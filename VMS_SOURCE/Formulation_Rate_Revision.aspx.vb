
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
        cblFormulation.Items.Clear()
        chkSelectAll.Checked = False

        If String.IsNullOrWhiteSpace(ddlVendor.SelectedValue) Then
            Return
        End If

        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetFormulationList(ddlVendor.SelectedValue)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            cblFormulation.DataSource = ds.Tables(0)
            cblFormulation.DataTextField = "sku_description"
            cblFormulation.DataValueField = "sf_id"
            cblFormulation.DataBind()
            MarkApprovedFormulations()
        End If
    End Sub

    Private Sub MarkApprovedFormulations()
        Dim ds As DataSet = New OPC_VendorClass().GetFormulationRateRevisionFlagged(ddlVendor.SelectedValue)
        If ds Is Nothing Then
            Return
        End If

        Dim approved As New List(Of String)()
        For Each tbl As DataTable In ds.Tables
            If Not tbl.Columns.Contains("sf_id") Then
                Continue For
            End If
            For Each row As DataRow In tbl.Rows
                Dim sfId As String = Convert.ToString(row("sf_id")).Trim()
                If sfId <> "" AndAlso Not approved.Contains(sfId) Then
                    approved.Add(sfId)
                End If
            Next
        Next

        Dim checkedCount As Integer = 0
        For Each item As ListItem In cblFormulation.Items
            If approved.Contains(item.Value.Trim()) Then
                item.Selected = True
                checkedCount += 1
            End If
        Next
        chkSelectAll.Checked = (cblFormulation.Items.Count > 0 AndAlso checkedCount = cblFormulation.Items.Count)
    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateFormulation()
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

        Dim selected As List(Of ListItem) = SelectedFormulations()
        If selected.Count = 0 Then
            lblErrorMessage.Text = "Please select at least one formulation."
            Return
        End If

        Try
            Dim obj As New OPC_VendorClass()
            obj.ApproveFormulationRateRevision(SelectedFormulationIds(selected), userInfo.userIDEntity)
            Dim note As String = SendRateRevisionMail(selected)
            PopulateFormulation()
            lblErrorMessage.Text = String.Empty
            RmActionPopup.ShowSuccess(Me, "Permission given: the vendor can now change the rates of all raw materials and packaging for the selected formulation(s)." & If(note = "", " The vendor has been mailed.", " " & note))
        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    ''' <summary>Mail to the selected vendor after a rate revision is marked. Recipients come from
    ''' [opc_sku_formulation_vendor_email]. A mail failure does not undo the flag update. Returns "" when sent.</summary>
    Private Function SendRateRevisionMail(ByVal selected As List(Of ListItem)) As String
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
            Dim td As String = "style='border:1px solid #999;padding:4px 8px;'"
            Dim vendorName As String = If(ddlVendor.SelectedItem Is Nothing, ddlVendor.SelectedValue, ddlVendor.SelectedItem.Text)
            Dim sb As New StringBuilder()
            sb.Append("<p>Dear Vendor,</p><p>HO has opened your approved SKU formulation(s) for a rate revision. Please open each formulation in VMS, press <b>Propose change</b> and change the rates of <b>all raw materials and packaging</b>. Everything else is locked. HO will approve the new rates and tell you from which date they apply; until then the current rates stay in force.</p>")
            sb.Append("<table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr><td " & td & "><b>Vendor</b></td><td " & td & ">" & Server.HtmlEncode(vendorName) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>By</b></td><td " & td & ">" & Server.HtmlEncode(userInfo.userIDEntity) & " on " & DateTime.Now.ToString("dd/MM/yyyy HH:mm") & "</td></tr>")
            sb.Append("</table><br/>")

            sb.Append("<b>Formulations</b><table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr style='background:#375973;color:#fff;'><th " & td & ">Formulation</th><th " & td & ">Link</th></tr>")
            For Each item As ListItem In selected
                Dim sfId As Integer
                Integer.TryParse(item.Value, sfId)
                sb.Append("<tr><td " & td & ">" & Server.HtmlEncode(item.Text) & "</td><td " & td & "><a href='" & FormulationLink(sfId) & "'>Open in VMS</a></td></tr>")
            Next
            sb.Append("</table><br/>")
            sb.Append("<h4 style='color:darkred;'>**This is an auto-generated mail. Please do not reply to this mail**</h4>")

            Dim mailEntity As New MailEntity()
            mailEntity.FromAddress = ConfigurationManager.AppSettings("EMAIL_ADDRESS")
            mailEntity.ToAddress = toAddress
            mailEntity.CCAddress = ccAddress
            mailEntity.BCCAddress = bccAddress
            mailEntity.MailSubject = "SKU formulation - rate revision: " & vendorName
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
        Return Request.Url.GetLeftPart(UriPartial.Authority) & ResolveUrl("~/Product_Formulation.aspx?id=" & sfId)
    End Function

    Private Function SelectedFormulations() As List(Of ListItem)
        Dim selected As New List(Of ListItem)()
        For Each item As ListItem In cblFormulation.Items
            Dim sfId As Integer
            If item.Selected AndAlso Integer.TryParse(item.Value, sfId) AndAlso sfId > 0 Then
                selected.Add(item)
            End If
        Next
        Return selected
    End Function

    Private Function SelectedFormulationIds(ByVal selected As List(Of ListItem)) As DataTable
        Dim sfIds As New DataTable()
        sfIds.Columns.Add("sf_id", GetType(Integer))
        For Each item As ListItem In selected
            sfIds.Rows.Add(Convert.ToInt32(item.Value))
        Next
        Return sfIds
    End Function

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Formulation_Rate_Revision_List.aspx")
    End Sub
End Class
