Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports NPOI.SS.Formula.Functions
Imports NPOI.HSSF.UserModel
Imports NPOI.HSSF.Util
Imports NPOI.SS.UserModel
Imports System.Globalization
Imports System.IO
Imports System.Collections.Generic
Imports NPOI.SS.Util
Partial Class VendorInvoiceAc_ReleaseDtls
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page_Load Event"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateUnit()
            PopulateDepot()
            ddlStatus.SelectedValue = "Due"
            'PopulateStatus()
            'txtFromDate.Text = DateTime.Now.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString()
            'txtTodate.Text = DateTime.Now.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString()
            txtFromDate.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture())
            txtTodate.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture())

            gvVendorInvoiceDtls.PageIndex = 0
            BindGrid()
        End If
    End Sub
#End Region
#Region "Custom Method"
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#End Region
#Region "Populate Unit"
    Private Sub PopulateUnit()

        Dim UnitSet As New DataSet
        Dim StockObj As New UnitDespatchClass
        UnitSet = StockObj.GetUnit("", Constant.Common.ActiveStatus)

        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then

            ddlUnit.DataSource = UnitSet.Tables(0)
            ddlUnit.DataTextField = "unit_name"
            ddlUnit.DataValueField = "unit_code"
            ddlUnit.DataBind()
            ddlUnit.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlUnit.SelectedValue = userInfo.userBranchEntity
            ddlUnit.Enabled = False
        End If
    End Sub
#End Region
#Region "Populate Status"
    Private Sub PopulateStatus()

        Dim mstr As New Common
        Dim dsStatus As New DataSet
        Dim LovType As String = "VENDOR_INVOICE_TYPE"

        dsStatus = mstr.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)

        If (Not (dsStatus Is Nothing) AndAlso dsStatus.Tables.Count > 0 AndAlso Not (dsStatus.Tables(0) Is Nothing) AndAlso dsStatus.Tables(0).Rows.Count > 0) Then
            ddlStatus.DataSource = dsStatus.Tables(0)
            ddlStatus.DataTextField = "lov_value"
            ddlStatus.DataValueField = "lov_code"
            ddlStatus.DataBind()
            ddlStatus.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub
#End Region


#Region "Populate Depot"
    Private Sub PopulateDepot()

        Dim mstr As New Common
        Dim dsDepot As New DataSet

        dsDepot = mstr.Getdepotname(String.Empty)

        If (Not (dsDepot Is Nothing) AndAlso dsDepot.Tables.Count > 0 AndAlso Not (dsDepot.Tables(0) Is Nothing) AndAlso dsDepot.Tables(0).Rows.Count > 0) Then
            ddldepot.DataSource = dsDepot.Tables(0)
            ddldepot.DataTextField = "depot_name"
            ddldepot.DataValueField = "depot_code"
            ddldepot.DataBind()
            ddldepot.Items.Insert(0, New ListItem(Constant.Common.Selec, "", True))
        Else
            ddldepot.Items.Insert(0, New ListItem(Constant.Common.Selec, "", True))
        End If

        If (userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
            ddldepot.SelectedValue = userInfo.userBranchEntity
            ddldepot.Enabled = False
            'ElseIf (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS) Then
            'ddlDepot.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If

    End Sub
#End Region
#Region "BindGrid"
    Private Sub BindGrid()
        CheckLogin()
        Dim FromDate As SqlDateTime
        Dim ToDate As SqlDateTime
        FromDate = FormatDate(txtFromDate.Text)
        ToDate = FormatDate(txtTodate.Text)
        Try
            Dim obj As New VendorInvoice_ReleaseClass
            Dim ds As New DataSet
            ds = obj.GetVendorInvoice_ReleaseList_vr1(ddlUnit.SelectedValue, ddlStatus.SelectedValue, FromDate, ToDate, ddldepot.SelectedValue, ddltype.SelectedValue)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                gvVendorInvoiceDtls.PageIndex = 0
                gvVendorInvoiceDtls.DataSource = FirstInvoicePage(ds.Tables(0))
                gvVendorInvoiceDtls.DataBind()
                hdnVirHasData.Value = "1"
                hdnVirPageSize.Value = gvVendorInvoiceDtls.PageSize.ToString()
            Else
                gvVendorInvoiceDtls.DataSource = Nothing
                gvVendorInvoiceDtls.DataBind()
                hdnVirHasData.Value = "0"
            End If
            hdnVirVendor.Value = ddlUnit.SelectedValue
            hdnVirStatus.Value = ddlStatus.SelectedValue
            hdnVirFrom.Value = txtFromDate.Text
            hdnVirTo.Value = txtTodate.Text
            hdnVirDepot.Value = ddldepot.SelectedValue
            hdnVirType.Value = ddltype.SelectedValue
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region
    'Protected Sub ImgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles ImgbtnSearch.Click
    '    gvVendorInvoiceDtls.PageIndex = 0
    '    BindGrid()
    'End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        gvVendorInvoiceDtls.PageIndex = 0
        BindGrid()
    End Sub

    'Private Sub gvVendorInvoiceDtls_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVendorInvoiceDtls.PageIndexChanging
    '    gvVendorInvoiceDtls.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub

#Region "Date Format"
    Public Shared Function FormatDate(ByVal stringdate As String) As SqlDateTime
        'Modified-by MUKESH BHAGAT on 20-08-2026 : ported robust parser from UAT source (NEW had reverted to the old Split("/") version which fails on dd-MM-yyyy input)
        ' --- Original implementation (kept for reference) ---
        'If Not (stringdate = String.Empty) Then
        '    Dim ddate As String() = stringdate.Split("/")
        '    Dim arrlist As New ArrayList
        '    Dim index As Integer = 0
        '
        '    While index <= ddate.Length - 1
        '        arrlist.Add(ddate(index))
        '        System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        '    End While
        '    Dim dd As Integer = System.Convert.ToInt32(arrlist.Item(0))
        '    Dim mm As Integer = System.Convert.ToInt32(arrlist.Item(1))
        '    Dim yyyy As Integer = System.Convert.ToInt32(arrlist.Item(2))
        '
        '    Dim dt As DateTime = New DateTime(yyyy, mm, dd)
        '    dt = FormatDateTime(dt, DateFormat.LongDate)
        '
        '    Return dt
        'End If

        If String.IsNullOrWhiteSpace(stringdate) Then Return SqlDateTime.Null

        Dim raw As String = stringdate.Trim()
        ' UI uses dd/MM/yyyy; some clients submit dd-MM-yyyy — accept both separators.
        Dim formats() As String = {"dd/MM/yyyy", "d/M/yyyy", "dd-MM-yyyy", "d-M-yyyy"}

        Dim parsed As DateTime
        If Not DateTime.TryParseExact(raw, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, parsed) Then
            Throw New FormatException("Invalid date: " & raw)
        End If

        Return New SqlDateTime(parsed)
    End Function
#End Region
    'Protected Sub gvVendorInvoiceDtls_RowDataBound(sender As Object, e As GridViewRowEventArgs)
    '    If (e.Row.RowType = DataControlRowType.Pager) Then
    '        Dim row As TableRow = New TableRow
    '        row = e.Row.Controls(0).Controls(0).Controls(0)
    '        For Each cell As TableCell In row.Cells
    '            Dim lb As Control = cell.Controls(0)


    '            If (TypeOf (lb) Is Label) Then

    '                'CType(lb, Label).ForeColor = System.Drawing.Color.Red
    '                CType(lb, Label).CssClass = "lblpager"
    '                CType(lb, Label).Width = 20
    '                CType(lb, Label).Height = 15
    '                'set current pager

    '            ElseIf (TypeOf (lb) Is LinkButton) Then

    '                CType(lb, LinkButton).CssClass = "lnkpager"
    '                CType(lb, LinkButton).Width = 20
    '                CType(lb, LinkButton).Height = 15
    '                CType(lb, LinkButton).ForeColor = Drawing.Color.Black
    '            End If

    '        Next
    '    End If
    'End Sub
    Protected Sub gvVendorInvoiceDtls_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            If Not IsDBNull(rowView("InvoiceUploadDate")) AndAlso rowView("InvoiceUploadDate").ToString() <> String.Empty Then
                e.Row.BackColor = Drawing.Color.Empty
            Else
                e.Row.BackColor = Drawing.Color.Yellow
            End If
        End If
    End Sub
    Protected Sub btndownload_Click(sender As Object, e As EventArgs)
        CheckLogin()
        Dim FromDate As SqlDateTime
        Dim ToDate As SqlDateTime
        Dim obj As New VendorInvoice_ReleaseClass
        Dim ds As New DataSet
        Try
            FromDate = FormatDate(txtFromDate.Text)
            ToDate = FormatDate(txtTodate.Text)
            ds = obj.GetVendorInvoice_ReleaseList_vr1(ddlUnit.SelectedValue, ddlStatus.SelectedValue, FromDate, ToDate, ddldepot.SelectedValue, ddltype.SelectedValue)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    ExportToExcelSheet1(ds)
                End If
            End If
        Catch ex As Exception
            Dim MSG As String = ex.Message
        End Try
    End Sub
    Private Sub ExportToExcelSheet1(ByVal dset As DataSet)
        'Opening the Excel template...
        Dim fs As FileStream = New FileStream(AppDomain.CurrentDomain.BaseDirectory & "Templates\VendorInvoiceAccountRealeaseDetailReport.xls", FileMode.Open, FileAccess.Read)

        'Getting the complete workbook...
        Dim templateWorkbook As HSSFWorkbook = New HSSFWorkbook(fs, True)

        'Getting the worksheet by its name...
        Dim sheet As HSSFSheet = templateWorkbook.GetSheet("Invoice Details")

        Dim fontRight As IFont = templateWorkbook.CreateFont()
        fontRight.Color = HSSFColor.BLACK.index
        fontRight.Boldweight = NPOI.SS.UserModel.FontBoldWeight.NORMAL
        fontRight.FontName = "Calibri"
        fontRight.FontHeightInPoints = 9
        fontRight.IsItalic = True

        Dim styleRight As ICellStyle = templateWorkbook.CreateCellStyle()
        styleRight.VerticalAlignment = VerticalAlignment.CENTER
        styleRight.Alignment = HorizontalAlignment.RIGHT
        styleRight.SetFont(fontRight)

        Dim fontLeft As IFont = templateWorkbook.CreateFont()
        fontLeft.Color = HSSFColor.BLACK.index
        fontLeft.Boldweight = NPOI.SS.UserModel.FontBoldWeight.NORMAL
        fontLeft.FontName = "Calibri"
        fontLeft.FontHeightInPoints = 9
        fontLeft.IsItalic = True

        Dim styleLeft As ICellStyle = templateWorkbook.CreateCellStyle()
        styleLeft.VerticalAlignment = VerticalAlignment.CENTER
        styleLeft.Alignment = HorizontalAlignment.LEFT
        styleLeft.SetFont(fontLeft)

        Dim fontCenter As IFont = templateWorkbook.CreateFont()
        fontCenter.Color = HSSFColor.BLACK.index
        fontCenter.Boldweight = NPOI.SS.UserModel.FontBoldWeight.NORMAL
        fontCenter.FontName = "Calibri"
        fontCenter.FontHeightInPoints = 9
        fontCenter.IsItalic = True

        Dim styleCenter As ICellStyle = templateWorkbook.CreateCellStyle()
        styleCenter.VerticalAlignment = VerticalAlignment.CENTER
        styleCenter.Alignment = HorizontalAlignment.CENTER
        styleCenter.SetFont(fontCenter)

        Dim fontDate As IFont = templateWorkbook.CreateFont()
        fontDate.Color = HSSFColor.BLACK.index
        fontDate.Boldweight = NPOI.SS.UserModel.FontBoldWeight.NORMAL
        fontDate.FontName = "Calibri"
        fontDate.FontHeightInPoints = 9
        fontDate.IsItalic = True

        Dim styleDate As ICellStyle = templateWorkbook.CreateCellStyle()
        styleDate.VerticalAlignment = VerticalAlignment.CENTER
        styleDate.Alignment = HorizontalAlignment.CENTER
        'styleDate.BorderTop = NPOI.SS.UserModel.BorderStyle.THIN
        'styleDate.BorderRight = NPOI.SS.UserModel.BorderStyle.THIN
        'styleDate.BorderBottom = NPOI.SS.UserModel.BorderStyle.THIN
        'styleDate.BorderLeft = NPOI.SS.UserModel.BorderStyle.THIN
        Dim formatIdDate = HSSFDataFormat.GetBuiltinFormat("dd/MM/yyyy")

        If formatIdDate = -1 Then
            Dim newDataFormat = templateWorkbook.CreateDataFormat()
            styleDate.DataFormat = newDataFormat.GetFormat("dd/MM/yyyy")
        Else
            styleDate.DataFormat = formatIdDate
        End If
        styleDate.SetFont(fontDate)

        Dim RowIndex As Integer

        Dim row As HSSFRow
        Dim cell As HSSFCell

        Dim DateString As String = "_" & DateTime.Today.ToString("dd_MM_yyyy")

        row = sheet.GetRow(0)
        cell = row.GetCell(0)
        cell.SetCellValue("Report Date - " & DateTime.Today.ToString("dd/MM/yyyy"))

        row = sheet.GetRow(0)
        cell = row.GetCell(2)
        cell.SetCellValue("VENDOR INVOICE ACCOUNT REALEASE DETAILS REPORT - ( " & txtFromDate.Text.Trim() & " To " & txtTodate.Text.Trim() & " )")

        RowIndex = 2

        Dim dt As DataTable = dset.Tables(0)

        If dt.Rows.Count > 0 Then
            For i = 0 To dt.Rows.Count - 1

                row = sheet.CreateRow(RowIndex)

                cell = row.CreateCell(0)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("Type")))
                cell.CellStyle = styleCenter

                cell = row.CreateCell(1)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("depot_name")))
                cell.CellStyle = styleLeft

                cell = row.CreateCell(2)
                If dt.Rows(i)("InvoiceUploadDate") Is DBNull.Value Or Convert.ToString(dt.Rows(i)("InvoiceUploadDate")) = String.Empty Then
                    cell.SetCellValue(String.Empty)
                Else
                    cell.SetCellValue(dt.Rows(i)("InvoiceUploadDate"))
                End If
                cell.CellStyle = styleDate

                cell = row.CreateCell(3)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("Invoice_No")))
                cell.CellStyle = styleCenter

                cell = row.CreateCell(4)
                cell.SetCellValue(dt.Rows(i)("Invoice_Date"))
                cell.CellStyle = styleDate

                cell = row.CreateCell(5)
                cell.SetCellValue(Val(dt.Rows(i)("Invoice_Value")))
                cell.CellStyle = styleRight

                cell = row.CreateCell(6)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("Release_No")))
                cell.CellStyle = styleCenter

                cell = row.CreateCell(7)
                cell.SetCellValue(dt.Rows(i)("Release_Date"))
                cell.CellStyle = styleDate

                cell = row.CreateCell(8)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("GRN_No")))
                cell.CellStyle = styleCenter

                cell = row.CreateCell(9)
                cell.SetCellValue(dt.Rows(i)("GRN_Date"))
                cell.CellStyle = styleDate

                cell = row.CreateCell(10)
                cell.SetCellValue(Convert.ToString(dt.Rows(i)("Voucher_No")))
                cell.CellStyle = styleCenter

                cell = row.CreateCell(11)
                cell.SetCellValue(Val(dt.Rows(i)("Payment_Status")))
                cell.CellStyle = styleRight

                cell = row.CreateCell(12)
                cell.SetCellValue(Val(dt.Rows(i)("PendingAmount")))
                cell.CellStyle = styleRight

                cell = row.CreateCell(13)
                If Convert.ToString(dt.Rows(i)("ap_voucher")) = String.Empty Then
                    cell.SetCellValue(String.Empty)
                Else
                    cell.SetCellValue(Convert.ToString(dt.Rows(i)("ap_voucher")))
                End If
                cell.CellStyle = styleCenter

                cell = row.CreateCell(14)
                cell.SetCellValue(Val(dt.Rows(i)("product_volume")))
                cell.CellStyle = styleRight

                cell = row.CreateCell(15)
                If Convert.ToString(dt.Rows(i)("transpoter_name")) = String.Empty Then
                    cell.SetCellValue(String.Empty)
                Else
                    cell.SetCellValue(Convert.ToString(dt.Rows(i)("transpoter_name")))
                End If
                cell.CellStyle = styleLeft

                cell = row.CreateCell(16)
                If Convert.ToString(dt.Rows(i)("vechile_no")) = String.Empty Then
                    cell.SetCellValue(String.Empty)
                Else
                    cell.SetCellValue(Convert.ToString(dt.Rows(i)("vechile_no")))
                End If
                cell.CellStyle = styleCenter

                RowIndex = RowIndex + 1

            Next
        End If

        Dim genReportPath As String = AppDomain.CurrentDomain.BaseDirectory & "Excel_Reports\"

        If Not (Directory.Exists(genReportPath)) Then
            Directory.CreateDirectory(genReportPath)
        End If

        Dim file_name As String = "VendorInvoiceAccountRealeaseDetailReport" & DateString & ".xls"

        'Writing workbook's data stream to the root directory
        Dim fl As FileStream = New FileStream(genReportPath & file_name, FileMode.Create)
        templateWorkbook.Write(fl)
        fl.Close()
        Response.Clear()
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"
        Response.WriteFile(genReportPath & file_name)
        Response.AppendHeader("content-disposition", "attachment; filename=" & file_name)
    End Sub

    Private Function FirstInvoicePage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvVendorInvoiceDtls.PageSize
        If pageSize <= 0 Then pageSize = 10
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function GetMoreVendorInvoices(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal vendor As String, ByVal status As String, ByVal fromDate As String, ByVal toDate As String, ByVal depot As String, ByVal invoiceType As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 10
        If pageIndex < 0 Then pageIndex = 0
        If userInfo.userGroupCodeEntity = "UNIT" Then vendor = userInfo.userBranchEntity
        If userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT Then depot = userInfo.userBranchEntity
        Dim ds As DataSet = New VendorInvoice_ReleaseClass().GetVendorInvoice_ReleaseList_vr1(If(vendor, String.Empty), If(status, String.Empty), FormatDate(If(fromDate, String.Empty)), FormatDate(If(toDate, String.Empty)), If(depot, String.Empty), If(invoiceType, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                Dim despatchDate As String = Convert.ToString(dr("InvoiceUploadDate"))
                rows.Add(New With {
                    .type = Convert.ToString(dr("Type")),
                    .depot = Convert.ToString(dr("depot_name")),
                    .despatchDate = despatchDate,
                    .invoiceNo = Convert.ToString(dr("Invoice_No")),
                    .invoiceDate = Convert.ToString(dr("Invoice_Date")),
                    .invoiceValue = Convert.ToString(dr("Invoice_Value")),
                    .releaseNo = Convert.ToString(dr("Release_No")),
                    .releaseDate = Convert.ToString(dr("Release_Date")),
                    .grnNo = Convert.ToString(dr("GRN_No")),
                    .grnDate = Convert.ToString(dr("GRN_Date")),
                    .voucherNo = Convert.ToString(dr("Voucher_No")),
                    .amountPaid = Convert.ToString(dr("Payment_Status")),
                    .amountDue = Convert.ToString(dr("PendingAmount")),
                    .missingDespatch = String.IsNullOrEmpty(despatchDate)
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function
End Class
