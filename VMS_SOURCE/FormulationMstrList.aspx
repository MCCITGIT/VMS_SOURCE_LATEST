<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FormulationMstrList.aspx.vb" Inherits="FormulationMstrList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <script type="text/javascript">
        function onProductSelected(sender, e) {
            var value = e.get_value();
            var text = e.get_text();
            document.getElementById('<%=hdnProductCode.ClientID%>').value = value;
            document.getElementById('<%=txtProductSearch.ClientID%>').value = text + " (" + value + ")";
            sender.get_element().value = text + " (" + value + ")";
        }

        function clearProductSelection() {
            document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
        }

        function resetProductField() {
            document.getElementById('<%=txtProductSearch.ClientID%>').value = '';
            document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
        }
    </script>
    <style type="text/css">
        #<%= gvFormulationList.ClientID %> .fm-skel-bar {
            display: inline-block;
            height: 12px;
            max-width: 100%;
            border-radius: 3px;
            vertical-align: middle;
            background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
            background-size: 400% 100%;
            animation: fmSkelShimmer 1.2s ease-in-out infinite;
        }

        #<%= gvFormulationList.ClientID %> .fm-skel-box {
            display: inline-block;
            width: 14px;
            height: 14px;
            border-radius: 3px;
            vertical-align: middle;
            background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
            background-size: 400% 100%;
            animation: fmSkelShimmer 1.2s ease-in-out infinite;
        }

        @keyframes fmSkelShimmer {
            0% { background-position: 100% 0; }
            100% { background-position: 0 0; }
        }
    </style>

    <div class="rm-module rm-compact rm-formulation-list">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Product Formulation</h3>
                    <p class="pageSubTitle">Browse product formulation records</p>
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
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Brand:</label>
                                    <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3" id="colVendorFilter" runat="server">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor:<span id="Span2" class="mandatory">*</span></label>
                                    <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                    <asp:HiddenField ID="HiddenField1" runat="server" ClientIDMode="Static" />
                                </div>
                            </div>
                            <div class="col-md-2" runat="server" visible="false">
                                <div class="form-group">
                                    <label class="form-control-label">Raw Material:</label>
                                    <asp:DropDownList ID="ddlRawMat" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Show:</label>
                                    <asp:DropDownList ID="ddlView" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" runat="server">
                                        <asp:ListItem Value="ALL" Text="Everything (full history)" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="ACTIVE" Text="Active releases (in force)"></asp:ListItem>
                                        <asp:ListItem Value="NEGOTIATION" Text="Under negotiation (pending / rejected)"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Product:</label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Product" onkeyup="clearProductSelection();"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset SKU"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                    </div>
                                    <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                                    <asp:AutoCompleteExtender ID="aceProductSearch" runat="server"
                                        TargetControlID="txtProductSearch"
                                        ServiceMethod="ProductSearch"
                                        CompletionInterval="200"
                                        EnableCaching="false"
                                        CompletionSetCount="20"
                                        FirstRowSelected="true"
                                        OnClientItemSelected="onProductSelected"
                                        CompletionListCssClass="vmsAutoComplete"
                                        CompletionListItemCssClass="vmsAutoCompleteItem"
                                        CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                    </asp:AutoCompleteExtender>
                                </div>
                            </div>
                            <div class="col-md-2 form-btn-mt">
                                    <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                    <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>
                            </div>
                        </div>
                        <%--<div class="rm-stat-row">
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                <div>
                                    <p class="rm-stat-label">Total</p>
                                    <p class="rm-stat-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-green"><i class="fas fa-tags"></i></div>
                                <div>
                                    <p class="rm-stat-label">Brands</p>
                                    <p class="rm-stat-value is-green"><asp:Label ID="lblBrandCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-orange"><i class="fas fa-boxes"></i></div>
                                <div>
                                    <p class="rm-stat-label">SKUs</p>
                                    <p class="rm-stat-value is-orange"><asp:Label ID="lblSkuCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                        </div>--%>
                    </div>
                </div>

                <div class="card" runat="server" id="tr1">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Brand List</h5>
                                <p class="mst-panel-subtitle">All brands currently available for product mapping</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:HiddenField ID="hdnFormulationPage" runat="server" ClientIDMode="Static" />
                                    <asp:GridView ID="gvFormulationList" runat="server" AutoGenerateColumns="False" BorderWidth="1"
                                        CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found"
                                        AllowPaging="true" PageSize="10" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                        <RowStyle CssClass="tlrowlight" />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Srl No" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSrl" Text='<%# (gvFormulationList.PageIndex * gvFormulationList.PageSize) + Container.DataItemIndex + 1 %>' runat="server" />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Brand" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblbrand" Text='<%# Bind("Brand_Name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnbrandcode" Value='<%# Bind("Brand_Code") %>' />
                                                    <asp:HiddenField runat="server" ID="hdnid" Value='<%# Bind("fh_id") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="8%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Vendor" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblvendor" Text='<%# Bind("vendor_name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnvendorcode" Value='<%# Bind("vendor_code") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="12%" />
                                            </asp:TemplateField>
                                            <%--<asp:TemplateField HeaderText="Raw Material" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblraw" Text='<%# Bind("Raw_Mat_Name")%>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnRawCode" Value='<%# Bind("Raw_Mat_Code") %>' />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="6%" />
                                        </asp:TemplateField>--%>
                                            <asp:TemplateField HeaderText="Sku" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSku" Text='<%# Bind("Sku_Desc")%>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnSkucode" Value='<%# Bind("Sku_Code") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="15%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Release / Revision">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblVersion" Text='<%# Eval("version_text") %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="SKU Price (&#8377;)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSkuPrice" Text='<%# String.Format("{0:0.00}", Eval("sf_sku_price")) %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Right" Width="6%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Status">
                                                <ItemTemplate>
                                                    <span style='font-weight: 600; color: <%# If(Eval("sf_status").ToString() = "APPROVED", "#28a745", If(Eval("sf_status").ToString() = "REJECTED", "#dc3545", If(Eval("sf_status").ToString() = "PENDING_VENDOR", "#17a2b8", If(Eval("sf_status").ToString() = "PENDING", "#e0a800", "#6c757d")))) %>'><%# Eval("sf_status") %></span>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="7%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Packs">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPacks" Text='<%# Eval("pack_count") %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <div style="display: flex; align-items: center; justify-content: center">
                                                        <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="View" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" CssClass="text-primary"><i class="fa fa-eye"></i></asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                                <ControlStyle></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                    <asp:PostBackTrigger ControlID="gvFormulationList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        $(function () {
            var pageSize = 10;
            var pageIndex = parseInt($('#hdnFormulationPage').val(), 10) || 0;
            var loading = false;
            var noMoreData = false;
            var loadSeq = 0;
            var suppressScrollUntil = 0;
            var filters = { brand: '', vendor: '', product: '', viewMode: 'ACTIVE' };
            var gridSel = '#<%= gvFormulationList.ClientID %>';

            function captureFilters() {
                filters.brand = $('#ddlBrand').val() || '';
                filters.vendor = $('#ddlvendor').val() || '';
                filters.product = $('#hdnProductCode').val() || '';
                filters.viewMode = $('#ddlView').val() || 'ACTIVE';
            }

            function dataRows() {
                return $(gridSel + ' tr').not('.fm-skel').not('.headerGrid').not('.PagerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0 && $(this).children('td').length > 1;
                });
            }

            function placeRows(html) {
                var $pager = $(gridSel).find('tr.PagerGrid').first();
                if ($pager.length) $pager.before(html);
                else $(gridSel).find('tbody').append(html);
            }

            function bindFormulationScroll() {
                var $el = $(gridSel).closest('.rm-grid-scroll');
                $el.off('scroll.fmskel').on('scroll.fmskel', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($el.scrollTop() + $el.innerHeight() < $el[0].scrollHeight - 50) return;
                    loadNext($el);
                });
            }

            function loadNext($el) {
                if (loading || noMoreData || dataRows().length === 0) return;

                loading = true;
                pageIndex++;
                var seq = ++loadSeq;
                showFormulationSkeleton($el);

                PageMethods.GetMoreFormulations(pageIndex, filters.brand, filters.vendor, filters.product, filters.viewMode,
                    function (result) {
                        if (seq !== loadSeq) return;
                        hideFormulationSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        $.each(result.rows, function (i, r) {
                            appendFormulationRow(r, pageIndex * pageSize + i + 1);
                        });
                        if ((pageIndex + 1) * pageSize >= result.total || result.rows.length < pageSize) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.rm-grid-scroll');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) {
                            loadNext($scroll);
                        }
                    },
                    function () {
                        if (seq !== loadSeq) return;
                        hideFormulationSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showFormulationSkeleton($scroll) {
                if ($(gridSel).find('tr.fm-skel').length) return;
                var widths = ['72%', '64%', '80%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight fm-skel">';
                    html += '<td align="center" style="width:4%;"><span class="fm-skel-bar" style="width:16px;"></span></td>';
                    html += '<td align="left" style="width:8%;"><span class="fm-skel-bar" style="width:' + widths[r] + ';"></span></td>';
                    html += '<td align="left" style="width:12%;"><span class="fm-skel-bar" style="width:' + widths[(r + 1) % 3] + ';"></span></td>';
                    html += '<td align="left" style="width:15%;"><span class="fm-skel-bar" style="width:' + widths[(r + 2) % 3] + ';"></span></td>';
                    html += '<td align="center" style="width:4%;"><span class="fm-skel-bar" style="width:18px;"></span></td>';
                    html += '<td align="right" style="width:6%;"><span class="fm-skel-bar" style="width:46px;"></span></td>';
                    html += '<td align="center" style="width:7%;"><span class="fm-skel-bar" style="width:70%;"></span></td>';
                    html += '<td align="center" style="width:4%;"><span class="fm-skel-bar" style="width:16px;"></span></td>';
                    html += '<td align="center" style="width:8%;"><span class="fm-skel-box"></span></td>';
                    html += '</tr>';
                }
                placeRows(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideFormulationSkeleton() {
                var $rows = $(gridSel).find('tr.fm-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function statusColor(status) {
                if (status === 'APPROVED') return '#28a745';
                if (status === 'REJECTED') return '#dc3545';
                if (status === 'PENDING_VENDOR') return '#17a2b8';
                if (status === 'PENDING') return '#e0a800';
                return '#6c757d';
            }

            function appendFormulationRow(r, slNo) {
                placeRows(
                    '<tr class="tlrowlight">' +
                    '<td align="center" style="width:4%;">' + slNo + '</td>' +
                    '<td align="left" style="width:8%;">' + esc(r.Brand_Name) + '</td>' +
                    '<td align="left" style="width:12%;">' + esc(r.vendor_name) + '</td>' +
                    '<td align="left" style="width:15%;">' + esc(r.Sku_Desc) + '</td>' +
                    '<td align="center" style="width:4%;">' + esc(r.version_text) + '</td>' +
                    '<td align="right" style="width:6%;">' + esc(r.sf_sku_price) + '</td>' +
                    '<td align="center" style="width:7%;"><span style="font-weight:600;color:' + statusColor(r.sf_status) + ';">' + esc(r.sf_status) + '</span></td>' +
                    '<td align="center" style="width:4%;">' + esc(r.pack_count) + '</td>' +
                    '<td align="center" style="width:8%;"><div style="display:flex;align-items:center;justify-content:center"><a href="Product_Formulation.aspx?id=' + encodeURIComponent(r.fh_id || '') + '" class="text-primary" title="View"><i class="fa fa-eye"></i></a></div></td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            function resetFormulationScroll() {
                loadSeq++;
                pageIndex = parseInt($('#hdnFormulationPage').val(), 10) || 0;
                noMoreData = false;
                loading = false;
                captureFilters();
                bindFormulationScroll();
                var $scroll = $(gridSel).closest('.rm-grid-scroll');
                if ($scroll.length && dataRows().length > 0 && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
            }

            captureFilters();
            bindFormulationScroll();
            var $initial = $(gridSel).closest('.rm-grid-scroll');
            if ($initial.length && dataRows().length > 0 && $initial[0].scrollHeight <= $initial.innerHeight() + 1) loadNext($initial);

            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(resetFormulationScroll);
            }
        });
    </script>
</asp:Content>

