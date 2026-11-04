Imports VMS.Web
Imports System.Data
Imports System.Data.SqlClient
Partial Class RawMaterialCodeLinking
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    ''' <summary>Labels ("code-description") of the Berger codes already saved on the rows being shown - one SP call per bind (30-10-2026, lazy dropdown).</summary>
    Private savedBergerNames As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
    Private Const BergerPageSize As Integer = 30

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateRegion()
            LoadPage()
        End If
    End Sub

    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        ' on a postback without rebind (e.g. a failed Submit) the labels were not loaded in this request - fetch them for the codes on screen
        Dim missing As New List(Of String)()
        For Each gridRow As GridViewRow In gvrawMatDetails.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then Continue For
            Dim h As HiddenField = TryCast(gridRow.FindControl("hdnBergerCode"), HiddenField)
            If h IsNot Nothing AndAlso h.Value.Trim() <> "" AndAlso Not savedBergerNames.ContainsKey(h.Value.Trim()) Then missing.Add(h.Value.Trim())
        Next
        If missing.Count > 0 Then
            Try
                Dim ds As DataSet = New OPC_VendorClass().GetRmBergerItemNames(String.Join(",", missing.Distinct(StringComparer.OrdinalIgnoreCase)))
                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each r As DataRow In ds.Tables(0).Rows
                        savedBergerNames(Convert.ToString(r("prd_code")).Trim()) = Convert.ToString(r("prd_name")).Trim()
                    Next
                End If
            Catch
            End Try
        End If

        For Each gridRow As GridViewRow In gvrawMatDetails.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim chkBergerNotSold As CheckBox = TryCast(gridRow.FindControl("chkBergerNotSold"), CheckBox)
            Dim hdnBergerCode As HiddenField = TryCast(gridRow.FindControl("hdnBergerCode"), HiddenField)
            If chkBergerNotSold Is Nothing OrElse hdnBergerCode Is Nothing Then
                Continue For
            End If

            If chkBergerNotSold.Checked Then hdnBergerCode.Value = String.Empty
            RenderBergerSelect(gridRow, hdnBergerCode.Value, chkBergerNotSold.Checked)
        Next
    End Sub

    ''' <summary>Writes the row's &lt;select&gt; with only the saved option (if any); select2 loads the rest on demand (30-10-2026).</summary>
    Private Sub RenderBergerSelect(ByVal gridRow As GridViewRow, ByVal code As String, ByVal disabled As Boolean)
        Dim lit As Literal = TryCast(gridRow.FindControl("litBergerSelect"), Literal)
        If lit Is Nothing Then Exit Sub
        Dim sb As New System.Text.StringBuilder()
        ' data-type = which Berger item category the row's list searches: RM (raw material) or PKG (the vendor's packaging item) - 02-11-2026
        Dim hdnType As HiddenField = TryCast(gridRow.FindControl("hdnItemType"), HiddenField)
        Dim itemType As String = If(hdnType IsNot Nothing AndAlso hdnType.Value.Trim().ToUpperInvariant() = "PKG", "PKG", "RM")
        sb.Append("<select class=""form-control rm-berger-code-ddl rm-berger-ajax"" data-type=""").Append(itemType).Append("""").Append(If(disabled, " disabled=""disabled""", "")).Append(">")
        sb.Append("<option value=""""></option>")
        code = Convert.ToString(code).Trim()
        If code <> "" Then
            Dim label As String = Nothing
            If Not savedBergerNames.TryGetValue(code, label) Then label = code
            sb.Append("<option value=""").Append(Server.HtmlEncode(code)).Append(""" selected=""selected"">").Append(Server.HtmlEncode(label)).Append("</option>")
        End If
        sb.Append("</select>")
        lit.Text = sb.ToString()
    End Sub

    ''' <summary>Page method of the lazy Berger Code dropdown: one page (30 rows) of RM items whose code or description contains term.
    ''' Returns { items: [{id, text}], total }. Author: MUKESH BHAGAT 30-10-2026.</summary>
    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function BergerCodeSearch(ByVal term As String, ByVal page As Integer, ByVal itemType As String) As Object
        Dim items As New List(Of Object)()
        Dim total As Integer = 0
        If HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.items = items, .total = 0}
        Try
            Dim ds As DataSet = New OPC_VendorClass().SearchRmBergerItems(If(term, "").Trim(), Math.Max(page, 1) - 1, BergerPageSize, itemType)
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

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function RawMaterialSearch(ByVal prefixText As String) As String()
        Dim rawMaterialDetails As List(Of String) = New List(Of String)()

        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 Then
            Return rawMaterialDetails.ToArray()
        End If

        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetRawMaterial_SearchList(prefixText)

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
        End Try

        Return rawMaterialDetails.ToArray()
    End Function

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs)
        lblErrorMessage.Text = String.Empty
        valGrid.Text = String.Empty
        BindData()
    End Sub

    Public Sub LoadPage()
        BindData()
    End Sub

    Private Sub BindData()
        Dim obj As New OPC_VendorClass()
        Dim rmName As String = GetRawMaterialSearchName()
        Dim bergerCode As String = txtBergerCodeSearch.Text.Trim()
        Dim status As String = ddlStatus.SelectedValue
        Dim ds As DataSet = obj.GetRawmaterialBergerCodeLinking(rmName, bergerCode, status, ddlItemType.SelectedValue)

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            LoadSavedBergerNames(ds.Tables(0))
            RmGridHelper.BindPaged(gvrawMatDetails, ds.Tables(0))
        Else
            RmGridHelper.BindPaged(gvrawMatDetails, Nothing)
        End If
    End Sub

    ''' <summary>One SP call for the labels of every Berger code already saved on the rows about to be shown (lazy dropdown shows only those).
    ''' Modified-by MUKESH BHAGAT 30-10-2026: replaces the full item list that used to be loaded into every row.</summary>
    Private Sub LoadSavedBergerNames(ByVal rows As DataTable)
        savedBergerNames.Clear()
        If rows Is Nothing Then Exit Sub
        Dim codes As New List(Of String)()
        For Each r As DataRow In rows.Rows
            Dim c As String = GetRowColumnValue(r, "BergerCode", "Berger_Code", "berger_Code", "berger_code")
            If c <> "" AndAlso Not codes.Contains(c, StringComparer.OrdinalIgnoreCase) Then codes.Add(c)
        Next
        If codes.Count = 0 Then Exit Sub
        Try
            Dim ds As DataSet = New OPC_VendorClass().GetRmBergerItemNames(String.Join(",", codes))
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    savedBergerNames(Convert.ToString(r("prd_code")).Trim()) = Convert.ToString(r("prd_name")).Trim()
                Next
            End If
        Catch
            ' labels fall back to the bare code
        End Try
    End Sub

    Public Sub PopulateRegion()
        CheckLogin()
        Dim commonObj As New Common
        Dim RegionDS As New DataSet
        Dim RegiontypeDS As DataSet = commonObj.GetLovDetails(userInfo.userCompanyEntity, "SUBMIT_STATUS", Constant.Common.ActiveStatus)
        If Not (RegiontypeDS Is Nothing) Then
            ddlStatus.DataSource = RegiontypeDS
            ddlStatus.DataTextField = "Lov_Value"
            ddlStatus.DataValueField = "Lov_Code"
            ddlStatus.DataBind()
            ddlStatus.Items.Insert(0, New ListItem("Select", String.Empty))
            SelectPendingStatus()
        End If
    End Sub

    Private Sub SelectPendingStatus()
        Dim pendingItem As ListItem = ddlStatus.Items.FindByValue("Pending")
        If pendingItem Is Nothing Then
            pendingItem = ddlStatus.Items.FindByText("Pending")
        End If
        If pendingItem Is Nothing Then
            Return
        End If

        ddlStatus.ClearSelection()
        pendingItem.Selected = True
    End Sub

    Private Function GetRawMaterialSearchName() As String
        If Not String.IsNullOrWhiteSpace(txtSearchText.Text) Then
            Return txtSearchText.Text.Trim()
        End If

        Return String.Empty
    End Function

    Protected Sub gvrawMatDetails_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvrawMatDetails.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Exit Sub

        Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
        If rowView Is Nothing Then Exit Sub

        Dim hdnId As HiddenField = TryCast(e.Row.FindControl("hdnId"), HiddenField)
        If hdnId IsNot Nothing Then
            hdnId.Value = GetRowColumnValue(rowView.Row, "id", "Id", "link_id")
        End If

        Dim hdnBergerCode As HiddenField = TryCast(e.Row.FindControl("hdnBergerCode"), HiddenField)
        If hdnBergerCode Is Nothing Then Exit Sub
        hdnBergerCode.Value = GetRowColumnValue(rowView.Row, "BergerCode", "Berger_Code", "berger_Code", "berger_code")   ' the <select> itself is rendered in PreRender

        Dim chkBergerNotSold As CheckBox = TryCast(e.Row.FindControl("chkBergerNotSold"), CheckBox)
        If chkBergerNotSold IsNot Nothing Then
            Dim notSaleFlag As String = GetRowColumnValue(rowView.Row, "berger_not_sale_flag", "rmm_berger_not_sale_flag")
            chkBergerNotSold.Checked = notSaleFlag.Equals("N", StringComparison.OrdinalIgnoreCase)
        End If
    End Sub

    Private Function GetRowColumnValue(ByVal row As DataRow, ByVal ParamArray columnNames As String()) As String
        For Each columnName As String In columnNames
            If row.Table.Columns.Contains(columnName) AndAlso Not IsDBNull(row(columnName)) Then
                Return Convert.ToString(row(columnName)).Trim()
            End If
        Next

        Return String.Empty
    End Function

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        Dim obj As New OPC_VendorClass()
        Dim dtDetails As DataTable
        Dim rowsAffected As Integer

        Try
            lblErrorMessage.Text = String.Empty
            valGrid.Text = String.Empty

            If Not ValidateSubmitInputs() Then
                Return
            End If

            dtDetails = BuildCodeLinkingDetailTable()
            rowsAffected = obj.InsertUpdateRawmaterialBergerCodeLinking(userInfo.userIDEntity, dtDetails)

            If rowsAffected > 0 Then
                BindData()
                RmActionPopup.ShowSuccess(Me, "Berger code linking saved successfully.")
            Else
                valGrid.Text = "Unable to save Berger code linking."
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
    End Sub

    'Private Function ValidateSubmitInputs() As Boolean
    '    valGrid.Text = String.Empty

    '    If gvrawMatDetails.Rows.Count = 0 Then
    '        valGrid.Text = "No raw material records available to submit."
    '        Return False
    '    End If

    '    Dim hasBergerCode As Boolean = False
    '    For Each gridRow As GridViewRow In gvrawMatDetails.Rows
    '        If gridRow.RowType <> DataControlRowType.DataRow Then
    '            Continue For
    '        End If

    '        Dim ddlBergerCode As DropDownList = TryCast(gridRow.FindControl("ddlBergerCode"), DropDownList)
    '        If ddlBergerCode IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(ddlBergerCode.SelectedValue) Then
    '            hasBergerCode = True
    '            Exit For
    '        End If
    '    Next

    '    If Not hasBergerCode Then
    '        valGrid.Text = "Please select Berger code for at least one raw material."
    '        Return False
    '    End If

    '    Return True
    'End Function

    Private Function ValidateSubmitInputs() As Boolean
        valGrid.Text = String.Empty

        If gvrawMatDetails.Rows.Count = 0 Then
            valGrid.Text = "No raw material records available to submit."
            Return False
        End If

        Dim hasValue As Boolean = False
        For Each gridRow As GridViewRow In gvrawMatDetails.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim chkBergerNotSold As CheckBox = TryCast(gridRow.FindControl("chkBergerNotSold"), CheckBox)
            Dim hdnBergerCode As HiddenField = TryCast(gridRow.FindControl("hdnBergerCode"), HiddenField)
            If chkBergerNotSold IsNot Nothing AndAlso chkBergerNotSold.Checked Then
                hasValue = True
                Exit For
            End If
            If hdnBergerCode IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(hdnBergerCode.Value) Then
                hasValue = True
                Exit For
            End If
        Next

        If Not hasValue Then
            valGrid.Text = "Please select Berger code for at least one raw material."
            Return False
        End If

        Return True
    End Function

    'Private Function BuildCodeLinkingDetailTable() As DataTable
    '    Dim dtDetails As New DataTable()
    '    dtDetails.Columns.Add(New DataColumn("id", GetType(String)))
    '    dtDetails.Columns.Add(New DataColumn("raw_mat_code", GetType(String)))
    '    dtDetails.Columns.Add(New DataColumn("berger_code", GetType(String)))

    '    For Each gridRow As GridViewRow In gvrawMatDetails.Rows
    '        If gridRow.RowType <> DataControlRowType.DataRow Then
    '            Continue For
    '        End If

    '        Dim hdnId As HiddenField = TryCast(gridRow.FindControl("hdnId"), HiddenField)
    '        Dim hdnRawMatCode As HiddenField = TryCast(gridRow.FindControl("hdnrawmatcode"), HiddenField)
    '        Dim ddlBergerCode As DropDownList = TryCast(gridRow.FindControl("ddlBergerCode"), DropDownList)
    '        If hdnRawMatCode Is Nothing OrElse ddlBergerCode Is Nothing Then
    '            Continue For
    '        End If

    '        Dim rawMatCode As String = Convert.ToString(hdnRawMatCode.Value).Trim()
    '        Dim bergerCode As String = Convert.ToString(ddlBergerCode.SelectedValue).Trim()
    '        If rawMatCode = String.Empty OrElse bergerCode = String.Empty Then
    '            Continue For
    '        End If

    '        Dim dr As DataRow = dtDetails.NewRow()
    '        If hdnId IsNot Nothing Then
    '            dr("id") = Convert.ToString(hdnId.Value).Trim()
    '        Else
    '            dr("id") = String.Empty
    '        End If
    '        dr("raw_mat_code") = rawMatCode
    '        dr("berger_code") = bergerCode
    '        dtDetails.Rows.Add(dr)
    '    Next

    '    dtDetails.AcceptChanges()
    '    Return dtDetails
    'End Function

    Private Function BuildCodeLinkingDetailTable() As DataTable
        Dim dtDetails As New DataTable()
        dtDetails.Columns.Add(New DataColumn("id", GetType(String)))
        dtDetails.Columns.Add(New DataColumn("raw_mat_code", GetType(String)))
        dtDetails.Columns.Add(New DataColumn("berger_code", GetType(String)))
        dtDetails.Columns.Add(New DataColumn("berger_not_sale_flag", GetType(String)))

        For Each gridRow As GridViewRow In gvrawMatDetails.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim hdnId As HiddenField = TryCast(gridRow.FindControl("hdnId"), HiddenField)
            Dim hdnRawMatCode As HiddenField = TryCast(gridRow.FindControl("hdnrawmatcode"), HiddenField)
            Dim hdnBergerCode As HiddenField = TryCast(gridRow.FindControl("hdnBergerCode"), HiddenField)
            Dim chkBergerNotSold As CheckBox = TryCast(gridRow.FindControl("chkBergerNotSold"), CheckBox)
            If hdnRawMatCode Is Nothing OrElse hdnBergerCode Is Nothing OrElse chkBergerNotSold Is Nothing Then
                Continue For
            End If

            Dim rawMatCode As String = Convert.ToString(hdnRawMatCode.Value).Trim()
            If rawMatCode = String.Empty Then
                Continue For
            End If

            Dim notSold As Boolean = chkBergerNotSold.Checked
            Dim bergerCode As String = Convert.ToString(hdnBergerCode.Value).Trim()
            If Not notSold AndAlso bergerCode = String.Empty Then
                Continue For
            End If

            Dim dr As DataRow = dtDetails.NewRow()
            If hdnId IsNot Nothing Then
                dr("id") = Convert.ToString(hdnId.Value).Trim()
            Else
                dr("id") = String.Empty
            End If
            dr("raw_mat_code") = rawMatCode
            If notSold Then
                dr("berger_code") = DBNull.Value
                dr("berger_not_sale_flag") = "N"
            Else
                dr("berger_code") = bergerCode
                dr("berger_not_sale_flag") = "Y"
            End If
            dtDetails.Rows.Add(dr)
        Next

        dtDetails.AcceptChanges()
        Return dtDetails
    End Function

    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        txtSearchText.Text = String.Empty
        txtBergerCodeSearch.Text = String.Empty
        txtrawmatid.Value = String.Empty
        lblErrorMessage.Text = String.Empty
        valSearchText.Text = String.Empty
        valGrid.Text = String.Empty
        ddlItemType.SelectedIndex = 0
        SelectPendingStatus()
        BindData()
    End Sub
End Class
