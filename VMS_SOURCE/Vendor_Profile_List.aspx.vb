'**************************************************
'Copyright	    : AGROII, Edify India, Chennai
'Source	        : Vendor_Profile_List.aspx.vb
'Created Date	: 12-October-2007
'Created By	    : Deepak 
'Version	    : R01.00.00
'Description	: Code behind for Vendor Profile List Page

'Modified By       Modified On       Version         Reason

'**************************************************
Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web
Imports System.Data.SqlClient
Partial Class Vendor_Profile_List
    Inherits System.Web.UI.Page
#Region "Page Load Event Handler"
    'Page load event handler occurs at the time of page and page post back
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            'LoadDepotName()
            PageSizeDropdown()
            LoadSearchCriteria()
            BindGrid()
            AddAttributes()
        End If

    End Sub
#End Region

#Region "AddAttributes"
    Private Sub AddAttributes()
        'ImgbtnAdd.Attributes.Add("OnClick", "return ValidateVandorUnit();")
    End Sub
#End Region
#Region "Vendor Profile Grid Row DataBound"
    Protected Sub gvVendorProfile_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVendorProfile.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim pageIdx As Integer = gvVendorProfile.PageIndex * ddlPageSize.SelectedValue
            e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            If (rowView("active").ToString.ToLower = Constant.Common.ActiveStatus.ToLower) Then
                e.Row.Cells(3).Text = Constant.Common.Active
                ' e.Row.Cells(2).Text = "<a href='Vendor_Profile_Add.aspx?" + Constant.SessionKeys.UnitCode + "=" + e.Row.Cells(2).Text.ToString + "'class='hl'>" + rowView("unit_name") + "</a>"
                e.Row.Cells(2).Text = "<a href='Vendor_Profile_Add.aspx?" + Constant.SessionKeys.UnitCode + "=" + rowView("unit_code") + "'class='gridlink'>" + rowView("unit_name") + "</a>"
            Else
                e.Row.Cells(3).Text = Constant.Common.InActive
                e.Row.BackColor = Drawing.Color.Red
                e.Row.ForeColor = Drawing.Color.White
                'e.Row.Cells(2).Text = "<a class='gridlink' href='Vendor_Profile_Add.aspx?" + Constant.SessionKeys.UnitCode + "=" + e.Row.Cells(2).Text.ToString + "'class='hl'>" + rowView("unit_name") + "</a>"
                e.Row.Cells(2).Text = "<a href='Vendor_Profile_Add.aspx?" + Constant.SessionKeys.UnitCode + "=" + rowView("unit_code") + "'class='gridlink'>" + rowView("unit_name") + "</a>"

            End If
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
#End Region

    '#Region "Populating Branch"
    '    Public Sub populateBranch()

    '        Dim userInfo As VMS = New AGROUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), AGROUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim ObjDocumentType As New Common
    '        Dim VendorTypeSet As New DataSet
    '        Dim LovType As String = Constant.Common.Lov_Vend_Branch
    '        VendorTypeSet = ObjDocumentType.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)
    '        If (Not (VendorTypeSet Is Nothing) AndAlso VendorTypeSet.Tables.Count > 0 AndAlso Not (VendorTypeSet.Tables(0) Is Nothing) AndAlso VendorTypeSet.Tables(0).Rows.Count > 0) Then
    '            ddlLocation.DataSource = VendorTypeSet.Tables(0)
    '            ddlLocation.DataMember = "lov_code"
    '            ddlLocation.DataValueField = "lov_code"
    '            ddlLocation.DataBind()
    '            ddlLocation.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
    '            If (Not (Session(Constant.SessionKeys.VendorListSearchInfo) Is Nothing)) Then
    '                Dim VendorListSearchInfo As VendorProfileSearchCriteria
    '                VendorListSearchInfo = CType(Session(Constant.SessionKeys.VendorListSearchInfo), VendorProfileSearchCriteria)
    '                ddlLocation.SelectedValue = VendorListSearchInfo.VendorListBranch
    '            End If
    '        End If
    '    End Sub
    '#End Region

    '#Region "Load Depot Code"
    '    Private Sub LoadDepotName()

    '        Dim commonobj As New Common

    '        Dim dsDepot As DataSet

    '        Dim userInfo As AGROUserEntity = New AGROUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), AGROUserEntity)
    '        Else
    '            Response.Redirect("~/Login.aspx")

    '        End If
    '        Dim depotCode As String

    '        depotCode = String.Empty
    '        dsDepot = commonobj.GetDepotDetails(depotCode, Constant.Common.ActiveStatus)
    '        If (Not (dsDepot Is Nothing) AndAlso dsDepot.Tables.Count > 0 AndAlso Not (dsDepot.Tables(0) Is Nothing) AndAlso dsDepot.Tables(0).Rows.Count > 0) Then
    '            Dim dataSortview As DataView = New DataView(dsDepot.Tables(0))
    '            dataSortview.Sort = "depot_name asc"
    '            ddlLocation.DataSource = dataSortview
    '            ddlLocation.DataTextField = "depot_name"
    '            ddlLocation.DataValueField = "depot_code"
    '            ddlLocation.DataBind()
    '            ddlLocation.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
    '            '
    '        End If

    '        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING) Then
    '            ddlLocation.Enabled = False
    '            ddlLocation.SelectedValue = userInfo.userBranchEntity
    '        End If
    '    End Sub
    '#End Region

#Region "Load Search Criteria"
    ' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()
        If Not (Session(Constant.SessionKeys.VendorListSearchInfo) Is Nothing) Then
            Dim VendorListSearchInfo As New VendorProfileSearchCriteria
            VendorListSearchInfo = CType(Session(Constant.SessionKeys.VendorListSearchInfo), VendorProfileSearchCriteria)
            ddlPageSize.SelectedValue = VendorListSearchInfo.VendorPagination
            gvVendorProfile.PageSize = ddlPageSize.SelectedValue
        End If
    End Sub
#End Region

#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()
        Dim VendorListSearchInfo As New VendorProfileSearchCriteria

        VendorListSearchInfo.VendorPagination = ddlPageSize.SelectedValue
        Session(Constant.SessionKeys.VendorListSearchInfo) = VendorListSearchInfo
    End Sub
#End Region

#Region "Page Size Change Event Handler"

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvVendorProfile.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        'SaveSearchCriteria()
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
        gvVendorProfile.PageSize = ddlPageSize.SelectedValue
    End Sub

#End Region

#Region "Load Default Page Size"
    ' Loads the default page size if the entry is missing in web.config or any incorrect entries are present
    Private Sub LoadDefaultPageSize()
        Dim index As Integer = 1
        While index <= 50
            ddlPageSize.Items.Add(New ListItem(index.ToString, index.ToString))
            index = index + 1
        End While
    End Sub

#End Region

#Region "BindGrid"
    Protected Sub BindGrid()

        Dim userInfo As VMSUserEntity = New VMSUserEntity
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Try
            Dim VendorSet As New DataSet
            Dim oVendorFunction As New VendorUnit
            VendorSet = oVendorFunction.Vendor_List_Get()
            If (Not (VendorSet Is Nothing) AndAlso VendorSet.Tables.Count > 0 AndAlso Not (VendorSet.Tables(0) Is Nothing) AndAlso VendorSet.Tables(0).Rows.Count > 0) Then
                gvVendorProfile.Visible = True
                gvVendorProfile.DataSource = FirstVendorPage(VendorSet.Tables(0))
                gvVendorProfile.DataBind()
                'Div_Vendor_List_Grid.Visible = False
            Else
                gvVendorProfile.Visible = False
                'Div_Vendor_List_Grid.Visible = True
                'ddlWeekSelect.SelectedValue = Session(Constant.SessionKeys.CurrentWeek)
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

#Region "Grid Page Index Changed"
    ' Event Handler for Page Changing
    'Protected Sub gvVendorProfile_IndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
    '    gvVendorProfile.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
#End Region

    '#Region "Search Click Event"
    '    Protected Sub ImgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnSearch.Click
    '        Session(Constant.SessionKeys.VendorListSearchInfo) = Nothing
    '        SaveSearchCriteria()
    '        BindGrid()
    '    End Sub
    '#End Region

#Region "Add Click Event"
    'Protected Sub ImgbtnAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnAdd.Click
    '    Response.Redirect("~/Vendor_Profile_Add.aspx?UnitCode=New")
    '    'Response.Redirect("~/Vendor_Profile_Add.aspx")
    'End Sub

    Protected Sub ImgbtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Vendor_Profile_Add.aspx?UnitCode=New")
        'Response.Redirect("~/Vendor_Profile_Add.aspx")
    End Sub
#End Region

    Private Function SelectedPageSize() As Integer
        Dim pageSize As Integer = 15
        Integer.TryParse(Convert.ToString(ddlPageSize.SelectedValue), pageSize)
        If pageSize <= 0 Then pageSize = 15
        Return pageSize
    End Function

    Private Function FirstVendorPage(ByVal dt As DataTable) As DataTable
        Dim pageDt As DataTable = dt.Clone()
        Dim take As Integer = Math.Min(SelectedPageSize(), dt.Rows.Count)
        For i As Integer = 0 To take - 1
            pageDt.ImportRow(dt.Rows(i))
        Next
        Return pageDt
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetMoreVendorProfiles(pageIndex As Integer, pageSize As Integer) As Object
        Dim rows As New List(Of Object)
        Dim total As Integer = 0
        If pageSize <= 0 Then pageSize = 15

        Dim vendorSet As DataSet = New VendorUnit().Vendor_List_Get()
        If vendorSet IsNot Nothing AndAlso vendorSet.Tables.Count > 0 AndAlso vendorSet.Tables(0) IsNot Nothing Then
            Dim dt As DataTable = vendorSet.Tables(0)
            total = dt.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            For i As Integer = start To last
                Dim r As DataRow = dt.Rows(i)
                rows.Add(New With {
                    .unit_code = Convert.ToString(r("unit_code")),
                    .unit_name = Convert.ToString(r("unit_name")),
                    .active = Convert.ToString(r("active")),
                    .created_user = Convert.ToString(r("created_user")),
                    .created_date = Convert.ToString(r("created_date"))
                })
            Next
        End If

        Return New With {.rows = rows, .total = total}
    End Function

End Class
