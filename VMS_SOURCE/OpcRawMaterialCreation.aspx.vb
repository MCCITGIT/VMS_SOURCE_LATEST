Imports System.Data
Imports VMS.Web

Partial Class OpcRawMaterialCreation
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const RmCodeKey As String = "RmCode"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            CheckLogin()
            Page.MaintainScrollPositionOnPostBack = True

            If Not IsPostBack Then
                ' 04-11-2026: no item type choice any more - a vendor (UNIT) login enters packaging only, HO enters raw materials only (for ALL vendors)
                ddlItemType.ClearSelection()
                ddlItemType.Items.FindByValue(If(IsUnitUser(), "PKG", "RM")).Selected = True
                ddlItemType.Enabled = False
                PopulateVendor()
                pnlVendor.Visible = IsUnitUser()          ' HO does not pick a vendor
                pnlScope.Visible = Not IsUnitUser()       ' "Applies to: All vendors"
                pnlBerger.Visible = Not IsUnitUser()      ' Berger code + "Berger doesn't buy" - HO raw material only
                pnlBergerTick.Visible = Not IsUnitUser()

                ' 05-11-2026: say what is being entered - a vendor enters PACKAGING, HO enters RAW MATERIAL
                If IsUnitUser() Then
                    lblPageTitle.Text = "Packaging Creation"
                    lblPageSub.Text = "Create your packaging items (for example 1 KG bag, 20 KG bucket)"
                    lblPanelTitle.Text = "Packaging Item Details"
                    lblPanelSub.Text = "You are entering a PACKAGING item. Enter the packaging name; the code (PKG...) is generated on save. HO links its Berger code."
                    lblNameCaption.Text = "Packaging Name:"
                    pnlType.Visible = True                ' read-only Type box: Packaging
                    txtName_Placeholder()
                Else
                    lblPageTitle.Text = "Raw Material Creation"
                    lblPageSub.Text = "Create raw materials for all vendors"
                    lblPanelTitle.Text = "Raw Material Details"
                    lblPanelSub.Text = "You are entering a RAW MATERIAL for all vendors. Enter the name and link its Berger code (or tick that Berger doesn't buy it). The code (MAN...) is generated on save."
                    lblNameCaption.Text = "Raw Material Name:"
                    txtRmName.Attributes("placeholder") = "e.g. CEMENT 43 GRADE"
                End If

                Dim rmCode As String = If(Request.QueryString(RmCodeKey), String.Empty).Trim()
                If Not String.IsNullOrWhiteSpace(rmCode) Then
                    ViewState("EditRmCode") = rmCode
                    btnSubmit.Text = Constant.GeneralMessages.btnUpdate
                    SetEditFieldsVisible(True)
                    LoadSavedRecord(rmCode)
                Else
                    btnSubmit.Text = Constant.GeneralMessages.btnSubmit
                    SetEditFieldsVisible(False)
                    txtRmCode.Text = String.Empty
                    rbtnActiveY.Checked = True
                    rbtnActiveN.Checked = False
                End If
            End If
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Private Sub txtName_Placeholder()
        txtRmName.Attributes("placeholder") = "e.g. 1 KG BAG"
    End Sub

    Private ReadOnly Property IsEditMode As Boolean
        Get
            Return ViewState("EditRmCode") IsNot Nothing
        End Get
    End Property

    Private ReadOnly Property EditRmCode As String
        Get
            Return If(Convert.ToString(ViewState("EditRmCode")), String.Empty).Trim()
        End Get
    End Property

    Private Function IsUnitUser() As Boolean
        If userInfo Is Nothing Then
            Return False
        End If
        Return String.Equals(Convert.ToString(userInfo.userGroupCodeEntity).Trim(), Constant.UserFormAccess.UNIT, StringComparison.OrdinalIgnoreCase)
    End Function

    Private Function OwnUnitCode() As String
        If userInfo Is Nothing Then
            Return String.Empty
        End If
        Return Convert.ToString(userInfo.userBranchEntity).Trim()
    End Function

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateVendor()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)

        ddlVendor.Items.Clear()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

        If IsUnitUser() Then
            Dim own As String = OwnUnitCode()
            If Not String.IsNullOrWhiteSpace(own) AndAlso ddlVendor.Items.FindByValue(own) IsNot Nothing Then
                ddlVendor.ClearSelection()
                ddlVendor.Items.FindByValue(own).Selected = True
            End If
            ddlVendor.Enabled = False
        End If
    End Sub

    Private Sub LoadSavedRecord(ByVal rmCode As String)
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetOpcRawMaterialCreation(rmCode)

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing OrElse ds.Tables(0).Rows.Count = 0 Then
            valRmName.Text = "Raw material was not found."
            Return
        End If

        Dim row As DataRow = ds.Tables(0).Rows(0)
        Dim unitCode As String = Convert.ToString(row("unit_code")).Trim()

        If IsUnitUser() AndAlso Not String.Equals(unitCode, OwnUnitCode(), StringComparison.OrdinalIgnoreCase) Then
            Response.Redirect("~/OpcRawMaterialCreationList.aspx", False)
            Context.ApplicationInstance.CompleteRequest()
            Return
        End If

        ' type of the saved item (fixed after creation). An HO login cannot open a packaging item (it belongs to the vendor, HO links its Berger code on
        ' Raw Material Code Linking); a vendor login cannot open a raw material (raw materials are entered by HO) - 04-11-2026
        Dim savedType As String = If(row.Table.Columns.Contains("rmm_item_type"), Convert.ToString(row("rmm_item_type")).Trim().ToUpperInvariant(), "RM")
        If (savedType = "PKG" AndAlso Not IsUnitUser()) OrElse (savedType <> "PKG" AndAlso IsUnitUser()) Then
            Response.Redirect("~/OpcRawMaterialCreationList.aspx", False)
            Context.ApplicationInstance.CompleteRequest()
            Return
        End If
        If ddlItemType.Items.FindByValue(savedType) IsNot Nothing Then
            ddlItemType.ClearSelection()
            ddlItemType.Items.FindByValue(savedType).Selected = True
        End If
        ddlItemType.Enabled = False

        txtRmCode.Text = Convert.ToString(row("rmm_code")).Trim()
        txtRmName.Text = Convert.ToString(row("rmm_material_name")).Trim()

        ' scope: "All vendors" (entered by HO for everybody) or one vendor (old vendor-wise raw material / the vendor's packaging item)
        If String.Equals(unitCode, AllVendors, StringComparison.OrdinalIgnoreCase) Then
            pnlVendor.Visible = False
            pnlScope.Visible = True
            txtScope.Text = "All vendors"
        Else
            Dim vendorItem As ListItem = ddlVendor.Items.FindByValue(unitCode)
            If vendorItem Is Nothing AndAlso Not String.IsNullOrWhiteSpace(unitCode) Then
                vendorItem = New ListItem(Convert.ToString(row("vendor_name")).Trim(), unitCode)
                ddlVendor.Items.Add(vendorItem)
            End If
            If vendorItem IsNot Nothing Then
                ddlVendor.ClearSelection()
                vendorItem.Selected = True
            End If
            ddlVendor.Enabled = False
            If Not IsUnitUser() Then          ' HO opening an old vendor-wise raw material: show the vendor read-only
                pnlVendor.Visible = True
                pnlScope.Visible = False
            End If
        End If

        ' Berger link of the raw material (HO): code, or "Berger doesn't buy" (flag 'N' - same values as Raw Material Code Linking)
        If savedType <> "PKG" Then
            Dim flag As String = If(row.Table.Columns.Contains("berger_not_sale_flag"), Convert.ToString(row("berger_not_sale_flag")).Trim(), String.Empty)
            chkBergerNotBuy.Checked = flag.Equals("N", StringComparison.OrdinalIgnoreCase)
            hdnBergerCode.Value = If(chkBergerNotBuy.Checked OrElse Not row.Table.Columns.Contains("berger_code"), String.Empty, Convert.ToString(row("berger_code")).Trim())
        End If

        Dim activeValue As String = Convert.ToString(row("active")).Trim().ToUpper()
        rbtnActiveY.Checked = (activeValue <> "N")
        rbtnActiveN.Checked = (activeValue = "N")
    End Sub

    Private Sub ClearFieldErrors()
        If ddlVendor.CssClass Is Nothing Then
            ddlVendor.CssClass = "form-control select2"
        Else
            ddlVendor.CssClass = ddlVendor.CssClass.Replace("field-invalid", "").Trim()
            If ddlVendor.CssClass.IndexOf("select2", StringComparison.OrdinalIgnoreCase) < 0 Then
                ddlVendor.CssClass = (ddlVendor.CssClass & " select2").Trim()
            End If
        End If
        txtRmName.CssClass = "form-control"
        valVendor.Text = String.Empty
        valRmName.Text = String.Empty
    End Sub

    Private Sub SetFieldError(ByVal control As WebControl, ByVal messageLabel As Label, ByVal message As String)
        If control IsNot Nothing Then
            Dim css As String = Convert.ToString(control.CssClass)
            If css.IndexOf("field-invalid", StringComparison.OrdinalIgnoreCase) < 0 Then
                control.CssClass = (css & " field-invalid").Trim()
            End If
        End If
        If messageLabel IsNot Nothing Then
            messageLabel.Text = message
        End If
    End Sub

    Private Sub ShowMessage(ByVal message As String, ByVal isSuccess As Boolean)
        lblMessage.Text = String.Empty
        RmActionPopup.Show(Me, message, isSuccess)
    End Sub

    'owner of a NEW item: the vendor's own unit for a vendor login; "ALL" (every vendor) for the raw materials HO enters
    Private Const AllVendors As String = "ALL"

    Private Function GetSelectedUnitCode() As String
        If IsUnitUser() Then
            Return OwnUnitCode()
        End If
        Return AllVendors
    End Function

    Private Sub SetEditFieldsVisible(ByVal visible As Boolean)
        pnlRmCode.Visible = visible
        pnlActive.Visible = visible
    End Sub

    'vendor login = packaging, HO = raw material (decided by the login, not by anything posted)
    Private Function GetSelectedItemType() As String
        Return If(IsUnitUser(), "PKG", "RM")
    End Function

    Private Function BergerNotBuy() As Boolean
        Return Not IsUnitUser() AndAlso chkBergerNotBuy.Checked
    End Function

    Private Function SelectedBergerCode() As String
        If IsUnitUser() OrElse chkBergerNotBuy.Checked Then Return String.Empty
        Return Convert.ToString(hdnBergerCode.Value).Trim()
    End Function

    ' Berger link of an HO raw material is saved on a new item and when HO edits one (not for a vendor's packaging)
    Private Function SavesBerger() As Boolean
        Return Not IsUnitUser() AndAlso GetSelectedItemType() = "RM"
    End Function

    Private Function GetSelectedActiveStatus() As String
        If Not IsEditMode Then
            Return "Y"
        End If
        If rbtnActiveN IsNot Nothing AndAlso rbtnActiveN.Checked Then
            Return "N"
        End If
        Return "Y"
    End Function

    Private Function ValidateInputs() As Boolean
        ClearFieldErrors()
        Dim isValid As Boolean = True
        Dim unitCode As String = GetSelectedUnitCode()
        Dim name As String = Convert.ToString(txtRmName.Text).Trim()

        If IsUnitUser() AndAlso String.IsNullOrWhiteSpace(unitCode) Then
            SetFieldError(ddlVendor, valVendor, "Your vendor could not be identified. Please log in again.")
            isValid = False
        End If

        If String.IsNullOrWhiteSpace(name) Then
            SetFieldError(txtRmName, valRmName, "Enter the name.")
            isValid = False
        ElseIf name.Length < 3 Then
            SetFieldError(txtRmName, valRmName, "Name must be at least 3 characters.")
            isValid = False
        End If

        Return isValid
    End Function

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As EventArgs)
        CheckLogin()

        If Not ValidateInputs() Then
            Return
        End If

        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet
            If IsEditMode Then
                ds = obj.UpdateOpcRawMaterialCreation(EditRmCode, Convert.ToString(txtRmName.Text).Trim(), GetSelectedActiveStatus(), userInfo.userIDEntity, SavesBerger(), SelectedBergerCode(), BergerNotBuy())
            Else
                ds = obj.InsertOpcRawMaterialCreation(Convert.ToString(txtRmName.Text).Trim(), GetSelectedUnitCode(), userInfo.userIDEntity, GetSelectedItemType(), SelectedBergerCode(), BergerNotBuy())
            End If

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim status As Integer = 0
                Integer.TryParse(Convert.ToString(ds.Tables(0).Rows(0)("status")), status)
                Dim message As String = Convert.ToString(ds.Tables(0).Rows(0)("message"))
                Dim savedCode As String = Convert.ToString(ds.Tables(0).Rows(0)("rmm_code")).Trim()

                If status = 1 Then
                    If IsEditMode Then
                        LoadSavedRecord(EditRmCode)
                    Else
                        txtRmName.Text = String.Empty
                        txtRmCode.Text = String.Empty
                        SetEditFieldsVisible(False)
                        If Not IsUnitUser() AndAlso ddlVendor.Items.Count > 0 Then
                            ddlVendor.ClearSelection()
                            ddlVendor.SelectedIndex = 0
                        End If
                        rbtnActiveY.Checked = True
                        rbtnActiveN.Checked = False
                        hdnBergerCode.Value = String.Empty
                        chkBergerNotBuy.Checked = False
                    End If
                    If Not String.IsNullOrWhiteSpace(savedCode) AndAlso message.IndexOf(savedCode, StringComparison.OrdinalIgnoreCase) < 0 Then
                        message = message & " Code: " & savedCode
                    End If
                    ShowMessage(message, True)
                Else
                    SetFieldError(txtRmName, valRmName, message)
                    ShowMessage(message, False)
                End If
            Else
                ShowMessage("Something went wrong. Try again.", False)
            End If
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As EventArgs)
        ClearFieldErrors()
        lblMessage.Text = String.Empty

        If IsEditMode Then
            LoadSavedRecord(EditRmCode)
        Else
            txtRmName.Text = String.Empty
            txtRmCode.Text = String.Empty
            SetEditFieldsVisible(False)
            If Not IsUnitUser() AndAlso ddlVendor.Items.Count > 0 Then
                ddlVendor.ClearSelection()
                ddlVendor.SelectedIndex = 0
            End If
            rbtnActiveY.Checked = True
            rbtnActiveN.Checked = False
            hdnBergerCode.Value = String.Empty
            chkBergerNotBuy.Checked = False
        End If
    End Sub

    ' The Berger <select> is written here (after the postback events) with only the saved option; select2 loads the rest on demand.
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As EventArgs) Handles Me.PreRender
        If Not pnlBerger.Visible Then Return
        Dim code As String = If(chkBergerNotBuy.Checked, String.Empty, Convert.ToString(hdnBergerCode.Value).Trim())
        Dim label As String = code
        If code <> String.Empty Then
            Try
                Dim ds As DataSet = New OPC_VendorClass().GetRmBergerItemNames(code)
                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each r As DataRow In ds.Tables(0).Rows
                        If String.Equals(Convert.ToString(r("prd_code")).Trim(), code, StringComparison.OrdinalIgnoreCase) Then label = Convert.ToString(r("prd_name")).Trim()
                    Next
                End If
            Catch
            End Try
        End If
        Dim sb As New System.Text.StringBuilder()
        sb.Append("<select id=""ddlBergerCode"" class=""form-control""").Append(If(chkBergerNotBuy.Checked, " disabled=""disabled""", "")).Append("><option value=""""></option>")
        If code <> String.Empty Then sb.Append("<option value=""").Append(Server.HtmlEncode(code)).Append(""" selected=""selected"">").Append(Server.HtmlEncode(label)).Append("</option>")
        sb.Append("</select>")
        litBergerSelect.Text = sb.ToString()
    End Sub

    ''' <summary>Page method of the lazy Berger Code dropdown: one page (30 rows) of raw material items of the Berger item master whose code or description contains term.
    ''' Returns { items: [{id, text}], total }. Author: MUKESH BHAGAT 04-11-2026.</summary>
    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function BergerCodeSearch(ByVal term As String, ByVal page As Integer) As Object
        Dim items As New List(Of Object)()
        Dim total As Integer = 0
        If HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.items = items, .total = 0}
        Try
            Dim ds As DataSet = New OPC_VendorClass().SearchRmBergerItems(If(term, "").Trim(), Math.Max(page, 1) - 1, 30, "RM")
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    items.Add(New With {.id = Convert.ToString(r("prd_code")).Trim(), .text = Convert.ToString(r("prd_name")).Trim()})
                    If total = 0 Then Integer.TryParse(Convert.ToString(r("total_rows")), total)
                Next
            End If
        Catch
        End Try
        Return New With {.items = items, .total = total}
    End Function

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("~/OpcRawMaterialCreationList.aspx")
    End Sub
End Class
