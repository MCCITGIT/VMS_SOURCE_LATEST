<%@ Page Title="Unit Despatch Plan" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UnitDespatchPlanListVr1.aspx.vb" Inherits="UnitDespatchPlanListVr1" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }

        function DeleteItem() {
            if (confirm("Are you sure you want to delete ...?")) {
                return true;
            }
            return false;
        }

        // Modified-by MUKESH BHAGAT on 31-08-2026 : the Print button opens the report via
        // fnNewWindow, defined in FunctionValidator.js which the redesigned MasterPage no
        // longer includes - so the click failed silently. Defined locally, same as
        // Stock_Upload_Summary.aspx / User_Profile_List_Report.aspx already do.
        function fnNewWindow(strUrl, strtarget) {
            window.open(strUrl, strtarget, "status=no,toolbar=no,menubar=no,location=no,scrollbars=yes,modal=yes,resizable=yes");
        }
    </script>

    <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : pill styling for the document download
         buttons. Done as classes (not inline styles) so the hover state can repaint the
         background - an inline background overrides Bootstrap's :hover and left white
         text on a white pill. --%>
    <style type="text/css">
        .btn-doc-pill {
            min-width: 92px;
            border-radius: 20px;
            background-color: #fff;
        }

        .btn-doc-invoice:hover, .btn-doc-invoice:focus {
            background-color: #28a745;
            color: #fff;
        }

        .btn-doc-eway {
            margin-top: 4px;
        }

        .btn-doc-eway:hover, .btn-doc-eway:focus {
            background-color: #17a2b8;
            color: #fff;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Unit Despatch Plan</h3>
                <p class="pageSubTitle">Plan and track despatches unit by unit</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3">
                                    <asp:ListItem>01</asp:ListItem>
                                    <asp:ListItem>02</asp:ListItem>
                                    <asp:ListItem>03</asp:ListItem>
                                    <asp:ListItem>04</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>06</asp:ListItem>
                                    <asp:ListItem>07</asp:ListItem>
                                    <asp:ListItem>08</asp:ListItem>
                                    <asp:ListItem>09</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>11</asp:ListItem>
                                    <asp:ListItem>12</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan No.:</label>
                                <asp:TextBox ID="txtChallanNo" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                                    <asp:ListItem Value="P" Text="Pending" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="A" Text="Approved"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" ImageUrl="images/ic_search.gif" />
                        <asp:ImageButton ID="ImgbtnAdd" CssClass="btn btn-success btn-sm" runat="server" ImageUrl="images/ic_add.gif" PostBackUrl="~/UnitDespatchPlanAddUpdateVr1.aspx" />--%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                                <asp:LinkButton ID="ImgbtnAdd" CssClass="btn btn-success btn-sm" runat="server" PostBackUrl="~/UnitDespatchPlanAddUpdateVr1.aspx">Add</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="form-group row ddlPageSize" style="display:none;">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <asp:HiddenField ID="hdnUdpHasData" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnUdpPageSize" runat="server" Value="15" />
                    <asp:HiddenField ID="hdnUdpUnit" runat="server" />
                    <asp:HiddenField ID="hdnUdpDepot" runat="server" />
                    <asp:HiddenField ID="hdnUdpYear" runat="server" />
                    <asp:HiddenField ID="hdnUdpMonth" runat="server" />
                    <asp:HiddenField ID="hdnUdpChallan" runat="server" />
                    <asp:HiddenField ID="hdnUdpStatus" runat="server" />
                    <asp:HiddenField ID="hdnUdpApprove" runat="server" />
                    <asp:HiddenField ID="hdnUdpDlPath" runat="server" />
                    <asp:HiddenField ID="hdnUdpDlName" runat="server" />
                    <asp:LinkButton ID="btnUdpDownload" runat="server" Style="display: none;" />
                    <div class="table-responsive udp-grid-scroll">
                        <asp:GridView ID="gvChallanDetails" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                        <asp:HiddenField ID="hdnyear" runat="server" Value='<%# Bind("desph_challan_fin_year") %>' />
                                        <asp:HiddenField ID="hdnMOnth" runat="server" Value='<%# Bind("desph_process_month") %>' />
                                        <asp:HiddenField ID="hdnUnit" runat="server" Value='<%# Bind("desph_desp_unit") %>' />
                                        <asp:HiddenField ID="hdnChallanId" runat="server" Value='<%# Bind("desph_challan_no") %>' />
                                        <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("desph_desp_depot") %>' />
                                        <asp:HiddenField ID="hdndocpath" runat="server" Value='<%# Bind("doc_path") %>' />
                                        <asp:HiddenField ID="hdnorgpath" runat="server" Value='<%# Bind("org_filename") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Reeion" DataField="region">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="desph_desp_depot">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Name" DataField="depotName">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Challan No." DataField="desph_challan_no">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Challan Date" DataField="desph_challan_date" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU List" DataField="skuList">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Aproved/Pending" DataField="">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Print">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ID="ImgbtnPrint" runat="server" AlternateText="Print" ImageUrl="~/images/printButton.png"
                                            CommandName="Print" />--%>
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnPrint" runat="server" AlternateText="Print" CommandName="Print">Print</asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Action">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ID="ImgbtnDeleteChallan" runat="server" AlternateText="Delete Challan" OnClientClick="return DeleteItem()" ToolTip="Click to delete challan" ImageUrl="~/images/ic_delete.gif"
                                            CommandName="DeleteChallan" />--%>
                                        <asp:LinkButton CssClass="btn btn-danger btn-sm" ID="ImgbtnDeleteChallan" runat="server" AlternateText="Delete Challan" OnClientClick="return DeleteItem()" ToolTip="Click to delete challan" CommandName="DeleteChallan">Delete</asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Download">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ID="ImgbtndownloadChallan" runat="server" AlternateText="Download Challan" Height="70px" ToolTip="Click to download challan" ImageUrl="~/images/download.gif"
                                            CommandName="DownloadChallan" />--%>
                                        <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : renamed "Download" to
                                             "Invoice", matched widths, softer outline styling for both. --%>
                                        <asp:LinkButton CssClass="btn btn-outline-success btn-sm btn-doc-pill btn-doc-invoice" ID="ImgbtndownloadChallan" runat="server" AlternateText="Download Invoice" ToolTip="Download the invoice copy" CommandName="DownloadChallan"><i class="fa fa-download"></i>&nbsp;Invoice</asp:LinkButton>
                                        <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : E-Way bill download.
                                             Values are filled in RowDataBound (not Bind) so the page
                                             keeps working even before the SP returns the eway columns. --%>
                                        <asp:HiddenField ID="hdnEwayDocPath" runat="server" />
                                        <asp:HiddenField ID="hdnEwayOrgName" runat="server" />
                                        <asp:LinkButton CssClass="btn btn-outline-info btn-sm btn-doc-pill btn-doc-eway" ID="ImgbtndownloadEway" runat="server" Visible="false" ToolTip="Download the E-Way bill" CommandName="DownloadEway"><i class="fa fa-download"></i>&nbsp;E-Way</asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnAprove" CssClass="btn btn-success btn-sm" runat="server" Text="Approve" OnClientClick="return udpCollectApprove();" />
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <style type="text/css">
        .udp-grid-scroll,
        .udp-grid-scroll table,
        .udp-grid-scroll tr,
        .udp-grid-scroll td {
            overflow-anchor: none;
        }
        .udp-grid-scroll {
            max-height: 440px;
            overflow-y: auto;
            overscroll-behavior: auto;
        }
    </style>
    <script type="text/javascript">
        function udpCollectApprove() {
            var parts = [];
            $('#<%= gvChallanDetails.ClientID %> input.udp-chk:checked').each(function () {
                var d = this.dataset;
                parts.push([d.challan || '', d.unit || '', d.year || '', d.month || '', d.depot || ''].join('|'));
            });
            $('#<%= hdnUdpApprove.ClientID %>').val(parts.join(';'));
            return true;
        }
        (function () {
            var gridSel = '#<%= gvChallanDetails.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { unit: '', depot: '', year: '', month: '', challan: '', status: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function attr(v) { return esc(v).replace(/"/g, '&quot;'); }
            function dataRows() { return $(gridSel + ' tr.tlrowlight').not('.udp-skel'); }
            function scrollBox() { return $(gridSel).closest('.udp-grid-scroll'); }
            function capture() {
                filters.unit = $('#<%= hdnUdpUnit.ClientID %>').val() || '';
                filters.depot = $('#<%= hdnUdpDepot.ClientID %>').val() || '';
                filters.year = $('#<%= hdnUdpYear.ClientID %>').val() || '';
                filters.month = $('#<%= hdnUdpMonth.ClientID %>').val() || '';
                filters.challan = $('#<%= hdnUdpChallan.ClientID %>').val() || '';
                filters.status = $('#<%= hdnUdpStatus.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnUdpPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '18px', '40px', '36px', '70%', '50px', '72px', '80%', '60px', '48px', '52px', '70px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight udp-skel">' + cells + '</tr>';
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
                if ($('#<%= hdnUdpHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreUnitDespatch !== 'function') {
                    $(gridSel + ' tr.udp-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreUnitDespatch(pageIndex, pageSize, filters.unit, filters.depot, filters.year, filters.month, filters.challan, filters.status, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.udp-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var approved = r.approved === 'Y';
                        var select = approved ? '' : '<input type="checkbox" class="udp-chk" data-challan="' + attr(r.challanNo) + '" data-unit="' + attr(r.unit) + '" data-year="' + attr(r.year) + '" data-month="' + attr(r.month) + '" data-depot="' + attr(r.depot) + '" />';
                        var print = approved ? '<a href="#" class="btn btn-primary btn-sm udp-print" data-unit="' + attr(r.unit) + '" data-depot="' + attr(r.depot) + '" data-year="' + attr(r.year) + '" data-challan="' + attr(r.challanNo) + '">Print</a>' : '';
                        var del = approved ? '' : '<a href="#" class="btn btn-danger btn-sm udp-del" data-year="' + attr(r.year) + '" data-challan="' + attr(r.challanNo) + '">Delete</a>';
                        var docs = '<a href="#" class="btn btn-outline-success btn-sm btn-doc-pill btn-doc-invoice udp-dl" data-path="' + attr(r.docPath) + '" data-name="' + attr(r.orgName) + '"><i class="fa fa-download"></i>&nbsp;Invoice</a>';
                        if (r.ewayName) docs += '<a href="#" class="btn btn-outline-info btn-sm btn-doc-pill btn-doc-eway udp-dl" data-path="' + attr(r.ewayPath) + '" data-name="' + attr(r.ewayName) + '"><i class="fa fa-download"></i>&nbsp;E-Way</a>';
                        var link = 'UnitDespatchPlanAddUpdateVr1.aspx?Challan_No=' + encodeURIComponent(r.challanNo || '') + '&Process_Year=' + encodeURIComponent(r.year || '') + '&UnitCode=' + encodeURIComponent(r.unit || '');
                        html += '<tr class="tlrowlight"' + (approved ? ' style="background-color:#7CFC00"' : '') + '>'
                            + '<td style="text-align:center">' + esc(r.serial) + '</td>'
                            + '<td style="text-align:center">' + select + '</td>'
                            + '<td style="text-align:center">' + esc(r.region) + '</td>'
                            + '<td style="text-align:center">' + esc(r.depot) + '</td>'
                            + '<td style="text-align:center">' + esc(r.depotName) + '</td>'
                            + '<td style="text-align:center"><a href="' + link + '" class="gridlink">' + esc(r.challanNo) + '</a></td>'
                            + '<td style="text-align:center">' + esc(r.challanDate) + '</td>'
                            + '<td style="text-align:center">' + esc(r.sku) + '</td>'
                            + '<td style="text-align:center">' + (approved ? 'Approved' : 'Pending') + '</td>'
                            + '<td style="text-align:center">' + print + '</td>'
                            + '<td style="text-align:center">' + del + '</td>'
                            + '<td style="text-align:center">' + docs + '</td></tr>';
                    }
                    if (html) place(html);
                    if (!noMore && scrolledNear()) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.udp-skel').remove();
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
                $(gridSel + ' tr.udp-skel').remove();
                capture();
                setTimeout(function () { if (scrolledNear()) loadNext(); }, 0);
            }
            $(document).off('click.udp').on('click.udp', gridSel + ' a.udp-print', function (e) {
                e.preventDefault();
                var d = this.dataset;
                if (!window.PageMethods || typeof PageMethods.PrepareDespatchPrint !== 'function') return;
                PageMethods.PrepareDespatchPrint(d.unit || '', d.depot || '', d.year || '', d.challan || '', function (ok) {
                    if (ok && typeof fnNewWindow === 'function') fnNewWindow('ReportViewer.aspx', '_blank');
                });
            }).on('click.udp', gridSel + ' a.udp-del', function (e) {
                e.preventDefault();
                if (typeof DeleteItem === 'function' && !DeleteItem()) return;
                var d = this.dataset;
                if (!window.PageMethods || typeof PageMethods.DeleteAppendedChallan !== 'function') return;
                PageMethods.DeleteAppendedChallan(d.year || '', parseInt(d.challan, 10) || 0, function (ok) {
                    if (ok) __doPostBack('<%= ImgbtnSearch.UniqueID %>', '');
                });
            }).on('click.udp', gridSel + ' a.udp-dl', function (e) {
                e.preventDefault();
                var d = this.dataset;
                if (!d.name) return;
                $('#<%= hdnUdpDlPath.ClientID %>').val(d.path || '');
                $('#<%= hdnUdpDlName.ClientID %>').val(d.name || '');
                __doPostBack('<%= btnUdpDownload.UniqueID %>', '');
            });
            if (!window.__udpScroll) {
                window.__udpScroll = true;
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
