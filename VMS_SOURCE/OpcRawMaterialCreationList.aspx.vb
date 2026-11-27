Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web

Partial Class OpcRawMaterialCreationList
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateVendorList()
            BindData()
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Function IsUnitUser() As Boolean
        Return userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT
    End Function

    Private Function OwnUnitCode() As String
        Return Convert.ToString(userInfo.userBranchEntity).Trim()
    End Function

    Private Sub BindData()
        Try
            Dim obj As New OPC_VendorClass()
            Dim unitCode As String = If(IsUnitUser(), OwnUnitCode(), ddlVendor.SelectedValue)
            Dim ds As DataSet = obj.GetOpcRawMaterialCreationList(unitCode, txtSearch.Text, ddlItemType.SelectedValue)
            Dim table As DataTable = RmGridHelper.GetTable(ds)
            If table IsNot Nothing AndAlso table.Rows.Count > 0 Then
                gvRmList.PageIndex = 0
                RmGridHelper.BindPaged(gvRmList, FirstRmPage(table))
                hdnRmHasData.Value = "1"
                hdnRmPageSize.Value = gvRmList.PageSize.ToString()
            Else
                RmGridHelper.BindPaged(gvRmList, ds)
                hdnRmHasData.Value = "0"
            End If
            hdnRmUnit.Value = unitCode
            hdnRmSearch.Value = txtSearch.Text
            hdnRmType.Value = ddlItemType.SelectedValue
            hdnRmIsUnit.Value = If(IsUnitUser(), "1", "0")
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Private Function FirstRmPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvRmList.PageSize
        If pageSize <= 0 Then pageSize = 10
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function GetMoreRawMaterials(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal unit As String, ByVal searchKey As String, ByVal itemType As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 10
        If pageIndex < 0 Then pageIndex = 0
        Dim isUnit As Boolean = userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT
        If isUnit Then unit = Convert.ToString(userInfo.userBranchEntity).Trim()
        Dim ds As DataSet = New OPC_VendorClass().GetOpcRawMaterialCreationList(If(unit, String.Empty), If(searchKey, String.Empty), If(itemType, String.Empty))
        Dim total As Integer = 0
        Dim table As DataTable = RmGridHelper.GetTable(ds)
        If table IsNot Nothing Then
            total = table.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = table.Rows(i)
                Dim typeCode As String = Convert.ToString(dr("rmm_item_type")).Trim().ToUpper()
                Dim isPkg As Boolean = typeCode = "PKG"
                Dim notSale As Boolean = Convert.ToString(dr("berger_not_sale_flag")).Trim().ToUpper() = "N"
                Dim active As Boolean = Convert.ToString(dr("active")).Trim().ToUpper() = "Y"
                Dim canEdit As Boolean = (isPkg AndAlso isUnit) OrElse (Not isPkg AndAlso Not isUnit)
                rows.Add(New With {
                    .serial = (i + 1).ToString(),
                    .typeName = If(isPkg, "Packaging", "Raw Material"),
                    .code = Convert.ToString(dr("rmm_code")),
                    .name = Convert.ToString(dr("rmm_material_name")),
                    .vendor = Convert.ToString(dr("vendor_name")),
                    .berger = If(notSale, "Berger does not buy", Convert.ToString(dr("berger_code")).Trim()),
                    .status = Convert.ToString(dr("rmm_status")),
                    .activeText = If(active, "Active", "Inactive"),
                    .activeClass = If(active, "rm-status-pill is-active", "rm-status-pill is-inactive"),
                    .canEdit = canEdit
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

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
        ddlVendor.Items.Insert(1, New ListItem("All vendors (common raw materials)", "ALL", True))      ' 04-11-2026: raw materials HO entered for every vendor

        If IsUnitUser() Then
            Dim own As String = OwnUnitCode()
            If ddlVendor.Items.FindByValue(own) IsNot Nothing Then
                ddlVendor.SelectedValue = own
            End If
            ddlVendor.Enabled = False
            colVendorFilter.Visible = False
        End If
    End Sub

    Protected Sub lbBtnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        gvRmList.PageIndex = 0
        BindData()
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("~/OpcRawMaterialCreation.aspx")
    End Sub

    Protected Sub gvRmList_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "EditRm" Then
            Return
        End If

        Dim rmCode As String = Convert.ToString(e.CommandArgument).Trim()
        If String.IsNullOrWhiteSpace(rmCode) Then
            Return
        End If

        Response.Redirect("~/OpcRawMaterialCreation.aspx?RmCode=" & Server.UrlEncode(rmCode), False)
        Context.ApplicationInstance.CompleteRequest()
    End Sub

    ''' <summary>Packaging items belong to the vendor (02-11-2026): an HO login sees them but gets no edit link.</summary>
    Protected Sub gvRmList_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType <> DataControlRowType.DataRow Then Return
        Dim hdn As HiddenField = TryCast(e.Row.FindControl("hdnItemType"), HiddenField)
        Dim edit As LinkButton = TryCast(e.Row.FindControl("btnEdit"), LinkButton)
        'Modified-by MUKESH BHAGAT 04-11-2026: raw materials are entered by HO, packaging by the vendor - the edit link follows that
        '(a vendor login gets no edit link on a raw material; an HO login none on a packaging item)
        If hdn IsNot Nothing AndAlso edit IsNot Nothing Then
            Dim isPkg As Boolean = hdn.Value.Trim().ToUpperInvariant() = "PKG"
            If (isPkg AndAlso Not IsUnitUser()) OrElse (Not isPkg AndAlso IsUnitUser()) Then edit.Visible = False
        End If
    End Sub

    'Protected Sub gvRmList_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvRmList.PageIndexChanging
    '    gvRmList.PageIndex = e.NewPageIndex
    '    BindData()
    'End Sub
End Class
