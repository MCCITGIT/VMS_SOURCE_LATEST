Imports System.Data
Imports System.IO
Imports System.Text.RegularExpressions
Imports VMS.Web

Partial Class RawMaterialPoPdf
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        Dim poNo As String = If(Request.QueryString("po"), "").Trim()
        Dim dateFolder As String = If(Request.QueryString("folder"), "").Trim()
        Dim fileName As String = If(Request.QueryString("file"), "").Trim()

        If poNo <> "" Then
            If Not Regex.IsMatch(poNo, "^[A-Za-z0-9]+$") Then
                Response.StatusCode = 400
                Response.End()
                Return
            End If

            Dim doc As DataSet = New POLinkingRequestClass().GetRawMaterialPoDocument(poNo)
            If doc Is Nothing OrElse doc.Tables.Count = 0 OrElse doc.Tables(0).Rows.Count = 0 Then
                Response.StatusCode = 404
                Response.End()
                Return
            End If

            dateFolder = If(Convert.ToString(doc.Tables(0).Rows(0)("rmph_doc_path")), "").Trim()
            fileName = If(Convert.ToString(doc.Tables(0).Rows(0)("rmph_doc_name")), "").Trim()
        End If

        If Not Regex.IsMatch(dateFolder, "^\d{2}_\d{2}_\d{4}$") OrElse Not Regex.IsMatch(fileName, "^[0-9a-fA-F\-]{36}_[A-Za-z0-9]+\.pdf$") Then
            Response.StatusCode = 400
            Response.End()
            Return
        End If

        Dim root As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH")
        Dim rootFull As String = Path.GetFullPath(root)
        If Not rootFull.EndsWith(Path.DirectorySeparatorChar) Then
            rootFull &= Path.DirectorySeparatorChar
        End If

        Dim fullPath As String = Path.GetFullPath(Path.Combine(root, dateFolder, fileName))
        If Not fullPath.StartsWith(rootFull, StringComparison.OrdinalIgnoreCase) OrElse Not File.Exists(fullPath) Then
            Response.StatusCode = 404
            Response.End()
            Return
        End If

        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AddHeader("Content-Disposition", "inline; filename=""" & fileName & """")
        Response.TransmitFile(fullPath)
        Response.Flush()
        Response.End()
    End Sub
End Class
