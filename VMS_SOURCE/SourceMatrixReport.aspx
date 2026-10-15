<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="SourceMatrixReport.aspx.vb" Inherits="SourceMatrixReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateSourceMatrix.js"></script>
<%--    <style type="text/css">
        #<%= gvmatrixsource.ClientID %> .grid-skel-bar {
            display: inline-block;
            height: 12px;
            max-width: 100%;
            border-radius: 3px;
            vertical-align: middle;
            background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
            background-size: 400% 100%;
            animation: matrixSkelShimmer 1.2s ease-in-out infinite;
        }

        @keyframes matrixSkelShimmer {
            0% { background-position: 100% 0; }
            100% { background-position: 0 0; }
        }
    </style>--%>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Wise Ranking Details Report</h3>
                <p class="pageSubTitle">Vendor ranking across the source matrix</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlDepot" CssClass="form-control select2" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Unit Name:</label>
                                <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Sku Code:</label>
                                <asp:TextBox runat="server" ID="txtSkucode" CssClass="form-control" AutoComplete="Off"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <div class="form-group">
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="imgbtnDownload" runat="server">Download</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" runat="server">
                <div class="card-body">
                    <div class="table-responsive" style="overflow-y: auto; max-height: calc(100vh - 295px);">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="gvmatrixsource" runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid"
                                    EmptyDataText="No records found">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Srl No" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSrl" Text='<%# Container.DataItemIndex + 1 %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="4%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Region" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblregion" Text='<%# Bind("Region") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Depot" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDepot" Text='<%# Bind("Depot")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="6%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Sku Code" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblskucode" Text='<%# Bind("SkuCode")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Sku Desc" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblsudesc" Text='<%# Bind("Sku_Desc")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Unit" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUnit" Text='<%# Bind("vendor_name")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Left" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Site" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSiteCode" Text='<%# Bind("Site_Code")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Left" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Total Rate" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotal_Rate" Text='<%# Bind("TotalRate")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Priority" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPriority" Text='<%# Bind("priority_rank")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                <asp:PostBackTrigger ControlID="gvmatrixsource" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="imgbtnDownload" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">
        $(function () {
            var pageIndex = 0;
            var loading = false;
            var noMoreData = false;
            var searched = false;
            var loadSeq = 0;
            var suppressScrollUntil = 0;
            var filters = { depot: '', vendor: '', sku: '' };
            var gridSel = '#<%= gvmatrixsource.ClientID %>';

            function captureFilters() {
                filters.depot = $('#<%= ddlDepot.ClientID %>').val() || '';
                filters.vendor = $('#<%= ddlVendorUnit.ClientID %>').val() || '';
                filters.sku = $('#<%= txtSkucode.ClientID %>').val() || '';
            }

            function dataRows() {
                return $(gridSel + ' tbody tr').not('.matrix-skel').not('.headerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function bindMatrixScroll() {
                var $el = $(gridSel).closest('.table-responsive');
                $el.off('scroll.matrixskel').on('scroll.matrixskel', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($el.scrollTop() + $el.innerHeight() < $el[0].scrollHeight - 50) return;
                    loadNext($el);
                });
            }

            function loadNext($el) {
                if (!searched || loading || noMoreData || dataRows().length === 0) return;

                loading = true;
                pageIndex++;
                var seq = ++loadSeq;
                showMatrixSkeleton($el);

                PageMethods.GetMoreSourceMatrix(pageIndex, filters.depot, filters.vendor, filters.sku,
                    function (result) {
                        if (seq !== loadSeq) return;
                        hideMatrixSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        var $tbody = $(gridSel + ' tbody');
                        $.each(result.rows, function (i, r) {
                            appendMatrixRow($tbody, r);
                        });
                        if (dataRows().length >= result.total) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.table-responsive');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) {
                            loadNext($scroll);
                        }
                    },
                    function () {
                        if (seq !== loadSeq) return;
                        hideMatrixSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showMatrixSkeleton($scroll) {
                var $tbody = $(gridSel + ' tbody');
                if (!$tbody.length || $tbody.find('tr.matrix-skel').length) return;

                var bars = [
                    ['60%', '72%', '54%'],
                    ['68%', '56%', '74%'],
                    ['70%', '58%', '80%'],
                    ['86%', '74%', '90%'],
                    ['78%', '64%', '84%'],
                    ['46%', '58%', '40%'],
                    ['52%', '40%', '60%']
                ];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight matrix-skel">';
                    html += '<td align="center" style="width:4%;"><span class="grid-skel-bar" style="width:14px;"></span></td>';
                    html += '<td align="center" style="width:8%;"><span class="grid-skel-bar" style="width:' + bars[0][r] + ';"></span></td>';
                    html += '<td align="center" style="width:6%;"><span class="grid-skel-bar" style="width:' + bars[1][r] + ';"></span></td>';
                    html += '<td align="center" style="width:10%;"><span class="grid-skel-bar" style="width:' + bars[2][r] + ';"></span></td>';
                    html += '<td align="center" style="width:10%;"><span class="grid-skel-bar" style="width:' + bars[3][r] + ';"></span></td>';
                    html += '<td align="left" style="width:10%;"><span class="grid-skel-bar" style="width:' + bars[4][r] + ';"></span></td>';
                    html += '<td align="left" style="width:10%;"><span class="grid-skel-bar" style="width:' + bars[5][r] + ';"></span></td>';
                    html += '<td align="right" style="width:10%;"><span class="grid-skel-bar" style="width:' + bars[6][r] + ';"></span></td>';
                    html += '<td align="center" style="width:10%;"><span class="grid-skel-bar" style="width:14px;"></span></td>';
                    html += '</tr>';
                }
                $tbody.append(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideMatrixSkeleton() {
                var $rows = $(gridSel + ' tbody tr.matrix-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendMatrixRow($tbody, r) {
                var slNo = dataRows().length + 1;
                $tbody.append(
                    '<tr class="tlrowlight">' +
                    '<td align="center" style="width:4%;">' + slNo + '</td>' +
                    '<td align="center" style="width:8%;">' + esc(r.Region) + '</td>' +
                    '<td align="center" style="width:6%;">' + esc(r.Depot) + '</td>' +
                    '<td align="center" style="width:10%;">' + esc(r.SkuCode) + '</td>' +
                    '<td align="center" style="width:10%;">' + esc(r.Sku_Desc) + '</td>' +
                    '<td align="left" style="width:10%;">' + esc(r.vendor_name) + '</td>' +
                    '<td align="left" style="width:10%;">' + esc(r.Site_Code) + '</td>' +
                    '<td align="right" style="width:10%;">' + esc(r.TotalRate) + '</td>' +
                    '<td align="center" style="width:10%;">' + esc(r.priority_rank) + '</td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            $(document).on('click', '#<%= imgbtnSearch.ClientID %>', function () {
                loadSeq++;
                pageIndex = 0;
                noMoreData = false;
                loading = false;
                searched = true;
                captureFilters();
            });

            bindMatrixScroll();
            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    loadSeq++;
                    pageIndex = 0;
                    noMoreData = false;
                    loading = false;
                    bindMatrixScroll();
                    if (searched) {
                        var $scroll = $(gridSel).closest('.table-responsive');
                        if ($scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                    }
                });
            }
        });
    </script>

</asp:Content>

