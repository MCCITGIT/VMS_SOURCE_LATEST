'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : TokenRequisitionList.aspx.vb
'Created Date	: 14-09-2018
'Created By	    : Debayan Das
'Version	    : R01.00.00
'Description	: Code behind for Unit Applicable Product Assign Page

'Modified By       Modified On       Version         Reason

'****************************************************************

Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports VMS.DataAccess
Partial Class TokenVendorRequisitionList
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
            PopulateUnit()
            PopulateTokenVendor(ddlTokenVendor)
            gvRequistionList.PageIndex = 0
            PopulateRequisition()
            BindGrid()
            If (userInfo.userGroupCodeEntity.Equals("VENDOR")) Then
                ddlVendorUnit.Visible = True

            Else
                ddlVendorUnit.Visible = True

            End If
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

#Region "Populate Unit"
    Private Sub PopulateUnit()
        CheckLogin()
        Try
            Dim obj As New TokenVendorRequisitionListClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetUnitList(userInfo.userIDEntity, "Despatched")
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlVendorUnit.DataSource = dsUnitSet.Tables(0)
                ddlVendorUnit.DataTextField = "unit_name"
                ddlVendorUnit.DataValueField = "unit_code"
                ddlVendorUnit.DataBind()
                If (dsUnitSet.Tables(0).Rows.Count > 0) Then
                    ddlVendorUnit.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                End If
            Else
                ddlVendorUnit.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
            End If

        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region
#Region "Date Format"
    Public Shared Function FormatDate(ByVal stringdate As String) As SqlDateTime

        If (stringdate.Equals(String.Empty)) Then
            Return SqlDateTime.MinValue
        End If

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

            Dim dt As DateTime = New DateTime(yyyy, mm, dd)
            dt = FormatDateTime(dt, DateFormat.LongDate)
            Return dt
        End If

    End Function
#End Region

#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Try
            Dim obj As New TokenVendorRequisitionListClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0
            If Integer.TryParse(ddlVendorRequisition.SelectedValue, RequisitionId) Then
                dsProductSet = obj.GetRequistionListForVendor(userInfo.userIDEntity, userInfo.userGroupCodeEntity, ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, Integer.Parse(ddlVendorRequisition.SelectedValue), FormatDate(IIf(Request.Form(txtFromDate.UniqueID) Is Nothing, String.Empty, Request.Form(txtFromDate.UniqueID)).Trim), FormatDate(IIf(Request.Form(txtTodate.UniqueID) Is Nothing, String.Empty, Request.Form(txtTodate.UniqueID)).Trim))
            Else
                dsProductSet = obj.GetRequistionListForVendor(userInfo.userIDEntity, userInfo.userGroupCodeEntity, ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, 0, FormatDate(IIf(Request.Form(txtFromDate.UniqueID) Is Nothing, String.Empty, Request.Form(txtFromDate.UniqueID)).Trim), FormatDate(IIf(Request.Form(txtTodate.UniqueID) Is Nothing, String.Empty, Request.Form(txtTodate.UniqueID)).Trim))
            End If

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvRequistionList.PageIndex = 0
                gvRequistionList.DataSource = FirstVendorReqPage(dsProductSet.Tables(0))
                gvRequistionList.DataBind()
                hdnVendorReqHasData.Value = "1"
                hdnVendorReqPageSize.Value = gvRequistionList.PageSize.ToString()
            Else
                gvRequistionList.DataSource = Nothing
                gvRequistionList.DataBind()
                hdnVendorReqHasData.Value = "0"
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Token Vendor List"
    Private Sub PopulateTokenVendor(ddl As DropDownList)
        CheckLogin()
        Try
            Dim obj As New UnitApplicableVendorAssignClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetTokenVendorList(String.Empty, Constant.Common.ActiveStatus)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then

                ddl.DataSource = dsUnitSet.Tables(0)
                ddl.DataTextField = "tvm_name"
                ddl.DataValueField = "tvm_code"
                ddl.DataBind()
                If (dsUnitSet.Tables(0).Rows.Count > 0) Then
                    ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                End If
                Dim a As String = userInfo.userGroupCodeEntity
                If (userInfo.userGroupCodeEntity.Equals("VENDOR")) Then
                    ddlTokenVendor.SelectedValue = userInfo.userIDEntity
                    ddlTokenVendor.Enabled = False
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    Protected Sub ddlTokenVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTokenVendor.SelectedIndexChanged

        PopulateRequisition()

        BindGrid()
    End Sub

    'Protected Sub ddlVendorRequisition_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorRequisition.SelectedIndexChanged

    'End Sub

    Protected Sub ddlVendorUnit_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorUnit.SelectedIndexChanged
        CheckLogin()
        PopulateRequisition()
        BindGrid()
    End Sub
#Region "Populate Requisition"
    Private Sub PopulateRequisition()
        CheckLogin()
        Try
            ddlVendorRequisition.Items.Clear()
            Dim obj As New TokenVendorRequisitionClass
            Dim dsVendorRequisitionSet As New DataSet

            dsVendorRequisitionSet = obj.GetRequisitionForUnitByVendor(Constant.Common.ActiveStatus, ddlTokenVendor.SelectedValue, ddlVendorUnit.SelectedValue)
            If (Not (dsVendorRequisitionSet Is Nothing) AndAlso dsVendorRequisitionSet.Tables.Count > 0 AndAlso Not (dsVendorRequisitionSet.Tables(0) Is Nothing) AndAlso dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
                ddlVendorRequisition.DataSource = dsVendorRequisitionSet.Tables(0)
                ddlVendorRequisition.DataTextField = "trh_id"
                ddlVendorRequisition.DataValueField = "trh_id"
                ddlVendorRequisition.DataBind()
                If (dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
                    ddlVendorRequisition.Items.Insert(0, New ListItem(Constant.Common.Selec, 0))
                End If
            Else
                ddlVendorRequisition.Items.Insert(0, New ListItem(Constant.Common.Selec, 0))
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    'Protected Sub gvProductList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvRequistionList.PageIndexChanging
    '    gvRequistionList.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
    Protected Sub gvProductList_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvRequistionList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim label As Label = CType(e.Row.FindControl("lblRequistionId"), Label)
            label.Text = "<a href='TokenRequisitionList_Vendor.aspx?id=" & label.Text & "' style='color:blue'>" & label.Text & "</a>"
        End If
    End Sub




    Protected Sub gvTokenVendorList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvRequistionList.RowCommand
        CheckLogin()
        If (e.CommandName.Equals("EditRequisition")) Then
            'Dim gvrow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)
            Response.Redirect("TokenVendorRequisitionAddUpdate.aspx?id=" & e.CommandArgument.ToString)
        End If

    End Sub

    'Protected Sub imgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnSearch.Click
    '    BindGrid()
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        BindGrid()
    End Sub

    Private Function FirstVendorReqPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvRequistionList.PageSize
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
    Public Shared Function GetMoreVendorTokenReqs(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal unit As String, ByVal tokenVendor As String, ByVal requisitionId As String, ByVal fromDate As String, ByVal toDate As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 20
        If pageIndex < 0 Then pageIndex = 0
        Dim vendorValue As String = If(tokenVendor, String.Empty)
        If userInfo.userGroupCodeEntity.Equals("VENDOR") Then vendorValue = userInfo.userIDEntity
        Dim reqId As Integer = 0
        Integer.TryParse(If(requisitionId, "0"), reqId)
        Dim total As Integer = 0
        Try
            Dim ds As DataSet = New TokenVendorRequisitionListClass().GetRequistionListForVendor(userInfo.userIDEntity, userInfo.userGroupCodeEntity, If(unit, String.Empty), vendorValue, reqId, FormatDate(If(fromDate, String.Empty).Trim()), FormatDate(If(toDate, String.Empty).Trim()))
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
                total = ds.Tables(0).Rows.Count
                Dim start As Integer = pageIndex * pageSize
                Dim last As Integer = Math.Min(start + pageSize, total) - 1
                Dim i As Integer
                For i = start To last
                    Dim dr As DataRow = ds.Tables(0).Rows(i)
                    rows.Add(New With {
                        .id = dr("trh_id").ToString(),
                        .created = dr("created_date").ToString(),
                        .unit = dr("trh_unit").ToString(),
                        .vendor = dr("VendorName").ToString(),
                        .site = dr("trh_site_name").ToString(),
                        .desc = dr("trh_desc").ToString(),
                        .items = dr("items").ToString(),
                        .qty = dr("totalQty").ToString()
                    })
                Next
            End If
        Catch
            Return New With {.rows = rows, .total = 0}
        End Try
        Return New With {.rows = rows, .total = total}
    End Function
End Class