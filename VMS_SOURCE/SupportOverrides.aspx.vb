Imports System.Data
Imports System.Globalization
Imports VMS.Web

''' <summary>
''' Support Overrides page (SYSADMIN only) - added by MUKESH BHAGAT on 12-Oct-2026.
''' Lets support switch temporary exceptions on/off (table dbo.support_override_mstr) instead of
''' changing code: despatch invoice-limit bypass per unit + date range, OCR validation flags.
''' </summary>
Partial Class SupportOverrides
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            LoadTypes()
            LoadScopes()
            ApplyTypeRules()
            BindGrid()
        End If
    End Sub

    Private Sub CheckLogin()
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        ' SYSADMIN group AND listed in the SUPPORT_PAGE_USERS override (seeded with murthy)
        If userInfo.userGroupCodeEntity <> Constant.UserFormAccess.SYSADMIN OrElse Not SupportOverrideClass.CanOpenSupportPage(userInfo.userIDEntity) Then
            Response.Redirect("~/Home.aspx")
        End If
    End Sub

    Private Sub LoadTypes()
        ddlType.Items.Clear()
        ddlType.Items.Add(New ListItem(Constant.Common.Selec, ""))
        For Each t As SupportOverrideClass.OverrideType In SupportOverrideClass.Types
            ddlType.Items.Add(New ListItem(t.Label, t.Key))
        Next
    End Sub

    Private Sub LoadScopes()
        ddlScope.Items.Clear()
        ddlScope.Items.Add(New ListItem("All (*)", "*"))
        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    ddlScope.Items.Add(New ListItem(Convert.ToString(dr("unit_name")) & " (" & Convert.ToString(dr("unit_code")) & ")", Convert.ToString(dr("unit_code"))))
                Next
            End If
        Catch
        End Try
    End Sub

    Protected Function TypeLabel(ByVal key As Object) As String
        Dim t As SupportOverrideClass.OverrideType = SupportOverrideClass.FindType(Convert.ToString(key))
        Return If(t Is Nothing, Convert.ToString(key), t.Label)
    End Function

    Protected Sub ddlType_SelectedIndexChanged(sender As Object, e As EventArgs)
        ApplyTypeRules()
    End Sub

    Private Sub ApplyTypeRules()
        Dim t As SupportOverrideClass.OverrideType = SupportOverrideClass.FindType(ddlType.SelectedValue)
        litDesc.Text = If(t Is Nothing, "", t.Description)
        lblScopeReq.Visible = t IsNot Nothing AndAlso t.NeedsScope
        lblValueReq.Visible = t IsNot Nothing AndAlso t.NeedsValue
        txtValue.Enabled = t Is Nothing OrElse t.NeedsValue
        txtValue.Attributes("placeholder") = If(t Is Nothing, "", t.ValueHint)
        If t IsNot Nothing AndAlso Not t.NeedsValue Then txtValue.Text = ""
        If t IsNot Nothing AndAlso Not t.NeedsScope Then ddlScope.SelectedValue = "*"
    End Sub

    Private Sub BindGrid()
        Dim obj As New SupportOverrideClass()
        Try
            Dim ds As DataSet = obj.ListOverrides()
            gvList.DataSource = If(ds IsNot Nothing AndAlso ds.Tables.Count > 0, ds.Tables(0), Nothing)
        Catch ex As Exception
            gvList.DataSource = Nothing
            lblErrorMessage.Text = "Override table not available: " & ex.Message
        End Try
        gvList.DataBind()
    End Sub

    Private Sub ClearValidation()
        valType.Text = "" : valScope.Text = "" : valValue.Text = "" : valDates.Text = "" : valRemarks.Text = "" : lblErrorMessage.Text = ""
    End Sub

    Private Function ParseDate(ByVal text As String) As Date?
        Dim d As Date
        If String.IsNullOrWhiteSpace(text) Then Return Nothing
        If Date.TryParseExact(text.Trim(), New String() {"yyyy-MM-dd", "dd/MM/yyyy", "dd-MM-yyyy"}, CultureInfo.InvariantCulture, DateTimeStyles.None, d) Then Return d
        If Date.TryParse(text.Trim(), d) Then Return d
        Return Nothing
    End Function

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ClearValidation()
        Dim t As SupportOverrideClass.OverrideType = SupportOverrideClass.FindType(ddlType.SelectedValue)
        Dim ok As Boolean = True
        If t Is Nothing Then valType.Text = "Please select the override." : ok = False
        If t IsNot Nothing AndAlso t.NeedsScope AndAlso (ddlScope.SelectedValue = "" OrElse ddlScope.SelectedValue = "*") Then valScope.Text = "Please select the unit / vendor." : ok = False
        If t IsNot Nothing AndAlso t.NeedsValue AndAlso String.IsNullOrWhiteSpace(txtValue.Text) Then valValue.Text = "Please enter the value (" & t.ValueHint & ")." : ok = False
        If t IsNot Nothing AndAlso t.NeedsValue AndAlso (t.Key = SupportOverrideClass.OCR_VALIDATION_ENABLED OrElse t.Key = SupportOverrideClass.OCR_FAIL_OPEN) Then
            Dim v As String = txtValue.Text.Trim().ToUpperInvariant()
            If v <> "Y" AndAlso v <> "N" Then valValue.Text = "Value must be Y or N." : ok = False Else txtValue.Text = v
        End If
        If t IsNot Nothing AndAlso t.Key = SupportOverrideClass.OCR_API_TIMEOUT_MS Then
            Dim n As Integer
            If Not Integer.TryParse(txtValue.Text.Trim(), n) OrElse n < 1000 Then valValue.Text = "Timeout must be a number of milliseconds (1000 or more)." : ok = False
        End If
        Dim fromDate As Date? = ParseDate(txtFrom.Text)
        Dim toDate As Date? = ParseDate(txtTo.Text)
        If t IsNot Nothing AndAlso t.NeedsScope AndAlso (Not fromDate.HasValue OrElse Not toDate.HasValue) Then valDates.Text = "Unit exceptions need both Valid From and Valid To." : ok = False
        If fromDate.HasValue AndAlso toDate.HasValue AndAlso toDate.Value < fromDate.Value Then valDates.Text = "Valid To cannot be before Valid From." : ok = False
        If String.IsNullOrWhiteSpace(txtRemarks.Text) Then valRemarks.Text = "Please enter the ticket / reason." : ok = False
        If Not ok Then Exit Sub

        Try
            Dim obj As New SupportOverrideClass()
            Dim id As Integer = 0
            Integer.TryParse(hdnId.Value, id)
            Dim newId As Integer = obj.SaveOverride(id, t.Key, If(t.NeedsScope, ddlScope.SelectedValue, "*"), If(t.NeedsValue, txtValue.Text, ""), fromDate, toDate, txtRemarks.Text, userInfo.userIDEntity)
            If newId > 0 Then
                ResetForm()
                BindGrid()
                RmActionPopup.ShowSuccess(Me, "Override saved. It is live within one minute.")
            Else
                lblErrorMessage.Text = "Unable to save. Please try again."
            End If
        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        ResetForm()
    End Sub

    Private Sub ResetForm()
        hdnId.Value = ""
        ddlType.SelectedIndex = 0
        ddlScope.SelectedValue = "*"
        txtValue.Text = "" : txtFrom.Text = "" : txtTo.Text = "" : txtRemarks.Text = ""
        litFormTitle.Text = "Add override"
        btnSave.Text = "Save"
        ClearValidation()
        ApplyTypeRules()
    End Sub

    Protected Sub gvList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvList.RowCommand
        Dim id As Integer = 0
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), id) OrElse id <= 0 Then Exit Sub
        Dim obj As New SupportOverrideClass()
        Select Case e.CommandName
            Case "EditRow"
                Dim ds As DataSet = obj.ListOverrides()
                If ds Is Nothing OrElse ds.Tables.Count = 0 Then Exit Sub
                Dim rows() As DataRow = ds.Tables(0).Select("so_id = " & id)
                If rows.Length = 0 Then Exit Sub
                Dim r As DataRow = rows(0)
                hdnId.Value = id.ToString()
                If ddlType.Items.FindByValue(Convert.ToString(r("so_key"))) IsNot Nothing Then ddlType.SelectedValue = Convert.ToString(r("so_key"))
                If ddlScope.Items.FindByValue(Convert.ToString(r("so_scope"))) IsNot Nothing Then ddlScope.SelectedValue = Convert.ToString(r("so_scope"))
                txtValue.Text = Convert.ToString(r("so_value"))
                txtFrom.Text = If(IsDBNull(r("so_valid_from")), "", Convert.ToDateTime(r("so_valid_from")).ToString("yyyy-MM-dd"))
                txtTo.Text = If(IsDBNull(r("so_valid_to")), "", Convert.ToDateTime(r("so_valid_to")).ToString("yyyy-MM-dd"))
                txtRemarks.Text = Convert.ToString(r("so_remarks"))
                litFormTitle.Text = "Edit override #" & id
                btnSave.Text = "Update"
                ApplyTypeRules()
            Case "Disable", "Enable"
                obj.SetActive(id, If(e.CommandName = "Enable", "Y", "N"), userInfo.userIDEntity)
                BindGrid()
                RmActionPopup.ShowSuccess(Me, "Override " & If(e.CommandName = "Enable", "enabled", "disabled") & ". It is live within one minute.")
        End Select
    End Sub
End Class
