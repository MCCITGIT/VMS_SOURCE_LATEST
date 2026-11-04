<%@ Page Title="Estimation Data Despatched Status" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Estimation_Data_Despatched_Status.aspx.vb" Inherits="Estimation_Data_Despatched_Status" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/Validation_Estimation_Data_Despatch_Status.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            //	    if(event.keyCode == 118){  // button Add (F7 keypress)	    		    0
            //		    __doPostBack(document.getElementById('ImgbtnAdd').name,'');
            //	    }
            if (event.keyCode == 119) {
                if (ValidatePaymentSearch()) { // button Search (F8 keypress)    		    	        
                    __doPostBack(document.getElementById('ImgbtnSearch').name, '');
                }
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">SKU Wise Despatch Status</h3>
                <p class="pageSubTitle">Despatch status against estimates, SKU wise</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Despatched Source:</label>
                                <asp:DropDownList ID="ddlDsptchdUnit" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlProduct" runat="server" AppendDataBoundItems="True" AutoPostBack="True" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Fin Year:<span id="lblGroup" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtFinYear" runat="server" CssClass="form-control" MaxLength="4"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Month:<span id="Span3" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtMonth" runat="server" CssClass="form-control" MaxLength="2" TabIndex="5"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Format:</label>
                                <asp:DropDownList ID="ddlPrntOptn" CssClass="form-control select2" valign="Center" runat="server" AutoPostBack="True" AppendDataBoundItems="True">
                                    <%--<asp:ListItem>Select Print Option</asp:ListItem>--%>
                                    <asp:ListItem Value="PdfFormat">PDF</asp:ListItem>
                                    <asp:ListItem Value="ExcelFormat" Selected="True">Excel</asp:ListItem>
                                    <asp:ListItem Value="WordFormat">Word</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <%--<asp:ImageButton ImageUrl="images/ic_search.gif" ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" AlternateText="Search" />--%>
                            <asp:LinkButton ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" AlternateText="Search" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                            <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" TabIndex="31" runat="server" Text="Submit" />
                            <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm d-none" TabIndex="32" runat="server" Text="Cancel" />
                        </div>
                    </div>
                    <div id="divErrMsg1" class="errormsg"></div>
                </div>
            </div>
            <div class="card" id="td_gvitem_mid" runat="server">
                <div class="card-body">
                    <div class="form-group row ddlPageSize" style="display:none;">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <asp:HiddenField ID="hdnEdsHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnEdsPageSize" runat="server" Value="15" />
                    <asp:HiddenField ID="hdnEdsRegion" runat="server" />
                    <asp:HiddenField ID="hdnEdsDepot" runat="server" />
                    <asp:HiddenField ID="hdnEdsUnit" runat="server" />
                    <asp:HiddenField ID="hdnEdsSku" runat="server" />
                    <asp:HiddenField ID="hdnEdsYear" runat="server" />
                    <asp:HiddenField ID="hdnEdsMonth" runat="server" />
                    <div class="table-responsive eds-grid-scroll">
                        <asp:GridView ID="gvDsptchdStat" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Srl.No">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'
                                            Font-Bold="True"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="3%" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="region" HeaderText="Region">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="4%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_depot" HeaderText="Depot">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="9%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_sku_code" HeaderText="SKU">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="23%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_average" HeaderText="Average">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_estimate_nop" HeaderText="Estimate">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_tsl_factor" HeaderText="TSL Factor">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_tsl_nop" HeaderText="TSL">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_stock" HeaderText="Stock">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_auto_indent" HeaderText="Auto Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_depot_indent_nop" HeaderText="Branch Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Desp_date" HeaderText="Desp-to Date">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="INTRANSIT" HeaderText="INTRANSIT">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RECEIVED at Depot" HeaderText="RECEIVED at Depot">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Last_Desp_date" HeaderText="Last Despatch Date">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="pending_auto_indent" HeaderText="Pending Auto Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="pending_manual_indent" HeaderText="Pending Manual Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="current_despatch" HeaderText="Current Despatch">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div id="tblrental" runat="server">
                        <asp:Label ID="lblNoRecrds" CssClass="errormsg" runat="server"></asp:Label>
                        <asp:Label ID="lblErrMsg" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        <div id="divErrMsg"></div>
                    </div>
                    <div id="divErrorMessage1"></div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
    </asp:UpdatePanel>
    <style type="text/css">
        .eds-grid-scroll,
        .eds-grid-scroll table,
        .eds-grid-scroll tr,
        .eds-grid-scroll td {
            overflow-anchor: none;
        }
        .eds-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: contain;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvDsptchdStat.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { region: '', depot: '', unit: '', sku: '', year: '', month: '' };
            var align = ['center', 'center', 'center', 'center', 'center', 'center', 'center', 'center', 'right', 'right', 'right', 'right', 'right', 'right', 'right', 'right', 'right', 'right'];

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.eds-skel'); }
            function scrollBox() { return $(gridSel).closest('.eds-grid-scroll'); }
            function capture() {
                filters.region = $('#<%= hdnEdsRegion.ClientID %>').val() || '';
                filters.depot = $('#<%= hdnEdsDepot.ClientID %>').val() || '';
                filters.unit = $('#<%= hdnEdsUnit.ClientID %>').val() || '';
                filters.sku = $('#<%= hdnEdsSku.ClientID %>').val() || '';
                filters.year = $('#<%= hdnEdsYear.ClientID %>').val() || '';
                filters.month = $('#<%= hdnEdsMonth.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnEdsPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '36px', '70%', '80%', '40px', '40px', '28px', '36px', '40px', '40px', '40px', '72px', '40px', '40px', '72px', '40px', '40px', '40px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:' + align[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight eds-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnEdsHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreDespatchStatus !== 'function') {
                    $(gridSel + ' tr.eds-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreDespatchStatus(pageIndex, pageSize, filters.region, filters.depot, filters.unit, filters.sku, filters.year, filters.month, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.eds-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var vals = [r.serial, r.region, r.depot, r.sku, r.average, r.estimate, r.tslFactor, r.tsl, r.stock, r.autoIndent, r.branchIndent, r.despDate, r.intransit, r.received, r.lastDesp, r.pendingAuto, r.pendingManual, r.currentDespatch];
                        html += '<tr class="tlrowlight">';
                        for (var c = 0; c < vals.length; c++) {
                            var text = c === 0 ? '<b>' + esc(vals[c]) + '</b>' : esc(vals[c]);
                            html += '<td style="text-align:' + align[c] + '">' + text + '</td>';
                        }
                        html += '</tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.eds-skel').remove();
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
                $(gridSel + ' tr.eds-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            if (!window.__edsScroll) {
                window.__edsScroll = true;
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
