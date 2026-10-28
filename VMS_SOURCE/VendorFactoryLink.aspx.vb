Imports VMS.Web
Imports System.Data
Imports System.Collections.Generic

' Author: MUKESH BHAGAT  Created: 26-Oct-2026
' Modified-by MUKESH BHAGAT 26-10-2026 (later): ONE factory per vendor, no distance (as instructed).
' HO links each FG vendor to the Berger factory nearest to it. HO and the Material Department compare the vendor's
' raw-material prices with the RM cost at that factory (LMIS_DB.dbo.PMAC_COST by org_code). HO groups / SYSADMIN only.
Partial Class VendorFactoryLink
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Private Sub CheckLogin()
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Dim g As String = Convert.ToString(userInfo.userGroupCodeEntity)
        If Not (g = Constant.UserFormAccess.HO OrElse g = Constant.UserFormAccess.HOMARKETING OrElse g = Constant.UserFormAccess.HOACCOUNTS OrElse g = Constant.UserFormAccess.SYSADMIN) Then
            Response.Redirect("~/Home.aspx")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            BindVendor()
            BindAll()
        End If
    End Sub

#Region "autocomplete"
    ''' <summary>Factories from MSTRDB.mstr_org (org_type FACTORY). Value = org_code, text = "300:Howrah - Mfg (SHIBPUR) [MFG]".</summary>
    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function FactorySearch(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim items As New List(Of String)()
        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 2 Then Return items.ToArray()
        Try
            Dim ds As DataSet = New OPC_VendorClass().GetVendorFactoryLookup(prefixText.Trim())
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim code As String = Convert.ToString(dr("org_code")).Trim()
                    Dim text As String = Convert.ToString(dr("org_name")).Trim() & If(Convert.ToString(dr("org_city")).Trim() <> "", " (" & Convert.ToString(dr("org_city")).Trim() & ")", "") &
                                         If(Convert.ToString(dr("depo_type")).Trim() <> "", " [" & Convert.ToString(dr("depo_type")).Trim() & "]", "")
                    If code <> "" Then items.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(text, code))
                Next
            End If
        Catch ex As Exception
            ' keep the autocomplete resilient
        End Try
        Return items.ToArray()
    End Function
#End Region

#Region "binders"
    Private Function HasRows(ByVal ds As DataSet) As Boolean
        Return ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0
    End Function

    Private Sub BindVendor()
        Dim ds As DataSet = New OPC_VendorClass().GetUnitName(Constant.Common.ActiveStatus)
        ddlVendor.Items.Clear()
        If HasRows(ds) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub BindAll()
        Dim ds As DataSet = New OPC_VendorClass().ListVendorFactoryLinks()
        gvAll.DataSource = If(HasRows(ds), ds.Tables(0), Nothing)
        gvAll.DataBind()
        litListSub.Text = If(HasRows(ds), ds.Tables(0).Rows.Count & " vendor(s) linked. Edit loads the vendor into the form above.", "No vendor linked yet.")
    End Sub

    ''' <summary>Shows the vendor's current factory and pre-fills the form with it.</summary>
    Private Sub LoadVendorLink()
        pnlCurrent.Visible = False
        txtFactorySearch.Text = "" : hdnOrgCode.Value = "" : txtRemarks.Text = ""
        If ddlVendor.SelectedValue = "" Then litHint.Text = "Select a vendor to see its factory." : Exit Sub
        Dim ds As DataSet = New OPC_VendorClass().GetVendorFactoryLinks(ddlVendor.SelectedValue, "Y")
        If HasRows(ds) Then
            Dim r As DataRow = ds.Tables(0).Rows(0)
            Dim text As String = Convert.ToString(r("vfl_org_code")).Trim() & " - " & Convert.ToString(r("org_name")).Trim() &
                                 If(Convert.ToString(r("org_city")).Trim() <> "", " (" & Convert.ToString(r("org_city")).Trim() & ")", "") &
                                 If(Convert.ToString(r("depo_type")).Trim() <> "", " [" & Convert.ToString(r("depo_type")).Trim() & "]", "")
            litCurrent.Text = Server.HtmlEncode(text) & If(Convert.ToString(r("vfl_remarks")).Trim() <> "", " <span class='vfl-sub'>" & Server.HtmlEncode(Convert.ToString(r("vfl_remarks"))) & "</span>", "")
            pnlCurrent.Visible = True
            hdnOrgCode.Value = Convert.ToString(r("vfl_org_code")).Trim()
            txtFactorySearch.Text = text
            txtRemarks.Text = Convert.ToString(r("vfl_remarks"))
            litHint.Text = "Pick another factory and press Save factory to replace it."
        Else
            litHint.Text = "No factory linked to " & Server.HtmlEncode(ddlVendor.SelectedItem.Text) & " yet - search the factory above and press Save factory."
        End If
    End Sub
#End Region

#Region "events"
    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        ClearValidation()
        LoadVendorLink()
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ClearValidation()
        If ddlVendor.SelectedValue = "" Then valVendor.Text = "Please select Vendor." : Exit Sub
        If hdnOrgCode.Value.Trim() = "" Then valFactory.Text = "Please select the factory from the list." : Exit Sub
        Dim msg As String = ""
        Dim ok As Boolean = New OPC_VendorClass().SaveVendorFactoryLink(ddlVendor.SelectedValue, hdnOrgCode.Value.Trim(), txtRemarks.Text, userInfo.userIDEntity, msg)
        If ok Then
            LoadVendorLink()
            BindAll()
        End If
        RmActionPopup.Show(Me, msg, ok)
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        ClearValidation()
        ddlVendor.ClearSelection()
        LoadVendorLink()
    End Sub

    Protected Sub gvAll_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName <> "EditVendor" Then Exit Sub
        Dim vendor As String = Convert.ToString(e.CommandArgument)
        If ddlVendor.Items.FindByValue(vendor) IsNot Nothing Then ddlVendor.SelectedValue = vendor
        ClearValidation()
        LoadVendorLink()
    End Sub

    Protected Sub gvAll_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.Header Then e.Row.TableSection = TableRowSection.TableHeader
    End Sub

    Private Sub ClearValidation()
        valVendor.Text = "" : valFactory.Text = "" : lblErrorMessage.Text = ""
    End Sub
#End Region
End Class
