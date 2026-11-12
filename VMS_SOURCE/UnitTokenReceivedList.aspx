<%@ Page Title="Token Requisition List (Vendor)" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UnitTokenReceivedList.aspx.vb" Inherits="UnitTokenReceivedList" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key="&<%= DateTime.Now.ToString %> ></script>

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
                <h3 class="pageTitle">Token Despatches List For Receive</h3>
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
                        <label class="form-control-label">Unit Name:</label>
                        <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlTokenVendor" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Requisition Id:</label>
                        <asp:DropDownList ID="ddlVendorRequisition" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Despatch Id:</label>
                        <asp:DropDownList ID="ddlDespatchId" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server">
                            <asp:ListItem Value="">Select</asp:ListItem>
                            <asp:ListItem Value="P">Pending</asp:ListItem>
                            <asp:ListItem Value="R">Received</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>

                        <%--<asp:ImageButton ImageUrl="images/p-search.png" title="Search" CssClass="btn btn-primary btn-sm py-2" ID="imgbtnSearch" runat="server" />--%>
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
                    <h5 class="mst-panel-title">Token Despatches List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hdnUnitRecvHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnUnitRecvPageSize" runat="server" Value="10" />
                    <div class="table-responsive grid-skel-bar">
                        <asp:GridView ID="gvRequistionList" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvRequistionList_RowDataBound" EmptyDataText="No records found" AllowPaging="false" OnRowCommand="gvTokenVendorList_RowCommand" PageSize="10" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Requisition  Id" ControlStyle-Width="90%" Visible="true">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesc" Text='<%# Bind("tdh_requisition_id")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Despatch Id" ControlStyle-Width="90%" Visible="true">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequistionId" Text='<%# Bind("tdh_despatch_id")%>' runat="server" />
                                        <asp:HiddenField runat="server" Value='<%# Bind("treh_recieve_id")%>' ID="hdnReceive" />
                                        <asp:HiddenField runat="server" Value='<%# Bind("tdh_despatch_id")%>' ID="hdnDespatch" />
                                        <asp:HiddenField runat="server" Value='<%# Bind("tdh_requisition_id")%>' ID="hdnRequisition" />
                                        <asp:HiddenField runat="server" Value='<%# Bind("tdh_token_vendor")%>' ID="hdnTokenVendor" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="2%" />
                                </asp:TemplateField>


                                <asp:TemplateField HeaderText="Unit Name" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnit" Text='<%# Bind("unit_name")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Courrier Name" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNoOfitems" Text='<%# Bind("tdh_transporter")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <%--               <asp:TemplateField HeaderText="Truck No." ControlStyle-Width="90%" >
                                            <ItemTemplate>
                                                 <asp:Label ID="lblTotalQty" Text='<%# Bind("tdh_truck_no")%>' runat="server" />
                                            </ItemTemplate>

                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="Challan No." ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_vendor_challan_no" Text='<%# Bind("tdh_vendor_challan_no")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Challan Date" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_vendor_challan_date" Text='<%# Bind("tdh_vendor_challan_date")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Road Permit" ControlStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lbltdh_road_permit" Text='<%# Bind("tdh_road_permit")%>' runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <%--            <asp:TemplateField HeaderText="Print" ControlStyle-Width="100%" >
                                                      <HeaderTemplate>
                                                          <span>Despatch Advise</span>
                                                         
                                                      </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgBtnPrint" ImageUrl="~/images/printButton.png" CommandArgument='<%# Bind("tdh_despatch_id")%>' CommandName="PrintDespatch" Style="width:25%" ToolTip="Print" runat="server" />
                                            </ItemTemplate>

                                            <ControlStyle  Width="100%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="4%" />
                                        </asp:TemplateField>  --%>
                                <asp:TemplateField HeaderText="View" ControlStyle-Width="100%">
                                    <HeaderTemplate>
                                        <span>View</span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgBtnSubmit" ImageUrl="~/images/p-view.png" title="View" CommandArgument='<%# Bind("tdh_despatch_id")%>' CommandName="EditRequisition" Style="width: 27%" ToolTip="View" runat="server" />
                                    </ItemTemplate>

                                    <ControlStyle Width="100%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                </asp:TemplateField>


                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="gvRequistionList" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>

    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvRequistionList.ClientID %>';
            var pageIndex = 0, pageSize = 10, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { unit: '', vendor: '', req: '', despatch: '', status: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.utr-skel'); }
            function scrollBox() { return $(gridSel).closest('.grid-skel-bar'); }
            function capture() {
                filters.unit = $('#<%= ddlVendorUnit.ClientID %>').val() || '';
                filters.vendor = $('#<%= ddlTokenVendor.ClientID %>').val() || '';
                filters.req = $('#<%= ddlVendorRequisition.ClientID %>').val() || '';
                filters.despatch = $('#<%= ddlDespatchId.ClientID %>').val() || '';
                filters.status = $('#<%= ddlStatus.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnUnitRecvPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 10;
                total = 0;
            }
            function skel() {
                var widths = ['40px', '40px', '70%', '70%', '60px', '72px', '60px', '22px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight utr-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function rowHtml(r) {
                var received = parseInt(r.receiveId, 10);
                var bg = (!isNaN(received) && received !== 0) ? ' style="background-color:#90EE90"' : '';
                var href = 'UnitTokenReceivedAddUpdate.aspx?receiveid=' + esc(r.receiveId) + '&tokenVendor=' + esc(r.tokenVendor) + '&requisition=' + esc(r.requisitionId) + '&despatch=' + esc(r.despatchId);
                return '<tr class="tlrowlight"' + bg + '>'
                    + '<td style="text-align:center">' + esc(r.requisitionId) + '</td>'
                    + '<td style="text-align:center">' + esc(r.despatchId) + '</td>'
                    + '<td style="text-align:center">' + esc(r.unit) + '</td>'
                    + '<td style="text-align:center">' + esc(r.courier) + '</td>'
                    + '<td style="text-align:center">' + esc(r.challanNo) + '</td>'
                    + '<td style="text-align:center">' + esc(r.challanDate) + '</td>'
                    + '<td style="text-align:center">' + esc(r.roadPermit) + '</td>'
                    + '<td style="text-align:center"><a href="' + href + '" title="View"><img src="images/p-view.png" title="View" alt="View" style="width:27%" /></a></td></tr>';
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnUnitRecvHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreUnitTokenReceived !== 'function') {
                    $(gridSel + ' tr.utr-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreUnitTokenReceived(pageIndex, pageSize, filters.unit, filters.vendor, filters.req, filters.despatch, filters.status, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.utr-skel').remove();
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
                    $(gridSel + ' tr.utr-skel').remove();
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
                $(gridSel + ' tr.utr-skel').remove();
                capture();
                var box = scrollBox();
                box.off('scroll.utr').on('scroll.utr', onScroll);
                setTimeout(function () {
                    var live = scrollBox();
                    if ($('#<%= hdnUnitRecvHasData.ClientID %>').val() === '1' && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
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
