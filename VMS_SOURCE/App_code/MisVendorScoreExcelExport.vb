Imports System.Data
Imports System.Globalization
Imports System.IO
Imports NPOI.SS.UserModel
Imports NPOI.SS.Util
Imports NPOI.XSSF.UserModel

''' <summary>
''' Modified-by MUKESH BHAGAT on 15-09-2026 : Vendor Score Report export for mis_report.aspx.
''' Reproduces the 2-row merged header of the sample "Vendor Score Report.xlsx" shared for this
''' task - unit_code / vendor in the first two (row-merged) columns, then one Q1..Q4 band per
''' quarter (col-merged) with Audit/Complaints/Penalty/.../Total/Grade repeated underneath each.
''' Built generically from whatever columns [dbo].[vrs_getvendor_score_report] actually returns
''' (unit_code, vendor, then N head columns + total + grade, repeated exactly 4 times - the SP
''' itself guarantees exactly 4 quarters and errors out otherwise) rather than a hard-coded head
''' list, so this keeps working even if the head list changes for a future year. Follows the same
''' fresh-XSSFWorkbook / save-to-Excel_Reports-then-stream pattern already used by
''' MonthlyUnitDespatchExcelExport.vb elsewhere in this project.
''' </summary>
Public Class MisVendorScoreExcelExport

    Public Shared Sub ExportVendorScoreReport(ByVal ds As DataSet, ByVal finYearLabel As String, ByVal templateBasePath As String, ByVal response As HttpResponse)
        Dim dt As DataTable = ds.Tables(0)
        Dim totalCols As Integer = dt.Columns.Count

        ' unit_code, vendor + 4 equal quarter blocks (the SP guarantees exactly 4 quarters)
        Dim quarterColCount As Integer = CInt(Math.Floor((totalCols - 2) / 4.0))
        Dim lastCol As Integer = totalCols - 1

        Dim workbook As New XSSFWorkbook()
        Dim sheet As XSSFSheet = CType(workbook.CreateSheet("Vendor Score Report"), XSSFSheet)

        Dim fontQuarterHeader As IFont = workbook.CreateFont()
        fontQuarterHeader.FontName = "Calibri"
        fontQuarterHeader.FontHeightInPoints = 11
        fontQuarterHeader.Boldweight = CShort(FontBoldWeight.Bold)

        Dim fontSubHeader As IFont = workbook.CreateFont()
        fontSubHeader.FontName = "Calibri"
        fontSubHeader.FontHeightInPoints = 10
        fontSubHeader.Boldweight = CShort(FontBoldWeight.Bold)

        Dim fontNormal As IFont = workbook.CreateFont()
        fontNormal.FontName = "Calibri"
        fontNormal.FontHeightInPoints = 10

        ' Modified-by MUKESH BHAGAT on 15-09-2026 : one distinct fill colour per quarter, matched
        ' exactly (RGB picked off) from the sample "Vendor Score Report.xlsx" header - Q1/Q2/Q4 are
        ' theme accent colours with a tint applied there, Q3 is a plain RGB fill. Previously a single
        ' shared style (IndexedColors.RoyalBlue) was reused for all 4 quarters, which is why every
        ' quarter band exported blue instead of matching the source's Q1=peach/Q2=blue/Q3=green/
        ' Q4=orange bands. Applied to both the Q1..Q4 label row and the Audit/.../Grade sub-header
        ' row beneath it, same as the sample.
        Dim quarterColors As Byte()() = {
            New Byte() {&HFC, &HD5, &HB5},
            New Byte() {&H95, &HB3, &HD7},
            New Byte() {&H92, &HD0, &H50},
            New Byte() {&HFA, &HC0, &H90}
        }

        Dim styleQuarterHeaderByQ(3) As ICellStyle
        Dim styleSubHeaderByQ(3) As ICellStyle
        For q As Integer = 0 To 3
            Dim color As New XSSFColor(quarterColors(q))

            Dim styleQ As ICellStyle = workbook.CreateCellStyle()
            styleQ.Alignment = HorizontalAlignment.Center
            styleQ.VerticalAlignment = VerticalAlignment.Center
            styleQ.SetFont(fontQuarterHeader)
            CType(styleQ, XSSFCellStyle).SetFillForegroundColor(color)
            styleQ.FillPattern = FillPattern.SolidForeground
            styleQuarterHeaderByQ(q) = styleQ

            Dim styleSub As ICellStyle = workbook.CreateCellStyle()
            styleSub.Alignment = HorizontalAlignment.Center
            styleSub.VerticalAlignment = VerticalAlignment.Center
            styleSub.SetFont(fontSubHeader)
            CType(styleSub, XSSFCellStyle).SetFillForegroundColor(color)
            styleSub.FillPattern = FillPattern.SolidForeground
            styleSub.BorderTop = BorderStyle.Thin
            styleSub.BorderBottom = BorderStyle.Thin
            styleSub.BorderLeft = BorderStyle.Thin
            styleSub.BorderRight = BorderStyle.Thin
            styleSubHeaderByQ(q) = styleSub
        Next

        Dim styleFixedHeader As ICellStyle = workbook.CreateCellStyle()
        styleFixedHeader.Alignment = HorizontalAlignment.Center
        styleFixedHeader.VerticalAlignment = VerticalAlignment.Center
        styleFixedHeader.SetFont(fontQuarterHeader)
        styleFixedHeader.FillForegroundColor = IndexedColors.Grey50Percent.Index
        styleFixedHeader.FillPattern = FillPattern.SolidForeground

        Dim styleText As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Left)
        Dim styleTextCenter As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Center)
        Dim styleNumber As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Right)
        styleNumber.DataFormat = workbook.CreateDataFormat().GetFormat("0.00")

        ' ---- Row 1 : unit_code / vendor (row-merged A1:A2 / B1:B2) + Q1..Q4 (col-merged) ----
        Dim row0 As XSSFRow = CType(sheet.CreateRow(0), XSSFRow)
        row0.HeightInPoints = 18
        Dim row1 As XSSFRow = CType(sheet.CreateRow(1), XSSFRow)
        row1.HeightInPoints = 20

        SetCell(row0, 0, dt.Columns(0).ColumnName, styleFixedHeader)   ' "unit_code"
        SetCell(row1, 0, "", styleFixedHeader)
        sheet.AddMergedRegion(New CellRangeAddress(0, 1, 0, 0))

        SetCell(row0, 1, dt.Columns(1).ColumnName, styleFixedHeader)   ' "vendor"
        SetCell(row1, 1, "", styleFixedHeader)
        sheet.AddMergedRegion(New CellRangeAddress(0, 1, 1, 1))

        For q As Integer = 0 To 3
            Dim startCol As Integer = 2 + (q * quarterColCount)
            Dim endCol As Integer = startCol + quarterColCount - 1

            SetCell(row0, startCol, "Q" & (q + 1).ToString(), styleQuarterHeaderByQ(q))
            For c As Integer = startCol + 1 To endCol
                SetCell(row0, c, "", styleQuarterHeaderByQ(q))
            Next
            If endCol > startCol Then
                sheet.AddMergedRegion(New CellRangeAddress(0, 0, startCol, endCol))
            End If

            ' ---- Row 2 : sub-headers, read from the actual column names (Q1_Audit -> "Audit",
            ' Q1_total -> "Total", Q1_grade_name -> "Grade") so this keeps working even if the
            ' head list the SP builds for a given year ever changes. ----
            For c As Integer = startCol To endCol
                Dim rawName As String = dt.Columns(c).ColumnName
                Dim underscoreIdx As Integer = rawName.IndexOf("_"c)
                Dim subLabel As String = If(underscoreIdx >= 0, rawName.Substring(underscoreIdx + 1), rawName)
                If subLabel.Equals("total", StringComparison.OrdinalIgnoreCase) Then
                    subLabel = "Total"
                ElseIf subLabel.Equals("grade_name", StringComparison.OrdinalIgnoreCase) Then
                    subLabel = "Grade"
                End If
                SetCell(row1, c, subLabel, styleSubHeaderByQ(q))
            Next
        Next

        ' ---- Data rows (from Excel row 3, 0-based row index 2) ----
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

        ' ---- Column widths (same repeating pattern the sample file used per quarter) ----
        sheet.SetColumnWidth(0, 12 * 256)
        sheet.SetColumnWidth(1, 40 * 256)
        Dim widthPattern() As Integer = {10, 15, 12, 11, 11, 13, 9, 16}
        For q As Integer = 0 To 3
            For i As Integer = 0 To quarterColCount - 1
                Dim col As Integer = 2 + (q * quarterColCount) + i
                Dim w As Integer = If(i < widthPattern.Length, widthPattern(i), 12)
                sheet.SetColumnWidth(col, w * 256)
            Next
        Next

        sheet.CreateFreezePane(0, 2)
        If dt.Rows.Count > 0 Then
            sheet.SetAutoFilter(New CellRangeAddress(1, rowIndex - 1, 0, lastCol))
        End If

        ' ---- Save then stream (same pattern as MonthlyUnitDespatchExcelExport.vb) ----
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
