<%@ Page Title="Token Vendor Requisition List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UnitRequisitionReport.aspx.vb" Inherits="UnitRequisitionReport" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('imgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Token Requisition List</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Unit:</label>
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                                <asp:Label runat="server" ID="lblTokenVendor"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Product:</label>
                        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorProduct" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-2" style="display: none;">
                    <div class="form-group">
                        <label class="form-control-label">Pack Size:</label>
                        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlPackSize" Visible="false" CssClass="form-control select2" runat="server" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit"
                                    EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorProduct"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-4 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
                        <asp:LinkButton ID="imgbtnExport" runat="server" CssClass="btn btn-success btn-sm">Export To Excel</asp:LinkButton>

                        <%--<asp:ImageButton ImageUrl="images/p-search.png" ID="imgbtnSearch" title="Search" runat="server" CssClass="btn btn-primary btn-sm py-2" />
                        <asp:ImageButton ImageUrl="~/images/p-menu.png" ToolTip="Export To Excel"  title="Menu" ID="imgbtnExport" runat="server" CssClass="btn btn-success btn-sm py-2" />--%>
                    </div>
                </div>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header" style="padding-top: 0;">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Token Requisition List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hdnUnitReqHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnUnitReqPageSize" runat="server" Value="20" />
                    <asp:HiddenField ID="hdnUnitReqUnit" runat="server" />
                    <asp:HiddenField ID="hdnUnitReqProduct" runat="server" />
                    <asp:HiddenField ID="hdnUnitReqPack" runat="server" />
                    <div class="table-responsive urr-grid-scroll">
                        <asp:GridView ID="gvRequistionList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="false" PageSize="20" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Srl no." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSrl" Text='<%# Container.DataItemIndex + 1 %>' runat="server" />

                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Unit" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnit" Text='<%# Bind("unit_name") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Product" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProduct" Text='<%# Bind("requisition_prd_desc")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="12%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Pack Size" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPackSize" Text='<%# Bind("requisition_pack_size") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Initial Qty." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOpeningStock" Text='<%# Bind("tsm_opening_stock") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Received Qty." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStockIn" Text='<%# Bind("tsm_stock_in") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Despatched Qty." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStockOut" Text='<%# Bind("tsm_stock_out") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Closing Qty." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCloseQty" Text='<%# Bind("close_qty") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                    <asp:PostBackTrigger ControlID="gvRequistionList" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <style type="text/css">
        .urr-grid-scroll,
        .urr-grid-scroll table,
        .urr-grid-scroll tr,
        .urr-grid-scroll td {
            overflow-anchor: none;
        }
        .urr-grid-scroll {
            overscroll-behavior: contain;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvRequistionList.ClientID %>';
            var pageIndex = 0, pageSize = 20, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { unit: '', product: '', pack: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.urr-skel'); }
            function scrollBox() { return $(gridSel).closest('.urr-grid-scroll'); }
            function capture() {
                filters.unit = $('#<%= hdnUnitReqUnit.ClientID %>').val() || '';
                filters.product = $('#<%= hdnUnitReqProduct.ClientID %>').val() || '';
                filters.pack = $('#<%= hdnUnitReqPack.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnUnitReqPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 20;
                total = 0;
            }
            function skel() {
                var widths = ['28px', '70%', '80%', '48px', '48px', '48px', '48px', '48px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight urr-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnUnitReqHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreUnitReqReport !== 'function') {
                    $(gridSel + ' tr.urr-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreUnitReqReport(pageIndex, pageSize, filters.unit, filters.product, filters.pack, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.urr-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var n = pageIndex * pageSize + i + 1;
                        html += '<tr class="tlrowlight">'
                            + '<td style="text-align:center">' + n + '</td>'
                            + '<td style="text-align:center">' + esc(r.unit) + '</td>'
                            + '<td style="text-align:center">' + esc(r.product) + '</td>'
                            + '<td style="text-align:center">' + esc(r.pack) + '</td>'
                            + '<td style="text-align:center">' + esc(r.opening) + '</td>'
                            + '<td style="text-align:center">' + esc(r.stockIn) + '</td>'
                            + '<td style="text-align:center">' + esc(r.stockOut) + '</td>'
                            + '<td style="text-align:center">' + esc(r.closing) + '</td></tr>';
                    }
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.urr-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                });
            }
            function onScroll() {
                if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                $(gridSel + ' tr.urr-skel').remove();
                capture();
                var box = scrollBox();
                box.off('scroll.urr').on('scroll.urr', onScroll);
                setTimeout(function () {
                    var live = scrollBox();
                    if ($('#<%= hdnUnitReqHasData.ClientID %>').val() === '1' && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, 0);
            }
            $(bind);
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                    try {
                        if (args.get_error && args.get_error()) return;
                        var updated = args.get_panelsUpdated() || [];
                        for (var i = 0; i < updated.length; i++) {
                            if ($(updated[i]).find(gridSel).length) { bind(); break; }
                        }
                    } catch (e) { }
                });
            }
        })();
    </script>
</asp:Content>
