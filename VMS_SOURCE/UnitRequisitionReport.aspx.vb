
Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.IO
Imports NPOI.HSSF.UserModel
Imports NPOI.SS.UserModel
Imports NPOI.HSSF.Util

Partial Class UnitRequisitionReport
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

            AddAttributes()
            PopulateUnit()
            'PopulateTokenVendor(ddlTokenVendor)
            PopulateVendorUnitProduct()
            PopulatePackSize()
            gvRequistionList.PageIndex = 0
            'PopulateRequisition()
            BindGrid()
            If (userInfo.userGroupCodeEntity.Equals("VENDOR")) Then
                ddlVendorUnit.Visible = False
                lblTokenVendor.Visible = True
            Else
                ddlVendorUnit.Visible = True
                lblTokenVendor.Visible = False
            End If
        End If

    End Sub

#End Region
#Region "Populate Product dropdown."

    Private Sub PopulateVendorUnitProduct()

        CheckLogin()
        Try
            Dim obj As New UnitApplicableProductAssignClass
            Dim dsProductSet As New DataSet

            dsProductSet = obj.GetProductNameFromUnit(ddlVendorUnit.SelectedValue)
            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                ddlVendorProduct.DataSource = dsProductSet.Tables(0)
                ddlVendorProduct.DataTextField = "sku_desc"
                ddlVendorProduct.DataValueField = "sku_new_code"
                ddlVendorProduct.DataBind()

                If Not (dsProductSet.Tables(0).Rows.Count = 1) Then
                    ddlVendorProduct.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            Else
                ddlPackSize.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
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

#Region "Populate Unit"
    Private Sub PopulateUnit()
        CheckLogin()
        Try
            Dim obj As New UnitApplicableProductAssignClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetUnitName(Constant.Common.ActiveStatus)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlVendorUnit.DataSource = dsUnitSet.Tables(0)
                ddlVendorUnit.DataTextField = "unit_name"
                ddlVendorUnit.DataValueField = "unit_code"
                ddlVendorUnit.DataBind()
                If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
                    ddlVendorUnit.SelectedValue = userInfo.userIDEntity
                    ddlVendorUnit.Enabled = False
                ElseIf (userInfo.userGroupCodeEntity.Equals("HO") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN")) Then
                    If (dsUnitSet.Tables(0).Rows.Count <> 1) Then
                        ddlVendorUnit.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                    End If
                End If
            Else
                ddlPackSize.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Pack Size"
    Private Sub PopulatePackSize()
        CheckLogin()
        Try
            Dim obj As New UnitRequisitionReportClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetApplicablePackSize(ddlVendorUnit.SelectedValue, ddlVendorProduct.SelectedValue)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlPackSize.DataSource = dsUnitSet.Tables(0)
                ddlPackSize.DataTextField = "pack_size"
                ddlPackSize.DataValueField = "uap_pack_size"
                ddlPackSize.DataBind()
                If (dsUnitSet.Tables(0).Rows.Count <> 1) Then
                    ddlPackSize.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                End If
            Else
                ddlPackSize.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
            End If

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
        Try
            Dim obj As New UnitRequisitionReportClass
            Dim dsProductSet As New DataSet
            dsProductSet = obj.GetRequisitionreport(ddlVendorUnit.SelectedValue, ddlVendorProduct.SelectedValue, ddlPackSize.SelectedValue)
            If (Not (dsProductSet Is Nothing) AndAlso dsProductSet.Tables.Count > 0 AndAlso Not (dsProductSet.Tables(0) Is Nothing) AndAlso dsProductSet.Tables(0).Rows.Count > 0) Then
                gvRequistionList.DataSource = dsProductSet.Tables(0)
                gvRequistionList.DataBind()
            Else
                gvRequistionList.DataSource = Nothing
                gvRequistionList.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Token Vendor List"
    Private Sub PopulateTokenVendor(ddl As DropDownList)
        CheckLogin()
        Try
            Dim obj As New UnitApplicableVendorAssignClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetTokenVendorList(String.Empty, Constant.Common.ActiveStatus)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then

                ddl.DataSource = dsUnitSet.Tables(0)
                ddl.DataTextField = "tvm_name"
                ddl.DataValueField = "tvm_code"
                ddl.DataBind()
                If (dsUnitSet.Tables(0).Rows.Count > 0) Then
                    ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    'Protected Sub ddlTokenVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTokenVendor.SelectedIndexChanged

    '    PopulateRequisition()

    '    BindGrid()
    'End Sub

    'Protected Sub ddlVendorRequisition_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorRequisition.SelectedIndexChanged

    'End Sub

    '#Region "Populate Requisition"
    '    Private Sub PopulateRequisition()
    '        CheckLogin()
    '        Try
    '            ddlVendorRequisition.Items.Clear()
    '            Dim obj As New TokenVendorRequisitionClass
    '            Dim dsVendorRequisitionSet As New DataSet

    '            dsVendorRequisitionSet = obj.GetRequisitionForUnitByVendor(Constant.Common.ActiveStatus, ddlTokenVendor.SelectedValue, ddlVendorUnit.SelectedValue)
    '            If (Not (dsVendorRequisitionSet Is Nothing) AndAlso dsVendorRequisitionSet.Tables.Count > 0 AndAlso Not (dsVendorRequisitionSet.Tables(0) Is Nothing) AndAlso dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
    '                ddlVendorRequisition.DataSource = dsVendorRequisitionSet.Tables(0)
    '                ddlVendorRequisition.DataTextField = "trh_id"
    '                ddlVendorRequisition.DataValueField = "trh_id"
    '                ddlVendorRequisition.DataBind()
    '                If (dsVendorRequisitionSet.Tables(0).Rows.Count > 0) Then
    '                    ddlVendorRequisition.Items.Insert(0, New ListItem(Constant.Common.Selec, 0))
    '                End If
    '            Else
    '                ddlVendorRequisition.Items.Insert(0, New ListItem(Constant.Common.Selec, 0))
    '            End If
    '        Catch ex As Exception
    '            Dim returnUrl As String = "~/ExceptionPage.aspx"
    '            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
    '            Server.Transfer(returnUrl)
    '        End Try

    '    End Sub
    '#End Region

    Protected Sub gvProductList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvRequistionList.PageIndexChanging
        gvRequistionList.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub

    Protected Sub gvProductList_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvRequistionList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then

        End If
    End Sub

    'Protected Sub imgbtnExport_Click(sender As Object, e As EventArgs) Handles imgbtnExport.Click
    Protected Sub imgbtnExport_Click(sender As Object, e As EventArgs) Handles imgbtnExport.Click
        Dim ds As New DataSet
        CheckLogin()
        If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("UNIT")) Then
            Try
                ds = GetDsForExcel()
            Catch ex As Exception
                Dim returnUrl As String = "~/ExceptionPage.aspx"
                Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
                Server.Transfer(returnUrl)

            End Try
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    ExportToExcel(ds)
                Else
                    lblErrorMessage.Text = "No Data Found..."
                End If
            Else
                lblErrorMessage.Text = "No Data Found..."
            End If

        Else
            lblErrorMessage.Text = "You are not allowed to download this report."
        End If


    End Sub

    Private Function GetDsForExcel() As DataSet
        Dim ds As New System.Data.DataSet
        Dim obj As New UnitRequisitionReportClass

        Dim active As String = Constant.Common.ActiveStatus
        ds = obj.GetRequisitionreport(ddlVendorUnit.SelectedValue, ddlVendorProduct.SelectedValue, ddlPackSize.SelectedValue)

        Return ds
    End Function

    Private Sub ExportToExcel(ds As DataSet)

        If (ds.Tables(0).Rows.Count > 0) Then
            Dim DateString As String = "_" & Format(Now, "dd-MM-yyyy_HH-mm-ss")
            Dim file_name As String = "UnitRequisition_" + DateString + ".xls"
            Dim genReportPath As String = Server.MapPath(Request.ApplicationPath) & "\Excel_Reports\"

            Try
                Dim fs As FileStream = New FileStream(Server.MapPath(Request.ApplicationPath) & "\Templates\UnitRequisition.xls", FileMode.Open, FileAccess.Read)

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
                'bgWhite.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.WHITE.index
                Row = ReportSheet.GetRow(2)
                Cell = Row.GetCell(4)
                Cell.SetCellValue("Report As On: " & DateTime.Today.ToString("dd/MM/yyyy"))

                Row = ReportSheet.GetRow(1)
                Cell = Row.GetCell(0)
                Cell.SetCellValue("Report Month: " & DateTime.Today.ToString("MMM") & ", " & DateTime.Today.Year.ToString)

                Row = ReportSheet.GetRow(1)
                Cell = Row.GetCell(4)
                Cell.SetCellValue("Report Year: " & DateTime.Today.Year)

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
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("unit_name"))
                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(1)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("requisition_prd_desc"))
                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(2)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("requisition_pack_size"))
                    Cell.CellStyle = alignCenter

                    Cell = Row.CreateCell(3)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("tsm_opening_stock"))
                    Cell.CellStyle = alignRight

                    Cell = Row.CreateCell(4)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("tsm_stock_in"))
                    Cell.CellStyle = alignRight

                    Cell = Row.CreateCell(5)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("tsm_stock_out"))
                    Cell.CellStyle = alignRight

                    Cell = Row.CreateCell(6)
                    Cell.CellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("General")
                    Cell.SetCellValue(ds.Tables(0).Rows(i)("close_qty"))
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
    'Protected Sub imgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnSearch.Click
    '    BindGrid()
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        BindGrid()
    End Sub
    Protected Sub ddlVendorUnit_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorUnit.SelectedIndexChanged
        ddlVendorProduct.Items.Clear()
        PopulateVendorUnitProduct()
        ddlPackSize.Items.Clear()
        PopulatePackSize()
    End Sub
    Protected Sub ddlVendorProduct_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendorProduct.SelectedIndexChanged
        ddlPackSize.Items.Clear()
        PopulatePackSize()
    End Sub
End Class
