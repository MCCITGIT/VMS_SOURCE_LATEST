Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports System.Text
Imports VMS.DataAccess
Partial Class VendorWiseLoadSummary
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            SelectedYear = Request.QueryString("year")
            SelectedMonth = Request.QueryString("month")
            SelectedVendorCode = Request.QueryString("vendor_code")
            SelectedVendorName = Request.QueryString("vendor_name")

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

    Private Property SelectedVendorCode As String
        Get
            Return If(ViewState("SelectedVendorCode"), "").ToString()
        End Get
        Set(value As String)
            ViewState("SelectedVendorCode") = value
        End Set
    End Property

    Private Property SelectedVendorName As String
        Get
            Return If(ViewState("SelectedVendorName"), "").ToString()
        End Get
        Set(value As String)
            ViewState("SelectedVendorName") = value
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
    ' Modified-by MUKESH BHAGAT on 14-09-2026 : SKU list redesigned as a 10-dot pictogram per row
    ' with an overall serviceability donut beside it - ported from Home.aspx.vb
    ' BindLoadDispatchChart()/BuildSkuSummaryPanel() (same [GetLoadDespatchSummary] columns, same
    ' visuals) so both pages look and behave the same way. See Home.aspx.vb for the fuller
    ' design-history comments on the dot math and the donut's add_endRequest rendering.
    Private Sub LoadData()
        txtVendor.Text = SelectedVendorName
        txtVendor.Enabled = False

        Dim obj As New UserLogin()
        Dim ds As DataSet = obj.GetLoadDespatchSummary(SelectedVendorCode, SelectedYear, SelectedMonth, txtSku.Text)

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            litSkuRows.Text = "<div class='mst-empty-state'>No data found for this selection.</div>"
            litSkuSummary.Text = BuildSkuSummaryPanel(0, 0)
            Return
        End If

        Dim dt As DataTable = ds.Tables(0)
        Dim sb As New StringBuilder()
        Dim grandTotalLoad As Decimal = 0
        Dim grandTotalDispatch As Decimal = 0

        For Each row As DataRow In dt.Rows
            Dim sku As String = row("SKU_Name").ToString()
            Dim totalLoad As Decimal = Convert.ToDecimal(row("Total_Load_NOP"))
            Dim totalDispatch As Decimal = Convert.ToDecimal(row("Total_Despatched_NOP"))
            Dim pct As Decimal = Convert.ToDecimal(row("Dispatch_Percentage"))
            Dim pendingLoad As Decimal = Convert.ToDecimal(row("Pending_Load_NOP"))

            grandTotalLoad += totalLoad
            grandTotalDispatch += totalDispatch

            Dim badgeClass As String
            If pct = 0 Then
                badgeClass = "badge-danger"
            ElseIf pct < 50 Then
                badgeClass = "badge-warning"
            ElseIf pct < 80 Then
                badgeClass = "badge-info"
            Else
                badgeClass = "badge-success"
            End If

            Dim pendingClass As String = If(pendingLoad > 0, "pending-value pending-active", "pending-value")

            ' ---- 10-dot pictogram : 1 dot = totalLoad / 10 ----
            Dim dotValue As Decimal = If(totalLoad > 0, totalLoad / 10D, 0D)
            Dim filledUnits As Decimal = If(totalLoad > 0, (totalDispatch / totalLoad) * 10D, 0D)
            Dim fullDots As Integer = Math.Floor(filledUnits)
            Dim fracDot As Decimal = filledUnits - fullDots
            If totalDispatch > 0 AndAlso filledUnits < 0.5D Then
                fullDots = 0
                fracDot = 0.5D
            End If
            If fullDots >= 10 Then
                fullDots = 10
                fracDot = 0
            End If

            Dim dotsHtml As New StringBuilder()
            For i As Integer = 0 To 9
                If i < fullDots Then
                    dotsHtml.Append("<div class='sku-dot sku-dot-full'></div>")
                ElseIf i = fullDots AndAlso fracDot > 0 Then
                    Dim fracDeg As Integer = CInt(Math.Round(fracDot * 360, 0))
                    dotsHtml.Append("<div class='sku-dot sku-dot-partial' style='background:conic-gradient(#0ca30c " & fracDeg.ToString() & "deg, #e9ecef 0deg)'></div>")
                Else
                    dotsHtml.Append("<div class='sku-dot sku-dot-empty'></div>")
                End If
            Next

            sb.Append("<div class='sku-row'>")
            sb.Append("  <div class='sku-label' title='" & Server.HtmlEncode(sku) & "'>" & Server.HtmlEncode(sku) & "</div>")
            sb.Append("  <div class='sku-dots' title='1 dot ~ " & dotValue.ToString("N0") & " units'>")
            sb.Append(dotsHtml.ToString())
            sb.Append("  </div>")
            sb.Append("  <div class='sku-stats'>Load: <b>" & totalLoad.ToString("N0") & "</b> | Dispatch: <b>" & totalDispatch.ToString("N0") & "</b> | Pending: <b class='" & pendingClass & "'>" & pendingLoad.ToString("N0") & "</b></div>")
            sb.Append("  <div class='sku-badge " & badgeClass & "'>" & pct.ToString("0.0") & "%</div>")
            sb.Append("</div>")
        Next

        litSkuRows.Text = sb.ToString()
        litSkuSummary.Text = BuildSkuSummaryPanel(grandTotalLoad, grandTotalDispatch)
    End Sub

    Private Function BuildSkuSummaryPanel(totalLoad As Decimal, totalDispatch As Decimal) As String
        Dim pct As Decimal = If(totalLoad > 0, Math.Round(totalDispatch / totalLoad * 100, 1), 0D)
        Dim pending As Decimal = Math.Max(totalLoad - totalDispatch, 0)

        Dim pctColor As String
        If pct = 0 Then
            pctColor = "#e74c3c"
        ElseIf pct < 50 Then
            pctColor = "#f39c12"
        ElseIf pct < 80 Then
            pctColor = "#d4ac0d"
        Else
            pctColor = "#27ae60"
        End If

        Dim html As New StringBuilder()
        html.Append("<div class='sku-summary-inner'>")
        html.Append("  <div class='sku-summary-title'>Overall Serviceability</div>")
        html.Append("  <div class='sku-donut-wrap'>")
        html.Append("    <canvas id='skuOverallChart' width='130' height='130' data-dispatch='" & totalDispatch.ToString(System.Globalization.CultureInfo.InvariantCulture) & "' data-pending='" & pending.ToString(System.Globalization.CultureInfo.InvariantCulture) & "'></canvas>")
        html.Append("    <div class='sku-donut-center'>")
        html.Append("      <div class='sku-donut-pct' style='color:" & pctColor & "'>" & pct.ToString("0.0") & "%</div>")
        html.Append("      <div class='sku-donut-caption'>" & If(totalLoad > 0, "Dispatched", "No data") & "</div>")
        html.Append("    </div>")
        html.Append("  </div>")
        html.Append("  <div class='sku-summary-stats'>")
        html.Append("    <div><span><span class='dot total-load'></span>Total Load</span><b>" & totalLoad.ToString("N0") & "</b></div>")
        html.Append("    <div><span><span class='dot total-dispatch'></span>Total Dispatch</span><b>" & totalDispatch.ToString("N0") & "</b></div>")
        html.Append("    <div><span>Pending</span><b class='" & If(pending > 0, "pending-value pending-active", "pending-value") & "'>" & pending.ToString("N0") & "</b></div>")
        html.Append("  </div>")
        html.Append("</div>")

        Return html.ToString()
    End Function

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

    ' Modified-by MUKESH BHAGAT on 14-09-2026 : gvFgVendorlist.PageIndex reset removed - the grid
    ' was replaced by the dot-pictogram list (no paging control); Page_Load's postback branch
    ' already calls LoadData() again after this handler runs, picking up the new txtSku value.
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
    End Sub
    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        txtSku.Text = String.Empty
    End Sub
End Class
