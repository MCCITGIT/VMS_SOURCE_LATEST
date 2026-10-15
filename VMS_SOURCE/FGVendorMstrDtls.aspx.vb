Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Partial Class FGVendorMstrDtls
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Public UnitCode As String
    Dim opcVenor As New OPC_VendorClass
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
#Region "Page Load Event Handler"
    'Page load event handler occurs at the time of page and page post back
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateVendor()
        End If
    End Sub
#End Region
#Region "VendorPopulate"
    Public Sub PopulateVendor()

        Dim Obj As New OPC_VendorClass
        Dim DS As New DataSet

        DS = Obj.RFQ_Vendor_List()

        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = DS.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_id"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub
#End Region
    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim Obj As New OPC_VendorClass
        Dim DS As New DataSet

        DS = Obj.Get_FG_Vendor_dtlsList(ddlVendor.SelectedValue.ToString())
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            txtUnitName.Text = DS.Tables(0).Rows(0)("vendor_name").ToString()
            txtLine1.Text = DS.Tables(0).Rows(0)("address1").ToString()
            txtLine2.Text = DS.Tables(0).Rows(0)("address2").ToString()
            txtLine3.Text = DS.Tables(0).Rows(0)("address3").ToString()
            txtLine4.Text = DS.Tables(0).Rows(0)("address4").ToString()
            txtCity.Text = DS.Tables(0).Rows(0)("city").ToString()
            txtState.Text = DS.Tables(0).Rows(0)("state").ToString()
            txtdistrict.Text = DS.Tables(0).Rows(0)("district").ToString()
            txtPin.Text = DS.Tables(0).Rows(0)("pincode").ToString()
            txtsiteid.Text = DS.Tables(0).Rows(0)("siteid").ToString()
            txtsitecode.Text = DS.Tables(0).Rows(0)("sitecode").ToString()
        End If
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        lblErrorMessage.Text = String.Empty
        lblConfirmMsg.Text = String.Empty

        If ddlVendor.SelectedIndex <= 0 OrElse String.IsNullOrWhiteSpace(ddlVendor.SelectedValue) Then
            lblErrorMessage.Text = "Please select Vendor."
            Return
        End If

        If String.IsNullOrWhiteSpace(txtUnitName.Text) Then
            lblErrorMessage.Text = "Please enter Name."
            Return
        End If

        Dim siteId As Long = 0
        Long.TryParse(txtsiteid.Text.Trim(), siteId)

        Dim regionCode As String = If(userInfo.userRegionEntity, String.Empty).Trim()
        If regionCode.Length > 2 Then
            regionCode = regionCode.Substring(0, 2)
        End If

        Dim errorMessage As String = String.Empty
        Dim status As Integer = opcVenor.InsertFGVendor(
            If(userInfo.userCompanyEntity, String.Empty).Trim(),
            txtUnitName.Text.Trim(),
            regionCode,
            txtLine1.Text.Trim(),
            txtLine2.Text.Trim(),
            txtLine3.Text.Trim(),
            txtState.Text.Trim(),
            txtCity.Text.Trim(),
            txtPin.Text.Trim(),
            ddlVendor.SelectedValue.Trim(),
            siteId,
            txtsitecode.Text.Trim(),
            userInfo.userIDEntity,
            errorMessage)

        If status = 1 Then
            RmActionPopup.ShowSuccess(Me, "Submitted Successfully.", ResolveClientUrl("~/FG_VendorMstrList.aspx"))
        Else
            lblErrorMessage.Text = ""
            RmActionPopup.ShowError(Me, If(String.IsNullOrWhiteSpace(errorMessage), "Unable to save.", errorMessage))
        End If
    End Sub
End Class
