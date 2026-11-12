<%@ Page Title="Token Vendor Requisition List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TokenRequisitionList.aspx.vb" Inherits="TokenRequisitionList" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.trq-grid-scroll { overscroll-behavior: auto; }</style>
    

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
                <p class="pageSubTitle">Track token requisitions and their status</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Unit Name:</label>
                        <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                        <asp:Label runat="server" ID="lblTokenVendor"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlTokenVendor" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Requisition Id:</label>
                        <asp:DropDownList ID="ddlVendorRequisition" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server" AutoPostBack="false"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-12 text-center">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ImageUrl="images/ic_search.gif" ID="imgbtnSearch" runat="server" />
                        <asp:ImageButton CssClass="btn btn-success btn-sm" ImageUrl="~/images/ic_add.gif" ID="imgbtnAdd" runat="server" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-success btn-sm" ID="imgbtnAdd" runat="server" OnClick="imgbtnAdd_Click">Add</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive trq-grid-scroll">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnTokenReqHasData" runat="server" Value="0" />
                        <asp:HiddenField ID="hdnTokenReqPageSize" runat="server" Value="20" />
                        <asp:GridView ID="gvRequistionList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" BorderStyle="None" AllowPaging="false" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Requisition Id" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequistionId" Text='<%# Bind("trh_id") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Unit Name" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnit" Text='<%# Bind("trh_unit") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor Name" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendor" Text='<%# Bind("trh_token_vendor")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Site Name" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSiteName" Text='<%# Bind("trh_site_name") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Description" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesc" Text='<%# Bind("trh_desc") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="No. of items" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNoOfitems" Text='<%# Bind("items") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total Qty." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTotalQty" Text='<%# Bind("totalQty") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" Text='<%# Bind("trh_status") %>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action" ControlStyle-Width="100%">
                                    <HeaderTemplate>
                                        <span>View</span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="imgBtnSubmit" CommandArgument='<%# Bind("trh_id") %>' CommandName="EditRequisition" ToolTip="View" runat="server"><i class="fa fa-eye"></i></asp:LinkButton>
                                        <%--<asp:ImageButton ID="imgBtnSubmit" ImageUrl="~/images/ic_view.gif" CommandArgument='<%# Bind("trh_id") %>' CommandName="EditRequisition" Style="width: 25%" ToolTip="View" runat="server" />--%>
                                    </ItemTemplate>
                                    <ControlStyle Width="100%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action" ControlStyle-Width="100%">
                                    <HeaderTemplate>
                                        <span>Reject</span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:HiddenField runat="server" ID="hdnStatus" Value='<%# Bind("trh_status") %>' />
                                        <asp:LinkButton ID="imgBtnReject" CommandArgument='<%# Bind("trh_id") %>' CommandName="RejectRequisition" ToolTip="Reject" runat="server"><i class="fa fa-times-circle" style="color:#FF0000;"></i></asp:LinkButton>
                                        <%--<asp:ImageButton ID="imgBtnReject" ImageUrl="~/images/ic_delete.gif" CommandArgument='<%# Bind("trh_id") %>' CommandName="RejectRequisition" Style="width: 25%" ToolTip="Reject" runat="server" />--%>
                                    </ItemTemplate>

                                    <ControlStyle Width="100%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:PostBackTrigger ControlID="gvRequistionList" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvRequistionList.ClientID %>';
            var pageIndex = 0, pageSize = 20, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { unit: '', vendor: '', req: '', status: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.trq-skel'); }
            function scrollBox() { return $(gridSel).closest('.trq-grid-scroll'); }
            function capture() {
                filters.unit = $('#<%= ddlVendorUnit.ClientID %>').val() || '';
                filters.vendor = $('#<%= ddlTokenVendor.ClientID %>').val() || '';
                filters.req = $('#<%= ddlVendorRequisition.ClientID %>').val() || '';
                filters.status = $('#<%= ddlStatus.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnTokenReqPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 20;
                total = 0;
            }
            function skel() {
                var widths = ['40px', '70%', '70%', '75%', '80%', '36px', '40px', '50px', '18px', '18px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight trq-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function rowHtml(r) {
                var bg = r.status === 'Rejected' ? ' style="background-color:#F08080"' : '';
                var reject = r.status === 'New'
                    ? '<a href="javascript:void(0)" class="trq-reject" data-id="' + esc(r.id) + '" title="Reject"><i class="fa fa-times-circle" style="color:#FF0000;"></i></a>'
                    : '';
                return '<tr class="tlrowlight"' + bg + '>'
                    + '<td style="text-align:center">' + esc(r.id) + '</td>'
                    + '<td style="text-align:center">' + esc(r.unit) + '</td>'
                    + '<td style="text-align:center">' + esc(r.vendor) + '</td>'
                    + '<td style="text-align:center">' + esc(r.site) + '</td>'
                    + '<td style="text-align:center">' + esc(r.desc) + '</td>'
                    + '<td style="text-align:center">' + esc(r.items) + '</td>'
                    + '<td style="text-align:center">' + esc(r.qty) + '</td>'
                    + '<td style="text-align:center">' + esc(r.status) + '</td>'
                    + '<td style="text-align:center"><a href="TokenVendorRequisitionAddUpdate.aspx?id=' + esc(r.id) + '" title="View"><i class="fa fa-eye"></i></a></td>'
                    + '<td style="text-align:center">' + reject + '</td></tr>';
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnTokenReqHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreTokenRequisitions !== 'function') {
                    $(gridSel + ' tr.trq-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreTokenRequisitions(pageIndex, pageSize, filters.unit, filters.vendor, filters.req, filters.status, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.trq-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) html += rowHtml(res.rows[i]);
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.trq-skel').remove();
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
                $(gridSel + ' tr.trq-skel').remove();
                capture();
                var box = scrollBox();
                box.off('scroll.trq').on('scroll.trq', onScroll);
                setTimeout(function () {
                    var live = scrollBox();
                    if ($('#<%= hdnTokenReqHasData.ClientID %>').val() === '1' && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, 0);
            }
            $(document).on('click', gridSel + ' a.trq-reject', function (e) {
                e.preventDefault();
                if (!confirm('Are you sure to reject this?')) return false;
                var $link = $(this);
                var id = parseInt($link.attr('data-id'), 10);
                if (!id) return false;
                PageMethods.RejectTokenRequisition(id, function (res) {
                    if (res !== 'ok') return;
                    var $tr = $link.closest('tr');
                    $tr.css('background-color', '#F08080');
                    $tr.children('td').eq(7).text('Rejected');
                    $link.remove();
                });
                return false;
            });
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
