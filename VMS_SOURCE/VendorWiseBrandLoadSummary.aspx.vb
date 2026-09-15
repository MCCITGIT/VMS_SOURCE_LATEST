Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Partial Class VendorWiseBrandLoadSummary
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            SelectedYear = Request.QueryString("year")
            SelectedMonth = Request.QueryString("month")
            SelectedBrand = Request.QueryString("brand_name")

            LoadData()
        Else
            'Values will come from ViewState after refresh/postback
            LoadData()
        End If
    End Sub

    Private Property SelectedYear As String
        Get
            Return If(ViewState("SelectedYear"), "").ToString()
        End Get
        Set(value As String)
            ViewState("SelectedYear") = value
        End Set
    End Property

    Private Property SelectedMonth As String
        Get
            Return If(ViewState("SelectedMonth"), "").ToString()
        End Get
        Set(value As String)
            ViewState("SelectedMonth") = value
        End Set
    End Property

    Private Property SelectedBrand As String
        Get
            Return If(ViewState("SelectedBrand"), "").ToString()
        End Get
        Set(value As String)
            ViewState("SelectedBrand") = value
        End Set
    End Property

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    'Private Sub SaveSearchCriteria()
    '    Session("PaymentReconciliationSearchCriteria") = Nothing
    '    Dim dto As New VendorPaymentSearchCriteria()
    '    dto.VendorName = txtVendorName.Text.Trim()
    '    dto.FromDate = txtFromDate.Text.Trim()
    '    dto.ToDate = txtToDate.Text.Trim()
    '    dto.PageNo = gvFgVendorlist.PageIndex
    '    Session("PaymentReconciliationSearchCriteria") = dto
    'End Sub

    'Public Sub RetrieveSearchCriteria()
    '    If Session("PaymentReconciliationSearchCriteria") IsNot Nothing Then
    '        Dim searchCriteria As VendorPaymentSearchCriteria =
    '        CType(Session("PaymentReconciliationSearchCriteria"), VendorPaymentSearchCriteria)
    '        txtVendorName.Text = searchCriteria.VendorName
    '        txtFromDate.Text = searchCriteria.FromDate
    '        txtToDate.Text = searchCriteria.ToDate
    '        gvFgVendorlist.PageIndex = searchCriteria.PageNo
    '    End If
    '    'Update session with current values
    '    SaveSearchCriteria()
    'End Sub

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
    Private Sub LoadData()
        Dim obj As New UserLogin()
        Dim ds As New DataSet()
        ds = obj.GetVendorWiseBrandLoadSummary(SelectedBrand, SelectedYear, SelectedMonth, txtVendor.Text)
        If (ds IsNot Nothing AndAlso ds.Tables(0).Rows.Count > 0) Then
            gvFgVendorlist.DataSource = ds.Tables(0)
            gvFgVendorlist.DataBind()
            txtBrand.Text = SelectedBrand
            txtBrand.Enabled = False
        Else
            gvFgVendorlist.DataSource = Nothing
            gvFgVendorlist.DataBind()
        End If
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

    ' Modified-by MUKESH BHAGAT on 15-09-2026 : Serviceability (%) as a colored status pill -
    ' same 4-tier thresholds/colors as the Dispatch % badge on Home.aspx / VendorWiseLoadSummary.aspx.
    Protected Sub gvFgVendorlist_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType <> DataControlRowType.DataRow Then Exit Sub

        Dim lblServiceability As Label = CType(e.Row.FindControl("lblServiceability"), Label)
        If lblServiceability Is Nothing Then Exit Sub

        Dim pct As Decimal
        If Not Decimal.TryParse(lblServiceability.Text, pct) Then Exit Sub

        Dim pillClass As String
        If pct = 0 Then
            pillClass = "pct-pill-danger"
        ElseIf pct < 50 Then
            pillClass = "pct-pill-warning"
        ElseIf pct < 80 Then
            pillClass = "pct-pill-info"
        Else
            pillClass = "pct-pill-success"
        End If

        lblServiceability.CssClass = "pct-pill " & pillClass
        lblServiceability.Text = pct.ToString("0.00") & "%"
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        gvFgVendorlist.PageIndex = 0
        'SaveSearchCriteria()
        LoadData()
    End Sub
    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        'Session("PaymentReconciliationSearchCriteria") = Nothing
        txtVendor.Text = String.Empty
        'txtFromDate.Text = String.Empty
        'txtToDate.Text = String.Empty
        gvFgVendorlist.PageIndex = 0
        LoadData()
    End Sub
End Class
