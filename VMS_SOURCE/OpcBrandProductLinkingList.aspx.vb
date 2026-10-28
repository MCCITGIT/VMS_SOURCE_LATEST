Imports System.Data
Imports VMS.Web

Partial Class OpcBrandProductLinkingList
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateVendorList()
            BindData()
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub BindData()
        Try
            Dim obj As New POLinkingRequestClass()
            Dim ds As DataSet = obj.GetBrandProductLinkList(ddlBrand.SelectedValue)
            RmGridHelper.BindPaged(gvBrandLinks, ds)
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Private Sub PopulateVendorList()
        Dim obj As New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetBrandProductList()

        ddlBrand.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlBrand.DataSource = ds.Tables(0)
            ddlBrand.DataTextField = "brand_name"
            ddlBrand.DataValueField = "brand_id"
            ddlBrand.DataBind()
        End If
        ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Protected Sub lbBtnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        gvBrandLinks.PageIndex = 0
        BindData()
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("~/OpcBrandProductLinking.aspx")
    End Sub

    Protected Sub gvBrandLinks_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "EditLink" Then
            Return
        End If

        Dim brandId As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), brandId) Then
            Return
        End If

        Response.Redirect("~/OpcBrandProductLinking.aspx?BrandId=" & brandId.ToString(), False)
        Context.ApplicationInstance.CompleteRequest()
    End Sub

    Protected Sub gvBrandLinks_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvBrandLinks.PageIndexChanging
        gvBrandLinks.PageIndex = e.NewPageIndex
        BindData()
    End Sub
End Class
