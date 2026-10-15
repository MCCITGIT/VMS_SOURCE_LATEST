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
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx", False)
            Context.ApplicationInstance.CompleteRequest()
            Exit Sub
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If Not CheckAccess() Then Exit Sub
        If Not IsPostBack Then
            Try
                LoadTypes()
                LoadScopes()
                ApplyTypeRules()
                BindGrid()
            Catch ex As Exception
                lblErrorMessage.Text = "Page could not load: " & ex.Message
            End Try
        End If
    End Sub

    ''' <summary>SYSADMIN group AND listed in the SUPPORT_PAGE_USERS override. On failure the page shows why (no redirect, no Response.End).</summary>
    Private Function CheckAccess() As Boolean
        Dim groupOk As Boolean = String.Equals(Convert.ToString(userInfo.userGroupCodeEntity).Trim(), Constant.UserFormAccess.SYSADMIN, StringComparison.OrdinalIgnoreCase)
        Dim userOk As Boolean = False, listed As String = ""
        Try
            userOk = SupportOverrideClass.CanOpenSupportPage(userInfo.userIDEntity)
            listed = SupportOverrideClass.GetValue(SupportOverrideClass.SUPPORT_PAGE_USERS, "<no active row>")
        Catch ex As Exception
            listed = "<error reading overrides: " & ex.Message & ">"
        End Try
        If groupOk AndAlso userOk Then Return True
        pnlContent.Visible = False
        pnlDenied.Visible = True
        litDenied.Text = "<p>Group: <b>" & Server.HtmlEncode(Convert.ToString(userInfo.userGroupCodeEntity)) & "</b> (must be SYSADMIN) - " & If(groupOk, "OK", "<span style='color:#dc3545'>NOT OK</span>") & "</p>" &
                         "<p>User id: <b>" & Server.HtmlEncode(Convert.ToString(userInfo.userIDEntity)) & "</b> (must be listed in override SUPPORT_PAGE_USERS = '" & Server.HtmlEncode(listed) & "') - " &
                         If(userOk, "OK", "<span style='color:#dc3545'>NOT OK</span>") & "</p>"
        Return False
    End Function

    Private Sub LoadTypes()
        ddlType.Items.Clear()
        ddlType.Items.Add(New ListItem(Constant.Common.Selec, ""))
        For Each t As SupportOverrideClass.OverrideType In SupportOverrideClass.Types
            ddlType.Items.Add(New ListItem(t.Label, t.Key))
        Next
    End Sub

    ''' <summary>Unit / vendor list for the scope dropdown. Uses VendorMaster_GetUnitName (exists in live) - not the
    ''' RM-procurement GetUnitList, which is UAT-only. If the list cannot be loaded the unit code can be typed instead.</summary>
    Private Sub LoadScopes()
        ddlScope.Items.Clear()
        ddlScope.Items.Add(New ListItem("All (*)", "*"))
        Try
            Dim obj As New VendorMaster()
            Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Columns.Count >= 2 Then
                Dim dt As DataTable = ds.Tables(0)
                Dim codeCol As String = If(dt.Columns.Contains("unit_code"), "unit_code", dt.Columns(0).ColumnName)
                Dim nameCol As String = If(dt.Columns.Contains("unit_name"), "unit_name", dt.Columns(1).ColumnName)
                For Each dr As DataRow In dt.Rows
                    ddlScope.Items.Add(New ListItem(Convert.ToString(dr(nameCol)) & " (" & Convert.ToString(dr(codeCol)) & ")", Convert.ToString(dr(codeCol))))
                Next
            End If
        Catch
        End Try
        ' no units available (SP missing / empty): let support type the unit code
        txtScope.Visible = ddlScope.Items.Count <= 1
        ddlScope.Visible = Not txtScope.Visible
    End Sub

    ''' <summary>Selected unit code: dropdown, or the typed code when the list was unavailable.</summary>
    Private Function SelectedScope() As String
        If txtScope.Visible Then Return If(String.IsNullOrWhiteSpace(txtScope.Text), "*", txtScope.Text.Trim().ToUpperInvariant())
        Return ddlScope.SelectedValue
    End Function

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
        If t IsNot Nothing AndAlso Not t.NeedsScope Then ddlScope.SelectedValue = "*" : txtScope.Text = ""
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
        If t IsNot Nothing AndAlso t.NeedsScope AndAlso (SelectedScope() = "" OrElse SelectedScope() = "*") Then valScope.Text = "Please select the unit / vendor." : ok = False
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
            Dim newId As Integer = obj.SaveOverride(id, t.Key, If(t.NeedsScope, SelectedScope(), "*"), If(t.NeedsValue, txtValue.Text, ""), fromDate, toDate, txtRemarks.Text, userInfo.userIDEntity)
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
        ddlScope.SelectedValue = "*" : txtScope.Text = ""
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
                If ddlScope.Items.FindByValue(Convert.ToString(r("so_scope"))) IsNot Nothing Then ddlScope.SelectedValue = Convert.ToString(r("so_scope")) Else txtScope.Text = If(Convert.ToString(r("so_scope")) = "*", "", Convert.ToString(r("so_scope")))
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
