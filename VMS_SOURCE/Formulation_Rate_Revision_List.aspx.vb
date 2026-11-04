Imports System.Data
Imports VMS.Web

Partial Class Formulation_Rate_Revision_List
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

    Private Function IsUnitUser() As Boolean
        Return userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT
    End Function

    Private Function OwnUnitCode() As String
        Return Convert.ToString(userInfo.userBranchEntity).Trim()
    End Function

    Private Sub PopulateVendorList()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem("All", String.Empty, True))

        If IsUnitUser() Then
            Dim own As String = OwnUnitCode()
            If ddlVendor.Items.FindByValue(own) IsNot Nothing Then
                ddlVendor.SelectedValue = own
            End If
            ddlVendor.Enabled = False
            colVendorFilter.Visible = False
        End If
    End Sub

    Private Sub BindData()
        Try
            Dim obj As New OPC_VendorClass()
            Dim vendorCode As String = If(IsUnitUser(), OwnUnitCode(), ddlVendor.SelectedValue)
            Dim ds As DataSet = obj.GetFormulationRateRevisionList(vendorCode)
            RmGridHelper.BindPaged(gvFormulation, ds)
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        gvFormulation.PageIndex = 0
        BindData()
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Formulation_Rate_Revision.aspx")
    End Sub

End Class
