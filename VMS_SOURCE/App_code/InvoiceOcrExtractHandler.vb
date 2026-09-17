Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports System.IO
Imports System.Net
Imports System.Text
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Web.SessionState

Public Class InvoiceExtractResponse
    Public Property success As Boolean
    Public Property message As String
    Public Property invoice_no As String
    Public Property invoice_date As String
    Public Property amount As Decimal?
End Class

'Modified-by MUKESH BHAGAT on 27-08-2026 : switched to the COLOURANT_INV_AI structured
'extraction API. It returns nested data (party / invoice / tax / line_items); this handler
'flattens the fields the screens read (invoice_no, invoice_date, amount, total_quantity,
'supplier_gstn, recipient_gstn, eway_bill_no) so every consuming page keeps working with
'the same flat JSON contract as before.
'Modified-by MUKESH BHAGAT on 17-09-2026 : freight_amount (tax.freight_amount) added to the flat
'contract - the challan page needs it because the bill total = SKU taxable + freight + GST, and
'freight is not part of the SKU grid.
Public Class InvoiceOcrExtractHandler
    Implements IHttpHandler
    Implements IRequiresSessionState

    Private Const DefaultInvoiceOcrApiUrl As String = "https://bpilmobile.bergerindia.com/COLOURANT_INV_AI/api/invoice-data?use_ai=true&fast_mode=false"
    Private Const SessionInvoiceOcrTempFile As String = "InvoiceOcrTempFile"
    Private Const SessionInvoiceOcrFileName As String = "InvoiceOcrFileName"

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache)

        Try
            'If context.Session Is Nothing OrElse context.Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            '    WriteJson(context, False, "Session expired. Please login again.", Nothing)
            '    context.Response.StatusCode = 401
            '    Return
            'End If

            If Not String.Equals(context.Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase) Then
                WriteJson(context, False, "Only POST is allowed.", Nothing)
                context.Response.StatusCode = 405
                Return
            End If

            If context.Request.Files Is Nothing OrElse context.Request.Files.Count = 0 Then
                WriteJson(context, False, "Please select an invoice PDF file.", Nothing)
                context.Response.StatusCode = 400
                Return
            End If

            Dim uploaded = context.Request.Files(0)
            If uploaded Is Nothing OrElse uploaded.ContentLength <= 0 Then
                WriteJson(context, False, "Uploaded file is empty.", Nothing)
                context.Response.StatusCode = 400
                Return
            End If

            Dim fileName As String = Path.GetFileName(If(uploaded.FileName, "invoice.pdf"))
            If Not String.Equals(Path.GetExtension(fileName), ".pdf", StringComparison.OrdinalIgnoreCase) Then
                WriteJson(context, False, "Please upload a PDF invoice file.", Nothing)
                context.Response.StatusCode = 400
                Return
            End If

            Dim contentType As String = ResolveContentType(fileName, uploaded.ContentType)
            Dim fileBytes As Byte()

            Using ms As New MemoryStream()
                uploaded.InputStream.CopyTo(ms)
                fileBytes = ms.ToArray()
            End Using

            Dim apiResponseJson As String = PostMultipartToOcrApi(DefaultInvoiceOcrApiUrl, GetOcrApiKey(), fileName, contentType, fileBytes)

            'Modified-by MUKESH BHAGAT on 27-08-2026 : parse the structured COLOURANT_INV_AI
            'response and flatten it into the contract the screens read.
            Dim serializer As New JavaScriptSerializer()
            Dim apiResult As Dictionary(Of String, Object) = Nothing
            Try
                apiResult = serializer.Deserialize(Of Dictionary(Of String, Object))(apiResponseJson)
            Catch
                apiResult = Nothing
            End Try

            If apiResult Is Nothing OrElse Not GetBool(apiResult, "success") Then
                WriteJson(context, False, GetMessageOrDefault(apiResult, "Unable to extract invoice details."), Nothing)
                context.Response.StatusCode = 422
                Return
            End If

            'The AI service also classifies the document; a non-invoice PDF is rejected here.
            If apiResult.ContainsKey("is_invoice") AndAlso Not GetBool(apiResult, "is_invoice") Then
                WriteJson(context, False, "The uploaded PDF does not appear to be an invoice.", Nothing)
                context.Response.StatusCode = 422
                Return
            End If

            SaveInvoiceFileToSession(context, fileBytes, fileName)
            context.Response.Write(serializer.Serialize(FlattenAiResponse(apiResult)))
        Catch ex As WebException
            Dim errBody As String = String.Empty
            If ex.Response IsNot Nothing Then
                Using respStream = ex.Response.GetResponseStream()
                    If respStream IsNot Nothing Then
                        Using reader As New StreamReader(respStream)
                            errBody = reader.ReadToEnd()
                        End Using
                    End If
                End Using
            End If

            If Not String.IsNullOrWhiteSpace(errBody) Then
                context.Response.StatusCode = 502
                context.Response.Write(errBody)
            Else
                WriteJson(context, False, "Invoice OCR API call failed: " & ex.Message, Nothing)
                context.Response.StatusCode = 502
            End If
        Catch ex As Exception
            WriteJson(context, False, "Invoice OCR processing failed: " & ex.Message, Nothing)
            context.Response.StatusCode = 500
        End Try
    End Sub

    'Modified-by MUKESH BHAGAT on 27-08-2026 : helpers for the structured AI response.
    Private Shared Function GetBool(dict As Dictionary(Of String, Object), key As String) As Boolean
        If dict Is Nothing OrElse Not dict.ContainsKey(key) OrElse dict(key) Is Nothing Then
            Return False
        End If
        Return String.Equals(Convert.ToString(dict(key)), "True", StringComparison.OrdinalIgnoreCase)
    End Function

    Private Shared Function GetMessageOrDefault(dict As Dictionary(Of String, Object), fallback As String) As String
        If dict IsNot Nothing AndAlso dict.ContainsKey("message") AndAlso dict("message") IsNot Nothing Then
            Dim msg As String = Convert.ToString(dict("message"))
            If Not String.IsNullOrWhiteSpace(msg) Then
                Return msg
            End If
        End If
        Return fallback
    End Function

    Private Shared Function GetNested(dict As Dictionary(Of String, Object), section As String, key As String) As Object
        If dict Is Nothing OrElse Not dict.ContainsKey(section) Then
            Return Nothing
        End If
        Dim sub_ As Dictionary(Of String, Object) = TryCast(dict(section), Dictionary(Of String, Object))
        If sub_ Is Nothing OrElse Not sub_.ContainsKey(key) Then
            Return Nothing
        End If
        Return sub_(key)
    End Function

    'Builds the flat JSON contract the screens read. The nested response is passed through
    'under "detail" so nothing the API returns is lost to the client.
    Private Shared Function FlattenAiResponse(apiResult As Dictionary(Of String, Object)) As Dictionary(Of String, Object)
        Dim flat As New Dictionary(Of String, Object) From {
            {"success", True},
            {"message", GetMessageOrDefault(apiResult, String.Empty)},
            {"invoice_no", Convert.ToString(If(GetNested(apiResult, "invoice", "invoice_number"), String.Empty))},
            {"invoice_date", Convert.ToString(If(GetNested(apiResult, "invoice", "invoice_date"), String.Empty))},
            {"eway_bill_no", Convert.ToString(If(GetNested(apiResult, "invoice", "eway_bill_no"), String.Empty))},
            {"amount", GetNested(apiResult, "tax", "total_amount")},
            {"freight_amount", GetNested(apiResult, "tax", "freight_amount")},
            {"supplier_gstn", Convert.ToString(If(GetNested(apiResult, "party", "vendor_gstin"), String.Empty))},
            {"recipient_gstn", Convert.ToString(If(GetNested(apiResult, "party", "buyer_gstin"), String.Empty))}
        }

        'total_quantity = sum of the line-item quantities
        Dim totalQty As Decimal = 0
        Dim hasQty As Boolean = False
        If apiResult.ContainsKey("line_items") Then
            Dim items As Object() = TryCast(apiResult("line_items"), Object())
            If items IsNot Nothing Then
                For Each item As Object In items
                    Dim itemDict As Dictionary(Of String, Object) = TryCast(item, Dictionary(Of String, Object))
                    If itemDict IsNot Nothing AndAlso itemDict.ContainsKey("quantity") AndAlso itemDict("quantity") IsNot Nothing Then
                        Dim qty As Decimal
                        If Decimal.TryParse(Convert.ToString(itemDict("quantity")), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, qty) Then
                            totalQty += qty
                            hasQty = True
                        End If
                    End If
                Next
            End If
        End If
        If hasQty Then
            flat("total_quantity") = totalQty
        End If

        'full structured response, in case a screen wants line items etc.
        flat("detail") = apiResult
        Return flat
    End Function

    Private Shared Function GetOcrApiKey() As String
        Dim apiKey As String = ConfigurationManager.AppSettings("ColorantInvoiceOcrApiKey")
        Return If(apiKey, String.Empty).Trim()
    End Function

    Private Shared Function PostMultipartToOcrApi(apiUrl As String, apiKey As String, fileName As String, contentType As String, fileBytes As Byte()) As String
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 Or SecurityProtocolType.Tls11 Or SecurityProtocolType.Tls

        Dim boundary As String = "----InvoiceOcrBoundary" & DateTime.UtcNow.Ticks.ToString("x")
        Dim request As HttpWebRequest = CType(WebRequest.Create(apiUrl), HttpWebRequest)
        request.Method = "POST"
        request.Accept = "application/json"
        request.ContentType = "multipart/form-data; boundary=" & boundary
        request.Timeout = 120000
        request.ReadWriteTimeout = 120000

        If Not String.IsNullOrWhiteSpace(apiKey) Then
            request.Headers.Add("X-API-Key", apiKey.Trim())
        End If

        Dim preamble As String =
            "--" & boundary & vbCrLf &
            "Content-Disposition: form-data; name=""file""; filename=""" & fileName & """" & vbCrLf &
            "Content-Type: " & contentType & vbCrLf & vbCrLf

        Dim epilogue As String = vbCrLf & "--" & boundary & "--" & vbCrLf

        Dim preambleBytes As Byte() = Encoding.UTF8.GetBytes(preamble)
        Dim epilogueBytes As Byte() = Encoding.UTF8.GetBytes(epilogue)
        request.ContentLength = preambleBytes.Length + fileBytes.Length + epilogueBytes.Length

        Using reqStream = request.GetRequestStream()
            reqStream.Write(preambleBytes, 0, preambleBytes.Length)
            reqStream.Write(fileBytes, 0, fileBytes.Length)
            reqStream.Write(epilogueBytes, 0, epilogueBytes.Length)
        End Using

        Using response As HttpWebResponse = CType(request.GetResponse(), HttpWebResponse)
            Using respStream = response.GetResponseStream()
                Using reader As New StreamReader(respStream)
                    Return reader.ReadToEnd()
                End Using
            End Using
        End Using
    End Function

    Private Shared Function DeserializeInvoiceResponse(responseJson As String) As InvoiceExtractResponse
        If String.IsNullOrWhiteSpace(responseJson) Then
            Return Nothing
        End If

        Dim serializer As New JavaScriptSerializer()
        Return serializer.Deserialize(Of InvoiceExtractResponse)(responseJson)
    End Function

    Private Shared Function ResolveContentType(fileName As String, uploadedContentType As String) As String
        If Not String.IsNullOrWhiteSpace(uploadedContentType) AndAlso Not String.Equals(uploadedContentType, "application/octet-stream", StringComparison.OrdinalIgnoreCase) Then
            Return uploadedContentType
        End If

        If String.Equals(Path.GetExtension(fileName), ".pdf", StringComparison.OrdinalIgnoreCase) Then
            Return "application/pdf"
        End If

        Return "application/octet-stream"
    End Function

    Private Shared Sub SaveInvoiceFileToSession(context As HttpContext, fileBytes As Byte(), fileName As String)
        ClearSessionInvoiceFile(context)

        Dim tempFilePath As String = Path.Combine(Path.GetTempPath(), "VMS_Invoice_" & context.Session.SessionID & Path.GetExtension(fileName))
        File.WriteAllBytes(tempFilePath, fileBytes)

        context.Session(SessionInvoiceOcrTempFile) = tempFilePath
        context.Session(SessionInvoiceOcrFileName) = fileName
    End Sub

    Private Shared Sub ClearSessionInvoiceFile(context As HttpContext)
        If context.Session(SessionInvoiceOcrTempFile) IsNot Nothing Then
            Dim tempFilePath As String = Convert.ToString(context.Session(SessionInvoiceOcrTempFile))
            If Not String.IsNullOrEmpty(tempFilePath) AndAlso File.Exists(tempFilePath) Then
                Try
                    File.Delete(tempFilePath)
                Catch
                End Try
            End If
        End If

        context.Session.Remove(SessionInvoiceOcrTempFile)
        context.Session.Remove(SessionInvoiceOcrFileName)
    End Sub

    Private Shared Sub WriteJson(context As HttpContext, success As Boolean, message As String, ocrResult As InvoiceExtractResponse)
        Dim payload As New Dictionary(Of String, Object) From {
            {"success", success},
            {"message", message}
        }

        If ocrResult IsNot Nothing Then
            payload("invoice_no") = If(ocrResult.invoice_no, String.Empty)
            payload("invoice_date") = If(ocrResult.invoice_date, String.Empty)
            payload("amount") = ocrResult.amount
        End If

        Dim serializer As New JavaScriptSerializer()
        context.Response.Write(serializer.Serialize(payload))
    End Sub
End Class