Imports System.Data
Imports System.IO
Imports VMS.Web

''' <summary>
''' Author: MUKESH BHAGAT  Created: 13-11-2026
''' Head office page: review the invoices vendors uploaded for challans saved without one. Each upload is mapped to its challan
''' (existing document insert, through cir_map) or rejected with a reason - both by hand, nothing is automatic.
''' </summary>
Partial Class MissingInvoiceReview
    Inherits System.Web.UI.Page

    Private userInfo As VMSUserEntity = New VMSUserEntity()

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

    'Head office only. A vendor (UNIT) user must not review or map anything even if they reach the URL.
    Private Function IsHeadOffice() As Boolean
        Return Not String.Equals(Convert.ToString(userInfo.userGroupCodeEntity), "UNIT", StringComparison.OrdinalIgnoreCase)
    End Function

    Private Sub BindGrid()
        If Not IsHeadOffice() Then
            gvReview.DataSource = Nothing
            gvReview.DataBind()
            ShowMessage("This page is for head office users. Vendors use the Upload Missing Invoice page.", False)
            Return
        End If
        Try
            Dim ds As DataSet = New MissingInvoiceClass().GetReview(ddlStatus.SelectedValue, txtUnit.Text.Trim())
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                gvReview.DataSource = ds.Tables(0)
            Else
                gvReview.DataSource = Nothing
            End If
            gvReview.DataBind()
        Catch ex As Exception
            ShowMessage(FailText("The list could not be loaded.", ex), False)
        End Try
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSearch.Click
        CheckLogin()
        BindGrid()
    End Sub

    Protected Sub gvReview_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvReview.RowCommand
        If e.CommandName <> "ViewFile" AndAlso e.CommandName <> "MapUpload" AndAlso e.CommandName <> "RejectUpload" Then Return
        CheckLogin()
        If Not IsHeadOffice() Then
            ShowMessage("This page is for head office users.", False)
            Return
        End If
        Try
            Dim row As GridViewRow = gvReview.Rows(Convert.ToInt32(e.CommandArgument))
            Dim cirId As Integer
            If Not Integer.TryParse(CType(row.FindControl("hdnCirId"), HiddenField).Value, cirId) Then
                ShowMessage("The upload could not be identified. Please search again.", False) : Return
            End If

            Select Case e.CommandName
                Case "ViewFile"
                    DownloadStaged(CType(row.FindControl("hdnPath"), HiddenField).Value, CType(row.FindControl("hdnFile"), HiddenField).Value)

                Case "MapUpload"
                    Dim msg As String = String.Empty
                    Dim ok As Boolean = MissingInvoiceClass.ReadResult(New MissingInvoiceClass().MapUpload(cirId, userInfo.userIDEntity), msg)
                    ShowMessage(msg, ok)
                    BindGrid()

                Case "RejectUpload"
                    Dim reason As String = CType(row.FindControl("txtReason"), TextBox).Text.Trim()
                    If reason = "" Then ShowMessage("Please type the reason for rejecting.", False) : Return
                    Dim msg As String = String.Empty
                    Dim ok As Boolean = MissingInvoiceClass.ReadResult(New MissingInvoiceClass().RejectUpload(cirId, userInfo.userIDEntity, reason), msg)
                    ShowMessage(msg, ok)
                    BindGrid()
            End Select
        Catch ex As Threading.ThreadAbortException
            Throw
        Catch ex As Exception
            ShowMessage(FailText("The action could not be completed.", ex), False)
        End Try
    End Sub

    'Streams the staged PDF. The folder and file name come from our own table, but are still checked for path characters.
    Private Sub DownloadStaged(ByVal docPath As String, ByVal fileName As String)
        If String.IsNullOrEmpty(docPath) OrElse String.IsNullOrEmpty(fileName) OrElse
           docPath.IndexOfAny(New Char() {"\"c, "/"c}) >= 0 OrElse fileName.IndexOfAny(New Char() {"\"c, "/"c}) >= 0 OrElse
           docPath.Contains("..") OrElse fileName.Contains("..") Then
            ShowMessage("The file name or folder is not valid.", False)
            Return
        End If
        Dim fullPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\" & docPath & "\" & fileName
        If Not File.Exists(fullPath) Then
            ShowMessage("The uploaded file is not on the server.", False)
            Return
        End If
        Response.Clear()
        Response.ClearHeaders()
        Response.Buffer = True
        Response.Charset = ""
        Response.ContentType = "application/pdf"
        Response.AppendHeader("Content-Disposition", "attachment; filename=""" & fileName & """")
        Response.AppendHeader("Content-Length", New FileInfo(fullPath).Length.ToString())
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.TransmitFile(fullPath)
        Response.Flush()
        Response.SuppressContent = True
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    Private Sub ShowMessage(ByVal text As String, ByVal ok As Boolean)
        lblMessage.Text = "<div class='alert " & If(ok, "alert-success", "alert-danger") & "'>" & Server.HtmlEncode(text) & "</div>"
    End Sub

    Private Function FailText(ByVal prefix As String, ByVal ex As Exception) As String
        Dim t As String = prefix & " Nothing was changed - please try again. If it keeps happening, contact support."
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.IsDebuggingEnabled AndAlso ex IsNot Nothing Then
            t &= " [" & ex.GetType().Name & ": " & ex.Message & "]"
        End If
        Return t
    End Function
End Class
