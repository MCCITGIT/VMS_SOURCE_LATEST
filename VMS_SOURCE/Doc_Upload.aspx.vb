'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : Doc_Upload.aspx.vb
'Created Date	: 30-December-2011
'Created By	    : Debayan Biswas
'Version	    : R02.00.00
'Description	: Code behind for Doc_Upload.aspx Page

'Modified By       Modified On       Version         Reason

'****************************************************************


Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.IO
Imports VMS.DataAccess
Imports System.Data.SqlClient
Imports System.IO.Path
Imports System.Collections.Generic

Partial Class Doc_Upload
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CheckLogin()
            PageSizeDropdown()
            BindGrid()
            'divF7.Visible = False
            divDetailsSection.Visible = False
            btnSubmit.Visible = False
            btnDelete.Visible = False
            btnCancel.Visible = False

            'sch_fld.Attributes.Add("onChange", "return fnDocExtGet('" + userInfo.userCompanyEntity + "');")
            sch_fld.Attributes.Add("onChange", "return fnCheckExt();")
            btnDelete.Attributes.Add("onClick", "return ValidateDocUpldDelete();")

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
        CheckLogin()

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
            ddlRegion.SelectedValue = "E1"
            ddlRegion.Enabled = False
        End If

    End Sub
#End Region

#Region "Populate Depot"
    Private Sub PopulateDepot()
        CheckLogin()

        Dim DocUpld As New Doc_Upload_App
        Dim DepotSet As New DataSet

        DepotSet = DocUpld.GetDepot(ddlRegion.SelectedValue, Constant.Common.ActiveStatus)
        If (Not (DepotSet Is Nothing) AndAlso DepotSet.Tables.Count > 0 AndAlso Not (DepotSet.Tables(0) Is Nothing) AndAlso DepotSet.Tables(0).Rows.Count > 0) Then
            ddlLocation.DataSource = DepotSet.Tables(0)
            ddlLocation.DataTextField = "depot_name"
            ddlLocation.DataValueField = "depot_code"
            ddlLocation.DataBind()
            ddlLocation.Items.Insert(0, New ListItem("All Depot-999", 999, True))
        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
            ddlLocation.SelectedValue = "009"
            ddlLocation.Enabled = False
        End If
    End Sub
#End Region

#Region "Populate FinYear"
    Private Sub PopulateFinYr()
        CheckLogin()

        Dim DocUpld As New Doc_Upload_App
        Dim FinYrSet As New DataSet

        FinYrSet = DocUpld.GetFinYear(Constant.Common.ActiveStatus)
        If (Not (FinYrSet Is Nothing)) Then
            txtFinYear.Text = FinYrSet.Tables(0).Rows(0)("fin_year")
            txtFinYear.Enabled = False
        End If
    End Sub
#End Region

#Region "Populate From Depot"
    Private Sub PopulateFromDepot()
        CheckLogin()

        Dim DocUpld As New Doc_Upload_App
        Dim FrmDptSet As New DataSet

        FrmDptSet = DocUpld.GetFromDepot(userInfo.userBranchEntity, Constant.Common.ActiveStatus)
        If (Not (FrmDptSet.Tables(0).Rows.Count = 0)) Then
            txtFromDepot.Text = FrmDptSet.Tables(0).Rows(0)("Depot")
            txtFromDepot.Enabled = False
        End If
    End Sub
#End Region

#Region "Populate DocType"
    Private Sub PopulateDocType()
        CheckLogin()

        Dim ObjDocumentType As New Common
        Dim OccupationTypeSet As New DataSet
        Dim LovType As String = Constant.Common.Doc_Type
        OccupationTypeSet = ObjDocumentType.GetLovDetails(userInfo.userCompanyEntity, LovType, Constant.Common.ActiveStatus)
        If (Not (OccupationTypeSet Is Nothing) AndAlso OccupationTypeSet.Tables.Count > 0 AndAlso Not (OccupationTypeSet.Tables(0) Is Nothing) AndAlso OccupationTypeSet.Tables(0).Rows.Count > 0) Then
            ddlDocType.DataSource = OccupationTypeSet.Tables(0)
            ddlDocType.DataTextField = "lov_value"
            ddlDocType.DataValueField = "lov_code"
            ddlDocType.DataBind()
            ddlDocType.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
        '    ddlDocType.SelectedValue = userInfo.userRegionEntity
        '    ddlDocType.Enabled = False
        'End If

    End Sub
#End Region

#Region "Populate Page Size DropDownList"

    ' Populates the page size dropdown
    Private Sub PageSizeDropdown()

        ddlPageSize.Items.Clear()

        'Gets the page size from the web.config file
        Dim configPagesize As String = ConfigurationManager.AppSettings.Get("PageSize")

        Dim numbers As String() = configPagesize.Split(",")
        Dim index As Integer = 0

        While index <= numbers.Length - 1
            Try
                Dim size As Integer = Convert.ToInt32(numbers(index))
                'Adds the page size to drop down list
                ddlPageSize.Items.Add(New ListItem(size.ToString, size.ToString))
            Catch exp As Exception
                ddlPageSize.Items.Clear()
            End Try
            System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
        End While
        gvMasterLinkDocList.PageSize = ddlPageSize.SelectedValue

    End Sub
#End Region

#Region "ddlRegion_SelectedIndexChanged"
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulateDepot()
    End Sub
#End Region

#Region "Bind Grid"
    Private Sub BindGrid()
        CheckLogin()
        Try
            Dim DocUpld As New Doc_Upload_App
            Dim GridSet As New DataSet

            GridSet = DocUpld.GridListGetDetails(userInfo.userDepartmentEntity, userInfo.userBranchEntity, Constant.Common.ActiveStatus)
            If (Not (GridSet Is Nothing) AndAlso GridSet.Tables.Count > 0 AndAlso Not (GridSet.Tables(0) Is Nothing) AndAlso GridSet.Tables(0).Rows.Count > 0) Then
                gvMasterLinkDocList.Visible = True
                Div_MasterLinkDocs_Grid.Visible = False
                gvMasterLinkDocList.PageIndex = 0
                gvMasterLinkDocList.DataSource = FirstDocPage(GridSet.Tables(0))
                gvMasterLinkDocList.DataBind()
                hdnDocHasData.Value = "1"
                hdnDocPageSize.Value = gvMasterLinkDocList.PageSize.ToString()
            Else
                gvMasterLinkDocList.Visible = False
                Div_MasterLinkDocs_Grid.Visible = True
                hdnDocHasData.Value = "0"
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

#Region "Date Format"

    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime
        If Not (stringdate = String.Empty) Then

            Dim ddate As String() = stringdate.Split("/")
            Dim arrlist As New ArrayList
            Dim index As Integer = 0

            While index <= ddate.Length - 1
                arrlist.Add(ddate(index))
                System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
            End While
            Dim dd As Integer = System.Convert.ToInt32(arrlist.Item(0))
            Dim mm As Integer = System.Convert.ToInt32(arrlist.Item(1))
            Dim yyyy As Integer = System.Convert.ToInt32(arrlist.Item(2))

            Dim dt As DateTime = New DateTime(yyyy, mm, dd)
            dt = FormatDateTime(dt, DateFormat.LongDate)

            Return dt
        End If

    End Function

#End Region

#Region "Showing doc"
    Private Function GetDocument(ByVal file_name As String) As String
        CheckLogin()


        Dim docFolder As String = String.Empty
        Dim docFileName As String = String.Empty

        Dim filepath As String

        docFolder = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_REL_PATH") & userInfo.userCompanyEntity & "/" & "Vms Docs" & "/" & "Document_Repository"
        docFileName = file_name
        filepath = docFolder + "/" + docFileName

        Dim fileExtention As String = GetFileExtension(docFileName)
        Dim contentType As String = String.Empty
        Select Case fileExtention.ToUpper()
            Case Constant.FileExtension.DOC
                contentType = Constant.ContentType.Word
            Case Constant.FileExtension.DOCX
                contentType = Constant.ContentType.Word
                'Case Constant.FileExtension.PPT
                '    contentType = Constant.ContentType.PowerPoint
                'Case Constant.FileExtension.PPTX
                '    contentType = Constant.ContentType.PowerPoint
                'Case Constant.FileExtension.PPS
                '    contentType = Constant.ContentType.PowerPoint
                'Case Constant.FileExtension.PPSX
                '    contentType = Constant.ContentType.PowerPoint
            Case Constant.FileExtension.PDF
                contentType = Constant.ContentType.PDF
            Case Constant.FileExtension.TXT
                contentType = Constant.ContentType.Text
            Case Constant.FileExtension.XLS
                contentType = Constant.ContentType.Excel
            Case Constant.FileExtension.XLSX
                contentType = Constant.ContentType.Excel
            Case Constant.FileExtension.JPG
                contentType = Constant.ContentType.JPEG
            Case Constant.FileExtension.JPEG
                contentType = Constant.ContentType.JPEG
            Case Constant.FileExtension.GIF
                contentType = Constant.ContentType.GIF
                'Case Constant.FileExtension.TIF
                '    contentType = Constant.ContentType.TIF
                'Case Constant.FileExtension.HTM
                '    contentType = Constant.ContentType.HTML
                'Case Constant.FileExtension.HTML
                '    contentType = Constant.ContentType.HTML
                'Case Constant.FileExtension.SWF
                '    contentType = Constant.ContentType.SWF
        End Select



        Return filepath
    End Function
#End Region

#Region "Get File Extension"

    ' Gets the File extension from the file Name
    Private Function GetFileExtension(ByVal fileName As String) As String
        Dim extension As String = String.Empty
        If (fileName.LastIndexOf(".") >= 0) Then
            extension = fileName.Substring(fileName.LastIndexOf(".") + 1)
        End If

        Return extension
    End Function

#End Region

#Region "gvMasterLinkDocList Event Handeling"
    'Protected Sub gvMasterLinkDocList_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvMasterLinkDocList.PageIndexChanging
    '    gvMasterLinkDocList.PageIndex = e.NewPageIndex
    '    BindGrid()
    'End Sub

    Protected Sub gvMasterLinkDocList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMasterLinkDocList.RowCommand

        If e.CommandName = "PopulateDtl" Then
            Dim sItem As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)
            Dim index As Integer = sItem.RowIndex
            Dim hdnGenId As HiddenField = CType(gvMasterLinkDocList.Rows(index).FindControl("hdnGenId"), HiddenField)
            OpenMasterDoc(CType(hdnGenId.Value, Integer))
        End If
    End Sub

    'Protected Sub gvMasterLinkDocList_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMasterLinkDocList.RowCreated
    '    If (e.Row.RowType = DataControlRowType.DataRow) Then
    '        Dim lnk As LinkButton
    '        lnk = e.Row.FindControl("lnk_FrmDpt")

    '        AddHandler lnk.Click, New EventHandler(AddressOf ImgbtnAdd_Click)
    '    End If
    'End Sub

    Protected Sub gvMasterLinkDocList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMasterLinkDocList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            'e.Row.Cells(0).Text = e.Row.RowIndex + 1
            Dim pageIdx As Integer = gvMasterLinkDocList.PageIndex * ddlPageSize.SelectedValue
            'e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            'e.Row.Cells(5).Text = "<a href='FileView.aspx?url=" + rowView("sdocs_gen_id") + "&" + (Constant.SessionKeys.DocGenId) + "=" + rowView("sdocs_gen_id") + " 'class='hl' Title='Edit'>" + rowView("sdocs_doc_title") + "</a>"
            'e.Row.Cells(1).Text = "<a href='Doc_Upload.aspx?" & Constant.SessionKeys.DocGenId & "=" & rowView("sdocs_gen_id") & "'class='hl'>" & rowView("sdocs_from_depot") & "</a>"

            'Dim lnk As LinkButton
            'lnk = e.Row.FindControl("lnk_FrmDpt")
            'lnk.Text = CType(rowView("sdocs_from_depot"), String)
            'lnk.PostBackUrl = "Doc_Upload.aspx?"  & Constant.SessionKeys.DocGenId & "=" & rowView("sdocs_gen_id")

            'Dim hdn As HiddenField
            'hdn = e.Row.FindControl("hdnGenId")
            'hdn.Value = Constant.SessionKeys.DocGenId & "=" & rowView("sdocs_gen_id")

            If rowView("sdocs_to_depot") Is DBNull.Value Then
                e.Row.Cells(2).Text = "All Depot"
            End If

            Dim Page As String = GetDocument(rowView("sdocs_file_name"))

            'e.Row.Cells(5).Text = rowView("sdocs_doc_title").ToString
            'e.Row.Cells(5).Attributes.Add("onClick", "newwindow('" & Page & "');")

            'e.Row.Cells(5).Attributes.Add("Style", "Cursor:hand")
            'e.Row.Cells(5).ForeColor = Drawing.Color.FromArgb(132, 132, 132)

            Dim lblTitle As Label = e.Row.FindControl("lblTitle")
            lblTitle.Text = rowView("sdocs_doc_title").ToString
            lblTitle.Attributes.Add("onClick", "newwindow('" + Page + "');")

            lblTitle.Attributes.Add("Style", "Cursor:hand")
            lblTitle.ForeColor = Drawing.Color.FromArgb(132, 132, 132)

            Dim img_new As Image = e.Row.FindControl("img_new")
            If (CType(rowView("no_of_days"), Integer) < 16) Then
                img_new.Visible = True
            Else
                img_new.Visible = False
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
#End Region

#Region "ddlPageSize_SelectedIndexChanged Event Handeling"
    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvMasterLinkDocList.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        BindGrid()
    End Sub
#End Region

#Region "ImageButtonAdd Click Event Handelling"
    'Protected Sub ImgbtnAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnAdd.Click
    '    divF7.Visible = True
    '    divDetailsSection.Visible = True
    '    If Not IsPostBack Then
    '    PopulateRegion()
    '    PopulateDepot()
    '    PopulateFinYr()
    '    PopulateDocType()
    '    PopulateFromDepot()
    '    txtUpdatedBy.Text = userInfo.userIDEntity
    '    txtUpdatedBy.Enabled = False
    '    txtUpdatedDt.Text = Format(Date.Today, "dd/MM/yyyy")
    '    txtUpdatedDt.Enabled = False
    '    txtTitle.Text = ""
    '    txtRemark.Text = ""
    '    txtDocNo.Text = ""
    '    txtdocdt.Text = ""
    '    btnSubmit.Visible = True
    '    btnDelete.Visible = True
    '    btnDelete.Enabled = False
    '    btnCancel.Visible = True
    '    If Not Request.QueryString(Constant.SessionKeys.DocGenId) Is Nothing Then
    '        PopulateEditMode()
    '        btnSubmit.CommandName = Constant.GeneralMessages.btnUpdate
    '    Else
    '    btnSubmit.Text = Constant.GeneralMessages.btnSubmit
    '    btnSubmit.Attributes.Add("onClick", "return ValidateDocUpld('" + btnSubmit.Text + "');")
    '    If btnSubmit.Text = Constant.GeneralMessages.btnSubmit Then
    '    btnSubmit.Attributes.Add("onClick", "return ValidateDocUpld();")
    '    Else
    '        btnSubmit.Attributes.Add("onClick", "return ValidateDocUpldUpdate();")
    '    End If
    '    End If
    '    End If
    'End Sub

    Protected Sub ImgbtnAdd_Click(sender As Object, e As EventArgs) Handles ImgbtnAdd.Click
        'divF7.Visible = True
        divDetailsSection.Visible = True
        'If Not IsPostBack Then
        PopulateRegion()
        PopulateDepot()
        PopulateFinYr()
        PopulateDocType()
        PopulateFromDepot()
        txtUpdatedBy.Text = userInfo.userIDEntity
        txtUpdatedBy.Enabled = False
        txtUpdatedDt.Text = Format(Date.Today, "dd/MM/yyyy")
        txtUpdatedDt.Enabled = False
        txtTitle.Text = ""
        txtRemark.Text = ""
        txtDocNo.Text = ""
        txtdocdt.Text = ""
        btnSubmit.Visible = True
        btnDelete.Visible = True
        btnDelete.Enabled = False
        btnCancel.Visible = True
        'If Not Request.QueryString(Constant.SessionKeys.DocGenId) Is Nothing Then
        '    PopulateEditMode()
        '    btnSubmit.CommandName = Constant.GeneralMessages.btnUpdate
        'Else
        btnSubmit.Text = Constant.GeneralMessages.btnSubmit
        btnSubmit.Attributes.Add("onClick", "return ValidateDocUpld('" + btnSubmit.Text + "');")
        'If btnSubmit.Text = Constant.GeneralMessages.btnSubmit Then
        'btnSubmit.Attributes.Add("onClick", "return ValidateDocUpld();")
        'Else
        '    btnSubmit.Attributes.Add("onClick", "return ValidateDocUpldUpdate();")
        'End If
        'End If
        'End If
    End Sub

#End Region

#Region "Populate Edit Mode"
    Private Sub PopulateEditMode(ByVal GenId As Integer)
        CheckLogin()

        'Dim hdn As HiddenField = Page.FindControl("hdnLeadId")
        'Dim GenId As Integer = hdn.Value
        'Dim GenId As Integer = CType(Request.QueryString(Constant.SessionKeys.DocGenId), Integer)

        Dim DocUpld As New Doc_Upload_App
        Dim EditModeSet As New DataSet

        EditModeSet = DocUpld.GetEditModeDetails(GenId, Constant.Common.ActiveStatus)
        If (Not (EditModeSet Is Nothing) AndAlso EditModeSet.Tables.Count > 0 AndAlso Not (EditModeSet.Tables(0) Is Nothing) AndAlso EditModeSet.Tables(0).Rows.Count > 0) Then
            PopulateRegion()
            ddlRegion.SelectedValue = IIf(EditModeSet.Tables(0).Rows(0)("region") Is DBNull.Value, String.Empty, EditModeSet.Tables(0).Rows(0)("region"))
            PopulateDepot()
            ddlLocation.SelectedValue = IIf(EditModeSet.Tables(0).Rows(0)("sdocs_to_depot") Is DBNull.Value, 999, EditModeSet.Tables(0).Rows(0)("sdocs_to_depot"))
            PopulateDocType()
            txtFromDepot.Text = EditModeSet.Tables(0).Rows(0)("from_depot")
            txtFromDepot.Enabled = False
            hdnFrmDepot.Value = EditModeSet.Tables(0).Rows(0)("sdocs_from_depot")
            txtFinYear.Text = EditModeSet.Tables(0).Rows(0)("sdocs_fin_year")
            txtFinYear.Enabled = False
            ddlDocType.SelectedValue = EditModeSet.Tables(0).Rows(0)("sdocs_doc_catg")
            txtTitle.Text = EditModeSet.Tables(0).Rows(0)("sdocs_doc_title")
            txtRemark.Text = IIf(EditModeSet.Tables(0).Rows(0)("sdocs_remarks") Is DBNull.Value, String.Empty, EditModeSet.Tables(0).Rows(0)("sdocs_remarks"))
            txtDocNo.Text = EditModeSet.Tables(0).Rows(0)("sdocs_doc_no")
            'txtDocNo.Enabled = False
            txtdocdt.Text = EditModeSet.Tables(0).Rows(0)("sdocs_doc_date")
            txtUpdatedBy.Text = EditModeSet.Tables(0).Rows(0)("created_user")
            txtUpdatedBy.Enabled = False
            txtUpdatedDt.Text = Format(EditModeSet.Tables(0).Rows(0)("created_date"), "dd/MM/yyyy")
            txtUpdatedDt.Enabled = False
        End If
        btnSubmit.Text = Constant.GeneralMessages.btnUpdate

        'btnSubmit.Attributes.Add("onClick", "return ValidateDocUpldUpdate();")
    End Sub
#End Region

#Region "Insert Document"
    Private Function InsertDocument() As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing

        Dim Extension As String = String.Empty
        ' Set the Response Content Type based on the file extension
        Extension = GetFileExtension(sch_fld.FileName)

        Dim numRowsAffected As Integer
        Dim DocEntity As New DocUpload_Entity
        Dim DocUpld As New Doc_Upload_App

        DocEntity.DocsFromDepot = userInfo.userBranchEntity
        DocEntity.DocsToDepot = ddlLocation.SelectedValue
        DocEntity.DocsFinYear = txtFinYear.Text
        DocEntity.DocsDocCatg = ddlDocType.SelectedValue
        DocEntity.DocsDocTitle = txtTitle.Text
        DocEntity.DocsDocDate = FormatDate(txtdocdt.Text)
        DocEntity.DocsRemarks = txtRemark.Text
        DocEntity.DocsDocNo = txtDocNo.Text
        DocEntity.CreatedUser = userInfo.userIDEntity
        DocEntity.DocActive = Constant.Common.ActiveStatus

        Dim new_srl As Integer = (DocUpld.GetRowCount() + 1)
        DocEntity.DocsFileName = GetFileNameWithoutExtension(sch_fld.FileName) + "_" + CType(new_srl, String) + "." + Extension
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            numRowsAffected = DocUpld.InsertDocument(DocEntity, sqlConn, sqlTrans)
            If numRowsAffected > 0 Then
                If Not sch_fld.PostedFile Is Nothing And sch_fld.PostedFile.ContentLength > 0 Then
                    Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Vms Docs" & "\" & "Document_Repository"


                    Dim fn As String = System.IO.Path.GetFileName(sch_fld.PostedFile.FileName)
                    fn = GetFileNameWithoutExtension(fn) + "_" + CType(new_srl, String) + "." + Extension
                    Dim saveLocation As String = projectPath & "\" & fn


                    Dim file As System.IO.FileInfo = New System.IO.FileInfo(saveLocation)


                    If Not (Directory.Exists(projectPath)) Then
                        Directory.CreateDirectory(projectPath)
                    End If
                    sch_fld.PostedFile.SaveAs(saveLocation)
                End If
                sqlTrans.Commit()
            Else
                sqlTrans.Rollback()
            End If
        Catch ex As Exception
            sqlTrans.Rollback()
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
            Server.Transfer(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
            End If
        End Try
        Return numRowsAffected
    End Function
#End Region

#Region "Update Document"
    Private Function UpdateDocument() As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing


        'Dim leadid As Integer = CType(lblleadid.Text, Integer)
        'Dim projectname As String = lblleadoppr.Text


        Dim Extension As String = String.Empty
        ' Set the Response Content Type based on the file extension
        Extension = GetFileExtension(sch_fld.FileName)

        Dim numRowsAffected As Integer
        Dim DocEntity As New DocUpload_Entity
        Dim DocUpld As New Doc_Upload_App

        DocEntity.DocsFromDepot = userInfo.userBranchEntity
        DocEntity.DocsToDepot = ddlLocation.SelectedValue
        DocEntity.DocsFinYear = txtFinYear.Text
        DocEntity.DocsDocCatg = ddlDocType.SelectedValue
        DocEntity.DocsDocTitle = txtTitle.Text
        DocEntity.DocsDocDate = FormatDate(txtdocdt.Text)
        DocEntity.DocsRemarks = txtRemark.Text
        DocEntity.DocsDocNo = txtDocNo.Text
        DocEntity.ModifiedUser = userInfo.userIDEntity
        DocEntity.DocActive = Constant.Common.ActiveStatus

        DocEntity.DocsGenId = CType(hdnDocGenId.Value, Integer)
        'DocEntity.DocsGenId = CType(Request.QueryString(Constant.SessionKeys.DocGenId), Integer)

        If sch_fld.HasFile Then
            DocEntity.DocsFileName = GetFileNameWithoutExtension(sch_fld.FileName) + "_" + CType(hdnDocGenId.Value, String) + "." + Extension
        Else
            DocEntity.DocsFileName = String.Empty
        End If

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            numRowsAffected = DocUpld.UpdateDocument(DocEntity, sqlConn, sqlTrans)
            If numRowsAffected > 0 Then
                If Not sch_fld.PostedFile Is Nothing And sch_fld.PostedFile.ContentLength > 0 Then
                    Dim projectPath As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_ABS_PATH") & userInfo.userCompanyEntity & "\" & "Vms Docs" & "\" & "Document_Repository"


                    Dim fn As String = System.IO.Path.GetFileName(sch_fld.PostedFile.FileName)
                    fn = GetFileNameWithoutExtension(fn) + "_" + CType(hdnDocGenId.Value, String) + "." + Extension
                    Dim saveLocation As String = projectPath & "\" & fn


                    Dim file As System.IO.FileInfo = New System.IO.FileInfo(saveLocation)


                    If Not (Directory.Exists(projectPath)) Then
                        Directory.CreateDirectory(projectPath)
                    End If
                    sch_fld.PostedFile.SaveAs(saveLocation)
                End If
                sqlTrans.Commit()
            Else
                sqlTrans.Rollback()
            End If
        Catch ex As Exception
            sqlTrans.Rollback()
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.FileUploadError
            Server.Transfer(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
            End If
        End Try
        Return numRowsAffected
    End Function
#End Region

#Region "Delete Document"
    Private Function DeleteDocument() As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing

        Dim numRowsAffected As Integer
        Dim DocUpld As New Doc_Upload_App

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            numRowsAffected = DocUpld.DeleteDocument(CType(hdnDocGenId.Value, Integer), userInfo.userIDEntity, sqlConn, sqlTrans)
            If numRowsAffected > 0 Then
                sqlTrans.Commit()
            Else
                sqlTrans.Rollback()
            End If
        Catch ex As Exception
            If Not (sqlTrans Is Nothing) Then
                'SqlTrans is set to Rollback to go back to the beginning of the transaction
                sqlTrans.Rollback()
            End If
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
                Server.Transfer("~/Doc_Upload.aspx")
            End If
        End Try

    End Function
#End Region

#Region "Submit Button Click Event Handelling"
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        CheckLogin()
        If btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then
            UpdateDocument()
        Else
            InsertDocument()
        End If

        Response.Redirect("Doc_Upload.aspx")

    End Sub
#End Region

#Region "Button Delete Click Event Handelling"
    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        CheckLogin()
        DeleteDocument()
    End Sub
#End Region

#Region "Cancel Button Click Event Handeling"
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect("Doc_Upload.aspx")
    End Sub
#End Region

    Private Sub OpenMasterDoc(ByVal docGenId As Integer)
        divDetailsSection.Visible = True
        hdnDocGenId.Value = docGenId.ToString()
        PopulateEditMode(docGenId)
        If hdnFrmDepot.Value = userInfo.userBranchEntity Then
            btnSubmit.Visible = True
            btnSubmit.CommandName = Constant.GeneralMessages.btnUpdate
            btnSubmit.Enabled = True
            btnDelete.Visible = True
            btnDelete.Enabled = True
            sch_fld.Enabled = True
        Else
            btnSubmit.Visible = True
            btnSubmit.CommandName = Constant.GeneralMessages.btnUpdate
            btnSubmit.Enabled = False
            btnDelete.Visible = True
            btnDelete.Enabled = False
            sch_fld.Enabled = False
        End If
        btnCancel.Visible = True
        btnSubmit.Attributes.Add("onClick", "return ValidateDocUpld('" + btnSubmit.Text + "');")
    End Sub

    Private Function FirstDocPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvMasterLinkDocList.PageSize
        If pageSize <= 0 Then pageSize = 15
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    Protected Sub btnDocOpen_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocOpen.Click
        Dim docGenId As Integer
        If Integer.TryParse(hdnDocOpenId.Value, docGenId) Then OpenMasterDoc(docGenId)
    End Sub

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function GetMoreMasterDocs(ByVal pageIndex As Integer, ByVal pageSize As Integer) As Object
        Dim rows As New List(Of Object)
        If System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo) Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim userInfo As VMSUserEntity = CType(System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        If pageSize <= 0 Then pageSize = 15
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New Doc_Upload_App().GridListGetDetails(userInfo.userDepartmentEntity, userInfo.userBranchEntity, Constant.Common.ActiveStatus)
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim folder As String = ConfigurationManager.AppSettings.Get("UPLOAD_DOCS_FOLDER_REL_PATH") & userInfo.userCompanyEntity & "/" & "Vms Docs" & "/" & "Document_Repository"
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                Dim toDepot As String = Convert.ToString(dr("sdocs_to_depot"))
                If String.IsNullOrEmpty(toDepot) Then toDepot = "All Depot"
                Dim days As Integer
                Dim isNew As Boolean = dr.Table.Columns.Contains("no_of_days") AndAlso Integer.TryParse(Convert.ToString(dr("no_of_days")), days) AndAlso days < 16
                Dim fileName As String = Convert.ToString(dr("sdocs_file_name"))
                rows.Add(New With {
                    .serial = (i + 1).ToString(),
                    .fromDepot = Convert.ToString(dr("sdocs_from_depot")),
                    .genId = Convert.ToString(dr("sdocs_gen_id")),
                    .toDepot = toDepot,
                    .year = Convert.ToString(dr("sdocs_fin_year")),
                    .docType = Convert.ToString(dr("sdocs_doc_catg")),
                    .title = Convert.ToString(dr("sdocs_doc_title")),
                    .docNo = Convert.ToString(dr("sdocs_doc_no")),
                    .docDate = Convert.ToString(dr("sdocs_doc_date")),
                    .remarks = Convert.ToString(dr("sdocs_remarks")),
                    .fileUrl = folder & "/" & fileName,
                    .isNew = isNew
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function
End Class
