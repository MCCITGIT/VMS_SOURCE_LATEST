<%@ Page Title="Load Drop List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="LoadDropList.aspx.vb" Inherits="LoadDropList" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : master page mangles IDs (ctl00_ContentPlaceHolder1_*) and the buttons are now LinkButtons (no name attribute) - use ClientID and .click() so F7/F8 hotkeys work --%>
            if (event.keyCode == 118) {  // button Add (F7 keypress)
                document.getElementById('<%= ImgbtnAdd.ClientID %>').click();
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)

                document.getElementById('<%= ImgbtnSearch.ClientID %>').click();
            }
        }
        //-->
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Load Drop List</h3>
                <p class="pageSubTitle">Track and approve load drop requests</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddlBranch" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">SKU Code:</label>
                        <asp:TextBox ID="txtSearchUserName" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ImageUrl="images/ic_search.gif" ID="ImgbtnSearch" runat="server" />
                        <asp:ImageButton CssClass="btn btn-success btn-sm" ImageUrl="images/ic_add.gif" ID="ImgbtnAdd" PostBackUrl="~/LoadDropAddUpdate.aspx" runat="server" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-success btn-sm" ID="ImgbtnAdd" PostBackUrl="~/LoadDropAddUpdate.aspx" runat="server">Add</asp:LinkButton>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="form-group row ddlPageSize" style="display:none;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div class="col-md-1">
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
            <asp:HiddenField ID="hdnLoadDropHasData" runat="server" Value="0" />
            <asp:HiddenField ID="hdnLoadDropPageSize" runat="server" Value="15" />
            <div class="table-responsive ld-grid-scroll">
                <asp:GridView ID="gvLoadDrop" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                    Visible="true" OnRowDataBound="gvLoadDrop_RowDataBound" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Vendor Unit" DataField="vendor_name"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Depot" DataField="depot_name"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="SKU Code" DataField="sku_code"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="SKU Description" DataField="SkuDescription"></asp:BoundField>
                    </Columns>
                </asp:GridView>
                <div id="Div_User_List_Grid" runat="server" visible="false">
                    <table border="1" class="table table-hover upgradDataGrid">
                        <tr class="headerGrid">
                            <th style="text-align: center;">Sl.No.</th>
                            <th style="text-align: center;">Vendor Unit</th>
                            <th style="text-align: center;">Depot</th>
                            <th style="text-align: center;">SKU Code</th>
                            <th style="text-align: center;">SKU Description</th>
                        </tr>
                        <tr class="tlrowlight">
                            <td colspan="7">No Records Found</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <style type="text/css">
        .ld-grid-scroll,
        .ld-grid-scroll table,
        .ld-grid-scroll tr,
        .ld-grid-scroll td {
            overflow-anchor: none;
        }
        .ld-grid-scroll {
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvLoadDrop.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { depot: '', sku: '', vendor: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.ld-skel'); }
            function scrollBox() { return $(gridSel).closest('.ld-grid-scroll'); }
            function capture() {
                filters.depot = $('#<%= ddlBranch.ClientID %>').val() || '';
                filters.sku = $('#<%= txtSearchUserName.ClientID %>').val() || '';
                filters.vendor = $('#<%= ddlVendor.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnLoadDropPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '70%', '60px', '80%'];
                var align = ['left', 'center', 'center', 'center', 'center'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:' + align[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight ld-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnLoadDropHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                PageMethods.GetMoreLoadDrops(pageIndex, pageSize, filters.depot, filters.sku, filters.vendor, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ld-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var n = pageIndex * pageSize + i + 1;
                        html += '<tr class="tlrowlight">'
                            + '<td style="text-align:left">' + n + '</td>'
                            + '<td style="text-align:center">' + esc(r.vendorName) + '</td>'
                            + '<td style="text-align:center"><a href="' + esc(r.depotHref) + '" class="gridlink">' + esc(r.depotName) + '</a></td>'
                            + '<td style="text-align:center">' + esc(r.sku) + '</td>'
                            + '<td style="text-align:center">' + esc(r.skuDesc) + '</td></tr>';
                    }
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ld-skel').remove();
                    loading = false;
                    pageIndex--;
                });
            }
            function onScroll() {
                if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                capture();
                var box = scrollBox();
                box.off('scroll.ld').on('scroll.ld', onScroll);
                if ($('#<%= hdnLoadDropHasData.ClientID %>').val() === '1' && box.length && box[0].scrollHeight <= box[0].clientHeight + 2) loadNext();
            }
            $(bind);
        })();
    </script>
</asp:Content>
