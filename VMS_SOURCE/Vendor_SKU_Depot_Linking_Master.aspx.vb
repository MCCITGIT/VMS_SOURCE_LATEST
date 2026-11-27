Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Partial Class Vendor_SKU_Depot_Linking_Master
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity
#Region "Page Load Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.MaintainScrollPositionOnPostBack = True
        checkLogin()
        Dim ItemCode As String = String.Empty
        If Not IsPostBack Then
            AddAttributes()
            PopulateRegion()
            populatVendorUnit(ddlVendor)
            populatDepot(ddlDepot)

            PageSizeDropdown()
            '  LoadSearchCriteria()
            ' VendorSKUListLoad()
            ' EmptyGridLoad()
        End If

    End Sub

#End Region
#Region "AddAttributes"
    Private Sub AddAttributes()
        imgbtnSearch.Attributes.Add("OnClick", "return ValidateSearch('" + txtSkuCode.ClientID + "','" + lblErrorMessage.ClientID + "','" + imgbtnSearch.ClientID + "');")



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
        gvVendorSKUList.PageSize = ddlPageSize.SelectedValue

    End Sub
#End Region
#Region "Load Search Criteria"

    '' Loads the earlier search criteria when navigating back from a different screen
    Private Sub LoadSearchCriteria()

        If Not (Session(Constant.SessionKeys.VendorSKUSearchInfo) Is Nothing) Then
            Dim SearchInfo As New VendorMasterEntity
            SearchInfo = CType(Session(Constant.SessionKeys.VendorSKUSearchInfo), VendorMasterEntity)

            ddlVendor.SelectedValue = SearchInfo.VendorUnit
            ddlDepot.SelectedValue = SearchInfo.VendorDepot
            ddlPageSize.SelectedValue = SearchInfo.pageSize
            txtSkuCode.Text = SearchInfo.VendorSku_Code
            gvVendorSKUList.PageIndex = SearchInfo.PageNumber
        End If

    End Sub

#End Region
#Region "Save Search Criteria"
    ' Saves the current search criteria in session
    Private Sub SaveSearchCriteria()

        Dim SearchInfo As New VendorMasterEntity

        SearchInfo.VendorUnit = ddlVendor.SelectedValue
        SearchInfo.VendorDepot = ddlDepot.SelectedValue
        SearchInfo.pageSize = ddlPageSize.SelectedValue
        SearchInfo.VendorSku_Code = txtSkuCode.Text
        SearchInfo.PageNumber = gvVendorSKUList.PageIndex

        Session(Constant.SessionKeys.VendorSKUSearchInfo) = SearchInfo
    End Sub
#End Region
#Region "Populate Region"
    Private Sub PopulateRegion()
        checkLogin()

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
#Region "Populate  Venodr Unit "
    Public Sub populatVendorUnit(ddl As DropDownList)

        checkLogin()

        ddl.DataSource = Nothing
        Dim VendorUnit As New VendorMaster
        Dim Vendords As New DataSet
        Vendords = VendorUnit.GetUnitName(Constant.Common.ActiveStatus)
        If (Not (Vendords Is Nothing) AndAlso Vendords.Tables.Count > 0 AndAlso Not (Vendords.Tables(0) Is Nothing) AndAlso Vendords.Tables(0).Rows.Count > 0) Then
            ddl.DataSource = Vendords.Tables(0)
            ddl.DataTextField = "unit_name"
            ddl.DataValueField = "unit_code"
            ddl.DataBind()
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        Else
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        End If



    End Sub
#End Region
#Region "Populate  Depot"
    Public Sub populatDepot(ddl As DropDownList)

        checkLogin()

        ddl.DataSource = Nothing
        'Dim helper As New Common
        'Dim ds As New DataSet
        'ds = helper.GetDepotDetails(Constant.Common.ActiveStatus)
        'If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
        '    ddl.DataSource = ds.Tables(0)
        '    ddl.DataTextField = "depot_name"
        '    ddl.DataValueField = "depot_code"
        '    ddl.DataBind()
        '    ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        'Else
        '    ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))

        'End If
        Dim GeDepot As New Common
        Dim DepotSet As New DataSet

        DepotSet = GeDepot.Getdepotname(ddlRegion.SelectedValue)
        If (Not (DepotSet Is Nothing) AndAlso DepotSet.Tables.Count > 0 AndAlso Not (DepotSet.Tables(0) Is Nothing) AndAlso DepotSet.Tables(0).Rows.Count > 0) Then
            ddl.DataSource = DepotSet.Tables(0)
            ddl.DataTextField = "depot_name"
            ddl.DataValueField = "depot_code"
            ddl.DataBind()
            ddl.Items.Insert(0, New ListItem("Select", String.Empty, True))
        End If

        'If (userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
        '    ddl.SelectedValue = userInfo.userBranchEntity
        '    ddl.Enabled = False
        'Else
        '    ddl.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        'End If


    End Sub
#End Region

#Region "Gridview PageIndexChanging event handling."

    'Protected Sub gvVendorSKUList_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvVendorSKUList.PageIndexChanging
    '    ' gvVendorSKUList.EditIndex = -1
    '    gvVendorSKUList.PageIndex = e.NewPageIndex
    '    VendorSKUListLoad()
    'End Sub

#End Region


#Region "Search Button Click event handling"
    'Protected Sub imgbtnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbtnSearch.Click
    '    SaveSearchCriteria()
    '    gvVendorSKUList.EditIndex = -1
    '    gvVendorSKUList.PageIndex = 0
    '    VendorSKUListLoad()
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        SaveSearchCriteria()
        gvVendorSKUList.EditIndex = -1
        gvVendorSKUList.PageIndex = 0
        VendorSKUListLoad()
    End Sub


#End Region



    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvVendorSKUList.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue)
        VendorSKUListLoad()
    End Sub
#Region "VendorSKU List Load"

    Private Sub VendorSKUListLoad()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim VendorSKUGet As New VendorSKUDepotLinkingClass
        Dim VendorSKUList As DataSet

        VendorSKUList = VendorSKUGet.GetVendorSKUDetailsList(ddlVendor.SelectedValue, ddlDepot.SelectedValue, hdnskucode1.Value, ddlRegion.SelectedValue)
        If (Not (VendorSKUList Is Nothing) AndAlso VendorSKUList.Tables.Count > 0) Then
            If (Not (VendorSKUList.Tables(0) Is Nothing) AndAlso VendorSKUList.Tables(0).Rows.Count > 0) Then
                gvVendorSKUList.PageIndex = 0
                gvVendorSKUList.DataSource = FirstSkuLinkPage(VendorSKUList.Tables(0))
                gvVendorSKUList.DataBind()
                hdnSkuLinkHasData.Value = "1"
                hdnSkuLinkPageSize.Value = gvVendorSKUList.PageSize.ToString()
                ' Div_Lov_Mstr_Grid.Visible = False
            Else
                'gvVendorSKUList.DataSource = Nothing
                ' gvVendorSKUList.DataBind()
                EmptyGridLoad()
                hdnSkuLinkHasData.Value = "0"
                ' Div_Lov_Mstr_Grid.Visible = True
            End If
        End If

    End Sub

#End Region
#Region "Empty Grid Load"

    Private Sub EmptyGridLoad()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If
        Dim EmptyTable As DataTable = Nothing

        EmptyTable = New DataTable()
        Dim dtColumn As DataColumn

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "depot_name"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "v_depot"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "vendor_name"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "v_vendor_unit"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "SkuDescription"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "v_sku_code"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "v_tsl_factor"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "v_primary_secondary"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.GetType("System.String")
        dtColumn.ColumnName = "depot_regn"
        EmptyTable.Columns.Add(dtColumn)

        dtColumn = New DataColumn()
        dtColumn.DataType = System.Type.[GetType]("System.String")
        dtColumn.ColumnName = "active"
        EmptyTable.Columns.Add(dtColumn)

        Dim dr As DataRow = EmptyTable.NewRow()
        dr("depot_name") = String.Empty
        dr("v_depot") = String.Empty
        dr("vendor_name") = String.Empty
        dr("v_vendor_unit") = String.Empty
        dr("SkuDescription") = String.Empty
        dr("v_sku_code") = String.Empty
        dr("v_tsl_factor") = String.Empty
        dr("v_primary_secondary") = String.Empty
        dr("depot_regn") = String.Empty
        dr("active") = String.Empty

        EmptyTable.Rows.Add(dr)



        gvVendorSKUList.PageIndex = 0
        gvVendorSKUList.DataSource = EmptyTable
        gvVendorSKUList.DataBind()
        hdnSkuLinkHasData.Value = "0"

    End Sub

#End Region

    Protected Sub txtftrSKU_OnTextChanged(sender As Object, e As EventArgs)
        'Reference the TextBox.
        Dim SKUCode As TextBox = CType(sender, TextBox)
        Dim gr As GridViewRow = CType(CType(sender, TextBox).NamingContainer, GridViewRow)

        Dim lblftrskudes As TextBox = CType(gr.FindControl("lblftrskudes"), TextBox)

        Dim VendorListset As New DataSet
        Dim Vendor_mstr As New VendorMaster
        VendorListset = Vendor_mstr.GetVendorListForSKUCode(SKUCode.Text)
        If (Not (VendorListset Is Nothing) AndAlso VendorListset.Tables.Count > 0 AndAlso Not (VendorListset.Tables(0) Is Nothing) AndAlso VendorListset.Tables(0).Rows.Count > 0) Then
            lblftrskudes.Text = VendorListset.Tables(0).Rows(0)("SkuDescription")
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Sku Code Not Found')", True)
            lblftrskudes.Text = ""
        End If

    End Sub
    Protected Sub txtSkuCode_OnTextChanged(sender As Object, e As EventArgs) Handles txtSkuCode.TextChanged
        VendorSKUListLoad()
    End Sub
    Private Sub ddlRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRegion.SelectedIndexChanged
        populatDepot(ddlDepot)
        VendorSKUListLoad()
    End Sub
    Private Sub ddlDepot_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDepot.SelectedIndexChanged
        VendorSKUListLoad()
    End Sub
    Private Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVendor.SelectedIndexChanged
        VendorSKUListLoad()
    End Sub

    Protected Sub ddlNewVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddlNewVendor As DropDownList = CType(sender, DropDownList)
        hdnNewVendorName.Value = ddlNewVendor.SelectedItem.Text
    End Sub



#Region "gvVendorSKUList_RowCancelingEdit"

    Protected Sub gvVendorSKUList_RowCancelingEdit(ByVal sender As Object, ByVal e As GridViewCancelEditEventArgs)
        Try
            gvVendorSKUList.EditIndex = -1
            VendorSKUListLoad()

        Catch ex As Exception

        End Try

    End Sub

#End Region

#Region "gvVendorSKUList_RowEditing"

    Protected Sub gvVendorSKUList_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles gvVendorSKUList.RowEditing

        gvVendorSKUList.EditIndex = e.NewEditIndex
        VendorSKUListLoad()

    End Sub

#End Region

#Region "gvVendorSKUList_RowCommand"

    Protected Sub gvVendorSKUList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvVendorSKUList.RowCommand

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If


        If e.CommandName = "insert" Then

            Try
                Dim ddlftrDepot As DropDownList = gvVendorSKUList.FooterRow.FindControl("ddlftrDepot")
                Dim ddlftrVendor As DropDownList = gvVendorSKUList.FooterRow.FindControl("ddlftrVendor")
                Dim txtftrSKU As TextBox = gvVendorSKUList.FooterRow.FindControl("txtftrSKU")
                Dim txtftrtslfactor As TextBox = gvVendorSKUList.FooterRow.FindControl("txtftrtslfactor")
                Dim ddlftrPS As DropDownList = gvVendorSKUList.FooterRow.FindControl("ddlftrPS")
                Dim ddlActive As DropDownList = gvVendorSKUList.FooterRow.FindControl("ddlActive")

                Dim Numrowsaffected As Integer
                Dim helper As New VendorSKUDepotLinkingClass()
                Numrowsaffected = helper.VendorSKUMstrInsertUpdate(ddlftrDepot.SelectedValue, ddlftrVendor.SelectedValue, txtftrSKU.Text, Convert.ToDecimal(txtftrtslfactor.Text), ddlftrPS.SelectedValue, "Y", userInfo.userIDEntity, "Insert")

                VendorSKUListLoad()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Data inserted successfully')", True)

            Catch ex As Exception
                Dim returnUrl As String = "ExceptionPage.aspx"
                Session(Constant.SessionKeys.ErrMessage) = ex.Message
                ' Server.Transfer(returnUrl)
                HttpContext.Current.Server.Transfer("~/ExceptionPage.aspx")
            End Try



        End If

        If e.CommandName = "change" Then

            Try
                Dim Row As GridViewRow = CType(CType(e.CommandSource, ImageButton).Parent.Parent, GridViewRow)
                Dim hdnDepot1 As HiddenField = Row.FindControl("hdnDepot1")

                Dim ddlVendor As DropDownList = Row.FindControl("ddlVendor")
                ' Dim hdnvendor As HiddenField = row.FindControl("hdnvendor")
                Dim lblSKU As Label = Row.FindControl("lblSKU")
                Dim lbltslfactor As Label = Row.FindControl("lbltslfactor")
                Dim lblPS As Label = Row.FindControl("lblPS")
                Dim lblActive As Label = Row.FindControl("lblActive")

                Dim Numrowsaffected As Integer
                Dim helper As New VendorSKUDepotLinkingClass()
                Numrowsaffected = helper.VendorSKUMstrInsertUpdate(hdnDepot1.Value, ddlVendor.SelectedValue, lblSKU.Text, Convert.ToDecimal(lbltslfactor.Text), lblPS.Text, "Y", userInfo.userIDEntity, "Insert")

                VendorSKUListLoad()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Data updated successfully')", True)

            Catch ex As Exception
                Dim returnUrl As String = "ExceptionPage.aspx"
                Session(Constant.SessionKeys.ErrMessage) = ex.Message
                ' Server.Transfer(returnUrl)
                HttpContext.Current.Server.Transfer("~/ExceptionPage.aspx")
            End Try



        End If

    End Sub
#End Region

#Region "gvVendorSKUList_RowUpdating"

    Protected Sub gvVendorSKUList_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles gvVendorSKUList.RowUpdating

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim index As Integer = gvVendorSKUList.EditIndex
        Dim row As GridViewRow = gvVendorSKUList.Rows(index)


        Try

            Dim Recordmodified As Integer

            Dim hdnDepot As HiddenField = row.FindControl("hdnDepot")

            Dim ddleditVendor As DropDownList = row.FindControl("ddleditVendor")
            ' Dim hdnvendor As HiddenField = row.FindControl("hdnvendor")
            Dim lbleditSKU As Label = row.FindControl("lbleditSKU")
            Dim lbledittslfactor As Label = row.FindControl("lbledittslfactor")
            Dim lbleditPS As Label = row.FindControl("lbleditPS")
            Dim ddlActive As DropDownList = row.FindControl("ddlActive")

            Dim helper As New VendorSKUDepotLinkingClass()
            Recordmodified = helper.VendorSKUMstrInsertUpdate(hdnDepot.Value, ddleditVendor.SelectedValue, lbleditSKU.Text, Convert.ToDecimal(lbledittslfactor.Text), lbleditPS.Text, ddlActive.SelectedValue, userInfo.userIDEntity, "Insert")
            If Recordmodified > 0 Then
                gvVendorSKUList.EditIndex = -1
                VendorSKUListLoad()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Data updated successfully')", True)
            End If


        Catch ex As Exception
            Dim returnUrl As String = "ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = ex.Message
            ' Server.Transfer(returnUrl)
            HttpContext.Current.Server.Transfer("~/ExceptionPage.aspx")
        End Try
    End Sub
#End Region

#Region "gvVendorSKUList_RowDataBound"

    Protected Sub gvVendorSKUList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVendorSKUList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            ' Dim pageIdx As Integer = gvVendorSKUList.PageIndex * ddlPageSize.SelectedValue
            'e.Row.Cells(0).Text = pageIdx + (e.Row.RowIndex + 1)
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim btnUpdate As ImageButton = e.Row.FindControl("btnUpdate")
            Dim btnChange As ImageButton = e.Row.FindControl("btnChange")
            If Not (btnChange Is Nothing) Then
                '   Dim ddleditVendor As DropDownList = e.Row.FindControl("ddleditVendor")
                Dim ddlVendor As DropDownList = e.Row.FindControl("ddlVendor")
                Dim hdnskucode1 As HiddenField = e.Row.FindControl("hdnskucode1")
                Dim hdnDepotname As HiddenField = e.Row.FindControl("hdnDepotname")
                Dim hdnCurrentvendorname As HiddenField = e.Row.FindControl("hdnvendorname")



                Dim hdnvendor As HiddenField = e.Row.FindControl("hdnvendor")
                '  Dim ddlActive As DropDownList = e.Row.FindControl("ddlActive")
                Dim hdnactive As HiddenField = e.Row.FindControl("hdnactive")
                If Not (hdnvendor.Value = String.Empty) Then
                    populatVendorUnit(ddlVendor)
                    ddlVendor.SelectedValue = hdnvendor.Value
                    btnChange.Visible = True
                    ddlVendor.Visible = True
                Else
                    btnChange.Visible = False
                    ddlVendor.Visible = False
                End If

                '  ddlActive.SelectedValue = hdnactive.Value
                hdnNewVendorName.Value = ddlVendor.SelectedItem.Text

                ' btnUpdate.Attributes.Add("onclick", "return ValidateUpdate('" + ddleditVendor.ClientID + "','" + lblErrorMessage.ClientID + "','" + btnUpdate.ClientID + "');")
                btnChange.Attributes.Add("onclick", "return ValidateUpdate('" + ddlVendor.ClientID + "','" + hdnskucode1.ClientID + "','" + hdnDepotname.ClientID + "','" + hdnCurrentvendorname.ClientID + "','" + hdnNewVendorName.ClientID + "','" + lblErrorMessage.ClientID + "','" + btnChange.ClientID + "');")

            End If
        End If

        If (e.Row.RowType = DataControlRowType.Footer) Then
            Dim btnInsert As ImageButton = e.Row.FindControl("btnInsert")
            If Not (btnInsert Is Nothing) Then
                Dim ddlftrDepot As DropDownList = e.Row.FindControl("ddlftrDepot")
                Dim ddlftrVendor As DropDownList = e.Row.FindControl("ddlftrVendor")
                Dim txtftrtslfactor As TextBox = e.Row.FindControl("txtftrtslfactor")
                Dim txtftrSKU As TextBox = e.Row.FindControl("txtftrSKU")
                Dim lblftrskudes As TextBox = e.Row.FindControl("lblftrskudes")
                Dim ddlftrPS As DropDownList = e.Row.FindControl("ddlftrPS")
                Dim ddlActive As DropDownList = e.Row.FindControl("ddlActive")

                populatDepot(ddlftrDepot)
                populatVendorUnit(ddlftrVendor)

                txtftrtslfactor.Attributes.Add("onkeypress", "return isDecimalNumber(this, event);")

                btnInsert.Attributes.Add("onclick", "return ValidateInsert('" + ddlftrVendor.ClientID + "','" + ddlftrDepot.ClientID + "','" + txtftrtslfactor.ClientID + "','" + txtftrSKU.ClientID + "','" + lblftrskudes.ClientID + "','" + lblErrorMessage.ClientID + "','" + btnInsert.ClientID + "');")

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

#Region "Web Method"

    <System.Web.Script.Services.ScriptMethod(),
System.Web.Services.WebMethod()>
    Public Shared Function SKUSearch(ByVal prefixText As String) As String()

        Dim ms As New VendorSKUDepotLinkingClass

        Dim SKUdetails As List(Of String) = New List(Of String)

        If prefixText.Length >= 3 Then
            Try

                Dim ds As DataSet = ms.GetSkuPartialSearch(prefixText)

                If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                    If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                        For Each dr As DataRow In ds.Tables(0).Rows
                            SKUdetails.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dr(1).ToString, dr(0).ToString))
                        Next
                    End If
                End If

            Catch ex As Exception

            End Try
        End If

        Return SKUdetails.ToArray()

    End Function

    Private Function FirstSkuLinkPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvVendorSKUList.PageSize
        If pageSize <= 0 Then pageSize = 15
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
    Public Shared Function GetMoreVendorSkuLinks(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal vendorUnit As String, ByVal depot As String, ByVal skuCode As String, ByVal region As String) As Object
        If pageSize <= 0 Then pageSize = 15
        If pageIndex < 0 Then pageIndex = 0
        Dim helper As New VendorSKUDepotLinkingClass()
        Dim ds As DataSet = helper.GetVendorSKUDetailsList(vendorUnit, depot, skuCode, region)
        Dim rows As New List(Of Object)
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .skuDesc = dr("SkuDescription").ToString(),
                    .sku = dr("v_sku_code").ToString(),
                    .tsl = dr("v_tsl_factor").ToString(),
                    .ps = dr("v_primary_secondary").ToString(),
                    .region = dr("depot_regn").ToString(),
                    .depotName = dr("depot_name").ToString(),
                    .depot = dr("v_depot").ToString(),
                    .vendorName = dr("vendor_name").ToString(),
                    .vendor = dr("v_vendor_unit").ToString()
                })
            Next
        End If
        Dim vendors As New List(Of Object)
        If pageIndex = 1 Then
            vendors.Add(New With {.code = "", .name = "Select"})
            Dim vendords As DataSet = New VendorMaster().GetUnitName(Constant.Common.ActiveStatus)
            If vendords IsNot Nothing AndAlso vendords.Tables.Count > 0 AndAlso vendords.Tables(0) IsNot Nothing Then
                For Each unitRow As DataRow In vendords.Tables(0).Rows
                    vendors.Add(New With {.code = unitRow("unit_code").ToString(), .name = unitRow("unit_name").ToString()})
                Next
            End If
        End If
        Return New With {.rows = rows, .total = total, .vendors = vendors}
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function SaveVendorSkuLink(ByVal depot As String, ByVal vendor As String, ByVal sku As String, ByVal tsl As String, ByVal primarySecondary As String) As String
        Dim sessionUser As Object = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser Is Nothing Then Return "Please login again."
        Try
            Dim userInfo As VMSUserEntity = CType(sessionUser, VMSUserEntity)
            Dim helper As New VendorSKUDepotLinkingClass()
            Dim affected As Integer = helper.VendorSKUMstrInsertUpdate(depot, vendor, sku, Convert.ToDecimal(tsl), primarySecondary, "Y", userInfo.userIDEntity, "Insert")
            If affected > 0 Then Return "ok"
            Return "Data was not updated."
        Catch ex As Exception
            Return ex.Message
        End Try
    End Function

    Protected Sub txtftrSKUdsec_OnTextChanged(sender As Object, e As EventArgs)
        'Reference the TextBox.
        Dim SKUCode As TextBox = CType(sender, TextBox)
        Dim gr As GridViewRow = CType(CType(sender, TextBox).NamingContainer, GridViewRow)

        Dim lblftrskudes As TextBox = CType(gr.FindControl("txtftrSKU"), TextBox)

        lblftrskudes.Text = hdnSKUCode.Value

    End Sub
#End Region

End Class
