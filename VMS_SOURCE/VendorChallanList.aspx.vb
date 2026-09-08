Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient
Imports System.Security.Permissions
Imports Microsoft.Win32

Partial Class VendorChallanList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page Load Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            btnAprove.Enabled = False
            CheckLogin()
            PopulateProcessYears()
            GetScreenDetails()
            PopulateRegion()
            PopulateDepotName()
            PopulateUnit()
            PageSizeDropdown()
            BindGrid()
            txtChallanNo.Attributes.Add("onkeypress", "KeyPressNumeric();")
        End If
    End Sub
#End Region

#Region "Event Handler"
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepotName()
    End Sub

    Protected Sub gvChallanDetails_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvChallanDetails.RowCommand
        If (e.CommandName = "Print") Then
            'Dim index As Integer = Convert.ToInt32(e.r
            '
            Dim gvRow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)

            Dim index As Integer = gvRow.RowIndex
            Dim row As GridViewRow = gvChallanDetails.Rows(index)
            Dim hdn As HiddenField
            Dim ReportViewer As New ReportViewer_DC

            ReportViewer.ReportFileName = AppDomain.CurrentDomain.BaseDirectory + Constant.ReportView.ReportFileLoc + Constant.ReportView.ReportName.Despatched_Advice_Report
            ReportViewer.ReportCase = Constant.ReportView.ReportCase.DespatchedAdviceRptCase


            hdn = row.FindControl("hdnUnit")
            ReportViewer.DsptchdAdviceUnit = hdn.Value
            hdn = row.FindControl("hdnDepot")
            ReportViewer.DsptchdAdviceDepot = hdn.Value
            hdn = row.FindControl("hdnyear")
            ReportViewer.DsptchdAdviceFinYear = hdn.Value
            hdn = row.FindControl("hdnChallanId")
            ReportViewer.DsptchdAdviceChlnNo = hdn.Value

            ReportViewer.Active = Constant.Common.ActiveStatus

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Show Report", "<script language='javascript'>fnNewWindow('ReportViewer.aspx','_blank')</script>", False)


        End If
        If (e.CommandName = "DeleteChallan") Then
            'Dim index As Integer = Convert.ToInt32(e.r
            '
            Dim gvRow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)

            Dim index As Integer = gvRow.RowIndex
            Dim row As GridViewRow = gvChallanDetails.Rows(index)
            Dim hdnyear As HiddenField
            Dim hdnChallanId As HiddenField

            hdnyear = row.FindControl("hdnyear")
            hdnChallanId = row.FindControl("hdnChallanId")

            DeleteDespatchChallan(hdnyear.Value, IIf(hdnChallanId.Value.Trim() <> String.Empty, Convert.ToInt32(hdnChallanId.Value.Trim()), 0))
            BindGrid()
        End If
        If (e.CommandName = "DownloadChallan") Then
            Dim gvRow As GridViewRow = CType(CType(e.CommandSource, ImageButton).NamingContainer, GridViewRow)
            CheckLogin()
            Dim index As Integer = gvRow.RowIndex
            Dim row As GridViewRow = gvChallanDetails.Rows(index)
            Dim hdndocpath As HiddenField = row.FindControl("hdndocpath")
            Dim hdnorgpath As HiddenField = row.FindControl("hdnorgpath")
            Dim DocumentName As String = hdndocpath.Value & "\" & hdnorgpath.Value
            Dim FileName As String = hdnorgpath.Value

            If (hdnorgpath.Value <> "") Then
                Dim genReportPath As String = String.Empty
                If (ddlType.SelectedValue = "Direct") Then
                    genReportPath = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Direct_Despatch_Docs" & "\"
                Else
                    genReportPath = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\"
                End If
                DownloadDocument(genReportPath, DocumentName, FileName)
            End If


        End If

        Try
            If e.CommandName.Equals("ViewDetails") Then

                ' Get the row index from CommandArgument
                Dim index As Integer = Convert.ToInt32(e.CommandArgument)

                ' Get the GridView row
                Dim row As GridViewRow = gvChallanDetails.Rows(index)

                Dim hdnUnit As HiddenField = row.FindControl("hdnUnit")
                Dim hdnyear As HiddenField = row.FindControl("hdnyear")
                Dim hdnMOnth As HiddenField = row.FindControl("hdnMOnth")
                Dim hdnChallanId As HiddenField = row.FindControl("hdnChallanId")
                Dim hdnDepot As HiddenField = row.FindControl("hdnDepot")

                ' Find the label inside the row
                Dim lbl As Label = CType(row.FindControl("lblName"), Label)

                If ddlStatus.SelectedValue = "A" And ddlType.SelectedValue = "Direct" Then
                    txtInvoiceNo.ReadOnly = False
                    txtInvoiceDate.Enabled = True
                    txtTransporterName.ReadOnly = False
                    txtLorryNo.ReadOnly = False
                    txtWayBill.ReadOnly = False
                    'btnSave.Visible = True

                    hdn_dispatchAssignHdr.Value = String.Empty
                    txtInvoiceNo.Text = String.Empty
                    'CalendarExtender.StartDate = DateTime.Now
                    txtInvoiceDate.Text = String.Empty
                    txtTransporterName.Text = String.Empty
                    txtLorryNo.Text = String.Empty
                    txtWayBill.Text = String.Empty

                    Dim ddrd_hdr_req_id As String = Convert.ToString(hdnChallanId.Value)

                    Dim ds As DataSet = New DataSet()
                    Dim Obj As VendorDispatchClass = New VendorDispatchClass()
                    ds = Obj.GetVendorDispatchAssignDetailsList(ddrd_hdr_req_id)

                    If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                        hdn_dispatchAssignHdr.Value = ddrd_hdr_req_id
                        gvDispatchAssignDtls.DataSource = ds.Tables(0)
                        gvDispatchAssignDtls.DataBind()
                    End If

                    Dim total As Decimal = 0
                    For i As Integer = 0 To gvDispatchAssignDtls.Rows.Count - 1
                        Dim lblTotalRate As Label = gvDispatchAssignDtls.Rows(i).FindControl("lblTotalRate")

                        If (lblTotalRate.Text = "") Then
                            total = total + Convert.ToDecimal(0)
                        Else
                            total = total + Convert.ToDecimal(lblTotalRate.Text)
                        End If
                    Next

                    lbltotalrateincgst.Text = total.ToString()

                    If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(1) Is Nothing) AndAlso ds.Tables(1).Rows.Count > 0) Then
                        txtTransporterName.Text = ds.Tables(1).Rows(0)("tm_transporter_name").ToString()
                        txtpono.Text = ds.Tables(1).Rows(0)("ddrh_po_no").ToString()
                    End If
                    If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(2) Is Nothing) AndAlso ds.Tables(2).Rows.Count > 0) Then
                        txtInvoiceNo.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vendor_invoice_no"))
                        txtInvoiceDate.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vendor_invoice_date"))
                        txtTransporterName.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_transporter_name"))
                        txtLorryNo.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vehicle_no"))
                        txtWayBill.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_waybill_no"))
                        'btnSave.Visible = False
                        txtInvoiceNo.ReadOnly = True
                        txtInvoiceDate.Enabled = False
                        txtTransporterName.ReadOnly = True
                        txtLorryNo.ReadOnly = True
                        txtWayBill.ReadOnly = True
                    End If

                    ModalPopupExtender2.Show()
                Else

                    'btnViewDetails.Visible = False
                    Response.Redirect("~/VendorChallanDetail.aspx?" & Constant.SessionKeys.Challan_No & "=" & Convert.ToString(hdnChallanId.Value) &
                  "&" & Constant.SessionKeys.Process_Year & "=" & hdnyear.Value &
                  "&" & Constant.SessionKeys.UnitCode & "=" & hdnUnit.Value, False)
                    HttpContext.Current.ApplicationInstance.CompleteRequest()
                    'e.Row.Cells(6).Text = "<a href='UnitDespatchPlanAddUpdateVr1.aspx?" & Constant.SessionKeys.Challan_No & "=" & rowView("desph_challan_no").ToString & "&" & Constant.SessionKeys.Process_Year & "=" & rowView("desph_challan_fin_year") & "&" & Constant.SessionKeys.UnitCode & "=" & rowView("desph_desp_unit") & "'class='hl'>" & rowView("desph_challan_no") & "</a>"
                End If

            End If


        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect(returnUrl)
        End Try
    End Sub
    Private Sub DownloadDocument(ByVal genReportPath As String, ByVal DocumentName As String, ByVal FileName As String)
        If genReportPath <> String.Empty AndAlso DocumentName <> String.Empty Then
            Dim appSupervisionFileAbsolutePath As String = String.Concat(genReportPath, DocumentName)
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = GetMIMETypeNew(appSupervisionFileAbsolutePath)
            Response.WriteFile(genReportPath & DocumentName)
            Response.AppendHeader("content-disposition", "attachment; filename=" & FileName)
            Response.TransmitFile(String.Concat(appSupervisionFileAbsolutePath))
            Response.Cache.SetCacheability(HttpCacheability.NoCache)
            Response.Flush()
            ' Response.End()
            'HttpContext.Current.Response.Flush()
            'HttpContext.Current.Response.SuppressContent = True
            'HttpContext.Current.ApplicationInstance.CompleteRequest()
        Else
            ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('Files or Directory Not Found!!');", True)
        End If
    End Sub
    Public Function GetMIMETypeNew(ByVal filepath As String) As String
        Dim regPerm As RegistryPermission = New RegistryPermission(RegistryPermissionAccess.Read, "\\HKEY_CLASSES_ROOT")
        Dim classesRoot As RegistryKey = Registry.ClassesRoot
        Dim fi = New FileInfo(filepath)
        Dim dotExt As String = LCase(fi.Extension)
        Dim typeKey As RegistryKey = classesRoot.OpenSubKey("MIME\Database\Content Type")
        Dim keyname As String = String.Empty
        For Each keyname In typeKey.GetSubKeyNames()
            Dim curKey As RegistryKey = classesRoot.OpenSubKey("MIME\Database\Content Type\" & keyname)
            If LCase(curKey.GetValue("Extension")) = dotExt Then
                Return keyname
            End If
        Next
        Return keyname
    End Function
    Protected Sub gvChallanDetails_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvChallanDetails.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim chk As CheckBox = e.Row.FindControl("chkSelect")
            'Dim ImgbtnDeleteChallan As ImageButton = e.Row.FindControl("ImgbtnDeleteChallan")
            Dim btnViewDetails As Button = e.Row.FindControl("btnViewDetails")
            Dim ImgbtnPrint As ImageButton = e.Row.FindControl("ImgbtnPrint")
            Dim pageIdx As Integer = gvChallanDetails.PageIndex * ddlPageSize.SelectedValue
            e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            If rowView("desph_approved_yn") = "Y" Then
                e.Row.Cells(11).Text = "Approved"
                chk.Visible = False
                'e.Row.BackColor = Drawing.Color.LawnGreen
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#a5faaf")
                'ImgbtnDeleteChallan.Visible = False
                ImgbtnPrint.Visible = True
            Else
                e.Row.Cells(11).Text = "Pending"
                'ImgbtnDeleteChallan.Visible = True
                ImgbtnPrint.Visible = False
            End If
            'e.Row.Cells(6).Text = "<a href='UnitDespatchPlanAddUpdateVr1.aspx?" & Constant.SessionKeys.Challan_No & "=" & rowView("desph_challan_no").ToString & "&" & Constant.SessionKeys.Process_Year & "=" & rowView("desph_challan_fin_year") & "&" & Constant.SessionKeys.UnitCode & "=" & rowView("desph_desp_unit") & "'class='hl'>" & rowView("desph_challan_no") & "</a>"
        End If

        If (e.Row.RowType = DataControlRowType.Pager) Then
            Dim row As TableRow = New TableRow
            'row = e.Row.Controls(0).Controls(0).Controls(0)
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

        If e.Row.RowType = DataControlRowType.DataRow OrElse e.Row.RowType = DataControlRowType.Header Then
            'Dim condition As Boolean = True ' Replace with your actual condition

            If (ddlType.SelectedValue = "Direct") Then
                e.Row.Cells(12).Visible = False
            Else
                e.Row.Cells(12).Visible = True
            End If
        End If
    End Sub

    Protected Sub btnAprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAprove.Click
        ChallanAprove()
        BindGrid()
    End Sub
    'Protected Sub ImgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnSearch.Click
    '    BindGrid()
    'End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        'Modified-by MUKESH BHAGAT on 07-09-2026 : a fresh search always starts at page 1
        gvChallanDetails.PageIndex = 0
        BindGrid()
    End Sub

    'Modified-by MUKESH BHAGAT on 07-09-2026 : Results Per Page / pagination were present in the
    'markup but had no handlers - changing the page size did nothing and clicking a pager link
    'threw "PageIndexChanging which wasn't handled". Wired the same pattern as
    'UsrPrflListNewMod.aspx (ddlPageSize_SelectedIndexChanged + IndexChanging).
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvChallanDetails.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue)
        gvChallanDetails.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub gvChallanDetails_IndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvChallanDetails.PageIndexChanging
        gvChallanDetails.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub

    Protected Sub gvChallanDetails_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvChallanDetails.SelectedIndexChanged

    End Sub
#End Region

#Region "Custom Method"
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

        If (ddlType.SelectedValue = "Depot") Then
            DepotDS = commonObj.Getdepotname(ddlRegion.SelectedValue)
        Else
            DepotDS = commonObj.Getdepotname_Vr1(ddlRegion.SelectedValue)
        End If
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
        'Modified-by MUKESH BHAGAT on 08-09-2026 : the hard-coded 999 "show all" size is gone.
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
    Private Sub BindGrid()
        Dim DespatchDS As DataSet
        Dim DespatchObj As New UnitDespatchClassVr1
        Dim chalanNo As Integer
        If txtChallanNo.Text.Trim <> "" Then
            chalanNo = CType(txtChallanNo.Text.Trim, Integer)
        Else
            chalanNo = Integer.MinValue
        End If
        DespatchDS = DespatchObj.GetChallanDetails_Vr1(ddlUnit.SelectedValue, ddlLocation.SelectedValue, ddlYear.SelectedValue, ddlMonth.SelectedValue, chalanNo, "A", userInfo.userIDEntity, ddlType.SelectedValue)
        If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
            gvChallanDetails.DataSource = DespatchDS
            gvChallanDetails.DataBind()
            btnAprove.Enabled = True
        Else
            gvChallanDetails.DataSource = Nothing
            gvChallanDetails.DataBind()
            btnAprove.Enabled = False
        End If
    End Sub


    Private Sub ChallanAprove()
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClass
        Dim hdrEntity As New DespatchHeaderEntity
        Dim numRowsAffected As Integer
        Dim sqlConn As New SqlConnection
        Dim sqlTrans As SqlTransaction

        Try
            Dim chk As CheckBox
            Dim hdnUnit, hdnMonth, hdnYr, hdnChallan, hdnDepot As HiddenField
            For i As Integer = 0 To gvChallanDetails.Rows.Count - 1
                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()
                Try
                    chk = gvChallanDetails.Rows(i).FindControl("chkSelect")
                    hdnChallan = gvChallanDetails.Rows(i).FindControl("hdnChallanId")
                    Dim challanNo As Integer
                    challanNo = hdnChallan.Value
                    hdnUnit = gvChallanDetails.Rows(i).FindControl("hdnUnit")
                    hdnMonth = gvChallanDetails.Rows(i).FindControl("hdnMOnth")
                    hdnYr = gvChallanDetails.Rows(i).FindControl("hdnyear")
                    hdnDepot = gvChallanDetails.Rows(i).FindControl("hdnDepot")
                    If chk.Checked Then
                        numRowsAffected = DespatchObj.AproveChallan(sqlConn, sqlTrans, challanNo, hdnUnit.Value, hdnYr.Value, hdnMonth.Value, Constant.Common.ActiveStatus, userInfo.userCompanyEntity)
                        If Not numRowsAffected > 0 Then
                            sqlTrans.Rollback()
                            GoTo z
                        Else
                            sqlTrans.Commit()

                            'If hdnUnit.Value = "U08" Then
                            '    sendMail(hdnDepot.Value, hdnUnit.Value, hdnYr.Value, challanNo, Constant.Common.ActiveStatus)
                            'End If

                        End If
                    End If
                    '' Need to comment out after oracle push sysnc|Start
                    'If numRowsAffected > 0 Then
                    '    If hdnDepot.Value.Trim().Equals("108") Then
                    '        Dim obj = New EmailSMSsender()
                    '        obj.SendSMS("9830384824,8013628024", "VMS: Depot Calcutta-IV(108) approved despatched challan. Need to run oracle push sync.")
                    '    End If
                    'End If
                    '' Need to comment out after oracle push sysnc|End
                Catch ex As Exception
                    If Not sqlTrans Is Nothing Then
                        sqlTrans.Rollback()
                    End If
                Finally
                    If Not sqlConn Is Nothing Then
                        sqlConn.Close()
                    End If
                End Try
            Next
            'sqlTrans.Commit()
        Catch ex As Exception
            'If Not sqlTrans Is Nothing Then
            '    sqlTrans.Rollback()
            'End If

        End Try
z:
    End Sub

    Public Sub sendMail(ByVal Depot As String, ByVal Unit As String, ByVal FinYear As String, ByVal ChallanNo As Int32, ByVal Active As String)

        Dim mstr As New UnitDespatchClass
        Dim Despatchds As New DataSet
        Dim filepath As String

        Despatchds = mstr.GetDespatchDetailsForMail(Depot, Unit, FinYear, ChallanNo, Active)

        If (Not (Despatchds Is Nothing) AndAlso Despatchds.Tables.Count > 0 AndAlso Not (Despatchds.Tables(0) Is Nothing) AndAlso Despatchds.Tables(0).Rows.Count > 0) Then
            Dim wrt_len As Integer = 70
            Dim tmp_len As Integer

            Dim SW As StreamWriter
            Dim file_name As String
            Dim RecPath As String = Format(DateTime.Now, "dd_MM_yyyy")

            filepath = ConfigurationManager.AppSettings("UPLOAD_DOCS_FOLDER_ABS_PATH") & "DespatchMail\" & RecPath
            'If Not System.IO.File.Exists(filepath) Then
            '    System.IO.File.Create(filepath)
            'End If
            If Not (Directory.Exists(filepath)) Then
                Directory.CreateDirectory(filepath)
            End If
            file_name = Convert.ToString(Despatchds.Tables(0).Rows(0)("UnitOracleId")) + "_" + Depot.ToString + "_" + DateTime.Now.ToFileTimeUtc.ToString() + ".txt"

            SW = File.CreateText(filepath & "\" & file_name)


            'tmp_len = Val(Despatchds.Tables(0).Select("max(len(sku_desc))"))
            'tmp_len = 60
            'wrt_len = wrt_len + tmp_len


            'For i = 0 To wrt_len
            '    SW.Write("-")
            'Next
            'SW.WriteLine("")
            'SW.WriteLine(Environment.NewLine)
            'SW.WriteLine("Vendor Name - " + )
            'SW.WriteLine("Depot - " + Despatchds.Tables(0).Rows(0)("Depot").ToString())
            'SW.WriteLine("Challan No - " + Despatchds.Tables(0).Rows(0)("Challan_No").ToString())
            'SW.WriteLine("Challan Date - " + Despatchds.Tables(0).Rows(0)("despd_challan_date").ToString())
            'SW.WriteLine("Vendor Challan No - " + Despatchds.Tables(0).Rows(0)("desph_excise_gp_no").ToString())
            'SW.WriteLine("Vendor Challan Date - " + Despatchds.Tables(0).Rows(0)("desph_excise_gp_dt").ToString())
            'SW.WriteLine("Transporter Name - " + Despatchds.Tables(0).Rows(0)("desph_transporter_name").ToString())
            'SW.WriteLine("Loaded in Vehicle No. - " + Despatchds.Tables(0).Rows(0)("desph_truck_no").ToString())
            'SW.WriteLine("Road Permit No. - " + Despatchds.Tables(0).Rows(0)("desph_road_permit_no").ToString())
            'For i = 0 To wrt_len
            '    SW.Write("-")
            'Next
            'SW.WriteLine("")


            SW.WriteLine("Vendor Code|Depot|Challan No|Challan Date|Vendor Challan No|Vendor Challan Date|Transporter Name|Loaded in Vehicle No|Road Permit No|SKU Code|NOP|VOLUME|")

            For i = 0 To Despatchds.Tables(0).Rows.Count - 1

                SW.WriteLine(Despatchds.Tables(0).Rows(i)("UnitOracleId").ToString() & "|" & Despatchds.Tables(0).Rows(i)("despd_desp_depot").ToString() & "|" & Despatchds.Tables(0).Rows(i)("despd_challan_no").ToString() & "|" & Despatchds.Tables(0).Rows(i)("despd_challan_date").ToString() & "|" & Despatchds.Tables(0).Rows(i)("desph_excise_gp_no").ToString() & "|" & Despatchds.Tables(0).Rows(i)("VendorChallanDate").ToString() & "|" & Despatchds.Tables(0).Rows(i)("desph_transporter_name").ToString() & "|" & Despatchds.Tables(0).Rows(i)("desph_truck_no").ToString() & "|" & Despatchds.Tables(0).Rows(i)("desph_road_permit_no").ToString() & "|" & Despatchds.Tables(0).Rows(i)("despd_sku_code").ToString & "|" & Despatchds.Tables(0).Rows(i)("despd_desp_nop").ToString & "|" & Format((Convert.ToDecimal(Despatchds.Tables(0).Rows(i)("despd_desp_nop")) * Convert.ToDecimal(Despatchds.Tables(0).Rows(i)("despd_sku_vol"))), "#0.00") & "|")

            Next
            'SW.WriteLine(Environment.NewLine)

            'For i = 0 To wrt_len
            '    SW.Write("-")
            'Next
            'SW.WriteLine("")
            SW.Close()



            Dim email_mstr As EmailSMSsender = New EmailSMSsender()

            Try
                Dim obj As New UnitDespatchClass
                Dim Ds As DataSet

                Ds = obj.GetMailIds("VendorDespatchMail")
                Dim result As String = String.Empty

                Dim subject As String = "Vendor Despatch ( " + Despatchds.Tables(0).Rows(0)("desph_excise_gp_no").ToString() + " - " + Despatchds.Tables(0).Rows(0)("desph_excise_gp_dt").ToString() + ")"
                Dim body As String = "Vendor Despatch to Depot" + Despatchds.Tables(0).Rows(0)("Depot").ToString() _
                      + Environment.NewLine + Environment.NewLine


                'result = email_mstr.sendEMail(
                'Ds.Tables(0).Rows(0)("MailIds_To").ToString,
                'Ds.Tables(0).Rows(0)("MailIds_CC").ToString,
                '(filepath & "\" & file_name),
                'subject,
                'body)

                Dim entity As New MailEntity
                entity.ToAddress = Ds.Tables(0).Rows(0)("MailIds_To").ToString
                entity.CCAddress = Ds.Tables(0).Rows(0)("MailIds_CC").ToString
                entity.BCCAddress = "automailer@mccit.co.in"
                entity.MailSubject = subject
                entity.MailBody = body
                entity.Attachment_Path = (filepath & "\" & file_name)
                entity.Sender_Task = "sendMail_UnitDespatchPlanListVr1"
                email_mstr.sendMail(entity)



            Catch ex As Exception
                'SW.WriteLine("Exception occurred - " + ex.Message + " - " + DateTime.Now.ToString())
            End Try
        End If

    End Sub
    Private Function LPad(ByVal str As String, ByVal len As Integer) As String
        Return str.PadLeft(len, " ")
    End Function
    Private Function RPad(ByVal str As String, ByVal len As Integer) As String
        Return str.PadRight(len, " ")
    End Function
    Private Sub DeleteDespatchChallan(ByVal challanYear As String, ByVal challanNo As Int32)
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClass
        Dim hdrEntity As New DespatchHeaderEntity
        Dim numRowsAffected As Integer
        Dim sqlConn As New SqlConnection
        Dim sqlTrans As SqlTransaction

        sqlConn = DBFactory.GetHelper.OpenConnection()
        sqlTrans = sqlConn.BeginTransaction()

        hdrEntity.DespUnit = userInfo.userBranchEntity
        hdrEntity.ChallanFinYear = challanYear
        hdrEntity.ChallanNo = challanNo

        numRowsAffected = DespatchObj.DeleteChallan(sqlConn, sqlTrans, hdrEntity)
        If (numRowsAffected > 0) Then
            sqlTrans.Commit()
        Else
            sqlTrans.Rollback()
        End If
        sqlConn.Close()
    End Sub

    Protected Sub gvDispatchAssignDtls_DataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDispatchAssignDtls.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim lblQty As Label = e.Row.FindControl("lblSumofQty")
            Dim hdnSkuRate As HiddenField = e.Row.FindControl("hdnSkuRate")
            Dim hdnSkuGST As HiddenField = e.Row.FindControl("hdnSkuGST")
            Dim lblTotalRate As Label = e.Row.FindControl("lblTotalRate")

            Dim qty As Decimal = Val(lblQty.Text)
            Dim rate As Decimal = Val(hdnSkuRate.Value)
            Dim gst As Decimal = Val(hdnSkuGST.Value)
            Dim totalAmt As Decimal = qty * rate
            Dim totalAmtWithGST As Decimal = (totalAmt + ((totalAmt * gst) / 100))
            lblTotalRate.Text = totalAmtWithGST.ToString("0.00")
        End If
    End Sub
#End Region


    Protected Sub ddlType_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateDepotName()
    End Sub

End Class
