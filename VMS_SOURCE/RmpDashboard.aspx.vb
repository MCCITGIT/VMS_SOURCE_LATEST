
Imports System.Data
Imports NPOI.SS.Formula.Functions
Imports VMS.Web

Partial Class RmpDashboard
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            'PopulateVendor()
            PopulateDuration()
            BindDashboardDetails()
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateDuration()
        Dim Obj As New POLinkingRequestClass
        Dim DS As New DataSet
        DS = Obj.GetLovDetails("DURATION", Constant.Common.ActiveStatus)
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlDurationType.DataSource = DS.Tables(0)
            ddlDurationType.DataTextField = "lov_value"
            ddlDurationType.DataValueField = "lov_code"
            ddlDurationType.DataBind()
            ddlDurationType.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            If DS.Tables(0).Rows.Count = 1 Then
                ddlDurationType.SelectedIndex = 1
                ddlDurationType.Enabled = False
                ddlDurationType.Enabled = False
            End If
        End If
    End Sub

    Private Sub PopulateMonth()
        Dim Obj As New POLinkingRequestClass
        Dim DS As New DataSet
        DS = Obj.GetLovDetails("MONTH", Constant.Common.ActiveStatus)
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlMonth.DataSource = DS.Tables(0)
            ddlMonth.DataTextField = "lov_value"
            ddlMonth.DataValueField = "lov_code"
            ddlMonth.DataBind()
            ddlMonth.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            If DS.Tables(0).Rows.Count = 1 Then
                ddlMonth.SelectedIndex = 1
                ddlMonth.Enabled = False
            End If
        End If
    End Sub

    Private Sub PopulateFinYear()
        Dim Obj As New POLinkingRequestClass
        Dim DS As New DataSet
        DS = Obj.GetLovDetails("YEAR", Constant.Common.ActiveStatus)
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlYear.DataSource = DS.Tables(0)
            ddlYear.DataTextField = "lov_value"
            ddlYear.DataValueField = "lov_code"
            ddlYear.DataBind()
            ddlYear.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            If DS.Tables(0).Rows.Count = 1 Then
                ddlYear.SelectedIndex = 1
                ddlYear.Enabled = False
            End If
        End If
    End Sub

    Private Sub BindDashboardDetails()
        'divKpiCards.Visible = False
        divCharts.Visible = False
        RmPendingList.Visible = False
        divPurchaseRecord.Visible = False

        If ddlDurationType.Items.FindByValue("MONTHLY") IsNot Nothing Then
            ddlDurationType.SelectedValue = "MONTHLY"
        End If


        'Show Year and Month for Monthly selection
        divYear.Visible = True
        monthDiv.Visible = True

        'Common dropdown binding
        PopulateFinYear()
        PopulateMonth()

        'Select current year/month for both users
        SelectCurrentYearMonth()

        If String.Equals(userInfo.userDepartmentEntity.ToString(), Constant.Common.userDept, StringComparison.OrdinalIgnoreCase) Then
            'monthDiv.Visible = False
            'divYear.Visible = False
            'divDuration.Visible = False
            PopulateUnit()
        Else
            divVendor.Visible = False
            'monthDiv.Visible = False
            'divYear.Visible = False
            'divDuration.Visible = False

            Dim vendorCode As String = GetSelectedVendorCode()
            BindDashboardData(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
            BindPendingDispatchTable(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
            BindVerifiedVendorList(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
        End If
        'BindDashboardData()
    End Sub

    Private Sub SelectCurrentYearMonth()
        Dim today As DateTime = DateTime.Now

        'Current Financial Year
        Dim fyStartYear As Integer
        If today.Month >= 4 Then
            fyStartYear = today.Year
        Else
            fyStartYear = today.Year - 1
        End If

        Dim currentFY As String =
        fyStartYear.ToString() & "-" &
        (fyStartYear + 1).ToString()
        If ddlYear.Items.FindByText(currentFY) IsNot Nothing Then
            ddlYear.SelectedValue =
            ddlYear.Items.FindByText(currentFY).Value
        End If

        'Current Month
        'Dim currentMonth As String = today.Month.ToString()
        Dim currentMonth As String =
        today.Month.ToString("00")
        If ddlMonth.Items.FindByValue(currentMonth) IsNot Nothing Then
            ddlMonth.SelectedValue = currentMonth
        End If
    End Sub

    Private Sub PopulateUnit()
        Dim UnitDespatch As New PendingDespatchesClass
        Dim UnitSet As New DataSet

        UnitSet = UnitDespatch.GetUnitName(Constant.Common.ActiveStatus, String.Empty)
        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlvendor.DataSource = UnitSet.Tables(0)
            ddlvendor.DataTextField = "unit_name"
            ddlvendor.DataValueField = "unit_code"
            ddlvendor.DataBind()
            ddlvendor.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlvendor.SelectedValue = userInfo.userBranchEntity
            ddlvendor.Enabled = False
        End If
    End Sub

    Private Sub BindDashboardData(ByVal vendorCode As String, ByVal Year As String, ByVal Month As String)

        If String.IsNullOrWhiteSpace(vendorCode) OrElse vendorCode = "0" Then

            'divKpiCards.Visible = False
            divCharts.Visible = False
            RmPendingList.Visible = False
            divPurchaseRecord.Visible = False

            hdnRmChartData.Value = "[]"

            Exit Sub

        End If

        'divKpiCards.Visible = True
        divCharts.Visible = True
        RmPendingList.Visible = True
        divPurchaseRecord.Visible = True

        PopulateRmChart(vendorCode, Year, Month)

    End Sub

    Private Sub PopulateRmChart(ByVal userId As String, ByVal Year As String, ByVal Month As String)
        Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetRmConsumedDetails(userId, Year, Month)
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim chartData As New List(Of Object)()
            For Each row As DataRow In ds.Tables(0).Rows
                chartData.Add(New With {
                .RawMaterialCode = row("fd_rawmaterial_code").ToString(),
                .PurchasedQty = If(
                    IsDBNull(row("total_recv_qty")),
                    0D,
                    Convert.ToDecimal(row("total_recv_qty"))
                ),
                .UsedQty = If(
                    IsDBNull(row("total_qty_consumed")),
                    0D,
                    Convert.ToDecimal(row("total_qty_consumed"))
                )
            })
            Next
            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            hdnRmChartData.Value = serializer.Serialize(chartData)
        Else
            hdnRmChartData.Value = "[]"
            divCharts.Visible = False
        End If
    End Sub

    Private Sub BindPendingDispatchTable(ByVal userId As String, ByVal Year As String, ByVal Month As String)
        'userId = "U02"
        Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetPendingDispatchData(userId, Year, Month)
        Dim table As DataTable = RmGridHelper.GetTable(ds)
        'RmGridHelper.BindPaged(gvRmPendingList, table)
        If table IsNot Nothing AndAlso table.Rows.Count > 0 Then

            gvRmPendingList.Visible = True
            divGvPenList.Visible = False
            RmGridHelper.BindPaged(gvRmPendingList, table)

        Else
            RmPendingList.Visible = False
            divGvPenList.Visible = False
            gvRmPendingList.DataSource = Nothing
            gvRmPendingList.DataBind()
            gvRmPendingList.Visible = False

        End If
    End Sub

    Private Sub BindVerifiedVendorList(ByVal userId As String, ByVal Year As String, ByVal Month As String)
        'userId = "U02"
        Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetVerifiedVendorList(userId, Year, Month)
        Dim table As DataTable = RmGridHelper.GetTable(ds)
        'RmGridHelper.BindPaged(gvVerifiedVendorList, table)
        If table IsNot Nothing AndAlso table.Rows.Count > 0 Then

            gvVerifiedVendorList.Visible = True
            divGvVerList.Visible = False
            RmGridHelper.BindPaged(gvVerifiedVendorList, table)

        Else
            divPurchaseRecord.Visible = False
            divGvVerList.Visible = True
            gvVerifiedVendorList.DataSource = Nothing
            gvVerifiedVendorList.DataBind()
            gvVerifiedVendorList.Visible = False

        End If
    End Sub

    Protected Sub ddlDurationType_SelectedIndexChanged(sender As Object, e As EventArgs)
        If ddlDurationType.SelectedValue = "MONTHLY" Then
            divYear.Visible = True
            monthDiv.Visible = True
            PopulateMonth()
            PopulateFinYear()
        ElseIf ddlDurationType.SelectedValue = "YEARLY" Then
            divYear.Visible = True
            monthDiv.Visible = False
            PopulateFinYear()
        Else
            divYear.Visible = False
            monthDiv.Visible = False
        End If
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        Dim vendorCode As String = GetSelectedVendorCode()
        BindDashboardData(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
        BindPendingDispatchTable(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
        BindVerifiedVendorList(vendorCode, ddlYear.SelectedValue, ddlMonth.SelectedValue)
    End Sub

    Private Function GetSelectedVendorCode() As String

        'For Sysadmin / Unit login
        If String.Equals(userInfo.userDepartmentEntity.ToString(), Constant.Common.userDept, StringComparison.OrdinalIgnoreCase) Then
            Return ddlvendor.SelectedValue
        End If

        'For Vendor login
        Return userInfo.userBranchEntity

    End Function

    Protected Function GetStatusCss(status As String) As String

        If String.IsNullOrWhiteSpace(status) Then
            Return "rm-status-pill is-inactive"
        End If

        Select Case status.Trim().ToLower()

            Case "transit"
                Return "rmp-status transit"

            Case "pending"
                Return "rm-status-pill is-inactive"

            Case Else
                Return "rm-status-pill is-inactive"

        End Select

    End Function

    'Protected Sub btnRmListClose_Click(sender As Object, e As EventArgs)
    '    mpRmList.Hide()
    'End Sub

    Protected Sub gvRmPendingList_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Details" Then
            Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvRmPendingList.Rows(rowIndex)
            Dim reqId As Integer = Convert.ToInt32(CType(row.FindControl("lblReqId"), Label).Text)
            Dim vendorCode As String = GetSelectedVendorCode()
            Dim rmVendorCode As String = CType(row.FindControl("hdnRmCode"), HiddenField).Value

            Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
            Dim ds As DataSet = obj.Get_Rm_List(reqId, vendorCode, rmVendorCode)
            gvRmList.DataSource = ds.Tables(0)
            gvRmList.DataBind()
            mpRmList.Show()
            upPendingList.Update()
        End If
    End Sub
End Class
