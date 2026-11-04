Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports VMS.DataAccess
Imports System.IO
Imports NPOI.HSSF.UserModel
Imports NPOI.SS.UserModel
Imports NPOI.HSSF.Util
Imports System.Globalization
Imports NPOI.SS.Util
Partial Class TestCaseTestResultList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

#Region "Page_Load Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
        If Not IsPostBack Then
            txtAsOndate.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now)
            txtAsOndateTo.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now)
            AddAttributes()
            PopulateFrequency()
            PopulateVendorBrand(String.Empty)
            PopulateVendorBrandProduct(String.Empty, String.Empty)

            RetrieveSearchCriteria()
            'gvTestList.PageIndex = 0
            BindGrid()
        End If

    End Sub

#End Region

#Region "Adding Attributes to Controls"
    Public Sub AddAttributes()

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

#Region "Populate Dropdown"
    Private Sub PopulateFrequency()
        CheckLogin()
        Try
            Dim obj As New QualityControlClass
            Dim dsUnitSet As New DataSet
            ddlVendor.Items.Clear()
            dsUnitSet = obj.GetVendor(userInfo.userIDEntity)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlVendor.DataSource = dsUnitSet.Tables(0)
                ddlVendor.DataTextField = "vendor_name"
                ddlVendor.DataValueField = "vendor_code"
                ddlVendor.DataBind()
            End If
            ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            If dsUnitSet.Tables(0).Rows.Count = 1 Then
                ddlVendor.SelectedIndex = 1
                ddlVendor.Enabled = False
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
    Private Sub PopulateVendorBrand(ByVal vendorCode As String)
        CheckLogin()
        Try
            Dim obj As New QualityControlClass
            Dim dsUnitSet As New DataSet
            If Not (ddlVendor.SelectedValue) Is Nothing Then
                dsUnitSet = obj.GetVendorBrand(ddlVendor.SelectedValue, userInfo.userIDEntity)
            Else
                dsUnitSet = obj.GetVendorBrand(vendorCode, userInfo.userIDEntity)
            End If

            ddlBrand.Items.Clear()
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlBrand.DataSource = dsUnitSet.Tables(0)
                ddlBrand.DataTextField = "brand_name"
                ddlBrand.DataValueField = "brand_id"
                ddlBrand.DataBind()
                'If Not (dsUnitSet.Tables(0).Rows.Count = 1) Then
                '    ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'End If
            End If
            ddlBrand.Items.Insert(0, New ListItem("All", String.Empty, True))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub

    Private Sub PopulateVendorBrandProduct(ByVal vendorCode As String, ByVal brandId As String)
        CheckLogin()
        Try
            Dim obj As New QualityControlClass
            Dim dsUnitSet As New DataSet
            If Not (ddlVendor.SelectedValue) Is Nothing And Not (ddlBrand.SelectedValue) Is Nothing Then
                dsUnitSet = obj.GetVendorBrandProduct(ddlVendor.SelectedValue, ddlBrand.SelectedValue, userInfo.userIDEntity)
            Else
                dsUnitSet = obj.GetVendorBrandProduct(vendorCode, brandId, userInfo.userIDEntity)
            End If

            ddlProduct.Items.Clear()
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlProduct.DataSource = dsUnitSet.Tables(0)
                ddlProduct.DataTextField = "prd_desc"
                ddlProduct.DataValueField = "prd_code"
                ddlProduct.DataBind()
                'If Not (dsUnitSet.Tables(0).Rows.Count = 1) Then
                '    ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'End If
            End If
            ddlProduct.Items.Insert(0, New ListItem("All", String.Empty, True))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Dim AsOnDate As String
        Dim AsOnDateto As String
        AsOnDate = String.Format("{0:yyyy-MM-dd}", txtAsOndate.Text)
        AsOnDateto = String.Format("{0:yyyy-MM-dd}", txtAsOndateTo.Text)
        Try
            Dim obj As New QualityControlClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0

            SaveSearchCriteria()

            dsProductSet = obj.GetTestResultList(ddlVendor.SelectedValue, ddlBrand.SelectedValue, ddlProduct.SelectedValue, AsOnDate, AsOnDateto, userInfo.userIDEntity, txtBatchNo.Text)

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvTestList.PageIndex = 0
                gvTestList.DataSource = FirstResultPage(dsProductSet.Tables(0))
                gvTestList.DataBind()
                hdnTrHasData.Value = "1"
                hdnTrPageSize.Value = gvTestList.PageSize.ToString()
            Else
                gvTestList.DataSource = Nothing
                gvTestList.DataBind()
                hdnTrHasData.Value = "0"
            End If
            hdnTrVendor.Value = ddlVendor.SelectedValue
            hdnTrBrand.Value = ddlBrand.SelectedValue
            hdnTrProduct.Value = ddlProduct.SelectedValue
            hdnTrBatch.Value = txtBatchNo.Text
            hdnTrFrom.Value = AsOnDate
            hdnTrTo.Value = AsOnDateto
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    'Protected Sub gvProductList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvTestList.PageIndexChanging
    '    gvTestList.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub
    Protected Sub gvTokenVendorList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTestList.RowCommand
        CheckLogin()
        If (e.CommandName.Equals("EditTest")) Then
            'Response.Redirect("TestCaseTestMasterAddUpdate.aspx?id=" & e.CommandArgument.ToString)
            Response.Redirect("TestResultApproval.aspx?id=" & e.CommandArgument.ToString)
        End If
    End Sub
    'Protected Sub imgbtnAdd_Click(sender As Object, e As EventArgs) Handles imgbtnAdd.Click
    '    Response.Redirect("TestCaseTestMasterAddUpdate.aspx", False)
    'End Sub
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        BindGrid()
    End Sub
    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendor.SelectedIndexChanged
        PopulateVendorBrand(ddlVendor.SelectedValue)
    End Sub
    Protected Sub ddlBrand_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlBrand.SelectedIndexChanged
        PopulateVendorBrandProduct(ddlVendor.SelectedValue, ddlBrand.SelectedValue)
    End Sub
    Protected Sub imgbtnExport_Click(ByVal sender As Object, ByVal e As EventArgs) Handles imgbtnExport.Click


        Dim AsOnDate As String
        Dim AsOnDateto As String
        AsOnDate = String.Format("{0:yyyy-MM-dd}", txtAsOndate.Text)
        AsOnDateto = String.Format("{0:yyyy-MM-dd}", txtAsOndateTo.Text)
        Try
            Dim obj As New QualityControlClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0
            dsProductSet = obj.GetTestResultList_export(ddlVendor.SelectedValue, ddlBrand.SelectedValue, ddlProduct.SelectedValue, AsOnDate, AsOnDateto, userInfo.userIDEntity, txtBatchNo.Text)

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0) Then

                'ExportToExcel(dsProductSet)
                ExportToExcelVr2(dsProductSet)

            Else

                ExportToExcelVr2(dsProductSet)
            End If
        Catch ex As Exception
            'Dim returnUrl As String = "~/ExceptionPage.aspx"

            'Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError

            'Server.Transfer(returnUrl)
        Finally

        End Try

    End Sub


#Region "For Testcaseresult sheet"

    Private Sub ExportToExcel(ByVal ds As DataSet)



        If (ds.Tables(0).Rows.Count > 0) Then

            Dim DateString As String = "_" & Format(Now, "dd-MM-yyyy_HH-mm-ss")

            Dim file_name As String = "TestResultListReport_" + DateString + ".xls"

            Dim genReportPath As String = Server.MapPath(Request.ApplicationPath) & "\Excel_Reports\"
            Try

                Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\TestResultListReport.xls", FileMode.Open, FileAccess.Read)
                Dim WorkBook As HSSFWorkbook = New HSSFWorkbook(fs, True)
                Dim ReportSheet As HSSFSheet = WorkBook.GetSheet("Sheet1")
                Dim Row As HSSFRow
                Dim Cell As HSSFCell
                Dim alignLeft As HSSFCellStyle = WorkBook.CreateCellStyle()
                Dim alignRight As HSSFCellStyle = WorkBook.CreateCellStyle()
                Dim alignCenter As HSSFCellStyle = WorkBook.CreateCellStyle()
                Dim bgWhite As HSSFCellStyle = WorkBook.CreateCellStyle()
                alignLeft.Alignment = 1
                alignRight.Alignment = 3
                alignCenter.Alignment = 2
                bgWhite.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.White.Index
                Row = ReportSheet.GetRow(1)
                Cell = Row.GetCell(0)
                Cell.SetCellValue("Report As On: " & DateTime.Today.ToString("dd/MM/yyyy"))



                'Row = ReportSheet.GetRow(1)

                'Cell = Row.GetCell(0)

                'Cell.SetCellValue("Report Month: " & DateTime.Today.ToString("MMM") & ", " & DateTime.Today.Year.ToString)



                'Row = ReportSheet.GetRow(1)

                'Cell = Row.GetCell(4)

                'Cell.SetCellValue("Report Year: " & DateTime.Today.Year)



                'Cell = Row.GetCell(4)



                'Cell.SetCellValue("SKU Wise MRP Dump")





                'If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then

                '    Cell = Row.GetCell(3)

                '    Cell.SetCellValue("User: " & userInfo.userIDEntity)

                '    Cell.CellStyle.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.GREY_50_PERCENT.index

                'Else

                '    Cell.CellStyle.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.WHITE.index

                'End If



                Dim SheetRowIndex As Integer = 3
                For i = 0 To ds.Tables(0).Rows.Count - 1

                    Row = ReportSheet.CreateRow(SheetRowIndex)
                    Cell = Row.CreateCell(0)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vendor_name"))

                    Cell.CellStyle = alignCenter
                    Cell = Row.CreateCell(1)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("brand_name"))

                    Cell.CellStyle = alignCenter
                    Cell = Row.CreateCell(2)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("prd_desc"))

                    Cell.CellStyle = alignCenter
                    Cell = Row.CreateCell(3)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("shade"))

                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(4)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("batch_no"))

                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(5)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("batch_date"))

                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(6)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("qulify_status"))
                    'If ds.Tables(0).Rows(i)("qulify_status") = "Approved" Then
                    '    Cell.CellStyle.FillBackgroundColor =
                    'End If
                    Cell.CellStyle = alignCenter

                    SheetRowIndex = SheetRowIndex + 1

                Next

                'For columnIndex As Integer = 0 To 7 - 1

                '    ReportSheet.AutoSizeColumn(columnIndex)

                'Next

                If Not (Directory.Exists(genReportPath)) Then
                    Directory.CreateDirectory(genReportPath)
                End If

                Dim fl As FileStream = New FileStream(genReportPath & file_name, FileMode.Create)
                WorkBook.Write(fl)
                fl.Close()
            Catch ex As Exception

                'lblErrMsg.Text = String.Format("Error: {0}", ex.Message)

                Response.Write(ex.Message & "<br>" & ex.StackTrace)

                'Dim returnUrl As String = "~/ExceptionPage.aspx"

                'Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorExporttoExcel

                'Server.Transfer(returnUrl)

            End Try
            Response.Clear()
            Response.Buffer = True
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"
            Response.WriteFile(genReportPath & file_name)
            Response.AppendHeader("content-disposition", "attachment; filename=" & file_name)
            Response.Cache.SetCacheability(HttpCacheability.NoCache)
            Response.Flush()
            Response.End()



        End If

    End Sub

    Private Sub ExportToExcelVr2(ByVal dset As DataSet)

        Dim fileBytes As Byte() = Nothing
        Try
            Dim VIEW As DataView = New DataView(dset.Tables(0))

            Dim ms As MemoryStream = New MemoryStream()
            Dim WorkBook As HSSFWorkbook = New HSSFWorkbook()


            Dim bradt As DataTable = VIEW.ToTable(True, "brand_id", "BrandName")

            Dim finaldt As DataTable

            For index = 0 To bradt.Rows.Count - 1
                Dim bid As Int64 = Convert.ToInt64(bradt.Rows(index)("brand_id"))
                Dim SheetName As String = Convert.ToString(bradt.Rows(index)("BrandName"))
                Dim ReportSheet As HSSFSheet = CType(WorkBook.CreateSheet(SheetName), HSSFSheet)

                If bid > 0 Then
                    ''Dim filteredRows2() As DataRow = dt.Select("ID > 1 AND Name LIKE 'J%'")
                    finaldt = dset.Tables(0).Select("brand_id='" & bid & "'").CopyToDataTable


                    If finaldt.Columns.Contains("trh_hdr_id") OrElse finaldt.Columns.Contains("brand_id") Then
                        finaldt.Columns.Remove("trh_hdr_id")
                        finaldt.Columns.Remove("brand_id")
                    End If


                    ''For Remove null value
                    Dim col As Integer
                    For col = finaldt.Columns.Count - 1 To 0 Step -1
                        Dim removeColumn As Boolean = True
                        For Each row As DataRow In finaldt.Rows
                            If Not row.IsNull(col) Then
                                removeColumn = False
                                Exit For
                            End If
                        Next
                        If removeColumn Then finaldt.Columns.RemoveAt(col)
                    Next
                    ''End


                    If Not finaldt Is Nothing AndAlso finaldt.Rows.Count > 0 Then
                        Dim dt As DataTable = finaldt

                        If dt.Rows.Count > 0 Then

                            Dim Row As HSSFRow = Nothing
                            Dim Cell As HSSFCell = Nothing

                            Dim font = WorkBook.CreateFont()
                            font.FontHeightInPoints = 10
                            font.FontName = "Calibri"

                            Dim font3 As IFont = WorkBook.CreateFont()
                            font3.Color = HSSFColor.Black.Index
                            font3.FontName = "Calibri"
                            font3.FontHeightInPoints = 10


                            Dim font4 As IFont = WorkBook.CreateFont()
                            font4.Color = HSSFColor.Black.Index
                            font4.FontName = "Calibri"
                            font4.FontHeightInPoints = 11
                            font4.Boldweight = NPOI.SS.UserModel.FontBoldWeight.Bold

                            Dim styleCenter As ICellStyle = WorkBook.CreateCellStyle()
                            styleCenter.VerticalAlignment = VerticalAlignment.Center
                            styleCenter.Alignment = HorizontalAlignment.Center
                            styleCenter.SetFont(font3)
                            styleCenter.BorderRight = BorderStyle.Thin
                            styleCenter.BorderBottom = BorderStyle.Thin
                            styleCenter.BorderTop = BorderStyle.Thin
                            styleCenter.BorderLeft = BorderStyle.Thin

                            Dim styleLeft As ICellStyle = WorkBook.CreateCellStyle()
                            styleLeft.VerticalAlignment = VerticalAlignment.Center
                            styleLeft.Alignment = HorizontalAlignment.Left
                            styleLeft.SetFont(font3)
                            styleLeft.BorderRight = BorderStyle.Thin
                            styleLeft.BorderBottom = BorderStyle.Thin
                            styleLeft.BorderTop = BorderStyle.Thin
                            styleLeft.BorderLeft = BorderStyle.Thin
                            styleLeft.BorderLeft = BorderStyle.Thin

                            Dim styleRight As ICellStyle = WorkBook.CreateCellStyle()
                            styleRight.VerticalAlignment = VerticalAlignment.Center
                            styleRight.Alignment = HorizontalAlignment.Right
                            styleRight.SetFont(font3)
                            styleRight.BorderRight = BorderStyle.Thin
                            styleRight.BorderBottom = BorderStyle.Thin
                            styleRight.BorderTop = BorderStyle.Thin
                            styleRight.BorderLeft = BorderStyle.Thin

                            Dim styleHeader2 As ICellStyle = WorkBook.CreateCellStyle()
                            styleHeader2.Alignment = HorizontalAlignment.Center
                            styleHeader2.VerticalAlignment = VerticalAlignment.Center
                            styleHeader2.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Aqua.Index
                            styleHeader2.FillPattern = FillPattern.SolidForeground
                            styleHeader2.SetFont(font4)
                            styleHeader2.BorderRight = BorderStyle.Thin
                            styleHeader2.BorderBottom = BorderStyle.Thin
                            styleHeader2.BorderTop = BorderStyle.Thin
                            styleHeader2.BorderLeft = BorderStyle.Thin

                            Dim styleHeader As ICellStyle = WorkBook.CreateCellStyle()
                            styleHeader.Alignment = HorizontalAlignment.Center
                            styleHeader.VerticalAlignment = VerticalAlignment.Center
                            styleHeader.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Orange.Index
                            styleHeader.FillPattern = FillPattern.SolidForeground
                            styleHeader.SetFont(font4)
                            styleHeader.BorderRight = BorderStyle.Thin
                            styleHeader.BorderBottom = BorderStyle.Thin
                            styleHeader.BorderTop = BorderStyle.Thin
                            styleHeader.BorderLeft = BorderStyle.Thin

                            Dim styleHeader1 As ICellStyle = WorkBook.CreateCellStyle()
                            styleHeader1.Alignment = HorizontalAlignment.Center
                            styleHeader1.VerticalAlignment = VerticalAlignment.Center
                            styleHeader1.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Yellow.Index
                            styleHeader1.FillPattern = FillPattern.SolidForeground
                            styleHeader1.WrapText = True

                            styleHeader1.SetFont(font4)
                            styleHeader1.BorderRight = BorderStyle.Thin
                            styleHeader1.BorderBottom = BorderStyle.Thin
                            styleHeader1.BorderTop = BorderStyle.Thin
                            styleHeader1.BorderLeft = BorderStyle.Thin


                            Dim styleDate As ICellStyle = WorkBook.CreateCellStyle()
                            styleDate.VerticalAlignment = VerticalAlignment.Center
                            styleDate.Alignment = HorizontalAlignment.Center
                            Dim formatIdDate = HSSFDataFormat.GetBuiltinFormat("dd/mm/yyyy h:mm AM/PM")
                            If formatIdDate = -1 Then
                                Dim newDataFormat = WorkBook.CreateDataFormat()
                                styleDate.DataFormat = newDataFormat.GetFormat("dd/MM/yyyy")
                            Else
                                styleDate.DataFormat = formatIdDate
                            End If

                            Row = CType(ReportSheet.CreateRow(0), HSSFRow)
                            Cell = CType(Row.CreateCell(0), HSSFCell)
                            Cell.SetCellValue("QualityControl Report")
                            Cell.CellStyle = styleHeader
                            ReportSheet.AddMergedRegion(New CellRangeAddress(0, 0, 0, dt.Columns.Count - 1))


                            Row = CType(ReportSheet.CreateRow(1), HSSFRow)
                            Cell = CType(Row.CreateCell(0), HSSFCell)
                            Cell.SetCellValue("Report as on  - " + DateTime.Today.ToString("dd/MM/yyyy"))
                            Cell.CellStyle = styleHeader2
                            ReportSheet.AddMergedRegion(New CellRangeAddress(1, 1, 0, dt.Columns.Count - 1))


                            ''  ReportSheet.AddMergedRegion(New CellRangeAddress(1, 0, 0, dt.Columns.Count - 1))


                            Row = CType(ReportSheet.CreateRow(2), HSSFRow)

                            ReportSheet.CreateFreezePane(0, 3)
                            Row = CType(ReportSheet.CreateRow(2), HSSFRow)
                            Dim hdrid As Int64
                            'Header
                            For i As Integer = 0 To dt.Rows(0).Table.Columns.Count - 1

                                ''If Convert.ToString(dt.Rows(0).Table.Columns(i).ColumnName) <> "trh_hdr_id" Then
                                Cell = CType(Row.CreateCell(i), HSSFCell)
                                Dim s As String = Convert.ToString(dt.Rows(0).Table.Columns(i).ColumnName)
                                Cell.SetCellValue(s)
                                Cell.CellStyle = styleHeader1

                                'Else
                                '    i -= 1
                                'End If
                            Next

                            Dim rowIndex As Integer = 3

                            For Each row1 As DataRow In dt.Rows

                                Row = CType(ReportSheet.CreateRow(rowIndex), HSSFRow)

                                For Each dc As DataColumn In dt.Columns
                                    ''If (dc.ColumnName) <> ("trh_hdr_id") Then
                                    Cell = CType(Row.CreateCell(dc.Ordinal), HSSFCell)
                                    '' If dc.ColumnName.Contains("regn_new") Or dc.ColumnName.Contains("dlr_dealer_code") Or dc.ColumnName.Contains("dlr_bill_to") Or dc.ColumnName.Contains("dealer_code") Or dc.ColumnName.Contains("mobile_no") Then
                                    Cell = Row.CreateCell(dc.Ordinal)
                                    Cell.SetCellValue(Convert.ToString(row1(dc.ColumnName)))
                                    Cell.CellStyle = styleLeft
                                    '' End If
                                    ''End If
                                Next
                                rowIndex += 1
                            Next


                            For i As Integer = 0 To dt.Columns.Count
                                'ReportSheet.AutoSizeColumn(i)
                            Next

                            'WorkBook.Write(ms)
                            'fileBytes = ms.ToArray()
                        End If
                    End If
                End If
            Next

            WorkBook.Write(ms)
            fileBytes = ms.ToArray()


        Catch ex As Exception
            Dim str = ex.Message
        Finally
            If (fileBytes IsNot Nothing) Then

                Dim DateString As String = DateTime.Now.ToString("dd-MM-yyyy_HH-mm")
                Dim FileName As String = String.Concat("QualityControlExport_", "_", DateString, ".xls")
                Response.Clear()
                Response.Charset = Encoding.UTF8.WebName
                Response.ContentType = "application/vnd.ms-excel"
                Response.Cache.SetCacheability(HttpCacheability.NoCache)
                Response.AppendHeader("content-disposition", "attachment; filename=" & FileName)
                Response.AddHeader("Content-Length", fileBytes.Length.ToString())
                Response.BinaryWrite(fileBytes)
                Response.End()
                HttpContext.Current.Response.Flush()
                HttpContext.Current.Response.SuppressContent = True
                HttpContext.Current.ApplicationInstance.CompleteRequest()
            End If
        End Try
    End Sub


#End Region

    Protected Sub gvTestList_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles gvTestList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim btnEdit As LinkButton = CType(e.Row.FindControl("btnEdit"), LinkButton)
            If rowView("editable_yn") = "Y" Then
                btnEdit.Visible = True
                btnEdit.PostBackUrl = "TestCaseResultEntry.aspx?id=" & rowView("result_id").ToString()
            Else
            End If
        End If
    End Sub

    Private Sub SaveSearchCriteria()
        CheckLogin()

        Session(Constant.SessionKeys.tcTestresultSearchInfo) = Nothing
        Dim tcSearchInfo As New tcResultSearchEntity
        tcSearchInfo.Vendor = ddlVendor.SelectedValue
        tcSearchInfo.Brand = ddlBrand.SelectedValue
        tcSearchInfo.Product = ddlProduct.SelectedValue
        tcSearchInfo.BatchNo = txtBatchNo.Text.Trim()
        tcSearchInfo.FromDate = txtAsOndate.Text.Trim()
        tcSearchInfo.ToDate = txtAsOndateTo.Text.Trim()
        Session(Constant.SessionKeys.tcTestresultSearchInfo) = tcSearchInfo

    End Sub

    Private Sub RetrieveSearchCriteria()

        If (Not (Session(Constant.SessionKeys.tcTestresultSearchInfo) Is Nothing)) Then

            Dim tcSearchInfo As New tcResultSearchEntity

            tcSearchInfo = Session(Constant.SessionKeys.tcTestresultSearchInfo)
            ddlVendor.SelectedValue = tcSearchInfo.Vendor
            ddlBrand.SelectedValue = tcSearchInfo.Brand
            ddlProduct.SelectedValue = tcSearchInfo.Product
            txtBatchNo.Text = tcSearchInfo.BatchNo
            txtAsOndate.Text = tcSearchInfo.FromDate
            txtAsOndateTo.Text = tcSearchInfo.ToDate

        End If

        SaveSearchCriteria()

    End Sub

    Private Function FirstResultPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvTestList.PageSize
        If pageSize <= 0 Then pageSize = 20
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function GetMoreTestResults(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal vendor As String, ByVal brand As String, ByVal product As String, ByVal fromDate As String, ByVal toDate As String, ByVal batchNo As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 20
        If pageIndex < 0 Then pageIndex = 0
        Dim fromValue As String = String.Format("{0:yyyy-MM-dd}", If(fromDate, String.Empty))
        Dim toValue As String = String.Format("{0:yyyy-MM-dd}", If(toDate, String.Empty))
        Dim ds As DataSet = New QualityControlClass().GetTestResultList(If(vendor, String.Empty), If(brand, String.Empty), If(product, String.Empty), fromValue, toValue, userInfo.userIDEntity, If(batchNo, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .id = dr("result_id").ToString(),
                    .vendor = dr("vendor_name").ToString(),
                    .brand = dr("brand_name").ToString(),
                    .product = dr("prd_desc").ToString(),
                    .shade = dr("shade").ToString(),
                    .batchNo = dr("batch_no").ToString(),
                    .batchDate = dr("batch_date").ToString(),
                    .editable = dr("editable_yn").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function
End Class
