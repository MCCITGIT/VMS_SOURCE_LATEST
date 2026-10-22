Imports System.Data
Imports System.Globalization
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.text.pdf

''' <summary>
''' Shared iTextSharp PDF builder. Callers pass the data and the file path; this class writes the file.
''' </summary>
Public Class PdfGenerator

    Private Shared ReadOnly Navy As New BaseColor(18, 59, 91)
    Private Shared ReadOnly Blue As New BaseColor(47, 111, 237)
    Private Shared ReadOnly Ink As New BaseColor(17, 24, 39)
    Private Shared ReadOnly Muted As New BaseColor(100, 116, 139)
    Private Shared ReadOnly Line As New BaseColor(226, 232, 240)
    Private Shared ReadOnly HeaderFill As New BaseColor(18, 59, 91)
    Private Shared ReadOnly AltRow As New BaseColor(248, 250, 252)
    Private Shared ReadOnly SoftBlue As New BaseColor(239, 246, 255)
    Private Shared ReadOnly TotalFill As New BaseColor(240, 253, 244)
    Private Shared ReadOnly White As New BaseColor(255, 255, 255)

    Private Shared ReadOnly BodyFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 9, Font.NORMAL, Ink)
    Private Shared ReadOnly SmallFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, Font.NORMAL, Muted)
    Private Shared ReadOnly LabelFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 7.5F, Font.BOLD, Muted)
    Private Shared ReadOnly ValueFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 10, Font.BOLD, Ink)
    Private Shared ReadOnly TitleFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 16, Font.BOLD, Navy)
    Private Shared ReadOnly SectionFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 10, Font.BOLD, Navy)
    Private Shared ReadOnly HeaderFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, Font.BOLD, White)
    Private Shared ReadOnly AmountFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 9, Font.NORMAL, Ink)
    Private Shared ReadOnly TotalFont As Font = FontFactory.GetFont(FontFactory.HELVETICA, 10, Font.BOLD, Navy)
    Private Shared ReadOnly WhiteSmall As Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, Font.NORMAL, White)

    ''' <summary>
    ''' Writes a raw-material purchase order PDF.
    ''' Line columns: ProductCode, ProductName, Qty, Rate, Gst, GstAmount, Amount.
    ''' Amount is quantity x rate plus GST on that line. freightGstPercent is the optional freight GST percent.
    ''' The item table repeats its header on each page and the totals block stays together.
    ''' </summary>
    Public Function CreateRawMaterialPurchaseOrder(ByVal outputPath As String,
                                                   ByVal poNo As String,
                                                   ByVal poDate As Date,
                                                   ByVal vendorCode As String,
                                                   ByVal vendorName As String,
                                                   ByVal preparedBy As String,
                                                   ByVal lines As DataTable,
                                                   ByVal freightGstPercent As Nullable(Of Decimal),
                                                   ByVal freightCost As Decimal) As String
        If String.IsNullOrWhiteSpace(outputPath) Then
            Throw New ArgumentException("PDF output path is required.")
        End If
        If lines Is Nothing OrElse lines.Rows.Count = 0 Then
            Throw New ArgumentException("At least one product line is required to create the purchase order PDF.")
        End If

        Dim folder As String = Path.GetDirectoryName(outputPath)
        Dim fileName As String = Path.GetFileName(outputPath)
        Dim dateFolder As String = Path.GetFileName(folder)
        Dim result As String = System.IO.Path.Combine(dateFolder, fileName)
        If Not String.IsNullOrEmpty(folder) AndAlso Not Directory.Exists(folder) Then
            Directory.CreateDirectory(folder)
        End If

        Dim document As New Document(PageSize.A4, 36, 36, 64, 52)
        Dim writer As PdfWriter = Nothing
        Dim stream As FileStream = Nothing

        Try
            stream = New FileStream(outputPath, FileMode.Create, FileAccess.Write)
            writer = PdfWriter.GetInstance(document, stream)
            writer.CloseStream = True
            writer.PageEvent = New PurchaseOrderPageEvent(poNo)
            document.AddTitle("Purchase Order " & poNo)
            document.AddAuthor(Constant.Common.Company)
            document.AddCreator("VMS")
            document.Open()

            AddTitleBlock(document, poNo, poDate, preparedBy)
            AddVendorBlock(document, vendorCode, vendorName)
            AddSectionLabel(document, "Line items")
            document.Add(BuildLineTable(lines))
            document.Add(BuildTotals(lines, freightGstPercent, freightCost))
            document.Add(BuildClosingBlock(preparedBy))
            document.Close()
        Catch ex As Exception
            Throw
        Finally
            If document.IsOpen() Then
                document.Close()
            End If
            If stream IsNot Nothing Then
                stream.Dispose()
            End If
        End Try

        Return result
    End Function

    Private Sub AddTitleBlock(ByVal document As Document, ByVal poNo As String, ByVal poDate As Date, ByVal preparedBy As String)
        Dim title As New Paragraph("Raw Material Purchase Order", TitleFont)
        title.SpacingAfter = 4
        document.Add(title)

        Dim subtitle As New Paragraph("Vendor material order raised from VMS", SmallFont)
        subtitle.SpacingAfter = 12
        document.Add(subtitle)

        Dim meta As New PdfPTable(3)
        meta.WidthPercentage = 100
        meta.SetWidths(New Single() {34, 33, 33})
        meta.SpacingAfter = 14
        meta.AddCell(MetaCell("PO NUMBER", poNo))
        meta.AddCell(MetaCell("PO DATE", poDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture)))
        meta.AddCell(MetaCell("PREPARED BY", If(String.IsNullOrWhiteSpace(preparedBy), "-", preparedBy)))
        document.Add(meta)
    End Sub

    Private Sub AddVendorBlock(ByVal document As Document, ByVal vendorCode As String, ByVal vendorName As String)
        AddSectionLabel(document, "Supplier")

        Dim vendor As New PdfPTable(2)
        vendor.WidthPercentage = 100
        vendor.SetWidths(New Single() {28, 72})
        vendor.SpacingAfter = 14

        'vendor.AddCell(InfoLabel("Vendor code"))
        'vendor.AddCell(InfoValue(If(String.IsNullOrWhiteSpace(vendorCode), "-", vendorCode)))
        vendor.AddCell(InfoLabel("Suppiler name"))
        vendor.AddCell(InfoValue(If(String.IsNullOrWhiteSpace(vendorName), "-", vendorName)))
        document.Add(vendor)
    End Sub

    Private Sub AddSectionLabel(ByVal document As Document, ByVal text As String)
        Dim label As New Paragraph(text, SectionFont)
        label.SpacingBefore = 2
        label.SpacingAfter = 6
        document.Add(label)
    End Sub

    Private Function BuildLineTable(ByVal lines As DataTable) As PdfPTable
        Dim table As New PdfPTable(8)
        table.WidthPercentage = 100
        table.SetWidths(New Single() {6, 14, 26, 9, 11, 8, 13, 13})
        table.HeaderRows = 1
        table.SplitLate = False
        table.SplitRows = True
        table.SpacingAfter = 8

        table.AddCell(HeadCell("Srl", Element.ALIGN_CENTER))
        table.AddCell(HeadCell("Product code", Element.ALIGN_LEFT))
        table.AddCell(HeadCell("Product", Element.ALIGN_LEFT))
        table.AddCell(HeadCell("Qty", Element.ALIGN_RIGHT))
        table.AddCell(HeadCell("Rate", Element.ALIGN_RIGHT))
        table.AddCell(HeadCell("GST %", Element.ALIGN_RIGHT))
        table.AddCell(HeadCell("GST Amt", Element.ALIGN_RIGHT))
        table.AddCell(HeadCell("Amount", Element.ALIGN_RIGHT))

        Dim serial As Integer = 0
        For Each row As DataRow In lines.Rows
            serial += 1
            Dim shade As BaseColor = If(serial Mod 2 = 0, AltRow, White)
            Dim qty As Decimal = ReadDecimal(row, "Qty")
            Dim rate As Decimal = ReadDecimal(row, "Rate")
            Dim gstPercent As Decimal = ReadDecimal(row, "Gst")
            Dim basicAmount As Decimal = ProductBasic(qty, rate)
            Dim gstAmount As Decimal = If(HasAmount(row, "GstAmount"), ReadDecimal(row, "GstAmount"), LineGstAmount(basicAmount, gstPercent))
            Dim lineAmount As Decimal = If(HasAmount(row, "Amount"), ReadDecimal(row, "Amount"), basicAmount + gstAmount)
            table.AddCell(BodyCell(serial.ToString(), Element.ALIGN_CENTER, shade, BodyFont))
            table.AddCell(BodyCell(ReadText(row, "ProductCode"), Element.ALIGN_LEFT, shade, BodyFont))
            table.AddCell(BodyCell(ReadText(row, "ProductName"), Element.ALIGN_LEFT, shade, BodyFont))
            table.AddCell(BodyCell(qty.ToString("N2", CultureInfo.InvariantCulture), Element.ALIGN_RIGHT, shade, AmountFont))
            table.AddCell(BodyCell(rate.ToString("N2", CultureInfo.InvariantCulture), Element.ALIGN_RIGHT, shade, AmountFont))
            table.AddCell(BodyCell(gstPercent.ToString("0.##", CultureInfo.InvariantCulture), Element.ALIGN_RIGHT, shade, AmountFont))
            table.AddCell(BodyCell(gstAmount.ToString("N2", CultureInfo.InvariantCulture), Element.ALIGN_RIGHT, shade, AmountFont))
            table.AddCell(BodyCell(lineAmount.ToString("N2", CultureInfo.InvariantCulture), Element.ALIGN_RIGHT, shade, AmountFont))
        Next

        Return table
    End Function

    Private Function BuildTotals(ByVal lines As DataTable, ByVal freightGstPercent As Nullable(Of Decimal), ByVal freightCost As Decimal) As PdfPTable
        Dim lineTotal As Decimal = 0D
        For Each row As DataRow In lines.Rows
            Dim qty As Decimal = ReadDecimal(row, "Qty")
            Dim rate As Decimal = ReadDecimal(row, "Rate")
            Dim gstPercent As Decimal = ReadDecimal(row, "Gst")
            Dim basic As Decimal = ProductBasic(qty, rate)
            Dim gstAmount As Decimal = If(HasAmount(row, "GstAmount"), ReadDecimal(row, "GstAmount"), LineGstAmount(basic, gstPercent))
            Dim lineAmount As Decimal = If(HasAmount(row, "Amount"), ReadDecimal(row, "Amount"), basic + gstAmount)
            lineTotal += lineAmount
        Next

        Dim freightGstAmount As Decimal = 0D
        Dim freightGstText As String = "0%"
        If freightGstPercent.HasValue Then
            freightGstAmount = LineGstAmount(freightCost, freightGstPercent.Value)
            freightGstText = freightGstPercent.Value.ToString("0.##", CultureInfo.InvariantCulture) & "%"
        End If
        Dim freightTotal As Decimal = freightCost + freightGstAmount
        Dim grandTotal As Decimal = lineTotal + freightTotal

        Dim wrap As New PdfPTable(1)
        wrap.WidthPercentage = 100
        wrap.KeepTogether = True
        wrap.SpacingBefore = 4
        wrap.SpacingAfter = 12

        Dim totals As New PdfPTable(2)
        totals.WidthPercentage = 52
        totals.HorizontalAlignment = Element.ALIGN_RIGHT
        totals.SetWidths(New Single() {68, 32})
        totals.AddCell(TotalLabel("Total amount"))
        totals.AddCell(TotalValue(lineTotal.ToString("N2", CultureInfo.InvariantCulture)))
        totals.AddCell(TotalLabel("Freight (Including GST: " & freightGstText & ")"))
        totals.AddCell(TotalValue(freightTotal.ToString("N2", CultureInfo.InvariantCulture)))
        totals.AddCell(TotalLabel("Grand total"))
        totals.AddCell(TotalValue(grandTotal.ToString("N2", CultureInfo.InvariantCulture)))

        Dim holder As New PdfPCell(totals)
        holder.Border = Rectangle.NO_BORDER
        holder.Padding = 0
        wrap.AddCell(holder)
        Return wrap
    End Function

    Private Function BuildClosingBlock(ByVal preparedBy As String) As PdfPTable
        Dim block As New PdfPTable(2)
        block.WidthPercentage = 100
        block.KeepTogether = True
        block.SetWidths(New Single() {50, 50})
        block.SpacingBefore = 8

        block.AddCell(SignCell("Prepared by", preparedBy))
        block.AddCell(SignCell("Authorised signatory", ""))

        Dim note As New PdfPCell(New Phrase("This purchase order was generated from VMS. Line amount is quantity x rate plus GST on that line. Freight GST is included only when a rate is selected.", SmallFont))
        note.Colspan = 2
        note.Border = Rectangle.NO_BORDER
        note.PaddingTop = 14
        block.AddCell(note)
        Return block
    End Function

    Private Function MetaCell(ByVal label As String, ByVal value As String) As PdfPCell
        Dim inner As New PdfPTable(1)
        inner.WidthPercentage = 100
        Dim labelCell As New PdfPCell(New Phrase(label, LabelFont))
        labelCell.Border = Rectangle.NO_BORDER
        labelCell.Padding = 0
        labelCell.PaddingBottom = 2
        inner.AddCell(labelCell)

        Dim valueCell As New PdfPCell(New Phrase(value, ValueFont))
        valueCell.Border = Rectangle.NO_BORDER
        valueCell.Padding = 0
        inner.AddCell(valueCell)

        Dim cell As New PdfPCell(inner)
        cell.BackgroundColor = SoftBlue
        cell.BorderColor = Line
        cell.BorderWidth = 0.6F
        cell.PaddingTop = 8
        cell.PaddingBottom = 8
        cell.PaddingLeft = 10
        cell.PaddingRight = 10
        Return cell
    End Function

    Private Function InfoLabel(ByVal text As String) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, LabelFont))
        cell.BackgroundColor = AltRow
        cell.BorderColor = Line
        cell.PaddingTop = 7
        cell.PaddingBottom = 7
        cell.PaddingLeft = 8
        cell.VerticalAlignment = Element.ALIGN_MIDDLE
        Return cell
    End Function

    Private Function InfoValue(ByVal text As String) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, BodyFont))
        cell.BorderColor = Line
        cell.PaddingTop = 7
        cell.PaddingBottom = 7
        cell.PaddingLeft = 8
        cell.VerticalAlignment = Element.ALIGN_MIDDLE
        Return cell
    End Function

    Private Function HeadCell(ByVal text As String, ByVal align As Integer) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, HeaderFont))
        cell.BackgroundColor = HeaderFill
        cell.HorizontalAlignment = align
        cell.VerticalAlignment = Element.ALIGN_MIDDLE
        cell.Border = Rectangle.NO_BORDER
        cell.PaddingTop = 7
        cell.PaddingBottom = 7
        cell.PaddingLeft = 6
        cell.PaddingRight = 6
        Return cell
    End Function

    Private Function BodyCell(ByVal text As String, ByVal align As Integer, ByVal background As BaseColor, ByVal font As Font) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, font))
        cell.BackgroundColor = background
        cell.HorizontalAlignment = align
        cell.VerticalAlignment = Element.ALIGN_MIDDLE
        cell.BorderColor = Line
        cell.BorderWidth = 0.4F
        cell.PaddingTop = 6
        cell.PaddingBottom = 6
        cell.PaddingLeft = 6
        cell.PaddingRight = 6
        cell.MinimumHeight = 20
        Return cell
    End Function

    Private Function TotalLabel(ByVal text As String) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, LabelFont))
        cell.BackgroundColor = TotalFill
        cell.BorderColor = Line
        cell.PaddingTop = 6
        cell.PaddingBottom = 6
        cell.PaddingLeft = 8
        cell.HorizontalAlignment = Element.ALIGN_LEFT
        Return cell
    End Function

    Private Function TotalValue(ByVal text As String) As PdfPCell
        Dim cell As New PdfPCell(New Phrase(text, TotalFont))
        cell.BackgroundColor = TotalFill
        cell.BorderColor = Line
        cell.PaddingTop = 6
        cell.PaddingBottom = 6
        cell.PaddingRight = 8
        cell.HorizontalAlignment = Element.ALIGN_RIGHT
        Return cell
    End Function

    Private Function SignCell(ByVal caption As String, ByVal name As String) As PdfPCell
        Dim inner As New PdfPTable(1)
        inner.WidthPercentage = 100

        Dim lineCell As New PdfPCell(New Phrase(" "))
        lineCell.Border = Rectangle.BOTTOM_BORDER
        lineCell.BorderColor = Navy
        lineCell.BorderWidthBottom = 0.8F
        lineCell.FixedHeight = 36
        lineCell.Padding = 0
        inner.AddCell(lineCell)

        Dim nameCell As New PdfPCell(New Phrase(If(String.IsNullOrWhiteSpace(name), " ", name), BodyFont))
        nameCell.Border = Rectangle.NO_BORDER
        nameCell.PaddingTop = 4
        nameCell.PaddingBottom = 0
        inner.AddCell(nameCell)

        Dim captionCell As New PdfPCell(New Phrase(caption, LabelFont))
        captionCell.Border = Rectangle.NO_BORDER
        captionCell.PaddingTop = 1
        inner.AddCell(captionCell)

        Dim cell As New PdfPCell(inner)
        cell.Border = Rectangle.NO_BORDER
        cell.PaddingRight = 16
        cell.PaddingTop = 6
        Return cell
    End Function

    Private Shared Function ProductBasic(ByVal qty As Decimal, ByVal rate As Decimal) As Decimal
        Return Math.Round(qty * rate, 2, MidpointRounding.AwayFromZero)
    End Function

    Private Shared Function LineGstAmount(ByVal basicAmount As Decimal, ByVal gstPercent As Decimal) As Decimal
        Return Math.Round(basicAmount * gstPercent / 100D, 2, MidpointRounding.AwayFromZero)
    End Function

    Private Shared Function HasAmount(ByVal row As DataRow, ByVal columnName As String) As Boolean
        Return row IsNot Nothing AndAlso row.Table.Columns.Contains(columnName) AndAlso Not IsDBNull(row(columnName))
    End Function

    Private Function ReadText(ByVal row As DataRow, ByVal columnName As String) As String
        If row Is Nothing OrElse Not row.Table.Columns.Contains(columnName) OrElse IsDBNull(row(columnName)) Then
            Return ""
        End If
        Return Convert.ToString(row(columnName)).Trim()
    End Function

    Private Function ReadDecimal(ByVal row As DataRow, ByVal columnName As String) As Decimal
        If row Is Nothing OrElse Not row.Table.Columns.Contains(columnName) OrElse IsDBNull(row(columnName)) Then
            Return 0D
        End If
        Dim value As Decimal
        If Decimal.TryParse(Convert.ToString(row(columnName)), NumberStyles.Number, CultureInfo.InvariantCulture, value) Then
            Return value
        End If
        If Decimal.TryParse(Convert.ToString(row(columnName)), NumberStyles.Number, CultureInfo.CurrentCulture, value) Then
            Return value
        End If
        Return 0D
    End Function

    Private Class PurchaseOrderPageEvent
        Inherits PdfPageEventHelper

        Private ReadOnly _poNo As String

        Public Sub New(ByVal poNo As String)
            _poNo = poNo
        End Sub

        Public Overrides Sub OnEndPage(ByVal writer As PdfWriter, ByVal document As Document)
            Dim canvas As PdfContentByte = writer.DirectContent
            Dim page As Rectangle = document.PageSize

            canvas.SaveState()
            canvas.SetColorFill(Navy)
            canvas.Rectangle(0, page.Height - 28, page.Width, 28)
            canvas.Fill()
            canvas.RestoreState()

            ColumnText.ShowTextAligned(canvas, Element.ALIGN_LEFT, New Phrase("BERGER   |   VMS", WhiteSmall), 36, page.Height - 18, 0)
            ColumnText.ShowTextAligned(canvas, Element.ALIGN_RIGHT, New Phrase("Raw Material PO", WhiteSmall), page.Width - 36, page.Height - 18, 0)

            canvas.SaveState()
            canvas.SetColorStroke(Line)
            canvas.SetLineWidth(0.6F)
            canvas.MoveTo(36, 34)
            canvas.LineTo(page.Width - 36, 34)
            canvas.Stroke()
            canvas.RestoreState()

            ColumnText.ShowTextAligned(canvas, Element.ALIGN_LEFT, New Phrase("PO " & _poNo, SmallFont), 36, 20, 0)
            ColumnText.ShowTextAligned(canvas, Element.ALIGN_RIGHT, New Phrase("Page " & writer.PageNumber.ToString(), SmallFont), page.Width - 36, 20, 0)
        End Sub
    End Class
End Class
