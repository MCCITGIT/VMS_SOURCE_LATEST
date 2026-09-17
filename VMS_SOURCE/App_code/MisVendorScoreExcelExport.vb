Imports System.Data
Imports System.Globalization
Imports System.IO
Imports NPOI.SS.UserModel
Imports NPOI.SS.Util
Imports NPOI.XSSF.UserModel

''' <summary>
''' Modified-by MUKESH BHAGAT on 16-09-2026 : Vendor Score Report export for mis_report.aspx.
''' Switched from building the workbook from scratch to opening the pre-formatted
''' "Templates\Vendor_Score_Report_Template.xlsx" - same template-based pattern used by the other
''' Excel exports in this project (e.g. FreightDtls.aspx.vb, MonthlyUnitDespatchExcelExport.vb).
''' The template is the sample "Vendor Score Report.xlsx" shared for this task with every data row
''' stripped out, keeping only its 2-row merged header (unit_code / vendor row-merged, Q1..Q4
''' col-merged with Audit/Complaints/Penalty/.../Total/Grade repeated underneath each) - so the
''' header colours/fonts/borders/column widths come from the template exactly as-is instead of
''' being recreated in code. Data rows are appended generically from whatever columns
''' [dbo].[vrs_getvendor_score_report] actually returns (unit_code, vendor, then N head columns +
''' total + grade, repeated exactly 4 times - the SP guarantees exactly 4 quarters).
''' </summary>
Public Class MisVendorScoreExcelExport

    Public Shared Sub ExportVendorScoreReport(ByVal ds As DataSet, ByVal finYearLabel As String, ByVal templateBasePath As String, ByVal response As HttpResponse)
        Dim dt As DataTable = ds.Tables(0)
        Dim lastCol As Integer = dt.Columns.Count - 1

        Dim templatePath As String = templateBasePath & "Templates\Vendor_Score_Report_Template.xlsx"
        Dim workbook As XSSFWorkbook
        Using fs As New FileStream(templatePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)
            workbook = New XSSFWorkbook(fs)
        End Using
        Dim sheet As XSSFSheet = CType(workbook.GetSheetAt(0), XSSFSheet)

        Dim fontNormal As IFont = workbook.CreateFont()
        fontNormal.FontName = "Calibri"
        fontNormal.FontHeightInPoints = 10

        Dim styleText As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Left)
        Dim styleTextCenter As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Center)
        Dim styleNumber As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Right)
        styleNumber.DataFormat = workbook.CreateDataFormat().GetFormat("0.00")

        ' ---- Data rows (from Excel row 3, 0-based row index 2 - the template's header occupies rows 0-1) ----
        Dim rowIndex As Integer = 2
        For r As Integer = 0 To dt.Rows.Count - 1
            Dim row As XSSFRow = CType(sheet.CreateRow(rowIndex), XSSFRow)
            Dim dataRow As DataRow = dt.Rows(r)

            SetCell(row, 0, Convert.ToString(dataRow(0)), styleTextCenter)
            SetCell(row, 1, Convert.ToString(dataRow(1)), styleText)

            For c As Integer = 2 To lastCol
                Dim colName As String = dt.Columns(c).ColumnName
                Dim cell As XSSFCell = CType(row.CreateCell(c), XSSFCell)
                If colName.EndsWith("_grade_name", StringComparison.OrdinalIgnoreCase) Then
                    cell.SetCellValue(Convert.ToString(dataRow(c)))
                    cell.CellStyle = styleTextCenter
                Else
                    cell.SetCellValue(SafeToDouble(dataRow(c)))
                    cell.CellStyle = styleNumber
                End If
            Next

            rowIndex += 1
        Next

        If dt.Rows.Count > 0 Then
            sheet.SetAutoFilter(New CellRangeAddress(1, rowIndex - 1, 0, lastCol))
        End If

        ' ---- Save then stream (same pattern as the other template-based exports) ----
        Dim genReportPath As String = templateBasePath & "Excel_Reports\"
        If Not Directory.Exists(genReportPath) Then
            Directory.CreateDirectory(genReportPath)
        End If

        Dim safeFinYear As String = If(String.IsNullOrEmpty(finYearLabel), "All", finYearLabel)
        Dim fileName As String = "Vendor_Score_Report_" & safeFinYear & "_" & DateTime.Today.ToString("dd_MM_yyyy") & ".xlsx"
        Dim fullPath As String = genReportPath & fileName

        Using fl As New FileStream(fullPath, FileMode.Create)
            workbook.Write(fl)
        End Using

        response.Clear()
        response.Charset = ""
        response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        response.AppendHeader("content-disposition", "attachment; filename=" & fileName)
        response.WriteFile(fullPath)
        response.End()
    End Sub

    Private Shared Sub SetCell(ByVal row As XSSFRow, ByVal colIndex As Integer, ByVal value As String, ByVal style As ICellStyle)
        Dim cell As XSSFCell = CType(row.CreateCell(colIndex), XSSFCell)
        cell.SetCellValue(value)
        cell.CellStyle = style
    End Sub

    Private Shared Function CreateBorderedStyle(ByVal workbook As IWorkbook, ByVal font As IFont, ByVal alignment As HorizontalAlignment) As ICellStyle
        Dim style As ICellStyle = workbook.CreateCellStyle()
        style.Alignment = alignment
        style.VerticalAlignment = VerticalAlignment.Center
        style.SetFont(font)
        style.BorderTop = BorderStyle.Thin
        style.BorderBottom = BorderStyle.Thin
        style.BorderLeft = BorderStyle.Thin
        style.BorderRight = BorderStyle.Thin
        Return style
    End Function

    Private Shared Function SafeToDouble(ByVal value As Object) As Double
        If value Is Nothing OrElse value Is DBNull.Value Then
            Return 0R
        End If
        Dim result As Double
        If Double.TryParse(Convert.ToString(value), NumberStyles.Any, CultureInfo.InvariantCulture, result) Then
            Return result
        End If
        If Double.TryParse(Convert.ToString(value), result) Then
            Return result
        End If
        Return 0R
    End Function

End Class
