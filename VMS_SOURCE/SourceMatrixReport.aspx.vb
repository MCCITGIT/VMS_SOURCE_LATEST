Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports VMS.Web
Imports System.IO
Imports NPOI.HSSF.UserModel
Imports NPOI.HSSF.Util
Imports NPOI.SS.UserModel
Imports NPOI.XSSF.UserModel
Partial Class SourceMatrixReport
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Const MatrixPageSize As Integer = 20
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            AddAttributes()

            PopulateRegion()
            PopulateDepot()
            PopulateUnit()
            'BindGrid()
        End If
    End Sub
#Region "Check Login"
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
#End Region

#Region "Populate Region"
    Private Sub PopulateRegion()

        Dim ObjDocumentType As New Common
        Dim OccupationTypeSet As New DataSet
        Dim LovType As String = Constant.Common.REGION_TYPE
        OccupationTypeSet = ObjDocumentType.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)
        If (Not (OccupationTypeSet Is Nothing) AndAlso OccupationTypeSet.Tables.Count > 0 AndAlso Not (OccupationTypeSet.Tables(0) Is Nothing) AndAlso OccupationTypeSet.Tables(0).Rows.Count > 0) Then
            ddlRegion.DataSource = OccupationTypeSet.Tables(0)
            ddlRegion.DataTextField = "lov_value"
            ddlRegion.DataValueField = "lov_code"
            ddlRegion.DataBind()
            ddlRegion.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
            ddlRegion.SelectedValue = userInfo.userRegionEntity
            ddlRegion.Enabled = False
        End If

    End Sub
#End Region

#Region "Populate Depot"
    Private Sub PopulateDepot()
        Dim DptDsptchdUntWise As New DepotDespatchUnitwiseApp
        Dim DepotSet As New DataSet

        DepotSet = DptDsptchdUntWise.GetDepot(ddlRegion.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (DepotSet Is Nothing) AndAlso DepotSet.Tables.Count > 0 AndAlso Not (DepotSet.Tables(0) Is Nothing) AndAlso DepotSet.Tables(0).Rows.Count > 0) Then
            ddlDepot.DataSource = DepotSet.Tables(0)
            ddlDepot.DataTextField = "depot_name"
            ddlDepot.DataValueField = "depot_code"
            ddlDepot.DataBind()
            ddlDepot.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.REGION) Then
        '    ddlLocation.SelectedValue = userInfo.userBranchEntity
        '    ddlLocation.Enabled = False
        'End If
    End Sub
#End Region
#Region "Populate Unit"
    Private Sub PopulateUnit()
        Dim DptDsptchdUntWise As New DepotDespatchUnitwiseApp
        Dim UnitSet As New DataSet

        UnitSet = DptDsptchdUntWise.GetUnit(Constant.Common.ActiveStatus)

        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlVendorUnit.DataSource = UnitSet.Tables(0)
            ddlVendorUnit.DataTextField = "unit_name"
            ddlVendorUnit.DataValueField = "unit_code"
            ddlVendorUnit.DataBind()
            ddlVendorUnit.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
    End Sub
#End Region
    Protected Sub ddlRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepot()
    End Sub
    Protected Sub imgbtnDownload_Click(sender As Object, e As EventArgs) Handles imgbtnDownload.Click
        Dim obj As New SourceMatrixClass
        Dim dsProductSet As New DataSet
        Try

            dsProductSet = obj.SourceMatrixDataList(ddlDepot.SelectedValue, ddlVendorUnit.SelectedValue, txtSkucode.Text)

            If (dsProductSet.Tables(0).Rows.Count > 0) Then
                ExportToExcelSheet(dsProductSet)
            Else
                lblErrorMessage.Text = "No Records Found"
            End If
        Catch ex As Exception
            Dim str As String = ex.Message.ToString()
        End Try
    End Sub
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs)
        BindGrid()
    End Sub
    Private Sub BindGrid()
        Try
            Dim obj As New SourceMatrixClass
            Dim dsProductSet As New DataSet
            Dim RequisitionId As Integer = 0

            dsProductSet = obj.SourceMatrixDataList(ddlDepot.SelectedValue, ddlVendorUnit.SelectedValue, txtSkucode.Text)

            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvmatrixsource.DataSource = FirstMatrixPage(dsProductSet.Tables(0))
                gvmatrixsource.DataBind()
            Else
                gvmatrixsource.DataSource = Nothing
                gvmatrixsource.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
    End Sub
    Private Function FirstMatrixPage(ByVal dt As DataTable) As DataTable
        Dim pageDt As DataTable = dt.Clone()
        Dim take As Integer = Math.Min(MatrixPageSize, dt.Rows.Count)
        For i As Integer = 0 To take - 1
            pageDt.ImportRow(dt.Rows(i))
        Next
        Return pageDt
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetMoreSourceMatrix(pageIndex As Integer, depot As String, vendor As String, sku As String) As Object
        Dim obj As New SourceMatrixClass
        Dim ds As DataSet = obj.SourceMatrixDataList(If(depot, String.Empty), If(vendor, String.Empty), If(sku, String.Empty))
        Dim rows As New List(Of Object)
        Dim total As Integer = 0

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            Dim dt As DataTable = ds.Tables(0)
            total = dt.Rows.Count
            Dim start As Integer = pageIndex * MatrixPageSize
            Dim last As Integer = Math.Min(start + MatrixPageSize, total) - 1
            For i As Integer = start To last
                Dim r As DataRow = dt.Rows(i)
                rows.Add(New With {
                    .Region = r("Region").ToString(),
                    .Depot = r("Depot").ToString(),
                    .SkuCode = r("SkuCode").ToString(),
                    .Sku_Desc = r("Sku_Desc").ToString(),
                    .vendor_name = r("vendor_name").ToString(),
                    .Site_Code = r("Site_Code").ToString(),
                    .TotalRate = r("TotalRate").ToString(),
                    .priority_rank = r("priority_rank").ToString()
                })
            Next
        End If

        Return New With {.rows = rows, .total = total}
    End Function

    Private Sub ExportToExcelSheet(ByVal dset As DataSet)
        Try
            'Opening the Excel template......
            Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\SourceMatrixReport.xlsx", FileMode.Open, FileAccess.Read)

            'Getting the complete workbook...
            Dim templateWorkbook As XSSFWorkbook = New XSSFWorkbook(fs)

            Dim font3 As IFont = templateWorkbook.CreateFont()
            font3.Color = IndexedColors.Black.Index
            font3.FontName = "Calibri"
            font3.FontHeightInPoints = 10

            Dim styleCenter As ICellStyle = templateWorkbook.CreateCellStyle()
            styleCenter.VerticalAlignment = VerticalAlignment.Center
            styleCenter.Alignment = HorizontalAlignment.Center
            styleCenter.SetFont(font3)
            styleCenter.BorderRight = BorderStyle.Thin
            styleCenter.BorderBottom = BorderStyle.Thin
            styleCenter.BorderTop = BorderStyle.Thin
            styleCenter.BorderLeft = BorderStyle.Thin

            Dim styleLeft As ICellStyle = templateWorkbook.CreateCellStyle()
            styleLeft.VerticalAlignment = VerticalAlignment.Center
            styleLeft.Alignment = HorizontalAlignment.Left
            styleLeft.SetFont(font3)
            styleLeft.BorderRight = BorderStyle.Thin
            styleLeft.BorderBottom = BorderStyle.Thin
            styleLeft.BorderTop = BorderStyle.Thin
            styleLeft.BorderLeft = BorderStyle.Thin

            Dim font4 As IFont = templateWorkbook.CreateFont()
            font4.Color = IndexedColors.Red.Index
            Dim styleRight As ICellStyle = templateWorkbook.CreateCellStyle()
            styleRight.VerticalAlignment = VerticalAlignment.Center
            styleRight.Alignment = HorizontalAlignment.Right
            styleRight.SetFont(font3)
            styleRight.BorderRight = BorderStyle.Thin
            styleRight.BorderBottom = BorderStyle.Thin
            styleRight.BorderTop = BorderStyle.Thin
            styleRight.BorderLeft = BorderStyle.Thin

            'styleRight.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0.00_ ;_ * -#,##0.00_ ;_ * ""-""??_ ;_ @_ ")
            styleRight.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0.00 ;_ * -#,##0.00_ ;_ * ""-""??_ ;_ @_ ")

            Dim styleValue As ICellStyle = templateWorkbook.CreateCellStyle()
            styleValue.SetFont(font3)

            styleValue.BorderRight = BorderStyle.Thin
            styleValue.BorderBottom = BorderStyle.Thin
            styleValue.BorderTop = BorderStyle.Thin
            styleValue.BorderLeft = BorderStyle.Thin

            styleValue.VerticalAlignment = VerticalAlignment.Center
            styleValue.Alignment = HorizontalAlignment.Right
            'styleValue.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0 ;_ * -#,##0_ ;_ * ""-""??_ ;_ @_ ")
            'styleValue.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0.00_ ;_ * -#,##0.00_ ;_ * ""-""??_ ;_ @_ ")

            Dim styleValueCenter As ICellStyle = templateWorkbook.CreateCellStyle()
            styleValueCenter.SetFont(font3)
            styleValueCenter.VerticalAlignment = VerticalAlignment.Center
            styleValueCenter.Alignment = HorizontalAlignment.Center
            styleValueCenter.BorderRight = BorderStyle.Thin
            styleValueCenter.BorderBottom = BorderStyle.Thin
            styleValueCenter.BorderTop = BorderStyle.Thin
            styleValueCenter.BorderLeft = BorderStyle.Thin
            styleValueCenter.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0 ;_ * -#,##0_ ;_ * ""-""??_ ;_ @_ ")

            Dim styleValueDec As ICellStyle = templateWorkbook.CreateCellStyle()
            styleValueDec.SetFont(font3)
            styleValueDec.BorderRight = BorderStyle.Thin
            styleValueDec.BorderBottom = BorderStyle.Thin
            styleValueDec.BorderTop = BorderStyle.Thin
            styleValueDec.BorderLeft = BorderStyle.Thin
            styleValueDec.VerticalAlignment = VerticalAlignment.Center
            styleValueDec.Alignment = HorizontalAlignment.Right
            styleValueDec.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0.00 ;_ * -#,##0_ ;_ * ""-""??_ ;_ @_ ")

            Dim styleDate As ICellStyle = templateWorkbook.CreateCellStyle()
            styleDate.VerticalAlignment = VerticalAlignment.Center
            styleDate.Alignment = HorizontalAlignment.Center
            styleDate.BorderRight = BorderStyle.Thin
            styleDate.BorderBottom = BorderStyle.Thin
            styleDate.BorderTop = BorderStyle.Thin
            styleDate.BorderLeft = BorderStyle.Thin
            Dim formatIdDate = HSSFDataFormat.GetBuiltinFormat("dd/MM/yyyy")

            If formatIdDate = -1 Then
                Dim newDataFormat = templateWorkbook.CreateDataFormat()
                styleDate.DataFormat = newDataFormat.GetFormat("dd/MM/yyyy")
            Else
                styleDate.DataFormat = formatIdDate
            End If

            Dim sheet As XSSFSheet = templateWorkbook.GetSheet("Sheet1")
            Dim RowsIndex As Integer

            Dim row As XSSFRow
            Dim cell As XSSFCell

            Dim DateString As String = "_" & DateTime.Today.ToString("dd_MM_yyyy")
            row = sheet.GetRow(0)
            cell = row.GetCell(0)
            cell.SetCellValue("Vendor Wise Ranking Details Report As On - " + Format(Now, "dd-MM-yyyy").ToString)

            RowsIndex = 2
            Dim count = 0
            Dim colIndex As Integer = 0

            For i = 0 To dset.Tables(0).Rows.Count - 1
                row = sheet.CreateRow(RowsIndex)
                colIndex = 0

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(i + 1)
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("Region")))
                cell.CellStyle = styleCenter
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("Depot")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("SkuCode")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("Sku_Desc")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("vendor_name")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("Site_Code")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToDouble(dset.Tables(0).Rows(i)("TotalRate")))
                cell.CellStyle = styleRight
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("priority_rank")))
                cell.CellStyle = styleCenter
                colIndex += 1

                RowsIndex = RowsIndex + 1

            Next

            Dim genReportPath As String = AppDomain.CurrentDomain.BaseDirectory & "Excel_Reports\"
            If Not (Directory.Exists(genReportPath)) Then
                Directory.CreateDirectory(genReportPath)
            End If
            Dim file_name As String = "SourceMatrixReport_" & DateString & ".xlsx"
            Dim fl As FileStream = New FileStream(genReportPath & file_name, FileMode.Create)
            templateWorkbook.Write(fl)
            fl.Close()
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"
            Response.WriteFile(genReportPath & file_name)
            Response.AppendHeader("content-disposition", "attachment; filename=" & file_name)
            Response.Cache.SetCacheability(HttpCacheability.NoCache)

            HttpContext.Current.Response.Flush()
            HttpContext.Current.Response.SuppressContent = True
            HttpContext.Current.ApplicationInstance.CompleteRequest()

        Catch ex As Exception
            Throw ex
        End Try


    End Sub
#Region "AddAttributes"
    Private Sub AddAttributes()
        'imgbtnSearch.Attributes.Add("onclick", "return ValidateSearch();")
        'imgbtnDownload.Attributes.Add("onclick", "return ValidateSearch();")
    End Sub
#End Region
End Class
