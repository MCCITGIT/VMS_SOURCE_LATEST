Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic
Imports System.Security.Permissions
Imports Microsoft.Win32
Imports System.Globalization

Partial Class UnitDespatchPlanAddUpdateVr1
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
            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            CheckLogin()
            hdnindentyn.Value = False

            lblErrorMessage.Text = String.Empty
            If Not Request.QueryString(Constant.SessionKeys.Challan_No) Is Nothing Then
                PopulateUpdateMode(Request.QueryString(Constant.SessionKeys.Challan_No), Request.QueryString(Constant.SessionKeys.Process_Year), Request.QueryString(Constant.SessionKeys.UnitCode))
                IsIndentAvailableForUnit(Request.QueryString(Constant.SessionKeys.UnitCode))
            Else
                IsIndentAvailableForUnit(userInfo.userBranchEntity)
                btnSubmit.Enabled = False
                btnDelete.Visible = False
                txtChallanDt.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture())
                txtCenvatDt.Text = DateTime.Now.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture())
                'txtEwayBillDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
                'txtValidUpto.Text = DateTime.Now.ToString("yyyy-MM-dd")
                GetScreenDetails()
                PopulateRegion()
                PopulateDepotName()
                PopulateDeliveryDepotName()
                PopulatePONo()
                PopulateSiteDetails()
                'Modified-by MUKESH BHAGAT on 24-08-2026 : reference GSTNs on first load
                PopulateGstnDetails()
                PageSizeDropdown()
            End If
            AddAttributes()
        End If
    End Sub
#End Region

#Region "Event Handler"
    'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
#Region "Check Indent Availability and Handle"
    Public Function IsIndentAvailableForUnit(ByVal unitCode As String) As Boolean
        Dim indentAvailable As Boolean = False
        Try
            Dim despatchObj As New UnitDespatchClass()

            indentAvailable = despatchObj.CheckIndentAvailable(unitCode)

            If indentAvailable Then
                hdnindentyn.Value = True
                ddlIndent.Enabled = True
                PopulateIndent()
            Else
                hdnindentyn.Value = False
                ddlIndent.Enabled = False
                ddlIndent.ClearSelection()
                ClearIndentDetails()
            End If

        Catch ex As Exception
            lblErrorMessage.Text = "Error while checking indent availability: " & ex.Message
            lblErrorMessage.ForeColor = Drawing.Color.Red
        End Try

        Return indentAvailable
    End Function

#End Region
    'Protected Sub ddlLocation_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlLocation.SelectedIndexChanged
    '    PopulateProduct()
    '    PopulateDeliveryDepotName()
    '    ddlDeliveryDepot.SelectedValue = ddlLocation.SelectedValue
    '    PopulateSiteDetails()
    '    PopulatePONo()
    '    BindGrid()
    'End Sub
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

            'If rowView("desph_approved_yn").ToString = "Y" Then
            '    btnGo.Enabled = False
            'Else
            '    btnGo.Enabled = True
            'End If


            If Updatemode = True Then
                If rowView("skuExist") = "Y" Then
                    chk.Checked = True
                    txt.Enabled = True
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

            ' Validation for Challan Date and Invoice Date
            'Dim challanDate As DateTime
            'Dim invoiceDate As DateTime
            'Dim currentDate As DateTime = DateTime.Now.Date

            'If Not DateTime.TryParse(txtChallanDt.Text, challanDate) Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invalid Challan Date.');", True)
            '    Exit Sub
            'End If

            'If Not DateTime.TryParse(txtCenvatDt.Text, invoiceDate) Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invalid Invoice Date.');", True)
            '    Exit Sub
            'End If

            '' Check if Challan Date or Invoice Date is greater than the current date
            'If challanDate > currentDate Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Challan Date cannot be greater than the current date.');", True)
            '    Exit Sub
            'End If

            'If invoiceDate > currentDate Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invoice Date cannot be greater than the current date.');", True)
            '    Exit Sub
            'End If

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
            'If (TotalRate > Val(txtFinalInvoiceValue.Text)) Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Total Rate (Ind. GST) can not be greater than Final Invoice Value');", True)
            '    txtFinalInvoiceValue.Focus()
            '    ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
            '    Exit Sub
            'End If
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
            'If sign = "-" Then
            '    If (Value1 > Result AndAlso Result < Value2) Then
            '        ''ModalPopupExtender2.Show()
            '        lblErrorMessage.Text = "Total Rate Not matching With the Final Invoice Value."
            '        lblErrorMessage.ForeColor = System.Drawing.Color.Red
            '        ''ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Total Rate not matching with the Final Invoice Value');", True)
            '        '' txtfinalinvoicevalue.Focus()
            '        ''ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
            '        Exit Sub
            '    End If
            'Else
            '    If (Value1 < Result AndAlso Result > Value2) Then
            '        '' ModalPopupExtender2.Show()
            '        lblErrorMessage.Text = "Total Rate not matching with the Final Invoice Value."
            '        lblErrorMessage.ForeColor = System.Drawing.Color.Red
            '        Exit Sub
            '    End If
            'End If

            'If (Value1 < Result < Value2) Then
            '    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Total Rate not matching with the Final Invoice Value');", True)
            '    txtFinalInvoiceValue.Focus()
            '    ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
            '    Exit Sub
            'End If

            Dim invoiceExists As Integer = 0
            'Modified-by MUKESH BHAGAT on 31-08-2026 : in update mode the challan's own invoice
            'number is in the table already, so an unchanged number must not count as a
            'duplicate. A CHANGED number is still checked against every challan (correct -
            'this challan still holds its old number until the update is saved).
            Dim isOwnUnchangedInvoiceNo As Boolean =
                hdnChallanno.Value.Trim() <> String.Empty AndAlso
                String.Equals(txtCenvatNo.Text.Trim(), hdnOriginalInvoiceNo.Value.Trim(), StringComparison.OrdinalIgnoreCase)

            If Not isOwnUnchangedInvoiceNo Then
                Dim dscheck As DataSet = Obj.CheckInvoiceNumberExsists(lblYear.Text, txtCenvatNo.Text, userInfo.userIDEntity)

                If dscheck IsNot Nothing AndAlso dscheck.Tables.Count > 0 AndAlso dscheck.Tables(0).Rows.Count > 0 Then
                    invoiceExists = Convert.ToInt32(dscheck.Tables(0).Rows(0)("InvoiceExists"))
                End If
            End If

            If invoiceExists = 1 Then
                ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invoice number already exists. Please use a different number.');", True)
                Exit Sub
            End If

            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            If hdnindentyn.Value Then
                If String.IsNullOrEmpty(ddlIndent.SelectedValue) Then
                    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Please select an Indent since Indent Available is checked.');", True)
                    ddlIndent.Focus()
                    Exit Sub
                End If
            End If

            'Modified-by MUKESH BHAGAT on 24-08-2026 : invoice OCR gate.
            'A newly uploaded bill must have been read and matched by OCR (gross value +
            'invoice no/date). The browser sets hdnOcrVerified; this server-side check makes
            'sure the validation cannot be skipped by disabling script.
            'Modified-by MUKESH BHAGAT on 09-09-2026 : "S" is also accepted - the browser sets it when the
            'bill could not be validated (OCR service down / unreadable PDF) and the user explicitly
            'chose to save anyway after the warning. Only an unchecked submit ("N") is refused.
            If sch_fld1.HasFile Then
                Dim ocrFlag As String = Convert.ToString(hdnOcrVerified.Value).Trim().ToUpperInvariant()
                If ocrFlag <> "Y" AndAlso ocrFlag <> "S" Then
                    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('The uploaded invoice has not been validated yet. Please click Submit again so it can be checked.');", True)
                    Exit Sub
                End If
            End If


            If Not (ddlSite.SelectedValue = String.Empty Or ddlPONo.SelectedValue = String.Empty Or txtTransporter.Text = String.Empty Or txtTruckNo.Text = String.Empty) Then

                If ChkCount > 0 Then
                    If Not btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then

                        InsertDespatch()
                    Else
                        UpdateDespatch()
                    End If
                    Response.Redirect("UnitDespatchPlanListVr1.aspx")
                Else
                    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Please select atleast one SKU');", True)
                    ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
                    'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ss", "<script>alert('Please select atleast one SKU')</script>", True)
                    'MsgBox("Please select atleast one SKU")
                End If

            Else
                ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Please enter all the details');", True)
                ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
                'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ss", "<script>alert('Please enter all the details')</script>", True)
                'MsgBox("Please enter all the details.")
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
        Response.Redirect("UnitDespatchPlanListVr1.aspx")
    End Sub
    Protected Sub ddlPONo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPONo.SelectedIndexChanged
        BindGrid()
    End Sub
    Protected Sub ddlSite_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSite.SelectedIndexChanged
        PopulatePONo()
        'Modified-by MUKESH BHAGAT on 24-08-2026 : supplier GSTN follows the selected site
        PopulateGstnDetails()
        BindGrid()
    End Sub
    'Protected Sub ddlDeliveryDepot_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDeliveryDepot.SelectedIndexChanged
    '    PopulateSiteDetails()
    '    PopulatePONo()
    '    BindGrid()
    'End Sub
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
            '  txtTransporter.Enabled = False
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
    'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
    Public Sub PopulateIndent()
        CheckLogin()
        Dim StockObj As New UnitDespatchClass
        Dim RegionDS As New DataSet
        Dim RegiontypeDS As DataSet = StockObj.GetPandoInvoice(ddlDeliveryDepot.SelectedValue, userInfo.userIDEntity, Val(hdnChallanno.Value), lblYear.Text)
        If Not (RegiontypeDS Is Nothing) Then
            ddlIndent.DataSource = RegiontypeDS
            ddlIndent.DataTextField = "indentIdDisplay"
            ddlIndent.DataValueField = "indentId"
            ddlIndent.DataBind()
            ddlIndent.Items.Insert(0, New ListItem("Select", "", True))
        Else
            ddlIndent.Items.Insert(0, New ListItem("Select", "", True))
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
            'chkbxListLocation.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
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
    'Modified-by MUKESH BHAGAT on 20-08-2026 : formats a DB datetime value for an HTML5 date input (yyyy-MM-dd);
    'returns empty for NULL / SqlDateTime.MinValue (1753-01-01) so the input shows blank instead of a junk date
    Private Function ToHtml5Date(ByVal value As Object) As String
        If value Is Nothing OrElse IsDBNull(value) OrElse Not IsDate(value) Then
            Return String.Empty
        End If
        Dim dt As DateTime = Convert.ToDateTime(value)
        If dt.Year <= 1753 Then
            Return String.Empty
        End If
        Return dt.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)
    End Function

    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime
        If Not (stringdate = String.Empty) Then
            'Modified-by MUKESH BHAGAT on 20-08-2026 : txtEwayBillDate / txtValidUpto are HTML5 date inputs
            '(TextMode="Date") and post yyyy-MM-dd; the original Split("/") parser crashed on them.
            'Added the yyyy-MM-dd branch using the same pattern as TestCaseResultEntry.FormatDate.
            If stringdate.Contains("-") Then
                Dim ddateIso As String() = stringdate.Split("-")
                Dim yyyyIso As Integer = System.Convert.ToInt32(ddateIso(0))
                Dim mmIso As Integer = System.Convert.ToInt32(ddateIso(1))
                Dim ddIso As Integer = System.Convert.ToInt32(ddateIso(2))
                Dim dtIso As DateTime = New DateTime(yyyyIso, mmIso, ddIso)
                dtIso = FormatDateTime(dtIso, DateFormat.LongDate)
                Return dtIso
            End If

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
        'txtEwayBillDate.Attributes.Add("readonly", "readonly")
        'txtValidUpto.Attributes.Add("readonly", "readonly")

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

    'Modified-by MUKESH BHAGAT on 24-08-2026 : reference GSTNs shown on the despatch screen -
    'invoicing depot GSTN from the depot master, supplier GSTN from the selected site.
    'Written defensively: a missing column or row must never break the despatch entry screen.
    Public Sub PopulateGstnDetails()
        Try
            txtDepotGstn.Text = String.Empty
            txtSupplierGstn.Text = String.Empty

            ' ---- invoicing depot GSTN ----
            ' Modified-by MUKESH BHAGAT on 27-08-2026 : read directly from MSTRDB.dbo.mstr_org
            ' (org_code = depot code, column org_gstn_no) through the dedicated SP
            ' [Get_Depot_Gstn]. The earlier route via [Get_DepotDetails] depended on that SP
            ' returning a GSTN_No column, which not every environment's copy does.
            If Not String.IsNullOrEmpty(ddlDeliveryDepot.SelectedValue) Then
                Dim depotObj As New UnitDespatchClassVr1
                Dim depotDS As DataSet = depotObj.GetDepotGstn(ddlDeliveryDepot.SelectedValue)
                If (Not (depotDS Is Nothing) AndAlso depotDS.Tables.Count > 0 AndAlso Not (depotDS.Tables(0) Is Nothing) AndAlso depotDS.Tables(0).Rows.Count > 0) Then
                    If depotDS.Tables(0).Columns.Contains("org_gstn_no") Then
                        txtDepotGstn.Text = Convert.ToString(depotDS.Tables(0).Rows(0)("org_gstn_no"))
                    End If
                End If
            End If

            ' ---- supplier GSTN : belongs to the SITE, not to the unit ----
            ' Modified-by MUKESH BHAGAT on 26-08-2026 : the GST registration is held against the
            ' vendor site in RFQDB.MSTR.vendor_site_dtls.gst_number. The site is whichever one is
            ' selected in ddlSite (its value is vendor_site_id); when nothing is selected yet the
            ' SP falls back to the site mapped to the logged-in user in
            ' dbo.user_applicable_site_dtls. This replaces the earlier vendor_mstr approach.
            Dim siteId As Integer = 0
            If Not String.IsNullOrEmpty(ddlSite.SelectedValue) Then
                Integer.TryParse(ddlSite.SelectedValue, siteId)
            End If

            Dim gstObj As New UnitDespatchClassVr1
            Dim gstDS As DataSet = gstObj.GetSupplierGstnBySite(siteId, userInfo.userIDEntity)
            If (Not (gstDS Is Nothing) AndAlso gstDS.Tables.Count > 0 AndAlso Not (gstDS.Tables(0) Is Nothing) AndAlso gstDS.Tables(0).Rows.Count > 0) Then
                If gstDS.Tables(0).Columns.Contains("gst_number") Then
                    txtSupplierGstn.Text = Convert.ToString(gstDS.Tables(0).Rows(0)("gst_number"))
                End If
            End If
        Catch ex As Exception
            ' reference information only - never block the despatch screen
            txtDepotGstn.Text = String.Empty
            txtSupplierGstn.Text = String.Empty
        End Try
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

        'Dim cenvatDtt As DateTime = DateTime.ParseExact(txtCenvatDt.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)

        'Dim cenvatDt As String = cenvatDtt.ToString("dd/MM/yyyy")

        'Dim challanDtt As DateTime = DateTime.ParseExact(txtChallanDt.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)

        'Dim challanDt As String = challanDtt.ToString("dd/MM/yyyy")

        'Dim ewayDtt As DateTime = DateTime.ParseExact(txtEwayBillDate.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)

        'Dim ewayDt As String = ewayDtt.ToString("dd/MM/yyyy")

        'Dim validToDtt As DateTime = DateTime.ParseExact(txtValidUpto.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture)

        'Dim validToDt As String = validToDtt.ToString("dd/MM/yyyy")

        hdrEntity.DespUnit = userInfo.userBranchEntity
        'hdrEntity.DespDepot = ddlLocation.SelectedValue
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

        'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
        'hdrEntity.ThirdPartyIndentYn = If(chkIndentAvailable.Checked, "Y", "N")
        hdrEntity.ThirdPartyIndent = ddlIndent.SelectedValue

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
            'Modified-by MUKESH BHAGAT on 24-08-2026 : optional E-Way bill document
            'Modified-by MUKESH BHAGAT on 26-08-2026 : moved after the commit - the E-Way bill
            'is optional and must never be able to roll back a challan that is already saved.
            SaveEwayBillDocument(GetChallanId)
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

                'Dim strLocationCode As String = String.Empty

                'For Each lstitm As ListItem In chkbxListLocation.Items
                '    If lstitm.Selected Then
                '        If strLocationCode.Length = 0 Then
                '            strLocationCode = lstitm.Value
                '        Else
                '            strLocationCode = lstitm.Value & "," & strLocationCode
                '        End If
                '    End If
                'Next

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

                    'dtlEntity.TransitTill = Dat
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
            ''ddlLocation.SelectedValue = DespatchDS.Tables(0).Rows(0)("desph_desp_depot").ToString

            For i = 0 To DespatchDS.Tables(1).Rows.Count - 1
                'CheckBoxListTerritory.SelectedValue = Convert.ToString(ds.Tables(0).Rows(i)("rt_territory_code"))
                For Each lstitm As ListItem In chkbxListLocation.Items

                    If Convert.ToString(DespatchDS.Tables(1).Rows(i)("despd_desp_depot")) = lstitm.Value Then
                        lstitm.Selected = True
                    End If
                Next
            Next


            txtCenvatNo.Text = DespatchDS.Tables(0).Rows(0)("desph_excise_gp_no").ToString
            'Modified-by MUKESH BHAGAT on 31-08-2026 : keep the loaded invoice number so the
            'duplicate check can recognise the challan's own number on update.
            hdnOriginalInvoiceNo.Value = txtCenvatNo.Text.Trim()
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
            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            PopulateIndent()
            PopulateSiteDetails()
            ddlSite.SelectedValue = DespatchDS.Tables(0).Rows(0)("desph_site_id").ToString
            'Modified-by MUKESH BHAGAT on 24-08-2026 : reference GSTNs in update mode
            PopulateGstnDetails()
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
            ''ddlLocation.Enabled = False
            chkbxListLocation.Enabled = False

            ddlProduct.Enabled = False
            ddlRegion.Enabled = False
            'ChallanDt.Visible = False
            lblChallanNo.Text = "Challan No. : " & hdnChallanno.Value
            txtRoadPermitNo.Text = DespatchDS.Tables(0).Rows(0)("desph_road_permit_no").ToString
            txtEwayBillNo.Text = DespatchDS.Tables(0).Rows(0)("desph_eway_bill_no").ToString
            'Modified-by MUKESH BHAGAT on 20-08-2026 : these are HTML5 date inputs - they only display a value
            'formatted yyyy-MM-dd. The raw .ToString left them blank in edit mode, so re-saving wiped the dates.
            txtEwayBillDate.Text = ToHtml5Date(DespatchDS.Tables(0).Rows(0)("desph_eway_bill_dt"))
            txtValidUpto.Text = ToHtml5Date(DespatchDS.Tables(0).Rows(0)("desph_valid_upto_dt"))
            'Modified-by MUKESH BHAGAT on 26-08-2026 : show the E-Way bill download link
            'when a document has already been attached to this challan.
            PopulateEwayDocument(challanNo)
            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            ddlIndent.SelectedValue = DespatchDS.Tables(0).Rows(0)("desph_third_party_indent_no").ToString
            ddlIndent.Enabled = False
            If DespatchDS.Tables(0).Rows(0)("desph_approved_yn").ToString = "Y" Then
                Aproved_yn = True
                btnSubmit.Enabled = False
                btnDelete.Visible = False
                'gvSKUDetails.Columns(9).Visible = False
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

        DespatchDS = DespatchObj.GetSKUDetailsForUpdateMode(challanNo, year, Constant.Common.ActiveStatus, userInfo.userBranchEntity, strLocationCode, poNo, vendorSiteId)
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

        'Dim chk As CheckBox
        'Dim txt As TextBox
        'Dim hdnCurrSkuStatus As HiddenField

        'For i As Integer = 0 To gvSKUDetails.Rows.Count - 1
        '    chk = gvSKUDetails.Rows(i).FindControl("chkSelect")
        '    hdnCurrSkuStatus = gvSKUDetails.Rows(i).FindControl("hdnCurrSkuStatus")
        '    txt = gvSKUDetails.Rows(i).FindControl("txtThisDesp")
        '    If (chk.Checked And hdnCurrSkuStatus.Value = "N" And CType(txt.Text.Trim, Integer) > 0) Then
        '        lblErrorMessage.Text = "Some skus are not applicable for this despatch.Please reject this despatch and generate new despatch request"
        '        Exit Sub
        '    End If
        'Next


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
            'Modified-by MUKESH BHAGAT on 09-09-2026 : an invoice PDF attached while EDITING was
            'validated by OCR but never stored (only the insert path called InsertDocument). The
            'copy must always be kept - including when the user saved after the "could not be
            'validated" warning - so support can later show exactly which PDF was submitted.
            '[challan_entry_insert_doc] updates the existing CHALLAN_DOC row when one exists.
            InsertDocument(Convert.ToInt64(hdnChallanno.Value), userInfo.userIDEntity, userInfo.userBranchEntity, sqlConn, sqlTrans)
            'Modified-by MUKESH BHAGAT on 31-08-2026 : the update transaction was NEVER
            'committed (long-standing defect, present in the old source too). The edit was
            'silently lost, and worse: the idle connection kept the open transaction and its
            'locks on despatch_hdr/despatch_dtl, blocking every other query on those tables
            'until the pooled connection was reset - pages appeared to hang forever.
            sqlTrans.Commit()
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
            'Modified-by MUKESH BHAGAT on 26-08-2026 : allow the E-Way bill to be attached
            '(or replaced) while editing an existing challan. Runs on its own connection
            'after the commit, so it cannot affect the challan update either way.
            SaveEwayBillDocument(Convert.ToInt64(hdnChallanno.Value))
        Else
            sqlTrans.Rollback()
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
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
                            'transpoterdetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dr(1).ToString, dr(0).ToString))
                            transpoterdetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dr(1).ToString, dr(0).ToString))
                        Next
                    End If
                End If

            Catch ex As Exception

            End Try
        End If

        Return transpoterdetails.ToArray()

    End Function

    'Private Sub chkbxListLocation_SelectedIndexChanged(sender As Object, e As EventArgs) Handles chkbxListLocation.SelectedIndexChanged
    '    PopulateProduct()
    '    PopulateDeliveryDepotName()
    '    'ddlDeliveryDepot.SelectedValue = ddlLocation.SelectedValue
    '    PopulateSiteDetails()
    '    PopulatePONo()
    '    BindGrid()
    'End Sub

    Private Sub ddlDeliveryDepot_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDeliveryDepot.SelectedIndexChanged
        PopulateSiteDetails()
        PopulatePONo()
        'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
        PopulateIndent()
        'Modified-by MUKESH BHAGAT on 24-08-2026 : refresh the reference GSTNs
        PopulateGstnDetails()
        BindGrid()
    End Sub

#End Region

#Region "Insert Document"
    Private Function InsertDocument(ByVal ChallanNo As Int64, ByVal UserID As String, ByVal UnitCode As String, ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction) As Integer
        'Dim sqlConn As SqlConnection = Nothing
        'Dim sqlTrans As SqlTransaction = Nothing

        Dim Extension As String = String.Empty
        ' Set the Response Content Type based on the file extension
        Extension = GetFileExtension(sch_fld1.FileName)

        Dim numRowsAffected As Integer = 0
        Dim DocUpld As New UnitDespatchClassVr1

        'Dim DocsFileName As String = GetFileNameWithoutExtension(sch_fld.FileName) + "." + Extension
        'Dim DocsOrgFileName As String = GetFileNameWithoutExtension(sch_fld.FileName) + "." + Extension
        Dim DocsFileName As String = sch_fld1.FileName
        Dim DocsOrgFileName As String = sch_fld1.FileName
        Dim DocPath As String = Format(Date.Now, "dd_MM_yyyy")

        If Not sch_fld1.PostedFile Is Nothing And sch_fld1.PostedFile.ContentLength > 0 Then
            Try


                'sqlConn = DBFactory.GetHelper.OpenConnection()
                'sqlTrans = sqlConn.BeginTransaction()


                numRowsAffected = DocUpld.InsertChallanDocument(ChallanNo, DocsFileName, DocsOrgFileName, DocPath, UserID, UnitCode, sqlConn, sqlTrans)
                If numRowsAffected > 0 Then
                    If Not sch_fld1.PostedFile Is Nothing And sch_fld1.PostedFile.ContentLength > 0 Then
                        'Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Vms Docs" & "\" & "Document_Repository"
                        Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\" & DocPath


                        Dim fn As String = System.IO.Path.GetFileName(sch_fld1.PostedFile.FileName)
                        'fn = GetFileNameWithoutExtension(fn) + "." + Extension
                        'fn = fn
                        Dim saveLocation As String = projectPath & "\" & fn


                        Dim file As System.IO.FileInfo = New System.IO.FileInfo(saveLocation)


                        If Not (Directory.Exists(projectPath)) Then
                            Directory.CreateDirectory(projectPath)
                        End If
                        sch_fld1.PostedFile.SaveAs(saveLocation)
                        'Else
                        '    lblErrorMessage.Text = "Select a document."
                        '    lblErrorMessage.ForeColor = Drawing.Color.Red
                    End If

                    'sqlTrans.Commit()
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
                'Finally
                '    If Not (sqlConn Is Nothing) Then
                '        'sqlConn is set to close state after completing the transaction
                '        'sqlConn.Close()
                '    End If
            End Try
        End If

        Return numRowsAffected
    End Function
#End Region

#Region "Save / Download E-Way Bill Document"
    'Modified-by MUKESH BHAGAT on 24-08-2026 : optional E-Way bill document.
    'Modified-by MUKESH BHAGAT on 26-08-2026 : the document is now also recorded in
    'dbo.challan_document_repository as doc_type='EWAY_DOC' (srl no 2) so it can be
    'downloaded again from this screen. The invoice copy stays doc_type='CHALLAN_DOC'
    '(srl no 1); the four procedures that read the table were filtered on
    'doc_type='CHALLAN_DOC' first, so the invoice download path is untouched.
    'Stored beside the invoice copy in Challan_Docs\<dd_MM_yyyy> and named
    'EWAY_<challan no>_<original name>, which also makes the file name unique per challan.
    'Never allowed to break the despatch: this runs after the challan is committed, on its
    'own connection with no transaction, and any failure is reported without losing the challan.
    Private Const EwayDocType As String = "EWAY_DOC"
    Private Const EwayDocSrlNo As Integer = 2

    Private Sub SaveEwayBillDocument(ByVal ChallanNo As Int64)
        Try
            If sch_fld_eway.PostedFile Is Nothing OrElse sch_fld_eway.PostedFile.ContentLength <= 0 Then
                Exit Sub
            End If

            If ChallanNo <= 0 Then
                Exit Sub
            End If

            Dim DocPath As String = Format(Date.Now, "dd_MM_yyyy")
            Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\" & DocPath

            If Not (Directory.Exists(projectPath)) Then
                Directory.CreateDirectory(projectPath)
            End If

            Dim originalName As String = System.IO.Path.GetFileName(sch_fld_eway.PostedFile.FileName)
            Dim storedName As String = "EWAY_" & ChallanNo.ToString() & "_" & originalName
            Dim saveLocation As String = projectPath & "\" & storedName

            sch_fld_eway.PostedFile.SaveAs(saveLocation)

            'Record it so the screen can offer it back for download.
            Dim DocUpld As New UnitDespatchClassVr1
            DocUpld.InsertChallanTypedDocument(ChallanNo, storedName, storedName, DocPath,
                                               userInfo.userIDEntity, userInfo.userBranchEntity,
                                               EwayDocType, EwayDocSrlNo)

            hdnEwayDocPath.Value = DocPath
            hdnEwayDocFile.Value = storedName
            lblEwayDocName.Text = "Uploaded: " & storedName
            lblEwayDocName.Visible = True
            lnkDownloadEway.Visible = True
        Catch ex As Exception
            lblErrorMessage.Text = "Challan saved, but the E-Way bill document could not be stored."
            lblErrorMessage.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    'Modified-by MUKESH BHAGAT on 26-08-2026 : in update mode, show the download link when
    'an E-Way bill has already been attached to this challan.
    'Modified-by MUKESH BHAGAT on 31-08-2026 : also loads the stored invoice copy, and shows
    'each stored file's name above its download button.
    Private Sub PopulateEwayDocument(ByVal ChallanNo As Int64)
        Try
            hdnEwayDocPath.Value = String.Empty
            hdnEwayDocFile.Value = String.Empty
            lnkDownloadEway.Visible = False
            lblEwayDocName.Visible = False
            hdnInvDocPath.Value = String.Empty
            hdnInvDocFile.Value = String.Empty
            lnkDownloadInvoice.Visible = False
            lblInvDocName.Visible = False

            If ChallanNo <= 0 Then
                Exit Sub
            End If

            Dim DocObj As New UnitDespatchClassVr1

            'stored invoice copy (doc_type CHALLAN_DOC)
            Dim InvDS As DataSet = DocObj.GetChallanTypedDocument(ChallanNo, userInfo.userBranchEntity, "CHALLAN_DOC")
            If InvDS IsNot Nothing AndAlso InvDS.Tables.Count > 0 AndAlso InvDS.Tables(0).Rows.Count > 0 Then
                Dim invRow As DataRow = InvDS.Tables(0).Rows(0)
                hdnInvDocPath.Value = Convert.ToString(invRow("doc_doc_path"))
                hdnInvDocFile.Value = Convert.ToString(invRow("doc_org_filename"))
                If Not String.IsNullOrEmpty(hdnInvDocFile.Value) Then
                    lblInvDocName.Text = "Uploaded: " & hdnInvDocFile.Value
                    lblInvDocName.Visible = True
                    lnkDownloadInvoice.Visible = True
                End If
            End If

            'stored E-Way bill (doc_type EWAY_DOC)
            Dim DocDS As DataSet = DocObj.GetChallanTypedDocument(ChallanNo, userInfo.userBranchEntity, EwayDocType)
            If DocDS IsNot Nothing AndAlso DocDS.Tables.Count > 0 AndAlso DocDS.Tables(0).Rows.Count > 0 Then
                Dim docRow As DataRow = DocDS.Tables(0).Rows(0)
                hdnEwayDocPath.Value = Convert.ToString(docRow("doc_doc_path"))
                hdnEwayDocFile.Value = Convert.ToString(docRow("doc_org_filename"))
                If Not String.IsNullOrEmpty(hdnEwayDocFile.Value) Then
                    lblEwayDocName.Text = "Uploaded: " & hdnEwayDocFile.Value
                    lblEwayDocName.Visible = True
                    lnkDownloadEway.Visible = True
                End If
            End If
        Catch ex As Exception
            'A missing document must never stop the challan from opening.
            lnkDownloadEway.Visible = False
            lnkDownloadInvoice.Visible = False
        End Try
    End Sub

    'Modified-by MUKESH BHAGAT on 31-08-2026 : streams the stored invoice copy to the browser.
    Protected Sub lnkDownloadInvoice_Click(ByVal sender As Object, ByVal e As EventArgs)
        CheckLogin()

        If String.IsNullOrEmpty(hdnInvDocFile.Value) Then
            Exit Sub
        End If

        Dim genReportPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\"
        Dim absolutePath As String = genReportPath & hdnInvDocPath.Value & "\" & hdnInvDocFile.Value

        If Not File.Exists(absolutePath) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "invmissing", "alert('Invoice document not found on the server.');", True)
            Exit Sub
        End If

        Response.Clear()
        Response.Charset = ""
        Response.ContentType = "application/octet-stream"
        Response.AppendHeader("content-disposition", "attachment; filename=""" & hdnInvDocFile.Value & """")
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.TransmitFile(absolutePath)
        Response.Flush()
        Response.SuppressContent = True
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    'Modified-by MUKESH BHAGAT on 26-08-2026 : streams the stored E-Way bill to the browser.
    Protected Sub lnkDownloadEway_Click(ByVal sender As Object, ByVal e As EventArgs)
        CheckLogin()

        If String.IsNullOrEmpty(hdnEwayDocFile.Value) Then
            Exit Sub
        End If

        Dim genReportPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Challan_Docs" & "\"
        Dim absolutePath As String = genReportPath & hdnEwayDocPath.Value & "\" & hdnEwayDocFile.Value

        If Not File.Exists(absolutePath) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ewaymissing", "alert('E-Way bill document not found on the server.');", True)
            Exit Sub
        End If

        Response.Clear()
        Response.Charset = ""
        Response.ContentType = "application/octet-stream"
        Response.AppendHeader("content-disposition", "attachment; filename=""" & hdnEwayDocFile.Value & """")
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.TransmitFile(absolutePath)
        Response.Flush()
        Response.SuppressContent = True
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub
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

    'Protected Sub ddlProduct_SelectedIndexChanged(sender As Object, e As EventArgs)
    '    Dim s As String = ddlProduct.SelectedValue
    '    BindGrid()
    'End Sub
    Protected Sub chkbxListLocation_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateProduct()
        PopulateDeliveryDepotName()
        'ddlDeliveryDepot.SelectedValue = ddlLocation.SelectedValue
        PopulateSiteDetails()
        PopulatePONo()
        BindGrid()
    End Sub

    'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
    Protected Sub ddlIndent_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlIndent.SelectedIndexChanged
        If ddlIndent.SelectedValue <> String.Empty Then
            PopulateIndentDetails(ddlIndent.SelectedValue)
        Else
            ClearIndentDetails()
        End If
    End Sub


    Private Sub PopulateIndentDetails(ByVal indentId As String)
        Try
            CheckLogin()
            Dim indentObj As New UnitDespatchClass
            Dim ds As DataSet = indentObj.GetIndentDetailsPando(indentId)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim dr As DataRow = ds.Tables(0).Rows(0)

                'chkApprovedTranspoterYN.Checked = True
                'chkApprovedTranspoterYN_CheckedChanged(Nothing, Nothing)

                txtTruckNo.Text = dr("vehicle_number").ToString()
                txtTransporter.Text = dr("transporter_name").ToString()
                'hdnTranspoterId.Value = dr("transporter_code").ToString()
                'txtTranspoterName.Text = dr("transporter_name_code").ToString()


            Else
                ClearIndentDetails()

                'chkApprovedTranspoterYN.Checked = False
            End If

        Catch ex As Exception
            lblErrorMessage.Text = "Error while fetching indent details."
            lblErrorMessage.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Private Sub ClearIndentDetails()
        txtTruckNo.Text = String.Empty
        txtTransporter.Text = String.Empty
        hdnTranspoterId.Value = String.Empty
        txtTranspoterName.Text = String.Empty
    End Sub
End Class
