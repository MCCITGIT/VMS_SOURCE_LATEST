Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports System.Collections.Generic
Imports System.Text
Partial Class FGVendor_DespatchList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            BindDropDown()
            PopulateList()
        End If
    End Sub
    Private Sub BindDropDown()
        PopulateRawMatVendor()
        populateStatus()
    End Sub
    Private Sub PopulateRawMatVendor()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetRawMaterialVendorList()

        ddlRawMatvendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlRawMatvendor.DataSource = ds.Tables(0)
            ddlRawMatvendor.DataTextField = "vendor_name"
            ddlRawMatvendor.DataValueField = "vendor_code"
            ddlRawMatvendor.DataBind()
        End If
        ddlRawMatvendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub
    Public Sub populateStatus()
        Dim Obj As New POLinkingRequestClass
        Dim DS As New DataSet
        DS = Obj.GetLovDetails("DISPATCH_STATUS", Constant.Common.ActiveStatus)
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlStatus.DataSource = DS.Tables(0)
            ddlStatus.DataTextField = "lov_value"
            ddlStatus.DataValueField = "lov_code"
            ddlStatus.DataBind()
            'ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            ddlStatus.SelectedIndex = 0
            If DS.Tables(0).Rows.Count = 1 Then
                ddlStatus.SelectedIndex = 1
                ddlStatus.Enabled = False
            End If
        End If

    End Sub
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        PopulateList()
    End Sub
    Private Sub PopulateList()
        Dim obj As OPC_VendorClass = New OPC_VendorClass()
        Dim ds As DataSet = obj.Get_FG_Vendor_DispatchList(userInfo.userIDEntity, ddlRawMatvendor.SelectedValue.ToString(), ddlStatus.SelectedValue.ToString())

        If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim vendorName As String = ds.Tables(0).Rows(0)("rvm_vendor_name").ToString()
            'lblRmVendor.Text = vendorName ' or wherever you want to display it
        End If

        If (ds IsNot Nothing AndAlso ds.Tables.Count > 1 AndAlso ds.Tables(1) IsNot Nothing) Then
            RmGridHelper.BindPaged(gvDispatchList, ds.Tables(1))
        Else
            RmGridHelper.BindPaged(gvDispatchList, Nothing)
        End If

        BindSummaryCounts(ds)
    End Sub
    Protected Sub lbtnDetails_Click(sender As Object, e As EventArgs)
        Dim lbtn As LinkButton = CType(sender, LinkButton)
        Dim row As GridViewRow = CType(lbtn.NamingContainer, GridViewRow)
        Dim hdnReqId As HiddenField = CType(row.FindControl("hdnReqId"), HiddenField)
        Dim hdnVendorCode As HiddenField = CType(row.FindControl("hdnVendorCode"), HiddenField)
        Dim orhId As String = If(hdnReqId Is Nothing, String.Empty, hdnReqId.Value)
        Dim orhVendorCode As String = If(hdnVendorCode Is Nothing, String.Empty, hdnVendorCode.Value)
        Dim dispatchStatus As String = ddlStatus.SelectedValue

        If Not String.IsNullOrEmpty(orhId) AndAlso
           Not String.IsNullOrEmpty(orhVendorCode) AndAlso
           Not String.IsNullOrEmpty(dispatchStatus) Then

            Dim url As String =
                "FGVendor_DispatchDtlsaspx.aspx?orh_id=" & Server.UrlEncode(orhId) &
                "&orh_vendor_code=" & Server.UrlEncode(orhVendorCode) &
                "&dispatch_status=" & Server.UrlEncode(dispatchStatus) &
                "&rm_vendor_code=" & Server.UrlEncode(ddlRawMatvendor.SelectedValue)
            Response.Redirect(url)
        End If
    End Sub
    Private Sub BindSummaryCounts(ByVal currentDs As DataSet)

        Dim pendingCount As Integer = 0
        Dim completedCount As Integer = 0
        Dim totalCount As Integer = 0

        If currentDs IsNot Nothing AndAlso currentDs.Tables.Count > 2 AndAlso currentDs.Tables(2).Rows.Count > 0 Then

            Dim summaryRow As DataRow = currentDs.Tables(2).Rows(0)

            pendingCount = If(IsDBNull(summaryRow("pen_qty")), 0, Convert.ToInt32(summaryRow("pen_qty")))
            completedCount = If(IsDBNull(summaryRow("des_qty")), 0, Convert.ToInt32(summaryRow("des_qty")))
            totalCount = If(IsDBNull(summaryRow("tot_req")), 0, Convert.ToInt32(summaryRow("tot_req")))

        End If

        lblPendingRequests.Text = pendingCount.ToString()
        lblCompletedRequests.Text = completedCount.ToString()
        lblTotalRequests.Text = totalCount.ToString()

    End Sub
End Class
