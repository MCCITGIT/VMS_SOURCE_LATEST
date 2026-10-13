Imports System.Collections.Generic
Imports System.Data
Imports System.Globalization
Imports System.Linq
Imports System.Text
Imports System.Configuration
Imports VMS.Web
Imports System.Data.SqlClient

''' <summary>
''' Product Formulation Master (V2, 09-Oct-2026 - MUKESH BHAGAT).
''' Section 1 - one line per raw material of the SKU: consumption ratio (total 100 %) + price.
''' Section 2 - packaging cost per pack size: material lines + processing fee + labour charge + margin %
'''             (margin on SKU price + material + processing + labour). At least one pack is mandatory.
''' One Submit saves everything through [opc_sku_formulation_save], which always creates a NEW VERSION of
''' brand + vendor + SKU (old versions are kept). The SP returns Status 2 when nothing changed; the page also
''' blocks the submit on the client when the data equals the loaded snapshot.
''' ?id= = sf_id of the version to open (list always passes the current one).
''' </summary>
Partial Class Product_Formulation
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const GridTableKey As String = "VendorRawMatGridTable"
    Private Const PackHdrKey As String = "PackagingHdrTable"
    Private Const PackDtlKey As String = "PackagingDtlTable"
    Private Const SnapshotKey As String = "LoadedSnapshot"
    Private gridRatioTotal As Decimal = 0D
    Private gridSkuPrice As Decimal = 0D

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Not txtProductSearch.Enabled OrElse String.Equals(txtProductSearch.Attributes("readonly"), "readonly", StringComparison.OrdinalIgnoreCase) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "lockProductSearch", "syncProductResetButtonState();", True)
        End If
        hdnSnapshot.Value = Convert.ToString(ViewState(SnapshotKey))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        btnSubmit.Attributes.Add("onclick", "return validateSubmitAll();")
        btnAdd.Attributes.Add("onclick", "return validateAddRow();")

        If Not IsPostBack Then
            BrandDetailsListLoad()
            VendorDetailsListLoad()
            InitializeGridTable()
            InitializePackTables()
            ViewState(SnapshotKey) = ""
            Dim id As Integer = ParseInteger(Convert.ToString(Request.QueryString("id")))
            If id > 0 Then
                Binddata(id)
            Else
                BindRawMatGrid()
                BindPacks()
            End If
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#Region "autocomplete web methods"
    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function ProductSearch(ByVal prefixText As String) As String()
        Dim productDetails As List(Of String) = New List(Of String)()
        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 Then
            Return productDetails.ToArray()
        End If
        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetProduct(prefixText.Trim())
            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso Not ds.Tables(0) Is Nothing Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim productCode As String = Convert.ToString(dr("product_code")).Trim()
                    Dim productName As String = Convert.ToString(dr("product_name")).Trim()
                    Dim sku_code As String = If(dr.Table.Columns.Contains("sku_code"), Convert.ToString(dr("sku_code")).Trim(), String.Empty)
                    If productName <> "" AndAlso productCode <> "" Then
                        productDetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(productName, productCode & "|" & sku_code))
                    End If
                Next
            End If
        Catch ex As Exception
            ' Keep autocomplete resilient; return collected items.
        End Try
        Return productDetails.ToArray()
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function RawMaterialSearch(ByVal prefixText As String) As String()
        Dim rawMaterialDetails As List(Of String) = New List(Of String)()
        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 Then
            Return rawMaterialDetails.ToArray()
        End If
        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetRawMatList(prefixText.Trim())
            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso Not ds.Tables(0) Is Nothing Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim rawMaterialId As String = Convert.ToString(dr("Raw_Mat_Code")).Trim()
                    Dim rawMaterialName As String = Convert.ToString(dr("Raw_Mat_Name")).Trim()
                    If rawMaterialName <> "" AndAlso rawMaterialId <> "" Then
                        rawMaterialDetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(rawMaterialName, rawMaterialId))
                    End If
                Next
            End If
        Catch ex As Exception
            ' Keep autocomplete resilient; return whatever is already collected.
        End Try
        Return rawMaterialDetails.ToArray()
    End Function
#End Region

#Region "section 1 - raw material grid"
    Private Sub InitializeGridTable()
        Dim dt As DataTable = New DataTable()
        dt.Columns.Add(New DataColumn("brand_code", GetType(String)))
        dt.Columns.Add(New DataColumn("brand_name", GetType(String)))
        dt.Columns.Add(New DataColumn("vendor_code", GetType(String)))
        dt.Columns.Add(New DataColumn("vendor_name", GetType(String)))
        dt.Columns.Add(New DataColumn("product_code", GetType(String)))
        dt.Columns.Add(New DataColumn("product_name", GetType(String)))
        dt.Columns.Add(New DataColumn("rawmat_code", GetType(String)))
        dt.Columns.Add(New DataColumn("rawmat_name", GetType(String)))
        dt.Columns.Add(New DataColumn("ratio", GetType(String)))
        dt.Columns.Add(New DataColumn("unit", GetType(String)))
        dt.Columns.Add(New DataColumn("rate", GetType(String)))
        dt.Columns.Add(New DataColumn("matrix_id", GetType(String)))
        ViewState(GridTableKey) = dt
    End Sub

    Private Function GetGridTable() As DataTable
        Dim dt As DataTable = TryCast(ViewState(GridTableKey), DataTable)
        If dt Is Nothing Then
            InitializeGridTable()
            dt = TryCast(ViewState(GridTableKey), DataTable)
        End If
        Return dt
    End Function

    Private Sub BindRawMatGrid()
        gridRatioTotal = 0D
        gridSkuPrice = 0D
        Dim dt As DataTable = GetGridTable()
        gvVendorRawMat.DataSource = dt
        gvVendorRawMat.DataBind()
        btnSubmit.Visible = dt.Rows.Count > 0
        btnSubmit.Text = If(ParseInteger(hdnId.Value) > 0, "Submit for HO approval", "Submit for HO approval")
        hdnSkuPrice.Value = CalculateSkuPrice(dt).ToString("0.00", CultureInfo.InvariantCulture)
        lblSkuPriceInfo.Text = hdnSkuPrice.Value
        LockHeaderIfRowsExist(dt)
    End Sub

    ''' <summary>SKU price = Sum of (consumption ratio % x raw material price).</summary>
    Private Shared Function CalculateSkuPrice(ByVal dt As DataTable) As Decimal
        Dim total As Decimal = 0D
        For Each row As DataRow In dt.Rows
            total += ParseDecimal(Convert.ToString(row("ratio"))) / 100D * ParseDecimal(Convert.ToString(row("rate")))
        Next
        Return Math.Round(total, 2)
    End Function

    Protected ReadOnly Property SkuPriceText() As String
        Get
            Return ParseDecimal(hdnSkuPrice.Value).ToString("0.00", CultureInfo.InvariantCulture)
        End Get
    End Property

    Private Sub LockHeaderIfRowsExist(ByVal dt As DataTable)
        Dim locked As Boolean = dt.Rows.Count > 0 OrElse ParseInteger(hdnId.Value) > 0
        ddlBrand.Enabled = Not locked
        ddlvendor.Enabled = Not locked
        txtProductSearch.Enabled = Not locked
        If locked Then
            txtProductSearch.Attributes("readonly") = "readonly"
        Else
            txtProductSearch.Attributes.Remove("readonly")
        End If
    End Sub

    Protected Sub gvVendorRawMat_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvVendorRawMat.RowDataBound
        If e.Row.RowType = DataControlRowType.Header Then
            e.Row.TableSection = TableRowSection.TableHeader
        ElseIf e.Row.RowType = DataControlRowType.DataRow Then
            Dim txtRowRatio As TextBox = TryCast(e.Row.FindControl("txtRowRatio"), TextBox)
            Dim txtRowRate As TextBox = TryCast(e.Row.FindControl("txtRowRate"), TextBox)
            Dim ratio As Decimal = If(txtRowRatio Is Nothing, 0D, ParseDecimal(txtRowRatio.Text))
            Dim rate As Decimal = If(txtRowRate Is Nothing, 0D, ParseDecimal(txtRowRate.Text))
            gridRatioTotal += ratio
            gridSkuPrice += ratio / 100D * rate
            If txtRowRatio IsNot Nothing Then txtRowRatio.Text = ratio.ToString("0.##", CultureInfo.InvariantCulture)
            If txtRowRate IsNot Nothing Then txtRowRate.Text = rate.ToString("0.00", CultureInfo.InvariantCulture)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.TableSection = TableRowSection.TableFooter
            SetRatioFooterLabels(e.Row, gridRatioTotal, gridSkuPrice)
        End If
    End Sub

    Private Sub SetRatioFooterLabels(ByVal footerRow As GridViewRow, ByVal totalRatio As Decimal, ByVal skuPrice As Decimal)
        Dim lblRatioTotal As Label = TryCast(footerRow.FindControl("lblRatioTotal"), Label)
        Dim lblRatioStatus As Label = TryCast(footerRow.FindControl("lblRatioStatus"), Label)
        Dim lblSkuPrice As Label = TryCast(footerRow.FindControl("lblSkuPrice"), Label)
        If lblRatioTotal IsNot Nothing Then lblRatioTotal.Text = totalRatio.ToString("0.00") & "%"
        If lblRatioStatus IsNot Nothing Then
            If totalRatio > 100D Then
                lblRatioStatus.Text = "Exceed 100%" : lblRatioStatus.CssClass = "pf-status-bad"
            ElseIf totalRatio = 100D Then
                lblRatioStatus.Text = "= 100%" : lblRatioStatus.CssClass = "pf-status-ok"
            Else
                lblRatioStatus.Text = "Within 100%" : lblRatioStatus.CssClass = "pf-status-ok"
            End If
        End If
        If lblSkuPrice IsNot Nothing Then lblSkuPrice.Text = Math.Round(skuPrice, 2).ToString("0.00", CultureInfo.InvariantCulture)
    End Sub

    Private Function ValidateSubmitInputs() As Boolean
        ClearInlineValidation()
        Dim isValid As Boolean = True
        If ddlBrand.SelectedIndex <= 0 Then AppendInlineValidation("Brand", "Please select Brand.") : isValid = False
        If ddlvendor.SelectedIndex <= 0 Then AppendInlineValidation("Vendor", "Please select Vendor.") : isValid = False
        If String.IsNullOrWhiteSpace(hdnProductCode.Value) Then AppendInlineValidation("Product", "Please enter Product.") : isValid = False

        Dim dt As DataTable = GetGridTable()
        Dim totalRatio As Decimal = 0D
        For Each row As DataRow In dt.Rows
            Dim ratioValue As Decimal = ParseDecimal(Convert.ToString(row("ratio")))
            If ratioValue <= 0D Then AppendInlineValidation("Grid", "Please enter valid Consumption Ratio.") : Return False
            If ParseDecimal(Convert.ToString(row("rate"))) <= 0D Then AppendInlineValidation("Grid", "Please enter a valid Price greater than 0 for all raw materials.") : Return False
            totalRatio += ratioValue
        Next
        If dt.Rows.Count = 0 Then
            AppendInlineValidation("Grid", "Please enter at least one record in the grid.") : isValid = False
        ElseIf Math.Round(totalRatio, 2) <> 100D Then
            AppendInlineValidation("Grid", "Total Consumption Ratio should be equal 100%.") : isValid = False
        End If
        Return isValid
    End Function

    Private Function ValidateAddInputs() As Boolean
        ClearInlineValidation()
        Dim isValid As Boolean = True
        If ddlBrand.SelectedIndex <= 0 Then AppendInlineValidation("Brand", "Please select Brand.") : isValid = False
        If ddlvendor.SelectedIndex <= 0 Then AppendInlineValidation("Vendor", "Please select Vendor.") : isValid = False
        If String.IsNullOrWhiteSpace(hdnProductCode.Value) Then AppendInlineValidation("Product", "Please enter Product.") : isValid = False
        If String.IsNullOrWhiteSpace(txtSearchText.Text.Trim()) Then
            AppendInlineValidation("RawMaterial", "Please enter Raw Material.") : isValid = False
        ElseIf String.IsNullOrWhiteSpace(txtrawmatid.Value) Then
            AppendInlineValidation("RawMaterial", "Please select Raw Material from the list.") : isValid = False
        End If
        Dim ratio As Decimal = ParseDecimal(txtRatio.Text)
        If String.IsNullOrWhiteSpace(txtRatio.Text) OrElse ratio <= 0D Then
            AppendInlineValidation("Ratio", "Please enter Consumption Ratio.") : isValid = False
        ElseIf CurrentRatioTotal() + ratio > 100D Then
            AppendInlineValidation("Ratio", "Total Consumption Ratio should not be greater than 100%.") : isValid = False
        End If
        If ParseDecimal(txtRate.Text) <= 0D Then AppendInlineValidation("Rate", "Please enter a valid Price greater than 0.") : isValid = False
        Return isValid
    End Function

    Private Function CurrentRatioTotal() As Decimal
        Dim total As Decimal = 0D
        For Each row As DataRow In GetGridTable().Rows
            total += ParseDecimal(Convert.ToString(row("ratio")))
        Next
        Return Math.Round(total, 2)
    End Function

    Private Sub ClearInlineValidation()
        ddlBrand.CssClass = "form-control select2"
        ddlvendor.CssClass = "form-control select2"
        txtProductSearch.CssClass = "form-control"
        txtSearchText.CssClass = "form-control"
        txtRatio.CssClass = "form-control pf-num"
        txtRate.CssClass = "form-control pf-num"
        valBrand.Text = "" : valVendor.Text = "" : valProduct.Text = "" : valSearchText.Text = "" : valRatio.Text = "" : valRate.Text = "" : valGrid.Text = ""
    End Sub

    Private Sub AppendInlineValidation(ByVal fieldKey As String, ByVal message As String)
        Select Case fieldKey
            Case "Brand" : ddlBrand.CssClass = "form-control select2 field-invalid" : valBrand.Text = message
            Case "Vendor" : ddlvendor.CssClass = "form-control select2 field-invalid" : valVendor.Text = message
            Case "Product" : txtProductSearch.CssClass = "form-control field-invalid" : valProduct.Text = message
            Case "RawMaterial" : txtSearchText.CssClass = "form-control field-invalid" : valSearchText.Text = message
            Case "Ratio" : txtRatio.CssClass = "form-control pf-num field-invalid" : valRatio.Text = message
            Case "Rate" : txtRate.CssClass = "form-control pf-num field-invalid" : valRate.Text = message
            Case "Grid" : valGrid.Text = message
        End Select
    End Sub

    Private Sub ShowInlineValidation(ByVal fieldKey As String, ByVal message As String)
        ClearInlineValidation()
        AppendInlineValidation(fieldKey, message)
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        CapturePackInputs()
        If Not ValidateAddInputs() Then BindPacks() : Exit Sub

        Dim dt As DataTable = GetGridTable()
        Dim selectedRawMatCode As String = txtrawmatid.Value.Trim()
        For Each row As DataRow In dt.Rows
            If Convert.ToString(row("rawmat_code")).Trim().Equals(selectedRawMatCode, StringComparison.OrdinalIgnoreCase) Then
                ShowInlineValidation("RawMaterial", "Selected Raw Material already added.")
                BindPacks()
                Exit Sub
            End If
        Next

        Dim rawMatName As String = txtSearchText.Text.Trim()
        If rawMatName.Contains("(") Then rawMatName = rawMatName.Substring(0, rawMatName.LastIndexOf("("c)).Trim()

        Dim dr As DataRow = dt.NewRow()
        dr("brand_code") = ddlBrand.SelectedValue
        dr("brand_name") = ddlBrand.SelectedItem.Text
        dr("vendor_code") = ddlvendor.SelectedValue
        dr("vendor_name") = ddlvendor.SelectedItem.Text
        dr("product_code") = hdnProductCode.Value
        dr("product_name") = hdnProductName.Value
        dr("rawmat_code") = selectedRawMatCode
        dr("rawmat_name") = rawMatName
        dr("ratio") = ParseDecimal(txtRatio.Text).ToString("0.##", CultureInfo.InvariantCulture)
        dr("unit") = ""
        dr("rate") = ParseDecimal(txtRate.Text).ToString("0.00", CultureInfo.InvariantCulture)
        dr("matrix_id") = "0"
        dt.Rows.Add(dr)
        ViewState(GridTableKey) = dt

        BindRawMatGrid()
        BindPacks()
        ClearInlineValidation()
        ClearControl()
    End Sub

    Protected Sub gvVendorRawMat_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVendorRawMat.RowCommand
        If e.CommandName <> "DeleteRow" Then Exit Sub
        Dim rowIndex As Integer = 0
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), rowIndex) Then Exit Sub
        CapturePackInputs()
        Dim dt As DataTable = GetGridTable()
        If rowIndex < 0 OrElse rowIndex >= dt.Rows.Count Then Exit Sub
        dt.Rows.RemoveAt(rowIndex)
        dt.AcceptChanges()
        ViewState(GridTableKey) = dt
        BindRawMatGrid()
        BindPacks()
        lblErrorMessage.Text = ""
    End Sub

    Private Sub ClearControl()
        txtSearchText.Text = "" : txtrawmatid.Value = "" : txtRatio.Text = "" : txtRate.Text = "" : lblErrorMessage.Text = ""
    End Sub

    Private Sub BrandDetailsListLoad()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.BindBrandMasterList()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
            If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlBrand.DataSource = ds
                ddlBrand.DataTextField = "brand_name"
                ddlBrand.DataValueField = "brand_id"
                ddlBrand.DataBind()
            Else
                ddlBrand.DataSource = Nothing
                ddlBrand.DataBind()
            End If
            ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub

    Private Sub VendorDetailsListLoad()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
            If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlvendor.DataSource = ds
                ddlvendor.DataTextField = "unit_name"
                ddlvendor.DataValueField = "unit_code"
                ddlvendor.DataBind()
            Else
                ddlvendor.DataSource = Nothing
                ddlvendor.DataBind()
            End If
            ddlvendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub

    ''' <summary>One submit: raw materials + every pack -> [opc_sku_formulation_save] (new version).</summary>
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Try
            CapturePackInputs()
            If Not ValidateSubmitInputs() Then BindPacks() : Exit Sub
            Dim packError As String = ValidatePacks()
            If packError <> "" Then valPack.Text = packError : BindPacks() : Exit Sub

            ' no-change guard (server side; the SP checks again)
            If ViewState(SnapshotKey) IsNot Nothing AndAlso Convert.ToString(ViewState(SnapshotKey)) <> "" AndAlso Convert.ToString(ViewState(SnapshotKey)) = BuildSnapshot() Then
                RmActionPopup.ShowError(Me, "No changes to save - this formulation and packaging cost is identical to what is already recorded.")
                BindPacks()
                Exit Sub
            End If

            Dim grid As DataTable = GetGridTable()
            Dim dtl As DataTable = OPC_VendorClass.NewSkuFormulationDtlTable()
            Dim srl As Integer = 0
            For Each row As DataRow In grid.Rows
                srl += 1
                dtl.Rows.Add(srl, Convert.ToString(row("rawmat_code")).Trim(), ParseDecimal(Convert.ToString(row("ratio"))), ParseDecimal(Convert.ToString(row("rate"))), DBNull.Value)
            Next

            Dim packs As DataTable = OPC_VendorClass.NewPackagingPackTable()
            Dim lines As DataTable = OPC_VendorClass.NewPackagingLineTable()
            For Each h As DataRow In PackHdr().Rows
                Dim key As Integer = Convert.ToInt32(h("pack_key"))
                packs.Rows.Add(key, Convert.ToString(h("pack_size")).Trim(), ParseDecimal(Convert.ToString(h("processing_fee"))), ParseDecimal(Convert.ToString(h("labour_charge"))), ParseDecimal(Convert.ToString(h("margin_pct"))))
                Dim lsrl As Integer = 0
                For Each l As DataRow In PackDtl().Select("pack_key = " & key, "srl, line_key")
                    Dim name As String = Convert.ToString(l("cost_name")).Trim()
                    Dim amtText As String = Convert.ToString(l("amount")).Trim()
                    If name = "" AndAlso amtText = "" Then Continue For      ' blank line ignored
                    lsrl += 1
                    lines.Rows.Add(key, lsrl, name, ParseDecimal(amtText))
                Next
            Next

            ' who is submitting: HO revising the vendor's proposal (goes to the vendor) or the vendor (goes to HO)
            Dim hoRevising As Boolean = Convert.ToString(ViewState("ReviseMode")) = "Y" AndAlso IsHoUser()
            If hoRevising AndAlso String.IsNullOrWhiteSpace(txtHoRemarks.Text) Then
                pnlApproval.Visible = True
                valHoRemarks.Text = "Please write the reason / negotiated price for the vendor before sending the revised rate."
                BindPacks()
                Exit Sub
            End If

            Dim obj As New OPC_VendorClass()
            Dim result As OPC_VendorClass.SkuFormulationSaveResult =
                obj.SaveSkuFormulation(ddlBrand.SelectedValue.Trim(), ddlvendor.SelectedValue.Trim(), hdnProductCode.Value.Trim(), txtRemarks.Text, dtl, packs, lines, userInfo.userIDEntity,
                                       If(hoRevising, "HO", "VENDOR"), If(hoRevising, txtHoRemarks.Text, ""))

            Select Case result.Status
                Case 1
                    ClearInlineValidation()
                    ViewState("ReviseMode") = Nothing
                    Dim mailNote As String = SendNegotiationMail(result.HeaderId, result.Cycle, result.Revision, hoRevising, If(hoRevising, txtHoRemarks.Text, ""))
                    RmActionPopup.ShowSuccess(Me, "Submitted as cycle " & result.Cycle & " / revision " & result.Revision &
                                              If(mailNote = "", If(hoRevising, " and sent to the vendor for acceptance.", " and sent to HO for approval."), ". " & mailNote), "Product_Formulation.aspx?id=" & result.HeaderId)
                Case 2
                    RmActionPopup.ShowError(Me, result.Message)
                Case Else
                    valPack.Text = If(result.Message = "", "Something went wrong. Try again.", result.Message)
            End Select
            BindPacks()
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    ''' <summary>Loads one version (sf_id) through [opc_sku_formulation_get] into both sections and freezes the snapshot.</summary>
    Private Sub Binddata(ByVal sfId As Integer)
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetSkuFormulation(sfId)
        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            BindRawMatGrid() : BindPacks()
            valGrid.Text = "Formulation not found."
            Exit Sub
        End If

        Dim h As DataRow = ds.Tables(0).Rows(0)
        hdnId.Value = Convert.ToString(h("sf_id"))
        Dim brandCode As String = Convert.ToString(h("sf_brand_code")).Trim()
        Dim vendorCode As String = Convert.ToString(h("sf_vendor_code")).Trim()
        If ddlBrand.Items.FindByValue(brandCode) IsNot Nothing Then ddlBrand.SelectedValue = brandCode
        If ddlvendor.Items.FindByValue(vendorCode) IsNot Nothing Then ddlvendor.SelectedValue = vendorCode
        hdnProductCode.Value = Convert.ToString(h("sf_product_code")).Trim()
        hdnProductName.Value = Convert.ToString(h("product_name")).Trim()
        txtProductSearch.Text = hdnProductCode.Value & "-" & hdnProductName.Value
        Dim status As String = If(h.Table.Columns.Contains("sf_status"), Convert.ToString(h("sf_status")).Trim().ToUpperInvariant(), "APPROVED")
        Dim hoRemarks As String = If(h.Table.Columns.Contains("sf_ho_remarks"), Convert.ToString(h("sf_ho_remarks")).Trim(), "")
        Dim approvedBy As String = If(h.Table.Columns.Contains("sf_approved_by"), Convert.ToString(h("sf_approved_by")).Trim(), "")
        Dim releaseNo As Integer = If(h.Table.Columns.Contains("sf_release_no") AndAlso Not IsDBNull(h("sf_release_no")), Convert.ToInt32(h("sf_release_no")), 0)
        Dim cycleNo As Integer = If(h.Table.Columns.Contains("sf_cycle_no"), ParseInteger(Convert.ToString(h("sf_cycle_no"))), 0)
        Dim revision As Integer = If(h.Table.Columns.Contains("sf_revision"), ParseInteger(Convert.ToString(h("sf_revision"))), 0)
        Dim isLatest As Boolean = Convert.ToString(h("sf_is_current")) = "Y"
        Dim activeId As Integer = If(h.Table.Columns.Contains("active_sf_id"), ParseInteger(Convert.ToString(h("active_sf_id"))), 0)
        Dim latestId As Integer = If(h.Table.Columns.Contains("latest_sf_id"), ParseInteger(Convert.ToString(h("latest_sf_id"))), 0)
        If releaseNo > 0 Then
            lblVersionInfo.Text = "Release " & releaseNo & If(status = "APPROVED", " - ACTIVE since " & Convert.ToString(h("sf_valid_from")), " - INACTIVE (valid " & Convert.ToString(h("sf_valid_from")) & " to " & Convert.ToString(h("sf_valid_to")) & ")") &
                If(approvedBy <> "", ", approved by " & approvedBy, "")
        Else
            lblVersionInfo.Text = "Cycle " & cycleNo & " / Revision " & revision & " - " & StatusText(status, approvedBy)
        End If
        txtRemarks.Text = ""

        Dim dtGrid As DataTable = GetGridTable()
        dtGrid.Rows.Clear()
        If ds.Tables.Count > 1 Then
            For Each src As DataRow In ds.Tables(1).Rows
                Dim dr As DataRow = dtGrid.NewRow()
                dr("brand_code") = brandCode : dr("brand_name") = Convert.ToString(h("brand_name"))
                dr("vendor_code") = vendorCode : dr("vendor_name") = Convert.ToString(h("vendor_name"))
                dr("product_code") = hdnProductCode.Value : dr("product_name") = hdnProductName.Value
                dr("rawmat_code") = Convert.ToString(src("sfd_rawmat_code")).Trim()
                dr("rawmat_name") = Convert.ToString(src("rawmat_name"))
                dr("ratio") = ParseDecimal(Convert.ToString(src("sfd_ratio"))).ToString("0.##", CultureInfo.InvariantCulture)
                dr("unit") = Convert.ToString(src("sfd_uom"))
                dr("rate") = ParseDecimal(Convert.ToString(src("sfd_price"))).ToString("0.00", CultureInfo.InvariantCulture)
                dr("matrix_id") = "0"
                dtGrid.Rows.Add(dr)
            Next
        End If
        ViewState(GridTableKey) = dtGrid
        BindRawMatGrid()

        InitializePackTables()
        Dim hdr As DataTable = PackHdr()
        Dim dtl As DataTable = PackDtl()
        Dim keyByPchId As New Dictionary(Of Integer, Integer)()
        If ds.Tables.Count > 2 Then
            For Each r As DataRow In ds.Tables(2).Rows
                Dim key As Integer = NextKey(hdr, "pack_key")
                hdr.Rows.Add(key, ParseInteger(Convert.ToString(r("pch_id"))), Convert.ToString(r("pch_pack_size")).Trim(),
                             ParseDecimal(Convert.ToString(r("pch_processing_fee"))).ToString("0.00", CultureInfo.InvariantCulture),
                             ParseDecimal(Convert.ToString(r("pch_labour_charge"))).ToString("0.00", CultureInfo.InvariantCulture),
                             ParseDecimal(Convert.ToString(r("pch_margin_pct"))).ToString("0.00", CultureInfo.InvariantCulture))
                keyByPchId(ParseInteger(Convert.ToString(r("pch_id")))) = key
            Next
        End If
        If ds.Tables.Count > 3 Then
            For Each r As DataRow In ds.Tables(3).Rows
                Dim pchId As Integer = ParseInteger(Convert.ToString(r("pcd_hdr_id")))
                If Not keyByPchId.ContainsKey(pchId) Then Continue For
                dtl.Rows.Add(NextKey(dtl, "line_key"), keyByPchId(pchId), ParseInteger(Convert.ToString(r("pcd_id"))), Convert.ToString(r("pcd_cost_name")).Trim(),
                             ParseDecimal(Convert.ToString(r("pcd_amount"))).ToString("0.00", CultureInfo.InvariantCulture), ParseInteger(Convert.ToString(r("pcd_srl"))))
            Next
        End If
        ViewState(PackHdrKey) = hdr
        ViewState(PackDtlKey) = dtl
        BindPacks()

        ' after both sections are bound: banner, HO panel, and who may edit this row
        ApplyApprovalState(status, hoRemarks, releaseNo, isLatest, sfId, activeId, latestId)
        ViewState(SnapshotKey) = BuildSnapshot()
    End Sub

    ''' <summary>Canonical text of everything that is saved - compared against the loaded version to block "no change" submits.
    ''' Must stay in sync with buildSnapshot() in the page script.</summary>
    Private Function BuildSnapshot() As String
        Dim sb As New StringBuilder()
        For Each r As DataRow In GetGridTable().Rows
            sb.Append(Convert.ToString(r("rawmat_code")).Trim()).Append("|").Append(ParseDecimal(Convert.ToString(r("ratio"))).ToString("0.00", CultureInfo.InvariantCulture)).Append("|") _
              .Append(ParseDecimal(Convert.ToString(r("rate"))).ToString("0.00", CultureInfo.InvariantCulture)).Append(";")
        Next
        sb.Append("#")
        For Each h As DataRow In PackHdr().Select("", "pack_key")
            sb.Append(Convert.ToString(h("pack_size")).Trim()).Append("|").Append(ParseDecimal(Convert.ToString(h("processing_fee"))).ToString("0.00", CultureInfo.InvariantCulture)).Append("|") _
              .Append(ParseDecimal(Convert.ToString(h("labour_charge"))).ToString("0.00", CultureInfo.InvariantCulture)).Append("|").Append(ParseDecimal(Convert.ToString(h("margin_pct"))).ToString("0.00", CultureInfo.InvariantCulture)).Append("{")
            For Each l As DataRow In PackDtl().Select("pack_key = " & Convert.ToInt32(h("pack_key")), "srl, line_key")
                Dim name As String = Convert.ToString(l("cost_name")).Trim()
                Dim amt As String = Convert.ToString(l("amount")).Trim()
                If name = "" AndAlso amt = "" Then Continue For
                sb.Append(name).Append("|").Append(ParseDecimal(amt).ToString("0.00", CultureInfo.InvariantCulture)).Append(",")
            Next
            sb.Append("};")
        Next
        Return sb.ToString()
    End Function

    Protected Sub btnCancel_Click1(sender As Object, e As EventArgs)
        Response.Redirect("~/FormulationMstrList.aspx")
    End Sub
#End Region

#Region "HO approval + mail"
    ''' <summary>HO side = HO groups and SYSADMIN. Everyone else is the vendor side: only they see
    ''' "Submit revised version", "Propose change", "Resubmit" and "Accept revised rate".
    ''' To test the vendor side, log in with the unit (vendor) user.</summary>
    Private Function IsHoUser() As Boolean
        Dim g As String = Convert.ToString(userInfo.userGroupCodeEntity)
        Return g = Constant.UserFormAccess.HO OrElse g = Constant.UserFormAccess.HOMARKETING OrElse g = Constant.UserFormAccess.HOACCOUNTS OrElse g = Constant.UserFormAccess.SYSADMIN
    End Function

    Private Shared Function StatusText(ByVal status As String, ByVal approvedBy As String) As String
        Select Case status
            Case "APPROVED" : Return "APPROVED" & If(approvedBy <> "", " by " & approvedBy, "")
            Case "REJECTED" : Return "REJECTED" & If(approvedBy <> "", " by " & approvedBy, "")
            Case "PENDING_VENDOR" : Return "WAITING FOR VENDOR (HO revised the rate)"
            Case "SUPERSEDED" : Return "SUPERSEDED (a newer revision was submitted)"
            Case "INACTIVE" : Return "INACTIVE (replaced by a newer release)"
            Case Else : Return "PENDING HO APPROVAL"
        End Select
    End Function

    ''' <summary>Status banner, HO approve/reject panel, and who may edit:
    ''' vendor edits only the newest revision (PENDING / REJECTED) or proposes a change on the active release;
    ''' old releases / superseded revisions are read-only with links to the active release and the latest revision;
    ''' HO (other than SYSADMIN) never edits.</summary>
    Private Sub ApplyApprovalState(ByVal status As String, ByVal hoRemarks As String, ByVal releaseNo As Integer, ByVal isLatest As Boolean, ByVal sfId As Integer, ByVal activeId As Integer, ByVal latestId As Integer)
        pnlHoRemarks.Visible = hoRemarks <> ""
        If hoRemarks <> "" Then
            lblHoRemarksTitle.Text = If(status = "REJECTED", "HO rejected this revision - ", If(status = "PENDING_VENDOR", "HO revised the rate - ", "HO remarks - "))
            lblHoRemarks.Text = Server.HtmlEncode(hoRemarks)
            pnlHoRemarks.Style("background") = If(status = "REJECTED", "#f8d7da", If(status = "PENDING_VENDOR", "#e8f7fa", "#d4edda"))
            pnlHoRemarks.Style("color") = If(status = "REJECTED", "#721c24", If(status = "PENDING_VENDOR", "#0c5460", "#155724"))
        End If
        Dim reviseMode As Boolean = Convert.ToString(ViewState("ReviseMode")) = "Y"
        Dim hoOnly As Boolean = IsHoUser()            ' HO side (HO groups + SYSADMIN): no vendor editing, no vendor buttons
        pnlApproval.Visible = IsHoUser() AndAlso status = "PENDING" AndAlso isLatest
        btnRevise.Visible = pnlApproval.Visible AndAlso Not reviseMode
        btnApprove.Visible = pnlApproval.Visible AndAlso Not reviseMode
        btnReject.Visible = pnlApproval.Visible AndAlso Not reviseMode
        lblReviseNote.Text = If(reviseMode, "Revise the ratios / prices / packaging above, write the reason in the remarks, then press 'Send revised rate to vendor'.", "")
        pnlVendorAccept.Visible = status = "PENDING_VENDOR" AndAlso isLatest AndAlso Not hoOnly
        valHoRemarks.Text = ""

        ' navigation links to the other relevant rows of this SKU
        Dim links As New StringBuilder()
        If activeId > 0 AndAlso activeId <> sfId Then links.Append("<a href='Product_Formulation.aspx?id=" & activeId & "'>Open active release</a>&nbsp;&nbsp;")
        If latestId > 0 AndAlso latestId <> sfId Then links.Append("<a href='Product_Formulation.aspx?id=" & latestId & "'>Open latest revision</a>&nbsp;&nbsp;")
        links.Append("<a href='Product_Rate_Approval.aspx?id=" & sfId & "'><i class='fas fa-history'></i> Negotiation history</a>")
        litLinks.Text = links.ToString()

        ' who may edit: a read-only row shows the grid/packs but no entry controls
        Dim editable As Boolean
        btnPropose.Visible = False
        If status = "APPROVED" AndAlso releaseNo > 0 Then
            ' active release: read-only until the vendor presses "Propose change" (then a new negotiation cycle starts on submit)
            Dim proposeMode As Boolean = Convert.ToString(ViewState("ProposeMode")) = "Y"
            editable = isLatest AndAlso proposeMode
            btnPropose.Visible = isLatest AndAlso Not proposeMode AndAlso Not IsHoUser()
            btnSubmit.Text = "Submit change for HO approval"
        ElseIf status = "PENDING" Then
            ' vendor may still replace their own proposal; HO edits only after "Revise rate"
            editable = isLatest AndAlso (reviseMode OrElse Not hoOnly)
            btnSubmit.Text = If(reviseMode, "Send revised rate to vendor", "Submit revised version")
        ElseIf status = "PENDING_VENDOR" Then
            ' HO's counter-offer: vendor accepts (panel) or edits and counters; HO waits
            editable = isLatest AndAlso Not hoOnly
            btnSubmit.Text = "Submit counter-proposal to HO"
        ElseIf status = "REJECTED" Then
            editable = isLatest AndAlso Not hoOnly
            btnSubmit.Text = "Resubmit for HO approval"
        Else
            editable = False                        ' INACTIVE release / SUPERSEDED revision: history only
        End If
        If hoOnly AndAlso Not reviseMode Then editable = False
        SetEditable(editable)
        If Not editable Then
            lblReadOnlyNote.Text = If(status = "INACTIVE" OrElse status = "SUPERSEDED", "This is a historical record and cannot be changed.",
                                   If(Not isLatest, "A newer revision exists - open it to make changes.",
                                   If(btnPropose.Visible, "Approved and in force. Press 'Propose change' to start a new negotiation.",
                                   If(status = "PENDING_VENDOR", "Waiting for the vendor to accept or counter the revised rate.", "Read-only view."))))
        Else
            lblReadOnlyNote.Text = ""
        End If
    End Sub

    Private Sub SetEditable(ByVal editable As Boolean)
        btnSubmit.Visible = editable AndAlso GetGridTable().Rows.Count > 0
        btnAdd.Visible = editable
        btnAddPack.Visible = editable
        txtPackSize.Visible = editable
        txtSearchText.Enabled = editable : txtRatio.Enabled = editable : txtRate.Enabled = editable
        txtRemarks.Enabled = editable
        ' row delete buttons and pack inputs
        For Each row As GridViewRow In gvVendorRawMat.Rows
            Dim b As LinkButton = TryCast(row.FindControl("btnDeleteRow"), LinkButton)
            If b IsNot Nothing Then b.Visible = editable
            For Each id As String In New String() {"txtRowRatio", "txtRowRate"}
                Dim t As TextBox = TryCast(row.FindControl(id), TextBox)
                If t IsNot Nothing Then t.ReadOnly = Not editable
            Next
        Next
        For Each item As RepeaterItem In rptPack.Items
            For Each id As String In New String() {"btnRemovePack", "btnAddLine", "txtNewCostName", "txtNewAmount"}
                Dim c As Control = item.FindControl(id)
                If c IsNot Nothing Then c.Visible = editable
            Next
            For Each id As String In New String() {"txtProcessing", "txtLabour", "txtMarginPct"}
                Dim t As TextBox = TryCast(item.FindControl(id), TextBox)
                If t IsNot Nothing Then t.ReadOnly = Not editable
            Next
            Dim rptLines As Repeater = CType(item.FindControl("rptLines"), Repeater)
            For Each li As RepeaterItem In rptLines.Items
                Dim r As Control = li.FindControl("btnRemoveLine")
                If r IsNot Nothing Then r.Visible = editable
                For Each id As String In New String() {"txtCostName", "txtAmount"}
                    Dim t As TextBox = TryCast(li.FindControl(id), TextBox)
                    If t IsNot Nothing Then t.ReadOnly = Not editable
                Next
            Next
        Next
    End Sub

    ''' <summary>Unlocks an active release for editing; the next Submit opens a new negotiation cycle.</summary>
    Protected Sub btnPropose_Click(sender As Object, e As EventArgs)
        ViewState("ProposeMode") = "Y"
        Binddata(ParseInteger(hdnId.Value))
    End Sub

    Protected Sub btnApprove_Click(sender As Object, e As EventArgs)
        Decide("A", "HO")
    End Sub

    Protected Sub btnReject_Click(sender As Object, e As EventArgs)
        Decide("R", "HO")
    End Sub

    ''' <summary>HO: unlock the vendor's pending proposal for editing; the next Submit sends it to the vendor as a counter-offer.</summary>
    Protected Sub btnRevise_Click(sender As Object, e As EventArgs)
        ViewState("ReviseMode") = "Y"
        Dim remarks As String = txtHoRemarks.Text
        Binddata(ParseInteger(hdnId.Value))
        txtHoRemarks.Text = remarks
    End Sub

    ''' <summary>Vendor: accept HO's revised rate -> approved directly (HO proposed it, no second approval).</summary>
    Protected Sub btnAccept_Click(sender As Object, e As EventArgs)
        Decide("A", "VENDOR")
    End Sub

    Private Sub Decide(ByVal action As String, ByVal role As String)
        Dim sfId As Integer = ParseInteger(hdnId.Value)
        If sfId <= 0 Then Exit Sub
        If role = "HO" AndAlso Not IsHoUser() Then Exit Sub
        If action = "R" AndAlso String.IsNullOrWhiteSpace(txtHoRemarks.Text) Then
            CapturePackInputs() : BindPacks()
            pnlApproval.Visible = True
            valHoRemarks.Text = "Please enter the remarks / negotiated price before rejecting."
            Exit Sub
        End If
        Dim obj As New OPC_VendorClass()
        Dim err As String = obj.ApproveSkuFormulation(sfId, action, If(role = "HO", txtHoRemarks.Text, txtRemarks.Text), userInfo.userIDEntity, role)
        If err <> "" Then
            CapturePackInputs() : BindPacks()
            If role = "HO" Then pnlApproval.Visible = True : valHoRemarks.Text = err Else valPack.Text = err
            Exit Sub
        End If
        Dim msg As String
        If role = "VENDOR" Then
            msg = "Revised rate accepted - the formulation is approved and now in force."
        ElseIf action = "A" Then
            msg = "Formulation approved."
        Else
            msg = "Formulation rejected. The vendor will see your remarks when they open it."
        End If
        RmActionPopup.ShowSuccess(Me, msg, "Product_Formulation.aspx?id=" & sfId)
    End Sub

    ''' <summary>Mail to HO after a version is saved: header, raw materials with ratio/price, packs and a link.
    ''' Recipients come from SP [opc_sku_formulation_ho_email] (TOAddr/CCAddr/BCCAddr), the same way as Indent_HO_Email.</summary>
    ''' <returns>"" when the mail API accepted the mail, otherwise a short reason shown in the save popup (the save itself is never undone).</returns>
    Private Function SendNegotiationMail(ByVal sfId As Integer, ByVal cycle As Integer, ByVal revision As Integer, ByVal toVendor As Boolean, ByVal hoRemarks As String) As String
        Dim who As String = If(toVendor, "Vendor", "HO")
        Dim toAddress As String = "", ccAddress As String = "", bccAddress As String = ""
        Try
            Dim dsMail As DataSet = If(toVendor, New OPC_VendorClass().GetSkuFormulationVendorEmail(ddlvendor.SelectedValue.Trim()), New OPC_VendorClass().GetSkuFormulationHoEmail())
            If dsMail IsNot Nothing AndAlso dsMail.Tables.Count > 0 AndAlso dsMail.Tables(0).Rows.Count > 0 Then
                toAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("TOAddr")).Trim()
                ccAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("CCAddr")).Trim()
                bccAddress = Convert.ToString(dsMail.Tables(0).Rows(0)("BCCAddr")).Trim()
            End If
        Catch ex As Exception
            Return who & " mail NOT sent - recipient lookup failed (" & ex.Message & ")"
        End Try
        If toAddress = "" Then Return who & " mail NOT sent - no TOAddr returned"
        Try
            Dim sb As New StringBuilder()
            Dim link As String = Request.Url.GetLeftPart(UriPartial.Authority) & ResolveUrl("~/Product_Formulation.aspx?id=" & sfId)
            Dim td As String = "style='border:1px solid #999;padding:4px 8px;'"
            If toVendor Then
                sb.Append("<p>Dear Vendor,</p><p>HO has reviewed your SKU formulation and revised the rate. Please open it in VMS and either <b>accept</b> the revised rate or submit a counter-proposal.</p>")
                sb.Append("<p style='color:#0c5460;'><b>HO remarks:</b> " & Server.HtmlEncode(hoRemarks) & "</p>")
            Else
                sb.Append("<p>Dear HO team,</p><p>A SKU formulation has been submitted and needs your approval.</p>")
            End If
            sb.Append("<table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr><td " & td & "><b>Brand</b></td><td " & td & ">" & Server.HtmlEncode(ddlBrand.SelectedItem.Text) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>Vendor</b></td><td " & td & ">" & Server.HtmlEncode(ddlvendor.SelectedItem.Text) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>SKU</b></td><td " & td & ">" & Server.HtmlEncode(hdnProductCode.Value & " - " & hdnProductName.Value) & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>Negotiation</b></td><td " & td & ">Cycle " & cycle & " / Revision " & revision & If(revision > 1, " (resubmission)", " (new)") & "</td></tr>")
            sb.Append("<tr><td " & td & "><b>Submitted by</b></td><td " & td & ">" & Server.HtmlEncode(userInfo.userIDEntity) & " on " & DateTime.Now.ToString("dd/MM/yyyy HH:mm") & "</td></tr>")
            If txtRemarks.Text.Trim() <> "" Then sb.Append("<tr><td " & td & "><b>Vendor remarks</b></td><td " & td & ">" & Server.HtmlEncode(txtRemarks.Text.Trim()) & "</td></tr>")
            sb.Append("</table><br/>")

            sb.Append("<b>Raw materials</b><table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr style='background:#375973;color:#fff;'><th " & td & ">Raw material</th><th " & td & ">Ratio %</th><th " & td & ">Price</th><th " & td & ">Amount</th></tr>")
            Dim skuPrice As Decimal = 0D
            For Each r As DataRow In GetGridTable().Rows
                Dim ratio As Decimal = ParseDecimal(Convert.ToString(r("ratio"))), price As Decimal = ParseDecimal(Convert.ToString(r("rate")))
                Dim amt As Decimal = Math.Round(ratio / 100D * price, 2) : skuPrice += amt
                sb.Append("<tr><td " & td & ">" & Server.HtmlEncode(Convert.ToString(r("rawmat_name"))) & " (" & Server.HtmlEncode(Convert.ToString(r("rawmat_code"))) & ")</td><td " & td & " align='right'>" & ratio.ToString("0.00") & "</td><td " & td & " align='right'>" & price.ToString("0.00") & "</td><td " & td & " align='right'>" & amt.ToString("0.00") & "</td></tr>")
            Next
            sb.Append("<tr><td " & td & " colspan='3' align='right'><b>SKU price</b></td><td " & td & " align='right'><b>" & skuPrice.ToString("0.00") & "</b></td></tr></table><br/>")

            sb.Append("<b>Packaging cost</b><table style='border-collapse:collapse;font-family:Segoe UI,Arial;font-size:13px;'>")
            sb.Append("<tr style='background:#375973;color:#fff;'><th " & td & ">Pack size</th><th " & td & ">Material lines</th><th " & td & ">Processing</th><th " & td & ">Labour</th><th " & td & ">Margin %</th><th " & td & ">Total</th></tr>")
            For Each h As DataRow In PackHdr().Select("", "pack_key")
                Dim key As Integer = Convert.ToInt32(h("pack_key"))
                Dim material As Decimal = 0D
                Dim lines As New List(Of String)()
                For Each l As DataRow In PackDtl().Select("pack_key = " & key, "srl, line_key")
                    Dim name As String = Convert.ToString(l("cost_name")).Trim()
                    If name = "" Then Continue For
                    Dim amt As Decimal = ParseDecimal(Convert.ToString(l("amount")))
                    material += amt
                    lines.Add(Server.HtmlEncode(name) & " " & amt.ToString("0.00"))
                Next
                Dim proc As Decimal = ParseDecimal(Convert.ToString(h("processing_fee"))), lab As Decimal = ParseDecimal(Convert.ToString(h("labour_charge"))), pct As Decimal = ParseDecimal(Convert.ToString(h("margin_pct")))
                Dim baseAmt As Decimal = skuPrice + material + proc + lab
                Dim total As Decimal = Math.Round(baseAmt + baseAmt * pct / 100D, 2)
                sb.Append("<tr><td " & td & ">" & Server.HtmlEncode(Convert.ToString(h("pack_size"))) & "</td><td " & td & ">" & String.Join(", ", lines.ToArray()) & " (= " & material.ToString("0.00") & ")</td><td " & td & " align='right'>" & proc.ToString("0.00") & "</td><td " & td & " align='right'>" & lab.ToString("0.00") & "</td><td " & td & " align='right'>" & pct.ToString("0.00") & "</td><td " & td & " align='right'><b>" & total.ToString("0.00") & "</b></td></tr>")
            Next
            sb.Append("</table><br/>")
            sb.Append("<p><a href='" & link & "'>" & If(toVendor, "Open the formulation to accept or counter the revised rate", "Open the formulation to approve, reject or revise") & "</a></p>")
            sb.Append("<h4 style='color:darkred;'>**This is an auto-generated mail. Please do not reply to this mail**</h4>")

            Dim mailEntity As New MailEntity()
            mailEntity.FromAddress = ConfigurationManager.AppSettings("EMAIL_ADDRESS")
            mailEntity.ToAddress = toAddress
            mailEntity.CCAddress = ccAddress
            mailEntity.BCCAddress = bccAddress
            mailEntity.MailSubject = If(toVendor, "SKU formulation - HO revised the rate: ", "SKU formulation approval required: ") & hdnProductCode.Value & " - " & ddlvendor.SelectedItem.Text & " (cycle " & cycle & " rev " & revision & ")"
            mailEntity.MailBody = sb.ToString()
            mailEntity.Sender_App = "VMS"
            mailEntity.Sender_Task = "SkuFormulationApproval"
            Dim mailobj As New EmailSMSsender()
            Dim rc As Integer = mailobj.sendMail(mailEntity)
            If rc = 0 Then Return who & " mail NOT sent - mail service rejected it (to: " & toAddress & ")"
            Return ""
        Catch ex As Exception
            ' a mail failure must never undo a saved formulation
            Return who & " mail NOT sent - " & ex.Message
        End Try
    End Function
#End Region

#Region "section 2 - packaging cost"
    Private Sub InitializePackTables()
        Dim hdr As New DataTable()
        hdr.Columns.Add("pack_key", GetType(Integer))
        hdr.Columns.Add("pch_id", GetType(Integer))
        hdr.Columns.Add("pack_size", GetType(String))
        hdr.Columns.Add("processing_fee", GetType(String))
        hdr.Columns.Add("labour_charge", GetType(String))
        hdr.Columns.Add("margin_pct", GetType(String))
        ViewState(PackHdrKey) = hdr

        Dim dtl As New DataTable()
        dtl.Columns.Add("line_key", GetType(Integer))
        dtl.Columns.Add("pack_key", GetType(Integer))
        dtl.Columns.Add("pcd_id", GetType(Integer))
        dtl.Columns.Add("cost_name", GetType(String))
        dtl.Columns.Add("amount", GetType(String))
        dtl.Columns.Add("srl", GetType(Integer))
        ViewState(PackDtlKey) = dtl
    End Sub

    Private Function PackHdr() As DataTable
        If ViewState(PackHdrKey) Is Nothing Then InitializePackTables()
        Return CType(ViewState(PackHdrKey), DataTable)
    End Function

    Private Function PackDtl() As DataTable
        If ViewState(PackDtlKey) Is Nothing Then InitializePackTables()
        Return CType(ViewState(PackDtlKey), DataTable)
    End Function

    Private Function NextKey(ByVal dt As DataTable, ByVal col As String) As Integer
        Dim max As Integer = 0
        For Each r As DataRow In dt.Rows
            max = Math.Max(max, Convert.ToInt32(r(col)))
        Next
        Return max + 1
    End Function

    Protected Function IsPackOpen(ByVal packKey As Object) As Boolean
        Return Convert.ToString(packKey) = hdnOpenPack.Value
    End Function

    Private Sub BindPacks()
        rptPack.DataSource = PackHdr()
        rptPack.DataBind()
    End Sub

    Protected Sub rptPack_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType <> ListItemType.Item AndAlso e.Item.ItemType <> ListItemType.AlternatingItem Then Exit Sub
        Dim packKey As Integer = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "pack_key"))
        Dim rptLines As Repeater = CType(e.Item.FindControl("rptLines"), Repeater)
        Dim lines As DataTable = PackDtl().Clone()
        For Each r As DataRow In PackDtl().Select("pack_key = " & packKey, "srl, line_key")
            lines.ImportRow(r)
        Next
        rptLines.DataSource = lines
        rptLines.DataBind()
    End Sub

    ''' <summary>Copies the inline-edited ratio / price of every grid row, and every textbox of the packaging repeaters,
    ''' back into the ViewState tables before a command is handled.</summary>
    Private Sub CapturePackInputs()
        Dim grid As DataTable = GetGridTable()
        For i As Integer = 0 To gvVendorRawMat.Rows.Count - 1
            If i >= grid.Rows.Count Then Exit For
            Dim txtRowRatio As TextBox = TryCast(gvVendorRawMat.Rows(i).FindControl("txtRowRatio"), TextBox)
            Dim txtRowRate As TextBox = TryCast(gvVendorRawMat.Rows(i).FindControl("txtRowRate"), TextBox)
            If txtRowRatio IsNot Nothing Then grid.Rows(i)("ratio") = ParseDecimal(txtRowRatio.Text).ToString("0.##", CultureInfo.InvariantCulture)
            If txtRowRate IsNot Nothing Then grid.Rows(i)("rate") = ParseDecimal(txtRowRate.Text).ToString("0.00", CultureInfo.InvariantCulture)
        Next
        ViewState(GridTableKey) = grid

        Dim hdr As DataTable = PackHdr()
        Dim dtl As DataTable = PackDtl()
        For Each item As RepeaterItem In rptPack.Items
            Dim packKey As Integer = ParseInteger(CType(item.FindControl("hdnPackKey"), HiddenField).Value)
            Dim h() As DataRow = hdr.Select("pack_key = " & packKey)
            If h.Length > 0 Then
                h(0)("processing_fee") = CType(item.FindControl("txtProcessing"), TextBox).Text.Trim()
                h(0)("labour_charge") = CType(item.FindControl("txtLabour"), TextBox).Text.Trim()
                h(0)("margin_pct") = CType(item.FindControl("txtMarginPct"), TextBox).Text.Trim()
            End If
            Dim rptLines As Repeater = CType(item.FindControl("rptLines"), Repeater)
            For Each li As RepeaterItem In rptLines.Items
                Dim lineKey As Integer = ParseInteger(CType(li.FindControl("hdnLineKey"), HiddenField).Value)
                Dim d() As DataRow = dtl.Select("line_key = " & lineKey)
                If d.Length > 0 Then
                    d(0)("cost_name") = CType(li.FindControl("txtCostName"), TextBox).Text.Trim()
                    d(0)("amount") = CType(li.FindControl("txtAmount"), TextBox).Text.Trim()
                End If
            Next
        Next
        ViewState(PackHdrKey) = hdr
        ViewState(PackDtlKey) = dtl
    End Sub

    Protected Sub btnAddPack_Click(sender As Object, e As EventArgs)
        CapturePackInputs()
        valPackSize.Text = ""
        Dim packSize As String = txtPackSize.Text.Trim()
        If packSize = "" Then valPackSize.Text = "Please enter Pack size." : BindPacks() : Exit Sub
        Dim hdr As DataTable = PackHdr()
        For Each r As DataRow In hdr.Rows
            If Convert.ToString(r("pack_size")).Trim().Equals(packSize, StringComparison.OrdinalIgnoreCase) Then
                valPackSize.Text = "This Pack size is already added." : BindPacks() : Exit Sub
            End If
        Next
        Dim key As Integer = NextKey(hdr, "pack_key")
        hdr.Rows.Add(key, 0, packSize, "", "", "")
        ViewState(PackHdrKey) = hdr
        hdnOpenPack.Value = key.ToString()
        txtPackSize.Text = ""
        BindPacks()
    End Sub

    Private Sub AddLine(ByVal packKey As Integer, Optional ByVal costName As String = "", Optional ByVal amount As String = "")
        Dim dtl As DataTable = PackDtl()
        dtl.Rows.Add(NextKey(dtl, "line_key"), packKey, 0, costName, amount, dtl.Select("pack_key = " & packKey).Length + 1)
        ViewState(PackDtlKey) = dtl
    End Sub

    Protected Sub rptPack_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        CapturePackInputs()
        valPack.Text = ""
        Dim packKey As Integer = ParseInteger(Convert.ToString(e.CommandArgument))
        hdnOpenPack.Value = packKey.ToString()
        Select Case e.CommandName
            Case "AddLine"
                ' values come from the entry line of that pack (like the SKU grid): name + amount required
                Dim item As RepeaterItem = TryCast(CType(source, Control).NamingContainer, RepeaterItem)
                If item Is Nothing Then item = TryCast(CType(e.CommandSource, Control).NamingContainer, RepeaterItem)
                Dim txtName As TextBox = If(item Is Nothing, Nothing, TryCast(item.FindControl("txtNewCostName"), TextBox))
                Dim txtAmt As TextBox = If(item Is Nothing, Nothing, TryCast(item.FindControl("txtNewAmount"), TextBox))
                Dim name As String = If(txtName Is Nothing, "", txtName.Text.Trim())
                Dim amtText As String = If(txtAmt Is Nothing, "", txtAmt.Text.Trim())
                If name = "" OrElse amtText = "" Then
                    valPack.Text = "Enter the cost name and amount, then press Add."
                Else
                    AddLine(packKey, name, ParseDecimal(amtText).ToString("0.00", CultureInfo.InvariantCulture))
                End If
            Case "RemovePack"
                Dim hdr As DataTable = PackHdr()
                For Each r As DataRow In hdr.Select("pack_key = " & packKey)
                    hdr.Rows.Remove(r)
                Next
                Dim dtl As DataTable = PackDtl()
                For Each r As DataRow In dtl.Select("pack_key = " & packKey)
                    dtl.Rows.Remove(r)
                Next
                ViewState(PackHdrKey) = hdr
                ViewState(PackDtlKey) = dtl
                hdnOpenPack.Value = ""
        End Select
        BindPacks()
    End Sub

    Protected Sub rptLines_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName <> "RemoveLine" Then Exit Sub
        CapturePackInputs()
        Dim lineKey As Integer = ParseInteger(Convert.ToString(e.CommandArgument))
        Dim dtl As DataTable = PackDtl()
        For Each r As DataRow In dtl.Select("line_key = " & lineKey)
            hdnOpenPack.Value = Convert.ToString(r("pack_key"))
            dtl.Rows.Remove(r)
        Next
        ViewState(PackDtlKey) = dtl
        BindPacks()
    End Sub

    ''' <summary>Server-side check of the packs before submit; "" when valid. Packaging cost is mandatory.</summary>
    Private Function ValidatePacks() As String
        If PackHdr().Rows.Count = 0 Then Return "Packaging cost is required: add at least one pack size."
        For Each h As DataRow In PackHdr().Rows
            Dim packSize As String = Convert.ToString(h("pack_size"))
            For Each l As DataRow In PackDtl().Select("pack_key = " & Convert.ToInt32(h("pack_key")))
                Dim name As String = Convert.ToString(l("cost_name")).Trim()
                Dim amtText As String = Convert.ToString(l("amount")).Trim()
                If name = "" AndAlso amtText = "" Then Continue For
                If name = "" OrElse amtText = "" Then Return "Please fill Cost name and Amount for every line of " & packSize & " packaging."
            Next
            Dim marginPct As Decimal = ParseDecimal(Convert.ToString(h("margin_pct")))
            If marginPct < 0D OrElse marginPct > 100D Then Return "Margin % of " & packSize & " packaging must be between 0 and 100."
        Next
        Return ""
    End Function
#End Region

#Region "helpers"
    Private Shared Function ParseInteger(ByVal value As String) As Integer
        Dim intValue As Integer = 0
        If Integer.TryParse(value, intValue) Then Return intValue
        Dim decimalValue As Decimal = 0D
        If Decimal.TryParse(value, decimalValue) Then Return CInt(decimalValue)
        Return 0
    End Function

    Private Shared Function ParseDecimal(ByVal value As String) As Decimal
        Dim d As Decimal = 0D
        If String.IsNullOrWhiteSpace(value) Then Return 0D
        If Decimal.TryParse(value.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, d) Then Return d
        If Decimal.TryParse(value.Trim(), NumberStyles.Number, CultureInfo.CurrentCulture, d) Then Return d
        Return 0D
    End Function
#End Region
End Class
