<%@ Page Title="Raw Material Requisition List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialRequisitionList.aspx.vb" Inherits="RawMaterialRequisitionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <%-- <style type="text/css">
            .rm-module .upgradDataGrid td.rm-wrap-text {
                width: 38% !important;
                max-width: none !important;
                white-space: normal !important;
                word-break: normal !important;
                overflow-wrap: break-word !important;
                vertical-align: top !important;
                text-align: left !important;
                padding-top: 8px !important;
                padding-bottom: 8px !important;
            }

                .rm-module .upgradDataGrid td.rm-wrap-text .rm-rawmat-list {
                    display: block;
                    width: 100%;
                }

                .rm-module .upgradDataGrid td.rm-wrap-text .rm-rawmat-line {
                    display: flex;
                    align-items: baseline;
                    justify-content: space-between;
                    gap: 10px;
                    width: 100%;
                    padding: 4px 0;
                    border-bottom: 1px dotted #d7dde6;
                }

                    .rm-module .upgradDataGrid td.rm-wrap-text .rm-rawmat-line:last-child {
                        border-bottom: 0;
                        padding-bottom: 0;
                    }

                .rm-module .upgradDataGrid td.rm-wrap-text .rm-rawmat-name {
                    flex: 1 1 auto;
                    min-width: 0;
                    text-align: left;
                    white-space: normal !important;
                    word-break: normal !important;
                    overflow-wrap: break-word !important;
                }

                .rm-module .upgradDataGrid td.rm-wrap-text .qty {
                    flex: 0 0 auto;
                    width: auto;
                    text-align: right;
                    font-weight: 600;
                    white-space: nowrap !important;
                    word-break: keep-all !important;
                    overflow-wrap: normal !important;
                }

        .rm-module .rm-wrap-text {
            text-align: left;
        }
    </style>--%>
    <style type="text/css">
        #gvRequisition .rm-req-skel-bar {
            display: inline-block;
            height: 12px;
            max-width: 100%;
            border-radius: 3px;
            vertical-align: middle;
            background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
            background-size: 400% 100%;
            animation: rmReqSkelShimmer 1.2s ease-in-out infinite;
        }

        #gvRequisition .rm-req-skel-box {
            display: inline-block;
            width: 14px;
            height: 14px;
            border-radius: 3px;
            vertical-align: middle;
            background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
            background-size: 400% 100%;
            animation: rmReqSkelShimmer 1.2s ease-in-out infinite;
        }

        @keyframes rmReqSkelShimmer {
            0% { background-position: 100% 0; }
            100% { background-position: 0 0; }
        }
    </style>
    <style type="text/css">
        .rm-confirm-title {
            margin: 0 0 8px;
            color: #111827;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        .rm-confirm-text {
            margin: 0 0 22px;
            color: #64748b;
            font-size: 14px;
            line-height: 1.45;
            white-space: pre-line;
        }

        .rm-confirm-dialog.is-error .rm-confirm-title {
            color: #e11d48;
        }

        .rm-confirm-dialog.is-error .rm-confirm-text {
            text-align: left;
            color: #e11d48 !important;
            font-weight: 600;
        }

        .rm-confirm-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

            .rm-confirm-actions .btn {
                min-width: 110px;
            }

        .rm-module #lblErrorMessage,
        .rm-module span[id$="lblErrorMessage"] {
            display: none !important;
        }

        .rm-module .rm-stat-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .rm-module .rm-stat-card {
            background: #eff2f5;
            border: 1px solid #eee8de;
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 8px 22px rgba(80, 60, 30, 0.06);
            min-height: 96px;
        }

        .rm-module .rm-stat-icon {
            width: 22px;
            height: 22px;
            margin-bottom: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

            .rm-module .rm-stat-icon.is-blue {
                color: #2f6fed;
            }

            .rm-module .rm-stat-icon.is-orange {
                color: #e7a23a;
            }

            .rm-module .rm-stat-icon.is-green {
                color: #22a35a;
            }

            .rm-module .rm-stat-icon.is-red {
                color: #e11d48;
            }

        .rm-module .rm-stat-label {
            margin: 0 0 4px 0;
            color: #7d8899;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .rm-module .rm-stat-value {
            margin: 0;
            color: #111827;
            font-size: 32px;
            line-height: 1;
            font-weight: 800;
        }

            .rm-module .rm-stat-value.is-green {
                color: #15803d;
            }

            .rm-module .rm-stat-value.is-red {
                color: #e11d48;
            }

        .rm-compact .rm-grid-actions {
            padding-top: 8px;
            text-align: center;
            flex-shrink: 0;
        }

        .rm-compact .rm-stat-value.is-orange {
            color: #d9822b;
        }

        .rm-compact .rm-add-form-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .rm-compact .rm-add-form-controls .form-control {
                flex: 1 1 auto;
                min-width: 0;
            }

            .rm-compact .rm-add-form-controls .btn {
                margin: 0 !important;
                height: 36px;
                min-width: 88px;
            }

        .rm-compact .rm-stat-row {
            flex: 1 1 58%;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            margin-bottom: 0;
        }

        .rm-compact .rm-stat-card {
            min-height: 0;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-radius: 12px;
        }

        .rm-compact .rm-stat-icon {
            margin-bottom: 0;
            font-size: 20px;
            width: 24px;
            height: 20px;
        }

        .rm-compact .rm-stat-label {
            margin: 0;
            font-size: 10px;
        }

        .rm-compact .rm-stat-value {
            font-size: 20px;
        }

        .rm-compact .rm-list-fill {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            min-height: 0;
            margin-bottom: 0;
        }

            .rm-compact .rm-list-fill .card-body {
                flex: 1 1 auto;
                overflow: auto;
                padding-top: 8px;
                display: flex;
                flex-direction: column;
                min-height: 0;
            }

        .rm-card,
        .rm-metric-card,
        .rm-upload-box,
        .rm-list-card,
        .rm-status-badge,
        .rm-stat-card {
            transition: box-shadow 0.22s ease, border-color 0.22s ease, background-color 0.22s ease, transform 0.22s ease;
        }

            .rm-metric-card:hover,
            .rm-stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 22px rgba(80, 60, 30, 0.08);
            }
    </style>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateRawMaterialRequisitionDtls.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                __doPostBack(document.getElementById('ImgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="rm-module rm-compact">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material Requisition List</h3>
                    <p class="pageSubTitle">Track raw material requisitions</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanelFilter" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor:</label>
                                    <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Supplier:</label>
                                    <asp:DropDownList ID="ddlRawMatvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Approval Status:</label>
                                    <asp:DropDownList ID="ddlApprovalstatus" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3 form-btn-mt">
                                <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" OnClick="ImgbtnAdd_Click" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" />
                            </div>
                        </div>

                        <div class="rm-stat-row mt-2">
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                <div>
                                    <p class="rm-stat-label">Total</p>
                                    <p class="rm-stat-value">
                                        <asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-orange"><i class="fas fa-clock"></i></div>
                                <div>
                                    <p class="rm-stat-label">Pending</p>
                                    <p class="rm-stat-value is-orange">
                                        <asp:Label ID="lblPendingCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                                <div>
                                    <p class="rm-stat-label">Approved</p>
                                    <p class="rm-stat-value is-green">
                                        <asp:Label ID="lblApprovedCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnApprove" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>

        <div class="card rm-list-fill">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Requisition List</h5>
                        <p class="mst-panel-subtitle">All raw material requisitions and their approval status</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:UpdatePanel ID="UpdatePanelGrid" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnExtraRequisitions" runat="server" ClientIDMode="Static" />
                        <div class="table-responsive rm-grid-scroll rm-fit-grid">
                            <asp:GridView BorderWidth="0" CssClass="table table-hover upgradDataGrid rm-fit-grid" CellSpacing="0" CellPadding="0"
                                ID="gvRequisition" runat="server" ClientIDMode="Static" AutoGenerateColumns="false" Visible="true"
                                ShowFooter="false" GridLines="None" EmptyDataText="No records found"
                                PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                                OnRowCommand="gvRequisition_RowCommand" OnRowDataBound="gvRequisition_RowDataBound">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvRequisition.PageIndex * gvRequisition.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="rm-th-nowrap" HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                        <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                            <asp:HiddenField ID="hdnRequestId" runat="server" Value='<%# Bind("request_id") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="16%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="16%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="RM Vendor Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRawMatVendorName" runat="server" Text='<%# Bind("rawmat_vendor_name") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnrmVendorcode" runat="server" Value='<%# Bind("rawmat_vendor_code") %>' />
                                            <asp:HiddenField ID="hdnrmVendoremail" runat="server" Value='<%# Bind("rawmat_vendor_email") %>' />
                                            <asp:HiddenField ID="hdnccemail" runat="server" Value='<%# Bind("CCAddress") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="16%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="16%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Raw Material List">
                                        <ItemTemplate>
                                            <div class="rm-wrap-text">
                                                <asp:HiddenField ID="hdnRawmaterialList" runat="server" Value='<%# Bind("RawmaterialList") %>' />
                                                <asp:Literal ID="litRawmaterialList" runat="server" Mode="PassThrough"></asp:Literal>
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="38%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Width="38%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Approval Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblApprovalStatus" runat="server" Text='<%# Bind("approval_status") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <div style="display: flex; align-items: center; justify-content: center">
                                                <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="ViewRequisition" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View"><i class="fa fa-eye"></i></asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="6%" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="rm-grid-actions">
                            <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-success btn-sm"
                                OnClientClick="return validateRawMaterialRequisitionApprove();"
                                CausesValidation="false" UseSubmitBehavior="true" />
                            <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnReset" EventName="Click" />
                        <asp:PostBackTrigger ControlID="gvRequisition" />
                        <asp:AsyncPostBackTrigger ControlID="btnApprove" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript">
        $(function () {
            var pageIndex = 0;
            var loading = false;
            var noMoreData = false;
            var loadSeq = 0;
            var suppressScrollUntil = 0;
            var filters = { vendor: '', rmVendor: '', status: '' };
            var gridSel = '#gvRequisition';

            function captureFilters() {
                filters.vendor = $('#ddlvendor').val() || '';
                filters.rmVendor = $('#ddlRawMatvendor').val() || '';
                filters.status = $('#ddlApprovalstatus').val() || '';
            }

            function dataRows() {
                return $(gridSel + ' tbody tr').not('.rm-req-skel').not('.headerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function bindRequisitionScroll() {
                var $el = $(gridSel).closest('.rm-grid-scroll');
                $el.off('scroll.rmreq').on('scroll.rmreq', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($el.scrollTop() + $el.innerHeight() < $el[0].scrollHeight - 50) return;
                    loadNext($el);
                });
            }

            function loadNext($el) {
                if (loading || noMoreData || dataRows().length === 0) return;

                loading = true;
                pageIndex++;
                var seq = ++loadSeq;
                showRequisitionSkeleton($el);

                PageMethods.GetMoreRequisitions(pageIndex, filters.vendor, filters.rmVendor, filters.status,
                    function (result) {
                        if (seq !== loadSeq) return;
                        hideRequisitionSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        var $tbody = $(gridSel + ' tbody');
                        $.each(result.rows, function (i, r) {
                            appendRequisitionRow($tbody, r);
                        });
                        if (dataRows().length >= result.total) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.rm-grid-scroll');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) {
                            loadNext($scroll);
                        }
                    },
                    function () {
                        if (seq !== loadSeq) return;
                        hideRequisitionSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showRequisitionSkeleton($scroll) {
                var $tbody = $(gridSel + ' tbody');
                if (!$tbody.length || $tbody.find('tr.rm-req-skel').length) return;

                var nameWidths = ['70%', '58%', '78%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight rm-req-skel">';
                    html += '<td align="center" style="width:4%;"><span class="rm-req-skel-bar" style="width:16px;"></span></td>';
                    html += '<td align="center" style="width:8%;"><span class="rm-req-skel-box"></span></td>';
                    html += '<td align="center" style="width:16%;"><span class="rm-req-skel-bar" style="width:' + nameWidths[r] + ';"></span></td>';
                    html += '<td align="center" style="width:16%;"><span class="rm-req-skel-bar" style="width:' + nameWidths[(r + 1) % 3] + ';"></span></td>';
                    html += '<td align="center" style="width:38%;"><span class="rm-req-skel-bar" style="width:82%;"></span></td>';
                    html += '<td align="center" style="width:14%;"><span class="rm-req-skel-bar" style="width:64%;"></span></td>';
                    html += '<td align="center" style="width:6%;"><span class="rm-req-skel-box"></span></td>';
                    html += '</tr>';
                }
                $tbody.append(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideRequisitionSkeleton() {
                var $rows = $(gridSel + ' tbody tr.rm-req-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendRequisitionRow($tbody, r) {
                var slNo = dataRows().length + 1;
                var approved = String(r.approval_status || '').toLowerCase() === 'approved';
                var rawList = String(r.RawmaterialList || '').replace(/\r?\n/g, ',');
                $tbody.append(
                    '<tr class="tlrowlight rm-extra-row" data-request-id="' + escAttr(r.request_id) + '" data-rm-code="' + escAttr(r.rawmat_vendor_code) + '" data-rm-email="' + escAttr(r.rawmat_vendor_email) + '" data-vendor-name="' + escAttr(r.vendor_name) + '" data-rm-name="' + escAttr(r.rawmat_vendor_name) + '" data-raw-list="' + escAttr(rawList) + '" data-cc="' + escAttr(r.CCAddress) + '">' +
                    '<td align="center" style="width:4%;">' + slNo + '</td>' +
                    '<td align="center" style="width:8%;"><input type="checkbox" id="rmExtra' + slNo + '_chkSelect"' + (approved ? ' disabled="disabled"' : '') + ' /></td>' +
                    '<td align="center" style="width:16%;">' + esc(r.vendor_name) + '</td>' +
                    '<td align="center" style="width:16%;">' + esc(r.rawmat_vendor_name) + '</td>' +
                    '<td align="center" style="width:38%;vertical-align:top;"><div class="rm-wrap-text">' + (r.RawmaterialHtml || '') + '</div></td>' +
                    '<td align="center" style="width:14%;">' + esc(r.approval_status) + '</td>' +
                    '<td align="center" style="width:6%;"><div style="display:flex;align-items:center;justify-content:center"><a href="RawMaterialRequisitionDtls.aspx?request_id=' + encodeURIComponent(r.request_id || '') + '" title="View"><i class="fa fa-eye"></i></a></div></td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            function escAttr(v) {
                return esc(v).replace(/"/g, '&quot;');
            }

            function syncExtraApprove() {
                var items = [];
                $(gridSel + ' tbody tr.rm-extra-row').each(function () {
                    var $tr = $(this);
                    var $chk = $tr.find('input[type="checkbox"]');
                    if (!$chk.length || $chk.prop('disabled') || !$chk.prop('checked')) return;
                    items.push({
                        request_id: $tr.attr('data-request-id') || '',
                        rm_vendor_code: $tr.attr('data-rm-code') || '',
                        rm_vendor_email: $tr.attr('data-rm-email') || '',
                        vendor_name: $tr.attr('data-vendor-name') || '',
                        rm_vendor_name: $tr.attr('data-rm-name') || '',
                        raw_material_list: $tr.attr('data-raw-list') || '',
                        hdnccemail: $tr.attr('data-cc') || ''
                    });
                });
                $('#hdnExtraRequisitions').val(JSON.stringify(items));
            }

            $(document).on('change', gridSel + ' .rm-extra-row input[type="checkbox"]', syncExtraApprove);
            $(document).on('mousedown', '[id$="btnApprove"]', syncExtraApprove);

            function resetRequisitionScroll() {
                loadSeq++;
                pageIndex = 0;
                noMoreData = false;
                loading = false;
                captureFilters();
                bindRequisitionScroll();
                var $scroll = $(gridSel).closest('.rm-grid-scroll');
                if ($scroll.length && dataRows().length > 0 && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
            }

            captureFilters();
            bindRequisitionScroll();
            var $initial = $(gridSel).closest('.rm-grid-scroll');
            if ($initial.length && dataRows().length > 0 && $initial[0].scrollHeight <= $initial.innerHeight() + 1) loadNext($initial);

            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(resetRequisitionScroll);
            }
        });
    </script>
</asp:Content>
