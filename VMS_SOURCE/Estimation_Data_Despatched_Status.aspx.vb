'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : Estimation_Data_Despatched_Status.aspx.vb
'Created Date	: 06-December-2011
'Created By	    : Debayan Biswas
'Version	    : R02.00.00
'Description	: Code behind for Estimation_Data_Despatched_Status.aspx Page

'Modified By       Modified On       Version         Reason

'****************************************************************


Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports System.Collections.Generic
Partial Class Estimation_Data_Despatched_Status
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Request.QueryString("NoData") = "Yes") Then
            lblErrMsg.Text = "No record found!"
        Else
            lblErrMsg.Text = String.Empty
        End If

        If Not IsPostBack Then
            CheckLogin()
            PopulateRegion()
            PopulateDepot()
            PopulateUnit()
            PopulateProduct()
            PopulateYear()
            PopulateMonth()
            PageSizeDropdown()
            LoadSearchCriteria()
            'txtFinYear.Enabled = False
            'ddlMonth.Enabled = False
            Dim EstmtnDataDsptchdStat As New EstimationDataDespatchedStatus_App
            btnSubmit.Attributes.Add("onClick", "return ValidateEstmtnDataDsptchStat('" + EstmtnDataDsptchdStat.GetTopFinYear() + "','" + EstmtnDataDsptchdStat.GetLastFinYear() + "');")
            ' BindGrid()
        End If
    End Sub

#Region "Check Login"
    Private Sub CheckLogin()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub
#End Region

#Region "Populate Region"
    Private Sub PopulateRegion()
        CheckLogin()

        Dim ObjDocumentType As New Common
        Dim OccupationTypeSet As New DataSet
        Dim LovType As String = Constant.Common.REGION_TYPE
        OccupationTypeSet = ObjDocumentType.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)
        If (Not (OccupationTypeSet Is Nothing) AndAlso OccupationTypeSet.Tables.Count > 0 AndAlso Not (OccupationTypeSet.Tables(0) Is Nothing) AndAlso OccupationTypeSet.Tables(0).Rows.Count > 0) Then
            ddlRegion.DataSource = OccupationTypeSet.Tables(0)
            ddlRegion.DataTextField = "lov_value"
            ddlRegion.DataValueField = "lov_code"
            ddlRegion.DataBind()
            ddlRegion.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
            ddlRegion.SelectedValue = userInfo.userRegionEntity
            ddlRegion.Enabled = False
        End If

    End Sub
#End Region

#Region "Populate Depot"
    Private Sub PopulateDepot()
        CheckLogin()

        Dim EstmtnDataDsptchdStat As New EstimationDataDespatchedStatus_App
        Dim DepotSet As New DataSet

        DepotSet = EstmtnDataDsptchdStat.GetDepot(ddlRegion.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (DepotSet Is Nothing) AndAlso DepotSet.Tables.Count > 0 AndAlso Not (DepotSet.Tables(0) Is Nothing) AndAlso DepotSet.Tables(0).Rows.Count > 0) Then
            ddlLocation.DataSource = DepotSet.Tables(0)
            ddlLocation.DataTextField = "depot_name"
            ddlLocation.DataValueField = "depot_code"
            ddlLocation.DataBind()
            ddlLocation.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.REGION) Then
            ddlLocation.SelectedValue = userInfo.userBranchEntity
            ddlLocation.Enabled = False
        End If
    End Sub
#End Region

#Region "Populate Unit"
    Private Sub PopulateUnit()
        CheckLogin()

        Dim EstmtnDataDsptchdStat As New EstimationDataDespatchedStatus_App
        Dim UnitSet As New DataSet

        UnitSet = EstmtnDataDsptchdStat.GetUnit(Constant.Common.ActiveStatus)
        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlDsptchdUnit.DataSource = UnitSet.Tables(0)
            ddlDsptchdUnit.DataTextField = "unit_name"
            ddlDsptchdUnit.DataValueField = "unit_code"
            ddlDsptchdUnit.DataBind()
            ddlDsptchdUnit.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
        '    ddlDsptchdUnit.SelectedValue = userInfo.userUnitEntity
        '    ddlDsptchdUnit.Enabled = False
        'End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlDsptchdUnit.SelectedValue = userInfo.userBranchEntity
            ddlDsptchdUnit.Enabled = False
        End If
    End Sub
#End Region

#Region "Populate TxtProcessYear"
    Private Sub PopulateYear()
        CheckLogin()

        Dim DptDsptchdUntWise As New DepotDespatchUnitwiseApp
        Dim YearSet As New DataSet

        YearSet = DptDsptchdUntWise.GetYear(Constant.Common.ActiveStatus)
        If (Not (YearSet Is Nothing) AndAlso YearSet.Tables.Count > 0 AndAlso Not (YearSet.Tables(0) Is Nothing) AndAlso YearSet.Tables(0).Rows.Count > 0) Then
            'txtProcessYear.Text = "param_char_value"
            txtFinYear.Text = YearSet.Tables(0).Rows(0)("param_char_value")
            'txtProcessYear.DataBind()
        End If
    End Sub
#End Region

#Region "Populate TxtProcessMonth"
    Private Sub PopulateMonth()
        CheckLogin()

        Dim DptDsptchdUntWise As New DepotDespatchUnitwiseApp
        Dim MonthSet As New DataSet

        MonthSet = DptDsptchdUntWise.GetMonth(Constant.Common.ActiveStatus)
        If (Not (MonthSet Is Nothing) AndAlso MonthSet.Tables.Count > 0 AndAlso Not (MonthSet.Tables(0) Is Nothing) AndAlso MonthSet.Tables(0).Rows.Count > 0) Then
            'txtProcessMonth.Text = MonthSet.Tables(0).Rows(0)
            'txtProcessMonth.Text = "param_char_value"
            txtMonth.Text = MonthSet.Tables(0).Rows(0)("param_char_value")
            'txtProcessMonth.DataBind()
        End If
    End Sub
#End Region

#Region "Populate Page Size DropDownList"

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
            End Try
            System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        End While
        gvDsptchdStat.PageSize = ddlPageSize.SelectedValue

    End Sub
#End Region

#Region "Load Search Criteria"
    ' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()
        If Not (Session(Constant.SessionKeys.EstmtdDataDsptchdStatSearchInfo) Is Nothing) Then
            Dim EstmtdDataDsptchdStatSearchInfo As New EstmtdDataDsptchdStatSearchCriteria
            EstmtdDataDsptchdStatSearchInfo = CType(Session(Constant.SessionKeys.EstmtdDataDsptchdStatSearchInfo), EstmtdDataDsptchdStatSearchCriteria)
            ddlRegion.SelectedValue = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Region
            ddlLocation.SelectedValue = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Depot
            ddlDsptchdUnit.SelectedValue = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Unit
            txtMonth.Text = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Month
            ddlProduct.SelectedValue = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_SKU
            txtFinYear.Text = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Finyr
            ddlPrntOptn.SelectedValue = EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_PrntOptn
        End If
    End Sub
#End Region

#Region "Save Search Criteria"
    Public Sub SaveSearchCriteria()
        Checklogin()
        Dim EstmtdDataDsptchdStatSearchInfo As New EstmtdDataDsptchdStatSearchCriteria
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Region = ddlRegion.SelectedValue
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Depot = ddlLocation.SelectedValue
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Unit = ddlDsptchdUnit.SelectedValue
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_SKU = ddlProduct.SelectedValue
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Finyr = txtFinYear.Text.Trim
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_Month = txtMonth.Text
        EstmtdDataDsptchdStatSearchInfo.Estmtd_Data_Dsptchd_Stat_PrntOptn = ddlPrntOptn.SelectedValue
        Session(Constant.SessionKeys.EstmtdDataDsptchdStatSearchInfo) = EstmtdDataDsptchdStatSearchInfo
    End Sub
#End Region

#Region "ddlRegion_SelectedIndexChanged"
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepot()
        PopulateUnit()
    End Sub
#End Region

#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Try
            Dim EstmtnDataDsptchdStat As New EstimationDataDespatchedStatus_App
            Dim DetailSet As New DataSet

            DetailSet = EstmtnDataDsptchdStat.GetDetailsGvDsptchdStat(ddlRegion.SelectedValue, ddlLocation.SelectedValue, ddlDsptchdUnit.SelectedValue, ddlProduct.SelectedValue, txtFinYear.Text.Trim, txtMonth.Text.Trim, Constant.Common.ActiveStatus)
            If (Not (DetailSet Is Nothing) AndAlso DetailSet.Tables.Count > 0 AndAlso Not (DetailSet.Tables(0) Is Nothing) AndAlso DetailSet.Tables(0).Rows.Count > 0) Then
                gvDsptchdStat.Visible = True
                lblNoRecrds.Visible = False
                gvDsptchdStat.PageIndex = 0
                gvDsptchdStat.DataSource = FirstDespatchPage(DetailSet.Tables(0))
                gvDsptchdStat.DataBind()
                hdnEdsHasData.Value = "1"
                hdnEdsPageSize.Value = gvDsptchdStat.PageSize.ToString()
            Else
                gvDsptchdStat.Visible = False
                lblNoRecrds.Visible = True
                lblNoRecrds.Text = "No Records Found!!!"
                hdnEdsHasData.Value = "0"
            End If
            hdnEdsRegion.Value = ddlRegion.SelectedValue
            hdnEdsDepot.Value = ddlLocation.SelectedValue
            hdnEdsUnit.Value = ddlDsptchdUnit.SelectedValue
            hdnEdsSku.Value = ddlProduct.SelectedValue
            hdnEdsYear.Value = txtFinYear.Text.Trim
            hdnEdsMonth.Value = txtMonth.Text.Trim
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

#Region "gvDsptchdStat_RowDataBound"

    'Protected Sub gvDsptchdStat_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDsptchdStat.PageIndexChanging
    '    gvDsptchdStat.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
    Protected Sub gvDsptchdStat_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDsptchdStat.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'e.Row.Cells(0).Text = e.Row.RowIndex + 1
            Dim pageIdx As Integer = gvDsptchdStat.PageIndex * ddlPageSize.SelectedValue
            'e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            'Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            'e.Row.Cells(2).Text = "<a href='Vendor_SKU_AddUpdate.aspx?" + Constant.SessionKeys.SKUCode + "=" + rowView("v_sku_code") + "&" + Constant.SessionKeys.Unit + "=" + rowView("v_vendor_unit") + "'class='hl'>" + rowView("SkuDescription") + "</a>"

        End If

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

#Region "Search Button Click Event Handeling"
    'Protected Sub ImgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnSearch.Click
    '    Session(Constant.SessionKeys.EstmtdDataDsptchdStatSearchInfo) = Nothing
    '    SaveSearchCriteria()
    '    BindGrid()
    'End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        Session(Constant.SessionKeys.EstmtdDataDsptchdStatSearchInfo) = Nothing
        SaveSearchCriteria()
        BindGrid()
    End Sub

#End Region

    '#Region "Print Button Click Event Handeling"
    '    Protected Sub ImgbtnPrint_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnPrint.Click

    '    End Sub
    '#End Region

#Region "Function to Export Dataset to Excel"
    Protected Sub ExportToExcel(ByVal dset As DataSet, ByVal Response As HttpResponse, ByVal filename As String)

        Try
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"
            Response.Write("<div style='text-align:center;'><b>" + "SKU wise Despatch Status" + "</b></div><BR>")
            Response.Write("<b>" + "Company Name : " + userInfo.userCompanyEntity + "</b><BR>")
            'Response.Write("<img src='" + AppDomain.CurrentDomain.BaseDirectory + "/images/Berger.gif' /><BR>")
            'Response.Write("<div style='text-align:center;'><b>" + "From : " + fdate + "  to " + tdate + "</b></div><BR>")
            'Response.Write("<div style='text-align:right;'><b>" + "Report Date : " + Format(Date.Today, "dd/MM/yyyy") + "</b></div><BR>")
            Response.Write("<BR>")
            Response.AppendHeader("content-disposition", "attachment; filename=" + filename + ".xls")
            'Response.Cache.SetCacheability(HttpCacheability.NoCache)
            Dim stringwrite As New System.IO.StringWriter
            Dim htmlwrite As New System.Web.UI.HtmlTextWriter(stringwrite)

            Dim dg As New GridView
            dg.DataSource = dset.Tables(0)
            dg.DataBind()

            dg.RenderControl(htmlwrite)

            Response.Write(stringwrite.ToString)

            Response.End()
        Catch ex As Exception
            'Dim returnUrl As String = "~/ExceptionPage.aspx"
            'Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorExporttoExcel
            'Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect("~/Home.aspx")
    End Sub

    'Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
    '    txtSKU.Text = ""
    'End Sub

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvDsptchdStat.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        BindGrid()
    End Sub

#Region "Populate Product Dropdown"
    Private Sub PopulateProduct()
        CheckLogin()
        ddlProduct.Items.Clear()
        Dim DespatchDS As DataSet
        Dim DespatchObj As New EstimationDataDespatchedStatus_App
        
        DespatchDS = DespatchObj.GetProductList(ddlDsptchdUnit.SelectedValue, ddlLocation.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
            ddlProduct.DataSource = DespatchDS
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

    Protected Sub ddlLocation_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlLocation.SelectedIndexChanged
        PopulateProduct()
    End Sub

    Protected Sub ddlDsptchdUnit_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDsptchdUnit.SelectedIndexChanged
        PopulateProduct()
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        CheckLogin()
        SaveSearchCriteria()

        If ddlPrntOptn.SelectedValue = Constant.Common.ExcelFormat Then

            Dim EstmtnDataDsptchdStat As New EstimationDataDespatchedStatus_App
            Dim ExcelSet As New DataSet

            ExcelSet = EstmtnDataDsptchdStat.GetExcelDsptchdStatRpt(ddlRegion.SelectedValue, ddlLocation.SelectedValue, ddlDsptchdUnit.SelectedValue, ddlProduct.SelectedValue, txtFinYear.Text.Trim, txtMonth.Text.Trim, Constant.Common.ActiveStatus)
            If (ExcelSet.Tables(0).Rows.Count > 0) Then
                Dim i As Integer = ExcelSet.Tables(0).Rows.Count
                Dim FileNme As String
                FileNme = Convert.ToString(userInfo.userIDEntity)
                FileNme = FileNme + "_" + "Estimation_Data_Despatched_Status" + "_" + Convert.ToString(Date.Today.Day) + "_" + Convert.ToString(Date.Today.Month) + "_" + Convert.ToString(Date.Today.Year)
                ExportToExcel(ExcelSet, Response, FileNme)
            Else
                lblNoRecrds.Text = "No Records Found"
            End If
        Else

            Dim ReportViewer As New ReportViewer_DC

            ReportViewer.ReportFileName = AppDomain.CurrentDomain.BaseDirectory + Constant.ReportView.ReportFileLoc + Constant.ReportView.ReportName.Estimation_Data_Despatched_Status_Report
            ReportViewer.ReportCase = Constant.ReportView.ReportCase.EstmtnDataDsptchdStatRptCase

            ReportViewer.Region = ddlRegion.SelectedValue
            ReportViewer.EstmtdDataDepot = ddlLocation.SelectedValue
            'ReportViewer.EstmtdDataFinYear = ddlDsptchdUnit.SelectedValue
            ReportViewer.EstmtdDataUnit = ddlDsptchdUnit.SelectedValue
            ReportViewer.EstmtdDataSKUCode = ddlProduct.SelectedValue
            ReportViewer.EstmtdDataFinYear = txtFinYear.Text.Trim
            ReportViewer.EstmtdDataMonth = txtMonth.Text.Trim
            ReportViewer.Active = Constant.Common.ActiveStatus

            ClientScript.RegisterStartupScript(Me.GetType(), "Show Report", "<script language='javascript'>fnNewWindow('ReportViewer.aspx','_blank')</script>", False)

        End If
    End Sub

    Private Function FirstDespatchPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvDsptchdStat.PageSize
        If pageSize <= 0 Then pageSize = 15
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function GetMoreDespatchStatus(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal region As String, ByVal depot As String, ByVal unit As String, ByVal sku As String, ByVal finYear As String, ByVal month As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 15
        If pageIndex < 0 Then pageIndex = 0
        If userInfo.userGroupCodeEntity = "UNIT" Then unit = userInfo.userBranchEntity
        Dim ds As DataSet = New EstimationDataDespatchedStatus_App().GetDetailsGvDsptchdStat(If(region, String.Empty), If(depot, String.Empty), If(unit, String.Empty), If(sku, String.Empty), If(finYear, String.Empty), If(month, String.Empty), Constant.Common.ActiveStatus)
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .serial = (i + 1).ToString(),
                    .region = Convert.ToString(dr("region")),
                    .depot = Convert.ToString(dr("load_depot")),
                    .sku = Convert.ToString(dr("load_sku_code")),
                    .average = Convert.ToString(dr("load_average")),
                    .estimate = Convert.ToString(dr("load_estimate_nop")),
                    .tslFactor = Convert.ToString(dr("load_tsl_factor")),
                    .tsl = Convert.ToString(dr("load_tsl_nop")),
                    .stock = Convert.ToString(dr("load_stock")),
                    .autoIndent = Convert.ToString(dr("load_auto_indent")),
                    .branchIndent = Convert.ToString(dr("load_depot_indent_nop")),
                    .despDate = Convert.ToString(dr("Desp_date")),
                    .intransit = Convert.ToString(dr("INTRANSIT")),
                    .received = Convert.ToString(dr("RECEIVED at Depot")),
                    .lastDesp = Convert.ToString(dr("Last_Desp_date")),
                    .pendingAuto = Convert.ToString(dr("pending_auto_indent")),
                    .pendingManual = Convert.ToString(dr("pending_manual_indent")),
                    .currentDespatch = Convert.ToString(dr("current_despatch"))
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function
End Class
