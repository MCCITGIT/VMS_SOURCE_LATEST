Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports NPOI.HSSF.UserModel
Imports NPOI.SS.UserModel
Imports NPOI.HSSF.Util
Imports System.Globalization
Imports System.Collections.Generic
Imports NPOI.SS.Util

Partial Class VendorStockList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
#Region "Page Load Event Handler"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        Page.MaintainScrollPositionOnPostBack = True

        If (Not IsPostBack) Then
            Div_Vendor_Stock_List_Grid.Visible = True
            txtAsOndate.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now)
            txtAsOndateTo.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now)
            gvVendorStockDetails.PageIndex = 0
            VendorStockListLoadBatchWise()
            populateVendor()
            ddlVendor_SelectedIndexChanged(sender, e)
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

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendor.SelectedIndexChanged
        VendorStockListLoadBatchWise()
    End Sub

    Private Sub VendorStockListLoadBatchWise()



        Dim userInfo As VMSUserEntity = New VMSUserEntity()

        Dim QualityControlClass As New QualityControlClass()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then

            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)



        Else

            Response.Redirect("~/Login.aspx")

        End If



        Dim StockList As DataSet



        Dim AsOnDate As String

        Dim AsOnDateto As String

        AsOnDate = String.Format("{0:yyyy-MM-dd}", txtAsOndate.Text)

        AsOnDateto = String.Format("{0:yyyy-MM-dd}", txtAsOndateTo.Text)

        'If AsOnDate = "" Then

        '    AsOnDate = String.Format("{0:yyyy-MM-dd}", DateTime.Now)

        'End If

        Dim VendorId As String = ddlVendor.SelectedValue

        StockList = QualityControlClass.GetVendorStockList(VendorId, AsOnDate, AsOnDateto)



        If (Not (StockList Is Nothing) AndAlso StockList.Tables.Count > 0) Then

            If (Not (StockList.Tables(0) Is Nothing) AndAlso StockList.Tables(0).Rows.Count > 0) Then

                gvVendorStockDetails.PageIndex = 0
                gvVendorStockDetails.DataSource = FirstStockPage(StockList.Tables(0))

                gvVendorStockDetails.DataBind()

                Div_Vendor_Stock_List_Grid.Visible = False
                hdnVstHasData.Value = "1"
                hdnVstPageSize.Value = gvVendorStockDetails.PageSize.ToString()

            Else

                gvVendorStockDetails.DataSource = Nothing

                gvVendorStockDetails.DataBind()

                Div_Vendor_Stock_List_Grid.Visible = True
                hdnVstHasData.Value = "0"

                'gvVendorStockDetails.Visible = True

            End If

            hdnVstVendor.Value = VendorId
            hdnVstFrom.Value = AsOnDate
            hdnVstTo.Value = AsOnDateto

        End If



    End Sub

    Protected Sub ImgbtnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles ImgbtnSearch.Click

        VendorStockListLoadBatchWise()

    End Sub

    Protected Sub gvVendorStockDetails_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVendorStockDetails.RowCommand

        Try

            Dim VendorId As String

            Dim QualityControlClass As New QualityControlClass()

            Dim gv_row As GridViewRow = Nothing

            Dim index As Integer = Nothing

            Dim DS As New DataSet

            If e.CommandName = "EditRow" Then

                'VendorId = Convert.ToString(e.CommandArgument)

                'Dim FileDt As String = CType(gvVendorStockDetails.Rows(Convert.ToString(e.CommandArgument)).FindControl("Date"), HiddenField).Value

                Dim FileDt1 As String

                Dim FileDt2 As String

                VendorId = e.CommandArgument

                Dim gvr As GridViewRow = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)

                Dim RemoveAt As Integer = gvr.RowIndex



                ''  Dim row As GridViewRow = gvLeadList.Rows(RemoveAt)



                Dim FileDt As Label = TryCast(gvr.FindControl("lblDate"), Label)

                FileDt2 = Convert.ToDateTime(FileDt.Text).ToString("yyyy-MM-dd")

                FileDt1 = String.Format("{0:yyyy-MM-dd}", FileDt.Text)



                DS = QualityControlClass.GetStockReport(VendorId, FileDt2)

                If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0) Then

                    ExportToExcel(DS, FileDt2)

                Else

                    ExportToExcel(DS, FileDt2)

                End If

            End If

        Catch ex As Exception



            'Dim returnUrl As String = "~/ExceptionPage.aspx"

            'Session(Constant.SessionKeys.ErrMessage) = ex.ToString()

            'Response.Redirect(returnUrl)

        Finally

        End Try

    End Sub

#Region "Export to Excel using Dll"

#Region "For gridview Row Command"

    Private Sub ExportToExcel(ByVal ds As DataSet, ByVal FileDt As String)



        If (ds.Tables(0).Rows.Count > 0) Then

            Dim DateString As String = "_" & Format(Now, "dd-MM-yyyy_HH-mm-ss")

            Dim file_name As String = "VendorStockList_" + DateString + ".xls"

            Dim genReportPath As String = Server.MapPath(Request.ApplicationPath) & "\Excel_Reports\"



            Try

                Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\VendorStockList.xls", FileMode.Open, FileAccess.Read)



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



                Dim SheetRowIndex As Integer = 4



                For i = 0 To ds.Tables(0).Rows.Count - 1

                    Row = ReportSheet.CreateRow(SheetRowIndex)



                    Cell = Row.CreateCell(0)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vendor_name"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(1)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("ason_date"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(2)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_code"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(3)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_desc"))

                    Cell.CellStyle = alignRight



                    Cell = Row.CreateCell(4)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vssm_nop"))

                    Cell.CellStyle = alignRight



                    Cell = Row.CreateCell(5)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vssm_vol"))

                    Cell.CellStyle = alignRight



                    Cell = Row.CreateCell(6)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_uom"))

                    Cell.CellStyle = alignRight



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

#End Region

#Region "For Batchwise"

    Private Sub ExportToExcelBatchWise(ByVal ds As DataSet)



        If (ds.Tables(0).Rows.Count > 0) Then

            Dim DateString As String = "_" & Format(Now, "dd-MM-yyyy_HH-mm-ss")

            Dim file_name As String = "VendorStockListBatchWise_" + DateString + ".xls"

            Dim genReportPath As String = Server.MapPath(Request.ApplicationPath) & "\Excel_Reports\"



            Try

                Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\VendorStockListBatchWise.xls", FileMode.Open, FileAccess.Read)



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

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("ason_date"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(2)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_code"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(3)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_desc"))

                    Cell.CellStyle = alignCenter



                    Cell = Row.CreateCell(4)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vssm_nop"))

                    Cell.CellStyle = alignRight



                    Cell = Row.CreateCell(5)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("vssm_vol"))

                    Cell.CellStyle = alignRight



                    Cell = Row.CreateCell(6)

                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")

                    Cell.SetCellValue(ds.Tables(0).Rows(i)("sku_uom"))

                    Cell.CellStyle = alignRight



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

#End Region

#End Region

    Private Function GetFromMonth(ByVal MonthCode As Integer) As String

        Dim MonthName As String = String.Empty

        If (MonthCode = 1) Then

            MonthName = "January"

        ElseIf (MonthCode = 2) Then

            MonthName = "February"

        ElseIf (MonthCode = 3) Then

            MonthName = "March"

        ElseIf (MonthCode = 4) Then

            MonthName = "April"

        ElseIf (MonthCode = 5) Then

            MonthName = "May"

        ElseIf (MonthCode = 6) Then

            MonthName = "June"

        ElseIf (MonthCode = 7) Then

            MonthName = "July"

        ElseIf (MonthCode = 8) Then

            MonthName = "August"

        ElseIf (MonthCode = 9) Then

            MonthName = "September"

        ElseIf (MonthCode = 10) Then

            MonthName = "October"

        ElseIf (MonthCode = 11) Then

            MonthName = "November"

        ElseIf (MonthCode = 12) Then

            MonthName = "December"

        End If

        Return MonthName.ToString

    End Function

    Protected Sub imgbtnExport_Click(sender As Object, e As EventArgs) Handles imgbtnExport.Click

        Dim QualityControlClass As New QualityControlClass()

        Dim ds As New DataSet

        CheckLogin()

        Dim AsOnDatefrom As String

        Dim VendorId As String

        Dim AsOnDateto As String

        AsOnDatefrom = String.Format("{0:yyyy-MM-dd}", txtAsOndate.Text)

        AsOnDateto = String.Format("{0:yyyy-MM-dd}", txtAsOndateTo.Text)

        VendorId = ddlVendor.SelectedValue

        Try

            ds = QualityControlClass.GetStockReportBatchWise(VendorId, AsOnDatefrom, AsOnDateto)

        Catch ex As Exception

            Dim returnUrl As String = "~/ExceptionPage.aspx"

            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError

            Server.Transfer(returnUrl)



        End Try

        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then

            If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then

                ExportToExcelBatchWise(ds)

            Else

                'lblErrorMessage.Text = "No Data Found..."

            End If

        Else

            'lblErrorMessage.Text = "No Data Found..."

        End If











    End Sub
    'Protected Sub gvVendorStockDetails_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVendorStockDetails.PageIndexChanging

    '    gvVendorStockDetails.PageIndex = e.NewPageIndex

    '    VendorStockListLoadBatchWise()

    'End Sub

    Private Function FirstStockPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvVendorStockDetails.PageSize
        If pageSize <= 0 Then pageSize = 20
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function GetMoreVendorStock(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal vendor As String, ByVal fromDate As String, ByVal toDate As String) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        If pageSize <= 0 Then pageSize = 20
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New QualityControlClass().GetVendorStockList(If(vendor, String.Empty), If(fromDate, String.Empty), If(toDate, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .serial = (i + 1).ToString(),
                    .vendor = dr("vendor_name").ToString(),
                    .asOnDate = dr("ason_date").ToString(),
                    .volume = dr("volume").ToString()
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

End Class