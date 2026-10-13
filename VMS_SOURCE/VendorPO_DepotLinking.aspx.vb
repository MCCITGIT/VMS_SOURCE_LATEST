Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports System.Collections.Generic
Imports System.Text
Imports System.IO
Imports NPOI.HSSF.UserModel
Imports NPOI.HSSF.Util
Imports NPOI.SS.UserModel
Imports NPOI.XSSF.UserModel

Partial Class VendorPO_DepotLinking
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            BindDropDown()
        End If
    End Sub
    Private Sub BindDropDown()
        PopulateUnit()
        'PopulatePONo()
        PopulateDepotDropdown()
    End Sub
#Region "Populate Unit"
    Private Sub PopulateUnit()
        Dim obj As New OPC_VendorClass()
        Dim UnitSet As DataSet = obj.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlvendor.DataSource = UnitSet.Tables(0)
            ddlvendor.DataTextField = "unit_name"
            ddlvendor.DataValueField = "unit_code"
            ddlvendor.DataBind()
            ddlvendor.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlvendor.SelectedValue = userInfo.userBranchEntity
            ddlvendor.Enabled = False
        End If
    End Sub
#End Region
#Region "Po No populate"
    Private Sub PopulatePONo()
        ddlPoNo.Items.Clear()
        Dim obj As New VendorPoDepotLinkClass()
        Dim ds As DataSet = obj.GetPoNoList(ddlvendor.SelectedValue)

        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlPoNo.DataSource = ds.Tables(0)
            ddlPoNo.DataTextField = "po_no"
            ddlPoNo.DataValueField = "po_no"
            ddlPoNo.DataBind()
        End If
        ddlPoNo.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
    End Sub
#End Region
#Region "Populate Edit Mode"
    Private Sub PopulateEditMode()
        chkbxListApplDepots.Items.Clear()
        Dim Obj As New VendorPoDepotLinkClass
        Dim DS As New DataSet

        DS = Obj.GetDepotPoList(ddlvendor.SelectedValue, ddlPoNo.SelectedValue)

        If (Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0) Then
            chkbxListApplDepots.DataSource = DS.Tables(0)
            chkbxListApplDepots.DataTextField = "depot_name"
            chkbxListApplDepots.DataValueField = "depot_code"
            chkbxListApplDepots.DataBind()

            Dim selectedCount As Integer = 0
            For i As Integer = 0 To chkbxListApplDepots.Items.Count - 1
                Dim item As ListItem = chkbxListApplDepots.Items(i)
                item.Selected = False
                For Each row As DataRow In DS.Tables(0).Rows
                    Dim checkValue As String = Convert.ToString(row("check")).Trim()
                    Dim depotCode As String = Convert.ToString(row("depot_code")).Trim()
                    If String.Equals(checkValue, "Y", StringComparison.OrdinalIgnoreCase) AndAlso String.Equals(item.Value, depotCode, StringComparison.OrdinalIgnoreCase) Then
                        item.Selected = True
                        selectedCount += 1
                        Exit For
                    End If
                Next
            Next
            chkSelectAll.Checked = chkbxListApplDepots.Items.Count > 0 AndAlso selectedCount = chkbxListApplDepots.Items.Count
        Else
            chkSelectAll.Checked = False
        End If
    End Sub
#End Region
    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        lblErrorMessage.Text = String.Empty
        chkSelectAll.Checked = False
        Dim poNo As Integer
        If String.IsNullOrWhiteSpace(ddlvendor.SelectedValue) Then
            lblErrorMessage.Text = "Please Select Vendor."
            chkbxListApplDepots.Items.Clear()
            Return
        End If
        If Not Integer.TryParse(ddlPoNo.SelectedValue, poNo) Then
            lblErrorMessage.Text = "Please Select PO No."
            chkbxListApplDepots.Items.Clear()
            Return
        End If
        PopulateEditMode()
    End Sub
    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click
        lblErrorMessage.ForeColor = System.Drawing.Color.Red
        lblErrorMessage.Text = String.Empty
        Dim poNo As Integer? = Nothing
        Dim parsedPoNo As Integer
        If Integer.TryParse(ddlPoNo.SelectedValue, parsedPoNo) Then
            poNo = parsedPoNo
        End If
        Try
            Dim ds As DataSet = New VendorPoDepotLinkClass().GetDepotPolinkReport(ddlvendor.SelectedValue, poNo)
            If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0) Is Nothing OrElse ds.Tables(0).Rows.Count = 0 Then
                lblErrorMessage.Text = "No records found."
                Return
            End If
            ExportToExcelSheet(ds)
        Catch ex As Exception
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect("~/ExceptionPage.aspx")
        End Try
    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        lblErrorMessage.ForeColor = System.Drawing.Color.Red
        Dim poNo As Integer
        If String.IsNullOrWhiteSpace(ddlvendor.SelectedValue) Then
            lblErrorMessage.Text = "Please Select Vendor."
            Return
        End If
        If Not Integer.TryParse(ddlPoNo.SelectedValue, poNo) Then
            lblErrorMessage.Text = "Please Select PO No."
            Return
        End If

        Dim dtDepot As New DataTable()
        dtDepot.Columns.Add("depot_code", GetType(String))
        For Each item As ListItem In chkbxListApplDepots.Items
            If item.Selected AndAlso Not String.IsNullOrWhiteSpace(item.Value) Then
                Dim depotCode As String = item.Value.Split("|"c)(0).Trim()
                If depotCode <> String.Empty Then
                    dtDepot.Rows.Add(depotCode)
                End If
            End If
        Next
        If dtDepot.Rows.Count = 0 Then
            lblErrorMessage.Text = "select atleast one Depot."
            Return
        End If

        Dim obj As New VendorPoDepotLinkClass()
        Dim result As Integer = obj.SaveVendorPoDepotLink(ddlvendor.SelectedValue, poNo, userInfo.userIDEntity, dtDepot)
        If result > 0 Then
            RefreshControls()
            lblErrorMessage.ForeColor = System.Drawing.Color.Green
            lblErrorMessage.Text = "Submitted Successfully."
        Else
            btnSubmit.Enabled = True
            lblErrorMessage.Text = "Submit failed."
        End If
    End Sub
    Private Sub RefreshControls()
        If ddlvendor.Enabled AndAlso ddlvendor.Items.Count > 0 Then
            ddlvendor.SelectedIndex = 0
        End If
        PopulatePONo()
        If ddlPoNo.Items.Count > 0 Then
            ddlPoNo.SelectedIndex = 0
        End If
        chkSelectAll.Checked = False
        chkbxListApplDepots.Items.Clear()
        PopulateDepotDropdown()
        For i As Integer = 0 To chkbxListApplDepots.Items.Count - 1
            chkbxListApplDepots.Items(i).Selected = False
        Next
        btnSubmit.Enabled = True
    End Sub
    Protected Sub ddlvendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlvendor.SelectedIndexChanged
        PopulatePONo()
        'chkbxListApplDepots.Items.Clear()
        'chkSelectAll.Checked = False
        'lblErrorMessage.Text = String.Empty
    End Sub
    Private Sub ExportToExcelSheet(ByVal dset As DataSet)
        Try
            'Opening the Excel template......
            Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\VendorPoDepotLinkTemplate.xlsx", FileMode.Open, FileAccess.Read)

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

            Dim styleValue As ICellStyle = templateWorkbook.CreateCellStyle()
            styleValue.SetFont(font3)

            styleValue.BorderRight = BorderStyle.Thin
            styleValue.BorderBottom = BorderStyle.Thin
            styleValue.BorderTop = BorderStyle.Thin
            styleValue.BorderLeft = BorderStyle.Thin

            styleValue.VerticalAlignment = VerticalAlignment.Center
            styleValue.Alignment = HorizontalAlignment.Right
            'styleValue.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0 ;_ * -#,##0_ ;_ * ""-""??_ ;_ @_ ")
            styleValue.DataFormat = templateWorkbook.CreateDataFormat().GetFormat("_ * #,##0.00_ ;_ * -#,##0.00_ ;_ * ""-""??_ ;_ @_ ")

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
            cell.SetCellValue("Vendor Po Depot Linking Report As On - " + Format(Now, "dd-MM-yyyy").ToString)

            RowsIndex = 2
            Dim count = 0
            Dim colIndex As Integer = 0

            For i = 0 To dset.Tables(0).Rows.Count - 1
                row = sheet.CreateRow(RowsIndex)
                colIndex = 0

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("unit")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("pono")))
                cell.CellStyle = styleCenter
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("region")))
                cell.CellStyle = styleCenter
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("depot")))
                cell.CellStyle = styleLeft
                colIndex += 1

                cell = row.CreateCell(colIndex)
                cell.SetCellValue(Convert.ToString(dset.Tables(0).Rows(i)("active")))
                cell.CellStyle = styleCenter
                colIndex += 1

                RowsIndex = RowsIndex + 1

            Next

            Dim genReportPath As String = AppDomain.CurrentDomain.BaseDirectory & "Excel_Reports\"
            If Not (Directory.Exists(genReportPath)) Then
                Directory.CreateDirectory(genReportPath)
            End If
            Dim file_name As String = "Vendor_PO_Depot_Linking_" & DateString & ".xlsx"
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
    Private Sub PopulateDepotDropdown()
        Dim cmnDepot As New Common()
        Dim dsDepot As DataSet
        Try
            dsDepot = cmnDepot.Getdepotname(String.Empty)

            If Not (dsDepot Is Nothing) Then

                If Not (dsDepot.Tables(0).Rows.Count = 0) Then

                    chkbxListApplDepots.DataSource = dsDepot
                    chkbxListApplDepots.DataTextField = "depot_name"
                    chkbxListApplDepots.DataValueField = "depot_code"
                    chkbxListApplDepots.DataBind()
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
    End Sub
End Class