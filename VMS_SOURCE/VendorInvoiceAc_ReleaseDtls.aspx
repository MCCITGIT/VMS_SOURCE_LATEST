<%@ Page Title="Vendor Invoice Account Release Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorInvoiceAc_ReleaseDtls.aspx.vb" Inherits="VendorInvoiceAc_ReleaseDtls" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">var cal1 = new CalendarPopup();</script>
    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
    <style>
        .vendor-name-column {
            min-width: 150px;
        }
    </style>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Invoice Account Release Details</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddldepot" runat="server" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2" TabIndex="2">
                            <asp:ListItem Text="Select" Value="" />
                            <asp:ListItem Text="Paid" Value="Paid" />
                            <asp:ListItem Text="Due" Value="Due" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Type:</label>
                        <asp:DropDownList ID="ddltype" runat="server" CssClass="form-control select2" TabIndex="2">
                            <asp:ListItem Text="Select" Value="" />
                            <asp:ListItem Text="Depot Despatch" Value="Depot Despatch" />
                            <asp:ListItem Text="Direct Despatch" Value="Direct Despatch" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">From Date:</label>
                        <asp:TextBox ID="txtFromDate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                        <%--<a href="javascript:cal1.select(document.forms[0].txtFromDate,'FromDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="FromDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy" />
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">To Date:</label>
                        <asp:TextBox ID="txtTodate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                        <%-- <a href="javascript:cal1.select(document.forms[0].txtTodate,'ToDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="ToDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTodate" Format="dd/MM/yyyy" />
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" ImageUrl="images/ic_search.gif" ToolTip="Search" AlternateText="Search" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click" ToolTip="Search" Text="Search"></asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-success btn-sm" ID="btndownload" runat="server" OnClick="btndownload_Click" Text="Download" ToolTip="Download" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">PO Linking Request List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:HiddenField ID="hdnVirHasData" runat="server" Value="0" />
            <asp:HiddenField ID="hdnVirPageSize" runat="server" Value="10" />
            <asp:HiddenField ID="hdnVirVendor" runat="server" />
            <asp:HiddenField ID="hdnVirStatus" runat="server" />
            <asp:HiddenField ID="hdnVirFrom" runat="server" />
            <asp:HiddenField ID="hdnVirTo" runat="server" />
            <asp:HiddenField ID="hdnVirDepot" runat="server" />
            <asp:HiddenField ID="hdnVirType" runat="server" />
            <div class="table-responsive vir-grid-scroll">
                <asp:GridView ID="gvVendorInvoiceDtls" runat="server" AutoGenerateColumns="false" AllowPaging="False" OnRowDataBound="gvVendorInvoiceDtls_RowDataBound" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>--%>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Type" DataField="Type">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>
                        <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Vendor Name" DataField="vendor_unit_name">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" CssClass="vendor-name-column" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>--%>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Depot" DataField="depot_name">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Despatched Date" DataField="InvoiceUploadDate">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Invoice No" DataField="Invoice_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Invoice Date" DataField="Invoice_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Invoice Value" DataField="Invoice_Value">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Release No" DataField="Release_No" ControlStyle-Width="6%">
                            <ControlStyle Width="10%"></ControlStyle>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Release Date" DataField="Release_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="GRN No" DataField="GRN_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="GRN Date" DataField="GRN_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Voucher No" DataField="Voucher_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Amount Paid" DataField="Payment_Status">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Amount Due" DataField="PendingAmount">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div id="divErrorMessage"></div>
        </div>
    </div>

    <style type="text/css">
        .vir-grid-scroll,
        .vir-grid-scroll table,
        .vir-grid-scroll tr,
        .vir-grid-scroll td {
            overflow-anchor: none;
        }

        .vir-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvVendorInvoiceDtls.ClientID %>';
            var pageIndex = 0, pageSize = 10, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { vendor: '', status: '', from: '', to: '', depot: '', type: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.vir-skel'); }
            function scrollBox() { return $(gridSel).closest('.vir-grid-scroll'); }
            function capture() {
                filters.vendor = $('#<%= hdnVirVendor.ClientID %>').val() || '';
                filters.status = $('#<%= hdnVirStatus.ClientID %>').val() || '';
                filters.from = $('#<%= hdnVirFrom.ClientID %>').val() || '';
                filters.to = $('#<%= hdnVirTo.ClientID %>').val() || '';
                filters.depot = $('#<%= hdnVirDepot.ClientID %>').val() || '';
                filters.type = $('#<%= hdnVirType.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnVirPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 10;
                total = 0;
            }
            function skel() {
                var widths = ['50px', '70%', '72px', '60px', '72px', '50px', '50px', '72px', '50px', '72px', '50px', '50px', '50px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight vir-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnVirHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreVendorInvoices !== 'function') {
                    $(gridSel + ' tr.vir-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreVendorInvoices(pageIndex, pageSize, filters.vendor, filters.status, filters.from, filters.to, filters.depot, filters.type, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.vir-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var vals = [r.type, r.depot, r.despatchDate, r.invoiceNo, r.invoiceDate, r.invoiceValue, r.releaseNo, r.releaseDate, r.grnNo, r.grnDate, r.voucherNo, r.amountPaid, r.amountDue];
                        html += '<tr class="tlrowlight"' + (r.missingDespatch ? ' style="background-color:#FFFF00"' : '') + '>';
                        for (var c = 0; c < vals.length; c++) html += '<td style="text-align:center">' + esc(vals[c]) + '</td>';
                        html += '</tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.vir-skel').remove();
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
                $(gridSel + ' tr.vir-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            if (!window.__virScroll) {
                window.__virScroll = true;
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
