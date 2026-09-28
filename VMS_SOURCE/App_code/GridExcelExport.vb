Imports System.Data
Imports System.Globalization
Imports System.IO
Imports NPOI.SS.UserModel
Imports NPOI.SS.Util
Imports NPOI.XSSF.UserModel

'=====================================================================================
'Author       : MUKESH BHAGAT
'Create date  : 28-09-2026
'Description  : Generic "grid to Excel" export (NPOI .xlsx) for list screens that have no
'               report template of their own. Same look as MonthlyUnitDespatchExcelExport:
'               title row, filter row, grey column header, thin borders, frozen header,
'               file written under Excel_Reports\ and streamed to the browser.
'               First used by VendorChallanList.aspx and VprDashboard.aspx.
'=====================================================================================
Public Class GridExcelExport

    Public Enum ColumnKind
        Text = 0
        Number = 1      '#,##0
        Amount = 2      '#,##0.00
        SerialNo = 3    'running number, no source field
    End Enum

    'One export column: header caption, source column of the DataTable, and how to render it.
    Public Class ExportColumn
        Public Property Header As String
        Public Property Field As String
        Public Property Kind As ColumnKind
        Public Property Width As Integer        'characters; 0 = default

        Public Sub New(ByVal header As String, ByVal field As String, ByVal kind As ColumnKind, Optional ByVal width As Integer = 0)
            Me.Header = header
            Me.Field = field
            Me.Kind = kind
            Me.Width = width
        End Sub
    End Class

    ''' <summary>
    ''' Builds the workbook, saves it as Excel_Reports\{companyCode}_{fileBaseName}_dd_MM_yyyy.xlsx
    ''' and streams it. Ends the response.
    ''' </summary>
    Public Shared Sub Export(ByVal table As DataTable, ByVal columns As IList(Of ExportColumn), ByVal title As String,
                             ByVal filterLine As String, ByVal companyCode As String, ByVal fileBaseName As String,
                             ByVal basePath As String, ByVal response As HttpResponse)

        Dim workbook As New XSSFWorkbook()
        Dim sheet As XSSFSheet = CType(workbook.CreateSheet("Report"), XSSFSheet)

        Dim fontTitle As IFont = workbook.CreateFont()
        fontTitle.FontName = "Calibri"
        fontTitle.FontHeightInPoints = 14
        fontTitle.Boldweight = CShort(FontBoldWeight.Bold)

        Dim fontBold As IFont = workbook.CreateFont()
        fontBold.FontName = "Calibri"
        fontBold.FontHeightInPoints = 11
        fontBold.Boldweight = CShort(FontBoldWeight.Bold)

        Dim fontNormal As IFont = workbook.CreateFont()
        fontNormal.FontName = "Calibri"
        fontNormal.FontHeightInPoints = 10

        Dim fontHeader As IFont = workbook.CreateFont()
        fontHeader.FontName = "Calibri"
        fontHeader.FontHeightInPoints = 10
        fontHeader.Boldweight = CShort(FontBoldWeight.Bold)
        fontHeader.Color = IndexedColors.White.Index

        Dim styleTitle As ICellStyle = workbook.CreateCellStyle()
        styleTitle.Alignment = HorizontalAlignment.Center
        styleTitle.VerticalAlignment = VerticalAlignment.Center
        styleTitle.SetFont(fontTitle)

        Dim styleFilter As ICellStyle = workbook.CreateCellStyle()
        styleFilter.Alignment = HorizontalAlignment.Left
        styleFilter.VerticalAlignment = VerticalAlignment.Center
        styleFilter.SetFont(fontBold)
        styleFilter.FillForegroundColor = IndexedColors.LightYellow.Index
        styleFilter.FillPattern = FillPattern.SolidForeground

        Dim styleColHeader As ICellStyle = workbook.CreateCellStyle()
        styleColHeader.Alignment = HorizontalAlignment.Center
        styleColHeader.VerticalAlignment = VerticalAlignment.Center
        styleColHeader.SetFont(fontHeader)
        styleColHeader.FillForegroundColor = IndexedColors.Grey50Percent.Index
        styleColHeader.FillPattern = FillPattern.SolidForeground
        styleColHeader.BorderTop = BorderStyle.Thin
        styleColHeader.BorderBottom = BorderStyle.Thin
        styleColHeader.BorderLeft = BorderStyle.Thin
        styleColHeader.BorderRight = BorderStyle.Thin
        styleColHeader.WrapText = True

        Dim styleText As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Left)
        styleText.WrapText = True
        Dim styleMid As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Center)
        Dim styleNumber As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Right)
        styleNumber.DataFormat = workbook.CreateDataFormat().GetFormat("#,##0")
        Dim styleAmount As ICellStyle = CreateBorderedStyle(workbook, fontNormal, HorizontalAlignment.Right)
        styleAmount.DataFormat = workbook.CreateDataFormat().GetFormat("#,##0.00")

        Dim lastCol As Integer = columns.Count - 1
        Dim row As XSSFRow
        Dim cell As XSSFCell

        'row 0 : title
        row = CType(sheet.CreateRow(0), XSSFRow)
        row.HeightInPoints = 22
        cell = CType(row.CreateCell(0), XSSFCell)
        cell.SetCellValue(title)
        cell.CellStyle = styleTitle
        If lastCol > 0 Then sheet.AddMergedRegion(New CellRangeAddress(0, 0, 0, lastCol))

        'row 1 : filters / report date
        row = CType(sheet.CreateRow(1), XSSFRow)
        cell = CType(row.CreateCell(0), XSSFCell)
        cell.SetCellValue(filterLine & "      Report Date : " & DateTime.Today.ToString("dd/MM/yyyy"))
        cell.CellStyle = styleFilter
        If lastCol > 0 Then sheet.AddMergedRegion(New CellRangeAddress(1, 1, 0, lastCol))

        'row 2 : column headers
        Const headerRowIndex As Integer = 2
        row = CType(sheet.CreateRow(headerRowIndex), XSSFRow)
        row.HeightInPoints = 20
        For c As Integer = 0 To lastCol
            cell = CType(row.CreateCell(c), XSSFCell)
            cell.SetCellValue(columns(c).Header)
            cell.CellStyle = styleColHeader
        Next

        'data rows
        Dim rowIndex As Integer = headerRowIndex + 1
        For i As Integer = 0 To table.Rows.Count - 1
            row = CType(sheet.CreateRow(rowIndex), XSSFRow)
            For c As Integer = 0 To lastCol
                Dim col As ExportColumn = columns(c)
                cell = CType(row.CreateCell(c), XSSFCell)
                Select Case col.Kind
                    Case ColumnKind.SerialNo
                        cell.SetCellValue(CDbl(i + 1))
                        cell.CellStyle = styleMid
                    Case ColumnKind.Number
                        cell.SetCellValue(SafeToDouble(FieldValue(table, i, col.Field)))
                        cell.CellStyle = styleNumber
                    Case ColumnKind.Amount
                        cell.SetCellValue(SafeToDouble(FieldValue(table, i, col.Field)))
                        cell.CellStyle = styleAmount
                    Case Else
                        cell.SetCellValue(Convert.ToString(FieldValue(table, i, col.Field)))
                        cell.CellStyle = styleText
                End Select
            Next
            rowIndex += 1
        Next

        For c As Integer = 0 To lastCol
            Dim w As Integer = If(columns(c).Width > 0, columns(c).Width, 16)
            sheet.SetColumnWidth(c, w * 256)
        Next
        sheet.CreateFreezePane(0, headerRowIndex + 1)
        If table.Rows.Count > 0 Then
            sheet.SetAutoFilter(New CellRangeAddress(headerRowIndex, rowIndex - 1, 0, lastCol))
        End If

        'save + stream (same folder / naming convention as the other exports)
        Dim genReportPath As String = basePath & "Excel_Reports\"
        If Not Directory.Exists(genReportPath) Then Directory.CreateDirectory(genReportPath)

        Dim fileName As String = companyCode & "_" & fileBaseName & "_" & DateTime.Today.ToString("dd_MM_yyyy") & ".xlsx"
        Using fl As New FileStream(genReportPath & fileName, FileMode.Create)
            workbook.Write(fl)
        End Using

        response.Clear()
        response.Charset = ""
        response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        response.AppendHeader("content-disposition", "attachment; filename=" & fileName)
        response.WriteFile(genReportPath & fileName)
        response.End()
    End Sub

    'missing column -> empty, so an SP that lacks an optional column does not break the export
    Private Shared Function FieldValue(ByVal table As DataTable, ByVal rowIndex As Integer, ByVal field As String) As Object
        If String.IsNullOrEmpty(field) OrElse Not table.Columns.Contains(field) Then Return String.Empty
        Dim v As Object = table.Rows(rowIndex)(field)
        If v Is Nothing OrElse v Is DBNull.Value Then Return String.Empty
        Return v
    End Function

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
        If value Is Nothing OrElse value Is DBNull.Value Then Return 0R
        Dim result As Double
        If Double.TryParse(Convert.ToString(value), NumberStyles.Any, CultureInfo.InvariantCulture, result) Then Return result
        If Double.TryParse(Convert.ToString(value), result) Then Return result
        Return 0R
    End Function

End Class
