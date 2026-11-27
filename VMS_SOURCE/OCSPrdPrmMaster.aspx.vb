Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports VMS.Web
Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess
Partial Class OCSPrdPrmMaster
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Dim Obj As Common = New Common()
    Dim entity As TokenReceiveEntity = New TokenReceiveEntity()
#Region "Page Load Event"
    Private Sub TokenDespatchList_Load(sender As Object, e As EventArgs) Handles Me.Load
        CheckLogin()
        If (Not IsPostBack) Then
            PopulateParams(ddlparam)
            PopulateOCSPrdPrmHeaders()
        End If
    End Sub
#End Region
#Region "Custom Method"
    Private Sub CheckLogin()
        If (Session(Constant.SessionKeys.UserInfo) IsNot Nothing) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx", True)
        End If
    End Sub
    Public Sub PopulateParams(ByVal ddl As DropDownList)
        Dim ds As DataSet
        Try
            ds = Obj.GetLovDetails("BERGER", "OCS_PRODUCTS", "Y")
            If ((Not (ds Is Nothing) And ds.Tables.Count > 0 And Not (ds.Tables(0) Is Nothing) And ds.Tables(0).Rows.Count > 0)) Then
                ddl.DataSource = ds.Tables(0)
                ddl.DataTextField = "lov_value"
                ddl.DataValueField = "lov_code"
                ddl.DataBind()
                ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Else
                ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            End If
        Catch ex As Exception
            Dim returnUrl = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try
    End Sub
    Public Sub PopulateFrequency(ByVal ddl As DropDownList)
        Dim ds As DataSet
        Try
            ds = Obj.GetLovDetails("BERGER", "OCS_FREQUENCY", "Y")
            If ((Not (ds Is Nothing) And ds.Tables.Count > 0 And Not (ds.Tables(0) Is Nothing) And ds.Tables(0).Rows.Count > 0)) Then
                ddl.DataSource = ds.Tables(0)
                ddl.DataTextField = "lov_value"
                ddl.DataValueField = "lov_code"
                ddl.DataBind()
                ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Else
                ddl.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            End If
        Catch ex As Exception
            Dim returnUrl = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try
    End Sub
    Public Sub PopulateOCSPrdPrmHeaders()
        CheckLogin()
        Dim ds As New DataSet
        Dim Obj As New OCSPrdPrmClass
        Dim Params As String = String.Empty
        If ddlparam.SelectedValue <> String.Empty Then
            Params = ddlparam.SelectedValue
        End If
        ds = Obj.GetPrdPrmDtls(Params)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            gvParamsList.PageIndex = 0
            gvParamsList.DataSource = FirstOcsPage(ds.Tables(0))
            gvParamsList.DataBind()
            hdnOcsHasData.Value = "1"
            hdnOcsPageSize.Value = gvParamsList.PageSize.ToString()
        Else
            hdnOcsHasData.Value = "0"
            gvParamsList.DataSource = ds
            gvParamsList.DataBind()
        End If
    End Sub
#End Region
    Protected Sub ddlparam_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlparam.SelectedIndexChanged
        PopulateOCSPrdPrmHeaders()
    End Sub
    Protected Sub gvParamsList_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvParamsList.RowCancelingEdit
        gvParamsList.EditIndex = -1
        PopulateOCSPrdPrmHeaders()
    End Sub
    Protected Sub gvParamsList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvParamsList.RowCommand
        If e.CommandName = "Submit" Then
            CheckLogin()
            Dim btnUpdate As LinkButton = gvParamsList.FooterRow.FindControl("btnSubmit")
            Dim ddlprdname As DropDownList = gvParamsList.FooterRow.FindControl("ddlprdname")
            Dim ddlfreqncy As DropDownList = gvParamsList.FooterRow.FindControl("ddlfreqncy")
            Dim ddlActive As DropDownList = gvParamsList.FooterRow.FindControl("ddlActive_ftr")
            Dim txtparam As TextBox = gvParamsList.FooterRow.FindControl("txtparam")
            Dim ddlNumeric As DropDownList = gvParamsList.FooterRow.FindControl("ddlNumeric_ftr")
            Dim ddlDropdown As DropDownList = gvParamsList.FooterRow.FindControl("ddlDropdown_ftr")
            Dim txtDropDownParam As TextBox = gvParamsList.FooterRow.FindControl("txtDropDownParam_ftr")
            '' Dim hdnprdid As HiddenField = gvParamsList.FooterRow.FindControl("hdnprdid")
            Dim txtminValueft As TextBox = gvParamsList.FooterRow.FindControl("txtminValueft")
            Dim txtmaxValueft As TextBox = gvParamsList.FooterRow.FindControl("txtmaxValueft")
            Dim sqlConn As SqlConnection = Nothing
            Dim sqlTrans As SqlTransaction = Nothing
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            Dim numberroweffect As Integer = 0

            If ddlprdname.SelectedIndex = 0 Then
                Return
            End If
            If ddlfreqncy.SelectedIndex = 0 Then
                Return
            End If
            If txtparam.Text = String.Empty Then
                Return
            End If
            Try
                Dim entity As New OCSPrmPrdEntity
                Dim obj As New OCSPrdPrmClass
                entity.PrmPrd_Id = 0
                entity.Product_Code = ddlprdname.SelectedValue
                entity.PFrequency = ddlfreqncy.SelectedValue
                entity.Paramss = txtparam.Text.Trim
                entity.Status = ddlActive.SelectedValue
                entity.CreatedUser = userInfo.userIDEntity
                entity.Numeric_YN = ddlNumeric.SelectedValue
                entity.Dropdown_YN = ddlDropdown.SelectedValue
                entity.DropDown_Param = txtDropDownParam.Text
                entity.Min_Value = txtminValueft.Text
                entity.Max_Value = txtmaxValueft.Text
                numberroweffect = obj.InsertUpdatePrmPrd(entity, sqlConn, sqlTrans)
                If numberroweffect > 0 Then
                    sqlTrans.Commit()
                    lblErrorMessage.ForeColor = System.Drawing.Color.Green
                    lblErrorMessage.Text = "Submited Successfully."
                Else
                    sqlTrans.Rollback()
                    lblErrorMessage.ForeColor = System.Drawing.Color.Red
                    lblErrorMessage.Text = "Some Error Occured."
                End If
            Catch ex As Exception
                'Throw ex
                lblErrorMessage.ForeColor = System.Drawing.Color.Red
                lblErrorMessage.Text = "Some Error Occured."
            Finally
                sqlConn.Close()
                gvParamsList.EditIndex = -1
                PopulateOCSPrdPrmHeaders()
            End Try
        End If
    End Sub
    Protected Sub gvParamsList_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvParamsList.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowview As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim btnEdit As LinkButton = e.Row.FindControl("btnEdit")
            Dim btnUpdate As LinkButton = e.Row.FindControl("btnUpdate")
            Dim btnCancel As LinkButton = e.Row.FindControl("btnCancel")
            Dim txtPrdCode As TextBox = e.Row.FindControl("txtPrdCode")
            Dim txtparams As TextBox = e.Row.FindControl("txtparams")
            Dim ddlprdname As DropDownList = e.Row.FindControl("ddlprodname")
            Dim ddlfreqncy As DropDownList = e.Row.FindControl("ddlfreq")
            Dim ddlActive As DropDownList = e.Row.FindControl("ddlActive")
            Dim txtfreqq As TextBox = e.Row.FindControl("txtfreqq")
            Dim ddlNumeric As DropDownList = e.Row.FindControl("ddlNumeric")
            Dim ddlDropdown As DropDownList = e.Row.FindControl("ddlDropdown")
            Dim txtDropDownParam As TextBox = e.Row.FindControl("txtDropDownParam")
            Dim txtminValue As TextBox = e.Row.FindControl("txtminValue")
            Dim txtmaxValue As TextBox = e.Row.FindControl("txtmaxValue")
            If Not ddlActive Is Nothing Then

                PopulateParams(ddlprdname)
                ddlprdname.SelectedValue = txtPrdCode.Text.Trim
                txtparams.Text = txtparams.Text.Trim
                PopulateFrequency(ddlfreqncy)
                ddlfreqncy.SelectedValue = txtfreqq.Text.Trim
                ddlActive.SelectedValue = rowview("active").ToString
                ddlNumeric.SelectedValue = rowview("numericYN").ToString
                ddlDropdown.SelectedValue = rowview("dropdownYN").ToString
                txtminValue.Attributes.Add("onkeypress", "return isDecimalNumber(this, event);")
                txtmaxValue.Attributes.Add("onkeypress", "return isDecimalNumber(this, event);")


                btnUpdate.Attributes.Add("onclick", "return ValidateSubmit('" _
                                                                        + ddlprdname.ClientID + "','" _
                                                                        + txtparams.ClientID + "','" _
                                                                        + ddlfreqncy.ClientID + "','" _
                                                                        + ddlNumeric.ClientID + "','" _
                                                                        + ddlDropdown.ClientID + "','" _
                                                                        + ddlprdname.ClientID + "','" _
                                                                        + txtminValue.ClientID + "','" _
                                                                        + txtmaxValue.ClientID + "','" _
                                                                        + btnUpdate.ClientID + "','" _
                                                                        + lblErrorMessage.ClientID + "') ")
            End If
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            Dim ddlNumeric As DropDownList = e.Row.FindControl("ddlNumeric_ftr")
            Dim ddlDropdown As DropDownList = e.Row.FindControl("ddlDropdown_ftr")
            Dim ddlfreqncy As DropDownList = e.Row.FindControl("ddlfreqncy")
            Dim txtminValueft As TextBox = e.Row.FindControl("txtminValueft")
            Dim txtmaxValueft As TextBox = e.Row.FindControl("txtmaxValueft")
            Dim txtparam As TextBox = e.Row.FindControl("txtparam")
            PopulateFrequency(ddlfreqncy)
            Dim btnUpdate As LinkButton = e.Row.FindControl("btnSubmit")
            Dim ddlprdname As DropDownList = e.Row.FindControl("ddlprdname")
            Dim txtDropDownParam As TextBox = e.Row.FindControl("txtDropDownParam_ftr")
            PopulateParams(ddlprdname)
            Dim ddlActive As DropDownList = e.Row.FindControl("ddlActive_ftr")
            txtminValueft.Attributes.Add("onkeypress", "return isDecimalNumber(this, event);")
            txtmaxValueft.Attributes.Add("onkeypress", "return isDecimalNumber(this, event);")
            'txtminValueft.Attributes.Add("onkeypress", "return MinMaxValue(this, event);")
            'txtmaxValueft.Attributes.Add("onkeypress", "return MinMaxValue(this, event);")
            btnUpdate.Attributes.Add("onclick", "return ValidateSubmit('" _
                                                                        + ddlprdname.ClientID + "','" _
                                                                        + txtparam.ClientID + "','" _
                                                                        + ddlfreqncy.ClientID + "','" _
                                                                        + ddlNumeric.ClientID + "','" _
                                                                        + ddlDropdown.ClientID + "','" _
                                                                        + txtDropDownParam.ClientID + "','" _
                                                                        + txtminValueft.ClientID + "','" _
                                                                        + txtmaxValueft.ClientID + "','" _
                                                                        + btnUpdate.ClientID + "','" _
                                                                        + lblErrorMessage.ClientID + "') ")
        End If
    End Sub
    Protected Sub gvParamsList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvParamsList.RowEditing
        gvParamsList.EditIndex = e.NewEditIndex
        PopulateOCSPrdPrmHeaders()
    End Sub
    Protected Sub gvParamsList_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvParamsList.RowUpdating
        CheckLogin()
        Dim Index As Integer = gvParamsList.EditIndex

        Dim btnUpdate As LinkButton = gvParamsList.Rows(Index).FindControl("btnUpdate")
        Dim ddlActive As DropDownList = gvParamsList.Rows(Index).FindControl("ddlActive")
        Dim ddlfreq As DropDownList = gvParamsList.Rows(Index).FindControl("ddlfreq")
        Dim ddlprodname As DropDownList = gvParamsList.Rows(Index).FindControl("ddlprodname")
        Dim hdnId As HiddenField = gvParamsList.Rows(Index).FindControl("hdnId")
        Dim txtparam As TextBox = gvParamsList.Rows(Index).FindControl("txtparams")
        Dim hdnprdid As HiddenField = gvParamsList.Rows(Index).FindControl("hdnprdid")
        Dim ddlNumeric As DropDownList = gvParamsList.Rows(Index).FindControl("ddlNumeric")
        Dim ddlDropdown As DropDownList = gvParamsList.Rows(Index).FindControl("ddlDropdown")
        Dim txtDropDownParam As TextBox = gvParamsList.Rows(Index).FindControl("txtDropDownParam")
        Dim txtminValue As TextBox = gvParamsList.Rows(Index).FindControl("txtminValue")
        Dim txtmaxValue As TextBox = gvParamsList.Rows(Index).FindControl("txtmaxValue")
        Dim id As Integer = Convert.ToInt32(hdnprdid.Value)

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        sqlConn = DBFactory.GetHelper.OpenConnection()
        sqlTrans = sqlConn.BeginTransaction()
        Dim numberroweffect As Integer = 0
        'ddlNumeric.SelectedValue = "N"
        'ddlNumeric.SelectedValue = "N"
        If ddlprodname.SelectedIndex = 0 Then
            Return
        End If
        If ddlfreq.SelectedIndex = 0 Then
            Return
        End If
        If txtparam.Text = String.Empty Then
            Return
        End If
        Try
            Dim entity As New OCSPrmPrdEntity
            Dim obj As New OCSPrdPrmClass
            entity.PrmPrd_Id = hdnprdid.Value
            entity.Product_Code = ddlprodname.SelectedValue
            entity.Paramss = txtparam.Text.Trim
            entity.PFrequency = ddlfreq.SelectedValue
            entity.Status = ddlActive.SelectedValue
            entity.modifieduser = userInfo.userIDEntity
            entity.Dropdown_YN = ddlDropdown.SelectedValue
            entity.Numeric_YN = ddlNumeric.SelectedValue
            entity.DropDown_Param = txtDropDownParam.Text

            entity.Min_Value = txtminValue.Text
            entity.Max_Value = txtmaxValue.Text

            numberroweffect = obj.InsertUpdatePrmPrd(entity, sqlConn, sqlTrans)
            If numberroweffect > 0 Then
                sqlTrans.Commit()
                lblErrorMessage.ForeColor = System.Drawing.Color.Green
                lblErrorMessage.Text = "Updated Successfully."
            Else
                sqlTrans.Rollback()
                lblErrorMessage.ForeColor = System.Drawing.Color.Red
                lblErrorMessage.Text = "Some Error Occured."
            End If
        Catch ex As Exception
            'Throw ex
            lblErrorMessage.ForeColor = System.Drawing.Color.Red
            lblErrorMessage.Text = "Some Error Occured."
        Finally
            sqlConn.Close()
            gvParamsList.EditIndex = -1
            PopulateOCSPrdPrmHeaders()
        End Try
    End Sub
    'Protected Sub gvParamsList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvParamsList.PageIndexChanging
    '    gvParamsList.PageIndex = e.NewPageIndex
    '    PopulateOCSPrdPrmHeaders()
    'End Sub

    Private Function FirstOcsPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvParamsList.PageSize
        If pageSize <= 0 Then pageSize = 15
        If table.Rows.Count <= pageSize Then Return table
        Dim page As DataTable = table.Clone()
        Dim i As Integer
        For i = 0 To pageSize - 1
            page.ImportRow(table.Rows(i))
        Next
        Return page
    End Function

    Private Shared Function CurrentOcsUser() As VMSUserEntity
        Dim sessionUser As Object = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser Is Nothing Then Return Nothing
        Return CType(sessionUser, VMSUserEntity)
    End Function

    Private Shared Function LovOptions(ByVal lovType As String) As List(Of Object)
        Dim options As New List(Of Object)
        options.Add(New With {.code = "", .name = Constant.Common.Selec})
        Dim ds As DataSet = New Common().GetLovDetails("BERGER", lovType, "Y")
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            For Each dr As DataRow In ds.Tables(0).Rows
                options.Add(New With {.code = dr("lov_code").ToString(), .name = dr("lov_value").ToString()})
            Next
        End If
        Return options
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function GetMoreOcsParams(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal productCode As String) As Object
        Dim rows As New List(Of Object)
        If CurrentOcsUser() Is Nothing Then Return New With {.rows = rows, .total = 0, .products = New List(Of Object), .frequencies = New List(Of Object)}
        If pageSize <= 0 Then pageSize = 15
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New OCSPrdPrmClass().GetPrdPrmDtls(If(productCode, String.Empty))
        Dim total As Integer = 0
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0) IsNot Nothing Then
            total = ds.Tables(0).Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim dr As DataRow = ds.Tables(0).Rows(i)
                rows.Add(New With {
                    .id = dr("opph_id").ToString(),
                    .productCode = dr("product_code").ToString(),
                    .productName = dr("product_name").ToString(),
                    .params = dr("params").ToString(),
                    .frequency = dr("frequency").ToString(),
                    .frequencyCode = dr("frequencycode").ToString(),
                    .active = dr("active").ToString(),
                    .numericYn = dr("numericYN").ToString(),
                    .minValue = dr("min_value").ToString(),
                    .maxValue = dr("max_value").ToString(),
                    .dropdownYn = dr("dropdownYN").ToString(),
                    .dropParams = dr("DrpDwnParams").ToString()
                })
            Next
        End If
        Dim products As New List(Of Object)
        Dim frequencies As New List(Of Object)
        If pageIndex = 1 Then
            products = LovOptions("OCS_PRODUCTS")
            frequencies = LovOptions("OCS_FREQUENCY")
        End If
        Return New With {.rows = rows, .total = total, .products = products, .frequencies = frequencies}
    End Function

    <System.Web.Script.Services.ScriptMethod(),
    System.Web.Services.WebMethod()>
    Public Shared Function SaveOcsParam(ByVal id As String, ByVal productCode As String, ByVal params As String, ByVal frequency As String, ByVal active As String, ByVal numericYn As String, ByVal dropdownYn As String, ByVal dropParams As String, ByVal minValue As String, ByVal maxValue As String) As String
        Dim userInfo As VMSUserEntity = CurrentOcsUser()
        If userInfo Is Nothing Then Return "Please login again."
        If productCode = String.Empty OrElse frequency = String.Empty OrElse params Is Nothing OrElse params.Trim() = String.Empty Then Return "Some Error Occured."
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()
            Dim entity As New OCSPrmPrdEntity
            entity.PrmPrd_Id = id
            entity.Product_Code = productCode
            entity.Paramss = params.Trim()
            entity.PFrequency = frequency
            entity.Status = active
            entity.modifieduser = userInfo.userIDEntity
            entity.Dropdown_YN = dropdownYn
            entity.Numeric_YN = numericYn
            entity.DropDown_Param = If(dropParams, String.Empty)
            entity.Min_Value = If(minValue, String.Empty)
            entity.Max_Value = If(maxValue, String.Empty)
            Dim affected As Integer = New OCSPrdPrmClass().InsertUpdatePrmPrd(entity, sqlConn, sqlTrans)
            If affected > 0 Then
                sqlTrans.Commit()
                Return "ok"
            End If
            sqlTrans.Rollback()
            Return "Some Error Occured."
        Catch ex As Exception
            If sqlTrans IsNot Nothing Then sqlTrans.Rollback()
            Return "Some Error Occured."
        Finally
            If sqlConn IsNot Nothing Then sqlConn.Close()
        End Try
    End Function
End Class
