Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports VMS.DataAccess
Partial Class TestCaseTestMasterList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page_Load Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
        If Not IsPostBack Then
            AddAttributes()
            PopulateFrequency()
            PopulateResultType()
            gvTestList.PageIndex = 0
            BindGrid()
        End If

    End Sub

#End Region

#Region "Adding Attributes to Controls"
    Public Sub AddAttributes()

    End Sub
#End Region

#Region "Check Login"
    Private Sub CheckLogin()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub
#End Region

#Region "Populate Dropdown"
    Private Sub PopulateFrequency()
        CheckLogin()
        Try
            Dim obj As New Common
            Dim dsUnitSet As New DataSet
            ddlFrequency.Items.Clear()
            dsUnitSet = obj.GetLovDetails("Berger", "TC_FREQUENCY", "Y")
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlFrequency.DataSource = dsUnitSet.Tables(0)
                ddlFrequency.DataTextField = "Lov_Value"
                ddlFrequency.DataValueField = "Lov_Code"
                ddlFrequency.DataBind()
                If Not (dsUnitSet.Tables(0).Rows.Count = 1) Then
                    ddlFrequency.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
    Private Sub PopulateResultType()
        CheckLogin()
        Try
            Dim obj As New Common
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetLovDetails("Berger", "TC_TEST_TYPE", "Y")
            ddlResultType.Items.Clear()
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlResultType.DataSource = dsUnitSet.Tables(0)
                ddlResultType.DataTextField = "Lov_Value"
                ddlResultType.DataValueField = "Lov_Code"
                ddlResultType.DataBind()
                If Not (dsUnitSet.Tables(0).Rows.Count = 1) Then
                    ddlResultType.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Try
            Dim obj As New QualityControlClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0
            dsProductSet = obj.GetTestList(ddlFrequency.SelectedValue, ddlResultType.SelectedValue, txtTestName.Text.Trim(), userInfo.userIDEntity)

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvTestList.PageIndex = 0
                gvTestList.DataSource = FirstTestPage(dsProductSet.Tables(0))
                gvTestList.DataBind()
                hdnTestHasData.Value = "1"
                hdnTestPageSize.Value = gvTestList.PageSize.ToString()
            Else
                gvTestList.DataSource = Nothing
                gvTestList.DataBind()
                hdnTestHasData.Value = "0"
            End If
            hdnTestFrequency.Value = ddlFrequency.SelectedValue
            hdnTestResultType.Value = ddlResultType.SelectedValue
            hdnTestName.Value = txtTestName.Text.Trim()
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    'Protected Sub gvProductList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvTestList.PageIndexChanging
    '    gvTestList.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
    Protected Sub gvTokenVendorList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTestList.RowCommand
        CheckLogin()
        If (e.CommandName.Equals("EditTest")) Then
            Response.Redirect("TestCaseTestMasterAddUpdate.aspx?id=" & e.CommandArgument.ToString)
        End If
    End Sub
    Protected Sub imgbtnAdd_Click(sender As Object, e As EventArgs) Handles imgbtnAdd.Click
        Response.Redirect("TestCaseTestMasterAddUpdate.aspx", False)
    End Sub
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        BindGrid()
    End Sub

    Private Function FirstTestPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvTestList.PageSize
        If pageSize <= 0 Then pageSize = 20
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
    Public Shared Function GetMoreTestCases(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal frequency As String, ByVal resultType As String, ByVal testName As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 20
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New QualityControlClass().GetTestList(If(frequency, String.Empty), If(resultType, String.Empty), If(testName, String.Empty).Trim(), userInfo.userIDEntity)
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .id = dr("test_id").ToString(),
                    .name = dr("test_name").ToString(),
                    .frequency = dr("frequency_value").ToString(),
                    .resultType = dr("test_type_value").ToString(),
                    .refValue = dr("ref_value").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function
End Class
