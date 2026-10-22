Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic
Imports System.Security.Permissions
Imports Microsoft.Win32

Partial Class VendorChallanDetail
    Inherits System.Web.UI.Page
    Dim Updatemode As Boolean = False
    Dim Aproved_yn As Boolean = False
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page Load Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            TranspoterClearControl()
            txtTranspoterName.Enabled = False
            btnResetdealerDetails.Enabled = False
            txtTransporter.Enabled = True

            lblErrorMessage.Text = String.Empty
            If Not Request.QueryString(Constant.SessionKeys.Challan_No) Is Nothing Then
                PopulateUpdateMode(Request.QueryString(Constant.SessionKeys.Challan_No), Request.QueryString(Constant.SessionKeys.Process_Year), Request.QueryString(Constant.SessionKeys.UnitCode))
            Else
                btnSubmit.Enabled = False
                btnDelete.Visible = False
                txtChallanDt.Text = Format(Date.Now, "dd/MM/yyyy")
                txtCenvatDt.Text = Format(Date.Now, "dd/MM/yyyy")
                GetScreenDetails()
                PopulateRegion()
                PopulateDepotName()
                PopulateDeliveryDepotName()
                PopulatePONo()
                PopulateSiteDetails()
                PageSizeDropdown()
            End If
            AddAttributes()
        End If
    End Sub
#End Region

#Region "Event Handler"
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepotName()
        PopulateDeliveryDepotName()
        'ddlDeliveryDepot.SelectedValue = ddlLocation.SelectedValue
        PopulateProduct()
        PopulateSiteDetails()
        PopulatePONo()
    End Sub
    Protected Sub gvSKUDetails_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSKUDetails.RowCreated

    End Sub
    Protected Sub gvStockDetails_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSKUDetails.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim pageIdx As Integer = gvSKUDetails.PageIndex * ddlPageSize.SelectedValue
            e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim chk As CheckBox = e.Row.FindControl("chkSelect")
            Dim txt As TextBox = e.Row.FindControl("txtThisDesp")
            Dim lbl As Label = e.Row.FindControl("lblPendingLoad")
            Dim lblTotalRate As Label = e.Row.FindControl("lblTotalRate")
            Dim txtLotNo As TextBox = e.Row.FindControl("txtLOT")
            Dim hdnSkuRate As HiddenField = e.Row.FindControl("hdnSkuRate")
            Dim hdnSkuGST As HiddenField = e.Row.FindControl("hdnSkuGST")
            Dim btnGo As Button = e.Row.FindControl("btnGo")

            txt.Attributes.Add("onKeyPress", "KeyPressNumeric();")
            txt.Attributes.Add("onblur", "CheckMaxLimit('" + txt.ClientID + "','" + lbl.ClientID + "','" & hdnSkuRate.ClientID & "','" & hdnSkuGST.ClientID & "','" & lblTotalRate.ClientID & "');")
            chk.Attributes.Add("onClick", "RowCheck('" & chk.ClientID & "','" & txt.ClientID & "','" & txtLotNo.ClientID & "','" & hdnSkuRate.ClientID & "','" & hdnSkuGST.ClientID & "','" & lblTotalRate.ClientID & "');")

            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            If Updatemode = True Then
                If rowView("skuExist") = "Y" Then
                    chk.Checked = True
                    txt.Enabled = False
                    txt.Text = rowView("this_Despatch").ToString
                End If
                If CType(rowView("pendingLoad"), Integer) < 0 Then
                    txt.Text = "0"
                    e.Row.Cells(7).Text = "0"
                End If
            Else
                If CType(rowView("pendingLoad"), Integer) < 0 Then
                    txt.Text = "0"
                    e.Row.Cells(7).Text = "0"
                End If
            End If

            If chk.Checked = True Then
                Dim qty As Decimal = Val(txt.Text)
                Dim rate As Decimal = Val(hdnSkuRate.Value)
                Dim gst As Decimal = Val(hdnSkuGST.Value)
                Dim totalAmt As Decimal = qty * rate
                Dim totalAmtWithGST As Decimal = (totalAmt + ((totalAmt * gst) / 100))
                lblTotalRate.Text = totalAmtWithGST.ToString("0.00")
            Else
                lblTotalRate.Text = String.Empty
            End If
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
    End Sub
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvSKUDetails.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        BindGrid()
    End Sub
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        If Not btnSubmit.Enabled = False Then
            Dim chk As CheckBox
            Dim txtThisDesp As TextBox
            Dim hdnSkuRate As HiddenField
            Dim hdnSkuGST As HiddenField
            Dim ChkCount As Integer = 0
            Dim TotalRate As Decimal = 0
            Dim Obj As New UnitDespatchClassVr1
            Dim ds As DataSet = New DataSet()

            CheckLogin()

            For i As Integer = 0 To gvSKUDetails.Rows.Count - 1
                chk = gvSKUDetails.Rows(i).FindControl("chkSelect")
                txtThisDesp = gvSKUDetails.Rows(i).FindControl("txtThisDesp")
                hdnSkuRate = gvSKUDetails.Rows(i).FindControl("hdnSkuRate")
                hdnSkuGST = gvSKUDetails.Rows(i).FindControl("hdnSkuGST")

                If (chk.Checked = True) Then
                    ChkCount = ChkCount + 1
                    Dim total As Decimal = Val(txtThisDesp.Text) * Val(hdnSkuRate.Value)
                    TotalRate = TotalRate + (total + (total * Val(hdnSkuGST.Value / 100)))
                End If
            Next
            Dim FinalInvoiceValue As Decimal = 0
            If txtFinalInvoiceValue.Text = "" Then
                FinalInvoiceValue = 0
            Else
                FinalInvoiceValue = Convert.ToDecimal(txtFinalInvoiceValue.Text)
            End If

            Dim Result As Decimal = TotalRate - FinalInvoiceValue
            Dim Value1 As Decimal = 0
            Dim Value2 As Decimal = 0

            ds = Obj.GetFinalInvoiceValue()

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
                Value1 = Convert.ToDecimal(ds.Tables(0).Rows(0)("lov_value"))
                Value2 = Convert.ToDecimal(ds.Tables(0).Rows(1)("lov_value"))
            End If
            Dim sign As String = Result.ToString().Substring(0, 1)

            Dim invoiceExists As Integer = 0
            Dim dscheck As DataSet = Obj.CheckInvoiceNumberExsists(lblYear.Text, txtCenvatNo.Text, userInfo.userIDEntity)

            If dscheck IsNot Nothing AndAlso dscheck.Tables.Count > 0 AndAlso dscheck.Tables(0).Rows.Count > 0 Then
                invoiceExists = Convert.ToInt32(dscheck.Tables(0).Rows(0)("InvoiceExists"))
            End If

            If invoiceExists = 1 Then
                ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invoice number already exists. Please use a different number.');", True)
                Exit Sub
            End If

            If Not (ddlSite.SelectedValue = String.Empty Or ddlPONo.SelectedValue = String.Empty Or txtTransporter.Text = String.Empty Or txtTruckNo.Text = String.Empty) Then

                If ChkCount > 0 Then
                    If Not btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then

                        InsertDespatch()
                    Else
                        UpdateDespatch()
                    End If
                    Response.Redirect("VendorChallanList.aspx")
                Else
                    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Please select atleast one SKU');", True)
                    ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
                End If

            Else
                ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Please enter all the details');", True)
                ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
            End If

        End If

    End Sub
    Protected Sub ddlAllSku_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAllSku.SelectedIndexChanged
        BindGrid()
    End Sub
    Protected Sub ddlProduct_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProduct.SelectedIndexChanged
        Dim s As String = ddlProduct.SelectedValue
        BindGrid()
    End Sub
    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        DeleteDespatchChallan()
        Response.Redirect("VendorChallanList.aspx")
    End Sub
    Protected Sub ddlPONo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPONo.SelectedIndexChanged
        BindGrid()
    End Sub
    Protected Sub ddlSite_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSite.SelectedIndexChanged
        PopulatePONo()
        BindGrid()
    End Sub
    Protected Sub btnResetdealerDetails_Click(sender As Object, e As EventArgs) Handles btnResetdealerDetails.Click
        TranspoterClearControl()
    End Sub
    Protected Sub chkApprovedTranspoterYN_CheckedChanged(sender As Object, e As EventArgs)
        TranspoterClearControl()
        txtTranspoterName.Enabled = False
        btnResetdealerDetails.Enabled = False
        txtTransporter.Enabled = True
        If chkApprovedTranspoterYN.Checked Then
            txtTranspoterName.Enabled = True
            btnResetdealerDetails.Enabled = True
            txtTransporter.Attributes.Add("readonly", "readonly")
        End If
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
    Private Sub GetScreenDetails()
        CheckLogin()
        Dim ScreenDS As DataSet
        Dim StockObj As New UnitDespatchClass
        ScreenDS = StockObj.GetSCreenDetails(userInfo.userBranchEntity)
        If (Not (ScreenDS Is Nothing) AndAlso ScreenDS.Tables.Count > 0 AndAlso Not (ScreenDS.Tables(0) Is Nothing) AndAlso ScreenDS.Tables(0).Rows.Count > 0) Then
            lblYear.Text = ScreenDS.Tables(0).Rows(0)("year").ToString
            lblmonth.Text = ScreenDS.Tables(0).Rows(0)("month").ToString
            lblUnit.Text = ScreenDS.Tables(0).Rows(0)("unit").ToString
            hdnMaxDespLimit.Value = ScreenDS.Tables(0).Rows(0)("maxLimit").ToString
            hdnUnitOracleId.Value = ScreenDS.Tables(0).Rows(0)("unitOracleId").ToString
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
        chkbxListLocation.Items.Clear()
        Dim commonObj As New Common
        Dim DepotDS As New DataSet

        DepotDS = commonObj.Getdepotname(ddlRegion.SelectedValue)
        If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
            chkbxListLocation.DataSource = DepotDS.Tables(0)
            chkbxListLocation.DataTextField = "Depot_Name"
            chkbxListLocation.DataValueField = "depot_code"
            chkbxListLocation.DataBind()
        End If
    End Sub
    Public Sub PopulateDeliveryDepotName()
        CheckLogin()
        ddlDeliveryDepot.Items.Clear()
        Dim commonObj As New Common
        Dim DepotDS As New DataSet

        DepotDS = commonObj.Getdepotname(String.Empty)
        If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
            ddlDeliveryDepot.DataSource = DepotDS.Tables(0)
            ddlDeliveryDepot.DataTextField = "Depot_Name"
            ddlDeliveryDepot.DataValueField = "depot_code"
            ddlDeliveryDepot.DataBind()
            ddlDeliveryDepot.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If

    End Sub
    Private Sub PopulateProduct()
        CheckLogin()
        Dim DespatchDS As DataSet
        Dim DespatchObj As New UnitDespatchClass

        Dim strLocationCode As String = String.Empty

        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next
        DespatchDS = DespatchObj.GetProductList(userInfo.userBranchEntity, strLocationCode, Constant.Common.ActiveStatus)
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
    Private Sub BindGrid()
        CheckLogin()
        CheckPendingAproval()
        Dim DespatchDS As DataSet
        Dim DespatchObj As New UnitDespatchClassVr1


        Dim strLocationCode As String = String.Empty

        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next


        DespatchDS = DespatchObj.GetSKUDetails(ddlProduct.SelectedValue, ddlAllSku.SelectedValue, Constant.Common.ActiveStatus, userInfo.userBranchEntity, ddlDeliveryDepot.SelectedValue, ddlPONo.SelectedValue, IIf(ddlSite.SelectedValue = String.Empty, 0, ddlSite.SelectedValue), strLocationCode) '' ddlLocation.SelectedValue
        If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
            gvSKUDetails.DataSource = DespatchDS
            gvSKUDetails.DataBind()
            btnSubmit.Enabled = True
            hdnNoMaster.Value = DespatchDS.Tables(0).Rows(0)("nomaster")

        Else
            gvSKUDetails.DataSource = DespatchDS
            gvSKUDetails.DataBind()
            btnSubmit.Enabled = False
        End If
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
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
        ddlPageSize.Items.Insert(0, New ListItem("999", 999, True))
        gvSKUDetails.PageSize = ddlPageSize.SelectedValue
    End Sub
    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime
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
    Public Sub AddAttributes()
        btnSubmit.Attributes.Add("onClick", "return ValidateSubmit();")
    End Sub
    Public Sub PopulatePONo()
        CheckLogin()
        ddlPONo.Items.Clear()
        Dim commonObj As New UnitDespatchClassVr1
        Dim DepotDS As New DataSet

        If Not String.IsNullOrEmpty(ddlDeliveryDepot.SelectedValue) And Not String.IsNullOrEmpty(ddlSite.SelectedValue) Then
            DepotDS = commonObj.GetPONo(ddlDeliveryDepot.SelectedValue, userInfo.userBranchEntity, IIf(ddlSite.SelectedValue = String.Empty, 0, ddlSite.SelectedValue))
            If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
                ddlPONo.DataSource = DepotDS.Tables(0)
                ddlPONo.DataTextField = "pm_po_no"
                ddlPONo.DataValueField = "pm_po_no"
                ddlPONo.DataBind()

            End If
            ddlPONo.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub
    Public Sub PopulateSiteDetails()
        CheckLogin()
        ddlSite.Items.Clear()
        Dim commonObj As New UnitDespatchClassVr1
        Dim DepotDS As New DataSet

        DepotDS = commonObj.GetSiteNameList(userInfo.userBranchEntity, ddlDeliveryDepot.SelectedValue, userInfo.userIDEntity) ''ddlLocation|PS|23-DEC-2020|AS per Sandeep Sir logic
        If (Not (DepotDS Is Nothing) AndAlso DepotDS.Tables.Count > 0 AndAlso Not (DepotDS.Tables(0) Is Nothing) AndAlso DepotDS.Tables(0).Rows.Count > 0) Then
            ddlSite.DataSource = DepotDS.Tables(0)
            ddlSite.DataTextField = "vendor_site_code"
            ddlSite.DataValueField = "vendor_site_id"
            ddlSite.DataBind()

            If (DepotDS.Tables(0).Rows.Count = 1) Then
                ddlSite.SelectedValue = Convert.ToString(DepotDS.Tables(0).Rows(0)("vendor_site_id"))
                PopulatePONo()
            End If

        End If
        ddlSite.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

    End Sub
    Private Function TotalKg() As Integer
        Dim chk As CheckBox
        Dim txt As TextBox
        Dim hdnUom, hdnVol As HiddenField
        Dim total As Decimal = 0
        For i As Integer = 0 To gvSKUDetails.Rows.Count - 1
            chk = gvSKUDetails.Rows(i).FindControl("chkSelect")
            txt = gvSKUDetails.Rows(i).FindControl("txtThisDesp")
            hdnUom = gvSKUDetails.Rows(i).FindControl("hdnUom")
            hdnVol = gvSKUDetails.Rows(i).FindControl("hdnVol")
            If chk.Checked Then
                If hdnUom.Value = "K" Or hdnUom.Value = "G" Then
                    total += CType(txt.Text, Integer) * hdnVol.Value
                End If
            End If
        Next
        Return total
    End Function
    Private Function TotalLtr() As Integer
        Dim chk As CheckBox
        Dim txt As TextBox
        Dim hdnUom, hdnVol As HiddenField
        Dim total As Decimal = 0
        For i As Integer = 0 To gvSKUDetails.Rows.Count - 1
            chk = gvSKUDetails.Rows(i).FindControl("chkSelect")
            txt = gvSKUDetails.Rows(i).FindControl("txtThisDesp")
            hdnUom = gvSKUDetails.Rows(i).FindControl("hdnUom")
            hdnVol = gvSKUDetails.Rows(i).FindControl("hdnVol")
            If chk.Checked Then
                If hdnUom.Value = "ML" Or hdnUom.Value = "L" Then
                    total += CType(txt.Text, Integer) * hdnVol.Value
                End If
            End If
        Next
        Return total

    End Function
    Private Sub InsertDespatch()
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClassVr1
        Dim hdrEntity As New DespatchHeaderEntity
        Dim numRowsAffected, GetChallanId As Integer
        Dim sqlConn As New SqlConnection
        Dim sqlTrans As SqlTransaction

        sqlConn = DBFactory.GetHelper.OpenConnection()
        sqlTrans = sqlConn.BeginTransaction()

        Dim strLocationCode As String = String.Empty


        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next

        hdrEntity.DespUnit = userInfo.userBranchEntity
        hdrEntity.DespDepot = strLocationCode
        hdrEntity.ChallanFinYear = Trim(lblYear.Text)
        hdrEntity.ChallanDate = FormatDate(txtChallanDt.Text)
        hdrEntity.TotalLtr = TotalLtr()
        hdrEntity.TotalKg = TotalKg()
        hdrEntity.TransporterName = txtTransporter.Text.Trim
        hdrEntity.TruckNo = txtTruckNo.Text.Trim
        hdrEntity.ExciseGpNo = txtCenvatNo.Text.Trim
        hdrEntity.ExciseGpDt = FormatDate(txtCenvatDt.Text)
        hdrEntity.CreatedUser = userInfo.userIDEntity
        hdrEntity.ActiveStatus = Constant.Common.ActiveStatus
        hdrEntity.ProcessMonth = lblmonth.Text
        hdrEntity.RoadPermitNo = txtRoadPermitNo.Text.Trim
        hdrEntity.po_no = ddlPONo.SelectedValue
        hdrEntity.site_name = Convert.ToString(ddlSite.SelectedItem)
        hdrEntity.delivery_depot = ddlDeliveryDepot.SelectedValue
        hdrEntity.InvoiceValue = Val(txtFinalInvoiceValue.Text)

        hdrEntity.EWayBillNo = txtEwayBillNo.Text.Trim
        hdrEntity.EwayBillDt = IIf(txtEwayBillDate.Text <> String.Empty, FormatDate(txtEwayBillDate.Text), SqlDateTime.MinValue)
        hdrEntity.ValidUptoDt = IIf(txtValidUpto.Text <> String.Empty, FormatDate(txtValidUpto.Text), SqlDateTime.MinValue)

        If String.IsNullOrEmpty(ddlSite.SelectedValue) Then
            lblErrorMessage.Text = "Please select site name."
            Exit Sub
        End If
        hdrEntity.SiteId = ddlSite.SelectedValue
        If Not String.IsNullOrEmpty(hdnTranspoterId.Value) Then
            hdrEntity.TranspoterId = Convert.ToInt32(hdnTranspoterId.Value)
        End If

        GetChallanId = DespatchObj.InsertDespHeader_Vr1(sqlConn, sqlTrans, hdrEntity)
        'GetChallanId = 45169
        InsertDocument(GetChallanId, userInfo.userIDEntity, userInfo.userBranchEntity, sqlConn, sqlTrans)
        If (GetChallanId > 0) Then
            InsertDetail(GetChallanId, sqlConn, sqlTrans)
            sqlTrans.Commit()
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
        Else
            sqlTrans.Rollback()
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
        End If
    End Sub
    Private Sub InsertDetail(ByVal ChallanId As Integer, ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction)
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClassVr1
        Dim dtlEntity As New DespatchDetailEntity
        Dim numRowsAffected As Integer = 0
        Dim chk As CheckBox
        Dim txt As TextBox
        Dim hdnUom, hdnVol, hdnDay, hdnLineNum, hdnDepot, hdnSkuRate, hdnSkuGST As HiddenField
        Dim txtLot As TextBox
        Dim lblTotalRate As Label
        Dim total As Integer = 0

        Try

            For i As Integer = 0 To gvSKUDetails.Rows.Count - 1
                chk = gvSKUDetails.Rows(i).FindControl("chkSelect")

                txt = gvSKUDetails.Rows(i).FindControl("txtThisDesp")
                hdnUom = gvSKUDetails.Rows(i).FindControl("hdnUom")
                hdnVol = gvSKUDetails.Rows(i).FindControl("hdnVol")
                hdnDay = gvSKUDetails.Rows(i).FindControl("hdnTransitDay")
                hdnLineNum = gvSKUDetails.Rows(i).FindControl("hdnLineNum")
                hdnDepot = gvSKUDetails.Rows(i).FindControl("hdnDepotCode")
                hdnSkuRate = gvSKUDetails.Rows(i).FindControl("hdnSkuRate")
                hdnSkuGST = gvSKUDetails.Rows(i).FindControl("hdnSkuGST")
                lblTotalRate = gvSKUDetails.Rows(i).FindControl("lblTotalRate")
                Dim lblPendingLoad As Label = gvSKUDetails.Rows(i).FindControl("lblPendingLoad")

                txtLot = gvSKUDetails.Rows(i).FindControl("txtLOT")

                If chk.Checked Then
                    dtlEntity.DespUnit = userInfo.userBranchEntity
                    'dtlEntity.DespDepot = ddlLocation.SelectedValue
                    dtlEntity.DespDepot = hdnDepot.Value

                    dtlEntity.ChallanFinYear = lblYear.Text.Trim
                    dtlEntity.ChallanNo = ChallanId
                    dtlEntity.ChallanDate = FormatDate(txtChallanDt.Text.Trim)
                    dtlEntity.Srl = i + 1
                    dtlEntity.SkuCode = gvSKUDetails.Rows(i).Cells(3).Text.Trim
                    dtlEntity.SkuUom = hdnUom.Value
                    dtlEntity.DespNop = CType(txt.Text.Trim, Integer)
                    dtlEntity.SkuVol = hdnVol.Value
                    dtlEntity.AutoIndent = gvSKUDetails.Rows(i).Cells(6).Text.Trim
                    dtlEntity.DepotIndent = gvSKUDetails.Rows(i).Cells(7).Text.Trim
                    dtlEntity.IndentTotal = (dtlEntity.AutoIndent + dtlEntity.DepotIndent)
                    dtlEntity.DespatchToDate = gvSKUDetails.Rows(i).Cells(8).Text.Trim
                    dtlEntity.PendingLoad = lblPendingLoad.Text.Trim
                    dtlEntity.CreatedUser = userInfo.userIDEntity
                    dtlEntity.ActiveStatus = Constant.Common.ActiveStatus
                    dtlEntity.ProcessMonth = lblmonth.Text
                    dtlEntity.TransitTill = DateAdd(DateInterval.Day, CType(hdnDay.Value, Double), dtlEntity.ChallanDate)
                    dtlEntity.lot_no = txtLot.Text.Trim()
                    dtlEntity.Po_Rate = Val(hdnSkuRate.Value)
                    dtlEntity.Sku_Gst = Val(hdnSkuGST.Value)
                    If Not String.IsNullOrEmpty(hdnLineNum.Value.Trim()) Then
                        dtlEntity.LineNum = Convert.ToInt32(hdnLineNum.Value)
                    Else
                        lblErrorMessage.Text = "Line num should not be blank."
                        sqlTrans.Rollback()
                        If sqlConn IsNot Nothing Then
                            sqlConn.Close()
                        End If
                        Exit Sub
                    End If

                    numRowsAffected += DespatchObj.InsertDespatchDetail(sqlConn, sqlTrans, dtlEntity)
                    numRowsAffected = 1
                    If Not numRowsAffected > 0 Then
                        sqlTrans.Rollback()
                        If sqlConn IsNot Nothing Then
                            sqlConn.Close()
                        End If
                        Dim returnUrl As String = "~/ExceptionPage.aspx"
                        Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
                        Server.Transfer(returnUrl)
                    End If
                End If
            Next
            If numRowsAffected > 0 Then
                'sqlTrans.Commit()
                'If sqlConn IsNot Nothing Then
                '    sqlConn.Close()
                'End If
            End If

        Catch ex As Exception
            sqlTrans.Rollback()
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
            Server.Transfer(returnUrl)
        End Try
    End Sub
    Private Sub PopulateUpdateMode(ByVal challanNo As Integer, ByVal year As String, ByVal unit As String)
        CheckLogin()
        PopulateRegion()
        PopulateDepotName()
        PopulateDeliveryDepotName()

        PageSizeDropdown()
        Updatemode = True
        btnSubmit.Text = Constant.GeneralMessages.btnUpdate
        Dim DespatchObj As New UnitDespatchClass
        Dim DespatchDS As DataSet
        DespatchDS = DespatchObj.GetUpdateModeDetail(challanNo, year, unit)
        If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
            ddlRegion.SelectedValue = DespatchDS.Tables(0).Rows(0)("region").ToString

            For i = 0 To DespatchDS.Tables(1).Rows.Count - 1
                For Each lstitm As ListItem In chkbxListLocation.Items

                    If Convert.ToString(DespatchDS.Tables(1).Rows(i)("despd_desp_depot")) = lstitm.Value Then
                        lstitm.Selected = True
                    End If
                Next
            Next

            txtCenvatNo.Text = DespatchDS.Tables(0).Rows(0)("desph_excise_gp_no").ToString
            txtCenvatDt.Text = DespatchDS.Tables(0).Rows(0)("desph_excise_gp_dt").ToString
            txtChallanDt.Text = DespatchDS.Tables(0).Rows(0)("desph_challan_date").ToString
            txtTransporter.Text = DespatchDS.Tables(0).Rows(0)("desph_transporter_name").ToString
            txtFinalInvoiceValue.Text = DespatchDS.Tables(0).Rows(0)("desph_invoice_value").ToString
            hdnTranspoterId.Value = Convert.ToString(DespatchDS.Tables(0).Rows(0)("desph_transport_id"))
            txtTranspoterName.Enabled = False
            btnResetdealerDetails.Enabled = False
            txtTransporter.Enabled = True
            If Not String.IsNullOrEmpty(hdnTranspoterId.Value) Then
                chkApprovedTranspoterYN.Checked = True
                txtTranspoterName.Enabled = True
                btnResetdealerDetails.Enabled = True
                txtTransporter.Enabled = False
            End If
            txtTruckNo.Text = DespatchDS.Tables(0).Rows(0)("desph_truck_no").ToString
            hdnChallanno.Value = CType(DespatchDS.Tables(0).Rows(0)("desph_challan_no").ToString, Integer)
            lblmonth.Text = DespatchDS.Tables(0).Rows(0)("desph_process_month").ToString
            lblUnit.Text = DespatchDS.Tables(0).Rows(0)("desph_desp_unit").ToString
            lblYear.Text = DespatchDS.Tables(0).Rows(0)("desph_challan_fin_year").ToString
            ddlDeliveryDepot.SelectedValue = DespatchDS.Tables(0).Rows(0)("desph_delivery_depot").ToString

            PopulateSiteDetails()
            ddlSite.SelectedValue = DespatchDS.Tables(0).Rows(0)("desph_site_id").ToString
            PopulatePONo()
            ddlPONo.SelectedValue = Convert.ToString(DespatchDS.Tables(0).Rows(0)("desph_po_no"))

            hdnUnitOracleId.Value = Convert.ToString(DespatchDS.Tables(0).Rows(0)("UnitOracleId"))
            txtFinalInvoiceValue.Text = DespatchDS.Tables(0).Rows(0)("desph_invoice_value").ToString

            ddlProduct.Items.Clear()
            ddlProduct.Items.Insert(0, New ListItem("All", String.Empty, True))
            ddlProduct.Enabled = False
            ddlAllSku.SelectedValue = "Y"
            ddlAllSku.Enabled = False
            txtChallanDt.Enabled = False
            ddlPONo.Enabled = False
            ddlSite.Enabled = False
            ddlDeliveryDepot.Enabled = False
            chkbxListLocation.Enabled = False
            ddlProduct.Enabled = False
            ddlRegion.Enabled = False
            ChallanDt.Visible = False
            lblChallanNo.Text = "Challan No. : " & hdnChallanno.Value
            txtRoadPermitNo.Text = DespatchDS.Tables(0).Rows(0)("desph_road_permit_no").ToString
            txtEwayBillNo.Text = DespatchDS.Tables(0).Rows(0)("desph_eway_bill_no").ToString
            txtEwayBillDate.Text = DespatchDS.Tables(0).Rows(0)("desph_eway_bill_dt").ToString
            txtValidUpto.Text = DespatchDS.Tables(0).Rows(0)("desph_valid_upto_dt").ToString
            If DespatchDS.Tables(0).Rows(0)("desph_approved_yn").ToString = "Y" Then
                Aproved_yn = True
                btnSubmit.Enabled = False
                btnDelete.Visible = False
            End If
        End If
        BindGridForUpdateMode(challanNo, year, ddlPONo.SelectedValue, IIf(ddlSite.SelectedValue <> String.Empty, ddlSite.SelectedValue, 0))
    End Sub
    Private Sub BindGridForUpdateMode(ByVal challanNo As Integer, ByVal year As String, ByVal poNo As String, ByVal vendorSiteId As Long)
        Dim DespatchDS As DataSet
        Dim DespatchObj As New UnitDespatchClassVr1

        Dim strLocationCode As String = String.Empty

        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next

        'DespatchDS = DespatchObj.GetSKUDetailsForUpdateMode(challanNo, year, Constant.Common.ActiveStatus, userInfo.userBranchEntity, strLocationCode, poNo, vendorSiteId)
        DespatchDS = DespatchObj.GetSKUDetailsForUpdateMode(challanNo, year, Constant.Common.ActiveStatus, Convert.ToString(Request.QueryString(Constant.SessionKeys.UnitCode)), strLocationCode, poNo, vendorSiteId)
        If (Not (DespatchDS Is Nothing) AndAlso DespatchDS.Tables.Count > 0 AndAlso Not (DespatchDS.Tables(0) Is Nothing) AndAlso DespatchDS.Tables(0).Rows.Count > 0) Then
            gvSKUDetails.DataSource = DespatchDS
            gvSKUDetails.DataBind()
            hdnNoMaster.Value = DespatchDS.Tables(0).Rows(0)("nomaster")
        Else
            gvSKUDetails.DataSource = DespatchDS
            gvSKUDetails.DataBind()
        End If
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
    End Sub
    Private Sub UpdateDespatch()
        CheckLogin()

        Dim DespatchObj As New UnitDespatchClassVr1
        Dim hdrEntity As New DespatchHeaderEntity
        Dim numRowsAffected, GetChallanId As Integer
        Dim sqlConn As New SqlConnection
        Dim sqlTrans As SqlTransaction

        sqlConn = DBFactory.GetHelper.OpenConnection()
        sqlTrans = sqlConn.BeginTransaction()

        Dim strLocationCode As String = String.Empty

        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next

        hdrEntity.DespUnit = userInfo.userBranchEntity
        ''hdrEntity.DespDepot = ddlLocation.SelectedValue

        hdrEntity.DespDepot = strLocationCode

        hdrEntity.ChallanFinYear = Trim(lblYear.Text)
        hdrEntity.ChallanDate = FormatDate(txtChallanDt.Text)
        hdrEntity.TotalLtr = TotalLtr()
        hdrEntity.TotalKg = TotalKg()
        hdrEntity.TransporterName = txtTransporter.Text.Trim
        hdrEntity.TruckNo = txtTruckNo.Text.Trim
        hdrEntity.ExciseGpNo = txtCenvatNo.Text.Trim
        hdrEntity.ExciseGpDt = FormatDate(txtCenvatDt.Text)
        hdrEntity.CreatedUser = userInfo.userIDEntity
        hdrEntity.ActiveStatus = Constant.Common.ActiveStatus
        hdrEntity.ProcessMonth = lblmonth.Text
        hdrEntity.ChallanNo = hdnChallanno.Value
        hdrEntity.RoadPermitNo = txtRoadPermitNo.Text.Trim
        hdrEntity.po_no = ddlPONo.SelectedValue
        hdrEntity.site_name = Convert.ToString(ddlSite.SelectedItem)
        hdrEntity.delivery_depot = ddlDeliveryDepot.SelectedValue
        hdrEntity.SiteId = ddlSite.SelectedValue

        hdrEntity.EWayBillNo = txtEwayBillNo.Text.Trim
        hdrEntity.EwayBillDt = IIf(txtEwayBillDate.Text <> String.Empty, FormatDate(txtEwayBillDate.Text), SqlDateTime.MinValue)
        hdrEntity.ValidUptoDt = IIf(txtValidUpto.Text <> String.Empty, FormatDate(txtValidUpto.Text), SqlDateTime.MinValue)

        If Not String.IsNullOrEmpty(hdnTranspoterId.Value) Then
            hdrEntity.TranspoterId = Convert.ToInt32(hdnTranspoterId.Value)
        End If
        hdrEntity.InvoiceValue = Val(txtFinalInvoiceValue.Text)

        GetChallanId = DespatchObj.UpdateDespHeader_Vr1(sqlConn, sqlTrans, hdrEntity)
        If Not (GetChallanId < 0) Then
            DeleteDetail(sqlConn, sqlTrans)
            InsertDetail(hdnChallanno.Value, sqlConn, sqlTrans)
        Else
            sqlTrans.Rollback()
        End If
    End Sub
    Private Sub DeleteDetail(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction)
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClass
        Dim dtlEntity As New DespatchDetailEntity
        Dim numRowsAffected As Integer
        dtlEntity.DespUnit = userInfo.userBranchEntity

        dtlEntity.ChallanFinYear = lblYear.Text.Trim
        dtlEntity.ChallanNo = hdnChallanno.Value

        numRowsAffected = DespatchObj.DeleteDespDtl(sqlConn, sqlTrans, dtlEntity)

    End Sub
    Private Sub DeleteDespatchChallan()
        CheckLogin()
        Dim DespatchObj As New UnitDespatchClass
        Dim hdrEntity As New DespatchHeaderEntity
        Dim numRowsAffected As Integer
        Dim sqlConn As New SqlConnection
        Dim sqlTrans As SqlTransaction

        sqlConn = DBFactory.GetHelper.OpenConnection()
        sqlTrans = sqlConn.BeginTransaction()

        hdrEntity.DespUnit = userInfo.userBranchEntity
        hdrEntity.ChallanFinYear = Trim(lblYear.Text)
        hdrEntity.ChallanNo = hdnChallanno.Value

        numRowsAffected = DespatchObj.DeleteChallan(sqlConn, sqlTrans, hdrEntity)
        If (numRowsAffected > 0) Then
            sqlTrans.Commit()
        Else
            sqlTrans.Rollback()
        End If
        sqlConn.Close()
    End Sub
    Private Sub CheckPendingAproval()
        CheckLogin()
        Dim ApprovalPending As DataSet
        Dim StockObj As New UnitDespatchClass
        Dim strLocationCode As String = String.Empty

        For Each lstitm As ListItem In chkbxListLocation.Items
            If lstitm.Selected Then
                If strLocationCode.Length = 0 Then
                    strLocationCode = lstitm.Value
                Else
                    strLocationCode = lstitm.Value & "," & strLocationCode
                End If
            End If
        Next

        ApprovalPending = StockObj.CheckApprovalPending(strLocationCode, userInfo.userBranchEntity)
        If CType(ApprovalPending.Tables(0).Rows(0)("PendingCount"), Integer) > 0 Then
            btnSubmit.Enabled = False
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Message", "<script type='text/javascript' language='javascript'>alert('Please Approve The Previous Challan(s)'); document.getElementById('btnSubmit').disabled = true;</script>", False)

        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Message", "<script type='text/javascript' language='javascript'> document.getElementById('btnSubmit').disabled = false;</script>", False)
        End If
    End Sub
    Private Sub TranspoterClearControl()
        txtTranspoterName.Text = String.Empty
        hdnTranspoterId.Value = String.Empty
        txtTransporter.Text = String.Empty
    End Sub
#End Region

#Region "Populate Transpoter Search"

    <System.Web.Script.Services.ScriptMethod(),
System.Web.Services.WebMethod()>
    Public Shared Function TranspoterSearch(ByVal prefixText As String) As String()

        Dim ms As New UnitDespatchClass

        Dim transpoterdetails As List(Of String) = New List(Of String)

        If prefixText.Length >= 3 Then
            Try

                Dim ds As DataSet = ms.GetTranspoterList(prefixText)

                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                    If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                        For Each dr As DataRow In ds.Tables(0).Rows
                            transpoterdetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dr(1).ToString, dr(0).ToString))
                        Next
                    End If
                End If

            Catch ex As Exception

            End Try
        End If

        Return transpoterdetails.ToArray()

    End Function
    Private Sub ddlDeliveryDepot_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDeliveryDepot.SelectedIndexChanged
        PopulateSiteDetails()
        PopulatePONo()
        BindGrid()
    End Sub

#End Region

#Region "Insert Document"
    Private Function InsertDocument(ByVal ChallanNo As Int64, ByVal UserID As String, ByVal UnitCode As String, ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction) As Integer
        Dim Extension As String = String.Empty
        ' Set the Response Content Type based on the file extension
        Extension = GetFileExtension(sch_fld1.FileName)

        Dim numRowsAffected As Integer = 0
        Dim DocUpld As New UnitDespatchClassVr1

        'Modified-by MUKESH BHAGAT on 16-10-2026 : cleaned, unique stored name (see UploadFileName); the raw browser name
        '("1050, SURAT.pdf") broke the download header and could overwrite another vendor's file of the same name.
        Dim DocsFileName As String = UploadFileName.SafeFileName(sch_fld1.FileName, True)
        Dim DocsOrgFileName As String = DocsFileName
        Dim DocPath As String = Format(Date.Now, "dd_MM_yyyy")

        If Not sch_fld1.PostedFile Is Nothing And sch_fld1.PostedFile.ContentLength > 0 Then
            Try
                numRowsAffected = DocUpld.InsertChallanDocument(ChallanNo, DocsFileName, DocsOrgFileName, DocPath, UserID, UnitCode, sqlConn, sqlTrans)
                If numRowsAffected > 0 Then
                    If Not sch_fld1.PostedFile Is Nothing And sch_fld1.PostedFile.ContentLength > 0 Then
                        Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\" & DocPath


                        Dim fn As String = System.IO.Path.GetFileName(sch_fld1.PostedFile.FileName)
                        Dim saveLocation As String = projectPath & "\" & fn


                        Dim file As System.IO.FileInfo = New System.IO.FileInfo(saveLocation)


                        If Not (Directory.Exists(projectPath)) Then
                            Directory.CreateDirectory(projectPath)
                        End If
                        sch_fld1.PostedFile.SaveAs(saveLocation)
                    End If
                Else
                    sqlTrans.Rollback()
                    Dim returnUrl As String = "~/ExceptionPage.aspx"
                    Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
                    Server.Transfer(returnUrl)
                End If
            Catch ex As Exception
                sqlTrans.Rollback()
                Dim returnUrl As String = "~/ExceptionPage.aspx"
                Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
                Server.Transfer(returnUrl)
            End Try
        End If

        Return numRowsAffected
    End Function
#End Region

#Region "Get File Extension"

    ' Gets the File extension from the file Name
    Private Function GetFileExtension(ByVal fileName As String) As String
        Dim extension As String = String.Empty
        If (fileName.LastIndexOf(".") >= 0) Then
            extension = fileName.Substring(fileName.LastIndexOf(".") + 1)
        End If

        Return extension
    End Function

#End Region
    Protected Sub chkbxListLocation_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateProduct()
        PopulateDeliveryDepotName()
        PopulateSiteDetails()
        PopulatePONo()
        BindGrid()
    End Sub
End Class
