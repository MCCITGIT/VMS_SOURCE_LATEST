Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Web.UI.WebControls
Imports VMS.Web
Imports System.Globalization
Imports NPOI.HSSF.UserModel
Imports NPOI.SS.UserModel
Imports NPOI.SS.Util
Imports NPOI.XSSF.UserModel

Partial Class RawMaterialPoEntry
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Dim DOC_ABS_PATH As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH")

    ' Must match rmph_ref_po_no varchar(20).
    Private Const RefPoNoMaxLength As Integer = 20

    ' Template layout (zero-based row indexes). Upload reads the same positions.
    Private Const TemplateSheetName As String = "PO Entry"
    Private Const TemplateListSheetName As String = "Lists"
    Private Const TemplateFileName As String = "RawMaterialPO_Template.xls"
    Private Const TemplateRowPoNo As Integer = 2
    Private Const TemplateRowSupplier As Integer = 3
    Private Const TemplateRowFreight As Integer = 4
    Private Const TemplateRowFreightGst As Integer = 5
    Private Const TemplateRowLineHeader As Integer = 7
    Private Const TemplateLineRows As Integer = 200
    Private Const TemplateProductHeader As String = "Product *"
    Private Const TemplateGstHeader As String = "GST % *"
    Private Const TemplateMaxErrorsShown As Integer = 10

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
            dt.Columns.Add("Gst", GetType(Decimal))
            dt.Columns.Add("GstAmount", GetType(Decimal))
            dt.Columns.Add("Amount", GetType(Decimal))

            ViewState("PoItems") = dt
        Else
            EnsurePoItemColumn(dt, "Gst")
            EnsurePoItemColumn(dt, "GstAmount")
        End If

        Return dt
    End Function

    Private Shared Sub EnsurePoItemColumn(ByVal dt As DataTable, ByVal columnName As String)
        If Not dt.Columns.Contains(columnName) Then
            dt.Columns.Add(columnName, GetType(Decimal))
        End If
    End Sub

    ' Line amount is quantity x rate plus GST on that line. Gst is the selected percent.
    Private Shared Sub FillProductAmounts(ByVal row As DataRow, ByVal qty As Decimal, ByVal rate As Decimal, ByVal gstPercent As Decimal)
        Dim basicAmount As Decimal = Math.Round(qty * rate, 2, MidpointRounding.AwayFromZero)
        Dim gstAmount As Decimal = Math.Round(basicAmount * gstPercent / 100D, 2, MidpointRounding.AwayFromZero)
        row("Qty") = qty
        row("Rate") = rate
        row("Gst") = gstPercent
        row("GstAmount") = gstAmount
        row("Amount") = basicAmount + gstAmount
    End Sub

    Private Sub BindPoItems()
        gvPoItems.DataSource = GetPoItems()
        gvPoItems.DataBind()
    End Sub

    Private Sub ClearFieldErrors()
        ddlVendor.CssClass = "form-control select2"
        txtProductSearch.CssClass = "form-control"
        txtQty.CssClass = "form-control"
        txtRate.CssClass = "form-control"
        ddlPrdGst.CssClass = "form-control select2"
        ddlGst.CssClass = "form-control select2"
        txtFreight.CssClass = "form-control"
        pnlPoGrid.CssClass = "table-responsive rm-grid-scroll"
        valVendor.Text = String.Empty
        valProduct.Text = String.Empty
        valQty.Text = String.Empty
        valRate.Text = String.Empty
        lblPrdGst.Text = String.Empty
        lblGst.Text = String.Empty
        lblFreight.Text = String.Empty
        valGrid.Text = String.Empty
        lblUploadMsg.Text = String.Empty
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

        Dim gstPercent As Decimal
        If Not Decimal.TryParse(ddlPrdGst.SelectedValue.Trim(),
                                NumberStyles.Number,
                                CultureInfo.InvariantCulture,
                                gstPercent) OrElse gstPercent < 0D Then
            SetFieldError(ddlPrdGst, lblPrdGst, "Please select GST.")
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
        FillProductAmounts(newRow, qty, rate, gstPercent)

        dt.Rows.Add(newRow)
        ViewState("PoItems") = dt

        BindPoItems()
        ClearFieldErrors()

        txtProductSearch.Text = String.Empty
        hdnProductCode.Value = String.Empty
        txtQty.Text = String.Empty
        txtRate.Text = String.Empty
        ddlPrdGst.ClearSelection()
        ddlPrdGst.SelectedIndex = 0
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

        Dim vendorCode As String = ddlVendor.SelectedValue.Trim()
        If String.IsNullOrWhiteSpace(vendorCode) Then
            SetFieldError(ddlVendor, valVendor, "Please select a vendor.")
            Return
        End If

        Dim freightGst As Nullable(Of Decimal) = Nothing
        If ddlGst.SelectedValue.Trim() <> "" Then
            Dim freightGstValue As Decimal
            If Not Decimal.TryParse(ddlGst.SelectedValue.Trim(),
                                    NumberStyles.Number,
                                    CultureInfo.InvariantCulture,
                                    freightGstValue) OrElse freightGstValue < 0D Then
                SetFieldError(ddlGst, lblGst, "Please select a valid GST.")
                Return
            End If
            freightGst = freightGstValue
        End If

        Dim freightCost As Decimal
        If Not Decimal.TryParse(txtFreight.Text.Trim(),
                                NumberStyles.Number,
                                CultureInfo.CurrentCulture,
                                freightCost) OrElse freightCost < 0D Then
            SetFieldError(txtFreight, lblFreight, "Please enter a valid freight.")
            Return
        End If

        Dim items As DataTable = GetPoItems()
        If items.Rows.Count = 0 Then
            SetGridError("Please add at least one product.")
            Return
        End If

        Dim refPoNo As String = hdnRefPoNo.Value.Trim()
        If refPoNo.Length > RefPoNoMaxLength Then
            SetGridError("PO No from the template cannot be longer than " & RefPoNoMaxLength & " characters.")
            Return
        End If

        Dim dt1 As New DataTable()
        dt1.Columns.Add("product_code", GetType(String))
        dt1.Columns.Add("qty", GetType(Decimal))
        dt1.Columns.Add("rate", GetType(Decimal))
        dt1.Columns.Add("amount", GetType(Decimal))
        dt1.Columns.Add("gst", GetType(Decimal))

        For Each row As DataRow In items.Rows
            If IsDBNull(row("Gst")) Then
                SetGridError("Please select GST for every product.")
                Return
            End If

            Dim dr1 As DataRow = dt1.NewRow()
            dr1("product_code") = Convert.ToString(row("ProductCode")).Trim()
            dr1("qty") = Convert.ToDecimal(row("Qty"))
            dr1("rate") = Convert.ToDecimal(row("Rate"))
            dr1("gst") = Convert.ToDecimal(row("Gst"))
            dr1("amount") = Convert.ToDecimal(row("Amount"))
            dt1.Rows.Add(dr1)
        Next
        dt1.AcceptChanges()

        Try
            Dim obj As New POLinkingRequestClass()
            Dim poNo As String = obj.InsertRawMaterialPo(userInfo.userIDEntity, vendorCode, userInfo.userIDEntity, dt1, freightGst, freightCost, refPoNo)

            If poNo <> "" Then
                ' PDF and popup show the user's PO No when given; DB lookups stay on the system PO No.
                Dim displayPoNo As String = If(refPoNo <> "", refPoNo, poNo)
                Dim vendorName As String = If(ddlVendor.SelectedItem Is Nothing, vendorCode, ddlVendor.SelectedItem.Text)
                Dim preparedBy As String = (Convert.ToString(userInfo.userFirstNameEntity) & " " & Convert.ToString(userInfo.userLastNameEntity)).Trim()
                If preparedBy = "" Then
                    preparedBy = userInfo.userIDEntity
                End If

                Dim safePoNo As String = displayPoNo
                For Each invalidChar As Char In Path.GetInvalidFileNameChars()
                    safePoNo = safePoNo.Replace(invalidChar, "_"c)
                Next
                Dim dateFolder As String = DateTime.Now.ToString("dd_MM_yyyy")
                Dim folder As String = Path.Combine(DOC_ABS_PATH, dateFolder)
                Dim fileName As String = Guid.NewGuid().ToString() & "_" & safePoNo & ".pdf"
                Dim pdfPath As String = Path.Combine(folder, fileName)
                Dim pdf As New PdfGenerator()
                Dim output As String = pdf.CreateRawMaterialPurchaseOrder(pdfPath, displayPoNo, DateTime.Now, vendorCode, vendorName, preparedBy, items, freightGst, freightCost)

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
                txtFreight.Text = String.Empty
                ddlPrdGst.ClearSelection()
                ddlPrdGst.SelectedIndex = 0
                ddlGst.ClearSelection()
                ddlGst.SelectedIndex = 0
                hdnRefPoNo.Value = String.Empty
                lblRefPoNo.Text = String.Empty
                lblPoSavedMessage.Text = "PO saved successfully."
                lblPoNo.Text = "Your PO No: " & HttpUtility.HtmlEncode(displayPoNo)
                mpePoSaved.Show()
            Else
                SetGridError("PO was not saved.")
            End If
        Catch ex As Exception
            SetGridError(HttpUtility.HtmlEncode(ex.Message))
        End Try
    End Sub

    Protected Sub btnDownloadTemplate_Click(sender As Object, e As EventArgs)
        Dim content As Byte()
        Using ms As New MemoryStream()
            BuildPoTemplate().Write(ms)
            content = ms.ToArray()
        End Using

        Response.Clear()
        Response.ContentType = "application/vnd.ms-excel"
        Response.AppendHeader("Content-Disposition", "attachment; filename=" & TemplateFileName)
        Response.BinaryWrite(content)
        Response.End()
    End Sub

    Protected Sub btnUploadTemplate_Click(sender As Object, e As EventArgs)
        ClearFieldErrors()

        If Not fuPoTemplate.HasFile Then
            ShowUploadMessage("Please choose the filled template to upload.", True)
            Return
        End If

        Dim ext As String = Path.GetExtension(fuPoTemplate.FileName).ToLowerInvariant()
        If ext <> ".xls" AndAlso ext <> ".xlsx" Then
            ShowUploadMessage("Only Excel files (.xls, .xlsx) can be uploaded.", True)
            Return
        End If

        Dim sheet As ISheet = Nothing
        Try
            Dim workbook As IWorkbook
            Using stream As Stream = fuPoTemplate.PostedFile.InputStream
                If ext = ".xlsx" Then
                    workbook = New XSSFWorkbook(stream)
                Else
                    workbook = New HSSFWorkbook(stream)
                End If
            End Using
            sheet = workbook.GetSheet(TemplateSheetName)
        Catch ex As Exception
            sheet = Nothing
        End Try

        If sheet Is Nothing OrElse
           Not String.Equals(GetCellText(sheet, TemplateRowLineHeader, 0), TemplateProductHeader, StringComparison.OrdinalIgnoreCase) OrElse
           Not String.Equals(GetCellText(sheet, TemplateRowLineHeader, 4), TemplateGstHeader, StringComparison.OrdinalIgnoreCase) Then
            ShowUploadMessage("This file is not the current Raw Material PO template. Please download the template, fill it and upload it again.", True)
            Return
        End If

        Dim errors As New List(Of String)()

        Dim refPoNo As String = GetCellText(sheet, TemplateRowPoNo, 1)
        If refPoNo.Length > RefPoNoMaxLength Then
            errors.Add("PO No cannot be longer than " & RefPoNoMaxLength & " characters.")
        End If

        Dim supplierText As String = GetCellText(sheet, TemplateRowSupplier, 1)
        Dim supplierItem As ListItem = Nothing
        If supplierText = "" Then
            errors.Add("Supplier is required.")
        Else
            supplierItem = FindListItem(ddlVendor, supplierText)
            If supplierItem Is Nothing Then
                errors.Add("Supplier '" & supplierText & "' was not found.")
            End If
        End If

        Dim freightText As String = GetCellText(sheet, TemplateRowFreight, 1)
        Dim freightCost As Decimal
        If freightText = "" Then
            errors.Add("Freight is required.")
        ElseIf Not TryParseAmount(freightText, freightCost) OrElse freightCost < 0D Then
            errors.Add("Freight must be a number of zero or more.")
        End If

        Dim freightGstText As String = GetCellText(sheet, TemplateRowFreightGst, 1)
        Dim freightGstItem As ListItem = Nothing
        If freightGstText <> "" AndAlso Not TryGetGstItem(freightGstText, ddlGst, freightGstItem) Then
            errors.Add("Freight GST '" & freightGstText & "' is not valid. Please select it from the list or leave it blank.")
        End If

        Dim codeByName As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
        Dim nameByCode As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
        For Each dr As DataRow In GetRawMaterialMaster().Rows
            Dim code As String = Convert.ToString(dr("Raw_Mat_Code")).Trim()
            Dim name As String = Convert.ToString(dr("Raw_Mat_Name")).Trim()
            If code = "" OrElse name = "" Then
                Continue For
            End If
            If Not codeByName.ContainsKey(name) Then
                codeByName.Add(name, code)
            End If
            If Not nameByCode.ContainsKey(code) Then
                nameByCode.Add(code, name)
            End If
        Next

        Dim items As DataTable = GetPoItems().Clone()
        For rowIndex As Integer = TemplateRowLineHeader + 1 To sheet.LastRowNum
            Dim productText As String = GetCellText(sheet, rowIndex, 0)
            Dim productCodeText As String = GetCellText(sheet, rowIndex, 1)
            Dim qtyText As String = GetCellText(sheet, rowIndex, 2)
            Dim rateText As String = GetCellText(sheet, rowIndex, 3)
            Dim gstText As String = GetCellText(sheet, rowIndex, 4)

            If productText = "" AndAlso qtyText = "" AndAlso rateText = "" AndAlso gstText = "" Then
                Continue For
            End If

            Dim excelRow As Integer = rowIndex + 1
            Dim productCode As String = String.Empty
            If productText <> "" AndAlso codeByName.ContainsKey(productText) Then
                productCode = codeByName(productText)
            ElseIf productCodeText <> "" AndAlso nameByCode.ContainsKey(productCodeText) Then
                productCode = productCodeText
            ElseIf productText <> "" AndAlso nameByCode.ContainsKey(productText) Then
                productCode = productText
            End If

            Dim qty As Decimal
            Dim rate As Decimal
            Dim gstItem As ListItem = Nothing
            Dim rowValid As Boolean = True

            If productCode = "" Then
                errors.Add("Row " & excelRow & ": " & If(productText = "", "Product is required.", "Product '" & productText & "' was not found."))
                rowValid = False
            End If
            If Not TryParseAmount(qtyText, qty) OrElse qty <= 0D Then
                errors.Add("Row " & excelRow & ": Quantity must be a number greater than zero.")
                rowValid = False
            End If
            If Not TryParseAmount(rateText, rate) OrElse rate < 0D Then
                errors.Add("Row " & excelRow & ": Rate must be a number of zero or more.")
                rowValid = False
            End If
            If gstText = "" Then
                errors.Add("Row " & excelRow & ": GST is required.")
                rowValid = False
            ElseIf Not TryGetGstItem(gstText, ddlPrdGst, gstItem) Then
                errors.Add("Row " & excelRow & ": GST '" & gstText & "' is not valid. Please select it from the list.")
                rowValid = False
            End If

            If rowValid Then
                Dim newRow As DataRow = items.NewRow()
                newRow("ProductCode") = productCode
                newRow("ProductName") = nameByCode(productCode)
                FillProductAmounts(newRow, qty, rate, Decimal.Parse(gstItem.Value, CultureInfo.InvariantCulture))
                items.Rows.Add(newRow)
            End If
        Next

        If errors.Count = 0 AndAlso items.Rows.Count = 0 Then
            errors.Add("Please add at least one product line in the template.")
        End If

        If errors.Count > 0 Then
            Dim shown As New List(Of String)()
            For Each message As String In errors
                If shown.Count = TemplateMaxErrorsShown Then
                    shown.Add("...and " & (errors.Count - TemplateMaxErrorsShown) & " more.")
                    Exit For
                End If
                shown.Add(HttpUtility.HtmlEncode(message))
            Next
            ShowUploadMessage("The template could not be loaded:<br />" & String.Join("<br />", shown), True)
            Return
        End If

        ddlVendor.ClearSelection()
        supplierItem.Selected = True
        txtFreight.Text = freightCost.ToString("0.##", CultureInfo.CurrentCulture)
        ddlGst.ClearSelection()
        If freightGstItem Is Nothing Then
            ddlGst.SelectedIndex = 0
        Else
            freightGstItem.Selected = True
        End If

        txtProductSearch.Text = String.Empty
        hdnProductCode.Value = String.Empty
        txtQty.Text = String.Empty
        txtRate.Text = String.Empty
        ddlPrdGst.ClearSelection()
        ddlPrdGst.SelectedIndex = 0

        ViewState("PoItems") = items
        BindPoItems()

        hdnRefPoNo.Value = refPoNo
        'lblRefPoNo.Text = If(refPoNo = "", String.Empty, "PO No: " & HttpUtility.HtmlEncode(refPoNo))

        ShowUploadMessage("Template loaded with " & items.Rows.Count & " product line(s). Please review the details and click Submit.", False)
    End Sub

    Private Sub ShowUploadMessage(ByVal message As String, ByVal isError As Boolean)
        lblUploadMsg.CssClass = If(isError, "dispatch-field-error", "po-upload-success")
        lblUploadMsg.Text = message
    End Sub

    Private Function GetRawMaterialMaster() As DataTable
        Dim ds As DataSet = New OPC_VendorClass().GetRawMaterial_SearchList(Nothing)
        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing Then
            Return New DataTable()
        End If
        Return ds.Tables(0)
    End Function

    Private Function BuildPoTemplate() As IWorkbook
        Dim workbook As New HSSFWorkbook()
        Dim sheet As HSSFSheet = CType(workbook.CreateSheet(TemplateSheetName), HSSFSheet)
        Dim lists As ISheet = workbook.CreateSheet(TemplateListSheetName)
        workbook.SetSheetHidden(workbook.GetSheetIndex(lists), True)

        Dim boldFont As IFont = workbook.CreateFont()
        boldFont.Boldweight = CShort(FontBoldWeight.Bold)
        Dim titleFont As IFont = workbook.CreateFont()
        titleFont.Boldweight = CShort(FontBoldWeight.Bold)
        titleFont.FontHeightInPoints = 14

        Dim titleStyle As ICellStyle = workbook.CreateCellStyle()
        titleStyle.SetFont(titleFont)
        Dim labelStyle As ICellStyle = workbook.CreateCellStyle()
        labelStyle.SetFont(boldFont)
        Dim headerStyle As ICellStyle = CreateBorderedStyle(workbook, IndexedColors.Grey25Percent.Index)
        headerStyle.SetFont(boldFont)
        Dim inputStyle As ICellStyle = CreateBorderedStyle(workbook, IndexedColors.LightYellow.Index)
        Dim textInputStyle As ICellStyle = CreateBorderedStyle(workbook, IndexedColors.LightYellow.Index)
        textInputStyle.DataFormat = workbook.CreateDataFormat().GetFormat("@")
        Dim autoStyle As ICellStyle = CreateBorderedStyle(workbook, IndexedColors.White.Index)

        ' Hidden "Lists" sheet: A/B = product name/code, D = supplier, F = GST.
        Dim products As DataTable = GetRawMaterialMaster()
        For i As Integer = 0 To products.Rows.Count - 1
            GetOrCreateCell(lists, i, 0).SetCellValue(Convert.ToString(products.Rows(i)("Raw_Mat_Name")).Trim())
            GetOrCreateCell(lists, i, 1).SetCellValue(Convert.ToString(products.Rows(i)("Raw_Mat_Code")).Trim())
        Next

        Dim supplierCount As Integer = 0
        For Each item As ListItem In ddlVendor.Items
            If item.Value <> "" Then
                GetOrCreateCell(lists, supplierCount, 3).SetCellValue(item.Text)
                supplierCount += 1
            End If
        Next

        Dim gstCount As Integer = 0
        For Each item As ListItem In ddlGst.Items
            If item.Value <> "" Then
                GetOrCreateCell(lists, gstCount, 5).SetCellValue(item.Value)
                gstCount += 1
            End If
        Next

        GetOrCreateCell(sheet, 0, 0).SetCellValue("Raw Material PO Entry - Upload Template")
        GetOrCreateCell(sheet, 0, 0).CellStyle = titleStyle
        GetOrCreateCell(sheet, 1, 0).SetCellValue("Fill the yellow cells, save the file and upload it on the Raw Material PO Entry page. Fields marked * are mandatory. Leave PO No blank to use the system generated PO No. GST % is required on every product line. Freight GST % is optional.")

        Dim headerLabels As String() = {"PO No (Optional)", "Supplier *", "Freight *", "Freight GST % (Optional)"}
        Dim headerRows As Integer() = {TemplateRowPoNo, TemplateRowSupplier, TemplateRowFreight, TemplateRowFreightGst}
        For i As Integer = 0 To headerRows.Length - 1
            Dim labelCell As ICell = GetOrCreateCell(sheet, headerRows(i), 0)
            labelCell.SetCellValue(headerLabels(i))
            labelCell.CellStyle = labelStyle
            GetOrCreateCell(sheet, headerRows(i), 1).CellStyle = If(headerRows(i) = TemplateRowPoNo, textInputStyle, inputStyle)
        Next

        Dim lineHeaders As String() = {TemplateProductHeader, "Product Code", "Quantity *", "Rate *", TemplateGstHeader}
        For col As Integer = 0 To lineHeaders.Length - 1
            Dim headerCell As ICell = GetOrCreateCell(sheet, TemplateRowLineHeader, col)
            headerCell.SetCellValue(lineHeaders(col))
            headerCell.CellStyle = headerStyle
        Next

        Dim firstLineRow As Integer = TemplateRowLineHeader + 1
        Dim lastLineRow As Integer = TemplateRowLineHeader + TemplateLineRows
        For rowIndex As Integer = firstLineRow To lastLineRow
            GetOrCreateCell(sheet, rowIndex, 0).CellStyle = inputStyle
            GetOrCreateCell(sheet, rowIndex, 2).CellStyle = inputStyle
            GetOrCreateCell(sheet, rowIndex, 3).CellStyle = inputStyle
            GetOrCreateCell(sheet, rowIndex, 4).CellStyle = inputStyle

            Dim codeCell As ICell = GetOrCreateCell(sheet, rowIndex, 1)
            codeCell.CellStyle = autoStyle
            If products.Rows.Count > 0 Then
                ' .xls (Excel 97-2003) does not support IFERROR, which shows as #NAME?.
                ' ISNA/VLOOKUP is valid in that format and still fills the product code.
                Dim excelRow As Integer = rowIndex + 1
                Dim lookupRange As String = String.Format("'{0}'!$A$1:$B${1}", TemplateListSheetName, products.Rows.Count)
                Dim lookupFormula As String = String.Format("VLOOKUP(A{0},{1},2,FALSE)", excelRow, lookupRange)
                codeCell.CellFormula = String.Format("IF(A{0}="""","""",IF(ISNA({1}),"""",{1}))", excelRow, lookupFormula)
            End If
        Next

        Dim dvHelper As New HSSFDataValidationHelper(sheet)
        If products.Rows.Count > 0 Then
            AddListName(workbook, "ProductList", "A", products.Rows.Count)
            AddValidation(sheet, dvHelper, DVConstraint.CreateFormulaListConstraint("ProductList"),
                          firstLineRow, lastLineRow, 0, "Invalid Product", "Please select a product from the list.")
        End If
        If supplierCount > 0 Then
            AddListName(workbook, "SupplierList", "D", supplierCount)
            AddValidation(sheet, dvHelper, DVConstraint.CreateFormulaListConstraint("SupplierList"),
                          TemplateRowSupplier, TemplateRowSupplier, 1, "Invalid Supplier", "Please select a supplier from the list.")
        End If
        If gstCount > 0 Then
            AddListName(workbook, "GstList", "F", gstCount)
            AddValidation(sheet, dvHelper, DVConstraint.CreateFormulaListConstraint("GstList"),
                          TemplateRowFreightGst, TemplateRowFreightGst, 1, "Invalid Freight GST", "Please select freight GST from the list, or leave it blank.")
            AddValidation(sheet, dvHelper, DVConstraint.CreateFormulaListConstraint("GstList"),
                          firstLineRow, lastLineRow, 4, "Invalid GST", "Please select GST from the list.")
        End If
        AddValidation(sheet, dvHelper, DVConstraint.CreateNumericConstraint(ValidationType.TEXT_LENGTH, OperatorType.LESS_OR_EQUAL, RefPoNoMaxLength.ToString(), Nothing),
                      TemplateRowPoNo, TemplateRowPoNo, 1, "Invalid PO No", "PO No cannot be longer than " & RefPoNoMaxLength & " characters.")
        AddValidation(sheet, dvHelper, DVConstraint.CreateNumericConstraint(ValidationType.DECIMAL, OperatorType.GREATER_OR_EQUAL, "0", Nothing),
                      TemplateRowFreight, TemplateRowFreight, 1, "Invalid Freight", "Freight must be a number of zero or more.")
        AddValidation(sheet, dvHelper, DVConstraint.CreateNumericConstraint(ValidationType.DECIMAL, OperatorType.GREATER_THAN, "0", Nothing),
                      firstLineRow, lastLineRow, 2, "Invalid Quantity", "Quantity must be a number greater than zero.")
        AddValidation(sheet, dvHelper, DVConstraint.CreateNumericConstraint(ValidationType.DECIMAL, OperatorType.GREATER_OR_EQUAL, "0", Nothing),
                      firstLineRow, lastLineRow, 3, "Invalid Rate", "Rate must be a number of zero or more.")

        sheet.SetColumnWidth(0, 70 * 256)
        sheet.SetColumnWidth(1, 22 * 256)
        sheet.SetColumnWidth(2, 14 * 256)
        sheet.SetColumnWidth(3, 14 * 256)
        sheet.SetColumnWidth(4, 14 * 256)
        sheet.CreateFreezePane(0, firstLineRow)

        Return workbook
    End Function

    Private Shared Function CreateBorderedStyle(ByVal workbook As IWorkbook, ByVal fillColor As Short) As ICellStyle
        Dim style As ICellStyle = workbook.CreateCellStyle()
        style.FillForegroundColor = fillColor
        style.FillPattern = FillPattern.SolidForeground
        style.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin
        style.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin
        style.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin
        style.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin
        Return style
    End Function

    Private Shared Sub AddListName(ByVal workbook As IWorkbook, ByVal name As String, ByVal column As String, ByVal count As Integer)
        Dim listName As IName = workbook.CreateName()
        listName.NameName = name
        listName.RefersToFormula = String.Format("'{0}'!${1}$1:${1}${2}", TemplateListSheetName, column, count)
    End Sub

    Private Shared Sub AddValidation(ByVal sheet As ISheet, ByVal dvHelper As IDataValidationHelper, ByVal constraint As IDataValidationConstraint,
                                     ByVal firstRow As Integer, ByVal lastRow As Integer, ByVal col As Integer,
                                     ByVal errorTitle As String, ByVal errorMessage As String)
        Dim validation As IDataValidation = dvHelper.CreateValidation(constraint, New CellRangeAddressList(firstRow, lastRow, col, col))
        validation.CreateErrorBox(errorTitle, errorMessage)
        validation.ShowErrorBox = True
        sheet.AddValidationData(validation)
    End Sub

    Private Shared Function GetOrCreateCell(ByVal sheet As ISheet, ByVal rowIndex As Integer, ByVal colIndex As Integer) As ICell
        Dim row As IRow = sheet.GetRow(rowIndex)
        If row Is Nothing Then
            row = sheet.CreateRow(rowIndex)
        End If
        Dim cell As ICell = row.GetCell(colIndex)
        If cell Is Nothing Then
            cell = row.CreateCell(colIndex)
        End If
        Return cell
    End Function

    Private Shared Function GetCellText(ByVal sheet As ISheet, ByVal rowIndex As Integer, ByVal colIndex As Integer) As String
        Dim row As IRow = sheet.GetRow(rowIndex)
        If row Is Nothing Then
            Return String.Empty
        End If

        Dim cell As ICell = row.GetCell(colIndex)
        If cell Is Nothing Then
            Return String.Empty
        End If

        Dim valueType As CellType = cell.CellType
        If valueType = CellType.Formula Then
            valueType = cell.CachedFormulaResultType
        End If

        Select Case valueType
            Case CellType.String
                Return cell.StringCellValue.Trim()
            Case CellType.Numeric
                Return cell.NumericCellValue.ToString(CultureInfo.InvariantCulture)
            Case CellType.Boolean
                Return cell.BooleanCellValue.ToString()
            Case Else
                Return String.Empty
        End Select
    End Function

    Private Shared Function TryParseAmount(ByVal text As String, ByRef value As Decimal) As Boolean
        Return Decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, value) OrElse
               Decimal.TryParse(text, NumberStyles.Number, CultureInfo.CurrentCulture, value)
    End Function

    Private Shared Function TryGetGstItem(ByVal rawText As String, ByVal list As DropDownList, ByRef gstItem As ListItem) As Boolean
        gstItem = Nothing
        Dim gstText As String = rawText.Replace("%", "").Trim()
        Dim gstValue As Decimal
        If gstText = "" OrElse Not TryParseAmount(gstText, gstValue) Then
            Return False
        End If
        gstItem = FindListItem(list, gstValue.ToString("0.##", CultureInfo.InvariantCulture))
        Return gstItem IsNot Nothing
    End Function

    Private Shared Function FindListItem(ByVal list As DropDownList, ByVal text As String) As ListItem
        For Each item As ListItem In list.Items
            If item.Value = "" Then
                Continue For
            End If
            If String.Equals(item.Text.Trim(), text, StringComparison.OrdinalIgnoreCase) OrElse
               String.Equals(item.Value.Trim(), text, StringComparison.OrdinalIgnoreCase) Then
                Return item
            End If
        Next
        Return Nothing
    End Function

    Protected Sub btnPoSavedOk_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntryList.aspx")
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntryList.aspx")
    End Sub
End Class
