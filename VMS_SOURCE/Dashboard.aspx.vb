
'***************************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : Dashboard.aspx.vb
'Created Date	: 27/12/2011
'Created By	    : Riddhikusal Datta 
'Version	    : R01.00.00
'Description	: Code behind for Dashboard

'Modified By       Modified On       Version         Reason

'****************************************************************


Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports ChartDirector

Partial Class Dashboard
    Inherits System.Web.UI.Page
    Dim unit_auto_kl, unit_auto_mt, unit_depot_kl, unit_depot_mt, unit_despatch_kl, unit_despatch_mt, unit_pending_kl, unit_pending_mt, unit_despatch, unit_sku, unit_transit_kl, unit_transit_mt, unit_monthload_kl, unit_monthload_mt As Decimal
   
    Dim depot_auto_kl, depot_auto_mt, depot_depot_kl, depot_depot_mt, depot_despatch_kl, depot_despatch_mt, depot_pending_kl, depot_pending_mt, depot_stock_kl, depot_stock_ml, depot_transit_kl, depot_transit_mt, depot_monthload_kl, depot_monthload_mt As Decimal
    Dim x As String
    Dim unitDs As System.Data.DataSet

    Dim userInfo As VMSUserEntity = New VMSUserEntity()


#Region "Login Check"
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
#End Region
#Region "Get Screen Details"
    'Modified-by MUKESH BHAGAT on 02-09-2026 : the Process Year list was hardcoded 2010-2025 in
    'the markup; on process-year rollover the SelectedValue assignment in GetScreenDetails
    'would throw and the page would stop opening. Generated up to the current year instead.
    Private Sub PopulateProcessYears()
        'Modified-by MUKESH BHAGAT on 02-09-2026 : now database-driven - years come from
        'dbo.fin_year through the shared Common.BindProcessYearDropdown, so a new process
        'year is one master-data insert for the whole application.
        Dim commonObj As New Common
        commonObj.BindProcessYearDropdown(ddlYear, Constant.Common.Company, Constant.Common.ActiveStatus)
    End Sub

    Private Sub GetScreenDetails()
        Dim ScreenDS As System.Data.DataSet
        Dim DashObj As New DashboardClass
        ScreenDS = DashObj.GetSCreenDetails(userInfo.userBranchEntity)
        If (Not (ScreenDS Is Nothing) AndAlso ScreenDS.Tables.Count > 0 AndAlso Not (ScreenDS.Tables(0) Is Nothing) AndAlso ScreenDS.Tables(0).Rows.Count > 0) Then
            ddlYear.SelectedValue = ScreenDS.Tables(0).Rows(0)("year").ToString
            ddlMonth.SelectedValue = ScreenDS.Tables(0).Rows(0)("month").ToString
            lblAson.Text = ScreenDS.Tables(0).Rows(0)("as_on").ToString + "   " + ScreenDS.Tables(0).Rows(0)("as_onTime").ToString
            lblLaststok.Text = ScreenDS.Tables(0).Rows(0)("stock_as_on").ToString
        End If
    End Sub
#End Region
#Region "Populate Unit"
    Private Sub PopulateUnit()
        CheckLogin()
        Dim UnitSet As New System.Data.DataSet
        Dim DashObj As New DashboardClass
        UnitSet = DashObj.GetUnit(Constant.Common.ActiveStatus)
        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlUnit.DataSource = UnitSet.Tables(0)
            ddlUnit.DataTextField = "unit_name"
            ddlUnit.DataValueField = "unit_code"
            ddlUnit.DataBind()
            ddlUnit.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlUnit.SelectedValue = userInfo.userBranchEntity
            ddlUnit.Enabled = False
        End If
        lblUnit.Text = ddlUnit.SelectedItem.Text
    End Sub
#End Region
#Region "Populate Product Dropdown"
    Private Sub PopulateProduct()
        CheckLogin()
        Dim DashDS As System.Data.DataSet
        Dim DashObj As New DashboardClass
        
        dashDS = DashObj.GetProductList(ddlUnit.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (DashDS Is Nothing) AndAlso DashDS.Tables.Count > 0 AndAlso Not (DashDS.Tables(0) Is Nothing) AndAlso DashDS.Tables(0).Rows.Count > 0) Then
            ddlProduct.DataSource = DashDS
            ddlProduct.DataTextField = "descript"
            ddlProduct.DataValueField = "product"
            ddlProduct.DataBind()
            ddlProduct.Items.Insert(0, New ListItem("All", String.Empty, True))
        Else
            ddlProduct.Items.Clear()
            ddlProduct.Items.Insert(0, New ListItem("Select", 0, True))
        End If


    End Sub
#End Region
#Region "Populate Region Dropdown"
    Public Sub PopulateRegion()
        CheckLogin()
        Dim commonObj As New Common
        Dim RegionDS As New System.Data.DataSet
        Dim RegiontypeDS As System.Data.DataSet = commonObj.GetLovDetails(userInfo.userCompanyEntity, Constant.Common.REGION_TYPE, Constant.Common.ActiveStatus)
        If Not (RegiontypeDS Is Nothing) Then
            ddlRegion.DataSource = RegiontypeDS
            ddlRegion.DataTextField = "Lov_Value"
            ddlRegion.DataValueField = "Lov_Code"
            ddlRegion.DataBind()
            ddlRegion.Items.Insert(0, New ListItem("ALL", "", True))
        End If
        If userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.REGION Then
            ddlRegion.SelectedValue = userInfo.userRegionEntity
            ddlRegion.Enabled = False
        End If
    End Sub
#End Region
#Region "Populate Depot Dropdown"
    Public Sub PopulateDepotName()
        CheckLogin()
        ddlLocation.Items.Clear()
        Dim commonObj As New Common
        Dim DepotDS As New System.Data.DataSet

        DepotDS = commonObj.Getdepotname(ddlRegion.SelectedValue)
        If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
            ddlLocation.DataSource = DepotDS.Tables(0)
            ddlLocation.DataTextField = "Depot_Name"
            ddlLocation.DataValueField = "depot_code"
            ddlLocation.DataBind()
            ddlLocation.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
        If userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT Then
            ddlLocation.SelectedValue = userInfo.userBranchEntity
            ddlLocation.Enabled = False
        End If
    End Sub
#End Region
#Region "Populate page size dropdown"

    ' Populates the page size dropdown
    Private Sub PageSizeDropdownUnit()
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
        gvUnitSummery.PageSize = ddlPageSize.SelectedValue
    End Sub

#End Region
#Region "Populate page size dropdown"

    ' Populates the page size dropdown
    Private Sub PageSizeDropdownDepot()
        ddlPageSize0.Items.Clear()
        'Gets the page size from the web.config file
        Dim configPagesize As String = ConfigurationManager.AppSettings.Get("PageSize")
        Dim numbers As String() = configPagesize.Split(",")
        Dim index As Integer = 0

        While index <= numbers.Length - 1
            Try
                Dim size As Integer = Convert.ToInt32(numbers(index))
                'Adds the page size to drop down list
                ddlPageSize0.Items.Add(New ListItem(size.ToString, size.ToString))
            Catch exp As Exception
                ddlPageSize0.Items.Clear()
                'LoadDefaultPageSize()
            End Try
            System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        End While
        'Modified-by MUKESH BHAGAT on 08-09-2026 : removed the hard-coded 999 "show all" default.
        'The dropdown now holds only the sizes configured in Web.config (PageSize).
        gvDepotSummery.PageSize = ddlPageSize.SelectedValue
    End Sub

#End Region
#Region "Bind Unit Summery Grid"
    Private Sub BindUnitGrid()
        Dim DashSet As New System.Data.DataSet
        Dim DashObj As New DashboardClass
        DashSet = DashObj.GetUnitWiseSummery(ddlUnit.SelectedValue, ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlLocation.SelectedValue, ddlRegion.SelectedValue)
        If (Not (DashSet Is Nothing) AndAlso DashSet.Tables.Count > 0 AndAlso Not (DashSet.Tables(0) Is Nothing) AndAlso DashSet.Tables(0).Rows.Count > 0) Then
            unitDs = DashSet
            gvUnitSummery.DataSource = DashSet
            gvUnitSummery.DataBind()

        Else
            gvUnitSummery.DataSource = DashSet
            gvUnitSummery.DataBind()
        End If
    End Sub
#End Region
#Region "Bind Depot Summery Grid"
    Private Sub BindDepotGrid()
        Dim DashSet As System.Data.DataSet
        Dim DashObj As New DashboardClass
        gvDepotSummery.PageSize = Convert.ToInt16(ddlPageSize0.SelectedValue)
        DashSet = DashObj.GetDepotWiseSummery(ddlUnit.SelectedValue, ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlProduct.SelectedValue, ddlLocation.SelectedValue, ddlRegion.SelectedValue)
        If (Not (DashSet Is Nothing) AndAlso DashSet.Tables.Count > 0 AndAlso Not (DashSet.Tables(0) Is Nothing) AndAlso DashSet.Tables(0).Rows.Count > 0) Then
            gvDepotSummery.DataSource = DashSet
            gvDepotSummery.DataBind()
        Else
            gvDepotSummery.DataSource = DashSet
            gvDepotSummery.DataBind()
        End If
    End Sub
#End Region
#Region "Initialize Variable"
    Private Sub Initiallization()
        unit_auto_kl = 0
        unit_auto_mt = 0
        unit_depot_kl = 0
        unit_depot_mt = 0
        unit_despatch_kl = 0
        unit_despatch_mt = 0
        unit_pending_kl = 0
        unit_pending_mt = 0
        unit_despatch = 0
        unit_sku = 0
        unit_transit_kl = 0
        unit_transit_mt = 0
        unit_monthload_kl = 0
        unit_monthload_mt = 0
        depot_auto_kl = 0
        depot_auto_mt = 0
        depot_depot_kl = 0
        depot_depot_mt = 0
        depot_despatch_kl = 0
        depot_despatch_mt = 0
        depot_pending_kl = 0
        depot_pending_mt = 0
        depot_stock_kl = 0
        depot_stock_ml = 0
        depot_transit_kl = 0
        depot_transit_mt = 0
        depot_monthload_kl = 0
        depot_monthload_mt = 0
    End Sub
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Initiallization()
            OffVisibility()
            CheckLogin()
            PopulateUnit()
            PopulateRegion()
            PopulateDepotName()
            PopulateProduct()
            PopulateProcessYears()
            GetScreenDetails()
            PageSizeDropdownUnit()
            PageSizeDropdownDepot()
            LoadSearchCriteria()
            BindUnitGrid()
            BindDepotGrid()
            ChartCreation()
        End If
    End Sub
    'Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSearch.Click
    '    Search()
    'End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Search()
    End Sub

    Protected Sub ddlProduct_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProduct.SelectedIndexChanged
        OffVisibility()
        BindDepotGrid()
        BindUnitGrid()
        ChartCreation()
    End Sub
    Protected Sub gvUnitSummery_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvUnitSummery.PageIndexChanging
        gvUnitSummery.PageIndex = e.NewPageIndex
        Search()
    End Sub
    Protected Sub gvUnitSummery_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUnitSummery.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            unit_auto_kl += CType(rowView("autoindent_kl"), Decimal)
            unit_auto_mt += CType(rowView("autoindent_mt"), Decimal)
            unit_depot_kl += CType(rowView("depotindent_kl"), Decimal)
            unit_depot_mt += CType(rowView("depotindent_mt"), Decimal)
            unit_despatch_kl += CType(rowView("despatch_kl"), Decimal)
            unit_despatch_mt += CType(rowView("despatch_mt"), Decimal)
            unit_pending_kl += CType(rowView("pending_kl"), Decimal)
            unit_pending_mt += CType(rowView("pending_mt"), Decimal)
            unit_despatch += CType(rowView("despatchedPercent"), Integer)
            unit_sku += CType(rowView("pendingPercent"), Integer)
            unit_transit_kl += CType(rowView("transit_kl"), Decimal)
            unit_transit_mt += CType(rowView("transit_mt"), Decimal)
            unit_monthload_kl += CType(rowView("monthload_kl"), Decimal)
            unit_monthload_mt += CType(rowView("monthload_mt"), Decimal)
        End If

        If (e.Row.RowType = DataControlRowType.Footer) Then
            Dim lbl As Label

            lbl = e.Row.FindControl("lblAutoindent_Kl_Ftr")
            lbl.Text = unit_auto_kl
            lbl = e.Row.FindControl("lblAutoindent_Mt_Ftr")
            lbl.Text = unit_auto_mt
            lbl = e.Row.FindControl("lblDepotindent_Kl_Ftr")
            lbl.Text = unit_depot_kl
            lbl = e.Row.FindControl("lblDepotindent_Mt_Ftr")
            lbl.Text = unit_depot_mt
            lbl = e.Row.FindControl("lblDespatch_Kl_Ftr")
            lbl.Text = unit_despatch_kl
            lbl = e.Row.FindControl("lblDespatch_Mt_Ftr")
            lbl.Text = unit_despatch_mt
            lbl = e.Row.FindControl("lblPendingLoad_Kl_Ftr")
            lbl.Text = unit_pending_kl
            lbl = e.Row.FindControl("lblPendingLoad_Mt_Ftr")
            lbl.Text = unit_pending_mt
            lbl = e.Row.FindControl("lblTotalDespatch_Ftr")
            'displaying %despatch
            'lbl.Text = Format((((unit_despatch_kl + unit_despatch_mt / 2.8) * 100) / ((unit_auto_kl + unit_depot_kl) + (unit_auto_mt + unit_depot_mt) / 2.8)), "##.##")
            'lbl = e.Row.FindControl("lblTotalSKU_Ftr")
            'displaying %pending
            'lbl.Text = Format((100 - (((unit_despatch_kl + unit_despatch_mt / 2.8) * 100) / ((unit_auto_kl + unit_depot_kl) + (unit_auto_mt + unit_depot_mt) / 2.8))), "##.##")

            lbl.Text = Format((((unit_despatch_kl + unit_despatch_mt / 2.8) * 100) / (unit_monthload_kl + unit_monthload_mt / 2.8)), "##.##")

            lbl = e.Row.FindControl("lblTransit_Kl_Ftr")
            lbl.Text = unit_transit_kl
            lbl = e.Row.FindControl("lblTransit_Mt_Ftr")
            lbl.Text = unit_transit_mt
            lbl = e.Row.FindControl("lblMonthLoad_Kl_Ftr")
            lbl.Text = unit_monthload_kl
            lbl = e.Row.FindControl("lblMonthLoad_Mt_Ftr")
            lbl.Text = unit_monthload_mt
        End If
    End Sub
    Protected Sub gvDepotSummery_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDepotSummery.PageIndexChanging
        gvDepotSummery.PageIndex = e.NewPageIndex
        Search()
    End Sub
    Protected Sub gvDepotSummery_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDepotSummery.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            depot_auto_kl += CType(rowView("autoindent_kl"), Decimal)
            depot_auto_mt += CType(rowView("autoindent_mt"), Decimal)
            depot_depot_kl += CType(rowView("depotindent_kl"), Decimal)
            depot_depot_mt += CType(rowView("depotindent_mt"), Decimal)
            depot_despatch_kl += CType(rowView("despatch_kl"), Decimal)
            depot_despatch_mt += CType(rowView("despatch_mt"), Decimal)
            depot_pending_kl += CType(rowView("pending_kl"), Decimal)
            depot_pending_mt += CType(rowView("pending_mt"), Decimal)
            depot_stock_kl += CType(rowView("stock_kl"), Decimal)
            depot_stock_ml += CType(rowView("stock_mt"), Decimal)
            depot_transit_kl += CType(rowView("transit_kl"), Decimal)
            depot_transit_mt += CType(rowView("transit_mt"), Decimal)
            depot_monthload_kl += CType(rowView("monthload_kl"), Decimal)
            depot_monthload_mt += CType(rowView("monthload_mt"), Decimal)
        End If

        If (e.Row.RowType = DataControlRowType.Footer) Then
            Dim lbl As Label

            lbl = e.Row.FindControl("lblAutoindent_Kl_Ftr0")
            lbl.Text = depot_auto_kl
            lbl = e.Row.FindControl("lblAutoindent_Mt_Ftr0")
            lbl.Text = depot_auto_mt
            lbl = e.Row.FindControl("lblDepotindent_Kl_Ftr0")
            lbl.Text = depot_depot_kl
            lbl = e.Row.FindControl("lblDepotindent_Mt_Ftr0")
            lbl.Text = depot_depot_mt
            lbl = e.Row.FindControl("lblDespatch_Kl_Ftr0")
            lbl.Text = depot_despatch_kl
            lbl = e.Row.FindControl("lblDespatch_Mt_Ftr0")
            lbl.Text = depot_despatch_mt
            lbl = e.Row.FindControl("lblPendingLoad_Kl_Ftr")
            lbl.Text = depot_pending_kl
            lbl = e.Row.FindControl("lblPendingLoad_Mt_Ftr")
            lbl.Text = depot_pending_mt
            lbl = e.Row.FindControl("lblStock_Kl_Ftr")
            lbl.Text = depot_stock_kl
            lbl = e.Row.FindControl("lblStock_Mt_Ftr")
            lbl.Text = depot_stock_ml
            lbl = e.Row.FindControl("lblTransit_Kl_Ftr0")
            lbl.Text = depot_transit_kl
            lbl = e.Row.FindControl("lblTransit_Mt_Ftr0")
            lbl.Text = depot_transit_mt

            lbl = e.Row.FindControl("lblMonthLoad_Kl_Ftr")
            lbl.Text = depot_monthload_kl
            lbl = e.Row.FindControl("lblMonthLoad_Mt_Ftr")
            lbl.Text = depot_monthload_mt
        End If
    End Sub
    Protected Sub ddlLocation_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlLocation.SelectedIndexChanged
        Search()
    End Sub
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepotName()
        Search()
    End Sub
    Protected Sub ddlUnit_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlUnit.SelectedIndexChanged
        Search()
    End Sub
    Protected Sub ddlYear_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlYear.SelectedIndexChanged
        Search()
    End Sub
    Protected Sub ddlMonth_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMonth.SelectedIndexChanged
        Search()
    End Sub
#Region "Chart Creation"
    Private Sub ChartCreation()
        'If (Not (unitDs Is Nothing) AndAlso unitDs.Tables.Count > 0 AndAlso Not (unitDs.Tables(0) Is Nothing) AndAlso unitDs.Tables(0).Rows.Count > 0) Then
        '    Dim rCount As Integer = unitDs.Tables(0).Rows.Count
        '    For i As Integer = 1 To rCount
        '        'MakeBarChart(i, unitDs.Tables(0).Rows(i - 1)("autoindent_kl"), _
        '        '              unitDs.Tables(0).Rows(i - 1)("autoindent_mt"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("depotindent_kl"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("depotindent_mt"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("despatch_kl"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("despatch_mt"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("pending_kl"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("pending_mt"), _
        '        '                unitDs.Tables(0).Rows(i - 1)("unit"))
        '        'logic change by KSM , done by Riddhi on 27/06/2012
        '        MakeBarChart(i, unitDs.Tables(0).Rows(i - 1)("autoloadIncremental_kl"), _
        '                     unitDs.Tables(0).Rows(i - 1)("autoloadIncremental_mt"), _
        '                       unitDs.Tables(0).Rows(i - 1)("depotloadOriginal_kl"), _
        '                       unitDs.Tables(0).Rows(i - 1)("depotloadOriginal_mt"), _
        '                       unitDs.Tables(0).Rows(i - 1)("despatch_kl"), _
        '                       unitDs.Tables(0).Rows(i - 1)("despatch_mt"), _
        '                       unitDs.Tables(0).Rows(i - 1)("pending_kl"), _
        '                       unitDs.Tables(0).Rows(i - 1)("pending_mt"), _
        '                       unitDs.Tables(0).Rows(i - 1)("unit"))
        '    Next
        'End If

    End Sub
#End Region
#Region "Get Bar Chart"
    Private Sub MakeBarChart(ByVal id As Integer, ByVal auto_kl As Decimal, ByVal auto_mt As Decimal, ByVal depot_kl As Decimal, ByVal depot_mt As Decimal, ByVal despatch_kl As Decimal, ByVal despatch_mt As Decimal, ByVal pending_kl As Decimal, ByVal pending_mt As Decimal, ByVal unit As String)
        'Dim td1 As String = "td" + id.ToString
        'Dim td As System.Web.UI.HtmlControls.HtmlTableCell = Me.FindControl(td1)
        'td.Style("display") = "block"
        Dim controlName As String = "cv_unit" + id.ToString
        Dim controlId As ChartDirector.WebChartViewer = Me.FindControl(controlName)
        controlId.Visible = True
        ' The data for the bar chart
        Dim data0() As Double = {auto_kl, depot_kl, despatch_kl, pending_kl}
        Dim data1() As Double = {auto_mt, depot_mt, despatch_mt, pending_mt}

        Dim labels() As String = {"Auto Indent", "Depot Indent", "Desp-to-Date", "Pending Load"}

        ' Create a XYChart object of size 540 x 375 pixels
        Dim c As XYChart = New XYChart(540, 375)

        ' Add a title to the chart using 18 pts Times Bold Italic font
        c.addTitle("Satistics For : " & unit, "Times New Roman Bold Italic", 18, &H8E1104)

        ' Set the plotarea at (50, 55) and of 440 x 280 pixels in size. Use a vertical
        ' gradient color from grey (888888) to black (000000) as background. Set border
        ' and grid lines to white (ffffff).
        c.setPlotArea(50, 55, 440, 280, c.linearGradientColor(0, 55, 0, 335, &HCCF4FA, _
            &HA363D), -1, &HFFFFFF, &HFFFFFF)

        ' Add a legend box at (50, 25) using horizontal layout. Use 10pts Arial Bold as
        ' font, with transparent background.
        c.addLegend(50, 25, False, "Arial Bold", 10).setBackground(Chart.Transparent)

        ' Set the x axis labels
        c.xAxis().setLabels(labels)

        ' Draw the ticks between label positions (instead of at label positions)
        c.xAxis().setTickOffset(0.5)

        ' Set axis label style to 8pts Arial Bold
        c.xAxis().setLabelStyle("Arial Bold", 8)
        c.yAxis().setLabelStyle("Arial Bold", 8)

        ' Set axis line width to 2 pixels
        c.xAxis().setWidth(2)
        c.yAxis().setWidth(2)

        ' Add axis title
        c.yAxis().setTitle("Volume")

        ' Add a multi-bar layer with 3 data sets and 4 pixels 3D depth
        Dim layer As BarLayer = c.addBarLayer2(Chart.Side, 4)
        layer.addDataSet(data0, &HFF, "KL")
        layer.addDataSet(data1, &HEF0A1A, "MT")


        ' Set bar border to transparent. Use bar gradient lighting with light intensity
        ' from 0.75 to 1.75.
        layer.setBorderColor(Chart.Transparent, Chart.barLighting(0.75, 1.75))

        ' Configure the bars within a group to touch each others (no gap)
        layer.setBarGap(0.2, Chart.TouchBar)

        ' Output the chart
        controlId.Image = c.makeWebImage(Chart.PNG)

        ' Include tool tip for the chart
        controlId.ImageMap = c.getHTMLImageMap("", "", _
            "title='{xLabel}-{dataSetName}:Value={value}'")



    End Sub
#End Region
#Region "Off visibility of all charts"
    Private Sub OffVisibility()
        cv_unit1.Visible = False
        cv_unit2.Visible = False
        cv_unit3.Visible = False
        cv_unit4.Visible = False
        cv_unit5.Visible = False
        cv_unit6.Visible = False
        cv_unit7.Visible = False
        cv_unit8.Visible = False
        cv_unit9.Visible = False
        cv_unit10.Visible = False
        cv_unit11.Visible = False
        cv_unit12.Visible = False
        cv_unit13.Visible = False
    End Sub
#End Region
#Region "Load Search Criteria"
    ' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()
        If Not (Session(Constant.SessionKeys.DashboardSearch) Is Nothing) Then
            Dim SearchInfo As New DashboardSearchCriteria
            SearchInfo = CType(Session(Constant.SessionKeys.DashboardSearch), DashboardSearchCriteria)
            ddlUnit.SelectedValue = SearchInfo.Unit
            ddlRegion.SelectedValue = SearchInfo.Region
            ddlLocation.SelectedValue = SearchInfo.Depot
            ddlYear.SelectedValue = SearchInfo.Year
            ddlMonth.SelectedValue = SearchInfo.Month
            ddlProduct.SelectedValue = SearchInfo.Product
            ddlPageSize.SelectedValue = SearchInfo.UnitPageSize
            gvUnitSummery.PageSize = ddlPageSize.SelectedValue
            gvUnitSummery.PageIndex = SearchInfo.UnitPageIndex
            ddlPageSize0.SelectedValue = SearchInfo.DepotPageSize
            gvDepotSummery.PageSize = ddlPageSize0.SelectedValue
            gvDepotSummery.PageIndex = SearchInfo.DepotPageIndex

        End If
    End Sub
#End Region
#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()
        Dim SearchInfo As New DashboardSearchCriteria
        SearchInfo.Unit = ddlUnit.SelectedValue
        SearchInfo.Region = ddlRegion.SelectedValue
        SearchInfo.Depot = ddlLocation.SelectedValue
        SearchInfo.Year = ddlYear.SelectedValue
        SearchInfo.Month = ddlMonth.SelectedValue
        SearchInfo.Product = ddlProduct.SelectedValue
        SearchInfo.UnitPageSize = ddlPageSize.SelectedValue
        SearchInfo.UnitPageIndex = gvUnitSummery.PageIndex
        SearchInfo.DepotPageSize = ddlPageSize0.SelectedValue
        SearchInfo.DepotPageIndex = gvDepotSummery.PageIndex
        Session(Constant.SessionKeys.DashboardSearch) = SearchInfo
    End Sub
#End Region
#Region "Function For Search"
    Private Sub Search()
        OffVisibility()
        BindUnitGrid()
        BindDepotGrid()
        lblUnit.Text = ddlUnit.SelectedItem.Text
        ChartCreation()
        SaveSearchCriteria()
    End Sub
#End Region
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvUnitSummery.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        BindUnitGrid()
    End Sub
    Protected Sub ddlPageSize0_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize0.SelectedIndexChanged
        gvDepotSummery.PageSize = Convert.ToInt16(ddlPageSize0.SelectedValue)
        Search()
    End Sub

End Class
