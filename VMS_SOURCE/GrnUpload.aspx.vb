Imports System.Data
Imports System.Globalization
Imports System.IO
Imports NPOI.SS.UserModel
Imports NPOI.XSSF.UserModel
Imports VMS.Web

'=====================================================================================
'Author       : MUKESH BHAGAT
'Create date  : 04-11-2026
'Description  : HO uploads GRN No / GRN Date (Excel) for despatch releases that have no GRN number yet
'               (vendor_despatch_release_dtls.vdr_grn_no empty). Flow: download template -> fill GRN No and
'               GRN Date -> "Check file" (nothing saved) -> "Confirm and save". Valid rows are saved, rejected
'               rows are reported; every change is logged in vendor_grn_upload_log.
'               SPs: grn_upload_pending_list, grn_upload_apply.
'=====================================================================================
Partial Class GrnUpload
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Private Const SessLines As String = "GrnUpload_Lines"
    Private Const SessFile As String = "GrnUpload_File"
    Private Const SessResult As String = "GrnUpload_Result"
    Private Const GridRowCap As Integer = 300

    Private Const HdrKey As String = "Row Key (do not edit)"
    Private Const HdrGrnNo As String = "GRN No"
    Private Const HdrGrnDate As String = "GRN Date (dd/mm/yyyy)"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        If Not IsAllowed() Then
            pnlMain.Visible = False
            lblMessage.CssClass = "d-block mb-2 text-danger"
            lblMessage.Text = "You are not authorised to use this page. It is for HO users only."
            Return
        End If

        If Not IsPostBack Then
            ClearSession()
            PopulateVendor()
            PopulateDepot()
        End If
    End Sub

    'HO only. (The menu row is given to HO-ADMIN; SYSADMIN sees every menu.)
    Private Function IsAllowed() As Boolean
        Dim g As String = Convert.ToString(userInfo.userGroupCodeEntity)
        Return g = Constant.UserFormAccess.SYSADMIN OrElse g = Constant.UserFormAccess.HO OrElse
               g = Constant.UserFormAccess.HOACCOUNTS OrElse g = "HO-ADMIN"
    End Function

#Region "Filters"
    Private Sub PopulateVendor()
        Dim ds As DataSet = New UnitDespatchClass().GetUnit("", Constant.Common.ActiveStatus)
        ddlUnit.Items.Clear()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            ddlUnit.DataSource = ds.Tables(0)
            ddlUnit.DataTextField = "unit_name"
            ddlUnit.DataValueField = "unit_code"
            ddlUnit.DataBind()
        End If
        ddlUnit.Items.Insert(0, New ListItem("All", String.Empty))
    End Sub

    Private Sub PopulateDepot()
        Dim ds As DataSet = New Common().Getdepotname(String.Empty)
        ddlDepot.Items.Clear()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            ddlDepot.DataSource = ds.Tables(0)
            ddlDepot.DataTextField = "depot_name"
            ddlDepot.DataValueField = "depot_code"
            ddlDepot.DataBind()
        End If
        ddlDepot.Items.Insert(0, New ListItem("All", String.Empty))
    End Sub

    Private Function ParseFilterDate(ByVal text As String, ByRef value As Object) As Boolean
        value = DBNull.Value
        If String.IsNullOrWhiteSpace(text) Then Return True
        Dim d As DateTime
        If DateTime.TryParseExact(text.Trim(), New String() {"dd/MM/yyyy", "d/M/yyyy", "dd-MM-yyyy", "d-M-yyyy"}, CultureInfo.InvariantCulture, DateTimeStyles.None, d) Then
            value = d
            Return True
        End If
        Return False
    End Function
#End Region

#Region "Step 1 - template"
    Protected Sub btnTemplate_Click(sender As Object, e As EventArgs) Handles btnTemplate.Click
        If Not IsAllowed() Then Return
        Dim fromV As Object = Nothing, toV As Object = Nothing
        If Not ParseFilterDate(txtFromDate.Text, fromV) OrElse Not ParseFilterDate(txtToDate.Text, toV) Then
            ShowMessage("Please enter valid dates (dd/mm/yyyy).", False)
            Return
        End If

        Try
            Dim ds As DataSet = New POLinkingRequestClass().GetGrnUploadPendingList(ddlDepot.SelectedValue, ddlUnit.SelectedValue, If(fromV Is DBNull.Value, Nothing, fromV), If(toV Is DBNull.Value, Nothing, toV))
            If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
                ShowMessage("No release without a GRN number was found for these filters.", False)
                Return
            End If
            lblPendingCount.Text = ds.Tables(0).Rows.Count.ToString("N0") & " releases without a GRN number."
            WriteTemplate(ds.Tables(0))
        Catch ex As Threading.ThreadAbortException
            Throw
        Catch ex As Exception
            ShowMessage(Constant.ErrorMessages.GeneralError, False)
        End Try
    End Sub

    Private Sub WriteTemplate(ByVal dt As DataTable)
        Dim wb As New XSSFWorkbook()
        Dim sh As ISheet = wb.CreateSheet("GRN Upload")

        Dim fHead As IFont = wb.CreateFont()
        fHead.FontName = "Calibri" : fHead.FontHeightInPoints = 11 : fHead.Boldweight = CShort(FontBoldWeight.Bold)
        Dim stHead As ICellStyle = wb.CreateCellStyle()
        stHead.SetFont(fHead)
        stHead.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Grey25Percent.Index
        stHead.FillPattern = FillPattern.SolidForeground

        Dim stFill As ICellStyle = wb.CreateCellStyle()         'the two cells the client fills
        stFill.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.LightYellow.Index
        stFill.FillPattern = FillPattern.SolidForeground
        Dim stText As ICellStyle = wb.CreateCellStyle()
        stText.CloneStyleFrom(stFill)
        stText.DataFormat = wb.CreateDataFormat().GetFormat("@")
        Dim stDate As ICellStyle = wb.CreateCellStyle()
        stDate.CloneStyleFrom(stFill)
        stDate.DataFormat = wb.CreateDataFormat().GetFormat("dd/mm/yyyy")
        Dim stRelDate As ICellStyle = wb.CreateCellStyle()
        stRelDate.DataFormat = wb.CreateDataFormat().GetFormat("dd/mm/yyyy")

        Dim heads() As String = {HdrKey, "Vendor", "Depot", "Release ID", "Release No", "PO No", "Release Date", HdrGrnNo, HdrGrnDate}
        Dim widths() As Integer = {16, 34, 26, 12, 12, 14, 14, 18, 22}
        Dim hr As IRow = sh.CreateRow(0)
        For i As Integer = 0 To heads.Length - 1
            Dim c As ICell = hr.CreateCell(i)
            c.SetCellValue(heads(i))
            c.CellStyle = stHead
            sh.SetColumnWidth(i, widths(i) * 256)
        Next

        Dim r As Integer = 1
        For Each row As DataRow In dt.Rows
            Dim xr As IRow = sh.CreateRow(r)
            xr.CreateCell(0).SetCellValue(Convert.ToDouble(row("vdr_id")))
            xr.CreateCell(1).SetCellValue(Convert.ToString(row("vendor_name")))
            xr.CreateCell(2).SetCellValue(Convert.ToString(row("depot_name")))
            xr.CreateCell(3).SetCellValue(Convert.ToString(row("release_id")))
            xr.CreateCell(4).SetCellValue(Convert.ToString(row("release_no")))
            xr.CreateCell(5).SetCellValue(Convert.ToString(row("po_number")))
            Dim cd As ICell = xr.CreateCell(6)
            If Not IsDBNull(row("release_date")) Then cd.SetCellValue(Convert.ToDateTime(row("release_date")))
            cd.CellStyle = stRelDate
            Dim cg As ICell = xr.CreateCell(7) : cg.CellStyle = stText
            Dim cgd As ICell = xr.CreateCell(8) : cgd.CellStyle = stDate
            r += 1
        Next
        sh.CreateFreezePane(0, 1)

        Dim ms As New MemoryStream()
        wb.Write(ms)
        Dim bytes() As Byte = ms.ToArray()

        Response.Clear()
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AppendHeader("Content-Disposition", "attachment; filename=GRN_Upload_Template_" & DateTime.Now.ToString("dd_MM_yyyy_HHmm") & ".xlsx")
        Response.BinaryWrite(bytes)
        Response.Flush()
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub
#End Region

#Region "Step 2 - check the uploaded file"
    Protected Sub btnCheck_Click(sender As Object, e As EventArgs) Handles btnCheck.Click
        If Not IsAllowed() Then Return
        ClearSession()
        pnlResult.Visible = False

        If Not fuExcel.HasFile Then
            ShowMessage("Please choose the Excel file.", False)
            Return
        End If
        Dim ext As String = Path.GetExtension(fuExcel.FileName).ToLowerInvariant()
        If ext <> ".xlsx" AndAlso ext <> ".xls" Then
            ShowMessage("Only Excel files (.xlsx / .xls) are accepted.", False)
            Return
        End If

        Dim lines As DataTable = Nothing
        Dim blankRows As Integer = 0
        Try
            Using ms As New MemoryStream(fuExcel.FileBytes)
                lines = ReadLines(ms, blankRows)
            End Using
        Catch ex As InvalidDataException
            ShowMessage(ex.Message, False)
            Return
        Catch ex As Exception
            ShowMessage("The file could not be read. Please use the downloaded template (.xlsx) without changing its columns.", False)
            Return
        End Try

        If lines.Rows.Count = 0 Then
            ShowMessage("Nothing to upload: no row has a GRN No / GRN Date filled in" & If(blankRows > 0, " (" & blankRows.ToString("N0") & " rows were left blank).", "."), False)
            Return
        End If

        Try
            Dim ds As DataSet = New POLinkingRequestClass().ApplyGrnUpload(lines, Convert.ToString(userInfo.userIDEntity), Path.GetFileName(fuExcel.FileName), False)
            Session(SessLines) = lines
            Session(SessFile) = Path.GetFileName(fuExcel.FileName)
            ShowResult(ds, False, blankRows)
        Catch ex As Exception
            ShowMessage(Constant.ErrorMessages.GeneralError, False)
        End Try
    End Sub

    'Reads the template. Rows with both GRN No and GRN Date blank are skipped (counted in blankRows).
    Private Function ReadLines(ByVal stream As Stream, ByRef blankRows As Integer) As DataTable
        Dim wb As IWorkbook = WorkbookFactory.Create(stream)
        Dim sh As ISheet = wb.GetSheetAt(0)
        Dim head As IRow = sh.GetRow(0)
        If head Is Nothing Then Throw New InvalidDataException("The first row of the sheet must be the header row of the template.")

        Dim colKey As Integer = -1, colNo As Integer = -1, colDate As Integer = -1
        For i As Integer = 0 To head.LastCellNum - 1
            Dim h As String = CellText(head.GetCell(i)).ToLowerInvariant()
            If h.StartsWith("row key") Then colKey = i
            If h.StartsWith("grn no") Then colNo = i
            If h.StartsWith("grn date") Then colDate = i
        Next
        If colKey < 0 OrElse colNo < 0 OrElse colDate < 0 Then
            Throw New InvalidDataException("The columns 'Row Key', 'GRN No' and 'GRN Date' were not found in the first row. Please use the downloaded template.")
        End If

        Dim dt As DataTable = POLinkingRequestClass.NewGrnUploadLineTable()
        For r As Integer = 1 To sh.LastRowNum
            Dim row As IRow = sh.GetRow(r)
            If row Is Nothing Then Continue For
            Dim keyTxt As String = CellText(row.GetCell(colKey))
            Dim noTxt As String = CellText(row.GetCell(colNo))
            Dim dateCell As ICell = row.GetCell(colDate)
            Dim dateTxt As String = CellText(dateCell)
            If keyTxt = "" AndAlso noTxt = "" AndAlso dateTxt = "" Then Continue For
            If noTxt = "" AndAlso dateTxt = "" Then
                blankRows += 1
                Continue For
            End If

            Dim nr As DataRow = dt.NewRow()
            nr("row_no") = r + 1
            Dim key As Long
            If Long.TryParse(keyTxt, NumberStyles.Integer, CultureInfo.InvariantCulture, key) OrElse TryDoubleToLong(keyTxt, key) Then
                nr("vdr_id") = key
            Else
                nr("vdr_id") = DBNull.Value
            End If
            nr("grn_no") = If(noTxt = "", CType(DBNull.Value, Object), noTxt)
            Dim d As DateTime
            If TryReadDate(dateCell, d) Then nr("grn_date") = d Else nr("grn_date") = DBNull.Value
            dt.Rows.Add(nr)
        Next
        Return dt
    End Function

    Private Shared Function TryDoubleToLong(ByVal s As String, ByRef v As Long) As Boolean
        Dim dbl As Double
        If Double.TryParse(s, NumberStyles.Float, CultureInfo.InvariantCulture, dbl) AndAlso dbl = Math.Floor(dbl) AndAlso dbl > 0 Then
            v = CLng(dbl)
            Return True
        End If
        Return False
    End Function

    'Cell text; a whole number (an Excel numeric 123) is written as 123, not 123.0
    Private Shared Function CellText(ByVal c As ICell) As String
        If c Is Nothing Then Return ""
        Select Case c.CellType
            Case CellType.String
                Return c.StringCellValue.Trim()
            Case CellType.Numeric
                If DateUtil.IsCellDateFormatted(c) Then Return c.DateCellValue.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)
                Dim n As Double = c.NumericCellValue
                If n = Math.Floor(n) AndAlso Math.Abs(n) < 1.0E+15 Then Return CLng(n).ToString(CultureInfo.InvariantCulture)
                Return n.ToString(CultureInfo.InvariantCulture)
            Case CellType.Formula
                Return c.ToString().Trim()
            Case Else
                Return ""
        End Select
    End Function

    'A real Excel date, or text in dd/mm/yyyy (also d/m/yyyy, dd-mm-yyyy, yyyy-mm-dd)
    Private Shared Function TryReadDate(ByVal c As ICell, ByRef d As DateTime) As Boolean
        If c Is Nothing Then Return False
        If c.CellType = CellType.Numeric Then
            If DateUtil.IsCellDateFormatted(c) Then
                d = c.DateCellValue.Date
                Return True
            End If
            Return False   'a plain number is not accepted as a date
        End If
        Dim s As String = CellText(c)
        If s = "" Then Return False
        If DateTime.TryParseExact(s, New String() {"dd/MM/yyyy", "d/M/yyyy", "dd-MM-yyyy", "d-M-yyyy", "yyyy-MM-dd", "dd-MMM-yyyy", "d-MMM-yyyy"}, CultureInfo.InvariantCulture, DateTimeStyles.None, d) Then
            d = d.Date
            Return True
        End If
        Return False
    End Function
#End Region

#Region "Step 3 - result / confirm"
    Protected Sub btnConfirm_Click(sender As Object, e As EventArgs) Handles btnConfirm.Click
        If Not IsAllowed() Then Return
        Dim lines As DataTable = TryCast(Session(SessLines), DataTable)
        If lines Is Nothing OrElse lines.Rows.Count = 0 Then
            ShowMessage("The checked file is no longer available. Please upload it again.", False)
            pnlResult.Visible = False
            Return
        End If

        Try
            Dim ds As DataSet = New POLinkingRequestClass().ApplyGrnUpload(lines, Convert.ToString(userInfo.userIDEntity), Convert.ToString(Session(SessFile)), True)
            ClearSession()
            ShowResult(ds, True, 0)
        Catch ex As Exception
            ShowMessage(Constant.ErrorMessages.GeneralError, False)
        End Try
    End Sub

    Private Sub ShowResult(ByVal ds As DataSet, ByVal saved As Boolean, ByVal blankRows As Integer)
        If ds Is Nothing OrElse ds.Tables.Count < 2 Then
            ShowMessage(Constant.ErrorMessages.GeneralError, False)
            Return
        End If
        Dim s As DataRow = ds.Tables(0).Rows(0)
        Dim total As Integer = Convert.ToInt32(s("total_rows"))
        Dim ok As Integer = Convert.ToInt32(s("ok_rows"))
        Dim rejected As Integer = Convert.ToInt32(s("rejected_rows"))
        Dim savedRows As Integer = Convert.ToInt32(s("saved_rows"))

        Session(SessResult) = ds.Tables(1)
        pnlResult.Visible = True

        If saved Then
            lblSummary.Text = savedRows.ToString("N0") & " row(s) saved - GRN done now." & If(rejected > 0, "  " & rejected.ToString("N0") & " row(s) NOT saved (see the Result column).", "") &
                              If(Not IsDBNull(s("batch_id")), "  Batch " & Convert.ToString(s("batch_id")) & ".", "")
            lblSummary.CssClass = "d-block mb-2 font-weight-bold " & If(rejected > 0, "text-warning", "text-success")
            btnConfirm.Visible = False
        Else
            lblSummary.Text = total.ToString("N0") & " row(s) checked: " & ok.ToString("N0") & " can be saved, " & rejected.ToString("N0") & " rejected." &
                              If(blankRows > 0, "  " & blankRows.ToString("N0") & " row(s) left blank were ignored.", "") &
                              If(ok > 0, "  Nothing is saved until you press ""Confirm and save"".", "")
            lblSummary.CssClass = "d-block mb-2 font-weight-bold " & If(rejected > 0, "text-warning", "text-success")
            btnConfirm.Visible = ok > 0
            btnConfirm.Text = "Confirm and save " & ok.ToString("N0") & " row(s)"
        End If

        Dim t As DataTable = ds.Tables(1)
        If t.Rows.Count > GridRowCap Then
            Dim top As DataTable = t.Clone()
            For i As Integer = 0 To GridRowCap - 1
                top.ImportRow(t.Rows(i))
            Next
            gvResult.DataSource = top
            lblGridNote.Text = "Showing the first " & GridRowCap & " of " & t.Rows.Count.ToString("N0") & " rows (rejected rows first). Use ""Download result"" for all."
        Else
            gvResult.DataSource = t
            lblGridNote.Text = String.Empty
        End If
        gvResult.DataBind()
        lblMessage.Text = String.Empty
    End Sub

    Protected Sub btnDownloadResult_Click(sender As Object, e As EventArgs) Handles btnDownloadResult.Click
        If Not IsAllowed() Then Return
        Dim t As DataTable = TryCast(Session(SessResult), DataTable)
        If t Is Nothing OrElse t.Rows.Count = 0 Then Return
        Try
            Dim cols As New List(Of GridExcelExport.ExportColumn) From {
                New GridExcelExport.ExportColumn("Excel Row", "row_no", GridExcelExport.ColumnKind.Number, 10),
                New GridExcelExport.ExportColumn("Row Key", "vdr_id", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("Release ID", "release_id", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("GRN No", "grn_no", GridExcelExport.ColumnKind.Text, 18),
                New GridExcelExport.ExportColumn("GRN Date", "grn_date_text", GridExcelExport.ColumnKind.Text, 14),
                New GridExcelExport.ExportColumn("Result", "result", GridExcelExport.ColumnKind.Text, 70)
            }
            Dim copy As DataTable = t.Copy()
            copy.Columns.Add("grn_date_text", GetType(String))
            For Each r As DataRow In copy.Rows
                If Not IsDBNull(r("grn_date")) Then r("grn_date_text") = Convert.ToDateTime(r("grn_date")).ToString("dd/MM/yyyy")
            Next
            GridExcelExport.Export(copy, cols, "GRN Upload result", "File : " & Convert.ToString(Session(SessFile)), userInfo.userCompanyEntity,
                                   "GRN_Upload_Result", AppDomain.CurrentDomain.BaseDirectory, Response)
        Catch ex As Threading.ThreadAbortException
            Throw
        Catch ex As Exception
            ShowMessage(Constant.ErrorMessages.GeneralError, False)
        End Try
    End Sub
#End Region

    Private Sub ClearSession()
        Session.Remove(SessLines)
        Session.Remove(SessResult)
        Session.Remove(SessFile)
    End Sub

    Private Sub ShowMessage(ByVal text As String, ByVal ok As Boolean)
        lblMessage.CssClass = "d-block mb-2 " & If(ok, "text-success", "text-danger")
        lblMessage.Text = text
    End Sub
End Class
