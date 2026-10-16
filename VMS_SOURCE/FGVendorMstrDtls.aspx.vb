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
    End Sub
#End Region

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function VendorSearch(ByVal prefixText As String) As String()
        Dim vendorDetails As List(Of String) = New List(Of String)()

        If String.IsNullOrWhiteSpace(prefixText) OrElse prefixText.Trim().Length < 3 Then
            Return vendorDetails.ToArray()
        End If

        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.RFQ_Vendor_List(prefixText)
            Dim searchText As String = prefixText.Trim()

            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso Not ds.Tables(0) Is Nothing Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    Dim vendorId As String = Convert.ToString(dr("vendor_id")).Trim()
                    Dim vendorName As String = Convert.ToString(dr("vendor_name")).Trim()

                    If vendorId <> "" AndAlso vendorName <> "" AndAlso (vendorName.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0 OrElse vendorId.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0) Then
                        vendorDetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(vendorName, vendorId))
                        If vendorDetails.Count >= 20 Then
                            Exit For
                        End If
                    End If
                Next
            End If
        Catch ex As Exception
        End Try

        Return vendorDetails.ToArray()
    End Function

    Protected Sub btnLoadVendor_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(hdnVendorId.Value) Then
            ClearVendorDetails()
            Return
        End If

        Dim vendorId As Integer
        If Not Integer.TryParse(hdnVendorId.Value.Trim(), vendorId) Then
            ClearVendorDetails()
            'Return
        End If

        Dim obj As New OPC_VendorClass
        Dim ds As DataSet = obj.Get_FG_Vendor_dtlsList(vendorId)

        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            txtLine1.Text = ds.Tables(0).Rows(0)("address1").ToString()
            txtLine2.Text = ds.Tables(0).Rows(0)("address2").ToString()
            txtCity.Text = ds.Tables(0).Rows(0)("city").ToString()
            txtState.Text = ds.Tables(0).Rows(0)("state").ToString()
            txtdistrict.Text = ds.Tables(0).Rows(0)("district").ToString()
            txtPin.Text = ds.Tables(0).Rows(0)("pincode").ToString()
            PopulatesSiteId()
        Else
            ClearVendorDetails()
        End If
    End Sub

    Private Sub ClearVendorDetails()
        txtLine1.Text = String.Empty
        txtLine2.Text = String.Empty
        txtCity.Text = String.Empty
        txtState.Text = String.Empty
        txtdistrict.Text = String.Empty
        txtPin.Text = String.Empty
        ddlsiteid.SelectedValue = 0
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        lblErrorMessage.Text = String.Empty
        lblConfirmMsg.Text = String.Empty

        If String.IsNullOrWhiteSpace(txtVendorSearch.Text) OrElse String.IsNullOrWhiteSpace(hdnVendorId.Value) Then
            lblErrorMessage.Text = "Please select Vendor."
            Return
        End If
        If ddlsiteid.SelectedValue = "" Then
            lblErrorMessage.Text = "Please select site."
            Return
        End If

        Dim vendorName As String = txtVendorSearch.Text.Trim()
        Dim vendorId As String = hdnVendorId.Value.Trim()
        Dim idSuffix As String = " (" & vendorId & ")"
        If vendorName.EndsWith(idSuffix, StringComparison.OrdinalIgnoreCase) Then
            vendorName = vendorName.Substring(0, vendorName.Length - idSuffix.Length).Trim()
        End If

        'Dim siteId As Long = 0
        'Long.TryParse(txtsiteid.Text.Trim(), siteId)

        Dim regionCode As String = If(userInfo.userRegionEntity, String.Empty).Trim()
        If regionCode.Length > 2 Then
            regionCode = regionCode.Substring(0, 2)
        End If

        Dim errorMessage As String = String.Empty
        Dim status As Integer = opcVenor.InsertFGVendor(
            If(userInfo.userCompanyEntity, String.Empty).Trim(),
            vendorName,
            regionCode,
            txtLine1.Text.Trim(),
            txtLine2.Text.Trim(),
            String.Empty,
            txtState.Text.Trim(),
            txtCity.Text.Trim(),
            txtPin.Text.Trim(),
            hdnVendorId.Value.Trim(),
            ddlsiteid.SelectedValue.ToString(),
            ddlsiteid.Text.ToString(),
            userInfo.userIDEntity,
            errorMessage)

        If status = 1 Then
            RmActionPopup.ShowSuccess(Me, "Submitted Successfully.", ResolveClientUrl("~/FG_VendorMstrList.aspx"))
        Else
            lblErrorMessage.Text = ""
            RmActionPopup.ShowError(Me, If(String.IsNullOrWhiteSpace(errorMessage), "Unable to save.", errorMessage))
        End If
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/FG_VendorMstrList.aspx", False)
        Context.ApplicationInstance.CompleteRequest()
    End Sub
    Private Sub PopulatesSiteId()
        Dim oVendorFunction As New OPC_VendorClass
        Dim vendorSet As DataSet = oVendorFunction.SiteDetailsList(Convert.ToInt32(hdnVendorId.Value))

        ddlsiteid.Items.Clear()
        If (Not (vendorSet Is Nothing) AndAlso vendorSet.Tables.Count > 0 AndAlso Not (vendorSet.Tables(0) Is Nothing) AndAlso vendorSet.Tables(0).Rows.Count > 0) Then
            ddlsiteid.DataSource = vendorSet.Tables(0)
            ddlsiteid.DataTextField = "site_code"
            ddlsiteid.DataValueField = "site_id"
            ddlsiteid.DataBind()
        End If
        ddlsiteid.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub
End Class
