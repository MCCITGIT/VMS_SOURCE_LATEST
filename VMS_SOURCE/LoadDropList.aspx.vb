Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web
Imports System.Data.SqlClient
Partial Class LoadDropList
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        MaintainScrollPositionOnPostBack = True
        If Not IsPostBack Then
            'populateBranch()
            populatDepot(ddlBranch)
            populatVendorUnit(ddlVendor)

            PageSizeDropdown()
            LoadSearchCriteria()
            BindGrid()
        End If
    End Sub




#Region "Populate  Depot"
    Public Sub populatDepot(ddl As DropDownList)


        ddl.DataSource = Nothing
        Dim helper As New Common
        Dim ds As New DataSet
        ds = helper.GetDepotDetails(Constant.Common.ActiveStatus)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddl.DataSource = ds.Tables(0)
            ddl.DataTextField = "depot_name"
            ddl.DataValueField = "depot_code"
            ddl.DataBind()
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        Else
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        End If


    End Sub
#End Region
#Region "Populate  Venodr Unit "
    Public Sub populatVendorUnit(ddl As DropDownList)


        ddl.DataSource = Nothing
        Dim VendorUnit As New VendorMaster
        Dim Vendords As New DataSet
        Vendords = VendorUnit.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (Vendords Is Nothing) AndAlso Vendords.Tables.Count > 0 AndAlso Not (Vendords.Tables(0) Is Nothing) AndAlso Vendords.Tables(0).Rows.Count > 0) Then
            ddl.DataSource = Vendords.Tables(0)
            ddl.DataTextField = "unit_name"
            ddl.DataValueField = "unit_code"
            ddl.DataBind()
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        Else
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
        '    ddlVendor.SelectedValue = userInfo.userUnitEntity
        '    ddlVendor.Enabled = False
        'End If

    End Sub
#End Region

    Protected Sub gvLoadDrop_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLoadDrop.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'e.Row.Cells(0).Text = e.Row.RowIndex + 1
            Dim pageIdx As Integer = gvLoadDrop.PageIndex * ddlPageSize.SelectedValue
            e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            'e.Row.Cells(2).Text = "<a href='User_Profile_Add.aspx?" + Constant.SessionKeys.UserId + "=" + rowView("usp_user_id") + "'class='hl'>" + rowView("usp_user_id") + "</a>"
            e.Row.Cells(2).Text = "<a href='LoadDropAddUpdate.aspx?" + Constant.SessionKeys.DEPT + "=" + rowView("depot_code") + "&Vendor=" + rowView("vend_unit") + "'class='gridlink'>" + rowView("depot_name") + "</a>"
        End If
        'If (e.Row.RowType = DataControlRowType.Pager) Then
        '    Dim row As TableRow = New TableRow
        '    row = e.Row.Controls(0).Controls(0).Controls(0)
        '    For Each cell As TableCell In row.Cells
        '        Dim lb As Control = cell.Controls(0)


        '        If (TypeOf (lb) Is Label) Then

        '            'CType(lb, Label).ForeColor = System.Drawing.Color.Red
        '            CType(lb, Label).CssClass = "lblpager"
        '            'CType(lb, Label).Width = 20
        '            'CType(lb, Label).Height = 15
        '            'set current pager

        '        ElseIf (TypeOf (lb) Is LinkButton) Then

        '            CType(lb, LinkButton).CssClass = "lnkpager"
        '            'CType(lb, LinkButton).Width = 20
        '            'CType(lb, LinkButton).Height = 15
        '            'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
        '        End If

        '    Next
        'End If
    End Sub

#Region "Load Search Criteria"

    '' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()

        If Not (Session(Constant.SessionKeys.VendorSKUSearchInfo) Is Nothing) Then
            Dim SearchInfo As New VendorMasterEntity
            SearchInfo = CType(Session(Constant.SessionKeys.VendorSKUSearchInfo), VendorMasterEntity)


            ddlBranch.SelectedValue = SearchInfo.VendorDepot
            ddlPageSize.SelectedValue = SearchInfo.pageSize

            gvLoadDrop.PageIndex = SearchInfo.PageNumber
        End If

    End Sub

#End Region
#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()

        Dim SearchInfo As New VendorMasterEntity


        SearchInfo.VendorDepot = ddlBranch.SelectedValue
        SearchInfo.pageSize = ddlPageSize.SelectedValue
        SearchInfo.PageNumber = gvLoadDrop.PageIndex

        Session(Constant.SessionKeys.VendorSKUSearchInfo) = SearchInfo
    End Sub
#End Region

#Region "Page Size Change Event Handler"

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvLoadDrop.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        BindGrid()
    End Sub

#End Region

#Region "Populate page size dropdown"

    ' Populates the page size dropdown
    Private Sub PageSizeDropdown()
        ddlPageSize.Items.Clear()
        'Gets the page size from the web.config file
        Dim configPagesize As String = ConfigurationManager.AppSettings.Get("PageSize")
        Dim numbers As String() = configPagesize.Split(",")
        Dim index As Integer = 0

        While index <= numbers.Length - 1
            Try
                Dim size As Integer = Convert.ToInt32(numbers(index))
                'Adds the page size to drop down list
                ddlPageSize.Items.Add(New ListItem(size.ToString, size.ToString))
            Catch exp As Exception
                ddlPageSize.Items.Clear()
                'LoadDefaultPageSize()
            End Try
            System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        End While
        gvLoadDrop.PageSize = ddlPageSize.SelectedValue
    End Sub

#End Region

#Region "BindGrid"
    Protected Sub BindGrid()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Try
            Dim ds As New DataSet
            Dim hepler As New LoadDropAddUpdateClass
            ds = hepler.GetDropLoadList(ddlBranch.SelectedValue, txtSearchUserName.Text, ddlVendor.SelectedValue)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                gvLoadDrop.Visible = True
                gvLoadDrop.PageIndex = 0
                gvLoadDrop.DataSource = FirstLoadDropPage(ds.Tables(0))
                gvLoadDrop.DataBind()
                Div_User_List_Grid.Visible = False
                hdnLoadDropHasData.Value = "1"
                hdnLoadDropPageSize.Value = gvLoadDrop.PageSize.ToString()
            Else
                gvLoadDrop.Visible = False
                Div_User_List_Grid.Visible = True
                hdnLoadDropHasData.Value = "0"
                'ddlWeekSelect.SelectedValue = Session(Constant.SessionKeys.CurrentWeek)
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

    'Protected Sub ImgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnSearch.Click
    '    Session(Constant.SessionKeys.UPListSearchInfo) = Nothing
    '    SaveSearchCriteria()
    '    BindGrid()
    'End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        Session(Constant.SessionKeys.UPListSearchInfo) = Nothing
        SaveSearchCriteria()
        BindGrid()
    End Sub

    Protected Sub ImgbtnAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnAdd.Click
        Response.Redirect("~/LoadDropAddUpdate.aspx?UserId=New")
    End Sub

#Region "Grid Page Index Changed"
    ' Event Handler for Page Changing
    'Protected Sub gvLoadDrop_IndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
    '    gvLoadDrop.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
#End Region

    Private Function FirstLoadDropPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvLoadDrop.PageSize
        If pageSize <= 0 Then pageSize = 15
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function GetMoreLoadDrops(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal depot As String, ByVal skuCode As String, ByVal vendor As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        If pageSize <= 0 Then pageSize = 15
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New LoadDropAddUpdateClass().GetDropLoadList(If(depot, String.Empty), If(skuCode, String.Empty), If(vendor, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .vendorName = dr("vendor_name").ToString(),
                    .depotName = dr("depot_name").ToString(),
                    .depotHref = "LoadDropAddUpdate.aspx?" & Constant.SessionKeys.DEPT & "=" & dr("depot_code").ToString() & "&Vendor=" & dr("vend_unit").ToString(),
                    .sku = dr("sku_code").ToString(),
                    .skuDesc = dr("SkuDescription").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

End Class
