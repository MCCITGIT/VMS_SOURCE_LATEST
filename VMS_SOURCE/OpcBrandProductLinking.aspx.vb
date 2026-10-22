Imports System.Collections.Generic
Imports System.Data
Imports VMS.Web

Partial Class OpcBrandProductLinking
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const ProductVertical As String = "RETAIL"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        Page.MaintainScrollPositionOnPostBack = True

        If Not IsPostBack Then
            PopulateBrand()
            PopulateProduct()
            BindLinks()
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateBrand()
        Dim obj As New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetBrandProductLinkBrands()

        ddlBrand.Items.Clear()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
            ddlBrand.DataSource = ds.Tables(0)
            ddlBrand.DataTextField = "brand_name"
            ddlBrand.DataValueField = "brand_id"
            ddlBrand.DataBind()
        End If
        ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub PopulateProduct()
        Dim obj As New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetBrandProductLinkProducts()

        ddlProduct.Items.Clear()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
            ddlProduct.DataSource = ds.Tables(0)
            ddlProduct.DataTextField = "prd_name"
            ddlProduct.DataValueField = "prd_code"
            ddlProduct.DataBind()
        End If
    End Sub

    Private Function GetLinks() As DataTable
        Dim dt As DataTable = TryCast(ViewState("BrandProductLinks"), DataTable)

        If dt Is Nothing Then
            dt = New DataTable()
            dt.Columns.Add("BrandId", GetType(String))
            dt.Columns.Add("BrandName", GetType(String))
            dt.Columns.Add("ProductName", GetType(String))
            dt.Columns.Add("PrdCode", GetType(String))
            dt.Columns.Add("PrdSbl", GetType(String))
            ViewState("BrandProductLinks") = dt
        End If

        Return dt
    End Function

    Private Sub BindLinks()
        gvLinks.DataSource = GetLinks()
        gvLinks.DataBind()
    End Sub

    Private Sub ClearFieldErrors()
        ddlBrand.CssClass = "form-control select2"
        ddlProduct.CssClass = "form-control select2"
        valBrand.Text = String.Empty
        valProduct.Text = String.Empty
        valGrid.Text = String.Empty
    End Sub

    Private Sub SetFieldError(ByVal control As WebControl, ByVal messageLabel As Label, ByVal message As String)
        If control.CssClass.IndexOf("field-invalid", StringComparison.OrdinalIgnoreCase) < 0 Then
            control.CssClass = (control.CssClass & " field-invalid").Trim()
        End If
        messageLabel.Text = message
    End Sub

    Private Sub ShowMessage(ByVal message As String, ByVal isSuccess As Boolean)
        lblMessage.Text = message
        lblMessage.ForeColor = If(isSuccess, System.Drawing.Color.Green, System.Drawing.Color.Red)
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs)
        ClearFieldErrors()
        lblMessage.Text = String.Empty

        Dim brandId As String = ddlBrand.SelectedValue.Trim()

        If String.IsNullOrWhiteSpace(brandId) Then
            SetFieldError(ddlBrand, valBrand, "Please select a brand.")
            Return
        End If

        Dim selectedProducts As New List(Of ListItem)()
        For Each item As ListItem In ddlProduct.Items
            If item.Selected AndAlso Not String.IsNullOrWhiteSpace(item.Value) Then
                selectedProducts.Add(item)
            End If
        Next

        If selectedProducts.Count = 0 Then
            SetFieldError(ddlProduct, valProduct, "Please select at least one product.")
            Return
        End If

        Dim dt As DataTable = GetLinks()
        Dim addedCount As Integer = 0
        Dim skippedCount As Integer = 0

        For Each item As ListItem In selectedProducts
            Dim prdCode As String = item.Value.Trim()
            Dim alreadyAdded As Boolean = False

            For Each existing As DataRow In dt.Rows
                If String.Equals(Convert.ToString(existing("BrandId")), brandId, StringComparison.OrdinalIgnoreCase) AndAlso
                   String.Equals(Convert.ToString(existing("PrdSbl")), ProductVertical, StringComparison.OrdinalIgnoreCase) AndAlso
                   String.Equals(Convert.ToString(existing("PrdCode")), prdCode, StringComparison.OrdinalIgnoreCase) Then
                    alreadyAdded = True
                    Exit For
                End If
            Next

            If alreadyAdded Then
                skippedCount += 1
                Continue For
            End If

            Dim row As DataRow = dt.NewRow()
            row("BrandId") = brandId
            row("BrandName") = ddlBrand.SelectedItem.Text
            row("ProductName") = item.Text
            row("PrdCode") = prdCode
            row("PrdSbl") = ProductVertical
            dt.Rows.Add(row)
            addedCount += 1
        Next

        If addedCount = 0 Then
            SetFieldError(ddlProduct, valProduct, "Selected product(s) are already in the list.")
            Return
        End If

        ViewState("BrandProductLinks") = dt
        ddlProduct.ClearSelection()
        BindLinks()

        If skippedCount > 0 Then
            valProduct.Text = skippedCount.ToString() & " product(s) were already in the list and were not added again."
        End If
    End Sub

    Protected Sub gvLinks_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "RemoveLink" Then
            Return
        End If

        Dim index As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), index) Then
            Return
        End If

        Dim dt As DataTable = GetLinks()
        If index >= 0 AndAlso index < dt.Rows.Count Then
            dt.Rows.RemoveAt(index)
            ViewState("BrandProductLinks") = dt
            BindLinks()
        End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As EventArgs)
        CheckLogin()
        ClearFieldErrors()
        lblMessage.Text = String.Empty

        Dim dt As DataTable = GetLinks()
        If dt.Rows.Count = 0 Then
            valGrid.Text = "Add at least one brand and product link."
            Return
        End If

        Dim saveTable As DataTable = New DataTable()
        saveTable.Columns.Add("brand_id", GetType(Integer))
        saveTable.Columns.Add("prd_sbl", GetType(String))
        saveTable.Columns.Add("prd_code", GetType(String))

        For Each link As DataRow In dt.Rows
            Dim saveRow As DataRow = saveTable.NewRow()
            saveRow("brand_id") = Convert.ToInt32(link("BrandId"))
            saveRow("prd_sbl") = Convert.ToString(link("PrdSbl"))
            saveRow("prd_code") = Convert.ToString(link("PrdCode"))
            saveTable.Rows.Add(saveRow)
        Next

        Try
            Dim obj As New POLinkingRequestClass()
            Dim ds As DataSet = obj.InsertBrandProductLinks(userInfo.userIDEntity, saveTable)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim status As Integer = Convert.ToInt32(ds.Tables(0).Rows(0)("status"))
                Dim message As String = Convert.ToString(ds.Tables(0).Rows(0)("message"))

                If status = 1 Then
                    ViewState.Remove("BrandProductLinks")
                    ddlBrand.SelectedIndex = 0
                    ddlProduct.ClearSelection()
                    BindLinks()
                    ShowMessage(message, True)
                Else
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
        ViewState.Remove("BrandProductLinks")
        ClearFieldErrors()
        lblMessage.Text = String.Empty
        If ddlBrand.Items.Count > 0 Then
            ddlBrand.SelectedIndex = 0
        End If
        ddlProduct.ClearSelection()
        BindLinks()
    End Sub
End Class
