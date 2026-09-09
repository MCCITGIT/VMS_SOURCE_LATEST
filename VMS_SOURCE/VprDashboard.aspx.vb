Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Partial Class VprDashboard
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            If Session("PaymentReconciliationSearchCriteria") IsNot Nothing Then
                RetrieveSearchCriteria()
            Else
            End If
            BindGrid()
        End If
    End Sub
    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub SaveSearchCriteria()
        Session("PaymentReconciliationSearchCriteria") = Nothing
        Dim dto As New VendorPaymentSearchCriteria()
        dto.VendorName = txtVendorName.Text.Trim()
        dto.FromDate = txtFromDate.Text.Trim()
        dto.ToDate = txtToDate.Text.Trim()
        dto.PageNo = gvFgVendorlist.PageIndex
        Session("PaymentReconciliationSearchCriteria") = dto
    End Sub

    Public Sub RetrieveSearchCriteria()
        If Session("PaymentReconciliationSearchCriteria") IsNot Nothing Then
            Dim searchCriteria As VendorPaymentSearchCriteria =
            CType(Session("PaymentReconciliationSearchCriteria"), VendorPaymentSearchCriteria)
            txtVendorName.Text = searchCriteria.VendorName
            txtFromDate.Text = searchCriteria.FromDate
            txtToDate.Text = searchCriteria.ToDate
            gvFgVendorlist.PageIndex = searchCriteria.PageNo
        End If
        'Update session with current values
        SaveSearchCriteria()
    End Sub

    'Private Sub BindGrid()
    '    Try
    '        Dim vendorName As String = txtVendorName.Text.Trim()

    '        'Dim fromDate As String = "2026-01-01"
    '        'Dim toDate As String = "2026-12-31"
    '        Dim fromDate As String = FormatDate(txtFromDate.Text)
    '        Dim toDate As String = FormatDate(txtToDate.Text)

    '        'Dim pageNo = gvFgVendorlist.PageIndex + 1
    '        'Dim pageSize = gvFgVendorlist.PageSize

    '        Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
    '        'Dim ds As DataSet = obj.GetVendorPaymentDashboardDetails(vendorName, fromDate, toDate, pageNo, pageSize, userInfo.userIDEntity)
    '        Dim ds As DataSet = obj.GetVendorPaymentDashboardDetails(vendorName, fromDate, toDate, userInfo.userIDEntity)
    '        Dim table As DataTable = RmGridHelper.GetTable(ds)
    '        'RmGridHelper.BindPaged(gvRmPendingList, table)
    '        If table IsNot Nothing AndAlso table.Rows.Count > 0 Then
    '            gvFgVendorlist.Visible = True
    '            gvFgVendorlist.DataSource = table
    '            gvFgVendorlist.DataBind()
    '            '        gvFgVendorlist.VirtualItemCount =
    '            'Convert.ToInt32(table.Rows(0)("total_records"))
    '            'TotalRecords = Convert.ToInt32(table.Rows(0)("total_records"))
    '            'BindPager()
    '        End If
    '    Catch ex As Exception
    '        Throw
    '    End Try
    'End Sub
    Private Sub BindGrid()
        Try
            Dim vendorName As String = txtVendorName.Text.Trim()

            Dim fromDate As Nullable(Of DateTime) = GetDateValue(txtFromDate.Text)
            Dim toDate As Nullable(Of DateTime) = GetDateValue(txtToDate.Text)

            Dim obj As POLinkingRequestClass = New POLinkingRequestClass()
            Dim ds As DataSet = obj.GetVendorPaymentDashboardDetails(vendorName, fromDate, toDate, userInfo.userIDEntity)
            'RmGridHelper.BindPaged(gvRmPendingList, table)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim dateRow As DataRow = ds.Tables(0).Rows(0)

                If Not IsDBNull(dateRow("from_date")) Then
                    txtFromDate.Text = Convert.ToDateTime(dateRow("from_date")).ToString("dd-MM-yyyy")
                End If

                If Not IsDBNull(dateRow("to_date")) Then
                    txtToDate.Text = Convert.ToDateTime(dateRow("to_date")).ToString("dd-MM-yyyy")
                End If
            End If

            If ds IsNot Nothing AndAlso ds.Tables.Count > 1 Then
                Dim table As DataTable = ds.Tables(1)
                If table IsNot Nothing AndAlso table.Rows.Count > 0 Then
                    gvFgVendorlist.Visible = True
                    gvFgVendorlist.DataSource = table
                    gvFgVendorlist.DataBind()
                Else
                    gvFgVendorlist.Visible = False
                    gvFgVendorlist.DataSource = Nothing
                    gvFgVendorlist.DataBind()
                End If
            End If

            'Save resolved dates so pagination/navigation retains them
            SaveSearchCriteria()
        Catch ex As Exception
            Throw
        End Try
    End Sub

    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime

        If (stringdate.Equals(String.Empty)) Then
            Return SqlDateTime.MinValue
        End If

        If Not (stringdate = String.Empty) Then
            Dim ddate As String() = stringdate.Split("-")
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

    Private Function GetDateValue(ByVal value As String) As Nullable(Of DateTime)

        If String.IsNullOrWhiteSpace(value) Then
            Return Nothing
        End If

        Dim parsedDate As DateTime

        If DateTime.TryParseExact(
        value.Trim(),
        "dd-MM-yyyy",
        System.Globalization.CultureInfo.InvariantCulture,
        System.Globalization.DateTimeStyles.None,
        parsedDate) Then

            Return parsedDate
        End If

        Return Nothing

    End Function

    'Private Property TotalRecords As Integer
    '    Get
    '        Return If(ViewState("TotalRecords") Is Nothing, 0, Convert.ToInt32(ViewState("TotalRecords")))
    '    End Get
    '    Set(value As Integer)
    '        ViewState("TotalRecords") = value
    '    End Set
    'End Property

    'Private Sub BindPager()
    '    Dim totalPages As Integer = CInt(Math.Ceiling(TotalRecords / gvFgVendorlist.PageSize))
    '    ddlPageNumber.Items.Clear()
    '    For i As Integer = 1 To totalPages
    '        ddlPageNumber.Items.Add(
    '            New ListItem(i.ToString(), i.ToString())
    '        )
    '    Next
    '    ddlPageNumber.SelectedValue = (gvFgVendorlist.PageIndex + 1).ToString()
    '    lblTotalPages.Text = totalPages.ToString()
    'End Sub

    'Protected Sub Page_Click(sender As Object, e As EventArgs)
    '    Dim btn As LinkButton = CType(sender, LinkButton)
    '    gvFgVendorlist.PageIndex = Convert.ToInt32(btn.CommandArgument) - 1
    '    BindGrid()
    'End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        gvFgVendorlist.PageIndex = 0
        SaveSearchCriteria()
        BindGrid()
    End Sub
    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        Session("PaymentReconciliationSearchCriteria") = Nothing
        txtVendorName.Text = String.Empty
        txtFromDate.Text = String.Empty
        txtToDate.Text = String.Empty
        gvFgVendorlist.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub gvFgVendorlist_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvFgVendorlist.PageIndex = e.NewPageIndex
        SaveSearchCriteria()
        BindGrid()
    End Sub

    Protected Sub gvFgVendorlist_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Try
            'If e.CommandName = "Details" Then
            '    Dim row As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)
            '    Dim lblVendorName As Label = CType(row.FindControl("lblbrandname"), Label)
            '    Dim hdnVendorCode As HiddenField = CType(row.FindControl("hdnBrandId"), HiddenField)

            '    Dim vendorName As String = lblVendorName.Text.Trim()
            '    Dim vendorCode As String = hdnVendorCode.Value.Trim()
            '    Dim fromDate As String = txtFromDate.Text.Trim()
            '    Dim toDate As String = txtToDate.Text.Trim()

            '    Response.Redirect(
            '    "VendorReleaseReconciliation.aspx" &
            '    "?vendorName=" & Server.UrlEncode(vendorName) &
            '    "&vendorCode=" & Server.UrlEncode(vendorCode) &
            '    "&fromDate=" & Server.UrlEncode(fromDate) &
            '    "&toDate=" & Server.UrlEncode(toDate)
            '    )
            'End If

            If e.CommandName = "Page" Then
                Exit Sub
            End If


            Dim linkButton As LinkButton = TryCast(e.CommandSource, LinkButton)

            If linkButton Is Nothing Then
                Exit Sub
            End If

            Dim row As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)
            Dim hdnBrandId As HiddenField = CType(row.FindControl("hdnBrandId"), HiddenField)
            Dim unitCode As String = hdnBrandId.Value
            Dim lblVendorName As Label = CType(row.FindControl("lblbrandname"), Label)
            Dim vendorName As String = lblVendorName.Text.Trim()
            Dim fromDate As String = txtFromDate.Text
            Dim toDate As String = txtToDate.Text
            Dim flag As String = e.CommandName.ToUpper()

            Response.Redirect(
                "VendorReleaseReconciliation.aspx" &
                "?vendorName=" & Server.UrlEncode(vendorName) &
                "&vendorCode=" & Server.UrlEncode(unitCode) &
                "&fromDate=" & Server.UrlEncode(fromDate) &
                "&toDate=" & Server.UrlEncode(toDate) &
                "&flag=" & Server.UrlEncode(flag)
            )
            'If (e.CommandName = "Dispatched") Then
            '    Response.Redirect(
            '        "VendorReleaseReconciliation.aspx" &
            '        "?vendorName=" & Server.UrlEncode(vendorName) &
            '        "&vendorCode=" & Server.UrlEncode(unitCode) &
            '        "&fromDate=" & Server.UrlEncode(fromDate) &
            '        "&toDate=" & Server.UrlEncode(toDate) &
            '        "&flag=DISPATCHED"
            '    )
            'ElseIf (e.CommandName = "Delivered") Then
            '    Response.Redirect(
            '        "VendorReleaseReconciliation.aspx" &
            '        "?vendorName=" & Server.UrlEncode(vendorName) &
            '        "&vendorCode=" & Server.UrlEncode(unitCode) &
            '        "&fromDate=" & Server.UrlEncode(fromDate) &
            '        "&toDate=" & Server.UrlEncode(toDate) &
            '        "&flag=DISPATCHED"
            '    )
            'ElseIf (e.CommandName = "GrnNotDone") Then
            '    Response.Redirect(
            '        "VendorReleaseReconciliation.aspx" &
            '        "?vendorName=" & Server.UrlEncode(vendorName) &
            '        "&vendorCode=" & Server.UrlEncode(unitCode) &
            '        "&fromDate=" & Server.UrlEncode(fromDate) &
            '        "&toDate=" & Server.UrlEncode(toDate) &
            '        "&flag=DISPATCHED"
            '    )
            'ElseIf (e.CommandName = "ManualGrn") Then
            '    Response.Redirect(
            '        "VendorReleaseReconciliation.aspx" &
            '        "?vendorName=" & Server.UrlEncode(vendorName) &
            '        "&vendorCode=" & Server.UrlEncode(unitCode) &
            '        "&fromDate=" & Server.UrlEncode(fromDate) &
            '        "&toDate=" & Server.UrlEncode(toDate) &
            '        "&flag=DISPATCHED"
            '    )
            'ElseIf (e.CommandName = "Paid") Then
            '    Response.Redirect(
            '        "VendorReleaseReconciliation.aspx" &
            '        "?vendorName=" & Server.UrlEncode(vendorName) &
            '        "&vendorCode=" & Server.UrlEncode(unitCode) &
            '        "&fromDate=" & Server.UrlEncode(fromDate) &
            '        "&toDate=" & Server.UrlEncode(toDate) &
            '        "&flag=DISPATCHED"
            '    )
            'End If
        Catch ex As Exception
            Throw
        End Try
    End Sub

    'Protected Sub lnkPrev_Click(sender As Object, e As EventArgs)
    '    If gvFgVendorlist.PageIndex > 0 Then
    '        gvFgVendorlist.PageIndex -= 1
    '        BindGrid()
    '    End If
    'End Sub

    'Protected Sub lnkNext_Click(sender As Object, e As EventArgs)
    '    Dim totalPages As Integer = Convert.ToInt32(ViewState("TotalPages"))

    '    If gvFgVendorlist.PageIndex < totalPages - 1 Then
    '        gvFgVendorlist.PageIndex += 1
    '        BindGrid()
    '    End If
    'End Sub

    'Protected Sub lnkPage_Click(sender As Object, e As EventArgs)
    '    Dim btn As LinkButton = CType(sender, LinkButton)
    '    gvFgVendorlist.PageIndex = Convert.ToInt32(btn.CommandArgument) - 1
    '    BindGrid()
    'End Sub

    'Protected Sub ddlPageNumber_SelectedIndexChanged(sender As Object, e As EventArgs)
    '    gvFgVendorlist.PageIndex = Convert.ToInt32(ddlPageNumber.SelectedValue) - 1
    '    BindGrid()
    'End Sub
End Class
