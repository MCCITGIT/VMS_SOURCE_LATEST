Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports VMS.DataAccess
Partial Class UnitTokenReceivedList
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
            PopulateRequisition()
            PopulateDespatch()
            gvRequistionList.PageIndex = 0
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
#Region "Populate Requisition"
    Private Sub PopulateRequisition()
        CheckLogin()
        Try
            Dim obj As New UnitTokenReceivedClass
            Dim dsVendorRequisitionSet As New DataSet
            ddlVendorRequisition.Items.Clear()
            dsVendorRequisitionSet = obj.GetRequisitionList(ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue)
            If (Not (dsVendorRequisitionSet Is Nothing) AndAlso dsVendorRequisitionSet.Tables.Count > 0 AndAlso Not (dsVendorRequisitionSet.Tables(0) Is Nothing) AndAlso dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
                ddlVendorRequisition.DataSource = dsVendorRequisitionSet.Tables(0)
                ddlVendorRequisition.DataTextField = "tdh_requisition_id"
                ddlVendorRequisition.DataValueField = "tdh_requisition_id"
                ddlVendorRequisition.DataBind()
            End If
            ddlVendorRequisition.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

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
                If Not (dsUnitSet.Tables(0).Rows.Count = 1) Then
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
#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Try
            Dim out As Int32 = 0
            Dim obj As New UnitTokenReceivedClass
            Dim dsProductSet As New DataSet
            If (Integer.TryParse(ddlVendorRequisition.SelectedValue, out)) Then
                If (Integer.TryParse(ddlDespatchId.SelectedValue, out)) Then
                    dsProductSet = obj.GetDespatchListForReceive(ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, ddlVendorRequisition.SelectedValue, ddlDespatchId.SelectedValue, ddlStatus.SelectedValue)

                    If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                        BindReceivedPage(dsProductSet.Tables(0))
                    Else
                        BindReceivedPage(Nothing)
                    End If
                Else
                    dsProductSet = obj.GetDespatchListForReceive(ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, ddlVendorRequisition.SelectedValue, 0, ddlStatus.SelectedValue)

                    If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                        BindReceivedPage(dsProductSet.Tables(0))
                    Else
                        BindReceivedPage(Nothing)
                    End If
                End If
            Else
                dsProductSet = obj.GetDespatchListForReceive(ddlVendorUnit.SelectedValue, ddlTokenVendor.SelectedValue, 0, 0, ddlStatus.SelectedValue)

                If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                    BindReceivedPage(dsProductSet.Tables(0))
                Else
                    BindReceivedPage(Nothing)
                End If
            End If

        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region
#Region "Populate Despatch"
    Private Sub PopulateDespatch()
        CheckLogin()
        Try
            Dim out As Integer = 0
            Dim obj As New UnitTokenReceivedClass
            Dim dsVendorRequisitionSet As New DataSet
            ddlDespatchId.Items.Clear()
            If (Integer.TryParse(ddlVendorRequisition.SelectedValue, out)) Then
                dsVendorRequisitionSet = obj.GetDespatchId(Convert.ToInt32(ddlVendorRequisition.SelectedValue))
                If (Not (dsVendorRequisitionSet Is Nothing) AndAlso dsVendorRequisitionSet.Tables.Count > 0 AndAlso Not (dsVendorRequisitionSet.Tables(0) Is Nothing) AndAlso dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
                    ddlDespatchId.DataSource = dsVendorRequisitionSet.Tables(0)
                    ddlDespatchId.DataTextField = "tdh_despatch_id"
                    ddlDespatchId.DataValueField = "tdh_despatch_id"
                    ddlDespatchId.DataBind()

                End If
            End If
            ddlDespatchId.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region
    'Protected Sub ddlVendorUnit_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorUnit.SelectedIndexChanged
    '    gvRequistionList.PageIndex = 0
    '    BindGrid()
    'End Sub
    'Protected Sub gvProductList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvRequistionList.PageIndexChanging
    '    gvRequistionList.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
    Protected Sub gvTokenVendorList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvRequistionList.RowCommand
        CheckLogin()
        If (e.CommandName.Equals("EditRequisition")) Then
            Dim gvrow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)
            Dim hdnReceive As HiddenField = CType(gvrow.FindControl("hdnReceive"), HiddenField)
            Dim hdnDespatch As HiddenField = CType(gvrow.FindControl("hdnDespatch"), HiddenField)
            Dim hdnRequisition As HiddenField = CType(gvrow.FindControl("hdnRequisition"), HiddenField)
            Dim hdnTokenVendor As HiddenField = CType(gvrow.FindControl("hdnTokenVendor"), HiddenField)
            If (hdnReceive IsNot Nothing And hdnDespatch IsNot Nothing And hdnRequisition IsNot Nothing And hdnTokenVendor IsNot Nothing) Then
                Response.Redirect("UnitTokenReceivedAddUpdate.aspx?receiveid=" & hdnReceive.Value & "&tokenVendor=" & hdnTokenVendor.Value & "&requisition=" & hdnRequisition.Value & "&despatch=" & hdnDespatch.Value, False)
            Else
                lblErrorMessage.Text = "Internal Server Error."
            End If

        End If

    End Sub
    'Protected Sub imgbtnAdd_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnAdd.Click
    '    Response.Redirect("UnitTokenReceivedAddUpdate.aspx?", False)
    'End Sub
    Protected Sub ddlTokenVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTokenVendor.SelectedIndexChanged
        PopulateRequisition()
    End Sub
    'Protected Sub imgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnSearch.Click
    '    gvRequistionList.PageIndex = 0
    '    BindGrid()
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        gvRequistionList.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub ddlVendorRequisition_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorRequisition.SelectedIndexChanged
        PopulateDespatch()
    End Sub
    Protected Sub gvRequistionList_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvRequistionList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim hdnReceive As HiddenField = CType(e.Row.FindControl("hdnReceive"), HiddenField)
            If Not (hdnReceive Is Nothing) Then
                If Not (Convert.ToInt32(hdnReceive.Value) = 0) Then
                    e.Row.BackColor = Drawing.Color.LightGreen
                End If
            End If
        End If
    End Sub

    Private Sub BindReceivedPage(ByVal table As DataTable)
        If table IsNot Nothing AndAlso table.Rows.Count > 0 Then
            gvRequistionList.PageIndex = 0
            gvRequistionList.DataSource = FirstReceivedPage(table)
            gvRequistionList.DataBind()
            hdnUnitRecvHasData.Value = "1"
            hdnUnitRecvPageSize.Value = gvRequistionList.PageSize.ToString()
        Else
            gvRequistionList.DataSource = Nothing
            gvRequistionList.DataBind()
            hdnUnitRecvHasData.Value = "0"
        End If
    End Sub

    Private Function FirstReceivedPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvRequistionList.PageSize
        If pageSize <= 0 Then pageSize = 10
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
    Public Shared Function GetMoreUnitTokenReceived(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal unit As String, ByVal vendor As String, ByVal requisitionId As String, ByVal despatchId As String, ByVal status As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 10
        If pageIndex < 0 Then pageIndex = 0
        Dim unitValue As String = If(unit, String.Empty)
        If userInfo.userGroupCodeEntity.Equals("UNIT") Then unitValue = userInfo.userIDEntity
        Dim reqId As Integer = 0
        Dim despId As Integer = 0
        Dim parsed As Integer = 0
        If Integer.TryParse(If(requisitionId, String.Empty), parsed) Then
            reqId = parsed
            If Integer.TryParse(If(despatchId, String.Empty), parsed) Then despId = parsed
        End If
        Dim ds As DataSet = New UnitTokenReceivedClass().GetDespatchListForReceive(unitValue, If(vendor, String.Empty), reqId, despId, If(status, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .requisitionId = dr("tdh_requisition_id").ToString(),
                    .despatchId = dr("tdh_despatch_id").ToString(),
                    .receiveId = dr("treh_recieve_id").ToString(),
                    .tokenVendor = dr("tdh_token_vendor").ToString(),
                    .unit = dr("unit_name").ToString(),
                    .courier = dr("tdh_transporter").ToString(),
                    .challanNo = dr("tdh_vendor_challan_no").ToString(),
                    .challanDate = dr("tdh_vendor_challan_date").ToString(),
                    .roadPermit = dr("tdh_road_permit").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

End Class
