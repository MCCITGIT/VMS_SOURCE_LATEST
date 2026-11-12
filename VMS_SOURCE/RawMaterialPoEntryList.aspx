<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialPoEntryList.aspx.vb" Inherits="RawMaterialPoEntryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material PO Entry List</h3>
                    <p class="pageSubTitle">Manage Raw Material Requests</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Supplier:<span id="spanVendor" class="mandatory p-vendor-select">*</span></label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                            <asp:HiddenField ID="hdnRmVendor" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
                    <div class="col-md-4 form-btn-mt">
                        <asp:LinkButton ID="lbBtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" ToolTip="Search" OnClick="lbBtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton ID="lbBtnAdd" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" ToolTip="Add" OnClick="lbBtnAdd_Click">Add</asp:LinkButton>
                    </div>
                    <%--<div class="col-md-2">
                                <div class="mt-3">
                                    <asp:LinkButton ID="lbBtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add" OnClick="lbBtnAdd_Click"><i class="fas fa-plus"></i></asp:LinkButton>
                                </div>
                            </div>--%>
                </div>
            </div>
        </div>

        <div class="card rm-list-fill" runat="server" id="tr1">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Supplier List</h5>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll pol-grid-scroll">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:HiddenField ID="hdnPolHasData" runat="server" Value="0" />
                            <asp:HiddenField ID="hdnPolPageSize" runat="server" Value="10" />
                            <asp:HiddenField ID="hdnPolVendor" runat="server" />
                            <asp:GridView ID="gvPoList" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found"
                                AllowPaging="false" PageSize="10">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Srl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrl" runat="server" Text='<%# (gvPoList.PageIndex * gvPoList.PageSize) + Container.DataItemIndex + 1 %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PO No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPoNo" runat="server" Text='<%# HttpUtility.HtmlEncode(Convert.ToString(Eval("display_po_no"))) %>' />
                                            <%--<asp:HiddenField ID="hdnPoId" runat="server" Value='<%# Eval("rmph_id") %>' />--%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Supplier">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendor" runat="server" Text='<%# Eval("vendor_name") %>' />
                                            <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Eval("vendor_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Left" Width="14%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Supplier Code">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorCode" runat="server" Text='<%# Eval("vendor_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Product">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProduct" runat="server" Text='<%# Eval("product_name") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Left" Width="16%" />
                                    </asp:TemplateField>--%>
                                    <%--<asp:TemplateField HeaderText="Product NAme">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("product_name") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:Label ID="lblQty" runat="server" Text='<%# Eval("qty", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Rate">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("rate", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Right" Width="8%" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Amount">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("amount", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <a href='<%# "RawMaterialPoPdf.aspx?po=" & Eval("po_no") %>' target="_blank" class="rm-btn-icon text-primary" title="Preview PDF">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <style type="text/css">
        .pol-grid-scroll,
        .pol-grid-scroll table,
        .pol-grid-scroll tr,
        .pol-grid-scroll td {
            overflow-anchor: none;
        }

        .pol-grid-scroll {
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvPoList.ClientID %>';
            var pageIndex = 0, pageSize = 10, total = 0, loading = false, noMore = false, seq = 0;
            var vendor = '';
            var align = ['center', 'center', 'left', 'center', 'center', 'center', 'center'];

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.pol-skel'); }
            function scrollBox() { return $(gridSel).closest('.pol-grid-scroll'); }
            function capture() {
                vendor = $('#<%= hdnPolVendor.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnPolPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 10;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70px', '70%', '60px', '48px', '60px', '16px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:' + align[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight pol-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                var $grid = $(gridSel);
                var $body = $grid.children('tbody');
                if (!$body.length) $body = $grid.find('tbody').first();
                if ($body.length) $body.append($rows);
                else $grid.append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnPolHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreRawMaterialPos !== 'function') {
                    $(gridSel + ' tr.pol-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreRawMaterialPos(pageIndex, pageSize, vendor, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.pol-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var pdf = '<a href="RawMaterialPoPdf.aspx?po=' + encodeURIComponent(r.pdfPo || '') + '" target="_blank" class="rm-btn-icon text-primary" title="Preview PDF"><i class="fas fa-file-pdf"></i></a>';
                        var vals = [esc(r.serial), esc(r.poNo), esc(r.vendorName), esc(r.vendorCode), esc(r.qty), esc(r.amount), pdf];
                        html += '<tr class="tlrowlight">';
                        for (var c = 0; c < vals.length; c++) html += '<td style="text-align:' + align[c] + '">' + vals[c] + '</td>';
                        html += '</tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.pol-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                });
            }
            function scrolledNear() {
                var box = scrollBox()[0];
                if (!box) return false;
                if (box.scrollHeight > box.clientHeight + 2) return box.scrollTop + box.clientHeight >= box.scrollHeight - 50;
                var rect = box.getBoundingClientRect();
                return rect.bottom <= window.innerHeight + 50;
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                $(gridSel + ' tr.pol-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            if (!window.__polScroll) {
                window.__polScroll = true;
                document.addEventListener('scroll', function (e) {
                    var box = scrollBox()[0];
                    if (!box) return;
                    var t = e.target;
                    if (t !== box && t !== document && t !== document.documentElement && t !== document.body && !(t.contains && (t.contains(box) || box.contains(t)))) return;
                    if (scrolledNear()) loadNext();
                }, true);
            }
            if (window.Sys && Sys.Application) Sys.Application.add_load(bind);
            else $(bind);
        })();
    </script>
</asp:Content>

