'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : Vendor_SKU_AddUpdate.aspx.vb
'Created Date	: 05-Dec-2011
'Created By	    : Deepak 
'Version	    : R02.00.00
'Description	: Code behind for Vendor_SKU_AddUpdate Page

'Modified By       Modified On       Version         Reason

'****************************************************************
Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.IO
Imports VMS.DataAccess

Partial Class Vendor_SKU_AddUpdate
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity
    Shared SKUCode, DepotCode, Unit As String


#Region "Page Load Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.MaintainScrollPositionOnPostBack = True
        'btnMoveSelectedCheckBox.Visible = False
        checkLogin()
        If Not IsPostBack Then
            AddAttributes()
            populatVendorUnit()
            PopulateRegion()
            PageSizeDropdown()
            PopulategvVendorSelect()

            If Not (Request.QueryString(Constant.SessionKeys.SKUCode) = Nothing AndAlso Request.QueryString(Constant.SessionKeys.Unit) = Nothing) Then
                btnSubmit.CommandName = Constant.GeneralMessages.btnUpdate
                btnSubmit.Text = Constant.GeneralMessages.btnUpdate

                Dim SKUCode As String = Request.QueryString(Constant.SessionKeys.SKUCode)
                Dim Unit As String = Request.QueryString(Constant.SessionKeys.Unit)
                PopulateVendorProfile(SKUCode, Unit)
                PopulategvVendorSelect()

            End If

            'If (Not (Request.QueryString("Type") Is Nothing)) Then
            '    If ((Request.QueryString("Type") = Constant.Common.Modify)) Then
            '        btnSubmit.Text = Constant.GeneralMessages.btnUpdate
            '        v_sku_code = Request.QueryString("v_sku_code")
            '        DepotCode = Request.QueryString("DepotCode")
            '        VendorUnit = Request.QueryString("VendorUnit")
            '        PopulateVendorProfile(v_sku_code, VendorUnit)
            '        PopulategvVendorSelect()

            '        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN) Then

            '        End If

            '    Else
            '        btnSubmit.Text = Constant.GeneralMessages.Submit

            '    End If
            'End If

        Else
            If (Not (Request.QueryString("Type") Is Nothing)) Then
                If ((Request.QueryString("Type") = Constant.Common.Modify)) Then
                    btnSubmit.Text = Constant.GeneralMessages.btnUpdate
                   
                Else
                    btnSubmit.Text = Constant.GeneralMessages.Submit
                End If
            End If

        End If
    End Sub
#End Region
#Region "AddAttributes"
    Private Sub AddAttributes()
        btnSubmit.Attributes.Add("onClick", "return ValidateSearchInfo();")
        ImgbtnTrans.Attributes.Add("onClick", "return ValidateSearchInfo();")
        ImgbtnTransUp.Attributes.Add("onClick", "return ValidateSearchInfo();")
        txtSKU.Attributes.Add("OnBlur", "return ValidateSearchInfo();")
        btnSkuCode.Attributes.Add("style", "display:none;")

    End Sub
#End Region
#Region "Check if already logged in as a valid user of this page"
    Public Sub checkLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
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
        gvVendorSelect.PageSize = ddlPageSize.SelectedValue

    End Sub
#End Region

#Region "Populate  Venodr Unit "
    Public Sub populatVendorUnit()

        checkLogin()
        

        Dim VendorUnit As New VendorMaster
        Dim Vendords As New DataSet
        Vendords = VendorUnit.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (Vendords Is Nothing) AndAlso Vendords.Tables.Count > 0 AndAlso Not (Vendords.Tables(0) Is Nothing) AndAlso Vendords.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = Vendords.Tables(0)
            ddlVendor.DataTextField = "unit_name"
            ddlVendor.DataValueField = "unit_code"
            ddlVendor.DataBind()
            'ddlVendor.Items.Insert(0, New ListItem("ALL", String.Empty, True))

        Else
            ddlVendor.Items.Insert(0, New ListItem("Select", String.Empty, True))
        End If
        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
            ddlVendor.SelectedValue = userInfo.userUnitEntity
            ddlVendor.Enabled = False
        End If

    End Sub
#End Region
#Region "Function to populate Vendor Details for further modification"
    Private Sub PopulateVendorProfile(ByVal v_sku_code As String, ByVal VendorUnit As String)

        checkLogin()
        Dim VendorProfile As New VendorMasterEntity
        Dim VendorDB As New VendorMaster
        Dim VendorDs As New DataSet
        VendorDs = VendorDB.VendorDetails(v_sku_code, VendorUnit)


        If (Not (VendorDs Is Nothing) AndAlso VendorDs.Tables.Count > 0 AndAlso Not (VendorDs.Tables(0) Is Nothing) AndAlso VendorDs.Tables(0).Rows.Count > 0) Then

            ddlVendor.SelectedValue = VendorDs.Tables(0).Rows(0)("v_vendor_unit")
            ddlVendor.Enabled = False
            txtSKU.Text = VendorDs.Tables(0).Rows(0)("v_sku_code")
            txtSKU.Enabled = False
            txtDesc.Text = (VendorDs.Tables(0).Rows(0)("SkuDescription"))
            txtDesc.Enabled = False
            gvVendorAdd.Visible = True
            gvVendorAdd.DataSource = VendorDs.Tables(0)
            gvVendorAdd.DataBind()
        Else

            'ddlVendor.SelectedValue = VendorDs.Tables(0).Rows(0)("v_vendor_unit")
            'txtSKU.Text = VendorDs.Tables(0).Rows(0)("v_sku_code")
            'txtDesc.Text = (VendorDs.Tables(0).Rows(0)("SkuDescription"))

            gvVendorAdd.Visible = True
            gvVendorAdd.DataSource = VendorDs.Tables(0)
            gvVendorAdd.DataBind()
        End If
        'ddlEngDepot.SelectedValue = EngProfile.EngLocation_code
        'ddlEngClassifi.SelectedValue = EngProfile.Engclassification
        'txtbxLongName.Text = EngProfile.EngLong_name
        'txtbxShortName.Text = EngProfile.EngShortName
        'txtBxmobile.Text = EngProfile.EngmobileNo
    End Sub

#End Region
#Region "Populate Region"
    Private Sub PopulateRegion()
        Dim GetRegion As New Common
        'ProjectType holds user type from Lov_Details table using Lov_Details_Get SP
        Dim RegiontypeDS As DataSet = GetRegion.GetLovDetails(userInfo.userCompanyEntity, Constant.Common.REGION_TYPE, Constant.Common.ActiveStatus)
        If userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT Then

            ddlRegion.Items.Insert(0, New ListItem(userInfo.userRegionEntity, userInfo.userRegionEntity, True))
            ddlRegion.Enabled = False
        Else
            If Not (RegiontypeDS Is Nothing) Then
                ddlRegion.DataSource = RegiontypeDS
                ddlRegion.DataTextField = "Lov_Value"
                ddlRegion.DataValueField = "Lov_Code"
                ddlRegion.DataBind()

                ddlRegion.Items.Insert(0, New ListItem("ALL", "", True))
                'ddlOrderBy.Items.Insert(0, New ListItem("Region", "Region"))

            End If
        End If
    End Sub
#End Region
#Region "Vendor SKU Search Result for SKU Code"
    'Protected Sub btnSkuCode_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSkuCode.Click
    Protected Sub btnSkuCode_Click(sender As Object, e As EventArgs) Handles btnSkuCode.Click
        '    checkLogin()
        Dim VendorListset As New DataSet
        Dim Vendor_mstr As New VendorMaster

        Dim company As String
        Dim VendorUnit As String
        Dim SKUCode As String
        company = userInfo.userCompanyEntity

        VendorUnit = Trim(ddlVendor.SelectedValue)
        SKUCode = Trim(txtSKU.Text)
        VendorListset = Vendor_mstr.GetVendorListForSKUCode(SKUCode)

        If (Not (VendorListset Is Nothing) AndAlso VendorListset.Tables.Count > 0 AndAlso Not (VendorListset.Tables(0) Is Nothing) AndAlso VendorListset.Tables(0).Rows.Count > 0) Then
            txtDesc.Text = VendorListset.Tables(0).Rows(0)("SkuDescription")
            'gvVendorAdd.Visible = True
            'gvVendorAdd.DataSource = VendorListset.Tables(0)
            'gvVendorAdd.DataBind()
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Sku Code Not Found')", True)
            txtDesc.Text = ""
        End If

        PopulateVendorProfile(Trim(txtSKU.Text), ddlVendor.SelectedValue)
        PopulategvVendorSelect()

    End Sub
#End Region
#Region "Populate Vendor SKU Region List Grid"
    Public Sub PopulategvVendorSelect()
        checkLogin()
        Dim VendorListRegionset As New DataSet
        Dim Vendor_mstr As New VendorMaster
        Dim company As String
        Dim VendorRegion As String
        Dim VendorSku As String
        Dim VendorUnit As String
        company = userInfo.userCompanyEntity
        VendorRegion = Trim(ddlRegion.SelectedValue)
        VendorSku = Trim(txtSKU.Text)
        VendorUnit = Trim(ddlVendor.SelectedValue)
        VendorListRegionset = Vendor_mstr.GetVendorListRegion(VendorRegion, VendorSku, VendorUnit)
        gvVendorSelect.DataSource = VendorListRegionset.Tables(0)
        gvVendorSelect.DataBind()
    End Sub
#End Region
#Region "Gridview PageIndexChanging event handling"
    Protected Sub gvVendorSelect_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvVendorSelect.PageIndexChanging
        gvVendorSelect.PageIndex = e.NewPageIndex
        ''SaveSearchCriteria()
        PopulategvVendorSelect()
    End Sub

#End Region
#Region "Gridview RowDataBound event handling."
    Protected Sub gvVendorSelect_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVendorSelect.RowDataBound

        If (e.Row.RowType = DataControlRowType.Pager) Then
            Dim row As TableRow = New TableRow
            row = e.Row.Controls(0).Controls(0).Controls(0)
            For Each cell As TableCell In row.Cells
                Dim lb As Control = cell.Controls(0)


                If (TypeOf (lb) Is Label) Then

                    CType(lb, Label).CssClass = "lblpager"
                    'CType(lb, Label).Width = 20
                    'CType(lb, Label).Height = 15

                ElseIf (TypeOf (lb) Is LinkButton) Then

                    CType(lb, LinkButton).CssClass = "lnkpager"
                    'CType(lb, LinkButton).Width = 20
                    'CType(lb, LinkButton).Height = 15
                    'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
                End If

            Next
        ElseIf (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

           
        End If
    End Sub

#End Region
#Region "Gridview PageIndexChanging event handling"
    Protected Sub gvVendorAdd_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvVendorAdd.PageIndexChanging
        gvVendorAdd.PageIndex = e.NewPageIndex
        'SaveSearchCriteria()

    End Sub
#End Region
#Region "Gridview RowDataBound event handling."
    Protected Sub gvVendorAdd_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVendorAdd.RowDataBound

        'If (e.Row.RowType = DataControlRowType.Pager) Then
        '    Dim row As TableRow = New TableRow
        '    row = e.Row.Controls(0).Controls(0).Controls(0)
        '    For Each cell As TableCell In row.Cells
        '        Dim lb As Control = cell.Controls(0)


        '        If (TypeOf (lb) Is Label) Then

        '            CType(lb, Label).CssClass = "lblpager"
        '            CType(lb, Label).Width = 20
        '            CType(lb, Label).Height = 15

        '        ElseIf (TypeOf (lb) Is LinkButton) Then

        '            CType(lb, LinkButton).CssClass = "lnkpager"
        '            CType(lb, LinkButton).Width = 20
        '            CType(lb, LinkButton).Height = 15
        '            CType(lb, LinkButton).ForeColor = Drawing.Color.Black
        '        End If

        '    Next
        'ElseIf (e.Row.RowType = DataControlRowType.DataRow) Then
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim chk As CheckBox = e.Row.FindControl("ChkSelect")
            ' If btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then
            'If Not rowView("ChkSelect").Equals(DBNull.Value) Then
            chk.Checked = True
            'End If
            Dim tsl As TextBox = e.Row.FindControl("txtTsl")
            If Not rowView("v_tsl_factor").Equals(DBNull.Value) Then
                tsl.Text = rowView("v_tsl_factor")
            End If

            Dim ddlPA As DropDownList = e.Row.FindControl("ddlPA")
            If Not rowView("v_primary_secondary").Equals(DBNull.Value) Then
                ddlPA.SelectedValue = rowView("v_primary_secondary")
            End If


            ' End If
        End If
    End Sub

#End Region
#Region "gridview rowcommand event"
    'Protected Sub gvVendorSKUList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvVendorSKUList.RowCommand
    '    If (e.CommandName = "Update") Then
    '        Dim currentRowIndex As Integer = Int32.Parse(e.CommandArgument)
    '        Dim v_sku_code As String = gvVendorSelect.DataKeys(currentRowIndex)("v_sku_code")

    '        'SaveSearchCriteria()

    '        Response.Redirect("~/Vendor_SKU_AddUpdate.aspx?Type" + "=" + Constant.Common.Modify + "&" + "v_sku_code" + "=" + v_sku_code)
    '    End If
    'End Sub
#End Region
    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRegion.SelectedIndexChanged
        PopulategvVendorSelect()

    End Sub
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        checkLogin()

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        Dim numRowsDeleted As Integer
        Dim RowIndex1 As Integer = 0
        Dim VendorInsert As New VendorMaster

        
        Try
            If btnSubmit.Text = Constant.GeneralMessages.btnSubmit Then
                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()

                ' numRowsDeleted = VendorInsert.DeleteVendorSkuMaster(txtSKU.Text, ddlVendor.SelectedValue, Constant.Common.ActiveStatus, sqlConn, sqlTrans)

                For RowIndex1 = 0 To gvVendorAdd.Rows.Count - 1
                    Dim chkbx1 As CheckBox = gvVendorAdd.Rows(RowIndex1).FindControl("ChkSelect")
                    If chkbx1.Checked = True Then

                        Dim Ps, depotcode, skuCode, vendorUnit As String
                        Dim hdnDepot As HiddenField
                        Dim Tsl As Decimal

                        Dim ddlPA As DropDownList = gvVendorAdd.Rows(RowIndex1).FindControl("ddlPA")
                        If Not ddlPA Is Nothing Then
                            Ps = ddlPA.SelectedValue
                        Else
                            Ps = String.Empty
                        End If
                        Dim txtTsl As TextBox = gvVendorAdd.Rows(RowIndex1).FindControl("txtTsl")
                        Tsl = CType(txtTsl.Text, Decimal)
                        'Tsl = txtTsl.Text
                        skuCode = txtSKU.Text
                        vendorUnit = ddlVendor.SelectedValue
                        hdnDepot = gvVendorAdd.Rows(RowIndex1).FindControl("hdnDepot")

                        numRowsAffected = VendorInsert.UpdateVendorDetails(vendorUnit, Tsl, Ps, userInfo.userIDEntity, Constant.Common.ActiveStatus, skuCode, hdnDepot.Value, sqlConn, sqlTrans)
                        'numRowsAffected = VendorInsert.InsrtVendorDetails(vendorUnit, Tsl, Ps, userInfo.userIDEntity, Constant.Common.ActiveStatus, skuCode, hdnDepot.Value, sqlConn, sqlTrans)


                    End If
                Next
                If numRowsAffected > 0 Then
                    sqlTrans.Commit()
                Else
                    sqlTrans.Rollback()
                End If

            ElseIf btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then
                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()
                For RowIndex1 = 0 To gvVendorAdd.Rows.Count - 1
                    Dim chkbx1 As CheckBox = gvVendorAdd.Rows(RowIndex1).FindControl("ChkSelect")
                    If chkbx1.Checked = True Then

                        Dim Ps, depotcode, skuCode, vendorUnit As String
                        Dim hdnDepot As HiddenField
                        Dim Tsl As Decimal
                        Dim ddlPA As DropDownList = gvVendorAdd.Rows(RowIndex1).FindControl("ddlPA")
                        If Not ddlPA Is Nothing Then
                            Ps = ddlPA.SelectedValue
                        Else
                            Ps = String.Empty
                        End If
                        Dim txtTsl As TextBox = gvVendorAdd.Rows(RowIndex1).FindControl("txtTsl")
                        Tsl = CType(txtTsl.Text, Decimal)

                        skuCode = txtSKU.Text
                        vendorUnit = ddlVendor.SelectedValue
                        hdnDepot = gvVendorAdd.Rows(RowIndex1).FindControl("hdnDepot")
                        numRowsAffected = VendorInsert.UpdateVendorDetails(vendorUnit, Tsl, Ps, userInfo.userIDEntity, Constant.Common.ActiveStatus, skuCode, hdnDepot.Value, sqlConn, sqlTrans)


                    End If
                Next
                If numRowsAffected > 0 Then
                    sqlTrans.Commit()
                Else
                    sqlTrans.Rollback()
                End If



            End If
        Catch ex As Exception
            If Not (sqlTrans Is Nothing) Then
                'SqlTrans is set to Rollback to go back to the beginning of the transaction
                sqlTrans.Rollback()
            End If
            Dim returnUrl As String = "ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            Server.Transfer(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
                Server.Transfer("~/Vendor_SKU_Master.aspx")
            End If
        End Try


    End Sub
    '#Region "Move Region for Insert"
    '    Protected Sub btnMoveSelectedCheckBox_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMoveSelectedCheckBox.Click
    '        Dim sqlConn As SqlConnection = Nothing
    '        Dim sqlTrans As SqlTransaction = Nothing
    '        Dim numRowsAffected As Integer
    '        Dim numRowsDeleted As Integer
    '        Dim RowIndex1 As Integer = 0
    '        Dim VendorInsert As New VendorMaster

    '        Try
    '            sqlConn = DBFactory.GetHelper.OpenConnection()
    '            sqlTrans = sqlConn.BeginTransaction()

    '            'numRowsDeleted = VendorInsert.DeleteVendorSkuMaster(txtSKU.Text, ddlVendor.SelectedValue, Constant.Common.ActiveStatus, sqlConn, sqlTrans)

    '            For RowIndex1 = 0 To gvVendorSelect.Rows.Count - 1
    '                Dim chkbx1 As CheckBox = gvVendorSelect.Rows(RowIndex1).FindControl("ChkSel")
    '                If chkbx1.Checked = True Then

    '                    Dim Ps, depotcode, skuCode, vendorUnit As String
    '                    Dim hdnDepot As HiddenField
    '                    Dim Tsl As Decimal

    '                    'Dim ddlPA As DropDownList = gvVendorAdd.Rows(RowIndex1).FindControl("ddlPA")
    '                    'If Not ddlPA Is Nothing Then
    '                    '    Ps = ddlPA.SelectedValue
    '                    'Else
    '                    '    Ps = String.Empty
    '                    'End If
    '                    'Dim txtTsl As TextBox = gvVendorAdd.Rows(RowIndex1).FindControl("txtTsl")
    '                    'Tsl = CType(txtTsl.Text, Decimal)
    '                    Ps = "PRIMARY"
    '                    Tsl = 1.0

    '                    skuCode = txtSKU.Text
    '                    vendorUnit = ddlVendor.SelectedValue
    '                    hdnDepot = gvVendorSelect.Rows(RowIndex1).FindControl("hdnDepot")



    '                    numRowsAffected = VendorInsert.InsrtVendorDetails(hdnDepot.Value, vendorUnit, Tsl, Ps, userInfo.userIDEntity, Constant.Common.ActiveStatus, skuCode, sqlConn, sqlTrans)


    '                End If
    '            Next
    '            If numRowsAffected > 0 Then
    '                sqlTrans.Commit()
    '            Else
    '                sqlTrans.Rollback()
    '            End If
    '        Catch ex As Exception
    '            If Not (sqlTrans Is Nothing) Then
    '                'SqlTrans is set to Rollback to go back to the beginning of the transaction
    '                sqlTrans.Rollback()
    '            End If
    '            Dim returnUrl As String = "ExceptionPage.aspx"
    '            Session(Constant.SessionKeys.ErrMessage) = ex.Message
    '            Server.Transfer(returnUrl)
    '        Finally
    '            If Not (sqlConn Is Nothing) Then
    '                'sqlConn is set to close state after completing the transaction
    '                sqlConn.Close()
    '                'Server.Transfer("~/Vendor_SKU_Master.aspx")
    '            End If
    '        End Try

    '        Dim RowIndex As Integer = 0
    '        For RowIndex = 0 To gvVendorSelect.Rows.Count - 1
    '            Dim chkbx As CheckBox = gvVendorSelect.Rows(RowIndex).FindControl("ChkSel")
    '            If chkbx.Checked = True Then
    '                PopulateVendorProfile(SKUCode, Unit)
    '            End If
    '        Next

    '        PopulategvVendorSelect()


    '        'Dim dtList As New DataTable
    '        'Dim dtchklist As New DataTable
    '        'Dim dr As DataRow
    '        'If ViewState(Constant.Common.ViewGetDepot) Is Nothing Then
    '        '    dtList.Columns.Add(New DataColumn("depot_regn", GetType(String)))
    '        '    dtList.Columns.Add(New DataColumn("depot_code", GetType(String)))
    '        '    dtList.Columns.Add(New DataColumn("depot_name", GetType(String)))
    '        '    dtList.Columns.Add(New DataColumn("v_tsl_factor", GetType(String)))
    '        '    dtList.Columns.Add(New DataColumn("v_primary_secondary", GetType(String)))


    '        '    dr = dtList.NewRow
    '        'Else
    '        '    dtList = CType(ViewState(Constant.Common.ViewGetDepot), DataTable)
    '        '    dtchklist = CType(ViewState(Constant.Common.ViewGetDepot), DataTable)
    '        '    dr = dtList.NewRow
    '        'End If
    '        'Dim RowIndex As Integer = 0

    '        'For RowIndex = 0 To gvVendorSelect.Rows.Count - 1
    '        '    Dim chkSel As CheckBox = gvVendorSelect.Rows(RowIndex).FindControl("ChkSel")

    '        '    If chkSel.Checked = True And chkSel.Enabled = True Then
    '        '        Dim countdupli As Integer = 0

    '        '        Dim Region As String = gvVendorSelect.Rows(RowIndex).Cells(2).Text
    '        '        Dim depotCode As String = gvVendorSelect.Rows(RowIndex).Cells(3).Text
    '        '        Dim depotName As String = gvVendorSelect.Rows(RowIndex).Cells(4).Text
    '        '        For Each drlist As DataRow In dtchklist.Rows

    '        '            If Region = drlist("depot_regn") And depotCode = drlist("depot_code") And depotName = drlist("depot_name") Then
    '        '                countdupli += 1
    '        '                chkSel.Enabled = False
    '        '                gvVendorSelect.Rows(RowIndex).ForeColor = Drawing.Color.FromArgb(136, 196, 69)
    '        '            End If
    '        '        Next
    '        '        If Not countdupli > 0 Then

    '        '            dr("depot_regn") = Region
    '        '            dr("depot_code") = depotCode
    '        '            dr("depot_name") = depotName


    '        '            Dim Regn As String = gvVendorSelect.Rows(RowIndex).Cells(2).Text
    '        '            Dim depot_code As String = gvVendorSelect.Rows(RowIndex).Cells(3).Text
    '        '            Dim depot_name As String = gvVendorSelect.Rows(RowIndex).Cells(4).Text

    '        '            dr("dealer_add") = DealerName + " Address :" + DealerAddress
    '        '            dr("gf_gift_name") = ddlGiftName.SelectedItem
    '        '            dr("gift_code") = hdnGiftCode.Value
    '        '            dr("gift_uom") = hdnGiftUOM.Value
    '        '            dr("despatch_qty") = 0
    '        '            dr("actual_qty") = ""
    '        '            dr("cons_no") = ""
    '        '            dr("consDate") = ""
    '        '            chkSel.Enabled = False
    '        '            gvVendorSelect.Rows(RowIndex).ForeColor = Drawing.Color.FromArgb(136, 196, 69)
    '        '            dtList.Rows.Add(dr)
    '        '            dr = dtList.NewRow()
    '        '        End If
    '        '    End If

    '        'Next

    '        'ViewState(Constant.Common.ViewGetDepot) = dtList
    '        'gvVendorAdd.DataSource = dtList

    '        'gvVendorAdd.DataBind()
    '    End Sub
    '#End Region
    Protected Sub ImgbtnTrans_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnTrans.Click

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        Dim numRowsDeleted As Integer
        Dim numRowsDeletedRows As Integer
        Dim RowIndex1 As Integer = 0
        Dim VendorInsert As New VendorMaster
        Dim N As Integer = 0


        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()


            For RowIndex1 = 0 To gvVendorAdd.Rows.Count - 1
                Dim chkbx1 As CheckBox = gvVendorAdd.Rows(RowIndex1).FindControl("ChkSelect")
                Dim hdnDepot As HiddenField
                hdnDepot = gvVendorAdd.Rows(RowIndex1).FindControl("hdnDepot")
                If chkbx1.Checked = False Then

                    numRowsDeletedRows = VendorInsert.DeleteVendorSkuMasterOneRow(hdnDepot.Value, txtSKU.Text, ddlVendor.SelectedValue, Constant.Common.ActiveStatus, sqlConn, sqlTrans)

                End If
            Next
            If numRowsDeletedRows > 0 Then
                sqlTrans.Commit()
            Else
                sqlTrans.Rollback()
            End If
        Catch ex As Exception
            If Not (sqlTrans Is Nothing) Then
                'SqlTrans is set to Rollback to go back to the beginning of the transaction
                sqlTrans.Rollback()
            End If
            Dim returnUrl As String = "ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            Server.Transfer(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
                'Server.Transfer("~/Vendor_SKU_Master.aspx")
            End If
        End Try


        PopulategvVendorSelect()

        'Dim RowIndex As Integer = 0
        Dim i As Integer = 0
        PopulateVendorProfile(txtSKU.Text, ddlVendor.SelectedValue)
        '    End If

        'Next


        'Dim dtList As New DataTable
        'Dim dtchklist As New DataTable
        'Dim dr As DataRow
        'If ViewState(Constant.Common.ViewGetDepot) Is Nothing Then
        '    dtList.Columns.Add(New DataColumn("depot_regn", GetType(String)))
        '    dtList.Columns.Add(New DataColumn("depot_code", GetType(String)))
        '    dtList.Columns.Add(New DataColumn("depot_name", GetType(String)))
        '    'dtList.Columns.Add(New DataColumn("v_tsl_factor", GetType(String)))
        '    'dtList.Columns.Add(New DataColumn("v_primary_secondary", GetType(String)))


        '    dr = dtList.NewRow
        'Else
        '    dtList = CType(ViewState(Constant.Common.ViewGetDepot), DataTable)
        '    dtchklist = CType(ViewState(Constant.Common.ViewGetDepot), DataTable)
        '    dr = dtList.NewRow
        'End If
        'Dim RowIndex As Integer = 0

        'For RowIndex = 0 To gvVendorAdd.Rows.Count - 1
        '    Dim chkSel As CheckBox = gvVendorAdd.Rows(RowIndex).FindControl("ChkSelect")

        '    If chkSel.Checked = True And chkSel.Enabled = True Then
        '        Dim countdupli As Integer = 0

        '        Dim Region As String = gvVendorAdd.Rows(RowIndex).Cells(2).Text
        '        Dim depotCode As String = gvVendorAdd.Rows(RowIndex).Cells(3).Text
        '        Dim depotName As String = gvVendorAdd.Rows(RowIndex).Cells(4).Text
        '        For Each drlist As DataRow In dtchklist.Rows

        '            If Region = drlist("depot_regn") And depotCode = drlist("depot_code") And depotName = drlist("depot_name") Then
        '                countdupli += 1
        '                chkSel.Enabled = False
        '                'gvVendorSelect.Rows(RowIndex).ForeColor = Drawing.Color.FromArgb(136, 196, 69)
        '            End If
        '        Next
        '        If Not countdupli > 0 Then

        '            dr("depot_regn") = Region
        '            dr("depot_code") = depotCode
        '            dr("depot_name") = depotName


        '            Dim Regn As String = gvVendorAdd.Rows(RowIndex).Cells(2).Text
        '            Dim depot_code As String = gvVendorAdd.Rows(RowIndex).Cells(3).Text
        '            Dim depot_name As String = gvVendorAdd.Rows(RowIndex).Cells(4).Text

        '            'dr("dealer_add") = DealerName + " Address :" + DealerAddress
        '            'dr("gf_gift_name") = ddlGiftName.SelectedItem
        '            'dr("gift_code") = hdnGiftCode.Value
        '            'dr("gift_uom") = hdnGiftUOM.Value
        '            'dr("despatch_qty") = 0
        '            'dr("actual_qty") = ""
        '            'dr("cons_no") = ""
        '            'dr("consDate") = ""
        '            chkSel.Enabled = False
        '            ' gvVendorSelect.Rows(RowIndex).ForeColor = Drawing.Color.FromArgb(136, 196, 69)
        '            dtList.Rows.Add(dr)
        '            dr = dtList.NewRow()



        '        End If
        '    End If

        'Next

        'ViewState(Constant.Common.ViewGetDepot) = dtList
        'gvVendorSelect.DataSource = dtList
        'gvVendorSelect.DataBind()

        'Dim VendorListRegionset As New DataSet
        'Dim Vendor_mstr As New VendorMaster
        'Dim company As String
        'Dim VendorRegion As String
        'Dim VendorSku As String
        'Dim VendorUnit As String
        'company = userInfo.userCompanyEntity
        'VendorRegion = Trim(ddlRegion.SelectedValue)
        'VendorSku = Trim(txtSKU.Text)
        'VendorUnit = Trim(ddlVendor.SelectedValue)
        'VendorListRegionset = Vendor_mstr.GetVendorListRegion(VendorRegion, VendorSku, VendorUnit)
        'gvVendorSelect.DataSource = VendorListRegionset.Tables(0)
        'gvVendorSelect.DataBind()


    End Sub
#Region "Move Selected Depots Up"
    Protected Sub ImgbtnTransUp_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgbtnTransUp.Click
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        Dim numRowsDeleted As Integer
        Dim RowIndex1 As Integer = 0
        Dim VendorInsert As New VendorMaster

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            'numRowsDeleted = VendorInsert.DeleteVendorSkuMaster(txtSKU.Text, ddlVendor.SelectedValue, Constant.Common.ActiveStatus, sqlConn, sqlTrans)

            For RowIndex1 = 0 To gvVendorSelect.Rows.Count - 1
                Dim chkbx1 As CheckBox = gvVendorSelect.Rows(RowIndex1).FindControl("ChkSel")
                If chkbx1.Checked = True Then

                    Dim Ps, depotcode, skuCode, vendorUnit As String
                    Dim hdnDepot As HiddenField
                    Dim Tsl As Decimal

                    'Dim ddlPA As DropDownList = gvVendorAdd.Rows(RowIndex1).FindControl("ddlPA")
                    'If Not ddlPA Is Nothing Then
                    '    Ps = ddlPA.SelectedValue
                    'Else
                    '    Ps = String.Empty
                    'End If
                    'Dim txtTsl As TextBox = gvVendorAdd.Rows(RowIndex1).FindControl("txtTsl")
                    'Tsl = CType(txtTsl.Text, Decimal)
                    Ps = "PRIMARY"
                    Tsl = 1.0

                    skuCode = txtSKU.Text
                    vendorUnit = ddlVendor.SelectedValue
                    hdnDepot = gvVendorSelect.Rows(RowIndex1).FindControl("hdnDepot")

                    numRowsAffected = VendorInsert.InsrtVendorDetails(hdnDepot.Value, vendorUnit, Tsl, Ps, userInfo.userIDEntity, Constant.Common.ActiveStatus, skuCode, sqlConn, sqlTrans)


                End If
            Next
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
            Dim returnUrl As String = "ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            Server.Transfer(returnUrl)
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
                'Server.Transfer("~/Vendor_SKU_Master.aspx")
            End If
        End Try

        Dim RowIndex As Integer = 0
        For RowIndex = 0 To gvVendorSelect.Rows.Count - 1
            Dim chkbx As CheckBox = gvVendorSelect.Rows(RowIndex).FindControl("ChkSel")
            If chkbx.Checked = True Then
                PopulateVendorProfile(txtSKU.Text, ddlVendor.SelectedValue)
            End If
        Next

        PopulategvVendorSelect()
    End Sub
#End Region

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect("~/Vendor_SKU_Master.aspx")
    End Sub

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvVendorSelect.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        PopulategvVendorSelect()
    End Sub
End Class
