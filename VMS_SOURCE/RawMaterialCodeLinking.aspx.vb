Imports VMS.Web
Imports System.Data
Imports System.Data.SqlClient
Partial Class RawMaterialCodeLinking
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private skuProductTable As DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateRegion()
            LoadPage()
        End If
    End Sub

    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        For Each gridRow As GridViewRow In gvrawMatDetails.Rows
            If gridRow.RowType <> DataControlRowType.DataRow Then
                Continue For
            End If

            Dim chkBergerNotSold As CheckBox = TryCast(gridRow.FindControl("chkBergerNotSold"), CheckBox)
            Dim ddlBergerCode As DropDownList = TryCast(gridRow.FindControl("ddlBergerCode"), DropDownList)
            If chkBergerNotSold Is Nothing OrElse ddlBergerCode Is Nothing Then
                Continue For
            End If

            If chkBergerNotSold.Checked Then
                ddlBergerCode.ClearSelection()
                If ddlBergerCode.Items.FindByValue(String.Empty) IsNot Nothing Then
                    ddlBergerCode.SelectedValue = String.Empty
                End If
            End If
            ddlBergerCode.Enabled = Not chkBergerNotSold.Checked
        Next
    End Sub

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
        LoadSkuProductList()

        Dim obj As New OPC_VendorClass()
        Dim rmName As String = GetRawMaterialSearchName()
        Dim bergerCode As String = txtBergerCodeSearch.Text.Trim()
        Dim status As String = ddlStatus.SelectedValue
        Dim ds As DataSet = obj.GetRawmaterialBergerCodeLinking(rmName, bergerCode, status)

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            RmGridHelper.BindPaged(gvrawMatDetails, ds.Tables(0))
        Else
            RmGridHelper.BindPaged(gvrawMatDetails, Nothing)
        End If
    End Sub

    Private Sub LoadSkuProductList()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetOpcSkuPrdCodeList()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            skuProductTable = ds.Tables(0)
        Else
            skuProductTable = Nothing
        End If
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

    Private Sub PopulateBergerCodeList(ByVal ddlBergerCode As DropDownList, ByVal selectedCode As String)
        ddlBergerCode.Items.Clear()
        If skuProductTable IsNot Nothing AndAlso skuProductTable.Rows.Count > 0 Then
            ddlBergerCode.DataSource = skuProductTable
            ddlBergerCode.DataTextField = "prd_name"
            ddlBergerCode.DataValueField = "prd_code"
            ddlBergerCode.DataBind()
        End If
        ddlBergerCode.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

        If Not String.IsNullOrWhiteSpace(selectedCode) AndAlso ddlBergerCode.Items.FindByValue(selectedCode) IsNot Nothing Then
            ddlBergerCode.SelectedValue = selectedCode
        End If
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

        Dim ddlBergerCode As DropDownList = TryCast(e.Row.FindControl("ddlBergerCode"), DropDownList)
        If ddlBergerCode Is Nothing Then Exit Sub

        Dim bergerCode As String = GetRowColumnValue(rowView.Row, "BergerCode", "Berger_Code", "berger_Code", "berger_code")
        PopulateBergerCodeList(ddlBergerCode, bergerCode)

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
            Dim ddlBergerCode As DropDownList = TryCast(gridRow.FindControl("ddlBergerCode"), DropDownList)
            If chkBergerNotSold IsNot Nothing AndAlso chkBergerNotSold.Checked Then
                hasValue = True
                Exit For
            End If
            If ddlBergerCode IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(ddlBergerCode.SelectedValue) Then
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
            Dim ddlBergerCode As DropDownList = TryCast(gridRow.FindControl("ddlBergerCode"), DropDownList)
            Dim chkBergerNotSold As CheckBox = TryCast(gridRow.FindControl("chkBergerNotSold"), CheckBox)
            If hdnRawMatCode Is Nothing OrElse ddlBergerCode Is Nothing OrElse chkBergerNotSold Is Nothing Then
                Continue For
            End If

            Dim rawMatCode As String = Convert.ToString(hdnRawMatCode.Value).Trim()
            If rawMatCode = String.Empty Then
                Continue For
            End If

            Dim notSold As Boolean = chkBergerNotSold.Checked
            Dim bergerCode As String = Convert.ToString(ddlBergerCode.SelectedValue).Trim()
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
        SelectPendingStatus()
        BindData()
    End Sub
End Class
