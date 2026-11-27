'**************************************************
'Copyright	    : BSTRACKER, MCC, Kolkata
'Source	        : User_History_Details.vb
'Created Date	: 04 November 2010
'Created By	    : Srinath
'Version	    : 1.00.00
'Description	: Code behind file for User_History_Details Page

'Modified By       Modified On       Version         Reason

'*************************************************************
Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web
Imports System.Data.SqlClient

Imports System.Data.SqlTypes
Partial Class User_History
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            AddAttributes()
            populateUserGroupCode()
            PageSizeDropdown()
            LoadSearchCriteria()
            SaveSearchCriteria()
            populateUserIds()
            BindGrid()
        End If
    End Sub
#Region "AddAttributes"
    Private Sub AddAttributes()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")

        End If
        ddlUserGroup.Attributes.Add("onChange", "return userGroupChange('" + userInfo.userCompanyEntity + "');")
        ddlUserId.Attributes.Add("onChange", "return userIdChange('" + userInfo.userCompanyEntity + "');")
        btnSearch.Attributes.Add("onClick", "return validatedate();")


    End Sub
#End Region
#Region "Load User Group Code in list"

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
            ddlUserGroup.Items.Insert(0, New ListItem(Constant.Common.Selec, "", True))
            If (Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing)) Then
                Dim UPListSearchInfo As UserProfileListSearchCriteria
                UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
                ddlUserGroup.SelectedValue = UPListSearchInfo.UserUserGroup
            End If
        End If
        'populateUserIds()
    End Sub

#End Region



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
            'ddlBranch.DataSource = dataSortview
            'ddlBranch.DataTextField = "depot_name"
            'ddlBranch.DataValueField = "depot_code"
            'ddlBranch.DataBind()
            'ddlBranch.Items.Insert(0, New ListItem(Constant.Common.Selec, "0", True))
            'ddlBranch.SelectedValue = userInfo.userBranchEntity
        End If

        If Not userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Then
            'ddlBranch.Enabled = False
        End If
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
        gvUserHistory.PageSize = ddlPageSize.SelectedValue
    End Sub

#End Region
#Region "BindGrid"
    Protected Sub BindGrid()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        'Dim FromDate, ToDate As SqlDateTime
        Dim FromDate, ToDate As String
        Dim SearchType As String

        If (txtFromDate.Text) <> "" Then
            FromDate = txtFromDate.Text
        Else
            FromDate = Constant.Common.FromDate
        End If

        If (txtToDate.Text) <> "" Then
            ToDate = txtToDate.Text
        Else
            ToDate = Constant.Common.Todate
        End If

        SearchType = ddlSearchFor.SelectedValue

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Try
            Dim UserSet As New DataSet
            Dim UserId As String = hdnUserId.Value
            Dim oUserFunction As New UserProfile

            UserSet = oUserFunction.User_History_Get(userInfo.userCompanyEntity, ddlUserGroup.SelectedValue, UserId, FromDate, ToDate, SearchType)
            If (Not (UserSet Is Nothing) AndAlso UserSet.Tables.Count > 0 AndAlso Not (UserSet.Tables(0) Is Nothing) AndAlso UserSet.Tables(0).Rows.Count > 0) Then
                If ddlSearchFor.SelectedValue = "Detail" Then
                    gvUserHistory.Visible = True
                    gvUserHistoryCount.Visible = False
                    gvUserHistory.DataSource = FirstHistoryPage(UserSet.Tables(0), gvUserHistory.PageSize)
                    gvUserHistory.DataBind()
                    hdnHistoryMode.Value = "Detail"
                    hdnHistoryPage.Value = "0"
                    hdnHistoryPageSize.Value = gvUserHistory.PageSize.ToString()
                Else
                    gvUserHistory.Visible = False
                    gvUserHistoryCount.Visible = True
                    gvUserHistoryCount.DataSource = UserSet.Tables(0)
                    gvUserHistoryCount.DataBind()
                    hdnHistoryMode.Value = "Summary"
                    hdnHistoryPage.Value = gvUserHistoryCount.PageIndex.ToString()
                    hdnHistoryPageSize.Value = gvUserHistoryCount.PageSize.ToString()
                End If

            Else
                gvUserHistory.Visible = False
                gvUserHistoryCount.Visible = False
                hdnHistoryMode.Value = String.Empty
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

    Private Function FirstHistoryPage(ByVal dt As DataTable, ByVal pageSize As Integer) As DataTable
        If pageSize <= 0 Then pageSize = 15
        Dim pageDt As DataTable = dt.Clone()
        Dim take As Integer = Math.Min(pageSize, dt.Rows.Count)
        For i As Integer = 0 To take - 1
            pageDt.ImportRow(dt.Rows(i))
        Next
        Return pageDt
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetMoreUserHistory(pageIndex As Integer, pageSize As Integer, userGroup As String, userId As String, fromDate As String, toDate As String, searchType As String) As Object
        Dim rows As New List(Of Object)
        Dim total As Integer = 0
        If pageSize <= 0 Then pageSize = 15
        If String.IsNullOrEmpty(fromDate) Then fromDate = Constant.Common.FromDate
        If String.IsNullOrEmpty(toDate) Then toDate = Constant.Common.Todate
        If String.IsNullOrEmpty(searchType) Then searchType = "Detail"

        Dim company As String = String.Empty
        Dim sessionUser = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser IsNot Nothing Then
            company = CType(sessionUser, VMSUserEntity).userCompanyEntity
        End If

        Dim userSet As DataSet = New UserProfile().User_History_Get(company, If(userGroup, String.Empty), If(userId, String.Empty), fromDate, toDate, searchType)
        If userSet IsNot Nothing AndAlso userSet.Tables.Count > 0 AndAlso userSet.Tables(0) IsNot Nothing Then
            Dim dt As DataTable = userSet.Tables(0)
            total = dt.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            For i As Integer = start To last
                Dim r As DataRow = dt.Rows(i)
                If searchType = "Detail" Then
                    rows.Add(New With {
                        .uh_userid = Convert.ToString(r("uh_userid")),
                        .uh_user_group = Convert.ToString(r("uh_user_group")),
                        .logdate = Convert.ToString(r("logdate")),
                        .logtime = Convert.ToString(r("logtime"))
                    })
                Else
                    rows.Add(New With {
                        .uh_userid = Convert.ToString(r("uh_userid")),
                        .fromDate = Convert.ToString(r("fromDate")),
                        .toDate = Convert.ToString(r("toDate")),
                        .totalCount = Convert.ToString(r("totalCount"))
                    })
                End If
            Next
        End If

        Return New With {.rows = rows, .total = total}
    End Function

#Region "Date Format"

    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime

        If Not (stringdate = String.Empty) Then

            Dim ddate As String() = stringdate.Split("/")
            Dim arrlist As New ArrayList
            Dim index As Integer = 0

            While index <= ddate.Length - 1
                arrlist.Add(ddate(index))
                System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
            End While
            Dim dd As Integer = System.Convert.ToInt32(arrlist.Item(0))
            Dim mm As Integer = System.Convert.ToInt32(arrlist.Item(1))
            Dim yyyy As Integer = System.Convert.ToInt32(arrlist.Item(2))


            Dim dt As Date = New DateTime(yyyy, mm, dd)
            dt = FormatDateTime(dt, DateFormat.LongDate)

            Return dt

        End If

    End Function

#End Region

    'Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSearch.Click
    '    Session(Constant.SessionKeys.UPListSearchInfo) = Nothing
    '    SaveSearchCriteria()
    '    BindGrid()
    '    populateUserIds()
    'End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Session(Constant.SessionKeys.UPListSearchInfo) = Nothing
        SaveSearchCriteria()
        BindGrid()
        populateUserIds()
    End Sub

#Region "Grid Page Index Changed"
    ' Event Handler for Page Changing
    'Protected Sub gvUserProfile_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
    '    gvUserHistory.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
#End Region
    Protected Sub gvUserHistoryCount_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        gvUserHistoryCount.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub
#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()
        Dim UPListSearchInfo As New UserProfileListSearchCriteria
        UPListSearchInfo.UserUserGroup = ddlUserGroup.SelectedValue
        UPListSearchInfo.UserPagination = ddlPageSize.SelectedValue
        UPListSearchInfo.UserUserName = hdnUserId.Value
        Session(Constant.SessionKeys.UPListSearchInfo) = UPListSearchInfo
    End Sub
#End Region
#Region "Load Search Criteria"
    ' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()
        If Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing) Then
            Dim UPListSearchInfo As New UserProfileListSearchCriteria
            UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
            ddlUserGroup.SelectedValue = UPListSearchInfo.UserUserGroup
            ddlPageSize.SelectedValue = UPListSearchInfo.UserPagination
            gvUserHistory.PageSize = ddlPageSize.SelectedValue
            ddlUserId.SelectedValue = UPListSearchInfo.UserUserName
        End If
    End Sub
#End Region


#Region "Populate User Ids"
    Private Sub populateUserIds()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim ObjDocumentType As New Common
        Dim UserGroupCodeSet As New DataSet
        'Dim LovType As String = Constant.Common.Lov_Sep_Reason
        UserGroupCodeSet = ObjDocumentType.GetUserId(userInfo.userCompanyEntity, ddlUserGroup.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (UserGroupCodeSet Is Nothing) AndAlso UserGroupCodeSet.Tables.Count > 0 AndAlso Not (UserGroupCodeSet.Tables(0) Is Nothing) AndAlso UserGroupCodeSet.Tables(0).Rows.Count > 0) Then
            ddlUserId.DataSource = UserGroupCodeSet.Tables(0)
            ddlUserId.DataTextField = "usp_user_id"
            ddlUserId.DataValueField = "usp_user_id"
            ddlUserId.DataBind()
            ddlUserId.Items.Insert(0, New ListItem(Constant.Common.Selec, "", True))
            ddlUserId.Items.Insert(1, New ListItem(Constant.Common.All, "All", True))
            If (Not (Session(Constant.SessionKeys.UPListSearchInfo) Is Nothing)) Then
                Dim UPListSearchInfo As UserProfileListSearchCriteria
                UPListSearchInfo = CType(Session(Constant.SessionKeys.UPListSearchInfo), UserProfileListSearchCriteria)
                ddlUserId.SelectedValue = UPListSearchInfo.UserUserName
            End If
        End If
    End Sub
#End Region
#Region "Clear button click"

    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClear.Click
        gvUserHistory.Visible = False
        gvUserHistoryCount.Visible = False
        hdnHistoryMode.Value = String.Empty
        txtFromDate.Text = ""
        txtFromDate.Text = ""
        ddlUserId.Items.Clear()
        ddlUserId.Items.Insert(0, Constant.Common.Selec)
        groupCode()
    End Sub

#End Region
#Region "Populate user group code"
    Function groupCode()
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
            ddlUserGroup.Items.Insert(0, New ListItem(Constant.Common.Selec, "", True))
        End If

    End Function
#End Region
#Region "Row Bound event for User Histroy Details Grid"
    Protected Sub gvUserHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUserHistory.RowDataBound
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
#Region "User History Summary Grid Row Data Bound "
    Protected Sub gvUserHistoryCount_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUserHistoryCount.RowDataBound
        If (e.Row.RowType = DataControlRowType.Pager) Then
            Dim row As TableRow = New TableRow
            row = e.Row.Controls(0).Controls(0).Controls(0)
            For Each cell As TableCell In row.Cells
                Dim lb As Control = cell.Controls(0)


                If (TypeOf (lb) Is Label) Then

                    'CType(lb, Label).ForeColor = System.Drawing.Color.Red
                    CType(lb, Label).CssClass = "lblpager"
                    'CType(lb, Label).Width = 20
                    'CType(lb, Label).Height = 15
                    'set current pager

                ElseIf (TypeOf (lb) Is LinkButton) Then

                    CType(lb, LinkButton).CssClass = "lnkpager"
                    'CType(lb, LinkButton).Width = 20
                    'CType(lb, LinkButton).Height = 15
                    'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
                End If

            Next
        End If
    End Sub
#End Region
#Region "page size for grid view"
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvUserHistory.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        gvUserHistoryCount.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)

        BindGrid()
    End Sub
#End Region

End Class
