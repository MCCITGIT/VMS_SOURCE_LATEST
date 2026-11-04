Imports System.Data
Imports VMS.Web

Partial Class OpcRawMaterialCreationList
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

    Private Sub BindData()
        Try
            Dim obj As New OPC_VendorClass()
            Dim unitCode As String = If(IsUnitUser(), OwnUnitCode(), ddlVendor.SelectedValue)
            Dim ds As DataSet = obj.GetOpcRawMaterialCreationList(unitCode, txtSearch.Text, ddlItemType.SelectedValue)
            RmGridHelper.BindPaged(gvRmList, ds)
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub

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
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

        If IsUnitUser() Then
            Dim own As String = OwnUnitCode()
            If ddlVendor.Items.FindByValue(own) IsNot Nothing Then
                ddlVendor.SelectedValue = own
            End If
            ddlVendor.Enabled = False
            colVendorFilter.Visible = False
        End If
    End Sub

    Protected Sub lbBtnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        gvRmList.PageIndex = 0
        BindData()
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("~/OpcRawMaterialCreation.aspx")
    End Sub

    Protected Sub gvRmList_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "EditRm" Then
            Return
        End If

        Dim rmCode As String = Convert.ToString(e.CommandArgument).Trim()
        If String.IsNullOrWhiteSpace(rmCode) Then
            Return
        End If

        Response.Redirect("~/OpcRawMaterialCreation.aspx?RmCode=" & Server.UrlEncode(rmCode), False)
        Context.ApplicationInstance.CompleteRequest()
    End Sub

    ''' <summary>Packaging items belong to the vendor (02-11-2026): an HO login sees them but gets no edit link.</summary>
    Protected Sub gvRmList_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType <> DataControlRowType.DataRow Then Return
        Dim hdn As HiddenField = TryCast(e.Row.FindControl("hdnItemType"), HiddenField)
        Dim edit As LinkButton = TryCast(e.Row.FindControl("btnEdit"), LinkButton)
        If hdn IsNot Nothing AndAlso edit IsNot Nothing AndAlso hdn.Value.Trim().ToUpperInvariant() = "PKG" AndAlso Not IsUnitUser() Then edit.Visible = False
    End Sub

    Protected Sub gvRmList_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvRmList.PageIndexChanging
        gvRmList.PageIndex = e.NewPageIndex
        BindData()
    End Sub
End Class
