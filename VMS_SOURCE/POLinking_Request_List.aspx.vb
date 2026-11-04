
Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web

Partial Class POLinking_Request_List
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
#Region "Page Load Event Handler"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        Page.MaintainScrollPositionOnPostBack = True

        If userInfo.userGroupCodeEntity = "SYSADMIN" Then
            hdnPoLinkAdmin.Value = "Y"
        Else
            hdnPoLinkAdmin.Value = "N"
        End If

        If (Not IsPostBack) Then
            PopulateDepotDropdown()
            populateVendor()
            PopulateList()
        End If
    End Sub

#End Region

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#Region "PopulateVendor"
    Public Sub populateVendor()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
        Dim Obj As New QualityControlClass
        Dim DS As New DataSet
        DS = Obj.GetVendor(userInfo.userIDEntity)
        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = DS.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_code"
            ddlVendor.DataBind()
            ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            If DS.Tables(0).Rows.Count = 1 Then
                ddlVendor.SelectedIndex = 1
                ddlVendor.Enabled = False
            End If
        End If

    End Sub
#End Region

#Region "Populate Depot dropdown."

    Private Sub PopulateDepotDropdown()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim cmnDepot As New Common()
        Dim dsDepot As DataSet

        ddlDepot.Items.Clear()

        Try

            dsDepot = cmnDepot.Getdepotname(String.Empty)

            If Not (dsDepot Is Nothing) Then

                If Not (dsDepot.Tables(0).Rows.Count = 0) Then

                    ddlDepot.DataSource = dsDepot
                    ddlDepot.DataTextField = "depot_name"
                    ddlDepot.DataValueField = "depot_code"
                    ddlDepot.DataBind()

                    ddlDepot.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

                    If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.REGION) Then
                        ddlDepot.SelectedValue = userInfo.userBranchEntity
                        ddlDepot.Enabled = False
                    End If

                Else
                    ddlDepot.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If

            End If

        Catch ex As Exception

            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)

        End Try

    End Sub

#End Region

    Private Sub PopulateList()
        Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
        gvProduct.DataSource = Nothing
        gvProduct.DataBind()
        Dim ds As DataSet = New DataSet()
        ds = obj.GetPOLinkingReqList(ddlDepot.SelectedValue, ddlVendor.SelectedValue, ddlStatus.SelectedValue)

        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            gvProduct.DataSource = FirstPoLinkPage(ds.Tables(0))
            gvProduct.DataBind()
            hdnPoLinkHasData.Value = "1"
            hdnPoLinkPageSize.Value = gvProduct.PageSize.ToString()
        Else
            hdnPoLinkHasData.Value = "0"
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing)) Then
                gvProduct.DataSource = ds
                gvProduct.DataBind()
            End If
        End If
    End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs)
        PopulateList()
    End Sub

    Private Shared Function SendPoLinkMail(ByVal DepotCode As String, ByVal VendorCode As String, ByVal PONO As String, ByVal SKU As String, ByVal siteID As String, ByVal VendorID As String) As String
        Dim objemail As EmailSMSsender = New EmailSMSsender()
        Dim mailsubject As String = String.Empty
        Dim mailBody As String = String.Empty
        Dim ToAddress As String = String.Empty
        Dim CCAddress As String = String.Empty
        Dim BCCAddress As String = String.Empty
        Dim response As String = String.Empty
        Dim skuArr As String() = SKU.Split(",")
        Dim Ds1 As DataSet = New DataSet()

        If skuArr.Length > 0 Then
            Dim obj1 As POLinkingRequestClass = New POLinkingRequestClass()
            Ds1 = obj1.GetToMailAddress()
            If (Not (Ds1 Is Nothing) AndAlso Ds1.Tables.Count > 0 AndAlso Not (Ds1.Tables(0) Is Nothing) AndAlso Ds1.Tables(0).Rows.Count > 0) Then

                ToAddress = Ds1.Tables(0).Rows(0)("TOAddr").ToString()
                CCAddress = Ds1.Tables(0).Rows(0)("CCAddr").ToString()
                BCCAddress = Ds1.Tables(0).Rows(0)("BCCAddr").ToString()
            End If
            'ToAddress = "ranjitchakraborty@bergerindia.com,suranjanbasu@bergerindia.com,arijitdasgupta@bergerindia.com,souvikchakravarty@bergerindia.com,bijendarsingh@bergerindia.com,diptangshudey@bergerindia.com,rasenjitdas@bergerindia.com"
            'CCAddress = ""
            'BCCAddress = "benimadhab.samanta@mccit.co.in"
            mailBody = "<p>Please find below the SKU details which need to be linked with the PO."
            'mailBody += "<table style='border:1px solid black;'>"
            mailBody += "<table style='border:1px solid black; width: 500px'>" & "<thead>" & "<th colspan='6' style='border:1px solid black;padding: 5px;'>PO Linking Request</th>" & "</thead>"
            mailBody += "<tbody>" & "<tr>" & "<td style='border:1px solid black;padding: 5px;'>Depot Name</td>" & "<td style='border:1px solid black;padding: 5px;'>" & DepotCode & "</td>" & "</tr>" & "<tr>" & "<td style='border:1px solid black;padding: 5px;'>Vendor Site</td>" & "<td style='border:1px solid black;padding: 5px;'>" & VendorCode & " (" & VendorID & ")" & "</td>" & "</tr>" & "<tr>" & "<td style='border:1px solid black;padding: 5px;'>Site ID</td>" & "<td style='border:1px solid black;padding: 5px;'>" & siteID & "</td>" & "</tr>" & "<tr>" & "<td style='border:1px solid black;padding: 5px;'>PO No</td>" & "<td style='border:1px solid black;padding: 5px;'>" & PONO & "</td>" & "</tr>" & "</tbody>"
            mailBody += "<tbody>" & "<th colspan='2' style='border:1px solid black;padding: 5px;'>SKU Code</th>" & "</tbody>"

            For Each skus As String In skuArr

                If skus.Trim() <> "" Then
                    mailBody += "<tbody>" & "<td colspan='2' style='border:1px solid black;padding: 5px;' align='center'>" & skus.Trim() & "</td>" & "</tbody>"
                End If
            Next

            mailBody += "</table></table></p>"
            mailBody += "<br><br><h4 style='display:block;width:100%;text-align:center;color: darkred;'>**This is an auto-generated mail.Please do not reply to this mail**</h4>"
            mailsubject = "SKU Linking request against PO"
            Dim mailobj As EmailSMSsender = New EmailSMSsender()
            Dim mailEntity As MailEntity = New MailEntity()

            If ToAddress <> "" Then
                mailEntity.ToAddress = ToAddress
                mailEntity.CCAddress = CCAddress
                mailEntity.BCCAddress = BCCAddress
                mailEntity.MailSubject = mailsubject
                mailEntity.MailBody = mailBody
                mailEntity.Sender_Task = "MailSendToPO"
                response = "Email Sent Successfully"

                Dim recipNo As Integer = mailobj.sendMail(mailEntity)

                If recipNo = 0 Then
                    response = "Email Sent Failed"
                    'lblPopMessage.Text = response
                    'lblPopMessage.ForeColor = System.Drawing.Color.Red
                Else
                    'lblPopMessage.Text = response
                    'lblPopMessage.ForeColor = System.Drawing.Color.Green
                End If

                Return response
            End If
        End If
        Return String.Empty
    End Function

    Protected Sub gvProduct_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim gv_row As GridViewRow = Nothing
        Dim index As Integer = 0

        If e.CommandName = "SendMail" Then
            gv_row = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
            index = gv_row.RowIndex
            Dim lbldepot_name As Label = CType(gvProduct.Rows(index).FindControl("lbldepot_name"), Label)
            Dim lblVendor As Label = CType(gvProduct.Rows(index).FindControl("lblVendor"), Label)
            Dim lblPONumber As Label = CType(gvProduct.Rows(index).FindControl("lblPONumber"), Label)
            Dim lblSKU As Label = CType(gvProduct.Rows(index).FindControl("lblSKU"), Label)
            Dim lblSiteID As Label = CType(gvProduct.Rows(index).FindControl("lblSiteID"), Label)
            Dim hdnVendorCode As HiddenField = CType(gvProduct.Rows(index).FindControl("hdnVendorCode"), HiddenField)
            Dim response As String = SendPoLinkMail(lbldepot_name.Text, lblVendor.Text, lblPONumber.Text, lblSKU.Text, lblSiteID.Text, hdnVendorCode.Value)
            If response <> String.Empty Then
                ScriptManager.RegisterStartupScript(Me.Page, Me.[GetType](), "ShowAlert", "alert('" & response & "');", True)
            End If
        End If

        If e.CommandName = "Reject" Then
            gv_row = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
            index = gv_row.RowIndex
            Dim hdnHdrID As HiddenField = CType(gvProduct.Rows(index).FindControl("hdnHdrID"), HiddenField)
            Dim rowaffected As Int32 = 0

            Dim obj As POLinkingRequestClass = New POLinkingRequestClass()

            rowaffected = obj.RejectPOLinking(Convert.ToInt64(hdnHdrID.Value), userInfo.userIDEntity)
            If rowaffected > 0 Then
                ScriptManager.RegisterStartupScript(Me.Page, Me.[GetType](), "ShowAlert", "alert('Rejected Successfullty');", True)
            Else
                ScriptManager.RegisterStartupScript(Me.Page, Me.[GetType](), "ShowAlert", "alert('Error Occured');", True)
            End If
        End If
    End Sub

    'Protected Sub gvProduct_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
    '    gvProduct.PageIndex = e.NewPageIndex
    '    PopulateList()
    'End Sub

    Protected Sub gvProduct_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.DataRow) Then

            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            Dim hdnIsReject As HiddenField = CType(e.Row.FindControl("hdnIsReject"), HiddenField)
            Dim hdnIsLinked As HiddenField = CType(e.Row.FindControl("hdnIsLinked"), HiddenField)

            Dim lblcheck As Label = CType(e.Row.FindControl("lblcheck"), Label)
            Dim lblReject As Label = CType(e.Row.FindControl("lblReject"), Label)
            Dim lbtnMail As LinkButton = CType(e.Row.FindControl("lbtnMail"), LinkButton)
            Dim lbtnReject As LinkButton = CType(e.Row.FindControl("lbtnReject"), LinkButton)

            If (hdnIsReject.Value <> String.Empty) Then
                lblReject.Visible = True
                lbtnReject.Visible = False
            Else
                lblReject.Visible = False
                lbtnReject.Visible = True
            End If

            If (hdnIsLinked.Value = "Y") Then
                lblcheck.Visible = True
                lbtnMail.Visible = False

                lblReject.Visible = False
                lbtnReject.Visible = False
            Else
                lblcheck.Visible = False
                lbtnMail.Visible = True
                If (hdnIsReject.Value <> String.Empty) Then
                    lblcheck.Visible = False
                    lbtnMail.Visible = False
                End If
            End If

            If userInfo.userGroupCodeEntity <> "SYSADMIN" Then
                lblReject.Visible = False
                lbtnReject.Visible = False
            End If
        End If

        'If (e.Row.RowType = DataControlRowType.Pager) Then
        '    Dim row As TableRow = New TableRow
        '    row = e.Row.Controls(0).Controls(0).Controls(0)
        '    For Each cell As TableCell In row.Cells
        '        Dim lb As Control = cell.Controls(0)


        '        If (TypeOf (lb) Is Label) Then

        '            'CType(lb, Label).ForeColor = System.Drawing.Color.Red
        '            CType(lb, Label).CssClass = "lblpager"
        '            'CType(lb, Label).Width = 20
        '            'CType(lb, Label).Height = 15
        '            'set current pager

        '        ElseIf (TypeOf (lb) Is LinkButton) Then

        '            CType(lb, LinkButton).CssClass = "lnkpager"
        '            'CType(lb, LinkButton).Width = 20
        '            'CType(lb, LinkButton).Height = 15
        '            'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
        '        End If

        '    Next
        'End If
    End Sub

    Private Function FirstPoLinkPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvProduct.PageSize
        If pageSize <= 0 Then pageSize = 10
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    Private Shared Function CurrentPoLinkUser() As VMSUserEntity
        Dim sessionUser As Object = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser Is Nothing Then Return Nothing
        Return CType(sessionUser, VMSUserEntity)
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function GetMorePoLinks(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal depotCode As String, ByVal vendorCode As String, ByVal status As String) As Object
        Dim rows As New List(Of Object)
        Dim userInfo As VMSUserEntity = CurrentPoLinkUser()
        If userInfo Is Nothing Then Return New With {.rows = rows, .total = 0}
        If pageSize <= 0 Then pageSize = 10
        If pageIndex < 0 Then pageIndex = 0
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.REGION) Then
            depotCode = userInfo.userBranchEntity
        End If
        Dim vendorSet As DataSet = New QualityControlClass().GetVendor(userInfo.userIDEntity)
        If vendorSet IsNot Nothing AndAlso vendorSet.Tables.Count > 0 AndAlso vendorSet.Tables(0) IsNot Nothing AndAlso vendorSet.Tables(0).Rows.Count = 1 Then
            vendorCode = vendorSet.Tables(0).Rows(0)("vendor_code").ToString()
        End If
        Dim ds As DataSet = New POLinkingRequestClass().GetPOLinkingReqList(depotCode, vendorCode, status)
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .hdrId = dr("airh_hdr_id").ToString(),
                    .rejected = dr("airh_reject_request").ToString(),
                    .linked = dr("isLinked").ToString(),
                    .depotName = dr("depot_name").ToString(),
                    .depot = dr("airh_depot").ToString(),
                    .vendorName = dr("vendor_name").ToString(),
                    .vendor = dr("airh_vendor").ToString(),
                    .poNo = dr("aird_po_no").ToString(),
                    .sku = dr("sku_code").ToString(),
                    .site = dr("site_name").ToString(),
                    .reqDate = dr("req_date").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function SendPoLinkMailFromList(ByVal depotName As String, ByVal vendorName As String, ByVal poNo As String, ByVal sku As String, ByVal siteName As String, ByVal vendorCode As String) As String
        If CurrentPoLinkUser() Is Nothing Then Return "Please login again."
        Return SendPoLinkMail(depotName, vendorName, poNo, sku, siteName, vendorCode)
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function RejectPoLinkFromList(ByVal hdrId As String) As String
        Dim userInfo As VMSUserEntity = CurrentPoLinkUser()
        If userInfo Is Nothing Then Return "Please login again."
        If userInfo.userGroupCodeEntity <> "SYSADMIN" Then Return "Error Occured"
        Try
            Dim affected As Integer = New POLinkingRequestClass().RejectPOLinking(Convert.ToInt64(hdrId), userInfo.userIDEntity)
            If affected > 0 Then Return "ok"
            Return "Error Occured"
        Catch ex As Exception
            Return "Error Occured"
        End Try
    End Function
End Class
