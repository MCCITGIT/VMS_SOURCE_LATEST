
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Text
Imports VMS.Web

Partial Class Formulation_Rate_Revision
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateVendorList()
        End If
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
        Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

        If IsUnitUser() Then
            Dim own As String = OwnUnitCode()
            If ddlVendor.Items.FindByValue(own) IsNot Nothing Then
                ddlVendor.SelectedValue = own
            End If
            ddlVendor.Enabled = False
            colVendorFilter.Visible = False
        End If
        PopulateFormulation()
    End Sub

    Private Sub PopulateFormulation()
        ddlFormulation.Items.Clear()
        ClearRmList()
        ClearPkgList()

        If String.IsNullOrWhiteSpace(ddlVendor.SelectedValue) Then
            ddlFormulation.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Return
        End If

        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetFormulationList(ddlVendor.SelectedValue)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlFormulation.DataSource = ds.Tables(0)
            ddlFormulation.DataTextField = "sku_description"
            ddlFormulation.DataValueField = "sf_id"
            ddlFormulation.DataBind()
        End If
        ddlFormulation.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub PopulateRmList()
        ddlRmList.Items.Clear()
        Dim sfId As Integer
        If Integer.TryParse(ddlFormulation.SelectedValue, sfId) AndAlso sfId > 0 Then
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetFormulationRawmatList(sfId)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlRmList.DataSource = ds.Tables(0)
                ddlRmList.DataTextField = "rawmat_name"
                ddlRmList.DataValueField = "sfd_rawmat_code"
                ddlRmList.DataBind()
            End If
        End If
    End Sub

    Private Sub PopulatePkgList()
        ddlPkgList.Items.Clear()
        Dim sfId As Integer
        If Integer.TryParse(ddlFormulation.SelectedValue, sfId) AndAlso sfId > 0 Then
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetFormulationPackagingList(sfId)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ' 04-11-2026 MUKESH BHAGAT: one entry per packaging cost LINE ("50 K - 50 Kg bag ..."), value = pcd_id, so HO opens one specific packaging material
                Dim t As DataTable = ds.Tables(0).Copy()
                t.Columns.Add("pkg_text", GetType(String))
                For Each r As DataRow In t.Rows
                    r("pkg_text") = Convert.ToString(r("pch_pack_size")).Trim() & "  -  " & Convert.ToString(r("pcd_cost_name")).Trim()
                Next
                ddlPkgList.DataSource = t
                ddlPkgList.DataTextField = "pkg_text"
                ddlPkgList.DataValueField = "pcd_id"
                ddlPkgList.DataBind()
                RemoveBlankItems(ddlPkgList)
            End If
        End If
    End Sub

    Private Sub ClearRmList()
        ddlRmList.Items.Clear()
    End Sub

    Private Sub ClearPkgList()
        ddlPkgList.Items.Clear()
    End Sub

    Private Sub RemoveBlankItems(ByVal list As ListControl)
        For i As Integer = list.Items.Count - 1 To 0 Step -1
            If String.IsNullOrWhiteSpace(list.Items(i).Text) Then
                list.Items.RemoveAt(i)
            End If
        Next
    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateFormulation()
    End Sub

    Protected Sub ddlFormulation_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateRmList()
        PopulatePkgList()
    End Sub

    Private Function IsUnitUser() As Boolean
        Return userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT
    End Function

    Private Function OwnUnitCode() As String
        Return Convert.ToString(userInfo.userBranchEntity).Trim()
    End Function

    Protected Sub btnApprove_Click(sender As Object, e As EventArgs)
        lblErrorMessage.CssClass = "errormsg"
        lblErrorMessage.Text = String.Empty

        Dim sfId As Integer
        If Not Integer.TryParse(ddlFormulation.SelectedValue, sfId) OrElse sfId <= 0 Then
            lblErrorMessage.Text = "Please select a formulation."
            Return
        End If

        Dim rawmat As DataTable = SelectedRawmat()
        If rawmat.Rows.Count = 0 Then
            lblErrorMessage.Text = "Please select at least one raw material."
            Return
        End If

        Dim packs As DataTable = SelectedPacks()

        Try
            Dim obj As New OPC_VendorClass()
            obj.ApproveFormulationRawmatRevision(sfId, rawmat, userInfo.userIDEntity)
            If packs.Rows.Count > 0 Then
                obj.ApproveFormulationPackagingRevision(sfId, packs, userInfo.userIDEntity)
            End If
            Dim note As String = SendRateRevisionMail(sfId)
            Dim done As String = If(packs.Rows.Count > 0, "Permission given: the vendor can now change the rates of the selected raw materials and packaging.", "Permission given: the vendor can now change the rates of the selected raw materials.")
            lblErrorMessage.Text = String.Empty
            RmActionPopup.ShowSuccess(Me, done & If(note = "", " The vendor has been mailed.", " " & note))
        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    ''' <summary>Mail to the selected vendor after a rate revision is marked. Recipients come from
    ''' [opc_sku_formulation_vendor_email]. A mail failure does not undo the flag update. Returns "" when sent.</summary>
    Private Function SendRateRevisionMail(ByVal sfId As Integer) As String
        Dim toAddress As String = ""
        Dim ccAddress As String = ""
        Dim bccAddress As String = ""
        Try
            Dim dsMail As DataSet = New OPC_VendorClass().GetSkuFormulationVendorEmail(ddlVendor.SelectedValue.Trim())
            If dsMail IsNot Nothing AndAlso dsMail.Tables.Count > 0 AndAlso dsMail.Tables(0).Rows.Count > 0 Then
                toAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("TOAddr")).Trim()
                ccAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("CCAddr")).Trim()
                bccAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("BCCAddr")).Trim()
            End If
        Catch ex As Exception
            Return "Vendor mail NOT sent - recipient lookup failed."
        End Try
        If toAddress = "" Then Return "Vendor mail NOT sent - no address configured."
        Try
            Dim link As String = FormulationLink(sfId)
            Dim td As String = "style='border:1px solid #999;padding:4px 8px;'"
            Dim vendorName As String = If(ddlVendor.SelectedItem Is Nothing, ddlVendor.SelectedValue, ddlVendor.SelectedItem.Text)
            Dim formulationName As String = If(ddlFormulation.SelectedItem Is Nothing, Convert.ToString(sfId), ddlFormulation.SelectedItem.Text)
            Dim sb As New StringBuilder()
            sb.Append("<p>Dear Vendor,</p><p>HO has opened your approved SKU formulation for a rate revision. Please open it in VMS, press <b>Propose change</b> and change <b>only the rates of the items listed below</b>. Everything else is locked. HO will approve the new rates and tell you from which date they apply; until then the current rates stay in force.</p>")
            sb.Append("<table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr><td " & td & "><b>Vendor</b></td><td " & td & ">" & Server.HtmlEncode(vendorName) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>Formulation</b></td><td " & td & ">" & Server.HtmlEncode(formulationName) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>By</b></td><td " & td & ">" & Server.HtmlEncode(userInfo.userIDEntity) & " on " & DateTime.Now.ToString("dd/MM/yyyy HH:mm") & "</td></tr>")
            sb.Append("</table><br/>")

            sb.Append("<b>Raw materials</b><table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr style='background:#375973;color:#fff;'><th " & td & ">Raw material</th></tr>")
            For Each item As ListItem In ddlRmList.Items
                If item.Selected AndAlso Not String.IsNullOrWhiteSpace(item.Value) Then
                    sb.Append("<tr><td " & td & ">" & Server.HtmlEncode(item.Text) & " (" & Server.HtmlEncode(item.Value) & ")</td></tr>")
                End If
            Next
            sb.Append("</table><br/>")

            Dim packLines As New List(Of String)()
            For Each item As ListItem In ddlPkgList.Items
                If item.Selected AndAlso Not String.IsNullOrWhiteSpace(item.Text) Then
                    packLines.Add(Server.HtmlEncode(item.Text))
                End If
            Next
            If packLines.Count > 0 Then
                sb.Append("<b>Packaging</b><table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
                sb.Append("<tr style='background:#375973;color:#fff;'><th " & td & ">Cost</th></tr>")
                For Each line As String In packLines
                    sb.Append("<tr><td " & td & ">" & line & "</td></tr>")
                Next
                sb.Append("</table><br/>")
            End If

            sb.Append("<p><a href='" & link & "'>Open the formulation in VMS</a></p>")
            sb.Append("<h4 style='color:darkred;'>**This is an auto-generated mail. Please do not reply to this mail**</h4>")

            Dim mailEntity As New MailEntity()
            mailEntity.FromAddress = ConfigurationManager.AppSettings("EMAIL_ADDRESS")
            mailEntity.ToAddress = toAddress
            mailEntity.CCAddress = ccAddress
            mailEntity.BCCAddress = bccAddress
            mailEntity.MailSubject = "SKU formulation - rate revision: " & formulationName & " - " & vendorName
            mailEntity.MailBody = sb.ToString()
            mailEntity.Sender_App = "VMS"
            mailEntity.Sender_Task = "SkuFormulationRateRevision"
            Dim rc As Integer = New EmailSMSsender().sendMail(mailEntity)
            If rc = 0 Then Return "Vendor mail NOT sent - mail service rejected it (to: " & toAddress & ")"
            Return ""
        Catch ex As Exception
            Return "Vendor mail NOT sent."
        End Try
    End Function

    Private Function FormulationLink(ByVal sfId As Integer) As String
        ' 04-11-2026: scheme + host + application path of the request the user is working on (UAT on UAT, production on production) - no hard-coded address
        Return Request.Url.GetLeftPart(UriPartial.Authority) & ResolveUrl("~/Product_Formulation.aspx?id=" & sfId)
    End Function

    Private Function SelectedRawmat() As DataTable
        Dim rawmat As New DataTable()
        rawmat.Columns.Add("rawmat_code", GetType(String))
        For Each item As ListItem In ddlRmList.Items
            If item.Selected AndAlso Not String.IsNullOrWhiteSpace(item.Value) Then
                rawmat.Rows.Add(item.Value.Trim())
            End If
        Next
        Return rawmat
    End Function

    Private Function SelectedPacks() As DataTable
        Dim packs As New DataTable()
        packs.Columns.Add("pcd_id", GetType(Integer))          ' 04-11-2026: packaging cost lines (dbo.tbl_opc_rate_revision_pcd)
        Dim seen As New List(Of Integer)()
        For Each item As ListItem In ddlPkgList.Items
            Dim pcdId As Integer
            If item.Selected AndAlso Integer.TryParse(item.Value, pcdId) AndAlso pcdId > 0 AndAlso Not seen.Contains(pcdId) Then
                seen.Add(pcdId)
                packs.Rows.Add(pcdId)
            End If
        Next
        Return packs
    End Function

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Formulation_Rate_Revision_List.aspx")
    End Sub
End Class
