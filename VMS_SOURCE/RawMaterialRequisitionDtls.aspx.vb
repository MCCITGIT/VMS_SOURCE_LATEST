Imports System.Data
Imports VMS.Web
Imports System.Data.SqlTypes
Imports System.Data.SqlClient

Partial Class RawMaterialRequisitionDtls
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#Region "Page Load Event Handler"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        btnSubmit.Attributes.Add("onclick", "return validateRawMaterialRequisitionSubmit();")
        imgbtnSearch.Attributes.Add("onclick", "return validateRawMaterialRequisitionSearch();")

        If (Not IsPostBack) Then
            PopulateUnit()
            PopulateVendor()

            Dim requestId As Integer = 0
            If Integer.TryParse(Convert.ToString(Request.QueryString("request_id")), requestId) AndAlso requestId > 0 Then
                BindEditData(requestId)
                'Else
                '    txtreqVendor.Text = userInfo.userFirstNameEntity + " " + userInfo.userLastNameEntity
            End If
        End If
    End Sub
#End Region

#Region "PopulateVendor"
    Public Sub PopulateVendor()
        Dim obj As New OPC_VendorClass()
        Dim ds As New DataSet()
        ds = obj.GetRawMaterialVendorList()

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub
#End Region

#Region "Bind Data"
    Private Sub BindData()
        Dim obj As New OPC_VendorClass()
        Dim ds As New DataSet()
        'ds = obj.GetVendorRawMatEditList(ddlVendor.SelectedValue.ToString())
        ds = obj.GetRawMaterial_Requesteditt(ddlUnit.SelectedValue, ddlVendor.SelectedValue.ToString())
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
            If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                gvVendorRawMat.DataSource = ds
                gvVendorRawMat.DataBind()
                btnSubmit.Visible = True
            Else
                gvVendorRawMat.DataSource = Nothing
                gvVendorRawMat.DataBind()
                btnSubmit.Visible = False
            End If
        End If
    End Sub

    Private Sub BindEditData(ByVal requestId As Integer)
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetRawMaterialRequesteditt(requestId)

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing OrElse ds.Tables(0).Rows.Count = 0 Then
            lblErrorMessage.Text = ""
            RmActionPopup.ShowError(Me, "Requisition details not found.")
            btnSubmit.Visible = False
            Return
        End If

        Dim sourceTable As DataTable = ds.Tables(0)
        Dim firstRow As DataRow = sourceTable.Rows(0)
        Dim status As String = String.Empty
        If ds.Tables(0).Rows(0)("approval_status") = "A" Then
            btnSubmit.Visible = False
        Else
            btnSubmit.Visible = True
        End If

        'txtreqVendor.Text =Convert.ToString(firstRow("vendor_name")).Trim()
        ddlUnit.SelectedValue = ds.Tables(0).Rows(0)("vendor_code").ToString()

        Dim rawMatVendorCode As String = Convert.ToString(firstRow("rawmat_vendor_code")).Trim()
        If rawMatVendorCode <> "" AndAlso ddlVendor.Items.FindByValue(rawMatVendorCode) IsNot Nothing Then
            ddlVendor.SelectedValue = rawMatVendorCode
        End If

        ddlVendor.Enabled = False
        imgbtnSearch.Visible = False

        Dim dtGrid As DataTable = BuildGridTableFromEditData(sourceTable)
        gvVendorRawMat.DataSource = dtGrid
        gvVendorRawMat.DataBind()

        'btnSubmit.Visible = True
        btnSubmit.Text = Constant.GeneralMessages.btnUpdate
    End Sub

    Private Function BuildGridTableFromEditData(ByVal sourceTable As DataTable) As DataTable
        Dim dtGrid As New DataTable()
        dtGrid.Columns.Add("id", GetType(String))
        dtGrid.Columns.Add("vendor_code", GetType(String))
        dtGrid.Columns.Add("vendor_name", GetType(String))
        dtGrid.Columns.Add("rawmat_code", GetType(String))
        dtGrid.Columns.Add("rawmat_name", GetType(String))
        dtGrid.Columns.Add("rate", GetType(String))
        dtGrid.Columns.Add("quantity", GetType(String))
        dtGrid.Columns.Add("delivery_date", GetType(String))
        dtGrid.Columns.Add("remarks", GetType(String))

        For Each dr As DataRow In sourceTable.Rows
            Dim gridRow As DataRow = dtGrid.NewRow()
            gridRow("id") = Convert.ToString(dr("request_id"))
            gridRow("vendor_code") = Convert.ToString(dr("vendor_code"))
            gridRow("vendor_name") = Convert.ToString(dr("rawmat_vendor_name"))
            gridRow("rawmat_code") = Convert.ToString(dr("rawmaterial_code"))
            gridRow("rawmat_name") = Convert.ToString(dr("rawmaterial_name"))
            gridRow("rate") = Convert.ToString(dr("rate"))
            gridRow("quantity") = FormatQuantityValue(dr("quantity"))
            gridRow("remarks") = Convert.ToString(dr("remarks"))

            If Not IsDBNull(dr("delivery_date")) Then
                gridRow("delivery_date") = Convert.ToDateTime(dr("delivery_date")).ToString("yyyy-MM-dd")
            Else
                gridRow("delivery_date") = String.Empty
            End If

            dtGrid.Rows.Add(gridRow)
        Next

        dtGrid.AcceptChanges()
        Return dtGrid
    End Function
#End Region

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs)
        If Not ValidateSearchInputs() Then
            Return
        End If

        BindData()
    End Sub

    Protected Sub gvVendorRawMat_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvVendorRawMat.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then
            Return
        End If

        Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
        If rowView Is Nothing Then
            Return
        End If

        Dim txtReqDate As TextBox = TryCast(e.Row.FindControl("txtReqDate"), TextBox)
        Dim txtQuantity As TextBox = TryCast(e.Row.FindControl("txtQuantity"), TextBox)
        Dim txtRemarks As TextBox = TryCast(e.Row.FindControl("txtRemarks"), TextBox)

        If txtQuantity IsNot Nothing AndAlso rowView.Row.Table.Columns.Contains("quantity") Then
            txtQuantity.Text = FormatQuantityValue(rowView("quantity"))
        End If

        If txtRemarks IsNot Nothing AndAlso rowView.Row.Table.Columns.Contains("remarks") Then
            txtRemarks.Text = Convert.ToString(rowView("remarks")).Trim()
        End If

        If txtReqDate IsNot Nothing Then
            Dim reqDateValue As String = String.Empty

            If rowView.Row.Table.Columns.Contains("delivery_date") AndAlso Not IsDBNull(rowView("delivery_date")) Then
                reqDateValue = Convert.ToDateTime(rowView("delivery_date")).ToString("yyyy-MM-dd")
            ElseIf rowView.Row.Table.Columns.Contains("req_date") AndAlso Not IsDBNull(rowView("req_date")) Then
                reqDateValue = Convert.ToDateTime(rowView("req_date")).ToString("yyyy-MM-dd")
            End If

            txtReqDate.Text = reqDateValue
        End If
    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        gvVendorRawMat.DataSource = Nothing
        gvVendorRawMat.DataBind()
        btnSubmit.Visible = False
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim obj As New OPC_VendorClass()
        Dim headerEntity As New RawMaterialRequisitionHeaderEntity()
        Dim dtDetails As DataTable
        Dim result As Integer

        Try
            lblErrorMessage.Text = String.Empty

            If Not ValidateSubmitInputs() Then
                Return
            End If

            dtDetails = BuildRequisitionDetailTable()

            headerEntity.VendorCode = ddlUnit.SelectedValue.ToString() 'userInfo.userIDEntity
            headerEntity.RawMaterialVendorCode = ddlVendor.SelectedValue.Trim()
            headerEntity.CreatedUser = userInfo.userIDEntity
            headerEntity.ActiveStatus = "Y"
            headerEntity.Trantype = 1

            If Not String.IsNullOrWhiteSpace(Request.QueryString("request_id")) Then
                Dim requestId As Integer = 0
                If Integer.TryParse(Request.QueryString("request_id"), requestId) AndAlso requestId > 0 Then
                    headerEntity.RequestId = requestId
                    headerEntity.Trantype = 2
                    headerEntity.ModifiedUser = userInfo.userIDEntity
                End If
            End If

            result = obj.InsertUpdateRawMaterialRequisition(headerEntity, dtDetails)

            If result > 0 Then
                lblErrorMessage.Text = ""
                If headerEntity.Trantype = 2 Then
                    Session("RmActionResultMsg") = "Requisition updated successfully."
                Else
                    Session("RmActionResultMsg") = "Requisition submitted successfully."
                End If
                Response.Redirect("~/RawMaterialRequisitionList.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
            Else
                lblErrorMessage.Text = ""
                RmActionPopup.ShowError(Me, "Unable to submit requisition. Please try again.")
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect(returnUrl)
        End Try
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Response.Redirect("~/RawMaterialRequisitionList.aspx", False)
    End Sub

    'Protected Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
    '    If Not String.IsNullOrWhiteSpace(Request.QueryString("request_id")) Then
    '        Response.Redirect("~/RawMaterialRequisitionDtls.aspx?request_id=" & Server.UrlEncode(Request.QueryString("request_id")), False)
    '    Else
    '        Response.Redirect("~/RawMaterialRequisitionDtls.aspx", False)
    '    End If
    'End Sub

    Private Function BuildRequisitionDetailTable() As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("rawmaterial_code", GetType(String))
        dt.Columns.Add("qty", GetType(Decimal))
        dt.Columns.Add("req_delivery_date", GetType(DateTime))
        dt.Columns.Add("remark", GetType(String))
        dt.Columns.Add("rate", GetType(Decimal))

        For Each gridRow As GridViewRow In gvVendorRawMat.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim txtQuantity As TextBox = TryCast(gridRow.FindControl("txtQuantity"), TextBox)
            Dim txtReqDate As TextBox = TryCast(gridRow.FindControl("txtReqDate"), TextBox)
            Dim txtRemarks As TextBox = TryCast(gridRow.FindControl("txtRemarks"), TextBox)
            Dim hdnRate As HiddenField = TryCast(gridRow.FindControl("hdnRate"), HiddenField)

            Dim qtyValue As Decimal = 0D
            If txtQuantity Is Nothing OrElse Not Decimal.TryParse(txtQuantity.Text.Trim(), qtyValue) OrElse qtyValue <= 0D Then
                Continue For
            End If

            Dim rawMatCode As String = Server.HtmlDecode(gridRow.Cells(1).Text).Trim()
            If String.IsNullOrWhiteSpace(rawMatCode) Then
                Continue For
            End If

            Dim rateValue As Decimal = 0D
            If hdnRate IsNot Nothing Then
                Decimal.TryParse(hdnRate.Value.Trim(), rateValue)
            End If

            Dim reqDate As Object = DBNull.Value
            Dim parsedDate As DateTime
            If txtReqDate IsNot Nothing AndAlso DateTime.TryParse(txtReqDate.Text.Trim(), parsedDate) Then
                reqDate = parsedDate
            End If

            Dim dr As DataRow = dt.NewRow()
            dr("rawmaterial_code") = rawMatCode
            dr("qty") = Math.Round(qtyValue, 2)
            dr("req_delivery_date") = reqDate
            dr("remark") = If(txtRemarks Is Nothing, String.Empty, txtRemarks.Text.Trim())
            dr("rate") = rateValue
            dt.Rows.Add(dr)
        Next

        dt.AcceptChanges()
        Return dt
    End Function

    Private Function FormatQuantityValue(ByVal value As Object) As String
        If value Is Nothing OrElse IsDBNull(value) Then
            Return String.Empty
        End If

        Dim qty As Decimal = 0D
        If Decimal.TryParse(Convert.ToString(value), qty) Then
            Return qty.ToString("0.00")
        End If

        Return Convert.ToString(value).Trim()
    End Function

#Region "Populate Unit"
    Private Sub PopulateUnit()
        Dim obj As New OPC_VendorClass()
        Dim UnitSet As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)

        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlUnit.DataSource = UnitSet.Tables(0)
            ddlUnit.DataTextField = "unit_name"
            ddlUnit.DataValueField = "unit_code"
            ddlUnit.DataBind()
            ddlUnit.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
        '    ddlUnit.SelectedValue = userInfo.userUnitEntity
        '    ddlUnit.Enabled = False
        'End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlUnit.SelectedValue = userInfo.userBranchEntity
            ddlUnit.Enabled = False
        End If
    End Sub
#End Region

    Private Function ValidateSearchInputs() As Boolean
        ClearInlineValidation()

        Dim isValid As Boolean = True

        If ddlUnit.SelectedIndex <= 0 OrElse String.IsNullOrWhiteSpace(ddlUnit.SelectedValue) Then
            AppendInlineValidation("Unit", "Please select Vendor Name.")
            isValid = False
        End If

        If ddlVendor.SelectedIndex <= 0 OrElse String.IsNullOrWhiteSpace(ddlVendor.SelectedValue) Then
            AppendInlineValidation("Vendor", "Please select RM Vendor.")
            isValid = False
        End If

        Return isValid
    End Function

    Private Function ValidateSubmitInputs() As Boolean
        ClearInlineValidation()

        Dim isValid As Boolean = True

        If ddlVendor.SelectedIndex <= 0 OrElse String.IsNullOrWhiteSpace(ddlVendor.SelectedValue) Then
            AppendInlineValidation("Vendor", "Please select RM Vendor.")
            isValid = False
        End If

        Dim dtDetails As DataTable = BuildRequisitionDetailTable()
        If dtDetails.Rows.Count = 0 Then
            AppendInlineValidation("Grid", "Please enter Quantity greater than 0 for at least one Raw Material.")
            isValid = False
        End If

        Return isValid
    End Function

    Private Sub ClearInlineValidation()
        ddlUnit.CssClass = "form-control select2"
        ddlVendor.CssClass = "form-control select2"
        valUnit.Text = String.Empty
        valVendor.Text = String.Empty
        valGrid.Text = String.Empty
    End Sub

    Private Sub AppendInlineValidation(ByVal fieldKey As String, ByVal message As String)
        Select Case fieldKey
            Case "Unit"
                ddlUnit.CssClass = "form-control select2 field-invalid"
                valUnit.Text = message
            Case "Vendor"
                ddlVendor.CssClass = "form-control select2 field-invalid"
                valVendor.Text = message
            Case "Grid"
                valGrid.Text = message
        End Select
    End Sub

    Private Sub ShowInlineValidation(ByVal fieldKey As String, ByVal message As String)
        ClearInlineValidation()
        AppendInlineValidation(fieldKey, message)
    End Sub
End Class
