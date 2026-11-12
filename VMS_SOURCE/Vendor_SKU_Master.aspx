<%@ Page Title="Vendor SKU Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_SKU_Master.aspx.vb" Inherits="Vendor_SKU_Master" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>


    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }

            if (event.keyCode == 118) {  // button Add (F7 keypress)
                //	        __doPostBack(document.getElementById('imgbtnAdd').name, '');
                document.getElementById('imgbtnAdd').click()
            }
        }
        //-->
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor SKU LIST</h3>
                <p class="pageSubTitle">Browse and manage vendor SKUs</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Source:</label>
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">SKU Code:</label>
                        <asp:TextBox ID="txtSkuCode" runat="server" CssClass="form-control" text-align="center"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton ID="imgbtnAdd" PostBackUrl="~/Vendor_SKU_AddUpdate.aspx" runat="server" CssClass="btn btn-success btn-sm" OnClick="imgbtnAdd_Click">Add</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">User Login History Details</h5>
                        <p class="mst-panel-subtitle">Login activity for the selected user</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="align-items: center; display:none;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvVendorSKUList" runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid" AllowPaging="false" EmptyDataText="No Record Found." DataKeyNames="v_sku_code">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        <%--<asp:HiddenField ID="hdnDepot" runat="server" 
                                                     Value='<%# Bind("v__depot") %>' />--%>

                                        <asp:HiddenField ID="hdnvendor_unit" runat="server"
                                            Value='<%# Bind("v_vendor_unit") %>' />

                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="SKU" DataField="v_sku_code">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>
                                <%--<asp:BoundField HeaderText="Description" DataField="SkuDescription"><HeaderStyle HorizontalAlign="Center"/><ItemStyle HorizontalAlign="Center" Width="15%"/></asp:BoundField>--%>
                                <asp:ButtonField CommandName="Update" HeaderText="Description" ShowHeader="True"
                                    DataTextField="SkuDescription">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle Font-Underline="false" ForeColor="Blue" Width="20%" HorizontalAlign="Center" />
                                </asp:ButtonField>
                                <asp:BoundField HeaderText="Applicable Depots" DataField="ApplicableDepot">
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger
                            ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" runat="server" Font-Size="10px" Font-Bold="true"></asp:Label>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var pageIndex = 0;
            var loading = false;
            var noMoreData = false;
            var suppressScrollUntil = 0;
            var gridSel = '#<%= gvVendorSKUList.ClientID %>';
            var filters = { vendor: '', sku: '', pageSize: 15 };

            function captureFilters() {
                filters.vendor = $('#<%= ddlVendor.ClientID %>').val() || '';
                filters.sku = $('#<%= txtSkuCode.ClientID %>').val() || '';
                filters.pageSize = parseInt($('#<%= ddlPageSize.ClientID %>').val(), 10) || 15;
            }

            function dataRows() {
                return $(gridSel + ' tbody tr').not('.sku-skel').not('.headerGrid').not('.PagerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function loadNext($el) {
                if (loading || noMoreData || dataRows().length === 0) return;
                loading = true;
                pageIndex++;
                showSkuSkeleton($el);

                PageMethods.GetMoreVendorSkus(pageIndex, filters.pageSize, filters.vendor, filters.sku,
                    function (result) {
                        hideSkuSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        var $tbody = $(gridSel + ' tbody');
                        $.each(result.rows, function (i, r) {
                            appendSkuRow($tbody, r, pageIndex * filters.pageSize + i + 1);
                        });
                        if (dataRows().length >= result.total || result.rows.length < filters.pageSize) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.table-responsive');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                    },
                    function () {
                        hideSkuSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showSkuSkeleton($scroll) {
                var $tbody = $(gridSel + ' tbody');
                if (!$tbody.length || $tbody.find('tr.sku-skel').length) return;
                var widths = [
                    ['16px', '55%', '74%', '68%'],
                    ['16px', '48%', '66%', '60%'],
                    ['16px', '62%', '80%', '54%']
                ];
                var colWidths = ['5%', '10%', '20%', '20%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight sku-skel">';
                    for (var c = 0; c < colWidths.length; c++) {
                        html += '<td align="center" style="width:' + colWidths[c] + ';"><span class="grid-skel-bar" style="width:' + widths[r][c] + ';"></span></td>';
                    }
                    html += '</tr>';
                }
                $tbody.append(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideSkuSkeleton() {
                var $rows = $(gridSel + ' tbody tr.sku-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendSkuRow($tbody, r, slNo) {
                var descLink = '<a href="Vendor_SKU_AddUpdate.aspx?SKUCode=' + encodeURIComponent(r.v_sku_code || '') + '&Unit=' + encodeURIComponent(r.v_vendor_unit || '') + '" class="gridlink">' + esc(r.SkuDescription) + '</a>';
                $tbody.append(
                    '<tr class="tlrowlight">' +
                    '<td align="center" style="width:5%;">' + slNo + '</td>' +
                    '<td align="center" style="width:10%;">' + esc(r.v_sku_code) + '</td>' +
                    '<td align="center" style="width:20%;">' + descLink + '</td>' +
                    '<td align="center" style="width:20%;">' + esc(r.ApplicableDepot) + '</td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            function bindSkuScroll() {
                pageIndex = 0;
                noMoreData = false;
                loading = false;
                captureFilters();
                var $scroll = $(gridSel).closest('.table-responsive');
                $scroll.off('scroll.skuskel').on('scroll.skuskel', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($scroll.scrollTop() + $scroll.innerHeight() < $scroll[0].scrollHeight - 50) return;
                    loadNext($scroll);
                });
                if ($scroll.length && dataRows().length > 0 && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
            }

            bindSkuScroll();
            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(bindSkuScroll);
            }
        });
    </script>
</asp:Content>
