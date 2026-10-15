Imports System.Data
Imports VMS.Web

''' <summary>
''' Product Rate Approval list - SKU formulations under negotiation (default), approved releases, or
''' everything; links to the history page and to the formulation (HO approves there).
''' A UNIT user sees only its own vendor. Added by MUKESH BHAGAT on 12-Oct-2026.
''' </summary>
Partial Class Product_Rate_Approval_List
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            LoadBrands()
            LoadVendors()
            Binddata()
        End If
    End Sub

    Private Sub CheckLogin()
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
    End Sub

    Private Function IsUnitUser() As Boolean
        Return userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT
    End Function

    Private Sub LoadBrands()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.BindBrandMasterList()
        ddlBrand.Items.Clear()
        ddlBrand.Items.Add(New ListItem(Constant.Common.Selec, ""))
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each dr As DataRow In ds.Tables(0).Rows
                ddlBrand.Items.Add(New ListItem(Convert.ToString(dr("brand_name")), Convert.ToString(dr("brand_id"))))
            Next
        End If
    End Sub

    Private Sub LoadVendors()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)
        ddlvendor.Items.Clear()
        ddlvendor.Items.Add(New ListItem(Constant.Common.Selec, ""))
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each dr As DataRow In ds.Tables(0).Rows
                ddlvendor.Items.Add(New ListItem(Convert.ToString(dr("unit_name")), Convert.ToString(dr("unit_code"))))
            Next
        End If
        If IsUnitUser() Then
            Dim own As String = Convert.ToString(userInfo.userBranchEntity).Trim()
            If ddlvendor.Items.FindByValue(own) IsNot Nothing Then ddlvendor.SelectedValue = own
            ddlvendor.Enabled = False
        End If
    End Sub

    Private Sub Binddata()
        Try
            ' a unit (vendor) user only ever lists its own vendor's formulations
            Dim vendor As String = If(IsUnitUser(), Convert.ToString(userInfo.userBranchEntity).Trim(), ddlvendor.SelectedValue)
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.ListSkuFormulation(ddlBrand.SelectedValue, vendor, "", "N", ddlView.SelectedValue)
            gvList.DataSource = If(ds IsNot Nothing AndAlso ds.Tables.Count > 0, ds.Tables(0), Nothing)
            gvList.DataBind()
            lblErrorMessage.Text = ""
        Catch ex As Exception
            gvList.DataSource = Nothing
            gvList.DataBind()
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        gvList.PageIndex = 0
        Binddata()
    End Sub

    Protected Sub gvList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvList.PageIndex = e.NewPageIndex
        Binddata()
    End Sub
End Class
