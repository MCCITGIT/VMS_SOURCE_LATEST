Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Collections.Generic
Partial Class FormulationMstrList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()

        If Not IsPostBack Then
            BindDropdown()
            Binddata()
        End If
    End Sub
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub BindDropdown()
        BrandDetailsListLoad()
        VendorDetailsListLoad()
        RawMaterialListLoad()
    End Sub

    Private Sub BrandDetailsListLoad()
        Dim ds As DataSet
        Dim obj As New OPC_VendorClass()
        ds = obj.BindBrandMasterList()

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

                    If productName <> "" AndAlso productCode <> "" Then
                        productDetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(productName, productCode))
                    End If
                Next
            End If
        Catch ex As Exception
            ' Keep autocomplete resilient; return collected items.
        End Try

        Return productDetails.ToArray()
    End Function
    Private Sub RawMaterialListLoad()
        Dim ds As DataSet
        Dim obj As New OPC_VendorClass()
        ds = obj.GetRawMaterial()

        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
            If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlRawMat.DataSource = ds
                ddlRawMat.DataTextField = "Raw_Mat_Name"
                ddlRawMat.DataValueField = "Raw_Mat_Code"
                ddlRawMat.DataBind()
            Else
                ddlRawMat.DataSource = Nothing
                ddlRawMat.DataBind()
            End If
            ddlRawMat.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub
    Private Sub Binddata()
        Dim ds As DataSet
        Dim obj As New OPC_VendorClass()
        ' V2 (MUKESH BHAGAT 09-Oct-2026): versioned SKU formulation list - current versions only; columns aliased for the existing grid
        ds = obj.ListSkuFormulation(ddlBrand.SelectedValue, ddlvendor.SelectedValue, hdnProductCode.Value, "N")

        Dim table As DataTable = RmGridHelper.GetTable(ds)
        If table IsNot Nothing Then
            Dim map As New Dictionary(Of String, String) From {{"sf_id", "fh_id"}, {"brand_name", "Brand_Name"}, {"sf_brand_code", "Brand_Code"}, {"sf_vendor_code", "vendor_code"}, {"sf_product_code", "Sku_Code"}, {"product_name", "Sku_Desc"}}
            For Each kv In map
                If table.Columns.Contains(kv.Key) AndAlso Not table.Columns.Contains(kv.Value) Then table.Columns(kv.Key).ColumnName = kv.Value
            Next
        End If
        RmGridHelper.BindPaged(gvFormulationList, table)
        UpdateSummary(table)
    End Sub

    Private Sub UpdateSummary(ByVal sourceTable As DataTable)
        Dim totalCount As Integer = 0
        Dim brandCount As Integer = 0
        Dim skuCount As Integer = 0

        If sourceTable IsNot Nothing Then
            totalCount = sourceTable.Rows.Count
            Dim brands As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
            Dim skus As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
            Dim brandColumn As String = If(sourceTable.Columns.Contains("Brand_Code"), "Brand_Code", If(sourceTable.Columns.Contains("Brand_Name"), "Brand_Name", String.Empty))
            Dim skuColumn As String = If(sourceTable.Columns.Contains("Sku_Code"), "Sku_Code", If(sourceTable.Columns.Contains("Sku_Desc"), "Sku_Desc", String.Empty))

            For Each row As DataRow In sourceTable.Rows
                If brandColumn <> "" Then
                    Dim brandValue As String = Convert.ToString(row(brandColumn)).Trim()
                    If brandValue <> "" Then
                        brands.Add(brandValue)
                    End If
                End If
                If skuColumn <> "" Then
                    Dim skuValue As String = Convert.ToString(row(skuColumn)).Trim()
                    If skuValue <> "" Then
                        skus.Add(skuValue)
                    End If
                End If
            Next

            brandCount = brands.Count
            skuCount = skus.Count
        End If

        'lblTotalCount.Text = totalCount.ToString()
        'lblBrandCount.Text = brandCount.ToString()
        'lblSkuCount.Text = skuCount.ToString()
    End Sub
    Protected Sub gvFormulationList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFormulationList.RowCommand
        Try
            If e.CommandName = "View" Then
                Dim row As GridViewRow = Nothing
                Dim clickedControl As Control = TryCast(e.CommandSource, Control)
                If Not clickedControl Is Nothing Then
                    row = TryCast(clickedControl.NamingContainer, GridViewRow)
                End If

                If row Is Nothing Then
                    Dim rowIndex As Integer = 0
                    If Integer.TryParse(Convert.ToString(e.CommandArgument), rowIndex) AndAlso rowIndex >= 0 AndAlso rowIndex < gvFormulationList.Rows.Count Then
                        row = gvFormulationList.Rows(rowIndex)
                    End If
                End If

                If row Is Nothing Then
                    Throw New Exception("Unable to determine selected row.")
                End If

                Dim hdnBrandCode As HiddenField = CType(row.FindControl("hdnbrandcode"), HiddenField)
                'Dim hdnRawCode As HiddenField = CType(row.FindControl("hdnRawCode"), HiddenField)
                Dim hdnSkuCode As HiddenField = CType(row.FindControl("hdnskucode"), HiddenField)
                Dim hdnid As HiddenField = CType(row.FindControl("hdnid"), HiddenField)

                Dim brandCode As String = If(hdnBrandCode Is Nothing, String.Empty, Convert.ToString(hdnBrandCode.Value))
                ' Dim rawCode As String = If(hdnRawCode Is Nothing, String.Empty, Convert.ToString(hdnRawCode.Value))
                Dim produCode As String = If(hdnSkuCode Is Nothing, String.Empty, Convert.ToString(hdnSkuCode.Value))
                Dim id As String = If(hdnid Is Nothing, String.Empty, Convert.ToString(hdnid.Value))

                'Dim redirectUrl = "FormulationMaster.aspx?brandcode=" & Server.UrlEncode(brandCode) & "&rawcode=" & Server.UrlEncode(rawCode) & "&producode=" & Server.UrlEncode(produCode)
                Dim redirectUrl = "Product_Formulation.aspx?id=" & Server.UrlEncode(id)     ' id = sf_id of the current version
                Response.Redirect(redirectUrl, False)
                Context.ApplicationInstance.CompleteRequest()
                Exit Sub
            End If
        Catch ex As System.Threading.ThreadAbortException
            ' Ignore redirect thread-abort behavior.
        Catch ex As Exception
            Dim returnUrl As String = "~/XP_ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            Response.Redirect(returnUrl)
        End Try
    End Sub
    Protected Sub ImgbtnAdd_Click(sender As Object, e As EventArgs) Handles ImgbtnAdd.Click
        'Response.Redirect("~/FormulationMaster.aspx")
        Response.Redirect("~/Product_Formulation.aspx")
    End Sub
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        gvFormulationList.PageIndex = 0
        Binddata()
    End Sub
    Protected Sub gvFormulationList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvFormulationList.PageIndexChanging
        gvFormulationList.PageIndex = e.NewPageIndex
        Binddata()
    End Sub
    Private Sub VendorDetailsListLoad()
        Dim ds As DataSet
        Dim obj As New OPC_VendorClass()
        ds = obj.GetUnitName(Constant.Common.ActiveStatus)

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
End Class
