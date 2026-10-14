Imports System.Data
Imports VMS.Web

Partial Class BulkRawMaterialReceiptDtls
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Dim ObjDocumentType As New VMS.Web.Common()
    Dim dtItmDtlsactual As New DataTable()

    Private Const DefaultSubInventory As String = "New"
    Private Const DefaultLocator As String = "Good"

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub AddAttributes()
        btnSubmit.Attributes.Add("onClick", "return validateReceive();")
        btnAdd.Attributes.Add("onClick", "return validateAdjustment();")
        txtQtyPop.Attributes.Add("onblur", "return validatereceivequantitycheck('" & txtQtyPop.ClientID & "','" & lblDespopQty.ClientID & "');")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        AddAttributes()
        If Not IsPostBack Then
            InitItemDespTable()
            If Not String.IsNullOrWhiteSpace(Convert.ToString(Request.QueryString("receive_id"))) Then
                BindReceivedView()
            Else
                BindData()
            End If
        End If
    End Sub

    Private Sub InitItemDespTable()
        dtItmDtlsactual = New DataTable()
        dtItmDtlsactual.Columns.Add(New DataColumn("item_code", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("item_name", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("item_type", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("item_type_code", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("sub_inventory", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("sub_inventory_code", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("locator", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("locator_code", GetType(String)))
        dtItmDtlsactual.Columns.Add(New DataColumn("received_qty", GetType(Decimal)))
        dtItmDtlsactual.Columns.Add(New DataColumn("request_quant", GetType(Decimal)))

        dtItmDtlsactual.Columns.Add(New DataColumn("Good_Qty", GetType(Decimal)))
        dtItmDtlsactual.Columns.Add(New DataColumn("Short_Qty", GetType(Decimal)))
        dtItmDtlsactual.Columns.Add(New DataColumn("Damage_Qty", GetType(Decimal)))
        ViewState("ItemDesp") = dtItmDtlsactual
    End Sub

    Private Sub BindData()
        Try
            Dim despatchId As Integer = 0
            Integer.TryParse(Convert.ToString(Request.QueryString("despatch_id")), despatchId)
            If despatchId <= 0 Then
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "Invalid despatch id.")
                btnSubmit.Visible = False
                Return
            End If

            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetRawMaterial_DespatchHdrList(despatchId.ToString())

            If ds Is Nothing OrElse ds.Tables.Count = 0 Then
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "Despatch data not found.")
                gvVendorRawMat.DataSource = Nothing
                gvVendorRawMat.DataBind()
                btnSubmit.Visible = False
                Return
            End If

            If Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim hdr As DataRow = ds.Tables(0).Rows(0)
                Dim qsDespatchId As String = Convert.ToString(Request.QueryString("despatch_id"))
                hdnDespatchId.Value = If(Not String.IsNullOrWhiteSpace(qsDespatchId), qsDespatchId, GetColumnValue(hdr, "despatch_id", "despatchid"))
                hdnRequisitionId.Value = GetColumnValue(hdr, "requisition_id", "request_id")

                txtCourierno.Text = GetColumnValue(hdr, "courier_id")
                txtcouriernm.Text = ds.Tables(0).Rows(0)("couriernm")
                If ds.Tables(0).Rows(0)("courier_date").Equals(DBNull.Value) Then
                    txtcourierDT.Text = String.Empty
                Else
                    txtcourierDT.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("courier_date")).ToString("dd/MM/yyyy")
                End If

                If ds.Tables(0).Rows(0)("despatch_date").Equals(DBNull.Value) Then
                    txtDOJ.Text = String.Empty
                Else
                    txtDOJ.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("despatch_date")).ToString("dd/MM/yyyy")
                End If
                txtinvno.Text = ds.Tables(0).Rows(0)("inv_no")
                If ds.Tables(0).Rows(0)("inv_date").Equals(DBNull.Value) Then
                    txtinvdate.Text = String.Empty
                Else
                    txtinvdate.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("inv_date")).ToString("dd/MM/yyyy")
                End If
                txtTransporterNM.Text = ds.Tables(0).Rows(0)("trans_name")
                txttransno.Text = ds.Tables(0).Rows(0)("transid")
                txtlrno.Text = ds.Tables(0).Rows(0)("lrno")

                If ds.Tables(0).Rows(0)("lrdate").Equals(DBNull.Value) Then
                    txtlrdate.Text = String.Empty
                Else
                    txtlrdate.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("lrdate")).ToString("dd/MM/yyyy")
                End If
                txtVehicleno.Text = ds.Tables(0).Rows(0)("vehicle_no")
                txtdeliverytype.Text = ds.Tables(0).Rows(0)("del_type")
            End If

            Dim dtDetails As DataTable = Nothing
            If ds.Tables.Count > 1 AndAlso Not (ds.Tables(1) Is Nothing) AndAlso HasDetailCodeColumn(ds.Tables(1)) Then
                dtDetails = ds.Tables(1)
            ElseIf HasDetailCodeColumn(ds.Tables(0)) Then
                dtDetails = ds.Tables(0)
            End If

            If Not (dtDetails Is Nothing) AndAlso dtDetails.Rows.Count > 0 Then
                SeedItemDespFromDetails(dtDetails)
                GridBind()
                lblErrorMessage.Text = String.Empty
            Else
                gvVendorRawMat.DataSource = Nothing
                gvVendorRawMat.DataBind()
                btnSubmit.Visible = False
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "No pending raw material found for receipt.")
            End If
            SetReceiptMode(False)
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect(returnUrl)
        End Try
    End Sub

    Private Sub BindReceivedView()
        Try
            Dim receiveId As Integer = 0
            Integer.TryParse(Convert.ToString(Request.QueryString("receive_id")), receiveId)
            If receiveId <= 0 Then
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "Invalid receive id.")
                SetReceiptMode(True)
                Return
            End If

            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetRawMaterial_ReceivedHdrList(receiveId.ToString())

            If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing OrElse ds.Tables(0).Rows.Count = 0 Then
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "Received data not found.")
                SetReceiptMode(True)
                Return
            End If

            Dim hdr As DataRow = ds.Tables(0).Rows(0)
            hdnReceiveId.Value = GetColumnValue(hdr, "receive_id")
            hdnDespatchId.Value = GetColumnValue(hdr, "despatch_id", "despatchid")
            hdnRequisitionId.Value = GetColumnValue(hdr, "requisition_id", "request_id")
            txtreceiptNo.Text = GetColumnValue(hdr, "receive_id")
            txtCourierno.Text = GetColumnValue(hdr, "courier_id")

            txtinvno.Text = ds.Tables(0).Rows(0)("inv_no")
            If ds.Tables(0).Rows(0)("inv_date").Equals(DBNull.Value) Then
                txtinvdate.Text = String.Empty
            Else
                txtinvdate.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("inv_date")).ToString("dd/MM/yyyy")
            End If
            txtTransporterNM.Text = ds.Tables(0).Rows(0)("trans_name")

            If ds.Tables(0).Rows(0)("lrno").Equals(DBNull.Value) Then
                txtlrno.Text = String.Empty
            Else
                txtlrno.Text = ds.Tables(0).Rows(0)("lrno")
            End If

            If ds.Tables(0).Rows(0)("lrdate").Equals(DBNull.Value) Then
                txtlrdate.Text = String.Empty
            Else
                txtlrdate.Text = Convert.ToDateTime(ds.Tables(0).Rows(0)("lrdate")).ToString("dd/MM/yyyy")
            End If

            If ds.Tables(0).Rows(0)("vehicle_no").Equals(DBNull.Value) Then
                txtVehicleno.Text = String.Empty
            Else
                txtVehicleno.Text = ds.Tables(0).Rows(0)("vehicle_no")
            End If

            If ds.Tables(0).Rows(0)("del_type").Equals(DBNull.Value) Then
                txtdeliverytype.Text = String.Empty
            Else
                txtdeliverytype.Text = ds.Tables(0).Rows(0)("del_type")
            End If


            If hdr.Table.Columns.Contains("despatch_date") AndAlso Not hdr("despatch_date").Equals(DBNull.Value) Then
                txtDOJ.Text = Convert.ToDateTime(hdr("despatch_date")).ToString("dd/MM/yyyy")
            Else
                txtDOJ.Text = String.Empty
            End If

            If ds.Tables.Count > 1 AndAlso ds.Tables(1) IsNot Nothing Then
                gvReceivedItems.DataSource = ds.Tables(1)
                gvReceivedItems.DataBind()
            Else
                gvReceivedItems.DataSource = Nothing
                gvReceivedItems.DataBind()
            End If

            lblErrorMessage.Text = String.Empty
            SetReceiptMode(True)
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Private Sub SetReceiptMode(ByVal isViewMode As Boolean)
        divgvrequestdetails.Visible = Not isViewMode
        divgvrequest.Visible = isViewMode
        btnSubmit.Visible = Not isViewMode AndAlso gvVendorRawMat.Rows.Count > 0

    End Sub

    Private Function HasDetailCodeColumn(ByVal dt As DataTable) As Boolean
        If dt Is Nothing Then
            Return False
        End If
        Return dt.Columns.Contains("rawmaterial_code") OrElse dt.Columns.Contains("rawmat_code")
    End Function

    Private Sub SeedItemDespFromDetails(ByVal dtDetails As DataTable)
        dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)
        If dtItmDtlsactual Is Nothing Then
            InitItemDespTable()
            dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)
        End If
        dtItmDtlsactual.Rows.Clear()

        For Each dr As DataRow In dtDetails.Rows
            Dim rawmatCode As String = GetColumnValue(dr, "rawmaterial_code", "rawmat_code")
            Dim rawmatName As String = GetColumnValue(dr, "rawmaterial_name", "rawmat_name")
            Dim requestQty As Decimal = ToDecimal(GetColumnValue(dr, "request_quant", "request_qty", "reqst_Qty"))
            Dim receiveQty As Decimal = GetFirstPositiveQty(dr, "despatch_qunt", "dispatch_qty", "pending_qty")
            Dim subInventory As String = GetColumnValue(dr, "sub_inventory")
            Dim locator As String = GetColumnValue(dr, "locater", "locator")
            Dim Good_Qty As Decimal = ToDecimal(GetColumnValue(dr, "Good_Qty", "Good_Qty", "Good_Qty"))
            Dim Short_Qty As Decimal = ToDecimal(GetColumnValue(dr, "Short_Qty", "Short_Qty", "Short_Qty"))
            Dim Damage_Qty As Decimal = ToDecimal(GetColumnValue(dr, "Damage_Qty", "Damage_Qty", "Damage_Qty"))

            If String.IsNullOrWhiteSpace(subInventory) Then
                subInventory = DefaultSubInventory
            End If
            If String.IsNullOrWhiteSpace(locator) Then
                locator = DefaultLocator
            End If

            dtItmDtlsactual.Rows.Add(rawmatCode, rawmatName, "Good", "G", subInventory, subInventory, locator, locator, receiveQty, requestQty, Good_Qty, Short_Qty, Damage_Qty)
        Next

        ViewState("ItemDesp") = dtItmDtlsactual
    End Sub

    Private Sub GridBind()
        dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)
        If dtItmDtlsactual Is Nothing Then
            gvVendorRawMat.DataSource = Nothing
            gvVendorRawMat.DataBind()
            btnSubmit.Visible = False
            Return
        End If

        Dim dtShow As New DataTable()
        dtShow.Columns.Add("rawmaterial_code")
        dtShow.Columns.Add("rawmaterial_name")
        dtShow.Columns.Add("despatch_qunt", GetType(Decimal))
        dtShow.Columns.Add("request_quant", GetType(Decimal))
        dtShow.Columns.Add("sub_inventory")
        dtShow.Columns.Add("locater")

        dtShow.Columns.Add("Good_Qty", GetType(Decimal))
        dtShow.Columns.Add("Short_Qty", GetType(Decimal))
        dtShow.Columns.Add("Damage_Qty", GetType(Decimal))

        Dim distinctItem As DataTable = dtItmDtlsactual.DefaultView.ToTable("Temp", True, "item_code", "item_name")
        If distinctItem.Rows.Count > 0 Then
            For Each itmrow As DataRow In distinctItem.Rows
                Dim condi As String = "item_code = '" & Convert.ToString(itmrow("item_code")).Replace("'", "''") & "'"
                Dim firstRows As DataRow() = dtItmDtlsactual.Select(condi)
                Dim drSum As DataRow = dtShow.NewRow()
                drSum("rawmaterial_code") = itmrow("item_code")
                drSum("rawmaterial_name") = itmrow("item_name")
                drSum("despatch_qunt") = ToDecimal(dtItmDtlsactual.Compute("Sum(received_qty)", condi))
                Dim reqObj As Object = dtItmDtlsactual.Compute("Max(request_quant)", condi)
                drSum("request_quant") = If(reqObj Is Nothing OrElse IsDBNull(reqObj), 0D, ToDecimal(reqObj))

                If firstRows.Length > 0 Then
                    drSum("sub_inventory") = firstRows(0)("sub_inventory_code")
                    drSum("locater") = firstRows(0)("locator_code")
                Else
                    drSum("sub_inventory") = DefaultSubInventory
                    drSum("locater") = DefaultLocator
                End If

                drSum("Good_Qty") = ToDecimal(dtItmDtlsactual.Compute("Sum(Good_Qty)", condi))
                drSum("Short_Qty") = ToDecimal(dtItmDtlsactual.Compute("Sum(Short_Qty)", condi))
                drSum("Damage_Qty") = ToDecimal(dtItmDtlsactual.Compute("Sum(Damage_Qty)", condi))

                dtShow.Rows.Add(drSum)
            Next
        End If

        gvVendorRawMat.DataSource = dtShow
        gvVendorRawMat.DataBind()
        gvVendorRawMat.Visible = (dtShow.Rows.Count > 0)
        btnSubmit.Visible = (dtShow.Rows.Count > 0)
        btnSubmit.Enabled = (dtShow.Rows.Count > 0)
    End Sub

    Protected Sub gvVendorRawMat_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName <> "Adjustment" Then
            Return
        End If

        Try
            lblmsg.Text = String.Empty
            lblError.Text = String.Empty

            Dim row As GridViewRow = CType(CType(e.CommandSource, Button).NamingContainer, GridViewRow)
            Dim totdespqunt As Decimal = 0D

            Dim hdnitem As HiddenField = CType(row.FindControl("hdnRawMatCode"), HiddenField)
            Dim hdnsubinvemtory As HiddenField = CType(row.FindControl("hdnsubinvemtory"), HiddenField)
            Dim hdnlocator As HiddenField = CType(row.FindControl("hdnlocator"), HiddenField)
            Dim lblitem As Label = CType(row.FindControl("lblRawMatName"), Label)
            Dim lbldespQty As Label = CType(row.FindControl("lblDespQty"), Label)
            Dim txtQty As TextBox = CType(row.FindControl("txtQty"), TextBox)

            populateSubInventory(ddlSubInventoryPop)
            If Not String.IsNullOrWhiteSpace(hdnsubinvemtory.Value) AndAlso ddlSubInventoryPop.Items.FindByValue(hdnsubinvemtory.Value) IsNot Nothing Then
                ddlSubInventoryPop.SelectedValue = hdnsubinvemtory.Value
            End If

            populateLocator(ddlLocatorPop)
            If Not String.IsNullOrWhiteSpace(hdnlocator.Value) AndAlso ddlLocatorPop.Items.FindByValue(hdnlocator.Value) IsNot Nothing Then
                ddlLocatorPop.SelectedValue = hdnlocator.Value
            End If

            lblDespopQty.Text = lbldespQty.Text
            hdnDespQtygv.Value = lbldespQty.Text
            lblHItemPop.Text = lblitem.Text
            lblQtyPop.Text = lbldespQty.Text
            hdnItemCodePop.Value = hdnitem.Value
            hdnItemTypePop.Value = "G"
            hdnRequestQtyPop.Value = If(txtQty Is Nothing, "0", txtQty.Text)
            txtQtyPop.Text = lbldespQty.Text

            populatepopgv(hdnItemCodePop.Value)

            If gvAdjustDtls.Rows.Count > 0 Then
                For Each gvRow As GridViewRow In gvAdjustDtls.Rows
                    Dim lblQtygv As Label = CType(gvRow.FindControl("lblQtygv"), Label)
                    totdespqunt += ToDecimal(lblQtygv.Text)
                Next

                If totdespqunt = ToDecimal(lblQtyPop.Text) Then
                    btnAdjust.Visible = False
                Else
                    btnAdjust.Visible = True
                End If
            ElseIf ToDecimal(lblDespopQty.Text) = 0D Then
                btnAdjust.Visible = True
                btnAdjust.Enabled = True
            Else
                btnAdjust.Visible = True
                btnAdjust.Enabled = False
            End If

            lblDespopQty.Text = FormatQty(ToDecimal(lblDespopQty.Text) - ToDecimal(txtQtyPop.Text))
            If ToDecimal(lblDespopQty.Text) = 0D Then
                btnAdjust.Enabled = True
            Else
                btnAdjust.Enabled = False
            End If

            mpAdjust.Show()
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Protected Sub gvVendorRawMat_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim lbldespQty As Label = CType(e.Row.FindControl("lblDespQty"), Label)
            If lbldespQty IsNot Nothing Then
                txtQtyPop.Text = lbldespQty.Text
            End If
        End If
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim dtItmDtls As DataTable = CreateAdjustTable()

        If gvAdjustDtls.Rows.Count > 0 Then
            For Each gvRow As GridViewRow In gvAdjustDtls.Rows
                AddAdjustRowFromGrid(dtItmDtls, gvRow)
            Next
        End If

        If dtItmDtls.Rows.Count > 0 Then
            Dim condi As String = "item_code = '" & hdnItemCodePop.Value.Replace("'", "''") & "' AND item_type_code = 'G' AND sub_inventory_code = '" & ddlSubInventoryPop.SelectedValue.Replace("'", "''") & "' AND locator_code = '" & ddlLocatorPop.SelectedValue.Replace("'", "''") & "'"
            Dim itmrow As DataRow() = dtItmDtls.Select(condi)
            If itmrow.Length > 0 Then
                lblmsg.Text = ""
                RmActionPopup.ShowError(Me, "You have already added this sub inventory and locator.")
            Else
                AppendAdjustLine(dtItmDtls)
            End If
        Else
            AppendAdjustLine(dtItmDtls)
        End If

        mpAdjust.Show()
    End Sub

    Private Sub AppendAdjustLine(ByVal dtItmDtls As DataTable)
        Dim subInvText As String = If(ddlSubInventoryPop.SelectedItem Is Nothing, String.Empty, ddlSubInventoryPop.SelectedItem.Text)
        Dim locatorText As String = If(ddlLocatorPop.SelectedItem Is Nothing, String.Empty, ddlLocatorPop.SelectedItem.Text)

        dtItmDtls.Rows.Add(hdnItemCodePop.Value, lblHItemPop.Text, "Good", "G", subInvText, ddlSubInventoryPop.SelectedValue, locatorText, ddlLocatorPop.SelectedValue, ToDecimal(txtQtyPop.Text))
        lblDespopQty.Text = FormatQty(ToDecimal(lblDespopQty.Text) - ToDecimal(txtQtyPop.Text))
        If ToDecimal(lblDespopQty.Text) = 0D Then
            btnAdjust.Enabled = True
        Else
            btnAdjust.Enabled = False
        End If
        gvAdjustDtls.DataSource = dtItmDtls
        gvAdjustDtls.DataBind()
        lblmsg.Text = String.Empty
    End Sub

    Protected Sub btnadjust_Click(sender As Object, e As EventArgs)
        dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)
        If dtItmDtlsactual Is Nothing Then
            InitItemDespTable()
            dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)
        End If

        If dtItmDtlsactual.Rows.Count > 0 Then
            Dim condi As String = "item_code = '" & hdnItemCodePop.Value.Replace("'", "''") & "'"
            Dim itmrow As DataRow() = dtItmDtlsactual.Select(condi)
            If itmrow.Length > 0 Then
                For Each dr As DataRow In itmrow
                    dr.Delete()
                Next
            End If
            dtItmDtlsactual.AcceptChanges()
        End If

        Dim requestQty As Decimal = ToDecimal(hdnRequestQtyPop.Value)
        If gvAdjustDtls.Rows.Count > 0 Then
            For Each gvRow As GridViewRow In gvAdjustDtls.Rows
                Dim lblitemname As Label = CType(gvRow.FindControl("lblitemname"), Label)
                Dim hdnitemcode As HiddenField = CType(gvRow.FindControl("hdnitemcode"), HiddenField)
                Dim lbltype As Label = CType(gvRow.FindControl("lbltype"), Label)
                Dim hdntypecode As HiddenField = CType(gvRow.FindControl("hdntypecode"), HiddenField)
                Dim lblsubinventory As Label = CType(gvRow.FindControl("lblsubinventory"), Label)
                Dim hdnsubinventorycode As HiddenField = CType(gvRow.FindControl("hdnsubinventorycode"), HiddenField)
                Dim lbllocator As Label = CType(gvRow.FindControl("lbllocator"), Label)
                Dim hdnlocatorcode As HiddenField = CType(gvRow.FindControl("hdnlocatorcode"), HiddenField)
                Dim lblQtygv As Label = CType(gvRow.FindControl("lblQtygv"), Label)
                Dim itemType As String = If(lbltype Is Nothing OrElse String.IsNullOrWhiteSpace(lbltype.Text), "Good", lbltype.Text)
                Dim itemTypeCode As String = If(hdntypecode Is Nothing OrElse String.IsNullOrWhiteSpace(hdntypecode.Value), "G", hdntypecode.Value)
                dtItmDtlsactual.Rows.Add(hdnitemcode.Value, lblitemname.Text, itemType, itemTypeCode, lblsubinventory.Text, hdnsubinventorycode.Value, lbllocator.Text, hdnlocatorcode.Value, ToDecimal(lblQtygv.Text), requestQty)
            Next
        End If

        dtItmDtlsactual.AcceptChanges()
        ViewState("ItemDesp") = dtItmDtlsactual
        GridBind()
        ClearModal()
        mpAdjust.Hide()
    End Sub

    Protected Sub gvAdjustDtls_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName <> "Remove" Then
            Return
        End If

        Dim row As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)
        Dim rowindex As Integer = row.RowIndex
        Dim dtItmDtls As DataTable = CreateAdjustTable()

        If gvAdjustDtls.Rows.Count > 0 Then
            For Each gvRow As GridViewRow In gvAdjustDtls.Rows
                AddAdjustRowFromGrid(dtItmDtls, gvRow)
            Next
            dtItmDtls.Rows.RemoveAt(rowindex)
            dtItmDtls.AcceptChanges()
        End If

        Dim lblremoveQtygv As Label = CType(row.FindControl("lblQtygv"), Label)
        lblDespopQty.Text = FormatQty(ToDecimal(lblDespopQty.Text) + ToDecimal(lblremoveQtygv.Text))
        If ToDecimal(lblDespopQty.Text) = 0D Then
            btnAdjust.Visible = True
            btnAdjust.Enabled = True
        Else
            btnAdjust.Visible = True
            btnAdjust.Enabled = False
        End If

        gvAdjustDtls.DataSource = dtItmDtls
        gvAdjustDtls.DataBind()
        mpAdjust.Show()
    End Sub

    Protected Sub ddlSubInventoryPop_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            populateLocator(ddlLocatorPop)
            mpAdjust.Show()
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Protected Sub lbtnExit_Click(sender As Object, e As EventArgs) Handles lbtnExit.Click
        ClearModal()
        mpAdjust.Hide()
    End Sub

    Private Sub ClearModal()
        If ddlSubInventoryPop.Items.Count > 0 Then
            ddlSubInventoryPop.SelectedIndex = 0
        End If
        ddlLocatorPop.Items.Clear()
        txtQtyPop.Text = String.Empty
        lblDespopQty.Text = String.Empty
        hdnDespQtygv.Value = String.Empty
        hdnRequestQtyPop.Value = String.Empty
        lblmsg.Text = String.Empty
        lblError.Text = String.Empty
        gvAdjustDtls.DataSource = Nothing
        gvAdjustDtls.DataBind()
        hdnItemCodePop.Value = String.Empty
        hdnItemTypePop.Value = String.Empty
        lblHItemPop.Text = String.Empty
        lblQtyPop.Text = "0"
        btnAdjust.Enabled = False
        btnAdjust.Visible = False
    End Sub

    Private Sub populateSubInventory(ByVal ddlSubInventory As DropDownList)
        Dim ds As DataSet = ObjDocumentType.GetLovDetails(Constant.Common.Company, "SUB_INVENTORY", Constant.Common.ActiveStatus)
        If Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim dv As DataView = ds.Tables(0).DefaultView
            dv.Sort = "lov_value ASC"
            ddlSubInventory.DataSource = dv
            ddlSubInventory.DataTextField = "lov_value"
            ddlSubInventory.DataValueField = "lov_code"
            ddlSubInventory.DataBind()
            ddlSubInventory.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        Else
            ddlSubInventory.Items.Clear()
            ddlSubInventory.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub

    Private Sub populateLocator(ByVal ddlLocator As DropDownList)
        Dim lovType As String
        If String.Compare(ddlSubInventoryPop.SelectedValue, "New", StringComparison.CurrentCultureIgnoreCase) = 0 OrElse String.IsNullOrEmpty(ddlSubInventoryPop.SelectedValue) Then
            lovType = "CB_SUB_INVENTORY"
        Else
            lovType = "CB_SCRAP_LOCATOR"
        End If

        Dim ds As DataSet = ObjDocumentType.GetLovDetails(Constant.Common.Company, lovType, Constant.Common.ActiveStatus)
        If Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim dv As DataView = ds.Tables(0).DefaultView
            dv.Sort = "lov_value ASC"
            ddlLocator.DataSource = dv
            ddlLocator.DataTextField = "lov_value"
            ddlLocator.DataValueField = "lov_code"
            ddlLocator.DataBind()
            ddlLocator.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        Else
            ddlLocator.Items.Clear()
            ddlLocator.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub

    Private Sub populatepopgv(ByVal item As String)
        Dim dtItmDtls As DataTable = CType(ViewState("ItemDesp"), DataTable)
        Dim dtShowAdj As DataTable = CreateAdjustTable()

        If dtItmDtls Is Nothing Then
            gvAdjustDtls.DataSource = Nothing
            gvAdjustDtls.DataBind()
            Return
        End If

        Dim condi As String = "item_code = '" & item.Replace("'", "''") & "'"
        Dim itmrow As DataRow() = dtItmDtls.Select(condi)
        If itmrow.Length > 0 Then
            For Each dr As DataRow In itmrow
                Dim drSA As DataRow = dtShowAdj.NewRow()
                drSA("item_code") = Convert.ToString(dr("item_code"))
                drSA("item_name") = dr("item_name")
                drSA("item_type") = dr("item_type")
                drSA("item_type_code") = dr("item_type_code")
                drSA("sub_inventory") = dr("sub_inventory")
                drSA("sub_inventory_code") = dr("sub_inventory_code")
                drSA("locator") = dr("locator")
                drSA("locator_code") = dr("locator_code")
                drSA("received_qty") = dr("received_qty")
                dtShowAdj.Rows.Add(drSA)
            Next
            gvAdjustDtls.DataSource = dtShowAdj
            gvAdjustDtls.DataBind()
        Else
            gvAdjustDtls.DataSource = Nothing
            gvAdjustDtls.DataBind()
        End If
    End Sub

    Private Function CreateAdjustTable() As DataTable
        Dim dtItmDtls As New DataTable()
        dtItmDtls.Columns.Add(New DataColumn("item_code", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("item_name", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("item_type", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("item_type_code", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("sub_inventory", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("sub_inventory_code", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("locator", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("locator_code", GetType(String)))
        dtItmDtls.Columns.Add(New DataColumn("received_qty", GetType(Decimal)))
        Return dtItmDtls
    End Function

    Private Sub AddAdjustRowFromGrid(ByVal dtItmDtls As DataTable, ByVal gvRow As GridViewRow)
        Dim lblitemname As Label = CType(gvRow.FindControl("lblitemname"), Label)
        Dim hdnitemcode As HiddenField = CType(gvRow.FindControl("hdnitemcode"), HiddenField)
        Dim lbltype As Label = CType(gvRow.FindControl("lbltype"), Label)
        Dim hdntypecode As HiddenField = CType(gvRow.FindControl("hdntypecode"), HiddenField)
        Dim lblsubinventory As Label = CType(gvRow.FindControl("lblsubinventory"), Label)
        Dim hdnsubinventorycode As HiddenField = CType(gvRow.FindControl("hdnsubinventorycode"), HiddenField)
        Dim lbllocator As Label = CType(gvRow.FindControl("lbllocator"), Label)
        Dim hdnlocatorcode As HiddenField = CType(gvRow.FindControl("hdnlocatorcode"), HiddenField)
        Dim lblQtygv As Label = CType(gvRow.FindControl("lblQtygv"), Label)
        Dim itemType As String = If(lbltype Is Nothing OrElse String.IsNullOrWhiteSpace(lbltype.Text), "Good", lbltype.Text)
        Dim itemTypeCode As String = If(hdntypecode Is Nothing OrElse String.IsNullOrWhiteSpace(hdntypecode.Value), "G", hdntypecode.Value)
        dtItmDtls.Rows.Add(hdnitemcode.Value, lblitemname.Text, itemType, itemTypeCode, lblsubinventory.Text, hdnsubinventorycode.Value, lbllocator.Text, hdnlocatorcode.Value, ToDecimal(lblQtygv.Text))
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim obj As New OPC_VendorClass()
        Dim receiveId As Integer = 0
        Try
            lblErrorMessage.Text = String.Empty
            btnSubmit.Enabled = False

            Dim dispatchId As Integer = 0
            Integer.TryParse(hdnDespatchId.Value, dispatchId)
            If dispatchId <= 0 Then
                Integer.TryParse(Convert.ToString(Request.QueryString("despatch_id")), dispatchId)
            End If
            If dispatchId <= 0 Then
                ShowSubmitMessage("Invalid despatch id.", False)
                Return
            End If

            dtItmDtlsactual = CType(ViewState("ItemDesp"), DataTable)

            'If dtItmDtlsactual Is Nothing OrElse dtItmDtlsactual.Rows.Count = 0 Then
            '    ShowSubmitMessage("Please do the Adjustment for any one Item from the List.", False)
            '    Return
            'End If

            Dim dtDetails As DataTable = BuildReceivedDetailTable(dtItmDtlsactual)

            If dtDetails.Rows.Count = 0 Then
                ShowSubmitMessage("Receive not Successful. Contact Administrator.", False)
                Return
            End If

            Dim validationMessage As String = ValidateReceivedQuantities(dtDetails)

            If Not String.IsNullOrWhiteSpace(validationMessage) Then
                ShowSubmitMessage(validationMessage, False)
                Return
            End If

            Dim requestId As Integer = 0
            Integer.TryParse(hdnRequisitionId.Value, requestId)

            receiveId = obj.InsertRawMaterialReceipt(dispatchId, userInfo.userIDEntity, dtDetails)

            If receiveId > 0 Then
                txtreceiptNo.Text = receiveId.ToString()
                ShowSubmitMessage("Item has been received Successfully.", True)
            Else
                ShowSubmitMessage("Receive not Successful. Contact Administrator.", False)
            End If
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        Finally
            btnSubmit.Enabled = True
        End Try
    End Sub

    'Private Function BuildReceivedDetailTable(ByVal sourceTable As DataTable) As DataTable
    '    Dim dt As New DataTable()
    '    dt.Columns.Add("rawmaterial_code", GetType(String))
    '    dt.Columns.Add("sub_inventory", GetType(String))
    '    dt.Columns.Add("locator", GetType(String))
    '    dt.Columns.Add("received_qty", GetType(Decimal))
    '    dt.Columns.Add("good_qty", GetType(Decimal))
    '    dt.Columns.Add("short_qty", GetType(Decimal))
    '    dt.Columns.Add("damage_qty", GetType(Decimal))

    '    For Each dr As DataRow In sourceTable.Rows
    '        Dim qty As Decimal = ToDecimal(dr("received_qty"))
    '        If qty <= 0D Then
    '            Continue For
    '        End If

    '        Dim row As DataRow = dt.NewRow()
    '        row("rawmaterial_code") = Convert.ToString(dr("item_code"))
    '        Dim subInventory As String = Convert.ToString(dr("sub_inventory_code"))
    '        Dim locator As String = Convert.ToString(dr("locator_code"))
    '        row("sub_inventory") = If(String.IsNullOrWhiteSpace(subInventory), DefaultSubInventory, subInventory)
    '        row("locator") = If(String.IsNullOrWhiteSpace(locator), DefaultLocator, locator)
    '        row("received_qty") = qty

    '        row("good_qty") = ToDecimal(dr("Good_Qty"))
    '        row("short_qty") = ToDecimal(dr("Short_Qty"))
    '        row("damage_qty") = ToDecimal(dr("Damage_Qty"))

    '        dt.Rows.Add(row)
    '    Next

    '    dt.AcceptChanges()
    '    Return dt
    'End Function
    Private Function BuildReceivedDetailTable(ByVal sourceTable As DataTable) As DataTable

        Dim dt As New DataTable()

        dt.Columns.Add("rawmaterial_code", GetType(String))
        dt.Columns.Add("sub_inventory", GetType(String))
        dt.Columns.Add("locator", GetType(String))
        dt.Columns.Add("received_qty", GetType(Decimal))
        dt.Columns.Add("good_qty", GetType(Decimal))
        dt.Columns.Add("short_qty", GetType(Decimal))
        dt.Columns.Add("damage_qty", GetType(Decimal))

        For Each gridRow As GridViewRow In gvVendorRawMat.Rows

            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim hdnItemCode As HiddenField =
            CType(gridRow.FindControl("hdnItemCode"), HiddenField)

            Dim hdnSubInventory As HiddenField =
            CType(gridRow.FindControl("hdnsubinvemtory"), HiddenField)

            Dim hdnLocator As HiddenField =
            CType(gridRow.FindControl("hdnlocator"), HiddenField)

            Dim txtRecMatchQty As TextBox =
            CType(gridRow.FindControl("txtRecMatchQty"), TextBox)

            Dim txtGood As TextBox =
            CType(gridRow.FindControl("txtGood"), TextBox)

            Dim txtDamage As TextBox =
            CType(gridRow.FindControl("txtDamage"), TextBox)

            Dim txtShort As TextBox =
            CType(gridRow.FindControl("txtShort"), TextBox)

            Dim receivedQty As Decimal = ToDecimal(txtRecMatchQty.Text)
            Dim goodQty As Decimal = ToDecimal(txtGood.Text)
            Dim damageQty As Decimal = ToDecimal(txtDamage.Text)
            Dim shortQty As Decimal = ToDecimal(txtShort.Text)

            'Validation
            If goodQty + damageQty + shortQty <> receivedQty Then

                Dim rawMaterialCode As String = ""

                If hdnItemCode IsNot Nothing Then
                    rawMaterialCode = hdnItemCode.Value
                End If

                '    Throw New Exception(
                '    "For Raw Material " & rawMaterialCode &
                '    ", Good + Damage + Short must be equal to Received Qty. " &
                '    "Received Qty = " & receivedQty.ToString("0.##") &
                '    ", Good = " & goodQty.ToString("0.##") &
                '    ", Damage = " & damageQty.ToString("0.##") &
                '    ", Short = " & shortQty.ToString("0.##")
                ')

            End If

            Dim row As DataRow = dt.NewRow()

            row("rawmaterial_code") = hdnItemCode.Value

            row("sub_inventory") =
            If(String.IsNullOrWhiteSpace(hdnSubInventory.Value),
               DefaultSubInventory,
               hdnSubInventory.Value)

            row("locator") =
            If(String.IsNullOrWhiteSpace(hdnLocator.Value),
               DefaultLocator,
               hdnLocator.Value)

            row("received_qty") = receivedQty
            row("good_qty") = goodQty
            row("damage_qty") = damageQty
            row("short_qty") = shortQty

            dt.Rows.Add(row)

        Next

        dt.AcceptChanges()

        Return dt

    End Function
    Private Function ValidateReceivedQuantities(ByVal dtDetails As DataTable) As String

        For Each dr As DataRow In dtDetails.Rows
            Dim rawMaterialCode As String = Convert.ToString(dr("rawmaterial_code"))
            Dim receivedQty As Decimal = ToDecimal(dr("received_qty"))
            Dim goodQty As Decimal = ToDecimal(dr("good_qty"))
            Dim shortQty As Decimal = ToDecimal(dr("short_qty"))
            Dim damageQty As Decimal = ToDecimal(dr("damage_qty"))
            Dim totalQty As Decimal = goodQty + shortQty + damageQty
            If totalQty <> receivedQty Then
                'Return "For Raw Material " & rawMaterialCode &
                '   ", Good Qty + Short Qty + Damage Qty must be equal to Received Qty. " &
                '   "Received Qty: " & receivedQty.ToString("0.##") &
                '   ", Good: " & goodQty.ToString("0.##") &
                '   ", Short: " & shortQty.ToString("0.##") &
                '   ", Damage: " & damageQty.ToString("0.##") & "."
                Return "For Raw Material " & rawMaterialCode &
                   ", Good Qty + Short Qty + Damage Qty must be equal to Received Qty. "
            End If
        Next
        Return String.Empty
    End Function

    Private Sub ShowSubmitMessage(ByVal message As String, ByVal isSuccess As Boolean)
        lblErrorMessage.Text = ""
        If isSuccess Then
            RmActionPopup.ShowSuccess(Me, message, "BulkRawMaterialReceiptList.aspx")
        Else
            RmActionPopup.ShowError(Me, message)
        End If
    End Sub

    Protected Sub lbtnExit2_Click(sender As Object, e As EventArgs)
        If lblPopMessageShow.Text.Trim().ToLower().Contains("successfully") Then
            Response.Redirect("~/BulkRawMaterialReceiptList.aspx", False)
        Else
            mpSuccess.Hide()
        End If
    End Sub

    Private Function GetColumnValue(ByVal row As DataRow, ByVal ParamArray columnNames As String()) As String
        If row Is Nothing OrElse columnNames Is Nothing Then
            Return String.Empty
        End If

        For Each columnName As String In columnNames
            If row.Table.Columns.Contains(columnName) AndAlso Not IsDBNull(row(columnName)) Then
                Return Convert.ToString(row(columnName))
            End If
        Next

        Return String.Empty
    End Function

    Private Function GetFirstPositiveQty(ByVal row As DataRow, ByVal ParamArray columnNames As String()) As Decimal
        If row Is Nothing OrElse columnNames Is Nothing Then
            Return 0D
        End If

        Dim fallbackQty As Decimal = 0D
        Dim hasFallback As Boolean = False

        For Each columnName As String In columnNames
            If row.Table.Columns.Contains(columnName) AndAlso Not IsDBNull(row(columnName)) Then
                Dim qty As Decimal = ToDecimal(row(columnName))
                If qty > 0D Then
                    Return qty
                End If
                If Not hasFallback Then
                    fallbackQty = qty
                    hasFallback = True
                End If
            End If
        Next

        Return fallbackQty
    End Function

    Private Function ToDecimal(ByVal value As Object) As Decimal
        Dim result As Decimal = 0D
        If value Is Nothing OrElse IsDBNull(value) Then
            Return 0D
        End If
        Decimal.TryParse(Convert.ToString(value), result)
        Return result
    End Function

    Private Function FormatQty(ByVal value As Decimal) As String
        If value = Decimal.Truncate(value) Then
            Return value.ToString("0")
        End If
        Return value.ToString("0.##")
    End Function

    Private Function FormatDateValue(ByVal value As String) As String
        Dim parsedDate As DateTime
        If DateTime.TryParse(value, parsedDate) Then
            Return parsedDate.ToString("dd/MM/yyyy")
        End If
        Return value
    End Function

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/BulkRawMaterialReceiptList.aspx", False)
    End Sub

End Class
