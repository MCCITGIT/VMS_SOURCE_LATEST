Imports System.Data
Imports System.Text
Imports System.Collections.Generic
Imports VMS.Web

''' <summary>
''' Product Rate Approval - history of one SKU formulation (every negotiation revision and every
''' approved release), opened from Product_Formulation.aspx or Product_Rate_Approval_List.aspx with
''' ?id=<sf_id of any row of the SKU>. Added by MUKESH BHAGAT on 12-Oct-2026.
''' </summary>
Partial Class Product_Rate_Approval
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            Dim id As Integer = 0
            Integer.TryParse(Convert.ToString(Request.QueryString("id")), id)
            If id <= 0 Then
                Response.Redirect("~/Product_Rate_Approval_List.aspx")
                Exit Sub
            End If
            Binddata(id)
        End If
    End Sub

    Private Sub CheckLogin()
        If Session(Constant.SessionKeys.UserInfo) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If
        userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
    End Sub

    Private Sub Binddata(ByVal sfId As Integer)
        Try
            Dim obj As New OPC_VendorClass()
            Dim ds As DataSet = obj.GetSkuFormulationHistory(sfId)
            If ds Is Nothing OrElse ds.Tables.Count < 2 OrElse ds.Tables(0).Rows.Count = 0 Then
                lblErrorMessage.Text = "Formulation not found."
                Exit Sub
            End If
            Dim h As DataRow = ds.Tables(0).Rows(0)
            ' a unit (vendor) user may only see the history of its own vendor's formulations
            If userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT AndAlso
               Not String.Equals(Convert.ToString(h("sf_vendor_code")).Trim(), Convert.ToString(userInfo.userBranchEntity).Trim(), StringComparison.OrdinalIgnoreCase) Then
                Response.Redirect("~/Home.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
                Exit Sub
            End If
            litSku.Text = Server.HtmlEncode(Convert.ToString(h("sf_product_code")) & " - " & Convert.ToString(h("product_name")))
            litBrand.Text = Server.HtmlEncode(Convert.ToString(h("brand_name")) & " (" & Convert.ToString(h("sf_brand_code")) & ")")
            litVendor.Text = Server.HtmlEncode(Convert.ToString(h("vendor_name")) & " (" & Convert.ToString(h("sf_vendor_code")) & ")")
            litReleases.Text = Convert.ToString(h("release_count"))
            litRows.Text = Convert.ToString(h("row_count"))
            If IsDBNull(h("active_sf_id")) Then
                litActive.Text = "No approved release yet - formulation is still under negotiation."
            Else
                litActive.Text = "In force: Release " & Convert.ToString(h("active_release_no")) & " - SKU price " & String.Format("{0:0.00}", h("active_sku_price")) &
                                 " - since " & String.Format("{0:dd/MM/yyyy HH:mm}", h("active_since"))
            End If
            gvHistory.DataSource = ds.Tables(1)
            gvHistory.DataBind()
            If ds.Tables.Count >= 4 Then
                litMatrix.Text = BuildMatrix(ds.Tables(1), ds.Tables(2), ds.Tables(3))
            Else
                ' history SP is the older 2-table version: build the lines/packs per revision from opc_sku_formulation_get
                Dim dtl As DataTable = Nothing, packs As DataTable = Nothing
                For Each r As DataRow In ds.Tables(1).Rows
                    Dim id As Integer = Convert.ToInt32(r("sf_id"))
                    Dim one As DataSet = obj.GetSkuFormulation(id)
                    If one Is Nothing OrElse one.Tables.Count < 3 Then Continue For
                    If dtl Is Nothing Then dtl = one.Tables(1).Clone() : dtl.Columns.Add("sfd_hdr_id", GetType(Integer))
                    If packs Is Nothing Then packs = one.Tables(2).Clone() : packs.Columns.Add("pch_sf_id", GetType(Integer))
                    For Each d As DataRow In one.Tables(1).Rows
                        Dim nr As DataRow = dtl.NewRow()
                        For Each c As DataColumn In one.Tables(1).Columns : nr(c.ColumnName) = d(c.ColumnName) : Next
                        nr("sfd_hdr_id") = id : dtl.Rows.Add(nr)
                    Next
                    For Each p As DataRow In one.Tables(2).Rows
                        Dim nr As DataRow = packs.NewRow()
                        For Each c As DataColumn In one.Tables(2).Columns : nr(c.ColumnName) = p(c.ColumnName) : Next
                        nr("pch_sf_id") = id : packs.Rows.Add(nr)
                    Next
                Next
                If dtl IsNot Nothing AndAlso packs IsNot Nothing Then
                    litMatrix.Text = BuildMatrix(ds.Tables(1), dtl, packs)
                Else
                    litMatrix.Text = "<div class='pra-small'>Comparison not available - re-run opc_sku_formulation_history.sql.</div>"
                End If
            End If
            If String.IsNullOrWhiteSpace(litMatrix.Text) Then litMatrix.Text = "<div class='pra-small'>Matrix produced no output.</div>"
        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    ''' <summary>Side-by-side matrix: columns = revisions/releases, shown NEWEST first (computed oldest to newest, written in reverse - see
    ''' AppendNewestFirst); rows = raw materials, SKU price, packs. A cell is coloured against the revision submitted before it
    ''' (the column to its right): price up (red), down (green), added (yellow), removed (grey).</summary>
    ''' <summary>Coloured change badge against the previous column: up arrow +amount (+%) in red, down arrow -amount (-%) in green.</summary>
    Private Shared Function DeltaBadge(ByVal prev As Decimal, ByVal cur As Decimal) As String
        Dim diff As Decimal = cur - prev
        If diff = 0D Then Return ""
        Dim pct As String = If(prev = 0D, "", " (" & If(diff > 0D, "+", "-") & Math.Abs(Math.Round(diff / prev * 100D, 1)).ToString("0.#") & "%)")
        If diff > 0D Then Return "<span class='pra-delta pra-d-up'>&#9650; +" & diff.ToString("0.00") & pct & "</span>"
        Return "<span class='pra-delta pra-d-down'>&#9660; -" & Math.Abs(diff).ToString("0.00") & pct & "</span>"
    End Function

    Private Function BuildMatrix(ByVal hdr As DataTable, ByVal dtl As DataTable, ByVal packs As DataTable) As String
        Dim cols As New List(Of DataRow)()
        For Each r As DataRow In hdr.Select("", "sf_id ASC")
            cols.Add(r)
        Next
        If cols.Count = 0 Then Return "<div class='pra-small'>No revisions.</div>"

        ' raw materials in order of first appearance
        Dim rmOrder As New List(Of String)()
        Dim rmName As New Dictionary(Of String, String)()
        For Each c As DataRow In cols
            For Each d As DataRow In dtl.Select("sfd_hdr_id = " & Convert.ToInt32(c("sf_id")))
                Dim code As String = Convert.ToString(d("sfd_rawmat_code")).Trim()
                If Not rmName.ContainsKey(code) Then rmOrder.Add(code) : rmName(code) = Convert.ToString(d("rawmat_name"))
            Next
        Next
        ' pack size is free text ("1LTR" / "1ltr"): group case-insensitively, show the first spelling seen
        Dim packOrder As New List(Of String)()
        For Each c As DataRow In cols
            For Each p As DataRow In packs.Select("pch_sf_id = " & Convert.ToInt32(c("sf_id")))
                Dim ps As String = Convert.ToString(p("pch_pack_size")).Trim()
                If Not packOrder.Exists(Function(x) String.Equals(x, ps, StringComparison.OrdinalIgnoreCase)) Then packOrder.Add(ps)
            Next
        Next

        Dim sb As New StringBuilder()
        sb.Append("<table class='pra-matrix'><thead><tr><th class='pra-rowhead'>Raw material</th>")
        Dim hdrCells As New List(Of String)()
        For Each c As DataRow In cols
            Dim st As String = Convert.ToString(c("sf_status")).Trim().ToUpperInvariant()
            Dim who As String = Server.HtmlEncode(Convert.ToString(c("submitted_by")))
            Dim whenTxt As String = If(IsDBNull(c("submitted_on")), "", Convert.ToDateTime(c("submitted_on")).ToString("dd/MM/yy HH:mm"))
            Dim tip As String = "Vendor remarks: " & Convert.ToString(c("vendor_remarks")) & vbLf & "HO remarks: " & Convert.ToString(c("sf_ho_remarks")) &
                                If(IsDBNull(c("sf_approved_on")), "", vbLf & "Decided by " & Convert.ToString(c("sf_approved_by")) & " on " & Convert.ToDateTime(c("sf_approved_on")).ToString("dd/MM/yy HH:mm"))
            Dim cls As String = "pra-col-" & st.ToLowerInvariant()
            If st = "APPROVED" AndAlso Convert.ToString(c("sf_is_active")) = "Y" Then cls = "pra-col-active"
            Dim th As New StringBuilder()
            th.Append("<th class='" & cls & "' title='" & Server.HtmlEncode(tip) & "'>")
            th.Append("<a href='Product_Formulation.aspx?id=" & Convert.ToInt32(c("sf_id")) & "' style='color:#fff;text-decoration:underline;'>" & Server.HtmlEncode(Convert.ToString(c("version_text"))) & "</a>")
            th.Append("<span class='pra-hdr-sub'>" & st.Replace("_", " ") & If(st = "APPROVED" AndAlso Convert.ToString(c("sf_is_active")) = "Y", " (in force)", "") & "</span>")
            ' who made this move: pill with role (VENDOR / HO when the SP returns sf_submitted_role) and user id
            Dim role As String = If(hdr.Columns.Contains("sf_submitted_role"), Convert.ToString(c("sf_submitted_role")).Trim().ToUpperInvariant(), "")
            Dim pillCls As String = If(role = "HO", "pra-who-ho", If(role = "VENDOR", "pra-who-vendor", "pra-who-na"))
            th.Append("<span class='pra-who " & pillCls & "'>" & If(role <> "", "<small>" & role & "</small> ", "") & who & "</span>")
            th.Append("<span class='pra-hdr-sub'>" & whenTxt & "</span></th>")
            hdrCells.Add(th.ToString())
        Next
        AppendNewestFirst(sb, hdrCells)
        sb.Append("</tr></thead><tbody>")

        ' --- raw material rows ---
        For Each code As String In rmOrder
            sb.Append("<tr><td class='pra-rowhead'>" & Server.HtmlEncode(rmName(code)) & "<br/><span class='pra-small'>" & Server.HtmlEncode(code) & "</span></td>")
            Dim prevPrice As Decimal? = Nothing, prevExists As Boolean = False, prevRatio As Decimal? = Nothing
            Dim rmCells As New List(Of String)()
            For Each c As DataRow In cols
                Dim d() As DataRow = dtl.Select("sfd_hdr_id = " & Convert.ToInt32(c("sf_id")) & " AND sfd_rawmat_code = '" & code.Replace("'", "''") & "'")
                If d.Length = 0 Then
                    rmCells.Add("<td class='pra-gone'>" & If(prevExists, "<span class='pra-delta pra-d-gone'>REMOVED</span>", "&mdash;") & "</td>")
                    prevExists = False : prevPrice = Nothing : prevRatio = Nothing
                Else
                    Dim ratio As Decimal = Convert.ToDecimal(d(0)("sfd_ratio")), price As Decimal = Convert.ToDecimal(d(0)("sfd_price")), amt As Decimal = Convert.ToDecimal(d(0)("sfd_amount"))
                    Dim cls As String = "pra-val"
                    Dim badge As String = ""
                    If Not prevExists Then
                        If cols.IndexOf(c) > 0 Then cls &= " pra-new" : badge = "<span class='pra-delta pra-d-new'>NEW</span>"
                    ElseIf prevPrice.HasValue AndAlso price > prevPrice.Value Then
                        cls &= " pra-up" : badge = DeltaBadge(prevPrice.Value, price)
                    ElseIf prevPrice.HasValue AndAlso price < prevPrice.Value Then
                        cls &= " pra-down" : badge = DeltaBadge(prevPrice.Value, price)
                    End If
                    If prevRatio.HasValue AndAlso prevExists AndAlso ratio <> prevRatio.Value Then
                        badge &= "<span class='pra-delta pra-d-ratio'>ratio " & prevRatio.Value.ToString("0.##") & "% &rarr; " & ratio.ToString("0.##") & "%</span>"
                        If cls = "pra-val" Then cls &= " pra-new"
                    End If
                    rmCells.Add("<td class='" & cls & "'><div class='pra-fig'>" & price.ToString("0.00") & "</div><div class='pra-sub'>" & ratio.ToString("0.##") & "% share = " & amt.ToString("0.00") & "</div>" & badge & "</td>")
                    prevExists = True : prevPrice = price : prevRatio = ratio
                End If
            Next
            AppendNewestFirst(sb, rmCells)
            sb.Append("</tr>")
        Next

        ' --- SKU price row ---
        sb.Append("<tr class='pra-total'><td class='pra-rowhead'>SKU price (sum of ratio x price)</td>")
        Dim prevSku As Decimal? = Nothing
        Dim skuCells As New List(Of String)()
        For Each c As DataRow In cols
            Dim sku As Decimal = Convert.ToDecimal(c("sf_sku_price"))
            Dim cls As String = "pra-val" & If(prevSku.HasValue AndAlso sku > prevSku.Value, " pra-up", If(prevSku.HasValue AndAlso sku < prevSku.Value, " pra-down", ""))
            skuCells.Add("<td class='" & cls & "'><div class='pra-fig pra-fig-big'>" & sku.ToString("0.00") & "</div>" & If(prevSku.HasValue AndAlso sku <> prevSku.Value, DeltaBadge(prevSku.Value, sku), "") & "</td>")
            prevSku = sku
        Next
        AppendNewestFirst(sb, skuCells)
        sb.Append("</tr>")

        ' --- packaging rows ---
        If packOrder.Count > 0 Then
            sb.Append("<tr class='pra-section'><td class='pra-rowhead'>Packaging (total per pack)</td><td colspan='" & cols.Count & "'>material + processing + labour, margin % applied on SKU price + those</td></tr>")
            For Each ps As String In packOrder
                sb.Append("<tr><td class='pra-rowhead'>" & Server.HtmlEncode(ps) & " packaging</td>")
                Dim prevTot As Decimal? = Nothing, prevExists As Boolean = False
                Dim pkCells As New List(Of String)()
                For Each c As DataRow In cols
                    Dim p() As DataRow = packs.Select("pch_sf_id = " & Convert.ToInt32(c("sf_id")) & " AND Trim(pch_pack_size) = '" & ps.Replace("'", "''") & "'")     ' DataTable compare is case-insensitive ("1LTR" = "1ltr"); UPPER() is not a DataTable function
                    If p.Length = 0 Then
                        pkCells.Add("<td class='pra-gone'>" & If(prevExists, "<span class='pra-delta pra-d-gone'>REMOVED</span>", "&mdash;") & "</td>")
                        prevExists = False : prevTot = Nothing
                    Else
                        Dim tot As Decimal = Convert.ToDecimal(p(0)("pch_total"))
                        Dim tip As String = "material " & Convert.ToDecimal(p(0)("pch_material_amt")).ToString("0.00") & ", processing " & Convert.ToDecimal(p(0)("pch_processing_fee")).ToString("0.00") &
                                            ", labour " & Convert.ToDecimal(p(0)("pch_labour_charge")).ToString("0.00") & ", margin " & Convert.ToDecimal(p(0)("pch_margin_pct")).ToString("0.##") & "% = " & Convert.ToDecimal(p(0)("pch_margin_amt")).ToString("0.00")
                        Dim cls As String = "pra-val"
                        Dim badge As String = ""
                        If Not prevExists Then
                            If cols.IndexOf(c) > 0 Then cls &= " pra-new" : badge = "<span class='pra-delta pra-d-new'>NEW</span>"
                        ElseIf prevTot.HasValue AndAlso tot > prevTot.Value Then
                            cls &= " pra-up" : badge = DeltaBadge(prevTot.Value, tot)
                        ElseIf prevTot.HasValue AndAlso tot < prevTot.Value Then
                            cls &= " pra-down" : badge = DeltaBadge(prevTot.Value, tot)
                        End If
                        pkCells.Add("<td class='" & cls & "' title='" & Server.HtmlEncode(tip) & "'><div class='pra-fig'>" & tot.ToString("0.00") & "</div>" & badge & "<div class='pra-sub'>" & Server.HtmlEncode(tip) & "</div></td>")
                        prevExists = True : prevTot = tot
                    End If
                Next
                AppendNewestFirst(sb, pkCells)
                sb.Append("</tr>")
            Next
        End If

        ' --- remarks rows ---
        sb.Append("<tr><td class='pra-rowhead'>Vendor remarks</td>")
        Dim vrCells As New List(Of String)()
        For Each c As DataRow In cols
            vrCells.Add("<td style='white-space:normal;max-width:220px;' class='pra-small'>" & Server.HtmlEncode(Convert.ToString(c("vendor_remarks"))) & "</td>")
        Next
        AppendNewestFirst(sb, vrCells)
        sb.Append("</tr><tr><td class='pra-rowhead'>HO remarks / decision</td>")
        Dim hoCells As New List(Of String)()
        For Each c As DataRow In cols
            Dim dec As String = If(IsDBNull(c("sf_approved_on")), "", Convert.ToString(c("sf_approved_by")) & " " & Convert.ToDateTime(c("sf_approved_on")).ToString("dd/MM/yy HH:mm"))
            hoCells.Add("<td style='white-space:normal;max-width:220px;' class='pra-remarks'>" & Server.HtmlEncode(Convert.ToString(c("sf_ho_remarks"))) & If(dec <> "", "<br/><span class='pra-small'>" & Server.HtmlEncode(dec) & "</span>", "") & "</td>")
        Next
        AppendNewestFirst(sb, hoCells)
        sb.Append("</tr></tbody></table>")
        Return sb.ToString()
    End Function

    ''' <summary>Modified-by MUKESH BHAGAT 22-10-2026: the comparison is shown NEWEST revision first. Every row is computed oldest to
    ''' newest (so each change badge compares a revision with the one submitted just before it) and its cells are then written in
    ''' reverse, which puts the latest revision in the first column and the older ones to its right.</summary>
    Private Shared Sub AppendNewestFirst(ByVal sb As StringBuilder, ByVal cells As List(Of String))
        For i As Integer = cells.Count - 1 To 0 Step -1
            sb.Append(cells(i))
        Next
    End Sub


    Protected Sub gvHistory_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If Convert.ToString(DataBinder.Eval(e.Row.DataItem, "sf_is_active")) = "Y" Then e.Row.CssClass = "tlrowlight pra-row-active"
        End If
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Product_Rate_Approval_List.aspx")
    End Sub
End Class
