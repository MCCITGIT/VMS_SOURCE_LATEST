Imports System.Data
Imports System.IO
Imports VMS.Web

''' <summary>
''' Author: MUKESH BHAGAT  Created: 13-11-2026
''' Vendor page: upload the invoice copy for challans that were saved without one. The upload is only staged
''' (challan_invoice_resubmit); head office maps it on MissingInvoiceReview.aspx. All checks the browser does are repeated here.
''' </summary>
Partial Class MissingInvoiceUpload
    Inherits System.Web.UI.Page

    Private userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const MaxBytes As Integer = 10 * 1024 * 1024

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then BindGrid()
    End Sub

    Private Sub CheckLogin()
        If Session(Constant.SessionKeys.UserInfo) IsNot Nothing Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    'Vendor users only. Head office reviews on MissingInvoiceReview.aspx. The unit always comes from the session, never from the page.
    Private Function IsVendor() As Boolean
        Return String.Equals(Convert.ToString(userInfo.userGroupCodeEntity), "UNIT", StringComparison.OrdinalIgnoreCase) AndAlso
               Not String.IsNullOrEmpty(Convert.ToString(userInfo.userBranchEntity))
    End Function

    Private Sub BindGrid()
        If Not IsVendor() Then
            gvMissing.DataSource = Nothing
            gvMissing.DataBind()
            ShowMessage("This page is for vendor (unit) users. Head office uses the Review Missing Invoice page.", False)
            Return
        End If
        Try
            Dim ds As DataSet = New MissingInvoiceClass().GetMissingChallans(userInfo.userBranchEntity)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                gvMissing.DataSource = ds.Tables(0)
            Else
                gvMissing.DataSource = Nothing
            End If
            gvMissing.DataBind()
        Catch ex As Exception
            ShowMessage(FailText("The list could not be loaded.", ex), False)
        End Try
    End Sub

    'Text of the Status column.
    Protected Function StatusText(ByVal status As Object, ByVal submittedOn As Object, ByVal remarks As Object) As String
        Dim s As String = Convert.ToString(status)
        Select Case s
            Case "PENDING" : Return "Submitted " & Convert.ToString(submittedOn) & " - waiting for head office"
            Case "REJECTED" : Return "Rejected: " & Convert.ToString(remarks) & " - please upload again"
            Case Else : Return "Invoice needed"
        End Select
    End Function

    Protected Sub gvMissing_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvMissing.RowCommand
        If e.CommandName <> "SubmitInvoice" Then Return
        CheckLogin()
        If Not IsVendor() Then
            ShowMessage("This page is for vendor (unit) users.", False)
            Return
        End If

        Dim savedPath As String = String.Empty
        Try
            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvMissing.Rows(idx)
            Dim challanNo As Integer
            If Not Integer.TryParse(CType(row.FindControl("hdnChallanNo"), HiddenField).Value, challanNo) Then
                ShowMessage("The challan could not be identified. Please refresh the page.", False) : Return
            End If
            Dim invNo As String = CType(row.FindControl("txtInvNo"), TextBox).Text.Trim()
            Dim invDateText As String = CType(row.FindControl("txtInvDate"), TextBox).Text.Trim()
            Dim fu As FileUpload = CType(row.FindControl("fuInvoice"), FileUpload)

            If invNo = "" Then ShowMessage("Please enter the Invoice No for challan " & challanNo & ".", False) : Return
            If invNo.Length > 100 Then ShowMessage("The Invoice No is too long (maximum 100 characters).", False) : Return

            Dim invDate As DateTime
            If Not DateTime.TryParseExact(invDateText, New String() {"yyyy-MM-dd", "dd/MM/yyyy", "d/M/yyyy"},
                                          System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, invDate) Then
                ShowMessage("Please enter a valid Invoice Date for challan " & challanNo & ".", False) : Return
            End If
            If invDate.Date > DateTime.Today Then ShowMessage("Invoice Date cannot be in the future.", False) : Return

            If Not fu.HasFile OrElse fu.PostedFile Is Nothing OrElse fu.PostedFile.ContentLength <= 0 Then
                ShowMessage("Please choose the invoice file (PDF) for challan " & challanNo & ". The file box is cleared if the page was refreshed.", False) : Return
            End If
            If fu.PostedFile.ContentLength > MaxBytes Then ShowMessage("The file is larger than 10 MB. Please upload a smaller PDF.", False) : Return
            Dim originalName As String = Path.GetFileName(fu.FileName)
            If Not String.Equals(Path.GetExtension(originalName), ".pdf", StringComparison.OrdinalIgnoreCase) Then
                ShowMessage("Only a PDF file can be uploaded.", False) : Return
            End If
            If Not LooksLikePdf(fu) Then ShowMessage("The chosen file is not a valid PDF.", False) : Return

            'Same folder scheme as the challan page, so that mapping only needs to add the document row (no file move):
            '<UPLOAD_DOCS_FOLDER_ABS_PATH>\<company>\Challan_Docs\<dd_MM_yyyy>\<unique stored name>
            Dim storedName As String = UploadFileName.SafeFileName(originalName, True)
            Dim dayFolder As String = Format(Date.Now, "dd_MM_yyyy")
            Dim folder As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\" & dayFolder
            If Not Directory.Exists(folder) Then Directory.CreateDirectory(folder)
            savedPath = folder & "\" & storedName
            fu.PostedFile.SaveAs(savedPath)

            Dim ds As DataSet = New MissingInvoiceClass().Submit(userInfo.userBranchEntity, challanNo, invNo, invDate, storedName, originalName, dayFolder, userInfo.userIDEntity)
            Dim msg As String = String.Empty
            If MissingInvoiceClass.ReadResult(ds, msg) Then
                savedPath = String.Empty          'staged: keep the file
                ShowMessage(msg & " (Challan " & challanNo & ")", True)
                BindGrid()
            Else
                ShowMessage(msg, False)           'the file written above is ours and unique - removed in the cleanup below
            End If
        Catch ex As Threading.ThreadAbortException
            Throw
        Catch ex As Exception
            ShowMessage(FailText("The invoice could not be submitted.", ex), False)
        Finally
            If savedPath <> String.Empty Then
                Try
                    If File.Exists(savedPath) Then File.Delete(savedPath)
                Catch
                End Try
            End If
        End Try
    End Sub

    'A real PDF starts with "%PDF-".
    Private Function LooksLikePdf(ByVal fu As FileUpload) As Boolean
        Try
            Dim head(4) As Byte
            Dim s As Stream = fu.PostedFile.InputStream
            s.Position = 0
            Dim n As Integer = s.Read(head, 0, 5)
            s.Position = 0
            Return n = 5 AndAlso head(0) = &H25 AndAlso head(1) = &H50 AndAlso head(2) = &H44 AndAlso head(3) = &H46 AndAlso head(4) = &H2D
        Catch
            Return False
        End Try
    End Function

    Private Sub ShowMessage(ByVal text As String, ByVal ok As Boolean)
        lblMessage.Text = "<div class='alert " & If(ok, "alert-success", "alert-danger") & "'>" & Server.HtmlEncode(text) & "</div>"
    End Sub

    'Generic text; the technical detail only when the site runs with compilation debug="true".
    Private Function FailText(ByVal prefix As String, ByVal ex As Exception) As String
        Dim t As String = prefix & " Nothing was changed - please try again. If it keeps happening, contact support."
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.IsDebuggingEnabled AndAlso ex IsNot Nothing Then
            t &= " [" & ex.GetType().Name & ": " & ex.Message & "]"
        End If
        Return t
    End Function
End Class
