Imports System.Collections.Generic
Imports System.Data
Imports System.Globalization
Imports System.Linq
Imports System.Text
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
        btnSubmit.Text = If(ParseInteger(hdnId.Value) > 0, "Save new version", "Submit")
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
            Dim lblRatio As Label = TryCast(e.Row.FindControl("lblRatio"), Label)
            Dim lblRate As Label = TryCast(e.Row.FindControl("lblRate"), Label)
            Dim ratio As Decimal = If(lblRatio Is Nothing, 0D, ParseDecimal(lblRatio.Text))
            Dim rate As Decimal = If(lblRate Is Nothing, 0D, ParseDecimal(lblRate.Text))
            gridRatioTotal += ratio
            gridSkuPrice += ratio / 100D * rate
            If lblRate IsNot Nothing Then lblRate.Text = rate.ToString("0.00", CultureInfo.InvariantCulture)
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
                RmActionPopup.ShowError(Me, "No changes to save - the current version already has this formulation and packaging cost.")
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

            Dim obj As New OPC_VendorClass()
            Dim result As OPC_VendorClass.SkuFormulationSaveResult =
                obj.SaveSkuFormulation(ddlBrand.SelectedValue.Trim(), ddlvendor.SelectedValue.Trim(), hdnProductCode.Value.Trim(), txtRemarks.Text, dtl, packs, lines, userInfo.userIDEntity)

            Select Case result.Status
                Case 1
                    ClearInlineValidation()
                    RmActionPopup.ShowSuccess(Me, "Saved successfully as version " & result.Version & ".", "Product_Formulation.aspx?id=" & result.HeaderId)
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
        lblVersionInfo.Text = "Version " & Convert.ToString(h("sf_version")) &
            If(Convert.ToString(h("sf_is_current")) = "Y", " (current)", " (history - valid till " & Convert.ToString(h("sf_valid_to")) & ")")
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

    ''' <summary>Copies every textbox of the packaging repeaters back into the ViewState tables before a command is handled.</summary>
    Private Sub CapturePackInputs()
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
        AddLine(key)
        hdnOpenPack.Value = key.ToString()
        txtPackSize.Text = ""
        BindPacks()
    End Sub

    Private Sub AddLine(ByVal packKey As Integer)
        Dim dtl As DataTable = PackDtl()
        dtl.Rows.Add(NextKey(dtl, "line_key"), packKey, 0, "", "", dtl.Select("pack_key = " & packKey).Length + 1)
        ViewState(PackDtlKey) = dtl
    End Sub

    Protected Sub rptPack_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        CapturePackInputs()
        valPack.Text = ""
        Dim packKey As Integer = ParseInteger(Convert.ToString(e.CommandArgument))
        hdnOpenPack.Value = packKey.ToString()
        Select Case e.CommandName
            Case "AddLine"
                AddLine(packKey)
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
