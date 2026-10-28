Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Globalization
Imports System.IO


Partial Class VendorDispatchDetails
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        CheckLogin()
        'CalendarExtender.StartDate = DateTime.Now
        AddAttribute()
        If Not IsPostBack Then
            PopulateMonths()
            PopulateYears()
            BindGrid()

            'MailSendToVirtualOrg("shahirhossain.mali@mccit.co.in", "1", "MCC", "OLA", "KOlkata")
        End If
    End Sub

#Region "Populate Months"
    Private Sub PopulateMonths()
        Dim info As DateTimeFormatInfo = DateTimeFormatInfo.GetInstance(Nothing)
        For i As Integer = 1 To 13 - 1
            ddlMonth.Items.Add(New ListItem(info.GetMonthName(i), i.ToString()))
        Next
        ddlMonth.Items.Insert(0, New ListItem("Select Month", String.Empty, True))
        ddlMonth.SelectedValue = DateTime.Now.Date.Month.ToString()
    End Sub
#End Region

#Region "Populate Year"
    Private Sub PopulateYears()
        Dim info As DateTimeFormatInfo = DateTimeFormatInfo.GetInstance(Nothing)
        Dim Years As Integer = DateTime.Now.Year
        For i As Integer = Years To 2001 Step -1
            ddlYear.Items.Add(New ListItem(i.ToString(), i.ToString()))
        Next
        ddlYear.Items.Insert(0, New ListItem("Select Year", String.Empty, True))
        ddlYear.SelectedValue = DateTime.Now.Date.Year.ToString()

    End Sub
#End Region

#Region "Check Login"
    Private Sub CheckLogin()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub
#End Region

#Region "Attribute"
    Private Sub AddAttribute()
        txtInvoiceDate.Attributes.Add("readonly", "true")
        txtewaybilldate.Attributes.Add("readonly", "true")
        txtvalidupto.Attributes.Add("readonly", "true")
        btnSave.Attributes.Add("OnClick", "return ValidateDespatchHdrUpdate('" + txtInvoiceNo.ClientID +
                                                                         "','" + txtInvoiceDate.ClientID +
                                                                         "','" + txtTransporterName.ClientID +
                                                                         "','" + txtLorryNo.ClientID +
                                                                         "','" + txtWayBill.ClientID +
                                                                         "','" + txtewaybilldate.ClientID +
                                                                         "','" + txtvalidupto.ClientID +
                                                                         "','" + sch_fld1.ClientID +
                                                                         "','" + txtfinalinvoicevalue.ClientID +
                                                                         "','" + gvDispatchAssignDtls.ClientID +
                                                                         "','" + btnSave.ClientID +
                                                                         "','" + lblErrorMessage.ClientID + "');")
    End Sub
#End Region

#Region "Bing Grid"
    Private Sub BindGrid()
        gvVendorDispatch.DataSource = Nothing
        gvVendorDispatch.DataBind()
        If ddlMonth.SelectedIndex > 0 AndAlso ddlYear.SelectedIndex > 0 Then
            Dim ds As DataSet = New DataSet()
            Dim Months As String = ddlMonth.SelectedValue.ToString()
            Dim Years As String = ddlYear.SelectedValue.ToString()
            Dim Status As String = ddlStatus.SelectedValue.ToString()
            Dim Obj As VendorDispatchClass = New VendorDispatchClass()
            ds = Obj.GetVendorDispatchList(userInfo.userIDEntity, Months, Years, Status)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing)) Then
                gvVendorDispatch.DataSource = ds
                gvVendorDispatch.DataBind()
            End If
        Else
            lblPopMessage.Text = "Please Select both month And year."
            lblPopMessage.ForeColor = System.Drawing.Color.Red
            ModalPopupExtender1.Show()


            Return
        End If

    End Sub

#End Region


    Protected Sub gvVendorDispatch_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvVendorDispatch.RowCommand

        Try
            If e.CommandName.Equals("ViewDetails") Then
                txtInvoiceNo.ReadOnly = False
                txtInvoiceDate.Enabled = True
                txtTransporterName.ReadOnly = False
                txtLorryNo.ReadOnly = False
                txtWayBill.ReadOnly = False
                btnSave.Visible = True

                hdn_dispatchAssignHdr.Value = String.Empty
                txtInvoiceNo.Text = String.Empty
                'CalendarExtender.StartDate = DateTime.Now
                txtInvoiceDate.Text = String.Empty
                txtTransporterName.Text = String.Empty
                txtLorryNo.Text = String.Empty
                txtWayBill.Text = String.Empty

                Dim ddrd_hdr_req_id As String = Convert.ToString(e.CommandArgument.ToString())

                Dim ds As DataSet = New DataSet()
                Dim Obj As VendorDispatchClass = New VendorDispatchClass()
                ds = Obj.GetVendorDispatchAssignDetailsList(ddrd_hdr_req_id)

                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    hdn_dispatchAssignHdr.Value = ddrd_hdr_req_id
                    gvDispatchAssignDtls.DataSource = ds.Tables(0)
                    gvDispatchAssignDtls.DataBind()
                End If

                Dim total As Decimal = 0
                For i As Integer = 0 To gvDispatchAssignDtls.Rows.Count - 1
                    Dim lblTotalRate As Label = gvDispatchAssignDtls.Rows(i).FindControl("lblTotalRate")

                    total = total + Convert.ToDecimal(lblTotalRate.Text)
                Next

                lbltotalrateincgst.Text = total.ToString()

                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(1) Is Nothing) AndAlso ds.Tables(1).Rows.Count > 0) Then
                    txtTransporterName.Text = ds.Tables(1).Rows(0)("tm_transporter_name").ToString()
                    txtpono.Text = ds.Tables(1).Rows(0)("ddrh_po_no").ToString()
                End If
                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(2) Is Nothing) AndAlso ds.Tables(2).Rows.Count > 0) Then
                    txtInvoiceNo.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vendor_invoice_no"))
                    txtInvoiceDate.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vendor_invoice_date"))
                    txtTransporterName.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_transporter_name"))
                    txtLorryNo.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_vehicle_no"))
                    txtWayBill.Text = Convert.ToString(ds.Tables(2).Rows(0)("ddah_waybill_no"))
                    btnSave.Visible = False
                    txtInvoiceNo.ReadOnly = True
                    txtInvoiceDate.Enabled = False
                    txtTransporterName.ReadOnly = True
                    txtLorryNo.ReadOnly = True
                    txtWayBill.ReadOnly = True
                End If

                ModalPopupExtender2.Show()

            End If


        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect(returnUrl)
        End Try

    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave.Click
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Try



            lblErrorMessage.Text = ""
            Dim ds As DataSet = New DataSet()
            Dim Obj1 As New UnitDespatchClassVr1

            Dim DocPath As String = Format(Date.Now, "dd_MM_yyyy")
            'Dim DocsFileName As String = sch_fld1.FileName
            'Dim DocsOrgFileName As String = sch_fld1.FileName
            Dim DocsOrgFileName As String = sch_fld1.FileName

            Dim fileNameWithoutExt As String = System.IO.Path.GetFileNameWithoutExtension(DocsOrgFileName)
            Dim fileExt As String = System.IO.Path.GetExtension(DocsOrgFileName)

            Dim uniqueId As String = Guid.NewGuid().ToString("N")

            'Modified-by MUKESH BHAGAT on 16-10-2026 : cleaned name (UploadFileName.SafeFileName) - commas, spaces, quotes etc. in the


            'original name broke the download header; the GUID suffix keeps it unique as before.


            Dim DocsFileName As String = UploadFileName.SafeFileName(fileNameWithoutExt & "_" & uniqueId & fileExt)

            DocsOrgFileName = DocsFileName

            Dim Obj As VendorDispatchClass = New VendorDispatchClass()
            Dim Objunit As New UnitDespatchClassVr1

            Dim RowsAffected As Integer = 0
            Dim ddah_req_hdr_id As String = hdn_dispatchAssignHdr.Value
            Dim ddah_transporter_name As String = txtTransporterName.Text.Trim()
            Dim ddah_vehicle_no As String = txtLorryNo.Text.Trim()
            Dim ddah_vendor_invoice_no As String = txtInvoiceNo.Text.Trim()
            Dim ddah_vendor_invoice_date As String = txtInvoiceDate.Text
            Dim ddah_E_WayBill_date As String = txtewaybilldate.Text
            Dim ddah_Valid_upto_date As String = txtvalidupto.Text
            Dim ddah_waybill_no As String = txtWayBill.Text.Trim()
            Dim TotalRate As Decimal = 0

            For i As Integer = 0 To gvDispatchAssignDtls.Rows.Count - 1
                Dim hdnqty As HiddenField = gvDispatchAssignDtls.Rows(i).FindControl("hdnqty")
                Dim hdnSkuRate As HiddenField = gvDispatchAssignDtls.Rows(i).FindControl("hdnSkuRate")
                Dim hdnSkuGST As HiddenField = gvDispatchAssignDtls.Rows(i).FindControl("hdnSkuGST")

                Dim total As Decimal = Convert.ToDecimal(hdnqty.Value) * Convert.ToDecimal(hdnSkuRate.Value)
                TotalRate = TotalRate + (total + (total * Convert.ToDecimal(hdnSkuGST.Value / 100)))
            Next

            Dim FinalInvoiceValue As Decimal = 0
            If txtfinalinvoicevalue.Text = "" Then
                FinalInvoiceValue = 0
            Else
                FinalInvoiceValue = Convert.ToDecimal(txtfinalinvoicevalue.Text)
            End If

            Dim Result As Decimal = TotalRate - FinalInvoiceValue
            Dim Value1 As Decimal = 0
            Dim Value2 As Decimal = 0

            ds = Obj1.GetFinalInvoiceValue()

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0 Then
                Value1 = Convert.ToDecimal(ds.Tables(0).Rows(0)("lov_value"))
                Value2 = Convert.ToDecimal(ds.Tables(0).Rows(1)("lov_value"))
            End If
            Dim sign As String = Result.ToString().Substring(0, 1)
            'If txtpono.Text = "" Then

            'Else
            '    If sign = "-" Then
            '        If (Value1 > Result AndAlso Result < Value2) Then
            '            ModalPopupExtender2.Show()
            '            lblErrorMessage.Text = "Total Rate Not matching With the Final Invoice Value."
            '            lblErrorMessage.ForeColor = System.Drawing.Color.Red
            '            ''ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Total Rate not matching with the Final Invoice Value');", True)
            '            '' txtfinalinvoicevalue.Focus()
            '            ''ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "GridSummation();", True)
            '            Exit Sub
            '        End If
            '    Else
            '        If (Value1 < Result AndAlso Result > Value2) Then
            '            ModalPopupExtender2.Show()
            '            lblErrorMessage.Text = "Total Rate not matching with the Final Invoice Value."
            '            lblErrorMessage.ForeColor = System.Drawing.Color.Red
            '            Exit Sub
            '        End If
            '    End If
            'End If

            Dim year As String = String.Empty

            Dim invoiceDate As String = txtInvoiceDate.Text
            If Not String.IsNullOrEmpty(invoiceDate) Then
                Dim dateParts As String() = invoiceDate.Split("/"c) ' Split the date string by "/"
                If dateParts.Length = 3 Then
                    year = dateParts(2)
                Else
                    ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('invoice Date is not in correct format.');", True)
                    Exit Sub
                End If
            End If

            Dim invoiceExists As Integer = 0
            Dim dscheck As DataSet = Objunit.CheckInvoiceNumberExsists(Year, txtInvoiceNo.Text, userInfo.userIDEntity)

            If dscheck IsNot Nothing AndAlso dscheck.Tables.Count > 0 AndAlso dscheck.Tables(0).Rows.Count > 0 Then
                invoiceExists = Convert.ToInt32(dscheck.Tables(0).Rows(0)("InvoiceExists"))
            End If

            If invoiceExists = 1 Then
                ScriptManager.RegisterStartupScript(Me.Page, Me.GetType(), "alert", "alert('Invoice number already exists. Please use a different number.');", True)
                Exit Sub
            End If


            If ddah_req_hdr_id <> String.Empty AndAlso ddah_vehicle_no <> String.Empty AndAlso ddah_vendor_invoice_no <> String.Empty AndAlso ddah_vendor_invoice_date <> String.Empty AndAlso ddah_waybill_no <> String.Empty Then
                ddah_vendor_invoice_date = FormatDate(ddah_vendor_invoice_date)
                ddah_E_WayBill_date = FormatDate(ddah_E_WayBill_date)
                ddah_Valid_upto_date = FormatDate(ddah_Valid_upto_date)
                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()

                RowsAffected = Obj.UpdateVendorDispatchRequestStatus(ddah_req_hdr_id, ddah_transporter_name, ddah_vehicle_no, ddah_vendor_invoice_no, ddah_vendor_invoice_date, ddah_waybill_no, userInfo.userIDEntity, DocPath, DocsFileName, DocsOrgFileName, ddah_E_WayBill_date, ddah_Valid_upto_date, sqlConn, sqlTrans)
                If RowsAffected > 0 Then
                    If Not sch_fld1.PostedFile Is Nothing And sch_fld1.PostedFile.ContentLength > 0 Then
                        Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Direct_Despatch_Docs" & "\" & DocPath
                        'Dim fn As String = System.IO.Path.GetFileName(sch_fld1.PostedFile.FileName)
                        Dim fn As String = DocsFileName
                        Dim saveLocation As String = projectPath & "\" & fn
                        Dim file As System.IO.FileInfo = New System.IO.FileInfo(saveLocation)
                        If Not (Directory.Exists(projectPath)) Then
                            Directory.CreateDirectory(projectPath)
                        End If
                        sch_fld1.PostedFile.SaveAs(saveLocation)
                    End If

                    sqlTrans.Commit()

                    SendMail(ddah_req_hdr_id)
                    BindGrid()
                    lblPopMessage.Text = "Despatched Successfully"
                    lblPopMessage.ForeColor = System.Drawing.Color.Green
                    ModalPopupExtender2.Hide()
                    ModalPopupExtender1.Show()
                ElseIf RowsAffected = -1 Then
                    sqlTrans.Rollback()
                    BindGrid()
                    lblPopMessage.Text = "Data Already Exists."
                    lblPopMessage.ForeColor = System.Drawing.Color.Red
                    ModalPopupExtender2.Hide()
                    ModalPopupExtender1.Show()

                End If
            Else
                lblPopMessage.Text = "Please Fill Mandatory Fileds"
                lblPopMessage.ForeColor = System.Drawing.Color.Red
                ModalPopupExtender1.Show()
                Return
            End If
            txtfinalinvoicevalue.Text = ""
            txtewaybilldate.Text = ""
            txtvalidupto.Text = ""
        Catch ex As Exception
            If Not (sqlTrans Is Nothing) Then sqlTrans.Rollback()
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
            Response.Redirect(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                sqlConn.Close()
                sqlConn.Dispose()
            End If
        End Try

    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBack.Click
        'ModalPopupExtender1.Show()
        Response.Redirect("~/Home.aspx")
    End Sub

    'Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles ImgbtnSearch.Click
    '    BindGrid()
    'End Sub

    Protected Sub ImgbtnSearch_Click(sender As Object, e As EventArgs) Handles ImgbtnSearch.Click
        BindGrid()
    End Sub

    Private Function FormatDate(ByVal stringdate As String) As String
        Dim FormattedDate As String = String.Empty

        If stringdate = String.Empty Then
            FormattedDate = String.Empty
        ElseIf stringdate <> String.Empty Then
            Dim dd As String = Convert.ToString(stringdate.Substring(0, 2))
            Dim mm As String = Convert.ToString(stringdate.Substring(3, 2))
            Dim yyyy As String = Convert.ToString(stringdate.Substring(6, 4))
            FormattedDate = Convert.ToString(yyyy & "-" & mm & "-" & dd)
        End If

        Return FormattedDate
    End Function

    Protected Sub gvVendorDispatch_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles gvVendorDispatch.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim lblStatus As Label = TryCast(e.Row.FindControl("lblStatus"), Label)

            If lblStatus.Text.Trim().Equals("Pending") Then
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff")
            Else
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#9FF98D")
            End If
        End If
    End Sub

    Protected Sub btnOK_Click(sender As Object, e As EventArgs) Handles btnOK.Click
        If lblPopMessage.Text.Trim().Equals("Despatched Successfully") Then
            ModalPopupExtender1.Hide()
        Else
            ModalPopupExtender1.Hide()
            ModalPopupExtender2.Show()
        End If

    End Sub


#Region "Send Email"
    Private Sub SendMail(ByVal ReqID As String)

        Try
            Dim ds As DataSet = New DataSet()
            Dim Months As String = ddlMonth.SelectedValue.ToString()
            Dim Years As String = ddlYear.SelectedValue.ToString()
            Dim Status As String = ddlStatus.SelectedValue.ToString()
            Dim Obj As VendorDispatchClass = New VendorDispatchClass()
            ds = Obj.getVirtualOrgEmail(ReqID)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing)) Then

                Dim VirtualOrgEmail As String = ds.Tables(0).Rows(0)("vom_org_mail_id").ToString()
                Dim VirtualOrgName As String = ds.Tables(0).Rows(0)("vom_org_name").ToString()
                Dim VendorEmail As String = ds.Tables(1).Rows(0)("vm_vendor_mail_id").ToString()
                Dim VendorName As String = ds.Tables(1).Rows(0)("vm_vendor_name").ToString()
                Dim Transporter As String = ds.Tables(2).Rows(0)("tm_transporter_name").ToString()
                Dim TransporterEmail As String = ds.Tables(2).Rows(0)("tm_transporter_mail_id").ToString()
                Dim DepotName As String = ds.Tables(3).Rows(0)("depot_name").ToString()
                Dim OrderSlno As String = ds.Tables(3).Rows(0)("order_sl_no").ToString()

                MailSendToVirtualOrg(VirtualOrgEmail, OrderSlno, VendorName, Transporter, DepotName)
            End If
        Catch ex As Exception

        End Try



    End Sub

#End Region

    Private Sub MailSendToVirtualOrg(ByVal EmailId As String, ByVal number As String, ByVal VendorName As String, ByVal Transporter As String, ByVal DepotName As String)
        Try
            Dim email As EmailSMSsender = New EmailSMSsender()
            Dim ObjEmailentity As MailEntity = New MailEntity()
            Dim Subject As String = "Material Despatched by Vendor (" & VendorName & "): " & DepotName & " with Order Sl. No. :" & number
            Dim Body As String
            Body = ""
            Body = Body & "<div style='margin-left: 20px;'>"
            Body = Body & "<p>Material Despatched by ( " & VendorName & " ). Please check the following details : <br /> Order Sl. No. :  <b>" & number & "</b> <br /> Despatched Date :  <b>" & DateTime.Now.ToString("dd/MM/yyyy") & "</b><br /> Invoice No. :  <b>" + txtInvoiceNo.Text.Trim() & "</b><br /> Invoice Date :  <b>" + txtInvoiceDate.Text.Trim() & "</b><br /> Transporter :  <b>" + txtTransporterName.Text.Trim() & "</b><br /> Vehicle No. :  <b>" + txtLorryNo.Text.Trim() & "</b><br /> E-Way Bill No. :  <b>" + txtWayBill.Text.Trim() & "</b></p> "
            Dim A As String = "<table border=""1"" width=""100%"">" & "<tr style = ""background-color: #D3DEED; height: 25px;""> " & "<td style =""width: 10%; font-weight: bold;"" > SKU Code </td>" & "<td style =""width: 50%; font-weight: bold;"" > SKU Name </td>" & "<td style =""width: 10%; font-weight: bold;"" > Pack Size </td>" & "<td style =""width: 10%; font-weight: bold;"" > Qty </td>" & "<td style =""width: 10%; font-weight: bold;"" > UOM </td>" & "<td style = ""width: 10%; font-weight: bold;"" > Volume</td></tr>"
            Dim B As String = String.Empty

            If gvDispatchAssignDtls.Rows.Count > 0 Then
                Dim Total As Decimal = 0

                For i As Integer = 0 To gvDispatchAssignDtls.Rows.Count - 1
                    Dim lblSKUCode As Label = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("lblSKUCode"), Label)
                    Dim lblSkuName As Label = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("lblSkuName"), Label)
                    Dim lblPackSize As Label = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("lblPackSize"), Label)
                    Dim lblSumofQty As Label = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("lblSumofQty"), Label)
                    Dim lblUom As HiddenField = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("hdnUom"), HiddenField)
                    Dim lblSumofVolume As Label = TryCast(gvDispatchAssignDtls.Rows(i).FindControl("lblSumofVolume"), Label)
                    Dim SKUCode As String = lblSKUCode.Text.Trim()
                    Dim SKUName As String = lblSkuName.Text.Trim()
                    Dim PackSize As String = lblPackSize.Text.Trim()
                    Dim Qty As String = lblSumofQty.Text.Trim()
                    Dim UOM As String = lblUom.Value.Trim()
                    Dim volume As Decimal = 0

                    Try
                        volume = Convert.ToDecimal(lblSumofVolume.Text.Trim())
                    Catch
                    End Try

                    Total = Total + volume
                    B = B & "<tr>" & "<td style =""width: 10%; font-weight: bold;"" > " & SKUCode & " </td>" & "<td style =""width: 50%; font-weight: bold;"" > " & SKUName & " </td>" & "<td style =""width: 10%; font-weight: bold;"" > " & PackSize & " </td>" & "<td style =""width: 10%; font-weight: bold;"" > " & Qty & " </td>" & "<td style =""width: 10%; font-weight: bold;"" > " & UOM & " </td>" & "<td style = ""width: 10%; font-weight: bold; text-align:right;"" >" & volume.ToString() & " </td></tr>"
                Next

                B = B & "<tr>" & "<td style =""width: 10%; font-weight: bold;"" ></td>" & "<td style =""width: 50%; font-weight: bold;"" ></td>" & "<td style =""width: 10%; font-weight: bold;"" ></td>" & "<td style =""width: 10%; font-weight: bold;"" ></td>" & "<td style =""width: 10%; font-weight: bold;"" >Total</td>" & "<td style = ""width: 10%; font-weight: bold; text-align:right;"" >" & Total.ToString() & " </td></tr>"
            End If

            B = B & " </table><br /> "
            Body = Body & A & B & "<p><b>Disclaimer</b> : This is a system generated email. Please do not reply to this email.</p><p>*** If you have received this message in error, please notify the sender immediately and delete this message from your system ***</p></div>"

            If EmailId <> "" Then
                ObjEmailentity.ToAddress = EmailId
                ObjEmailentity.MailSubject = Subject
                ObjEmailentity.MailBody = Body
                'Dim result As String = email.sendMailHTML(ObjEmailentity)

                ObjEmailentity.Sender_Task = "MailSendToVirtualOrg"
                email.sendMail(ObjEmailentity)
            End If

        Catch ex As Exception
        End Try
    End Sub

    Protected Sub gvVendorDispatch_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVendorDispatch.PageIndexChanging
        gvVendorDispatch.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub
    Protected Sub gvVendorDispatch_RowDataBound1(sender As Object, e As GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.Pager) Then
            Dim row As TableRow = New TableRow
            row = e.Row.Controls(0).Controls(0).Controls(0)
            For Each cell As TableCell In row.Cells
                Dim lb As Control = cell.Controls(0)


                If (TypeOf (lb) Is Label) Then

                    'CType(lb, Label).ForeColor = System.Drawing.Color.Red
                    CType(lb, Label).CssClass = "lblpager"
                    'CType(lb, Label).Width = 20
                    'CType(lb, Label).Height = 15
                    'set current pager

                ElseIf (TypeOf (lb) Is LinkButton) Then

                    CType(lb, LinkButton).CssClass = "lnkpager"
                    'CType(lb, LinkButton).Width = 20
                    'CType(lb, LinkButton).Height = 15
                    'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
                End If

            Next
        End If
    End Sub
    Protected Sub gvDispatchAssignDtls_DataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDispatchAssignDtls.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim lblQty As Label = e.Row.FindControl("lblSumofQty")
            Dim hdnSkuRate As HiddenField = e.Row.FindControl("hdnSkuRate")
            Dim hdnSkuGST As HiddenField = e.Row.FindControl("hdnSkuGST")
            Dim lblTotalRate As Label = e.Row.FindControl("lblTotalRate")

            Dim qty As Decimal = Val(lblQty.Text)
            Dim rate As Decimal = Val(hdnSkuRate.Value)
            Dim gst As Decimal = Val(hdnSkuGST.Value)
            Dim totalAmt As Decimal = qty * rate
            Dim totalAmtWithGST As Decimal = (totalAmt + ((totalAmt * gst) / 100))
            lblTotalRate.Text = totalAmtWithGST.ToString("0.00")
        End If
    End Sub
End Class
