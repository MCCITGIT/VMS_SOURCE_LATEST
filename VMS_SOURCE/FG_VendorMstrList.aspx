<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FG_VendorMstrList.aspx.vb" Inherits="FG_VendorMstrList" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                document.getElementById('ImgbtnAdd').click();
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">FG Vendor Master</h3>
                <p class="pageSubTitle">Browse and manage production vendors</p>
            </div>
        </div>
        <div class="rightFung">
            <asp:LinkButton ID="ImgbtnAdd" runat="server" class="btn btn-success btn-sm" OnClick="ImgbtnAdd_Click">Add</asp:LinkButton>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Vendor Details</h5>
                        <p class="mst-panel-subtitle">Login activity for the selected user</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="display: none; align-items: center; padding: 0px;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="Label1" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="form-group mb-0">
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2" style="display: flex; align-items: flex-end;">
                    <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                </div>
            </div>
            <div class="table-responsive fgm-grid-scroll">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnFgmHasData" runat="server" Value="0" />
                        <asp:HiddenField ID="hdnFgmPageSize" runat="server" Value="15" />
                        <asp:HiddenField ID="hdnFgmVendor" runat="server" />
                        <asp:GridView ID="gvVendorProfile" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            OnRowDataBound="gvVendorProfile_RowDataBound" Visible="true" BorderWidth="1" Style="margin-bottom: 0" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>                                

                                <asp:BoundField HeaderText="Source Code" DataField="unit_code">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Source Name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataField="unit_name">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>

                               

                                <asp:BoundField HeaderText="Status" HeaderStyle-HorizontalAlign="Center" DataField="active">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Created User" HeaderStyle-HorizontalAlign="Center" DataField="created_user">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Created Date" HeaderStyle-HorizontalAlign="Center" DataField="created_date">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>
                                 <asp:BoundField HeaderText="Oracle ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataField="oracle_id">
     <HeaderStyle HorizontalAlign="Center" />
     <ItemStyle HorizontalAlign="Center" Width="15%" />
 </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch"
                            EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <style type="text/css">
        .fgm-grid-scroll,
        .fgm-grid-scroll table,
        .fgm-grid-scroll tr,
        .fgm-grid-scroll td {
            overflow-anchor: none;
        }
        .fgm-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvVendorProfile.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0;
            var vendor = '';

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.fgm-skel'); }
            function scrollBox() { return $(gridSel).closest('.fgm-grid-scroll'); }
            function capture() {
                vendor = $('#<%= hdnFgmVendor.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnFgmPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '60px', '70%', '56px', '70px', '70px', '60px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight fgm-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnFgmHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreFgVendors !== 'function') {
                    $(gridSel + ' tr.fgm-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreFgVendors(pageIndex, pageSize, vendor, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.fgm-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var name = '<a href="Vendor_Profile_Add.aspx?UnitCode=' + encodeURIComponent(r.code || '') + '" class="gridlink">' + esc(r.name) + '</a>';
                        var style = r.inactive ? ' style="background-color:Red;color:White"' : '';
                        html += '<tr class="tlrowlight"' + style + '>' +
                            '<td style="text-align:center">' + esc(r.serial) + '</td>' +
                            '<td style="text-align:center">' + esc(r.code) + '</td>' +
                            '<td style="text-align:center">' + name + '</td>' +
                            '<td style="text-align:center">' + esc(r.status) + '</td>' +
                            '<td style="text-align:center">' + esc(r.createdUser) + '</td>' +
                            '<td style="text-align:center">' + esc(r.createdDate) + '</td>' +
                            '<td style="text-align:center">' + esc(r.oracleId) + '</td></tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.fgm-skel').remove();
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
                $(gridSel + ' tr.fgm-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            if (!window.__fgmScroll) {
                window.__fgmScroll = true;
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
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>
