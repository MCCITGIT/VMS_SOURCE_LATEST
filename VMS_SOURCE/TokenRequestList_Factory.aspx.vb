Imports System.Data
Imports VMS.Web
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Data.SqlTypes
Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.IO

Partial Class TokenRequestList_Factory
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()


#Region "Page_Load Event"


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateFactoryList()
            PopulateVendorList()
            BindGrid()
        End If

        'Dim site As MasterPage = Me.Master
        'Dim lbl As Label = site.FindControl("lblPageHeader")
        'lbl.Text = "FACTORY TOKEN REQUISITION LIST"
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


#Region "Date Format"
    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime

        If (stringdate.Equals(String.Empty)) Then
            Return SqlDateTime.MinValue
        End If

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

#Region "Populate Factory List "
    Private Sub PopulateFactoryList()

        Dim obj As New VMS.Web.Common
        Try
            Dim ds As DataSet = obj.GetUserApplicableDepotList(userInfo.userIDEntity, userInfo.userGroupCodeEntity)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    ddlFactory.DataSource = ds.Tables(0)
                    ddlFactory.DataTextField = "depot"
                    ddlFactory.DataValueField = "depot_code"
                    ddlFactory.DataBind()


                    If ds.Tables(0).Rows.Count = 1 Then
                        ddlFactory.SelectedValue = ds.Tables(0).Rows(0)("depot_code").ToString
                        ddlFactory.Enabled = False
                        PopulateVendorList()
                    End If

                End If
                'Else
                '    ddlFactory.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            End If
            ddlFactory.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try


    End Sub
#End Region

#Region "Populate Vendor List "
    Private Sub PopulateVendorList()
        ddlVendor.Items.Clear()
        Dim obj As New TokenRequestAddUpdateMstr()
        Try
            Dim ds As DataSet = obj.GetFactoryApplicableVendorList(ddlFactory.SelectedValue)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    ddlVendor.DataSource = ds.Tables(0)
                    ddlVendor.DataTextField = "VendorName"
                    ddlVendor.DataValueField = "vfl_vendor_code"
                    ddlVendor.DataBind()
                    'ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))

                    If ds.Tables(0).Rows.Count = 1 Then
                        ddlVendor.SelectedValue = ds.Tables(0).Rows(0)("vfl_vendor_code").ToString
                        ddlVendor.Enabled = False
                    End If

                End If
            Else
                'ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            End If
            ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try


    End Sub
#End Region



    Protected Sub ddlFactory_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFactory.SelectedIndexChanged
        PopulateVendorList()
    End Sub

    Private Sub BindGrid()
        Dim ds As DataSet
        Dim ms As New TokenRequestAddUpdateMstr()
        Try
            ds = ms.GetTokenRequisitionSessionDetails(ddlFactory.SelectedValue, ddlVendor.SelectedValue, ddlStatus.SelectedValue)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0) Then
                If (Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                    gvTokenRequisitionList.DataSource = ds.Tables(0)
                    gvTokenRequisitionList.DataBind()
                Else
                    gvTokenRequisitionList.DataSource = Nothing
                    gvTokenRequisitionList.DataBind()
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try

    End Sub

    Protected Sub gvTokenRequisitionList_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvTokenRequisitionList.PageIndexChanging
        gvTokenRequisitionList.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub

    Protected Sub gvTokenRequisitionList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTokenRequisitionList.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim rowview As DataRowView = CType(e.Row.DataItem, DataRowView)

            Dim lblSessionId As Label = e.Row.FindControl("lblSessionId")
            'Dim btnGenerateBarcode As Button = e.Row.FindControl("btnGenerateToken")

            lblSessionId.Text = "<a href='TokenRequestAddUpdate_Factory.aspx?" + Constant.SessionKeys.SessionId + "=" + rowview("ts_session_id").ToString() + "'>" + rowview("ts_session_id").ToString() + "</a>"


            'If (rowview("ts_barcode_generated_yn").ToString = "Y") Then
            '    btnGenerateBarcode.Visible = False
            'Else
            '    btnGenerateBarcode.Visible = False
            'End If



        End If

        If (e.Row.RowType = DataControlRowType.Pager) Then
            Dim row As TableRow = New TableRow
            row = e.Row.Controls(0).Controls(0).Controls(0)
            For Each cell As TableCell In row.Cells
                Dim lb As Control = cell.Controls(0)

                If (TypeOf (lb) Is Label) Then
                    'CType(lb, Label).ForeColor = System.Drawing.Color.Red
                    CType(lb, Label).CssClass = "lblpager"
                    'CType(lb, Label).Width = 20
                    'CType(lb, Label).Height = 15
                    'set current pager

                ElseIf (TypeOf (lb) Is LinkButton) Then

                    CType(lb, LinkButton).CssClass = "lnkpager"
                    'CType(lb, LinkButton).Width = 20
                    'CType(lb, LinkButton).Height = 15
                    'CType(lb, LinkButton).ForeColor = Drawing.Color.Black
                End If
            Next
        End If

    End Sub

    'Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles imgbtnSearch.Click
    '    gvTokenRequisitionList.PageIndex = 0
    '    BindGrid()
    'End Sub

    'Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles imgbtnAdd.Click
    '    Response.Redirect("~/TokenRequestAddUpdate_Factory.aspx")
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        gvTokenRequisitionList.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub imgbtnAdd_Click(sender As Object, e As EventArgs) Handles imgbtnAdd.Click
        Response.Redirect("~/TokenRequestAddUpdate_Factory.aspx")
    End Sub

End Class
