<%@ Page Title="FACTORY TOKEN REQUISITION LIST" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TokenRequestList_Factory.aspx.vb" Inherits="TokenRequestList_Factory" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationIndentList_HO.js"></script>

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
                <h3 class="pageTitle">FACTORY TOKEN REQUISITION LIST</h3>
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
                        <label class="form-control-label">Factory:<span id="Span1" class="mandatory">*</span></label>
                        <asp:DropDownList ID="ddlFactory" CssClass="form-control select2" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" runat="server" CssClass="form-control select2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                            <asp:ListItem Value="">Select</asp:ListItem>
                            <asp:ListItem Value="Y">Generated</asp:ListItem>
                            <asp:ListItem Value="N">Not Generated</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
                        <asp:LinkButton ID="imgbtnAdd" runat="server" CssClass="btn btn-warning btn-sm">Add</asp:LinkButton>

                        <%--<asp:ImageButton ImageUrl="images/p-search.png" ID="imgbtnSearch" runat="server" class="btn btn-primary btn-sm py-2" />
                        <asp:ImageButton ImageUrl="~/images/p-plus.png" ID="imgbtnAdd" runat="server" class="btn btn-warning btn-sm py-2" />--%>
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
                    <h5 class="mst-panel-title">FACTORY TOKEN REQUISITION LIST</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hdnFactoryTokHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnFactoryTokPageSize" runat="server" Value="20" />
                    <asp:HiddenField ID="hdnFactoryTokFactory" runat="server" />
                    <asp:HiddenField ID="hdnFactoryTokVendor" runat="server" />
                    <asp:HiddenField ID="hdnFactoryTokStatus" runat="server" />
                    <div class="table-responsive ftr-grid-scroll">
                        <asp:GridView ID="gvTokenRequisitionList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="false" PageSize="20" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="#">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Factory">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFactory" runat="server" Text='<%# Bind("FactoryName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("VendorName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSessionId" runat="server" Text='<%# Bind("ts_session_id") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnSessionId" runat="server" Value='<%# Bind("ts_session_id") %>'></asp:HiddenField>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("TokenStatus") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Date" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequisitionDate" runat="server" Text='<%# Bind("RequisitionDate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="1%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <style type="text/css">
        .ftr-grid-scroll,
        .ftr-grid-scroll table,
        .ftr-grid-scroll tr,
        .ftr-grid-scroll td {
            overflow-anchor: none;
        }
        .ftr-grid-scroll {
            overscroll-behavior: contain;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvTokenRequisitionList.ClientID %>';
            var pageIndex = 0, pageSize = 20, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { factory: '', vendor: '', status: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.ftr-skel'); }
            function scrollBox() { return $(gridSel).closest('.ftr-grid-scroll'); }
            function capture() {
                filters.factory = $('#<%= hdnFactoryTokFactory.ClientID %>').val() || '';
                filters.vendor = $('#<%= hdnFactoryTokVendor.ClientID %>').val() || '';
                filters.status = $('#<%= hdnFactoryTokStatus.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnFactoryTokPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 20;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '70%', '50px', '70px', '80px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight ftr-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnFactoryTokHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreFactoryTokenReqs !== 'function') {
                    $(gridSel + ' tr.ftr-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreFactoryTokenReqs(pageIndex, pageSize, filters.factory, filters.vendor, filters.status, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ftr-skel').remove();
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
                            + '<td style="text-align:center">' + esc(r.factory) + '</td>'
                            + '<td style="text-align:center">' + esc(r.vendor) + '</td>'
                            + '<td style="text-align:center"><a href="TokenRequestAddUpdate_Factory.aspx?SessionId=' + esc(r.sessionId) + '">' + esc(r.sessionId) + '</a></td>'
                            + '<td style="text-align:center">' + esc(r.status) + '</td>'
                            + '<td style="text-align:center">' + esc(r.reqDate) + '</td></tr>';
                    }
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ftr-skel').remove();
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
                $(gridSel + ' tr.ftr-skel').remove();
                capture();
                var box = scrollBox();
                box.off('scroll.ftr').on('scroll.ftr', onScroll);
                setTimeout(function () {
                    var live = scrollBox();
                    if ($('#<%= hdnFactoryTokHasData.ClientID %>').val() === '1' && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
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
