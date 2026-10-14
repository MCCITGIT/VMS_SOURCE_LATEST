Imports System.Data
Imports VMS.Web

''' <summary>
''' Product Rate Approval list - SKU formulations under negotiation (default), approved releases, or
''' everything; links to the history page and to the formulation (HO approves there).
''' A UNIT user sees only the suppliers it declared a scope for (formulations belong to the supplier). Added by MUKESH BHAGAT on 12-Oct-2026.
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
        Dim ds As DataSet = obj.GetRawMaterialVendorList()      ' suppliers
        Dim allowed As HashSet(Of String) = If(IsUnitUser(), obj.GetUserScopeSuppliers(userInfo.userIDEntity), Nothing)
        ddlvendor.Items.Clear()
        ddlvendor.Items.Add(New ListItem(Constant.Common.Selec, ""))
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
            For Each dr As DataRow In ds.Tables(0).Rows
                Dim code As String = Convert.ToString(dr("vendor_code")).Trim()
                If allowed Is Nothing OrElse allowed.Contains(code) Then ddlvendor.Items.Add(New ListItem(Convert.ToString(dr("vendor_name")), code))
            Next
        End If
    End Sub

    Private Sub Binddata()
        Try
            ' a unit (vendor) user only ever lists the suppliers it declared a scope for
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.ListSkuFormulation(ddlBrand.SelectedValue, ddlvendor.SelectedValue, "", "N", ddlView.SelectedValue)
            Dim table As DataTable = If(ds IsNot Nothing AndAlso ds.Tables.Count > 0, ds.Tables(0), Nothing)
            If IsUnitUser() AndAlso table IsNot Nothing Then table = FilterBySuppliers(table, obj.GetUserScopeSuppliers(userInfo.userIDEntity))
            gvList.DataSource = table
            gvList.DataBind()
            lblErrorMessage.Text = ""
        Catch ex As Exception
            gvList.DataSource = Nothing
            gvList.DataBind()
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    ''' <summary>Keeps only the rows of the given suppliers (sf_vendor_code holds the supplier code).</summary>
    Private Function FilterBySuppliers(ByVal table As DataTable, ByVal allowed As HashSet(Of String)) As DataTable
        Dim result As DataTable = table.Clone()
        For Each r As DataRow In table.Rows
            If allowed.Contains(Convert.ToString(r("sf_vendor_code")).Trim()) Then result.ImportRow(r)
        Next
        Return result
    End Function

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        gvList.PageIndex = 0
        Binddata()
    End Sub

    Protected Sub gvList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvList.PageIndex = e.NewPageIndex
        Binddata()
    End Sub
End Class
