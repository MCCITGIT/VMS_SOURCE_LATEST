'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : Vendor_SKU_Master.aspx.vb
'Created Date	: 05-Dec-2011
'Created By	    : Deepak 
'Version	    : R02.00.00
'Description	: Code behind for Vendor_SKU_Master Page

'Modified By       Modified On       Version         Reason

'****************************************************************
Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Collections.Generic

Partial Class Vendor_SKU_Master
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity
#Region "Page Load Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If (Request.QueryString("NoData") = "Yes") Then
        '    lblErrorMessage.Text = "No record found!"
        'Else
        '    lblErrorMessage.Text = String.Empty
        'End If
        Page.MaintainScrollPositionOnPostBack = True
        checkLogin()
        Dim ItemCode As String = String.Empty
        If Not IsPostBack Then


            'added HO-MARKETING to the exception as advised by Sandeep Dey on 29/02/2012
            If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING) Then
                imgbtnAdd.Visible = False
            End If


            AddAttributes()
            populatVendorUnit()
            PageSizeDropdown()
            LoadSearchCriteria()
            populateVendorSKUList()
        End If

    End Sub

#End Region
#Region "AddAttributes"
    Private Sub AddAttributes()
        'imgbtnSearch.Attributes.Add("OnClick", "return ValidateSearch();")

       

    End Sub
#End Region
#Region "Check if already logged in as a valid user of this page"

    Public Sub checkLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#End Region
#Region "Populate Page Size DropDownList"

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
            End Try
            System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        End While
        gvVendorSKUList.PageSize = ddlPageSize.SelectedValue

    End Sub
#End Region
#Region "Load Search Criteria"

    '' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()

        If Not (Session(Constant.SessionKeys.VendorSKUSearchInfo) Is Nothing) Then
            Dim SearchInfo As New VendorMasterEntity
            SearchInfo = CType(Session(Constant.SessionKeys.VendorSKUSearchInfo), VendorMasterEntity)

            ddlVendor.SelectedValue = SearchInfo.VendorUnit
            ddlPageSize.SelectedValue = SearchInfo.pageSize
            txtSkuCode.Text = SearchInfo.VendorSku_Code
            gvVendorSKUList.PageIndex = SearchInfo.PageNumber
        End If

    End Sub

#End Region
#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()

        Dim SearchInfo As New VendorMasterEntity

        SearchInfo.VendorUnit = ddlVendor.SelectedValue
        SearchInfo.pageSize = ddlPageSize.SelectedValue
        SearchInfo.VendorSku_Code = txtSkuCode.Text
        SearchInfo.PageNumber = gvVendorSKUList.PageIndex

        Session(Constant.SessionKeys.VendorSKUSearchInfo) = SearchInfo
    End Sub
#End Region
#Region "Populate  Venodr Unit "
    Public Sub populatVendorUnit()

        checkLogin()
        

        Dim VendorUnit As New VendorMaster
        Dim Vendords As New DataSet
        Vendords = VendorUnit.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (Vendords Is Nothing) AndAlso Vendords.Tables.Count > 0 AndAlso Not (Vendords.Tables(0) Is Nothing) AndAlso Vendords.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = Vendords.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
            ' ddlVendor.Items.Insert(0, New ListItem("ALL", String.Empty, True))

        Else
            ddlVendor.Items.Insert(0, New ListItem("Select", String.Empty, True))

        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
            ddlVendor.SelectedValue = userInfo.userUnitEntity
            ddlVendor.Enabled = False
        End If

    End Sub
#End Region
#Region "Populate Vendor SKU List Grid"
    Public Sub populateVendorSKUList()
        checkLogin()
        Dim VendorListset As New DataSet
        Dim Vendor_mstr As New VendorMaster
        Dim company As String
        Dim VendorUnit As String
        Dim SKUCode As String
        company = userInfo.userCompanyEntity
        VendorUnit = Trim(ddlVendor.SelectedValue)
        SKUCode = Trim(txtSkuCode.Text)
        VendorListset = Vendor_mstr.GetVendorList(VendorUnit, SKUCode)
        If VendorListset IsNot Nothing AndAlso VendorListset.Tables.Count > 0 AndAlso VendorListset.Tables(0) IsNot Nothing Then
            gvVendorSKUList.DataSource = FirstSkuPage(VendorListset.Tables(0))
        Else
            gvVendorSKUList.DataSource = Nothing
        End If
        gvVendorSKUList.DataBind()
    End Sub
#End Region
#Region "Gridview PageIndexChanging event handling."

    Protected Sub gvVendorSKUList_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvVendorSKUList.PageIndexChanging
        gvVendorSKUList.PageIndex = e.NewPageIndex
        'SaveSearchCriteria()
        populateVendorSKUList()
    End Sub

#End Region
#Region "Gridview RowDataBound event handling."

    Protected Sub gvVendorSKUList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVendorSKUList.RowDataBound


        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'e.Row.Cells(0).Text = e.Row.RowIndex + 1
            'Dim pageIdx As Integer = gvVendorSKUList.PageIndex * ddlPageSize.SelectedValue
            'e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            e.Row.Cells(2).Text = "<a href='Vendor_SKU_AddUpdate.aspx?" + Constant.SessionKeys.SKUCode + "=" + rowView("v_sku_code") + "&" + Constant.SessionKeys.Unit + "=" + rowView("v_vendor_unit") + "'class='gridlink'>" + rowView("SkuDescription") + "</a>"

        End If



        'If (e.Row.RowType = DataControlRowType.Pager) Then
        '    Dim row As TableRow = New TableRow
        '    row = e.Row.Controls(0).Controls(0).Controls(0)
        '    For Each cell As TableCell In row.Cells
        '        Dim lb As Control = cell.Controls(0)


        '        If (TypeOf (lb) Is Label) Then

        '            CType(lb, Label).CssClass = "lblpager"
        '            'CType(lb, Label).Width = 20
        '            'CType(lb, Label).Height = 15

        '        ElseIf (TypeOf (lb) Is LinkButton) Then

        '            CType(lb, LinkButton).CssClass = "lnkpager"
        '            'CType(lb, LinkButton).Width = 20
        '            'CType(lb, LinkButton).Height = 15
        '            'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
        '        End If

        '    Next
        'ElseIf (e.Row.RowType = DataControlRowType.DataRow) Then
        '    Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

        '    'If (rowView("eng_left_yn").ToString.ToLower() = Constant.Common.ActiveStatus.ToLower()) Then
        '    '    e.Row.BackColor = Drawing.Color.Red
        '    '    e.Row.ForeColor = Drawing.Color.White
        '    '    e.Row.Cells(5).Text = "Yes"
        '    'Else
        '    '    e.Row.Cells(5).Text = "No"
        '    'End If
        'End If
    End Sub

#End Region
    '#Region "gridview rowcommand event"
    '    Protected Sub gvVendorSKUList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvVendorSKUList.RowCommand
    '        If (e.CommandName = "Update") Then

    '            Dim currentRowIndex As Integer = Int32.Parse(e.CommandArgument)
    '            Dim v_sku_code As String = gvVendorSKUList.DataKeys(currentRowIndex)("v_sku_code")
    '            'Dim v_sku_code As String = gvVendorSKUList.DataKeys(currentRowIndex)(Constant.SessionKeys.SKUCode)
    '            'SaveSearchCriteria()
    '            Dim hdnDepotCode As HiddenField
    '            Dim hdnVendorUnit As HiddenField
    '            hdnVendorUnit = gvVendorSKUList.Rows(currentRowIndex).FindControl("hdnvendor_unit")
    '            'hdnDepotCode = gvVendorSKUList.Rows(currentRowIndex).FindControl("hdnDepot")
    '            Response.Redirect("~/Vendor_SKU_AddUpdate.aspx?Type" + "=" + Constant.Common.Modify + "&" + "v_sku_code" + "=" + v_sku_code + "&" + "VendorUnit" + "=" + hdnVendorUnit.Value)
    '            '+ "&" + "DepotCode" + "=" + hdnDepotCode.Value
    '        End If
    '    End Sub
    '#End Region
#Region "Search Button Click event handling"
    'Protected Sub imgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbtnSearch.Click
    '    SaveSearchCriteria()
    '    populateVendorSKUList()
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs)
        SaveSearchCriteria()
        populateVendorSKUList()
    End Sub

#End Region
    'Protected Sub imgbtnAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbtnAdd.Click
    '    Response.Redirect("~/Vendor_SKU_AddUpdate.aspx")
    'End Sub

    Protected Sub imgbtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Vendor_SKU_AddUpdate.aspx")
    End Sub

    Private Function SelectedPageSize() As Integer
        Dim pageSize As Integer = 15
        Integer.TryParse(Convert.ToString(ddlPageSize.SelectedValue), pageSize)
        If pageSize <= 0 Then pageSize = 15
        Return pageSize
    End Function

    Private Function FirstSkuPage(ByVal dt As DataTable) As DataTable
        Dim pageDt As DataTable = dt.Clone()
        Dim take As Integer = Math.Min(SelectedPageSize(), dt.Rows.Count)
        For i As Integer = 0 To take - 1
            pageDt.ImportRow(dt.Rows(i))
        Next
        Return pageDt
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetMoreVendorSkus(pageIndex As Integer, pageSize As Integer, vendorUnit As String, skuCode As String) As Object
        Dim rows As New List(Of Object)
        Dim total As Integer = 0
        If pageSize <= 0 Then pageSize = 15

        Dim sessionUser = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser IsNot Nothing Then
            Dim info As VMSUserEntity = CType(sessionUser, VMSUserEntity)
            If Not (info.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or info.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or info.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or info.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
                vendorUnit = info.userUnitEntity
            End If
        End If

        Dim vendorList As DataSet = New VendorMaster().GetVendorList(If(vendorUnit, String.Empty).Trim(), If(skuCode, String.Empty).Trim())
        If vendorList IsNot Nothing AndAlso vendorList.Tables.Count > 0 AndAlso vendorList.Tables(0) IsNot Nothing Then
            Dim dt As DataTable = vendorList.Tables(0)
            total = dt.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            For i As Integer = start To last
                Dim r As DataRow = dt.Rows(i)
                rows.Add(New With {
                    .v_sku_code = Convert.ToString(r("v_sku_code")),
                    .v_vendor_unit = Convert.ToString(r("v_vendor_unit")),
                    .SkuDescription = Convert.ToString(r("SkuDescription")),
                    .ApplicableDepot = Convert.ToString(r("ApplicableDepot"))
                })
            Next
        End If

        Return New With {.rows = rows, .total = total}
    End Function

    'Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
    '    gvVendorSKUList.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
    '    populateVendorSKUList()
    'End Sub

End Class
