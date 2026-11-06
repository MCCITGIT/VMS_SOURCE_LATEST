Imports System.Data
Imports System.Collections.Generic
Imports VMS.Web

Partial Class RawMaterialPoEntryList
    Inherits System.Web.UI.Page

    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()

        If Not IsPostBack Then
            PopulateVendorList()
            BindPoList()
        End If
    End Sub
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateVendorList()
        Dim obj As New OPC_VendorClass()
        Dim ds As DataSet = obj.GetRawMaterialVendorList()

        ddlVendor.Items.Clear()
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlVendor.DataSource = ds.Tables(0)
            ddlVendor.DataTextField = "vendor_name"
            ddlVendor.DataValueField = "vendor_code"
            ddlVendor.DataBind()
        End If
        ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
    End Sub

    Private Sub BindPoList()
        Dim obj As New POLinkingRequestClass()
        Dim ds As DataSet = obj.GetRawMaterialPoList(userInfo.userIDEntity, ddlVendor.SelectedValue)
        Dim table As DataTable = RmGridHelper.GetTable(ds)
        gvPoList.PageIndex = 0
        If table IsNot Nothing AndAlso table.Rows.Count > 0 Then
            RmGridHelper.BindPaged(gvPoList, FirstPoPage(table))
            hdnPolHasData.Value = "1"
        Else
            RmGridHelper.BindPaged(gvPoList, table)
            hdnPolHasData.Value = "0"
        End If
        hdnPolPageSize.Value = If(gvPoList.PageSize > 0, gvPoList.PageSize, 10).ToString()
        hdnPolVendor.Value = ddlVendor.SelectedValue
    End Sub

    Private Function FirstPoPage(ByVal table As DataTable) As DataTable
        Dim pageSize As Integer = gvPoList.PageSize
        If pageSize <= 0 Then pageSize = 10
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
    Public Shared Function GetMoreRawMaterialPos(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal vendor As String) As Object
        Dim rows As New List(Of Object)
        Dim sessionUser = System.Web.HttpContext.Current.Session(Constant.SessionKeys.UserInfo)
        If sessionUser Is Nothing Then Return New With {.rows = rows, .total = 0}
        Dim info As VMSUserEntity = CType(sessionUser, VMSUserEntity)
        If pageSize <= 0 Then pageSize = 10
        If pageIndex < 0 Then pageIndex = 0
        Dim ds As DataSet = New POLinkingRequestClass().GetRawMaterialPoList(info.userIDEntity, If(vendor, String.Empty))
        Dim total As Integer = 0
        Dim table As DataTable = RmGridHelper.GetTable(ds)
        If table IsNot Nothing Then
            total = table.Rows.Count
            Dim start As Integer = pageIndex * pageSize
            Dim last As Integer = Math.Min(start + pageSize, total) - 1
            Dim i As Integer
            For i = start To last
                Dim r As DataRow = table.Rows(i)
                rows.Add(New With {
                    .serial = (i + 1).ToString(),
                    .poNo = Convert.ToString(r("display_po_no")),
                    .vendorName = Convert.ToString(r("vendor_name")),
                    .vendorCode = Convert.ToString(r("vendor_code")),
                    .qty = FormatN2(r("qty")),
                    .amount = FormatN2(r("amount")),
                    .pdfPo = Convert.ToString(r("po_no"))
                })
            Next
        End If
        Return New With {.rows = rows, .total = total}
    End Function

    Private Shared Function FormatN2(ByVal value As Object) As String
        If value Is Nothing OrElse IsDBNull(value) OrElse Convert.ToString(value).Trim() = "" Then Return String.Empty
        Dim number As Decimal
        If Decimal.TryParse(Convert.ToString(value), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, number) OrElse Decimal.TryParse(Convert.ToString(value), number) Then
            Return number.ToString("N2")
        End If
        Return Convert.ToString(value)
    End Function

    Protected Sub lbBtnAdd_Click(sender As Object, e As EventArgs)
        Response.Redirect("RawMaterialPoEntry.aspx")
    End Sub

    Protected Sub lbBtnSearch_Click(sender As Object, e As EventArgs)
        gvPoList.PageIndex = 0
        BindPoList()
    End Sub

    'Protected Sub gvPoList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
    '    gvPoList.PageIndex = e.NewPageIndex
    '    BindPoList()
    'End Sub
End Class
