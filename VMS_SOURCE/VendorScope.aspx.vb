Imports VMS.Web
Imports System.Data
Imports System.Collections.Generic

' Author: MUKESH BHAGAT  Created: 14-Oct-2026
' Modified-by MUKESH BHAGAT 15-Oct-2026: per VENDOR (unit) instead of supplier; packaging items removed; HO / SYSADMIN only;
'                                        searchable (select2) dropdowns, product autocomplete.
' Modified-by MUKESH BHAGAT 19-10-2026: packs are declared SHADE-WISE - one row per shade with its own pack list, so
'                                        Product_Formulation can offer exactly the packs of the shade that is picked.
' HO declares what each FG vendor makes: vertical > product > shades (none ticked = all) > packs per shade (none = all).
Partial Class VendorScope
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const NoShade As String = ""          ' shd_code of the single row shown for a product without shades

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

    ''' <summary>One table row per shade of the chosen product, each with the packs that exist for that shade
    ''' (shades from the SKU master, shade + pack pairs from mstr_sku). A product without shades gets one "(no shade)" row.</summary>
    Private Sub BindShadePacks()
        rptShades.DataSource = Nothing
        rptShades.DataBind()
        pnlShades.Visible = False
        Dim prd As String = hdnProductCode.Value.Trim()
        If prd = "" Then
            litShadeHint.Text = "Pick a product first."
            Exit Sub
        End If
        Dim obj As New OPC_VendorClass()

        ' shade + pack pairs of the product
        Dim packsByShade As New Dictionary(Of String, List(Of ListItem))(StringComparer.OrdinalIgnoreCase)
        Dim dsP As DataSet = obj.GetScopePacks(ddlVertical.SelectedValue, prd)
        If HasRows(dsP) Then
            For Each dr As DataRow In dsP.Tables(0).Rows
                Dim shd As String = Convert.ToString(dr("shd_code")).Trim()
                Dim desc As String = Convert.ToString(dr("pack_desc")).Trim()
                Dim code As String = Convert.ToString(dr("pack_code")).Trim()
                If Not packsByShade.ContainsKey(shd) Then packsByShade(shd) = New List(Of ListItem)()
                ' several pack codes can share one size ("1 L" = 001000 and 001008): one tag per size, value = every code of that size
                Dim same As ListItem = packsByShade(shd).Find(Function(x) x.Text = desc)
                If same Is Nothing Then packsByShade(shd).Add(New ListItem(desc, code)) Else same.Value &= "|" & code
            Next
        End If

        ' rows = shades of the product; a product without shades = one row keyed ""
        Dim rows As New DataTable()
        rows.Columns.Add("shd_code", GetType(String))
        rows.Columns.Add("shd_name", GetType(String))
        rows.Columns.Add("pack_hint", GetType(String))
        Dim dsS As DataSet = obj.GetShadeCodeList(prd)
        If HasRows(dsS) Then
            For Each dr As DataRow In dsS.Tables(0).Rows
                Dim code As String = Convert.ToString(dr("Shade_Code")).Trim()
                Dim cnt As Integer = If(packsByShade.ContainsKey(code), packsByShade(code).Count, 0)
                rows.Rows.Add(code, code & " - " & Convert.ToString(dr("Shade_Desc")).Trim(), If(cnt = 0, "no pack in the SKU master", cnt & " pack(s)"))
            Next
        End If
        If rows.Rows.Count = 0 Then
            ' no shade: every pack of the product in one row (packsByShade may still be keyed by a dummy shade code)
            Dim allPacks As New List(Of ListItem)()
            For Each kv In packsByShade
                For Each li In kv.Value
                    Dim same As ListItem = allPacks.Find(Function(x) x.Text = li.Text)
                    If same Is Nothing Then
                        allPacks.Add(New ListItem(li.Text, li.Value))
                    ElseIf Not ("|" & same.Value & "|").Contains("|" & li.Value & "|") Then
                        same.Value &= "|" & li.Value
                    End If
                Next
            Next
            packsByShade.Clear()
            packsByShade(NoShade) = allPacks
            rows.Rows.Add(NoShade, "(no shade)", allPacks.Count & " pack(s)")
        End If

        rptShades.DataSource = rows
        rptShades.DataBind()
        For Each item As RepeaterItem In rptShades.Items
            Dim shd As String = CType(item.FindControl("hdnShd"), HiddenField).Value
            Dim chk As CheckBox = CType(item.FindControl("chkShade"), CheckBox)
            Dim lst As ListBox = CType(item.FindControl("lstPacks"), ListBox)
            chk.InputAttributes("class") = "scope-shade-chk"
            chk.InputAttributes("onchange") = "vsShadeToggled(this);"
            chk.Checked = False
            If shd = NoShade Then chk.Checked = True : chk.Visible = False
            If packsByShade.ContainsKey(shd) Then
                For Each li In packsByShade(shd)
                    lst.Items.Add(New ListItem(li.Text, li.Value))
                Next
            End If
        Next
        pnlShades.Visible = True
        litShadeHint.Text = If(rows.Rows(0)("shd_code").ToString() = NoShade, "This product has no shades - choose its packs (empty = all).",
                               rows.Rows.Count & " shade(s). Tick the shades the vendor makes (none ticked = all) and, per shade, the packs (empty = all packs of that shade).")
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
        BindShadePacks()
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ClearValidation()
        Dim ok As Boolean = True
        If ddlVendor.SelectedValue = "" Then valVendor.Text = "Please select Vendor." : ok = False
        If ddlVertical.SelectedValue = "" Then valVertical.Text = "Please select Vertical." : ok = False
        If hdnProductCode.Value.Trim() = "" Then valProduct.Text = "Please select Product from the list." : ok = False
        If Not ok Then Exit Sub

        ' shades = ticked rows (none ticked = all shades); packs = the selected packs of every included row, with their shade
        Dim shades As New DataTable() : shades.Columns.Add("vss_shd_code", GetType(String))
        Dim packs As New DataTable() : packs.Columns.Add("vsp_shd_code", GetType(String)) : packs.Columns.Add("vsp_pack_code", GetType(String))
        Dim anyTicked As Boolean = False
        For Each item As RepeaterItem In rptShades.Items
            If CType(item.FindControl("chkShade"), CheckBox).Checked AndAlso CType(item.FindControl("hdnShd"), HiddenField).Value <> NoShade Then anyTicked = True
        Next
        For Each item As RepeaterItem In rptShades.Items
            Dim shd As String = CType(item.FindControl("hdnShd"), HiddenField).Value
            Dim ticked As Boolean = CType(item.FindControl("chkShade"), CheckBox).Checked
            If anyTicked AndAlso Not ticked AndAlso shd <> NoShade Then Continue For      ' excluded shade
            If shd <> NoShade AndAlso anyTicked Then shades.Rows.Add(shd)
            For Each li As ListItem In CType(item.FindControl("lstPacks"), ListBox).Items
                If li.Selected Then
                    For Each code As String In li.Value.Split("|"c)        ' one row per pack code of the chosen size
                        packs.Rows.Add(shd, code)
                    Next
                End If
            Next
        Next

        Dim msg As String = ""
        Dim saved As Boolean = New OPC_VendorClass().SaveScope(ddlVendor.SelectedValue, ddlVertical.SelectedValue, hdnProductCode.Value.Trim(), shades, packs, userInfo.userIDEntity, msg)
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

        BindShadePacks()
        ' declared shades -> ticked rows; declared packs -> selected in their shade's row ('' shade = every row)
        Dim declaredShades As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
        For Each dr As DataRow In ds.Tables(1).Rows
            declaredShades.Add(Convert.ToString(dr("code")).Trim())
        Next
        For Each item As RepeaterItem In rptShades.Items
            Dim shd As String = CType(item.FindControl("hdnShd"), HiddenField).Value
            Dim chk As CheckBox = CType(item.FindControl("chkShade"), CheckBox)
            If shd <> NoShade Then chk.Checked = declaredShades.Contains(shd)
            Dim lst As ListBox = CType(item.FindControl("lstPacks"), ListBox)
            For Each dr As DataRow In ds.Tables(2).Rows
                Dim pShd As String = Convert.ToString(dr("shd_code")).Trim()
                If pShd = "" OrElse String.Equals(pShd, shd, StringComparison.OrdinalIgnoreCase) Then
                    Dim stored As String = Convert.ToString(dr("code")).Trim()
                    For Each li As ListItem In lst.Items          ' a tag is selected when any of its pack codes was stored
                        If ("|" & li.Value & "|").Contains("|" & stored & "|") Then li.Selected = True
                    Next
                End If
            Next
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
        BindShadePacks()
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
