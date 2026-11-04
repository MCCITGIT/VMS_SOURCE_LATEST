Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports System.Data.SqlTypes



Partial Class Vendor_Profile_Add
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Public UnitCode As String
    Dim VendorFunctionclass As New VendorUnit

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            PopulateRegion()
            If (Not Request.QueryString(Constant.SessionKeys.UnitCode) = Constant.GeneralMessages.AddNew) Then
                btnSubmit.Text = Constant.GeneralMessages.btnUpdate
                UnitCode = (Request.QueryString(Constant.SessionKeys.UnitCode))
                PopulateVendorProfile()
            Else
                btnSubmit.Text = Constant.GeneralMessages.Submit
            End If
            AddAttributes()
        End If
    End Sub
#Region "AddAttributes"

    Private Sub AddAttributes()

        btnSubmit.Attributes.Add("onClick", "return ValidateVandorUnit();")
        txtUnitCode.Attributes.Add("OnBlur", "return ValidateSearchInfo();")
        btnCheckUnitCode.Attributes.Add("style", "display:none;")
    End Sub

#End Region
#Region "Populate Region"
    Private Sub PopulateRegion()
        Dim GetRegion As New Common
        'ProjectType holds user type from Lov_Details table using Lov_Details_Get SP

        Dim RegiontypeDS As New DataSet
        'RegiontypeDS = GetRegion.GetLovDetails(userInfo.userCompanyEntity, Constant.Common.REGION_TYPE, Constant.Common.ActiveStatus)
        RegiontypeDS = GetRegion.GetLovDetails(Constant.Common.Company, Constant.Common.REGION_TYPE, Constant.Common.ActiveStatus)
        'If userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT Then
        '    ddlRegion.Items.Insert(0, New ListItem(userInfo.userRegionEntity, userInfo.userRegionEntity, True))
        '    ddlRegion.Enabled = False
        'Else
        If Not (RegiontypeDS Is Nothing) Then
            ddlRegion.DataSource = RegiontypeDS
            ddlRegion.DataTextField = "Lov_Value"
            ddlRegion.DataValueField = "Lov_Code"
            ddlRegion.DataBind()
            'ddlRegion.Items.Insert(0, New ListItem("ALL", "", True))
            'ddlOrderBy.Items.Insert(0, New ListItem("Region", "Region"))

        End If
        ' End If
    End Sub
#End Region

#Region "Populate Region In dropdown"

    '    ' Populates the regions
    '    Private Sub PopulateRegion()

    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), CBINVENTUserEntity)
    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        'deptRegion is a object instance of user class
    '        Dim depotRegion As New StaleChequesReport

    '        'depotRegion holds depot type from Lov_Details table using GetDepotRegion SP
    '        Dim depotRegionDS As DataSet = depotRegion.GetRegion(Constant.Common.ActiveStatus)
    '        Try
    '            If Not (depotRegionDS Is Nothing) Then
    '                ddlRegion.DataSource = depotRegionDS.Tables(0)
    '                'ddlRegion.DataTextField = "depot_regn"
    '                'ddlRegion.DataValueField = "depot_regn"
    '                ddlRegion.DataTextField = "lov_code"
    '                ddlRegion.DataValueField = "lov_value"
    '                ddlRegion.DataBind()
    '                ddlRegion.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))

    '            End If
    '        Catch ex As Exception
    '            Dim returnUrl As String = "~/ExceptionPage.aspx"
    '            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorDepotRegion
    '            Server.Transfer(returnUrl)
    '        End Try

    '    End Sub
#End Region
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim RowsAffected As Integer = InsertVendorProfile()
        If RowsAffected = 1 Then
            Response.Redirect("~/FG_VendorMstrList.aspx")
        End If
    End Sub
    Public Function InsertVendorProfile() As Integer

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim oVendEntity As New VendorMasterListEntity
        oVendEntity.CreatedUser = userInfo.userIDEntity
        oVendEntity.Vendcompany = userInfo.userCompanyEntity
        oVendEntity.VendUnit_Code = txtUnitCode.Text
        oVendEntity.VendUnit_Name = txtUnitName.Text
        oVendEntity.VendUnit_Region = ddlRegion.SelectedValue
        oVendEntity.VendUnit_Add1 = txtLine1.Text
        oVendEntity.VendUnit_Add2 = txtLine2.Text
        oVendEntity.VendUnit_Add3 = txtLine3.Text
        oVendEntity.VendState = txtState.Text
        oVendEntity.VendCity = txtCity.Text
        oVendEntity.VendPin = txtPin.Text
        oVendEntity.VendEmail = txtEmail.Text
        oVendEntity.VendStax_regno = txtSaleTaxRegNo.Text
        oVendEntity.VendTinNo = txtTINno.Text
        oVendEntity.VendCenVatRegNo = txtCENVATRegNo.Text
        oVendEntity.VendCenVatRegDate = txtbxdate.Text
        oVendEntity.ActiveStatus = Constant.Common.ActiveStatus
        oVendEntity.FreightYn = If(chkAllowFreight.Checked, Constant.Common.ActiveStatus, Constant.Common.InActiveStatus)

        Dim RowsAffected As Integer

        If btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then
            oVendEntity.VendUnit_Code = (Request.QueryString(Constant.SessionKeys.UnitCode))
            oVendEntity.ModifiedUser = userInfo.userIDEntity
            If rbtnActiveY.Checked Then
                oVendEntity.ActiveStatus = Constant.Common.ActiveStatus
            End If
            If rbtnActiveN.Checked Then
                oVendEntity.ActiveStatus = Constant.Common.InActiveStatus
            End If
            RowsAffected = VendorFunctionclass.VendorUpdate(oVendEntity)
        Else
            If rbtnActiveY.Checked Then
                oVendEntity.ActiveStatus = Constant.Common.ActiveStatus
            End If
            If rbtnActiveN.Checked Then
                oVendEntity.ActiveStatus = Constant.Common.InActiveStatus
            End If
            'Dim rCount As Integer
            'rCount = VendorFunctionclass.ChkUnitCode(oVendEntity)
            'If (rCount > 0) Then
            '    lblErrorMessage.Text = "Unit Code already exist"
            'Else
            RowsAffected = VendorFunctionclass.VendorInsert(oVendEntity)
            'End If
        End If

        Return RowsAffected
    End Function
    Protected Sub rbtnActiveN_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rbtnActiveN.CheckedChanged
        If rbtnActiveN.Checked Then
            rbtnActiveY.Checked = False
        End If
    End Sub
    Public Sub PopulateVendorProfile()
        Dim PopulateVendorset As New DataSet
        PopulateVendorset = VendorFunctionclass.Vendor_Get(Request.QueryString(Constant.SessionKeys.UnitCode))
        If (Not (PopulateVendorset Is Nothing) AndAlso PopulateVendorset.Tables.Count > 0 AndAlso Not (PopulateVendorset.Tables(0) Is Nothing) AndAlso PopulateVendorset.Tables(0).Rows.Count > 0) Then
            Dim oVendEntity As New VendorMasterListEntity
            ' VendorId = CInt(Request.QueryString(Constant.SessionKeys.VendorId))
            txtUnitCode.Text = PopulateVendorset.Tables(0).Rows(0)("unit_code")
            txtUnitCode.ReadOnly = True
            txtUnitName.Text = PopulateVendorset.Tables(0).Rows(0)("unit_name")
            ddlRegion.SelectedValue = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_regn").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_regn"))
            txtEmail.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_email").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_email"))
            txtLine1.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_add_1").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_add_1"))
            txtLine2.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_add_2").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_add_2"))
            txtLine3.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_add_3").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_add_3"))
            txtCity.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_city").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_city"))
            txtState.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_state").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_state"))
            txtPin.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_pin").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_pin"))
            txtSaleTaxRegNo.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_stax_regno").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_stax_regno"))
            txtTINno.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_tinno").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_tinno"))
            txtCENVATRegNo.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_cenvat_reg_no").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_cenvat_reg_no"))

            txtbxdate.Text = IIf(PopulateVendorset.Tables(0).Rows(0)("unit_cenvat_reg_date").Equals(DBNull.Value), String.Empty, PopulateVendorset.Tables(0).Rows(0)("unit_cenvat_reg_date"))
            If PopulateVendorset.Tables(0).Rows(0)("active").ToString.ToLower = "n" Then
                rbtnActiveY.Checked = False
                rbtnActiveN.Checked = True
            Else
                rbtnActiveY.Checked = True
                rbtnActiveN.Checked = False
            End If
            Dim freightYn As String = "N"
            If PopulateVendorset.Tables(0).Columns.Contains("unit_freight_yn") AndAlso
               Not PopulateVendorset.Tables(0).Rows(0)("unit_freight_yn").Equals(DBNull.Value) Then
                freightYn = PopulateVendorset.Tables(0).Rows(0)("unit_freight_yn").ToString().Trim()
            End If
            chkAllowFreight.Checked = String.Equals(freightYn, Constant.Common.ActiveStatus, StringComparison.OrdinalIgnoreCase)
        End If
    End Sub
    Public Sub Clear()
        'lblVendorID.Text = ""
        'txtNameOfOrganisation.Text = ""
        'ddlVendorCategory.SelectedIndex = -1
        'txtWebsite.Text = ""
        'txtContactName1.Text = ""
        'txtDesignation1.Text = ""
        'txtContactNo1.Text = ""
        'txtEmail1.Text = ""
        'txtContactName2.Text = ""
        'txtContactNo2.Text = ""
        'txtDesignation2.Text = ""
        'txtEmail2.Text = ""
        'txtContactName3.Text = ""
        'txtContactNo3.Text = ""
        'txtDesignation3.Text = ""
        'txtEmail3.Text = ""
        'txtLine1.Text = ""
        'txtLine2.Text = ""
        'txtLine3.Text = ""
        'txtCity.Text = ""
        'txtState.Text = ""
        ''txtCountry.Text = ""
        'ddlCountry.SelectedValue = "0"
        'txtPin.Text = ""
        'txtEmail.Text = ""
        'txtOfficePhoneNo.Text = ""
        'txtExtension.Text = ""
        'txtFaxNo.Text = ""
        'rbtnActiveY.Checked = True
    End Sub

    Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReset.Click
        If btnSubmit.Text = Constant.GeneralMessages.btnUpdate Then
            PopulateVendorProfile()
        Else
            'Clear()
            Response.Redirect("~/Vendor_Profile_add.aspx?UnitCode=New")
            'Response.Redirect("~/Vendor_Profile_Add.aspx")
        End If
    End Sub
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect("~/FG_VendorMstrList.aspx")
    End Sub
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
        Else
            Dim dt As DateTime = SqlDateTime.MinValue
            Return dt
        End If

    End Function

#End Region

    Protected Sub btnCheckUnitCode_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCheckUnitCode.Click
        Dim oVendEntity As New VendorMasterListEntity
        Dim rCount As Integer
        rCount = VendorFunctionclass.ChkUnitCode(txtUnitCode.Text)
        If (rCount > 0) Then
            'lblErrorMessage.Text = "Unit Code already exist"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "message", "alert('Unit Code already exist')", True)
            txtUnitCode.Focus()
        End If

    End Sub
End Class
