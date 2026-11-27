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
Partial Class TokenRequisitionList
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
            PopulateStatus()
            BindGrid()
            If (userInfo.userGroupCodeEntity.Equals("VENDOR")) Then
                ddlVendorUnit.Visible = False
                lblTokenVendor.Visible = True
            Else
                ddlVendorUnit.Visible = True
                lblTokenVendor.Visible = False
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
            Dim obj As New UnitApplicableProductAssignClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetUnitName(Constant.Common.ActiveStatus)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlVendorUnit.DataSource = dsUnitSet.Tables(0)
                ddlVendorUnit.DataTextField = "unit_name"
                ddlVendorUnit.DataValueField = "unit_code"
                ddlVendorUnit.DataBind()
                If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
                    ddlVendorUnit.SelectedValue = userInfo.userIDEntity
                    ddlVendorUnit.Enabled = False
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
            Dim obj As New TokenVendorRequisitionClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0
            If Integer.TryParse(ddlVendorRequisition.SelectedValue, RequisitionId) Then
                dsProductSet = obj.GetRequistionList(userInfo.userIDEntity, userInfo.userGroupCodeEntity, ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, Integer.Parse(ddlVendorRequisition.SelectedValue), ddlStatus.SelectedValue)
            Else
                dsProductSet = obj.GetRequistionList(userInfo.userIDEntity, userInfo.userGroupCodeEntity, ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, 0, ddlStatus.SelectedValue)
            End If

            If (userInfo.userGroupCodeEntity.Equals("VENDOR")) Then
                lblTokenVendor.Text = dsProductSet.Tables(0).Rows(0)("tokenVendorName").ToString
            End If

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvRequistionList.PageIndex = 0
                gvRequistionList.DataSource = FirstTokenReqPage(dsProductSet.Tables(0))
                gvRequistionList.DataBind()
                hdnTokenReqHasData.Value = "1"
                hdnTokenReqPageSize.Value = gvRequistionList.PageSize.ToString()
            Else
                gvRequistionList.DataSource = Nothing
                gvRequistionList.DataBind()
                hdnTokenReqHasData.Value = "0"
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

#Region "Populate Requisition"
    Private Sub PopulateRequisition()
        CheckLogin()
        Try
            ddlVendorRequisition.Items.Clear()
            Dim obj As New TokenVendorRequisitionClass
            Dim dsVendorRequisitionSet As New DataSet

            dsVendorRequisitionSet = obj.GetRequisitionForUnitByVendor_Unit(Constant.Common.ActiveStatus, ddlTokenVendor.SelectedValue, ddlVendorUnit.SelectedValue)
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
            Dim hdnStatus As HiddenField = CType(e.Row.FindControl("hdnStatus"), HiddenField)
            If (hdnStatus IsNot Nothing) And (Not (hdnStatus.Value.Equals(String.Empty))) Then
                If (hdnStatus.Value.Equals(Constant.Common.Token_Req_Status_New)) Then
                    CType(e.Row.Cells(e.Row.Cells.Count - 1).FindControl("imgBtnReject"), LinkButton).Visible = True
                    CType(e.Row.Cells(e.Row.Cells.Count - 1).FindControl("imgBtnReject"), LinkButton).OnClientClick = "return confirm('Are you sure to reject this?');"
                ElseIf (hdnStatus.Value.Equals(Constant.Common.Token_Req_Status_Rejected)) Then
                    CType(e.Row.Cells(e.Row.Cells.Count - 1).FindControl("imgBtnReject"), LinkButton).Visible = False
                    e.Row.BackColor = Drawing.Color.LightCoral
                Else
                    CType(e.Row.Cells(e.Row.Cells.Count - 1).FindControl("imgBtnReject"), LinkButton).Visible = False
                End If

            End If
        End If
    End Sub
    Protected Sub gvTokenVendorList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvRequistionList.RowCommand
        CheckLogin()
        If (e.CommandName.Equals("EditRequisition")) Then
            'Dim gvrow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)
            Response.Redirect("TokenVendorRequisitionAddUpdate.aspx?id=" & e.CommandArgument.ToString)
        End If
        If (e.CommandName.Equals("RejectRequisition")) Then
            'Dim gvrow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)
            lblErrorMessage.Text = ""
            Dim sqlConn As SqlConnection = Nothing
            Dim sqlTrans As SqlTransaction = Nothing
            Dim obj As New TokenVendorRequisitionClass

            Dim RecordInserted As Integer = 0
            Try
                Dim requisitionId As Integer = Convert.ToInt32(e.CommandArgument.ToString)

                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()

                RecordInserted = obj.TokenRequisitionReject(requisitionId, Constant.Common.Token_Req_Status_Rejected, sqlConn, sqlTrans)
                If (RecordInserted > 0) Then
                    sqlTrans.Commit()
                Else
                    sqlTrans.Rollback()
                End If
            Catch ex As Exception
                If (sqlTrans IsNot Nothing) Then
                    sqlTrans.Rollback()
                End If
            Finally
                If (sqlConn IsNot Nothing) Then
                    sqlConn.Close()
                End If
                BindGrid()
            End Try


        End If
    End Sub
    'Protected Sub imgbtnAdd_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnAdd.Click
    '    Response.Redirect("TokenVendorRequisitionAddUpdate.aspx", False)
    'End Sub
    'Protected Sub imgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnSearch.Click
    '    BindGrid()
    'End Sub
#Region "Populate Status from Lov"
    Private Sub PopulateStatus()
        CheckLogin()
        Try
            Dim obj As New Common()
            Dim ds As New DataSet

            ds = obj.GetLovDetails(Constant.Common.Company, "T_REQ_STATUS", Constant.Common.ActiveStatus)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then

                ddlStatus.DataSource = ds.Tables(0)
                ddlStatus.DataTextField = "Lov_Value"
                ddlStatus.DataValueField = "Lov_Code"
                ddlStatus.DataBind()
                If (ds.Tables(0).Rows.Count > 0) Then
                    ddlStatus.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                End If
                ddlStatus.SelectedValue = Constant.Common.Token_Req_Status_New
            Else
                ddlStatus.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs)
        BindGrid()
    End Sub
    Protected Sub imgbtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("TokenVendorRequisitionAddUpdate.aspx", False)
    End Sub

    Private Function FirstTokenReqPage(ByVal table As DataTable) As DataTable
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
    Public Shared Function GetMoreTokenRequisitions(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal unit As String, ByVal tokenVendor As String, ByVal requisitionId As String, ByVal status As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 20
        If pageIndex < 0 Then pageIndex = 0
        Dim unitValue As String = If(unit, String.Empty)
        If userInfo.userGroupCodeEntity.Equals("UNIT") Then unitValue = userInfo.userIDEntity
        Dim reqId As Integer = 0
        Integer.TryParse(If(requisitionId, "0"), reqId)
        Dim ds As DataSet = New TokenVendorRequisitionClass().GetRequistionList(userInfo.userIDEntity, userInfo.userGroupCodeEntity, unitValue, If(tokenVendor, String.Empty), reqId, If(status, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .id = dr("trh_id").ToString(),
                    .unit = dr("trh_unit").ToString(),
                    .vendor = dr("trh_token_vendor").ToString(),
                    .site = dr("trh_site_name").ToString(),
                    .desc = dr("trh_desc").ToString(),
                    .items = dr("items").ToString(),
                    .qty = dr("totalQty").ToString(),
                    .status = dr("trh_status").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function RejectTokenRequisition(ByVal requisitionId As Integer) As String
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return "error"
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()
            Dim recordInserted As Integer = New TokenVendorRequisitionClass().TokenRequisitionReject(requisitionId, Constant.Common.Token_Req_Status_Rejected, sqlConn, sqlTrans)
            If recordInserted > 0 Then
                sqlTrans.Commit()
                Return "ok"
            End If
            sqlTrans.Rollback()
        Catch
            If sqlTrans IsNot Nothing Then sqlTrans.Rollback()
        Finally
            If sqlConn IsNot Nothing Then sqlConn.Close()
        End Try
        Return "error"
    End Function
End Class
