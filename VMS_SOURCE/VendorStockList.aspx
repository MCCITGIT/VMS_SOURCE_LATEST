<%@ Page Title="Brand Test Linking" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorStockList.aspx.vb" Inherits="VendorStockList" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="Scripts/ValidateVendorUnitMaster.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {  // button Add (F7 keypress)	    		    
                __doPostBack(document.getElementById('ImgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)

                __doPostBack(document.getElementById('ImgbtnSearch').name, '');
            }
        }
        //-->
    </script>
    <script type="text/javascript">var cal1 = new CalendarPopup(); function scheme_effective_date_onclick() { }</script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Brand Test Linking</h3>
                <p class="pageSubTitle">Browse vendor stock positions</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server" AutoPostBack="true"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Batch From Date:</label>
                                <asp:TextBox ID="txtAsOndate" runat="server" CssClass="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">To Date:</label>
                                <asp:TextBox ID="txtAsOndateTo" runat="server" CssClass="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4 form-btn-mt">
                            <asp:Button ID="ImgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                            <asp:Button ID="imgbtnExport" runat="server" Text="Export" CssClass="btn btn-info btn-sm" />
                            <asp:Button ID="ImgbtnAdd" PostBackUrl="~/VendorStockEntry.aspx" runat="server" Text="Add" CssClass="btn btn-success btn-sm" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <asp:HiddenField ID="hdnVstHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnVstPageSize" runat="server" Value="20" />
                    <asp:HiddenField ID="hdnVstVendor" runat="server" />
                    <asp:HiddenField ID="hdnVstFrom" runat="server" />
                    <asp:HiddenField ID="hdnVstTo" runat="server" />
                    <div class="table-responsive vst-grid-scroll">
                        <asp:GridView ID="gvVendorStockDetails" runat="server" AutoGenerateColumns="false" AllowPaging="false" PageSize="20"
                            Visible="true" ShowFooter="false" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Sl.No." HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblbrandid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="60%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="60%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="As On Date" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDate" runat="server" Text='<%# Bind("ason_date") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Volume" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVolume" runat="server" Text='<%# Bind("volume") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                    <ItemTemplate>
                                        <asp:UpdatePanel ID="upnlBtn" runat="server">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="btnExport" CommandName="EditRow" Visible="true" runat="server" Text="Export" title="Export" ToolTip="Click To Export" CommandArgument='<%# Bind("vendor_code")%>'></asp:LinkButton>

                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="btnExport" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="card" id="Div_Vendor_Stock_List_Grid" runat="server" visible="false">
                <div class="card-body">
                    <table border="1" class="table table-hover upgradDataGrid">
                        <tr class="headerGrid">
                            <th style="width: 5%; text-align: center;">Sl.No.</th>
                            <th style="width: 60%; text-align: center;">Vendor Name</th>
                            <th style="width: 15%; text-align: center;">As On Date</th>
                            <th style="width: 10%; text-align: center;">Volume</th>
                            <th style="width: 10%; text-align: center;">Action</th>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-weight: bold;" colspan="5">No Records Found</td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <style type="text/css">
        .vst-grid-scroll,
        .vst-grid-scroll table,
        .vst-grid-scroll tr,
        .vst-grid-scroll td {
            overflow-anchor: none;
        }
        .vst-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvVendorStockDetails.ClientID %>';
            var pageIndex = 0, pageSize = 20, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { vendor: '', from: '', to: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.vst-skel'); }
            function scrollBox() { return $(gridSel).closest('.vst-grid-scroll'); }
            function capture() {
                filters.vendor = $('#<%= hdnVstVendor.ClientID %>').val() || '';
                filters.from = $('#<%= hdnVstFrom.ClientID %>').val() || '';
                filters.to = $('#<%= hdnVstTo.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnVstPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 20;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '80px', '50px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight vst-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnVstHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreVendorStock !== 'function') {
                    $(gridSel + ' tr.vst-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreVendorStock(pageIndex, pageSize, filters.vendor, filters.from, filters.to, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.vst-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        html += '<tr class="tlrowlight">'
                            + '<td style="text-align:center">' + esc(r.serial) + '</td>'
                            + '<td style="text-align:center">' + esc(r.vendor) + '</td>'
                            + '<td style="text-align:center">' + esc(r.asOnDate) + '</td>'
                            + '<td style="text-align:center">' + esc(r.volume) + '</td></tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.vst-skel').remove();
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
                $(gridSel + ' tr.vst-skel').remove();
                capture();
                setTimeout(function () {
                    if (scrolledNear()) loadNext();
                }, 0);
            }
            if (!window.__vstStockScroll) {
                window.__vstStockScroll = true;
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
