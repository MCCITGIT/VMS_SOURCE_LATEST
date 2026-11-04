Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Partial Class UsrPrflListNewMod
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        MaintainScrollPositionOnPostBack = True
        If Not IsPostBack Then
            'populateBranch()
            LoadDepotName()
            populateDepartment()
            populateUserGroupCode()
            PageSizeDropdown()
            LoadSearchCriteria()
            BindGrid()
        End If
    End Sub
    Public Sub populateUserGroupCode()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim ObjDocumentType As New UserProfile
        Dim UserGroupCodeSet As New DataSet
        'Dim LovType As String = Constant.Common.Lov_Sep_Reason
        UserGroupCodeSet = ObjDocumentType.UserGroup_Get(userInfo.userCompanyEntity)
        If (Not (UserGroupCodeSet Is Nothing) AndAlso UserGroupCodeSet.Tables.Count > 0 AndAlso Not (UserGroupCodeSet.Tables(0) Is Nothing) AndAlso UserGroupCodeSet.Tables(0).Rows.Count > 0) Then
            ddlUserGroup.DataSource = UserGroupCodeSet.Tables(0)
            ddlUserGroup.DataTextField = "grp_user_group_desc"
            ddlUserGroup.DataValueField = "grp_user_group_code"
            ddlUserGroup.DataBind()
            ddlUserGroup.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
            If (Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing)) Then
                Dim UPListSearchInfo As UserProfileListSearchCriteria
                UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
                ddlUserGroup.SelectedValue = UPListSearchInfo.UserUserGroup
            End If
        End If
    End Sub
    Public Sub populateDepartment()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim ObjDocumentType As New Common
        Dim OccupationTypeSet As New DataSet
        Dim LovType As String = Constant.Common.Lov_Department
        OccupationTypeSet = ObjDocumentType.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)
        If (Not (OccupationTypeSet Is Nothing) AndAlso OccupationTypeSet.Tables.Count > 0 AndAlso Not (OccupationTypeSet.Tables(0) Is Nothing) AndAlso OccupationTypeSet.Tables(0).Rows.Count > 0) Then
            ddlDepartment.DataSource = OccupationTypeSet.Tables(0)
            ddlDepartment.DataMember = "lov_value"
            ddlDepartment.DataValueField = "lov_value"
            ddlDepartment.DataBind()
            ddlDepartment.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
            If (Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing)) Then
                Dim UPListSearchInfo As UserProfileListSearchCriteria
                UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
                ddlDepartment.SelectedValue = UPListSearchInfo.UserDepartment
            End If
        End If
    End Sub


#Region "Load Depot Code"
    Private Sub LoadDepotName()

        Dim commonobj As New Common

        Dim dsDepot As DataSet

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")

        End If
        Dim depotCode As String

        depotCode = String.Empty
        dsDepot = commonobj.GetDepotDetails(depotCode, Constant.Common.ActiveStatus)
        If (Not (dsDepot Is Nothing) AndAlso dsDepot.Tables.Count > 0 AndAlso Not (dsDepot.Tables(0) Is Nothing) AndAlso dsDepot.Tables(0).Rows.Count > 0) Then
            Dim dataSortview As DataView = New DataView(dsDepot.Tables(0))
            dataSortview.Sort = "depot_name asc"
            ddlBranch.DataSource = dataSortview
            ddlBranch.DataTextField = "depot_name"
            ddlBranch.DataValueField = "depot_code"
            ddlBranch.DataBind()
            ddlBranch.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
            'ddlBranch.SelectedValue = userInfo.userBranchEntity
        End If

        If Not userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Then
            ddlBranch.Enabled = False
        End If
    End Sub
#End Region

    Protected Sub gvUserProfile_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUserProfile.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'e.Row.Cells(0).Text = e.Row.RowIndex + 1
            Dim pageIdx As Integer = gvUserProfile.PageIndex * ddlPageSize.SelectedValue
            e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            'e.Row.Cells(2).Text = "<a href='User_Profile_Add.aspx?" + Constant.SessionKeys.UserId + "=" + rowView("usp_user_id") + "'class='hl'>" + rowView("usp_user_id") + "</a>"
            If (rowView("active").ToString.ToLower = Constant.Common.ActiveStatus.ToLower) Then
                e.Row.Cells(7).Text = Constant.Common.Active
                e.Row.Cells(3).Text = "<a href='UsrPrfileAddNewMod.aspx?" + Constant.SessionKeys.UserId + "=" + rowView("usp_user_id") + "'class='gridlink'>" + rowView("usp_name") + "</a>"

            Else
                e.Row.Cells(7).Text = Constant.Common.InActive
                e.Row.BackColor = Drawing.Color.Red
                e.Row.ForeColor = Drawing.Color.White
                e.Row.Cells(3).Text = "<a class='gridlink' href='UsrPrfileAddNewMod.aspx?" + Constant.SessionKeys.UserId + "=" + rowView("usp_user_id") + rowView("usp_name") + "</a>"
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

#Region "Load Search Criteria"
    ' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()
        If Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing) Then
            Dim UPListSearchInfo As New UserProfileListSearchCriteria
            UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
            ddlBranch.SelectedValue = UPListSearchInfo.UserBranch
            ddlDepartment.SelectedValue = UPListSearchInfo.UserDepartment
            ddlUserGroup.SelectedValue = UPListSearchInfo.UserUserGroup
            txtSearchUserName.Text = UPListSearchInfo.UserUserName
            ddlPageSize.SelectedValue = UPListSearchInfo.UserPagination
            gvUserProfile.PageSize = ddlPageSize.SelectedValue
        End If
    End Sub
#End Region

#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()
        Dim UPListSearchInfo As New UserProfileListSearchCriteria
        UPListSearchInfo.UserBranch = ddlBranch.SelectedValue
        UPListSearchInfo.UserDepartment = ddlDepartment.SelectedValue
        UPListSearchInfo.UserUserGroup = ddlUserGroup.SelectedValue
        UPListSearchInfo.UserUserName = txtSearchUserName.Text
        UPListSearchInfo.UserPagination = ddlPageSize.SelectedValue
        Session(Constant.SessionKeys.UPListSearchInfo) = UPListSearchInfo
    End Sub
#End Region

#Region "Page Size Change Event Handler"

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvUserProfile.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
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
        gvUserProfile.PageSize = ddlPageSize.SelectedValue
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
            Dim UserSet As New DataSet
            Dim oUserFunction As New UserProfile
            UserSet = oUserFunction.User_List_Get(userInfo.userCompanyEntity, ddlBranch.SelectedValue, ddlUserGroup.SelectedValue, txtSearchUserName.Text, ddlDepartment.SelectedValue)
            If (Not (UserSet Is Nothing) AndAlso UserSet.Tables.Count > 0 AndAlso Not (UserSet.Tables(0) Is Nothing) AndAlso UserSet.Tables(0).Rows.Count > 0) Then
                gvUserProfile.Visible = True
                gvUserProfile.DataSource = FirstUserPage(UserSet.Tables(0))
                gvUserProfile.DataBind()
                Div_User_List_Grid.Visible = False
            Else
                gvUserProfile.Visible = False
                Div_User_List_Grid.Visible = True
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

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs)
        Session(Constant.SessionKeys.UPListSearchInfo) = Nothing
        SaveSearchCriteria()
        BindGrid()
    End Sub

    'Protected Sub ImgbtnAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnAdd.Click
    '    Response.Redirect("~/UsrPrfileAddNewMod.aspx?UserId=New")
    'End Sub

    Protected Sub ImgbtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/UsrPrfileAddNewMod.aspx?UserId=New")
    End Sub

#Region "Grid Page Index Changed"
    ' Event Handler for Page Changing
    'Protected Sub gvUserProfile_IndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
    '    gvUserProfile.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
#End Region

    'Protected Sub ImgbtnPrint_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnPrint.Click
    '    Response.Redirect("~/User_Profile_List_Report.aspx")
    'End Sub

    Protected Sub ImgbtnPrint_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/User_Profile_List_Report.aspx")
    End Sub

    Private Function SelectedPageSize() As Integer
        Dim pageSize As Integer = 15
        If ddlPageSize IsNot Nothing Then
            Integer.TryParse(Convert.ToString(ddlPageSize.SelectedValue), pageSize)
        End If
        If pageSize <= 0 Then pageSize = 15
        Return pageSize
    End Function

    Private Function FirstUserPage(ByVal dt As DataTable) As DataTable
        Dim pageDt As DataTable = dt.Clone()
        Dim take As Integer = Math.Min(SelectedPageSize(), dt.Rows.Count)
        For i As Integer = 0 To take - 1
            pageDt.ImportRow(dt.Rows(i))
        Next
        Return pageDt
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetMoreUserProfiles(pageIndex As Integer, branch As String, userGroup As String, userName As String, department As String, pageSize As Integer) As Object
        Dim rows As New List(Of Object)
        Dim total As Integer = 0
        If pageSize <= 0 Then pageSize = 15

        Dim company As String = String.Empty
        Dim sessionUser = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser IsNot Nothing Then
            company = CType(sessionUser, VMSUserEntity).userCompanyEntity
        End If

        Dim userSet As DataSet = New UserProfile().User_List_Get(company, If(branch, String.Empty), If(userGroup, String.Empty), If(userName, String.Empty), If(department, String.Empty))
        If userSet IsNot Nothing AndAlso userSet.Tables.Count > 0 AndAlso userSet.Tables(0) IsNot Nothing Then
            Dim dt As DataTable = userSet.Tables(0)
            total = dt.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            For i As Integer = start To last
                Dim r As DataRow = dt.Rows(i)
                rows.Add(New With {
                    .usp_user_id = Convert.ToString(r("usp_user_id")),
                    .usp_dept = Convert.ToString(r("usp_dept")),
                    .usp_name = Convert.ToString(r("usp_name")),
                    .usp_branch = Convert.ToString(r("usp_branch")),
                    .usp_region = Convert.ToString(r("usp_region")),
                    .usp_desig = Convert.ToString(r("usp_desig")),
                    .usp_group_code = Convert.ToString(r("usp_group_code")),
                    .active = Convert.ToString(r("active"))
                })
            Next
        End If

        Return New With {.rows = rows, .total = total}
    End Function
End Class
