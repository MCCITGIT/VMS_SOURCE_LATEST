<%@ Page Title="PO SKU Linking Request List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="POLinking_Request_List.aspx.vb" Inherits="POLinking_Request_List" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>
    

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
    <script type="text/javascript">
        var cal1 = new CalendarPopup(); function scheme_effective_date_onclick() { }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">PO Linking Request List</h3>
                <p class="pageSubTitle">Purchase order linking requests, with status</p>
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
                        <asp:DropDownList ID="ddlDepot" class="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" class="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" class="form-control select2" runat="server">
                            <asp:ListItem Value="N" Selected="True">Linking Pending</asp:ListItem>
                            <asp:ListItem Value="Y">Linking Done</asp:ListItem>
                            <asp:ListItem Value="R">Rejected</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2 form-btn-mt">
                    <asp:Button ID="ImgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="ImgbtnSearch_Click" />
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
            <asp:HiddenField ID="hdnPoLinkHasData" runat="server" Value="0" />
            <asp:HiddenField ID="hdnPoLinkPageSize" runat="server" Value="10" />
            <asp:HiddenField ID="hdnPoLinkAdmin" runat="server" Value="N" />
            <div class="table-responsive">
                <asp:GridView ID="gvProduct" runat="server" AutoGenerateColumns="false" AllowPaging="false" PageSize="10"
                    Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found" OnRowCommand="gvProduct_RowCommand" OnRowDataBound="gvProduct_RowDataBound">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="Srl No." HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnHdrID" Value='<%# Bind("airh_hdr_id") %>' />
                                <asp:HiddenField runat="server" ID="hdnIsReject" Value='<%# Bind("airh_reject_request") %>' />
                                <asp:HiddenField runat="server" ID="hdnIsLinked" Value='<%# Bind("isLinked") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Depot" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lbldepot_name" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnDepotCode" Value='<%# Bind("airh_depot") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Vendor" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnVendorCode" Value='<%# Bind("airh_vendor") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="PO Number" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblPONumber" runat="server" Text='<%# Bind("aird_po_no") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="SKU" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSKU" runat="server" Text='<%# Bind("sku_code") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Site ID" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSiteID" runat="server" Text='<%# Bind("site_name") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Request Date" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblReqDate" runat="server" Text='<%# Bind("req_date") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Resend Mail" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="lbtnMail" Text="" CommandName="SendMail" ToolTip="Send Mail" Style="font-size: 14px"><i class="fa fa-envelope"></i></asp:LinkButton>
                                <asp:Label runat="server" ID="lblcheck" CssClass="text-success" Visible="false"><i class="fa fa-check" aria-hidden="true"></i></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblReject" CssClass="text-secondary" Visible="false">Rejected</asp:Label>
                                <asp:LinkButton runat="server" ID="lbtnReject" CommandName="Reject" ToolTip="Reject" CssClass="text-danger" Style="font-size: 14px" OnClientClick="return confirm('Are you Sure to Reject this PO Linking Request?')"><i class="fa fa-times-circle fa-1x"></i></asp:LinkButton>
                                <%--<asp:Button runat="server" ID="btnReject" Text="Reject" CommandName="Reject" CssClass="oldBtn-danger" />--%>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvProduct.ClientID %>';
            var pageIndex = 0, pageSize = 10, total = 0, loading = false, noMore = false, seq = 0, suppressUntil = 0;
            var filters = { depot: '', vendor: '', status: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.po-skel'); }
            function scrollBox() { return $(gridSel).closest('.table-responsive'); }
            function isAdmin() { return $('#<%= hdnPoLinkAdmin.ClientID %>').val() === 'Y'; }
            function capture() {
                filters.depot = $('#<%= ddlDepot.ClientID %>').val() || '';
                filters.vendor = $('#<%= ddlVendor.ClientID %>').val() || '';
                filters.status = $('#<%= ddlStatus.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnPoLinkPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 10;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '70%', '40px', '60%', '60%', '70px', '18px', '18px'];
                var cols = ['5%', '10%', '10%', '5%', '10%', '10%', '10%', '5%', '5%'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) {
                    cells += '<td style="text-align:center;width:' + cols[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                }
                return '<tr class="tlrowlight po-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnPoLinkHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && (pageIndex + 1) * pageSize >= total) { noMore = true; return; }
                if (total && dataRows().length >= total) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                var box = scrollBox();
                if (box.length && box[0].scrollHeight > box[0].clientHeight) {
                    suppressUntil = Date.now() + 200;
                    box.scrollTop(box[0].scrollHeight);
                }
                PageMethods.GetMorePoLinks(pageIndex, pageSize, filters.depot, filters.vendor, filters.status, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.po-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '', admin = isAdmin();
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var n = pageIndex * pageSize + i + 1;
                        var mailCell = '', actionCell = '';
                        if (r.linked === 'Y') {
                            mailCell = '<span class="text-success"><i class="fa fa-check" aria-hidden="true"></i></span>';
                        } else if (!r.rejected) {
                            mailCell = '<a href="javascript:void(0)" class="po-link-mail" title="Send Mail" style="font-size:14px"><i class="fa fa-envelope"></i></a>';
                        }
                        if (r.linked !== 'Y' && admin) {
                            if (r.rejected) actionCell = '<span class="text-secondary">Rejected</span>';
                            else actionCell = '<a href="javascript:void(0)" class="po-link-reject text-danger" title="Reject" style="font-size:14px"><i class="fa fa-times-circle fa-1x"></i></a>';
                        }
                        html += '<tr class="tlrowlight" data-hdr="' + esc(r.hdrId) + '" data-depot="' + esc(r.depotName) + '" data-vendor="' + esc(r.vendorName) + '" data-po="' + esc(r.poNo) + '" data-sku="' + esc(r.sku) + '" data-site="' + esc(r.site) + '" data-vendorcode="' + esc(r.vendor) + '">'
                            + '<td style="text-align:center;width:5%">' + n + '</td>'
                            + '<td style="text-align:center;width:10%">' + esc(r.depotName) + '</td>'
                            + '<td style="text-align:center;width:10%">' + esc(r.vendorName) + '</td>'
                            + '<td style="text-align:center;width:5%">' + esc(r.poNo) + '</td>'
                            + '<td style="text-align:center;width:10%">' + esc(r.sku) + '</td>'
                            + '<td style="text-align:center;width:10%">' + esc(r.site) + '</td>'
                            + '<td style="text-align:center;width:10%">' + esc(r.reqDate) + '</td>'
                            + '<td style="text-align:center;width:5%">' + mailCell + '</td>'
                            + '<td style="text-align:center;width:5%">' + actionCell + '</td></tr>';
                    }
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.po-skel').remove();
                    loading = false;
                    pageIndex--;
                });
            }
            function onScroll() {
                if (Date.now() < suppressUntil) return;
                var el = this;
                if (el.scrollTop + el.clientHeight >= el.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                capture();
                var box = scrollBox();
                box.off('scroll.poLink').on('scroll.poLink', onScroll);
                if ($('#<%= hdnPoLinkHasData.ClientID %>').val() === '1' && box.length && box[0].scrollHeight <= box[0].clientHeight + 2) loadNext();
            }
            $(document).on('click', '.po-link-mail', function (ev) {
                ev.preventDefault();
                var tr = $(this).closest('tr');
                PageMethods.SendPoLinkMailFromList(tr.attr('data-depot'), tr.attr('data-vendor'), tr.attr('data-po'), tr.attr('data-sku'), tr.attr('data-site'), tr.attr('data-vendorcode'), function (msg) {
                    if (msg) alert(msg);
                });
            });
            $(document).on('click', '.po-link-reject', function (ev) {
                ev.preventDefault();
                if (!confirm('Are you Sure to Reject this PO Linking Request?')) return;
                var tr = $(this).closest('tr');
                PageMethods.RejectPoLinkFromList(tr.attr('data-hdr'), function (msg) {
                    if (msg === 'ok') {
                        alert('Rejected Successfullty');
                        tr.find('.po-link-mail').remove();
                        tr.find('td').eq(8).html('<span class="text-secondary">Rejected</span>');
                    } else {
                        alert(msg || 'Error Occured');
                    }
                });
            });
            $(bind);
        })();
    </script>
</asp:Content>
