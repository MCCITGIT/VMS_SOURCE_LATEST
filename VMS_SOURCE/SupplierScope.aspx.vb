Imports VMS.Web
Imports System.Data

' Author: MUKESH BHAGAT  Created: 14-Oct-2026
' The FG vendor picks a supplier and declares what it may quote: vertical > product > shade > pack > packaging items.
' Product_Formulation later offers only what is declared here. The supplier never logs in.
Partial Class SupplierScope
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const EditIdKey As String = "SupplierScopeEditId"

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            BindSupplier()
            BindVertical()
            ResetProduct()
            BindGrid()
        End If
    End Sub

#Region "Binders"
    Private Function HasRows(ByVal ds As DataSet) As Boolean
        Return ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0
    End Function

    Private Sub BindSupplier()
        Dim ds As DataSet = New OPC_VendorClass().GetRawMaterialVendorList()
        ddlSupplier.Items.Clear()
        If HasRows(ds) Then
            ddlSupplier.DataSource = ds.Tables(0)
            ddlSupplier.DataTextField = "vendor_name"
            ddlSupplier.DataValueField = "vendor_code"
            ddlSupplier.DataBind()
        End If
        ddlSupplier.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
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

    Private Sub BindProducts()
        ddlProduct.Items.Clear()
        If ddlVertical.SelectedValue <> "" Then
            Dim ds As DataSet = New OPC_VendorClass().GetScopeProducts(ddlVertical.SelectedValue, txtProductSearch.Text)
            If HasRows(ds) Then
                ddlProduct.DataSource = ds.Tables(0)
                ddlProduct.DataTextField = "prd_name"
                ddlProduct.DataValueField = "prd_code"
                ddlProduct.DataBind()
            End If
        End If
        ddlProduct.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub ResetProduct()
        txtProductSearch.Text = String.Empty
        BindProducts()
        lstShade.Items.Clear()
        lstPack.Items.Clear()
    End Sub

    ' Shade and pack depend on the chosen product.
    Private Sub BindShadePack()
        lstShade.Items.Clear()
        lstPack.Items.Clear()
        If ddlProduct.SelectedValue = "" Then Exit Sub
        Dim obj As New OPC_VendorClass()

        Dim dsS As DataSet = obj.GetShadeCodeList(ddlProduct.SelectedValue)
        If HasRows(dsS) Then
            For Each dr As DataRow In dsS.Tables(0).Rows
                Dim code As String = Convert.ToString(dr("Shade_Code")).Trim()
                lstShade.Items.Add(New ListItem(code & " - " & Convert.ToString(dr("Shade_Desc")).Trim(), code))
            Next
        End If

        Dim dsP As DataSet = obj.GetScopePacks(ddlVertical.SelectedValue, ddlProduct.SelectedValue)
        If HasRows(dsP) Then
            For Each dr As DataRow In dsP.Tables(0).Rows
                lstPack.Items.Add(New ListItem(Convert.ToString(dr("pack_desc")).Trim(), Convert.ToString(dr("pack_code")).Trim()))
            Next
        End If
    End Sub

    Private Sub BindGrid()
        Dim ds As DataSet = New OPC_VendorClass().GetScopeList(ddlSupplier.SelectedValue, "Y")
        gvScope.DataSource = If(HasRows(ds), ds.Tables(0), Nothing)
        gvScope.DataBind()
    End Sub
#End Region

#Region "Filters"
    Protected Sub ddlSupplier_SelectedIndexChanged(sender As Object, e As EventArgs)
        ClearForm()
        BindGrid()
    End Sub

    Protected Sub ddlVertical_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetProduct()
    End Sub

    Protected Sub btnProductSearch_Click(sender As Object, e As EventArgs)
        BindProducts()
    End Sub

    Protected Sub ddlProduct_SelectedIndexChanged(sender As Object, e As EventArgs)
        BindShadePack()
    End Sub

    Protected Sub btnItemSearch_Click(sender As Object, e As EventArgs)
        lstItemAvail.Items.Clear()
        Dim ds As DataSet = New OPC_VendorClass().GetScopeItems(txtItemSearch.Text)
        If HasRows(ds) Then
            For Each dr As DataRow In ds.Tables(0).Rows
                lstItemAvail.Items.Add(New ListItem(Convert.ToString(dr("item_name")).Trim() & " [" & Convert.ToString(dr("costclass")).Trim() & "]", Convert.ToString(dr("item_code")).Trim()))
            Next
        End If
    End Sub

    Protected Sub btnItemAdd_Click(sender As Object, e As EventArgs)
        For Each li As ListItem In lstItemAvail.Items
            If li.Selected AndAlso lstItemSel.Items.FindByValue(li.Value) Is Nothing Then
                lstItemSel.Items.Add(New ListItem(li.Text, li.Value))
            End If
        Next
        lstItemAvail.ClearSelection()
    End Sub

    Protected Sub btnItemRemove_Click(sender As Object, e As EventArgs)
        For i As Integer = lstItemSel.Items.Count - 1 To 0 Step -1
            If lstItemSel.Items(i).Selected Then lstItemSel.Items.RemoveAt(i)
        Next
    End Sub
#End Region

#Region "Save / edit / deactivate"
    Private Function CodeTable(ByVal colName As String, ByVal lb As ListBox, ByVal onlySelected As Boolean) As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add(colName, GetType(String))
        For Each li As ListItem In lb.Items
            If Not onlySelected OrElse li.Selected Then dt.Rows.Add(li.Value)
        Next
        Return dt
    End Function

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ClearValidation()
        Dim ok As Boolean = True
        If ddlSupplier.SelectedValue = "" Then valSupplier.Text = "Please select Supplier." : ok = False
        If ddlVertical.SelectedValue = "" Then valVertical.Text = "Please select Vertical." : ok = False
        If ddlProduct.SelectedValue = "" Then valProduct.Text = "Please select Product." : ok = False
        If lstItemSel.Items.Count = 0 Then valItems.Text = "Add at least one packaging item." : ok = False
        If Not ok Then Exit Sub

        Dim msg As String = ""
        Dim saved As Boolean = New OPC_VendorClass().SaveScope(ddlSupplier.SelectedValue, ddlVertical.SelectedValue, ddlProduct.SelectedValue,
                                                             CodeTable("sss_shd_code", lstShade, True), CodeTable("ssp_pack_code", lstPack, True), CodeTable("ssi_item_code", lstItemSel, False),
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
        Dim ssId As Integer = 0
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), ssId) Then Exit Sub
        Dim obj As New OPC_VendorClass()

        Select Case e.CommandName
            Case "DeactivateScope"
                Dim msg As String = obj.SetScopeActive(ssId, "N", userInfo.userIDEntity)
                BindGrid()
                RmActionPopup.Show(Me, msg, True)
            Case "EditScope"
                LoadScope(ssId)
        End Select
    End Sub

    ' Fills the form from a saved scope. Saving again replaces that scope (same supplier + vertical + product).
    Private Sub LoadScope(ByVal ssId As Integer)
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetScope(ssId)
        If Not HasRows(ds) Then Exit Sub
        Dim h As DataRow = ds.Tables(0).Rows(0)

        ddlSupplier.SelectedValue = Convert.ToString(h("ss_supplier_code"))
        ddlVertical.SelectedValue = Convert.ToString(h("ss_sbl"))
        txtProductSearch.Text = Convert.ToString(h("ss_prd_code"))
        BindProducts()
        ddlProduct.SelectedValue = Convert.ToString(h("ss_prd_code"))
        BindShadePack()

        For Each dr As DataRow In ds.Tables(1).Rows
            Dim li As ListItem = lstShade.Items.FindByValue(Convert.ToString(dr("code")))
            If li IsNot Nothing Then li.Selected = True
        Next
        For Each dr As DataRow In ds.Tables(2).Rows
            Dim li As ListItem = lstPack.Items.FindByValue(Convert.ToString(dr("code")))
            If li IsNot Nothing Then li.Selected = True
        Next
        lstItemSel.Items.Clear()
        For Each dr As DataRow In ds.Tables(3).Rows
            Dim code As String = Convert.ToString(dr("code")).Trim()
            Dim dsI As DataSet = obj.GetScopeItems(Nothing, code)
            Dim text As String = code
            If HasRows(dsI) Then text = Convert.ToString(dsI.Tables(0).Rows(0)("item_name")).Trim() & " [" & Convert.ToString(dsI.Tables(0).Rows(0)("costclass")).Trim() & "]"
            lstItemSel.Items.Add(New ListItem(text, code))
        Next
    End Sub

    Private Sub ClearForm()
        ClearValidation()
        ddlVertical.ClearSelection()
        ResetProduct()
        txtItemSearch.Text = String.Empty
        lstItemAvail.Items.Clear()
        lstItemSel.Items.Clear()
    End Sub

    Private Sub ClearValidation()
        valSupplier.Text = String.Empty
        valVertical.Text = String.Empty
        valProduct.Text = String.Empty
        valItems.Text = String.Empty
        lblErrorMessage.Text = String.Empty
    End Sub
#End Region
End Class
