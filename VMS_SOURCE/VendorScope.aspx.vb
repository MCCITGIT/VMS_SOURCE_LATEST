Imports VMS.Web
Imports System.Data
Imports System.Collections.Generic

' Author: MUKESH BHAGAT  Created: 14-Oct-2026
' Modified-by MUKESH BHAGAT 15-Oct-2026: per VENDOR (unit) instead of supplier; packaging items removed;
'                                        HO / SYSADMIN only; searchable (select2) dropdowns, product autocomplete, shade / pack tag lists.
' HO declares what each FG vendor makes: vertical > product > shades (none = all) > packs (none = all).
' Product_Formulation offers a vendor only what is declared here.
Partial Class VendorScope
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    ''' <summary>HO groups and SYSADMIN only (same rule as the HO side of Product_Formulation). Vendors never open this page.</summary>
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
        aceProductSearch.ContextKey = ddlVertical.SelectedValue      ' product autocomplete searches inside the selected vertical
        If Not IsPostBack Then
            BindVendor()
            BindVertical()
            BindGrid()
        End If
    End Sub

#Region "autocomplete"
    ''' <summary>Products of the vertical passed as context key (opc_vendor_scope_lookup_product). Value = product code, text = "code-description".</summary>
    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function ProductSearch(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As String()
        Dim items As New List(Of String)()
        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 OrElse String.IsNullOrWhiteSpace(contextKey) Then Return items.ToArray()
        Try
            Dim ds As DataSet = New OPC_VendorClass().GetScopeProducts(contextKey.Trim(), prefixText.Trim())
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim code As String = Convert.ToString(dr("prd_code")).Trim()
                    Dim name As String = Convert.ToString(dr("prd_name")).Trim()
                    If code <> "" AndAlso name <> "" Then items.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(name, code))
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

    Private Sub BindVertical()
        Dim ds As DataSet = New OPC_VendorClass().GetScopeVerticals()
        ddlVertical.Items.Clear()
        If HasRows(ds) Then
            ddlVertical.DataSource = ds.Tables(0)
            ddlVertical.DataTextField = "sbl"
            ddlVertical.DataValueField = "sbl"
            ddlVertical.DataBind()
        End If
        ddlVertical.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    ''' <summary>Shade and pack lists of the chosen product (shades from the SKU master, packs from mstr_sku).</summary>
    Private Sub BindShadePack()
        lstShade.Items.Clear()
        lstPack.Items.Clear()
        Dim prd As String = hdnProductCode.Value.Trim()
        If prd = "" Then
            litShadeHint.Text = "Pick a product first. Leave empty to allow every shade."
            litPackHint.Text = "Pick a product first. Leave empty to allow every pack."
            Exit Sub
        End If
        Dim obj As New OPC_VendorClass()

        Dim dsS As DataSet = obj.GetShadeCodeList(prd)
        If HasRows(dsS) Then
            For Each dr As DataRow In dsS.Tables(0).Rows
                Dim code As String = Convert.ToString(dr("Shade_Code")).Trim()
                lstShade.Items.Add(New ListItem(code & " - " & Convert.ToString(dr("Shade_Desc")).Trim(), code))
            Next
        End If
        litShadeHint.Text = If(lstShade.Items.Count = 0, "This product has no shades.", lstShade.Items.Count & " shade(s) available. Leave empty to allow all of them.")

        Dim dsP As DataSet = obj.GetScopePacks(ddlVertical.SelectedValue, prd)
        If HasRows(dsP) Then
            For Each dr As DataRow In dsP.Tables(0).Rows
                lstPack.Items.Add(New ListItem(Convert.ToString(dr("pack_desc")).Trim(), Convert.ToString(dr("pack_code")).Trim()))
            Next
        End If
        litPackHint.Text = If(lstPack.Items.Count = 0, "No pack found for this product in the SKU master.", lstPack.Items.Count & " pack(s) available. Leave empty to allow all of them.")
    End Sub

    Private Sub BindGrid()
        ' always every vendor: changing the vendor in the form must not empty or reload anything
        Dim ds As DataSet = New OPC_VendorClass().GetScopeList("", "Y")
        gvScope.DataSource = If(HasRows(ds), ds.Tables(0), Nothing)
        gvScope.DataBind()
        litListSub.Text = If(HasRows(ds), ds.Tables(0).Rows.Count & " active scope(s) across all vendors. Edit opens one in the form above.", "No scope declared yet.")
    End Sub
#End Region

#Region "events"
    Protected Sub btnProductPicked_Click(sender As Object, e As EventArgs)
        BindShadePack()
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ClearValidation()
        Dim ok As Boolean = True
        If ddlVendor.SelectedValue = "" Then valVendor.Text = "Please select Vendor." : ok = False
        If ddlVertical.SelectedValue = "" Then valVertical.Text = "Please select Vertical." : ok = False
        If hdnProductCode.Value.Trim() = "" Then valProduct.Text = "Please select Product from the list." : ok = False
        If Not ok Then Exit Sub

        Dim msg As String = ""
        Dim saved As Boolean = New OPC_VendorClass().SaveScope(ddlVendor.SelectedValue, ddlVertical.SelectedValue, hdnProductCode.Value.Trim(),
                                                             SelectedCodes("vss_shd_code", lstShade), SelectedCodes("vsp_pack_code", lstPack),
                                                             userInfo.userIDEntity, msg)
        If saved Then
            ClearForm()
            BindGrid()
        End If
        RmActionPopup.Show(Me, msg, saved)
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        ClearForm()
    End Sub

    Protected Sub gvScope_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim vsId As Integer = 0
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), vsId) Then Exit Sub
        Select Case e.CommandName
            Case "DeactivateScope"
                Dim msg As String = New OPC_VendorClass().SetScopeActive(vsId, "N", userInfo.userIDEntity)
                BindGrid()
                RmActionPopup.Show(Me, msg, True)
            Case "EditScope"
                LoadScope(vsId)
        End Select
    End Sub

    Protected Sub gvScope_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.Header Then e.Row.TableSection = TableRowSection.TableHeader
    End Sub
#End Region

#Region "helpers"
    Private Function SelectedCodes(ByVal colName As String, ByVal lb As ListBox) As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add(colName, GetType(String))
        For Each li As ListItem In lb.Items
            If li.Selected Then dt.Rows.Add(li.Value)
        Next
        Return dt
    End Function

    ''' <summary>Fills the form from a saved scope. Saving again replaces that scope (same vendor + vertical + product).</summary>
    Private Sub LoadScope(ByVal vsId As Integer)
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetScope(vsId)
        If Not HasRows(ds) Then Exit Sub
        Dim h As DataRow = ds.Tables(0).Rows(0)
        ClearValidation()

        Dim vendor As String = Convert.ToString(h("vs_vendor_code")).Trim()
        Dim sbl As String = Convert.ToString(h("vs_sbl")).Trim()
        Dim prd As String = Convert.ToString(h("vs_prd_code")).Trim()
        If ddlVendor.Items.FindByValue(vendor) IsNot Nothing Then ddlVendor.SelectedValue = vendor
        If ddlVertical.Items.FindByValue(sbl) IsNot Nothing Then ddlVertical.SelectedValue = sbl
        aceProductSearch.ContextKey = sbl

        ' product text = "code-description" from the same lookup the autocomplete uses
        hdnProductCode.Value = prd
        hdnProductName.Value = prd
        Dim dsP As DataSet = obj.GetScopeProducts(sbl, prd)
        If HasRows(dsP) Then
            For Each r As DataRow In dsP.Tables(0).Rows
                If Convert.ToString(r("prd_code")).Trim() = prd Then hdnProductName.Value = Convert.ToString(r("prd_name")).Trim() : Exit For
            Next
        End If
        txtProductSearch.Text = hdnProductName.Value

        BindShadePack()
        For Each dr As DataRow In ds.Tables(1).Rows
            Dim li As ListItem = lstShade.Items.FindByValue(Convert.ToString(dr("code")))
            If li IsNot Nothing Then li.Selected = True
        Next
        For Each dr As DataRow In ds.Tables(2).Rows
            Dim li As ListItem = lstPack.Items.FindByValue(Convert.ToString(dr("code")))
            If li IsNot Nothing Then li.Selected = True
        Next
        litFormTitle.Text = "Edit scope - " & Server.HtmlEncode(ddlVendor.SelectedItem.Text & " / " & prd)
        BindGrid()
    End Sub

    ''' <summary>Clears everything except the vendor (HO usually declares several products for the same vendor).</summary>
    Private Sub ClearForm()
        ClearValidation()
        ddlVertical.ClearSelection()
        aceProductSearch.ContextKey = ""
        txtProductSearch.Text = ""
        hdnProductCode.Value = ""
        hdnProductName.Value = ""
        BindShadePack()
        litFormTitle.Text = "Declare scope"
    End Sub

    Private Sub ClearValidation()
        valVendor.Text = ""
        valVertical.Text = ""
        valProduct.Text = ""
        lblErrorMessage.Text = ""
    End Sub
#End Region
End Class
