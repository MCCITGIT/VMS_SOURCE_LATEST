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
Imports NPOI.SS.Util
Imports System.Configuration
Partial Class VendorReleaseReconciliation
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page_Load Event"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateUnit()
            PopulateDepot()
            ddlStatus.SelectedValue = "Due"
            ddltype.SelectedValue = "Depot Despatch"
            'Get values from previous page
            Dim vendorCode As String = Request.QueryString("vendorCode")
            Dim fromDate As String = Request.QueryString("fromDate")
            Dim toDate As String = Request.QueryString("toDate")
            SelectedFlag = Request.QueryString("flag")

            'Set date filters
            If Not String.IsNullOrEmpty(fromDate) Then
                txtFromDate.Text = fromDate
            End If

            If Not String.IsNullOrEmpty(toDate) Then
                txtTodate.Text = toDate
            End If

            'Set Unit/Vendor if passed
            If Not String.IsNullOrEmpty(vendorCode) Then
                If ddlUnit.Items.FindByValue(vendorCode) IsNot Nothing Then
                    ddlUnit.SelectedValue = vendorCode
                End If
            End If

            'Disable filters when opened from dashboard
            If Not String.IsNullOrEmpty(vendorCode) Then

                DisableFilterControls()

            End If

            gvVendorInvoiceDtls.PageIndex = 0
            BindGrid()
        End If
    End Sub

    Private Property SelectedFlag As String
        Get
            Return If(ViewState("SelectedFlag"), String.Empty)
        End Get
        Set(value As String)
            ViewState("SelectedFlag") = value
        End Set
    End Property

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
    'Modified-by MUKESH BHAGAT on 28-09-2026 : FromDate/ToDate parsing used to happen BEFORE the
    'Try block, and the Catch below did Server.Transfer("~/ExceptionPage.aspx"). Search
    '(ImgbtnSearch) and paging both fire as ASYNC postbacks (UpdatePanel1) - an unhandled
    'FormatException, or a full HTML page sent back via Server.Transfer, both break the MS AJAX
    'partial-postback response ("the message received from the server could not be parsed").
    'Once that happens PageRequestManager gets stuck thinking a request is still in flight, and
    'silently ignores every further async click on the page - Search again, paging, even the
    'in-page Back button (btnBack) - until a full page reload. This is why editing the date and
    'searching again "did nothing": a bad/unparseable date (or any other error) was crashing the
    'first attempt, and everything after it went nowhere.
    'Now: date parsing is inside the Try, a bad date shows a plain message via lblErrorMessage
    'instead of throwing, and any other error also shows inline instead of transferring to a full
    'page mid-async-postback.
    'Modified-by MUKESH BHAGAT on 01-10-2026 : pulled out of BindGrid so the Excel download
    '(btndownload_Click) fetches exactly the same data the grid is showing - same SP, same
    'SelectedFlag branch, same filters - instead of duplicating this branching a second time.
    'Also sets lblPanelTitle, same as before.
    Private Function GetCurrentListDataSet(ByVal fromDate As SqlDateTime, ByVal toDate As SqlDateTime, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Dim obj As New POLinkingRequestClass
        Dim ds As New DataSet
        If SelectedFlag = "GRNNOTDONE" Then
            lblPanelTitle.Text = "Grn Not Done List"
            ds = obj.GetGrnNotDoneList(ddlUnit.SelectedValue, fromDate, toDate, pageNo, pageSize)
        ElseIf SelectedFlag = "MANUALGRN" Then
            lblPanelTitle.Text = "Manual Grn List"
            ds = obj.GetManualGrnList(ddlUnit.SelectedValue, fromDate, toDate, pageNo, pageSize)
        ElseIf SelectedFlag = "PAID" Then
            lblPanelTitle.Text = "Payment List"
            ds = obj.GetInvPaymentList(ddlUnit.SelectedValue, fromDate, toDate, pageNo, pageSize)
        ElseIf SelectedFlag = "DISPATCHED" Then
            lblPanelTitle.Text = "Dispatched List"
            ds = obj.GetDispatchList(ddlUnit.SelectedValue, fromDate, toDate, pageNo, pageSize)
        ElseIf SelectedFlag = "DELIVERED" Then
            lblPanelTitle.Text = "Delivered List"
            ds = obj.GetDeliveredList(ddlUnit.SelectedValue, fromDate, toDate, pageNo, pageSize)
        End If
        Return ds
    End Function

    'Returns a friendly validation message, or empty if the dates are fine. Shared by BindGrid and
    'the Excel download so both fail the same way on a bad date.
    Private Function TryGetSearchDates(ByRef fromDate As SqlDateTime, ByRef toDate As SqlDateTime) As String
        Try
            fromDate = FormatDate(txtFromDate.Text)
            toDate = FormatDate(txtTodate.Text)
            Return String.Empty
        Catch fx As FormatException
            Return "Please enter a valid From Date / To Date (dd/mm/yyyy)."
        End Try
    End Function

    Private Sub BindGrid()
        CheckLogin()
        lblErrorMessage.Text = String.Empty
        Try
            Dim FromDate As SqlDateTime
            Dim ToDate As SqlDateTime
            Dim dateError As String = TryGetSearchDates(FromDate, ToDate)
            If dateError <> "" Then
                lblErrorMessage.Text = dateError
                gvVendorInvoiceDtls.DataSource = Nothing
                gvVendorInvoiceDtls.DataBind()
                Return
            End If

            Dim pageNo = gvVendorInvoiceDtls.PageIndex + 1
            Dim pageSize = gvVendorInvoiceDtls.PageSize

            If Not String.IsNullOrEmpty(SelectedFlag) Then
                Dim ds As DataSet = GetCurrentListDataSet(FromDate, ToDate, pageNo, pageSize)
                Dim totalRecords As Integer = 0

                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    gvVendorInvoiceDtls.DataSource = ds.Tables(0)
                    gvVendorInvoiceDtls.DataBind()
                    If ds.Tables.Count > 1 AndAlso ds.Tables(1).Rows.Count > 0 Then
                        totalRecords = Convert.ToInt32(ds.Tables(1).Rows(0)("total_records"))
                    End If
                    BindPager(totalRecords)
                Else
                    gvVendorInvoiceDtls.DataSource = Nothing
                    gvVendorInvoiceDtls.DataBind()
                End If
            Else
                gvVendorInvoiceDtls.DataSource = Nothing
                gvVendorInvoiceDtls.DataBind()
            End If
        Catch ex As Exception
            'Modified-by MUKESH BHAGAT on 28-09-2026 : no Server.Transfer here any more - Search and
            'paging are async (UpdatePanel1); transferring to a full page mid-async-postback breaks
            'the MS AJAX response and wedges the client for every further click on this page (see
            'the note above BindGrid). Shown inline instead, same as every other message on this page.
            lblErrorMessage.Text = Constant.ErrorMessages.GeneralError
            gvVendorInvoiceDtls.DataSource = Nothing
            gvVendorInvoiceDtls.DataBind()
        End Try
    End Sub

    Private Sub BindPager(ByVal totalRecords As Integer)

        'Dim totalPages As Integer = 0

        'If totalRecords > 0 Then
        '    totalPages = CInt(Math.Ceiling(totalRecords / gvVendorInvoiceDtls.PageSize))
        'End If

        'ddlPageNumber.Items.Clear()

        'For i As Integer = 1 To totalPages
        '    ddlPageNumber.Items.Add(
        '    New ListItem(i.ToString(), i.ToString())
        ')
        'Next

        'If totalPages > 0 Then
        '    ddlPageNumber.SelectedValue = (gvVendorInvoiceDtls.PageIndex + 1).ToString()
        'End If

        'lblTotalPages.Text = totalPages.ToString()

    End Sub

    'Modified-by MUKESH BHAGAT on 28-09-2026 : From Date / To Date were disabled here, so a user
    'who opened this page from a VprDashboard tile (Dispatched / Delivered / GRN Not Done /
    'Manual GRN / Paid) could not widen or move the date range - the dashboard's From/To were
    'locked in for good. The vendor itself (ddlUnit) and the Status/Depot/Type filters stay
    'locked, since those come from the tile that was clicked; only the dates - and Search, so a
    'changed date range can actually be applied - are left enabled.
    'Modified-by MUKESH BHAGAT on 01-10-2026 : btndownload is no longer hidden here - Excel
    'download now lives on this page (moved from VprDashboard.aspx) and must stay visible when
    'the page is opened from a dashboard tile, which is the main way users reach this page.
    Private Sub DisableFilterControls()

        'Disable dropdowns
        ddlUnit.Enabled = False
        divStatus.Visible = False
        divDepot.Visible = False
        divType.Visible = False

    End Sub
#End Region

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        gvVendorInvoiceDtls.PageIndex = 0
        BindGrid()
    End Sub

    Private Sub gvVendorInvoiceDtls_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVendorInvoiceDtls.PageIndexChanging
        gvVendorInvoiceDtls.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub

#Region "Date Format"
    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime
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
    '    If (e.Row.RowType = DataControlRowType.DataRow) Then
    '        Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
    '        If Not IsDBNull(rowView("InvoiceUploadDate")) AndAlso rowView("InvoiceUploadDate").ToString() <> String.Empty Then
    '            e.Row.BackColor = Drawing.Color.Empty
    '        Else
    '            e.Row.BackColor = Drawing.Color.Yellow
    '        End If
    '    End If
    'End Sub
    'Modified-by MUKESH BHAGAT on 01-10-2026 : moved here from VprDashboard.aspx (client wants the
    'Excel download on this detail page - Dispatched/Delivered/GRN Not Done/Manual GRN/Paid - not
    'on the dashboard). Rewritten to use the SAME data as the grid (GetCurrentListDataSet /
    'SelectedFlag), not the old GetVendorInvoice_ReleaseList_vr1 search, which never matched what
    'gvVendorInvoiceDtls actually shows (ddlStatus/ddltype/ddldepot are not read by BindGrid at all).
    Protected Sub btndownload_Click(sender As Object, e As EventArgs)
        CheckLogin()
        lblErrorMessage.Text = String.Empty
        Try
            Dim FromDate As SqlDateTime
            Dim ToDate As SqlDateTime
            Dim dateError As String = TryGetSearchDates(FromDate, ToDate)
            If dateError <> "" Then
                lblErrorMessage.Text = dateError
                Return
            End If

            If String.IsNullOrEmpty(SelectedFlag) Then Return

            'Full dataset - these SPs take no paging parameters and always return every matching row.
            Dim ds As DataSet = GetCurrentListDataSet(FromDate, ToDate, 1, Integer.MaxValue)
            If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing OrElse ds.Tables(0).Rows.Count = 0 Then
                lblErrorMessage.Text = "No data to export."
                Return
            End If

            Dim table As DataTable = ds.Tables(0).Copy()
            If Not table.Columns.Contains("ExportStatus") Then
                table.Columns.Add("ExportStatus", GetType(String))
            End If
            For Each row As DataRow In table.Rows
                'Same fallback logic as gvVendorInvoiceDtls_RowDataBound, so the exported Status
                'column always matches what's on screen.
                Dim status As String = String.Empty
                If table.Columns.Contains("status") Then
                    status = Convert.ToString(row("status"))
                End If
                If String.IsNullOrEmpty(status) Then
                    status = If(SelectedFlag = "PAID", "Paid", If(SelectedFlag = "DISPATCHED", "Dispatched", String.Empty))
                End If
                row("ExportStatus") = status
            Next

            Dim cols As New List(Of GridExcelExport.ExportColumn) From {
                New GridExcelExport.ExportColumn("S.No", Nothing, GridExcelExport.ColumnKind.SerialNo, 7),
                New GridExcelExport.ExportColumn("Depot", "depot_name", GridExcelExport.ColumnKind.Text, 20),
                New GridExcelExport.ExportColumn("Invoice No", "Invoice_No", GridExcelExport.ColumnKind.Text, 16),
                New GridExcelExport.ExportColumn("Invoice Date", "Invoice_Date", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("Invoice Value", "Invoice_Value", GridExcelExport.ColumnKind.Amount, 14),
                New GridExcelExport.ExportColumn("Release No", "Release_No", GridExcelExport.ColumnKind.Text, 16),
                New GridExcelExport.ExportColumn("Release Date", "Release_Date", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("GRN No", "GRN_No", GridExcelExport.ColumnKind.Text, 16),
                New GridExcelExport.ExportColumn("GRN Date", "GRN_Date", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("Voucher No", "Voucher_No", GridExcelExport.ColumnKind.Text, 16),
                New GridExcelExport.ExportColumn("Amount Paid", "Payment_Status", GridExcelExport.ColumnKind.Amount, 14),
                New GridExcelExport.ExportColumn("Amount Due", "PendingAmount", GridExcelExport.ColumnKind.Amount, 14),
                New GridExcelExport.ExportColumn("PO No", "po_number", GridExcelExport.ColumnKind.Text, 16),
                New GridExcelExport.ExportColumn("Rtv Qty", "rtv_qty", GridExcelExport.ColumnKind.Number, 10),
                New GridExcelExport.ExportColumn("Rtv Reason", "rtv_reason", GridExcelExport.ColumnKind.Text, 20),
                New GridExcelExport.ExportColumn("Deliver Qty", "deliver_qty", GridExcelExport.ColumnKind.Number, 12),
                New GridExcelExport.ExportColumn("Grn Status", "grn_status", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("Status", "ExportStatus", GridExcelExport.ColumnKind.Text, 16)
            }

            Dim filterLine As String = "From : " & txtFromDate.Text.Trim() & "   To : " & txtTodate.Text.Trim() &
                "   Unit : " & If(ddlUnit.SelectedItem Is Nothing, "", ddlUnit.SelectedItem.Text)

            'Modified-by MUKESH BHAGAT on 01-10-2026 : file name was hardcoded to
            '"Vendor_Release_Reconciliation" for every view, so Dispatched/Delivered/GRN Not
            'Done/Manual GRN/Paid all downloaded with the same file name. Now derived from
            'SelectedFlag so each view gets its own name.
            Dim fileBaseName As String = "Vendor_Release_Reconciliation_" &
                If(String.IsNullOrEmpty(SelectedFlag), "List", SelectedFlag)

            GridExcelExport.Export(table, cols, lblPanelTitle.Text, filterLine, userInfo.userCompanyEntity,
                                   fileBaseName, AppDomain.CurrentDomain.BaseDirectory, Response)
        Catch ex As Exception
            lblErrorMessage.Text = Constant.ErrorMessages.GeneralError
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
        fontRight.Color = HSSFColor.Black.Index
        fontRight.Boldweight = NPOI.SS.UserModel.FontBoldWeight.Normal
        fontRight.FontName = "Calibri"
        fontRight.FontHeightInPoints = 9
        fontRight.IsItalic = True

        Dim styleRight As ICellStyle = templateWorkbook.CreateCellStyle()
        styleRight.VerticalAlignment = VerticalAlignment.Center
        styleRight.Alignment = HorizontalAlignment.Right
        styleRight.SetFont(fontRight)

        Dim fontLeft As IFont = templateWorkbook.CreateFont()
        fontLeft.Color = HSSFColor.Black.Index
        fontLeft.Boldweight = NPOI.SS.UserModel.FontBoldWeight.Normal
        fontLeft.FontName = "Calibri"
        fontLeft.FontHeightInPoints = 9
        fontLeft.IsItalic = True

        Dim styleLeft As ICellStyle = templateWorkbook.CreateCellStyle()
        styleLeft.VerticalAlignment = VerticalAlignment.Center
        styleLeft.Alignment = HorizontalAlignment.Left
        styleLeft.SetFont(fontLeft)

        Dim fontCenter As IFont = templateWorkbook.CreateFont()
        fontCenter.Color = HSSFColor.Black.Index
        fontCenter.Boldweight = NPOI.SS.UserModel.FontBoldWeight.Normal
        fontCenter.FontName = "Calibri"
        fontCenter.FontHeightInPoints = 9
        fontCenter.IsItalic = True

        Dim styleCenter As ICellStyle = templateWorkbook.CreateCellStyle()
        styleCenter.VerticalAlignment = VerticalAlignment.Center
        styleCenter.Alignment = HorizontalAlignment.Center
        styleCenter.SetFont(fontCenter)

        Dim fontDate As IFont = templateWorkbook.CreateFont()
        fontDate.Color = HSSFColor.Black.Index
        fontDate.Boldweight = NPOI.SS.UserModel.FontBoldWeight.Normal
        fontDate.FontName = "Calibri"
        fontDate.FontHeightInPoints = 9
        fontDate.IsItalic = True

        Dim styleDate As ICellStyle = templateWorkbook.CreateCellStyle()
        styleDate.VerticalAlignment = VerticalAlignment.Center
        styleDate.Alignment = HorizontalAlignment.Center
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

    'Protected Sub ddlPageNumber_SelectedIndexChanged(sender As Object, e As EventArgs)
    '    gvVendorInvoiceDtls.PageIndex = Convert.ToInt32(ddlPageNumber.SelectedValue) - 1
    '    BindGrid()
    'End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("VprDashboard.aspx")
    End Sub

#Region "Cancelled by Vendor"
    'Modified-by MUKESH BHAGAT on 11-09-2026 : Dispatch List > Status column. Admin / HO mark a
    'release "Cancelled by Vendor" and attach the credit note (PDF). The flag is written on
    'despatch_hdr and the file recorded in vpr_vendor_cancellation_doc; the list SPs then show
    'the release under the Paid List with that status. Files are stored as <guid>.pdf under
    '<UPLOAD_DOCS>\<company>\Vendor_Cancellation_Docs\<dd_MM_yyyy>\ - same scheme as the invoice copy.

    Private Const CancelDocFolder As String = "Vendor_Cancellation_Docs"
    Private Const CancelledStatusText As String = "Cancelled by Vendor"

    Private Property CancelReleaseId As Integer
        Get
            Return If(ViewState("CancelReleaseId"), 0)
        End Get
        Set(value As Integer)
            ViewState("CancelReleaseId") = value
        End Set
    End Property

    Private Property CancelInvoiceNo As String
        Get
            Return If(ViewState("CancelInvoiceNo"), String.Empty)
        End Get
        Set(value As String)
            ViewState("CancelInvoiceNo") = value
        End Set
    End Property

    Private Property CancelInvoiceDate As String
        Get
            Return If(ViewState("CancelInvoiceDate"), String.Empty)
        End Get
        Set(value As String)
            ViewState("CancelInvoiceDate") = value
        End Set
    End Property

    Private Property CancelInvoiceValue As String
        Get
            Return If(ViewState("CancelInvoiceValue"), String.Empty)
        End Get
        Set(value As String)
            ViewState("CancelInvoiceValue") = value
        End Set
    End Property

    'Modified-by MUKESH BHAGAT on 28-09-2026 : explicit user-id deny-list, checked before the
    'group check below. These two named logins (both HO-MARKETING) must NOT get the "Cancelled
    'by Vendor" action, although their group otherwise has it - everything else on this page and
    'every other HO-MARKETING screen/data access is unaffected; only this one action is blocked
    'for them. Add / remove usp_user_id values here as business asks for named exceptions.
    Private Shared ReadOnly CancellationDeniedUserIds As String() = {"14563", "14564"}

    'Only Admin and HO users may mark / undo a cancellation - except the named exceptions above,
    'who are blocked regardless of group. Everyone can see the status and download the documents.
    Private Function CanManageCancellation() As Boolean
        Dim userId As String = Convert.ToString(userInfo.userIDEntity).Trim()
        If CancellationDeniedUserIds.Contains(userId) Then
            Return False
        End If

        Dim g As String = Convert.ToString(userInfo.userGroupCodeEntity)
        Return g = Constant.UserFormAccess.SYSADMIN OrElse
               g = Constant.UserFormAccess.HO OrElse
               g = Constant.UserFormAccess.HOMARKETING OrElse
               g = Constant.UserFormAccess.HOACCOUNTS
    End Function

    'The vendor unit the list is showing. Opened from the dashboard ddlUnit is pre-selected and
    'locked; a UNIT login is locked to its own code. Cancellation needs a definite vendor.
    Private Function SelectedUnitCode() As String
        Return Convert.ToString(ddlUnit.SelectedValue).Trim()
    End Function

    Protected Sub gvVendorInvoiceDtls_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvVendorInvoiceDtls.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Exit Sub

        Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
        If rowView Is Nothing Then Exit Sub

        Dim lblStatus As Label = TryCast(e.Row.FindControl("lblRowStatus"), Label)
        Dim lnkMark As LinkButton = TryCast(e.Row.FindControl("lnkMarkCancelled"), LinkButton)
        Dim lnkDocs As LinkButton = TryCast(e.Row.FindControl("lnkViewDocs"), LinkButton)
        If lblStatus Is Nothing OrElse lnkMark Is Nothing OrElse lnkDocs Is Nothing Then Exit Sub

        'status comes from the patched SPs; before the patch fall back to the list type
        Dim status As String = String.Empty
        If rowView.Row.Table.Columns.Contains("status") Then
            status = Convert.ToString(rowView("status"))
        End If
        If String.IsNullOrEmpty(status) Then
            status = If(SelectedFlag = "PAID", "Paid", If(SelectedFlag = "DISPATCHED", "Dispatched", String.Empty))
        End If
        lblStatus.Text = status
        If String.Equals(status, CancelledStatusText, StringComparison.OrdinalIgnoreCase) Then
            lblStatus.CssClass = "d-block text-danger font-weight-bold"
        End If

        Dim releaseOk As Boolean = Not String.IsNullOrEmpty(Convert.ToString(rowView("desph_release_id")))

        lnkMark.Visible = SelectedFlag = "DISPATCHED" AndAlso releaseOk AndAlso CanManageCancellation() AndAlso
                          Not String.Equals(status, CancelledStatusText, StringComparison.OrdinalIgnoreCase)
        lnkDocs.Visible = String.Equals(status, CancelledStatusText, StringComparison.OrdinalIgnoreCase)
    End Sub

    Protected Sub gvVendorInvoiceDtls_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVendorInvoiceDtls.RowCommand
        If e.CommandName <> "MarkCancelled" AndAlso e.CommandName <> "ViewCancelDocs" Then Exit Sub

        Dim row As GridViewRow = TryCast(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
        If row Is Nothing Then Exit Sub

        Dim relId As Integer
        Integer.TryParse(CType(row.FindControl("hdnReleaseId"), HiddenField).Value, relId)
        If relId <= 0 Then Exit Sub

        CancelReleaseId = relId
        CancelInvoiceNo = CType(row.FindControl("hdnInvNo"), HiddenField).Value
        CancelInvoiceDate = CType(row.FindControl("hdnInvDate"), HiddenField).Value
        CancelInvoiceValue = CType(row.FindControl("hdnInvValue"), HiddenField).Value

        If e.CommandName = "MarkCancelled" Then
            If Not CanManageCancellation() Then Exit Sub
            ShowCancelPopup()
        Else
            ShowDocsPopup()
        End If
    End Sub

    Private Sub ShowCancelPopup()
        lblCancelReleaseId.Text = CancelReleaseId.ToString()
        lblCancelInvoiceNo.Text = CancelInvoiceNo
        txtCancelRemarks.Text = String.Empty
        lblCancelError.Text = String.Empty
        mpCancel.Show()
    End Sub

    Private Sub ShowDocsPopup()
        lblDocsReleaseId.Text = CancelReleaseId.ToString()
        lblDocsInvoiceNo.Text = CancelInvoiceNo
        lblDocsError.Text = String.Empty
        btnAddCancelDoc.Visible = CanManageCancellation()
        btnUndoCancel.Visible = CanManageCancellation()
        BindCancelDocs()
        mpDocs.Show()
    End Sub

    Private Sub BindCancelDocs()
        Dim obj As New POLinkingRequestClass
        Dim ds As DataSet = obj.GetVendorCancellationDocs(CancelReleaseId, SelectedUnitCode())
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            gvCancelDocs.DataSource = ds.Tables(0)
        Else
            gvCancelDocs.DataSource = Nothing
        End If
        gvCancelDocs.DataBind()
    End Sub

    Protected Sub btnAddCancelDoc_Click(sender As Object, e As EventArgs)
        If Not CanManageCancellation() Then Exit Sub
        ShowCancelPopup()
    End Sub

    'Full postback (PostBackTrigger) - saves the PDF and records the cancellation.
    Protected Sub btnSaveCancel_Click(sender As Object, e As EventArgs)
        CheckLogin()
        If Not CanManageCancellation() Then
            lblErrorMessage.Text = "You are not authorised to mark a cancellation."
            Exit Sub
        End If

        If CancelReleaseId <= 0 OrElse String.IsNullOrEmpty(SelectedUnitCode()) Then
            lblErrorMessage.Text = "Release / vendor not identified. Please open the row again."
            Exit Sub
        End If

        If Not fuCancelDoc.HasFile OrElse fuCancelDoc.PostedFile.ContentLength <= 0 Then
            lblCancelError.Text = "Please attach the credit note / supporting document (PDF)."
            ShowCancelPopup()
            Exit Sub
        End If

        Dim originalName As String = Path.GetFileName(fuCancelDoc.FileName)
        If Not String.Equals(Path.GetExtension(originalName), ".pdf", StringComparison.OrdinalIgnoreCase) Then
            lblCancelError.Text = "Only PDF files are accepted."
            ShowCancelPopup()
            Exit Sub
        End If

        Try
            'stored as <guid>.pdf so two vendors' files can never collide (same as the invoice copy)
            Dim uniqueName As String = System.Guid.NewGuid().ToString("N") & ".pdf"   ' System. prefix: NPOI.HSSF.Util also defines GUID
            Dim docPath As String = Format(Date.Now, "dd_MM_yyyy")
            Dim folder As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") &
                                   userInfo.userCompanyEntity & "\" & CancelDocFolder & "\" & docPath
            If Not Directory.Exists(folder) Then Directory.CreateDirectory(folder)

            Dim invDate As Object = Nothing
            Dim parsedDate As DateTime
            If DateTime.TryParse(CancelInvoiceDate, parsedDate) Then invDate = parsedDate

            Dim invValue As Object = Nothing
            Dim parsedValue As Decimal
            If Decimal.TryParse(CancelInvoiceValue, parsedValue) Then invValue = parsedValue

            Dim obj As New POLinkingRequestClass
            obj.InsertVendorCancellationDoc(CancelReleaseId, SelectedUnitCode(), Nothing,
                                            CancelInvoiceNo, invDate, invValue,
                                            txtCancelRemarks.Text.Trim(), "CREDIT_NOTE",
                                            uniqueName, originalName, docPath, userInfo.userIDEntity)

            'file is written only after the database row is in - a failed insert leaves no orphan file
            fuCancelDoc.PostedFile.SaveAs(Path.Combine(folder, uniqueName))

            lblErrorMessage.ForeColor = Drawing.Color.Green
            lblErrorMessage.Text = "Release " & CancelReleaseId & " (Invoice " & CancelInvoiceNo & ") marked '" & CancelledStatusText & "'. It is now listed under Paid."
            gvVendorInvoiceDtls.PageIndex = 0
            BindGrid()
        Catch ex As Exception
            lblCancelError.Text = "Could not save: " & ex.Message
            ShowCancelPopup()
        End Try
    End Sub

    Protected Sub btnUndoCancel_Click(sender As Object, e As EventArgs)
        CheckLogin()
        If Not CanManageCancellation() OrElse CancelReleaseId <= 0 Then Exit Sub
        Try
            Dim obj As New POLinkingRequestClass
            obj.DeactivateVendorCancellation(CancelReleaseId, SelectedUnitCode(), userInfo.userIDEntity)
            lblErrorMessage.ForeColor = Drawing.Color.Green
            lblErrorMessage.Text = "Cancellation of release " & CancelReleaseId & " undone. It is back in the Dispatch List."
            gvVendorInvoiceDtls.PageIndex = 0
            BindGrid()
        Catch ex As Exception
            lblDocsError.Text = "Could not undo: " & ex.Message
            ShowDocsPopup()
        End Try
    End Sub

    'Full postback (gvCancelDocs is a PostBackTrigger) - streams one attached PDF.
    Protected Sub gvCancelDocs_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCancelDocs.RowCommand
        If e.CommandName <> "DownloadCancelDoc" Then Exit Sub
        CheckLogin()

        Dim docId As Integer
        Integer.TryParse(Convert.ToString(e.CommandArgument), docId)
        If docId <= 0 Then Exit Sub

        Dim obj As New POLinkingRequestClass
        Dim ds As DataSet = obj.GetVendorCancellationDocs(CancelReleaseId, SelectedUnitCode())
        If ds Is Nothing OrElse ds.Tables.Count = 0 Then Exit Sub

        Dim rows() As DataRow = ds.Tables(0).Select("vcd_id = " & docId)
        If rows.Length = 0 Then Exit Sub

        Dim fullPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") &
                                 userInfo.userCompanyEntity & "\" & CancelDocFolder & "\" &
                                 Convert.ToString(rows(0)("vcd_doc_path")) & "\" & Convert.ToString(rows(0)("vcd_doc_file_name"))
        If Not File.Exists(fullPath) Then
            lblErrorMessage.Text = "Document not found on the server: " & Convert.ToString(rows(0)("vcd_doc_org_filename"))
            Exit Sub
        End If

        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AppendHeader("content-disposition", "attachment; filename=""" & Convert.ToString(rows(0)("vcd_doc_org_filename")) & """")
        Response.TransmitFile(fullPath)
        Response.Flush()
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub
#End Region
End Class
