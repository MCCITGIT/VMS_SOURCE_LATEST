<%@ Page Title="Raw Material Creation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OpcRawMaterialCreationList.aspx.vb" Inherits="OpcRawMaterialCreationList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material / Packaging List</h3>
                    <p class="pageSubTitle">Browse and manage vendor raw material and packaging entries</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-4" id="colVendorFilter" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">Type:</label>
                            <asp:DropDownList ID="ddlItemType" ClientIDMode="Static" CssClass="form-control" runat="server">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="RM" Text="Raw Material"></asp:ListItem>
                                <asp:ListItem Value="PKG" Text="Packaging"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Name / code:</label>
                            <asp:TextBox ID="txtSearch" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" MaxLength="200" Placeholder="Name or code"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="lbBtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" ToolTip="Search" OnClick="lbBtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="btnAdd_Click" ToolTip="Add">
                          <i class="fas fa-plus"></i> Add
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Raw Material / Packaging List</h5>
                        <p class="mst-panel-subtitle">Raw materials and packaging items created for vendor use</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:HiddenField ID="hdnRmHasData" runat="server" Value="0" />
                <asp:HiddenField ID="hdnRmPageSize" runat="server" Value="10" />
                <asp:HiddenField ID="hdnRmUnit" runat="server" />
                <asp:HiddenField ID="hdnRmSearch" runat="server" />
                <asp:HiddenField ID="hdnRmType" runat="server" />
                <asp:HiddenField ID="hdnRmIsUnit" runat="server" Value="0" />
                <div class="table-responsive orm-grid-scroll">
                    <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                        ID="gvRmList" runat="server" AutoGenerateColumns="false" AllowPaging="false" PageSize="10"
                        ShowFooter="false" GridLines="both" EmptyDataText="No records found"
                        PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                        OnRowCommand="gvRmList_RowCommand" OnRowDataBound="gvRmList_RowDataBound">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvRmList.PageIndex * gvRmList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text='<%# If(Convert.ToString(Eval("rmm_item_type")).Trim().ToUpper() = "PKG", "Packaging", "Raw Material") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnItemType" runat="server" Value='<%# Eval("rmm_item_type") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblRmCode" runat="server" Text='<%# Bind("rmm_code") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblRmName" runat="server" Text='<%# Bind("rmm_material_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Vendor">
                                <ItemTemplate>
                                    <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="22%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Berger Code">
                                <ItemTemplate>
                                    <%-- 04-11-2026: the linked Berger code, or a note when Berger does not buy the product (flag 'N') --%>
                                    <asp:Label ID="lblBerger" runat="server" Text='<%# If(Convert.ToString(Eval("berger_not_sale_flag")).Trim().ToUpper() = "N", "Berger does not buy", Convert.ToString(Eval("berger_code")).Trim()) %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("rmm_status") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblActive" runat="server" CssClass='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "Active", "Inactive") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <div style="display: flex; align-items: center; justify-content: center">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRm" CommandArgument='<%# Eval("rmm_code") %>' ToolTip="Edit"><i class="fa fa-edit"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
    <style type="text/css">
        .orm-grid-scroll,
        .orm-grid-scroll table,
        .orm-grid-scroll tr,
        .orm-grid-scroll td {
            overflow-anchor: none;
        }
        .orm-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvRmList.ClientID %>';
            var pageIndex = 0, pageSize = 10, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { unit: '', search: '', type: '' };
            var align = ['center', 'center', 'center', 'left', 'left', 'center', 'center', 'center', 'center'];

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.orm-skel'); }
            function scrollBox() { return $(gridSel).closest('.orm-grid-scroll'); }
            function capture() {
                filters.unit = $('#<%= hdnRmUnit.ClientID %>').val() || '';
                filters.search = $('#<%= hdnRmSearch.ClientID %>').val() || '';
                filters.type = $('#<%= hdnRmType.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnRmPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 10;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70px', '60px', '80%', '70%', '70px', '60px', '56px', '18px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:' + align[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight orm-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnRmHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreRawMaterials !== 'function') {
                    $(gridSel + ' tr.orm-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreRawMaterials(pageIndex, pageSize, filters.unit, filters.search, filters.type, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.orm-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var edit = r.canEdit ? '<div style="display:flex;align-items:center;justify-content:center"><a href="OpcRawMaterialCreation.aspx?RmCode=' + encodeURIComponent(r.code || '') + '" title="Edit"><i class="fa fa-edit"></i></a></div>' : '';
                        var vals = [esc(r.serial), esc(r.typeName), esc(r.code), esc(r.name), esc(r.vendor), esc(r.berger), esc(r.status), '<span class="' + esc(r.activeClass) + '">' + esc(r.activeText) + '</span>', edit];
                        html += '<tr class="tlrowlight">';
                        for (var c = 0; c < vals.length; c++) html += '<td style="text-align:' + align[c] + '">' + vals[c] + '</td>';
                        html += '</tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.orm-skel').remove();
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
                $(gridSel + ' tr.orm-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            if (!window.__ormScroll) {
                window.__ormScroll = true;
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
