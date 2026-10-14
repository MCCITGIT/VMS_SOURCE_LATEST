Imports System.Data
Imports VMS.Web

Partial Class RawMaterialPoEntryList
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()

        If Not IsPostBack Then
            PopulateVendorList()
            BindPoList()
        End If
    End Sub
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateVendorList()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetRawMaterialVendorList()

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub BindPoList()
        Dim obj As New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetRawMaterialPoList(ddlVendor.SelectedValue)
        RmGridHelper.BindPaged(gvPoList, RmGridHelper.GetTable(ds))
    End Sub

    Protected Sub lbBtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntry.aspx")
    End Sub

    Protected Sub lbBtnSearch_Click(sender As Object, e As EventArgs)
        gvPoList.PageIndex = 0
        BindPoList()
    End Sub

    Protected Sub gvPoList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvPoList.PageIndex = e.NewPageIndex
        BindPoList()
    End Sub
End Class
