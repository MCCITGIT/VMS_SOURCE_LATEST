Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient

Partial Class ChallanCancellationList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            CheckLogin()
            PopulateProcessYears()
            GetScreenDetails()
            PopulateRegion()
            PopulateDepotName()
            PopulateUnit()
            PageSizeDropdown()
            BindGrid()

        End If

    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

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
        Dim ScreenDS As DataSet
        Dim StockObj As New UnitDespatchClass
        ScreenDS = StockObj.GetSCreenDetails(userInfo.userBranchEntity)
        If (Not (ScreenDS Is Nothing) AndAlso ScreenDS.Tables.Count > 0 AndAlso Not (ScreenDS.Tables(0) Is Nothing) AndAlso ScreenDS.Tables(0).Rows.Count > 0) Then
            ddlYear.SelectedValue = ScreenDS.Tables(0).Rows(0)("year").ToString
            ddlMonth.SelectedValue = ScreenDS.Tables(0).Rows(0)("month").ToString
            'lblUnit.Text = ScreenDS.Tables(0).Rows(0)("unit").ToString
        End If
    End Sub

    Public Sub PopulateRegion()
        CheckLogin()
        Dim commonObj As New Common
        Dim RegionDS As New DataSet
        Dim RegiontypeDS As DataSet = commonObj.GetLovDetails(userInfo.userCompanyEntity, Constant.Common.REGION_TYPE, Constant.Common.ActiveStatus)
        If Not (RegiontypeDS Is Nothing) Then
            ddlRegion.DataSource = RegiontypeDS
            ddlRegion.DataTextField = "Lov_Value"
            ddlRegion.DataValueField = "Lov_Code"
            ddlRegion.DataBind()
            ddlRegion.Items.Insert(0, New ListItem("ALL", "", True))
        End If
    End Sub

    Public Sub PopulateDepotName()
        CheckLogin()
        ddlLocation.Items.Clear()
        Dim commonObj As New Common
        Dim DepotDS As New DataSet

        DepotDS = commonObj.Getdepotname(ddlRegion.SelectedValue)
        If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
            ddlLocation.DataSource = DepotDS.Tables(0)
            ddlLocation.DataTextField = "Depot_Name"
            ddlLocation.DataValueField = "depot_code"
            ddlLocation.DataBind()
            ddlLocation.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If

    End Sub

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
        'Modified-by MUKESH BHAGAT on 08-09-2026 : removed the hard-coded 999 "show all" default.
        'The dropdown now holds only the sizes configured in Web.config (PageSize), and the
        'default is the first of those - same as Estimation_Data_Despatched_Status.aspx.
        gvChallanDetails.PageSize = ddlPageSize.SelectedValue
    End Sub

    Private Sub PopulateUnit()
        CheckLogin()


        Dim UnitSet As New DataSet
        Dim StockObj As New UnitDespatchClass
        UnitSet = StockObj.GetUnit(ddlRegion.SelectedValue, Constant.Common.ActiveStatus)
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
    End Sub

#Region "Bind Grid"
    Private Sub BindGrid()
        Try
            Dim DespatchDS As DataSet
            Dim DespatchObj As New UnitDespatchClass
            DespatchDS = DespatchObj.GetChallanDetailsForCnacellation(ddlUnit.SelectedValue, ddlLocation.SelectedValue, ddlYear.SelectedValue, ddlMonth.SelectedValue)
            If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
                gvChallanDetails.DataSource = DespatchDS
                gvChallanDetails.DataBind()

            Else
                gvChallanDetails.DataSource = DespatchDS
                gvChallanDetails.DataBind()

            End If

        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub
#End Region

    'Modified-by MUKESH BHAGAT on 08-09-2026 : Search is now a LinkButton (see the .aspx), which
    'raises Click with plain EventArgs instead of ImageClickEventArgs. Also corrected the page
    'reset - PageIndex is zero-based, so the old "= 1" sent a fresh search to the SECOND page and
    'hid the first page of results. Now that the pager actually works this was visible on screen.
    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        gvChallanDetails.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub ddlRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepotName()
    End Sub

    Protected Sub gvChallanDetails_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvChallanDetails.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'Dim chk As CheckBox = e.Row.FindControl("chkSelect")
            'Dim pageIdx As Integer = gvChallanDetails.PageIndex * ddlPageSize.SelectedValue
            'e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            If rowView("desph_approved_yn") = "Y" Then
                e.Row.Cells(6).Text = "Approved"
                e.Row.Cells(3).Text = "<a href='ChallanCancellationEntry.aspx?" & Constant.SessionKeys.Challan_No & "=" & rowView("desph_challan_no").ToString & "&" & Constant.SessionKeys.Process_Year & "=" & rowView("desph_challan_fin_year") & "&" & Constant.SessionKeys.UnitCode & "=" & rowView("desph_desp_unit") & "'class='hl'>" & rowView("desph_challan_no") & "</a>"
                e.Row.BackColor = Drawing.Color.GreenYellow
            ElseIf rowView("desph_approved_yn") = "N" Then
                e.Row.Cells(6).Text = "Pending"


            ElseIf rowView("desph_approved_yn") = "R" Then
                e.Row.Cells(6).Text = "Cancelled"
                e.Row.BackColor = Drawing.Color.LightSeaGreen
                e.Row.Cells(3).Text = "<a href='ChallanCancellationEntry.aspx?" & Constant.SessionKeys.Challan_No & "=" & rowView("desph_challan_no").ToString & "&" & Constant.SessionKeys.Process_Year & "=" & rowView("desph_challan_fin_year") & "&" & Constant.SessionKeys.UnitCode & "=" & rowView("desph_desp_unit") & "'class='hl'>" & rowView("desph_challan_no") & "</a>"
            End If

        End If
    End Sub

    'Modified-by MUKESH BHAGAT on 07-09-2026 : Results Per Page and the pager were both dead on
    'this page - ddlPageSize posted back with nothing handling it, and the pager links did
    'nothing because PageIndexChanging was never handled. Wired the same way as the working
    'Estimation_Data_Despatched_Status.aspx. PageIndex is reset when the size changes so the
    'grid cannot be left sitting on a page number that no longer exists under the new size.
#Region "Paging"
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvChallanDetails.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue)
        gvChallanDetails.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub gvChallanDetails_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvChallanDetails.PageIndexChanging
        gvChallanDetails.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub
#End Region

End Class
