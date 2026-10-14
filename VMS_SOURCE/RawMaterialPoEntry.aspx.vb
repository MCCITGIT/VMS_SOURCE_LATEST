Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Web.UI.WebControls
Imports VMS.Web
Imports System.Globalization

Partial Class RawMaterialPoEntry
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Dim DOC_ABS_PATH As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH")

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()

        If Not IsPostBack Then
            PopulateVendorList()
        End If
        BindPoItems()
    End Sub
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateVendorList()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetRawMaterialVendorList()

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function RawMaterialSearch(ByVal prefixText As String) As String()
        Dim rawMaterialDetails As List(Of String) = New List(Of String)()

        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 Then
            Return rawMaterialDetails.ToArray()
        End If

        Try
            Dim obj As New OPC_VendorClass()
            Dim searchText As String = prefixText.Trim()
            Dim ds As DataSet = obj.GetRawMaterial_SearchList(prefixText)

            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso Not ds.Tables(0) Is Nothing Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim rawMaterialId As String = Convert.ToString(dr("Raw_Mat_Code")).Trim()
                    Dim rawMaterialName As String = Convert.ToString(dr("Raw_Mat_Name")).Trim()

                    If rawMaterialName <> "" AndAlso rawMaterialId <> "" Then
                        rawMaterialDetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(rawMaterialName, rawMaterialId))
                    End If
                Next
            End If
        Catch ex As Exception
            ' Keep autocomplete resilient; return whatever is already collected.
        End Try

        Return rawMaterialDetails.ToArray()
    End Function

    Private Function GetPoItems() As DataTable
        Dim dt As DataTable = TryCast(ViewState("PoItems"), DataTable)

        If dt Is Nothing Then
            dt = New DataTable()
            dt.Columns.Add("ProductCode", GetType(String))
            dt.Columns.Add("ProductName", GetType(String))
            dt.Columns.Add("Qty", GetType(Decimal))
            dt.Columns.Add("Rate", GetType(Decimal))
            dt.Columns.Add("Amount", GetType(Decimal))

            ViewState("PoItems") = dt
        End If

        Return dt
    End Function

    Private Sub BindPoItems()
        gvPoItems.DataSource = GetPoItems()
        gvPoItems.DataBind()
    End Sub

    Private Sub ClearFieldErrors()
        ddlVendor.CssClass = "form-control select2"
        txtProductSearch.CssClass = "form-control"
        txtQty.CssClass = "form-control"
        txtRate.CssClass = "form-control"
        pnlPoGrid.CssClass = "table-responsive rm-grid-scroll"
        valVendor.Text = String.Empty
        valProduct.Text = String.Empty
        valQty.Text = String.Empty
        valRate.Text = String.Empty
        valGrid.Text = String.Empty
    End Sub

    Private Sub SetFieldError(ByVal control As WebControl, ByVal messageLabel As Label, ByVal message As String)
        If control.CssClass.IndexOf("field-invalid", StringComparison.OrdinalIgnoreCase) < 0 Then
            control.CssClass = (control.CssClass & " field-invalid").Trim()
        End If
        messageLabel.Text = message
    End Sub

    Private Sub SetGridError(ByVal message As String)
        pnlPoGrid.CssClass = "table-responsive rm-grid-scroll po-grid-invalid"
        valGrid.Text = message
    End Sub

    Protected Sub ImgbtnAdd_Click(ByVal sender As Object, ByVal e As EventArgs)
        ClearFieldErrors()

        Dim productCode As String = hdnProductCode.Value.Trim()
        Dim productText As String = txtProductSearch.Text.Trim()
        Dim vendorCode As String = ddlVendor.SelectedValue
        Dim qty As Decimal
        Dim rate As Decimal

        If String.IsNullOrWhiteSpace(vendorCode) Then
            SetFieldError(ddlVendor, valVendor, "Please select a vendor.")
            Return
        End If

        If String.IsNullOrWhiteSpace(productCode) OrElse String.IsNullOrWhiteSpace(productText) Then
            SetFieldError(txtProductSearch, valProduct, "Please select a product.")
            Return
        End If

        If Not Decimal.TryParse(txtQty.Text.Trim(),
                                NumberStyles.Number,
                                CultureInfo.CurrentCulture,
                                qty) OrElse qty <= 0D Then
            SetFieldError(txtQty, valQty, "Please enter a quantity greater than zero.")
            Return
        End If

        If Not Decimal.TryParse(txtRate.Text.Trim(),
                                NumberStyles.Number,
                                CultureInfo.CurrentCulture,
                                rate) OrElse rate < 0D Then
            SetFieldError(txtRate, valRate, "Please enter a valid rate.")
            Return
        End If

        Dim productName As String = productText
        Dim productSuffix As String = " (" & productCode & ")"

        If productName.EndsWith(productSuffix, StringComparison.OrdinalIgnoreCase) Then
            productName = productName.Substring(0, productName.Length - productSuffix.Length).Trim()
        End If

        If productName.EndsWith(productSuffix, StringComparison.OrdinalIgnoreCase) Then
            productName = productName.Substring(0, productName.Length - productSuffix.Length).Trim()
        End If

        Dim dt As DataTable = GetPoItems()
        Dim newRow As DataRow = dt.NewRow()

        newRow("ProductCode") = productCode
        newRow("ProductName") = productName
        newRow("Qty") = qty
        newRow("Rate") = rate
        newRow("Amount") = qty * rate

        dt.Rows.Add(newRow)
        ViewState("PoItems") = dt

        BindPoItems()
        ClearFieldErrors()

        txtProductSearch.Text = String.Empty
        hdnProductCode.Value = String.Empty
        txtQty.Text = String.Empty
        txtRate.Text = String.Empty
    End Sub

    Protected Sub gvPoItems_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "RemoveItem" Then
            Dim rowIndex As Integer

            If Integer.TryParse(Convert.ToString(e.CommandArgument), rowIndex) Then
                Dim dt As DataTable = GetPoItems()

                If rowIndex >= 0 AndAlso rowIndex < dt.Rows.Count Then
                    dt.Rows.RemoveAt(rowIndex)
                    ViewState("PoItems") = dt
                End If
            End If

            BindPoItems()
        End If
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        ClearFieldErrors()

        Dim items As DataTable = GetPoItems()
        If items.Rows.Count = 0 Then
            SetGridError("Please add at least one product.")
            Return
        End If

        Dim vendorCode As String = ddlVendor.SelectedValue.Trim()
        If String.IsNullOrWhiteSpace(vendorCode) Then
            SetFieldError(ddlVendor, valVendor, "Please select a vendor.")
            Return
        End If

        Dim gstValue As Decimal = Convert.ToDecimal(ddlGst.SelectedValue.Trim())
        Dim freightCost As Decimal = Convert.ToDecimal(txtFreight.Text.Trim())

        Dim dt1 As New DataTable()
        dt1.Columns.Add("product_code", GetType(String))
        dt1.Columns.Add("qty", GetType(Decimal))
        dt1.Columns.Add("rate", GetType(Decimal))
        dt1.Columns.Add("amount", GetType(Decimal))

        For Each row As DataRow In items.Rows
            Dim dr1 As DataRow = dt1.NewRow()
            dr1("product_code") = Convert.ToString(row("ProductCode")).Trim()
            dr1("qty") = Convert.ToDecimal(row("Qty"))
            dr1("rate") = Convert.ToDecimal(row("Rate"))
            dr1("amount") = Convert.ToDecimal(row("Amount"))
            dt1.Rows.Add(dr1)
        Next
        dt1.AcceptChanges()

        Try
            Dim obj As New POLinkingRequestClass()
            Dim poNo As String = obj.InsertRawMaterialPo(userInfo.userIDEntity, vendorCode, userInfo.userIDEntity, dt1, gstValue, freightCost)

            If poNo <> "" Then
                Dim vendorName As String = If(ddlVendor.SelectedItem Is Nothing, vendorCode, ddlVendor.SelectedItem.Text)
                Dim preparedBy As String = (Convert.ToString(userInfo.userFirstNameEntity) & " " & Convert.ToString(userInfo.userLastNameEntity)).Trim()
                If preparedBy = "" Then
                    preparedBy = userInfo.userIDEntity
                End If

                Dim safePoNo As String = poNo
                For Each invalidChar As Char In Path.GetInvalidFileNameChars()
                    safePoNo = safePoNo.Replace(invalidChar, "_"c)
                Next
                Dim dateFolder As String = DateTime.Now.ToString("dd_MM_yyyy")
                Dim folder As String = Path.Combine(DOC_ABS_PATH, dateFolder)
                Dim fileName As String = Guid.NewGuid().ToString() & "_" & safePoNo & ".pdf"
                Dim pdfPath As String = Path.Combine(folder, fileName)
                Dim pdf As New PdfGenerator()
                'pdf.CreateRawMaterialPurchaseOrder(pdfPath, poNo, DateTime.Now, vendorCode, vendorName, preparedBy, items)
                Dim output As String = pdf.CreateRawMaterialPurchaseOrder(pdfPath, poNo, DateTime.Now, vendorCode, vendorName, preparedBy, items, gstValue, freightCost)

                Dim docFileName = Path.GetFileName(output)
                Dim docFolder = Path.GetDirectoryName(output)

                If Not (String.IsNullOrEmpty(output)) Then
                    obj.UpdatePoDocPath(docFolder, docFileName, poNo)
                    lnkPreviewPdf.NavigateUrl = "RawMaterialPoPdf.aspx?folder=" & Server.UrlEncode(dateFolder) & "&file=" & Server.UrlEncode(docFileName)
                    lnkPreviewPdf.Visible = True
                End If

                ViewState.Remove("PoItems")
                BindPoItems()
                ddlVendor.SelectedIndex = 0
                txtProductSearch.Text = String.Empty
                hdnProductCode.Value = String.Empty
                txtQty.Text = String.Empty
                txtRate.Text = String.Empty
                lblPoSavedMessage.Text = "PO saved successfully."
                lblPoNo.Text = "Your PO No: " & poNo
                mpePoSaved.Show()
            Else
                SetGridError("PO was not saved.")
            End If
        Catch ex As Exception
            SetGridError(ex.Message)
        End Try
    End Sub

    Protected Sub btnPoSavedOk_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntryList.aspx")
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntryList.aspx")
    End Sub
End Class
