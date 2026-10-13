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
            ' a unit user may only see its own vendor's formulations
            If userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT AndAlso
               Not String.Equals(Convert.ToString(h("sf_vendor_code")).Trim(), Convert.ToString(userInfo.userBranchEntity).Trim(), StringComparison.OrdinalIgnoreCase) Then
                Response.Redirect("~/Home.aspx")
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
            If ds.Tables.Count >= 4 Then litMatrix.Text = BuildMatrix(ds.Tables(1), ds.Tables(2), ds.Tables(3))
        Catch ex As Exception
            lblErrorMessage.Text = ex.Message
        End Try
    End Sub

    ''' <summary>Side-by-side matrix: columns = revisions/releases oldest to newest, rows = raw materials, SKU price, packs.
    ''' A cell is coloured against the previous column: price up (red), down (green), added (yellow), removed (grey).</summary>
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
        Dim packOrder As New List(Of String)()
        For Each c As DataRow In cols
            For Each p As DataRow In packs.Select("pch_sf_id = " & Convert.ToInt32(c("sf_id")))
                Dim ps As String = Convert.ToString(p("pch_pack_size")).Trim()
                If Not packOrder.Contains(ps) Then packOrder.Add(ps)
            Next
        Next

        Dim sb As New StringBuilder()
        sb.Append("<table class='pra-matrix'><thead><tr><th class='pra-rowhead'>Raw material</th>")
        For Each c As DataRow In cols
            Dim st As String = Convert.ToString(c("sf_status")).Trim().ToUpperInvariant()
            Dim who As String = Server.HtmlEncode(Convert.ToString(c("submitted_by")))
            Dim whenTxt As String = If(IsDBNull(c("submitted_on")), "", Convert.ToDateTime(c("submitted_on")).ToString("dd/MM/yy HH:mm"))
            Dim tip As String = "Vendor remarks: " & Convert.ToString(c("vendor_remarks")) & vbLf & "HO remarks: " & Convert.ToString(c("sf_ho_remarks")) &
                                If(IsDBNull(c("sf_approved_on")), "", vbLf & "Decided by " & Convert.ToString(c("sf_approved_by")) & " on " & Convert.ToDateTime(c("sf_approved_on")).ToString("dd/MM/yy HH:mm"))
            Dim cls As String = "pra-col-" & st.ToLowerInvariant()
            If st = "APPROVED" AndAlso Convert.ToString(c("sf_is_active")) = "Y" Then cls = "pra-col-active"
            sb.Append("<th class='" & cls & "' title='" & Server.HtmlEncode(tip) & "'>")
            sb.Append("<a href='Product_Formulation.aspx?id=" & Convert.ToInt32(c("sf_id")) & "' style='color:#fff;text-decoration:underline;'>" & Server.HtmlEncode(Convert.ToString(c("version_text"))) & "</a>")
            sb.Append("<span class='pra-hdr-sub'>" & st.Replace("_", " ") & If(st = "APPROVED" AndAlso Convert.ToString(c("sf_is_active")) = "Y", " (in force)", "") & "</span>")
            sb.Append("<span class='pra-hdr-sub'>" & who & " " & whenTxt & "</span></th>")
        Next
        sb.Append("</tr></thead><tbody>")

        ' --- raw material rows ---
        For Each code As String In rmOrder
            sb.Append("<tr><td class='pra-rowhead'>" & Server.HtmlEncode(rmName(code)) & "<br/><span class='pra-small'>" & Server.HtmlEncode(code) & "</span></td>")
            Dim prevPrice As Decimal? = Nothing, prevExists As Boolean = False
            For Each c As DataRow In cols
                Dim d() As DataRow = dtl.Select("sfd_hdr_id = " & Convert.ToInt32(c("sf_id")) & " AND sfd_rawmat_code = '" & code.Replace("'", "''") & "'")
                If d.Length = 0 Then
                    sb.Append("<td class='pra-gone'>" & If(prevExists, "removed", "&mdash;") & "</td>")
                    prevExists = False : prevPrice = Nothing
                Else
                    Dim ratio As Decimal = Convert.ToDecimal(d(0)("sfd_ratio")), price As Decimal = Convert.ToDecimal(d(0)("sfd_price")), amt As Decimal = Convert.ToDecimal(d(0)("sfd_amount"))
                    Dim cls As String = "pra-val"
                    If Not prevExists Then
                        If cols.IndexOf(c) > 0 Then cls &= " pra-new"
                    ElseIf prevPrice.HasValue AndAlso price > prevPrice.Value Then
                        cls &= " pra-up"
                    ElseIf prevPrice.HasValue AndAlso price < prevPrice.Value Then
                        cls &= " pra-down"
                    End If
                    sb.Append("<td class='" & cls & "'>" & ratio.ToString("0.##") & "% @ " & price.ToString("0.00") & "<br/><span class='pra-small'>= " & amt.ToString("0.00") & "</span></td>")
                    prevExists = True : prevPrice = price
                End If
            Next
            sb.Append("</tr>")
        Next

        ' --- SKU price row ---
        sb.Append("<tr class='pra-total'><td class='pra-rowhead'>SKU price (sum of ratio x price)</td>")
        Dim prevSku As Decimal? = Nothing
        For Each c As DataRow In cols
            Dim sku As Decimal = Convert.ToDecimal(c("sf_sku_price"))
            Dim cls As String = "pra-val" & If(prevSku.HasValue AndAlso sku > prevSku.Value, " pra-up", If(prevSku.HasValue AndAlso sku < prevSku.Value, " pra-down", ""))
            sb.Append("<td class='" & cls & "'>" & sku.ToString("0.00") & "</td>")
            prevSku = sku
        Next
        sb.Append("</tr>")

        ' --- packaging rows ---
        If packOrder.Count > 0 Then
            sb.Append("<tr class='pra-section'><td class='pra-rowhead'>Packaging (total per pack)</td><td colspan='" & cols.Count & "'>material + processing + labour, margin % applied on SKU price + those</td></tr>")
            For Each ps As String In packOrder
                sb.Append("<tr><td class='pra-rowhead'>" & Server.HtmlEncode(ps) & " packaging</td>")
                Dim prevTot As Decimal? = Nothing, prevExists As Boolean = False
                For Each c As DataRow In cols
                    Dim p() As DataRow = packs.Select("pch_sf_id = " & Convert.ToInt32(c("sf_id")) & " AND pch_pack_size = '" & ps.Replace("'", "''") & "'")
                    If p.Length = 0 Then
                        sb.Append("<td class='pra-gone'>" & If(prevExists, "removed", "&mdash;") & "</td>")
                        prevExists = False : prevTot = Nothing
                    Else
                        Dim tot As Decimal = Convert.ToDecimal(p(0)("pch_total"))
                        Dim tip As String = "material " & Convert.ToDecimal(p(0)("pch_material_amt")).ToString("0.00") & ", processing " & Convert.ToDecimal(p(0)("pch_processing_fee")).ToString("0.00") &
                                            ", labour " & Convert.ToDecimal(p(0)("pch_labour_charge")).ToString("0.00") & ", margin " & Convert.ToDecimal(p(0)("pch_margin_pct")).ToString("0.##") & "% = " & Convert.ToDecimal(p(0)("pch_margin_amt")).ToString("0.00")
                        Dim cls As String = "pra-val"
                        If Not prevExists Then
                            If cols.IndexOf(c) > 0 Then cls &= " pra-new"
                        ElseIf prevTot.HasValue AndAlso tot > prevTot.Value Then
                            cls &= " pra-up"
                        ElseIf prevTot.HasValue AndAlso tot < prevTot.Value Then
                            cls &= " pra-down"
                        End If
                        sb.Append("<td class='" & cls & "' title='" & Server.HtmlEncode(tip) & "'>" & tot.ToString("0.00") & "<br/><span class='pra-small'>" & Server.HtmlEncode(tip) & "</span></td>")
                        prevExists = True : prevTot = tot
                    End If
                Next
                sb.Append("</tr>")
            Next
        End If

        ' --- remarks rows ---
        sb.Append("<tr><td class='pra-rowhead'>Vendor remarks</td>")
        For Each c As DataRow In cols
            sb.Append("<td style='white-space:normal;max-width:220px;' class='pra-small'>" & Server.HtmlEncode(Convert.ToString(c("vendor_remarks"))) & "</td>")
        Next
        sb.Append("</tr><tr><td class='pra-rowhead'>HO remarks / decision</td>")
        For Each c As DataRow In cols
            Dim dec As String = If(IsDBNull(c("sf_approved_on")), "", Convert.ToString(c("sf_approved_by")) & " " & Convert.ToDateTime(c("sf_approved_on")).ToString("dd/MM/yy HH:mm"))
            sb.Append("<td style='white-space:normal;max-width:220px;' class='pra-remarks'>" & Server.HtmlEncode(Convert.ToString(c("sf_ho_remarks"))) & If(dec <> "", "<br/><span class='pra-small'>" & Server.HtmlEncode(dec) & "</span>", "") & "</td>")
        Next
        sb.Append("</tr></tbody></table>")
        Return sb.ToString()
    End Function

    Protected Sub gvHistory_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If Convert.ToString(DataBinder.Eval(e.Row.DataItem, "sf_is_active")) = "Y" Then e.Row.CssClass = "tlrowlight pra-row-active"
        End If
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Product_Rate_Approval_List.aspx")
    End Sub
End Class
