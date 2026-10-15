<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VprDashboard.aspx.vb" Inherits="VprDashboard" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/css/bootstrap-select.min.css" rel="stylesheet" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js"></script>
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module .form-control.date-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
            background-color: #fff8f8 !important;
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .ajax__calendar_container TABLE {
            width: 100% !important;
        }

        .ajax__calendar_dayname {
            white-space: nowrap;
        }

        .ajax__calendar_days, .ajax__calendar_months, .ajax__calendar_years {
            width: 160px;
        }

        /* Pagination wrapper */
        .custom-pagination {
            display: flex;
            align-items: center;
            padding: 12px 5px;
            justify-content: flex-end;
        }


        /* Page label */
        .page-label {
            font-size: 14px;
            color: #374151;
            font-weight: 500;
        }


        /* Dropdown container */
        .page-dropdown + .bootstrap-select {
            width: 70px !important;
            margin: 0 8px;
        }


        /* Main dropdown button */
        .bootstrap-select .dropdown-toggle {
            height: 38px !important;
            border-radius: 8px !important;
            border: 1px solid #d1d5db !important;
            background: #ffffff !important;
            padding: 0 12px !important;
            color: #374151 !important;
            font-size: 14px !important;
            box-shadow: none !important;
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
        }


            /* Remove bootstrap default focus */
            .bootstrap-select .dropdown-toggle:focus {
                outline: none !important;
                border-color: #2563eb !important;
                box-shadow: 0 0 0 2px rgba(37,99,235,.15) !important;
            }


        /* Selected text */
        .bootstrap-select .filter-option {
            padding-top: 1px;
        }


        /* Arrow */
        .bootstrap-select .dropdown-toggle::after {
            margin-left: 8px;
            vertical-align: middle;
        }


        /* Dropdown menu */
        .bootstrap-select .dropdown-menu {
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 8px 20px rgba(0,0,0,.08);
        }


            /* Dropdown items */
            .bootstrap-select .dropdown-menu li a {
                font-size: 14px;
                padding: 8px 12px;
            }


                /* Hover */
                .bootstrap-select .dropdown-menu li a:hover {
                    background: #eff6ff;
                    color: #2563eb;
                }

        .p-page-selector {
            width: fit-content !important;
        }


            .p-page-selector .filter-option {
                display: flex;
                align-items: center;
            }

        .date-error {
            display: none;
            color: #dc3545;
            font-size: 13px;
            font-weight: 500;
            margin-top: 6px;
        }

        .rm-compact .upgradDataGrid a:not(.btn) {
            min-width: 28px !important;
            height: 28px;
            font-size: 14px;
            width: fit-content;
            border-radius: 38px;
            background: transparent;
            padding: 5px;
        }
    </style>
    <div class="rm-module rm-compact rm-brand-master">
        <script type="text/javascript">
            document.onkeydown = checkValue;
            function checkValue() {
                if (event.keyCode == 118) { // button Add (F7 keypress)
                    if (document.getElementById('btnSubmit').disabled == true)
                        return false;
                    else {
                        // button Add (F7 keypress)
                        validateSKUList();
                    }
                    //__doPostBack(document.getElementById('btnSubmit').name, '');
                }
                else if (event.keyCode == 119) {
                    __doPostBack(document.getElementById('btnCancel').name, '');
                }
            }

            function disableBackButton() {
                window.history.forward(1);
            }
        </script>
        <script type="text/javascript" src="Scripts/ValidateAddUpdate_ProductMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
        <style>
            .errormsg {
                font-size: 13px;
            }

            #<%= gvFgVendorlist.ClientID %> .vpr-skel-bar {
                display: inline-block;
                height: 12px;
                max-width: 100%;
                border-radius: 3px;
                vertical-align: middle;
                background: linear-gradient(90deg, #e3e8ee 25%, #f7f9fb 37%, #e3e8ee 63%);
                background-size: 400% 100%;
                animation: vprSkelShimmer 1.2s ease-in-out infinite;
            }

            @keyframes vprSkelShimmer {
                0% { background-position: 100% 0; }
                100% { background-position: 0 0; }
            }
        </style>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Payment Dashboard</h3>
                    <p class="pageSubTitle">Manage and evaluate your active supplier relationships.</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">

            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="rm-add-stats-row">
                            <div class="rm-add-form">
                                <div class="form-group pb-0 mb-0">

                                    <div class="rm-add-form-controls" style="align-items: flex-end">
                                        <div style="display: flex; flex-direction: column; gap: 2px">
                                            <label class="form-control-label">Search Vendor:</label>
                                            <asp:TextBox ID="txtVendorName" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" Placeholder="Enter Here"></asp:TextBox>
                                        </div>
                                        <div style="display: flex; flex-direction: column; gap: 2px">
                                            <label class="form-control-label">From Date:<span class="mandatory">*</span></label>
                                            <asp:TextBox
                                                ID="txtFromDate"
                                                runat="server"
                                                ClientIDMode="Static"
                                                CssClass="form-control"
                                                autocomplete="off"
                                                placeholder="Select From Date."
                                                onkeydown="return datePickerOnly(event, this);"
                                                onpaste="return true;"
                                                ondrop="return true;">
                                            </asp:TextBox>
                                            <ajaxToolkit:CalendarExtender
                                                ID="calFromDate"
                                                runat="server"
                                                TargetControlID="txtFromDate"
                                                Format="dd-MM-yyyy">
                                            </ajaxToolkit:CalendarExtender>
                                        </div>
                                        <div style="display: flex; flex-direction: column; gap: 2px">
                                            <label class="form-control-label">To Date:<span class="mandatory">*</span></label>
                                            <asp:TextBox
                                                ID="txtToDate"
                                                runat="server"
                                                ClientIDMode="Static"
                                                CssClass="form-control"
                                                autocomplete="off"
                                                placeholder="Select To Date."
                                                onkeydown="return datePickerOnly(event, this);"
                                                onpaste="return true;"
                                                ondrop="return true;">
                                            </asp:TextBox>
                                            <ajaxToolkit:CalendarExtender
                                                ID="calToDate"
                                                runat="server"
                                                TargetControlID="txtToDate"
                                                Format="dd-MM-yyyy">
                                            </ajaxToolkit:CalendarExtender>
                                        </div>
                                        <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" OnClientClick="return validateDateRange();" />
                                        <%-- Modified-by MUKESH BHAGAT on 01-10-2026 : Excel download removed from here - client
                                             wants it on the Dispatched / Delivered / GRN Not Done / Manual GRN / Paid detail
                                             pages (VendorReleaseReconciliation.aspx, opened via the links below), not on this
                                             summary dashboard. --%>
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-danger btn-sm" OnClick="btnReset_Click" />
                                    </div>
                                    <div id="dateError" class="date-error"></div>
                                    <asp:Label ID="valBrandName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage"
                            ClientIDMode="Static"
                            CssClass="errormsg"
                            Visible="true"
                            runat="server"
                            Style="text-align: left; font-size: 10px; font-weight: bold; color: red;"
                            Text="">
                        </asp:Label>
                    </div>
                </div>

                <div class="card rm-list-fill">
                    <div class="mst-panel-header" style="margin-bottom: 0;">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 id="panelTitle" class="mst-panel-title">Vendor List</h5>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                ID="gvFgVendorlist" runat="server" AutoGenerateColumns="false" PageSize="10" Visible="true" OnPageIndexChanging="gvFgVendorlist_PageIndexChanging" OnRowCommand="gvFgVendorlist_RowCommand"
                                ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <%--<asp:GridView
                                CssClass="table table-hover upgradDataGrid"
                                ID="gvFgVendorlist"
                                runat="server"
                                AutoGenerateColumns="false"
                                AllowPaging="false"
                                PageSize="10"
                                OnRowCommand="gvFgVendorlist_RowCommand">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />--%>
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblbrandid" runat="server" Text='<%# (gvFgVendorlist.PageIndex * gvFgVendorlist.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblbrandname" runat="server" Text='<%# Bind("unit_name") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnBrandId" runat="server" Value='<%# Bind("unit_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DISPATCHED">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblDispatched" runat="server" Text='<%# Bind("dispatched_status") %>'></asp:Label>--%>
                                            <asp:LinkButton
                                                ID="lnkDispatched"
                                                runat="server"
                                                Text='<%# Bind("approved_challan_count") %>'
                                                CommandName="Dispatched"
                                                CssClass="text-primary fw-bold">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DELIVERED">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblDelivered" runat="server" Text='<%# Bind("delivered_status") %>'></asp:Label>--%>
                                            <asp:LinkButton
                                                ID="lnkDelivered"
                                                runat="server"
                                                Text='<%# Bind("delivered_count") %>'
                                                CommandName="Delivered"
                                                CssClass="text-primary fw-bold">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="GRN Not Done">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblGrnNotDone" runat="server" Text='<%# Bind("grn_not_done") %>'></asp:Label>--%>
                                            <asp:LinkButton
                                                ID="lnkGrnNotDone"
                                                runat="server"
                                                Text='<%# Bind("grn_not_done") %>'
                                                CommandName="GrnNotDone"
                                                CssClass="text-danger fw-bold">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Manual GRN">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblmanualGrn" runat="server" Text='<%# Bind("manual_grn") %>'></asp:Label>--%>
                                            <asp:LinkButton
                                                ID="lnkManualGrn"
                                                runat="server"
                                                Text='<%# Bind("manual_grn") %>'
                                                CommandName="ManualGrn"
                                                CssClass="text-warning fw-bold">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PAID">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblPaidStatus" runat="server" Text='<%# Bind("paid_status") %>'></asp:Label>--%>
                                            <asp:LinkButton
                                                ID="lnkPaid"
                                                runat="server"
                                                Text='<%# Bind("paid_status") %>'
                                                CommandName="Paid"
                                                CssClass="text-success fw-bold">
                                            </asp:LinkButton>
                                            <%--<asp:HiddenField ID="hdnInvAmt" runat="server" Value='<%# Bind("invoice_amount") %>' />
                                            <asp:HiddenField ID="hdnAmtPaid" runat="server" Value='<%# Bind("amount_paid") %>' />--%>
                                            <asp:HiddenField ID="hfnBalAmt" runat="server" Value='<%# Bind("balance_amount") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDetails" CommandName="Details" runat="server" CssClass="text-info" ToolTip="View Details"><i class="fas fa-eye"></i></asp:LinkButton>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" CssClass="text-center" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" CssClass="text-center" />
                            </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <%--<div class="custom-pagination">

                            <div class="page-selector">

                                <span class="page-label">Page</span>

                                <asp:DropDownList
                                    ID="ddlPageNumber"
                                    runat="server"
                                    CssClass="selectpicker page-dropdown p-page-selector"
                                    data-live-search="true"
                                    data-size="5"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlPageNumber_SelectedIndexChanged">
                                </asp:DropDownList>

                                <span class="page-label">of
            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                </span>

                            </div>

                        </div>--%>
                    </div>
                </div>
                </div>
            </ContentTemplate>

            <Triggers>

                <asp:AsyncPostBackTrigger
                    ControlID="btnSubmit"
                    EventName="Click" />

                <asp:AsyncPostBackTrigger
                    ControlID="btnReset"
                    EventName="Click" />

                <%--<asp:AsyncPostBackTrigger
                    ControlID="ddlPageNumber"
                    EventName="SelectedIndexChanged" />--%>
            </Triggers>

        </asp:UpdatePanel>
        <script>
            function datePickerOnly(event, textbox) {

                // Allow Backspace/Delete to clear the field
                if (event.key === "Backspace" || event.key === "Delete") {
                    textbox.value = "";
                    return false;
                }

                // Allow Tab, Shift, Ctrl, Alt
                if (
                    event.key === "Tab" ||
                    event.key === "Shift" ||
                    event.key === "Control" ||
                    event.key === "Alt"
                ) {
                    return true;
                }

                // Block all typing
                event.preventDefault();
                return false;
            }
        </script>
        <script type="text/javascript">

            function initializePageDropdown() {

                $('.selectpicker').selectpicker();

            }


            $(document).ready(function () {

                initializePageDropdown();

            });


            // Required for ASP.NET WebForms postback / UpdatePanel
            if (typeof Sys !== "undefined") {

                Sys.WebForms.PageRequestManager.getInstance()
                    .add_endRequest(function () {

                        initializePageDropdown();

                    });

            }

        </script>
        <script>
            function validateDateRange() {

                var fromDate = document.getElementById('<%= txtFromDate.ClientID %>');
                var toDate = document.getElementById('<%= txtToDate.ClientID %>');

                var errorDiv = document.getElementById("dateError");


                // Clear previous errors
                fromDate.classList.remove("date-invalid");
                toDate.classList.remove("date-invalid");

                errorDiv.style.display = "none";
                errorDiv.innerHTML = "";


                if (fromDate.value === "" || toDate.value === "") {
                    return true;
                }


                // Convert dd-MM-yyyy to Date
                function parseDate(value) {

                    var parts = value.split("-");

                    return new Date(
                        parts[2],
                        parts[1] - 1,
                        parts[0]
                    );

                }


                var from = parseDate(fromDate.value);
                var to = parseDate(toDate.value);


                if (from > to) {

                    fromDate.classList.add("date-invalid");
                    toDate.classList.add("date-invalid");


                    errorDiv.innerHTML =
                        "From Date cannot be greater than To Date.";


                    errorDiv.style.display = "block";


                    return false;
                }


                return true;

            }
        </script>
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript">
            $(function () {
                var pageIndex = 0;
                var loading = false;
                var noMoreData = false;
                var loadSeq = 0;
                var suppressScrollUntil = 0;
                var filters = { vendor: '', fromDate: '', toDate: '' };
                var gridSel = '#<%= gvFgVendorlist.ClientID %>';

                function captureFilters() {
                    filters.vendor = $('#txtVendorName').val() || '';
                    filters.fromDate = $('#txtFromDate').val() || '';
                    filters.toDate = $('#txtToDate').val() || '';
                }

                function dataRows() {
                    return $(gridSel + ' tbody tr').not('.vpr-skel').not('.headerGrid').filter(function () {
                        return $(this).children('td[colspan]').length === 0;
                    });
                }

                function bindVendorScroll() {
                    var $el = $(gridSel).closest('.rm-grid-scroll');
                    $el.off('scroll.vprskel').on('scroll.vprskel', function () {
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
                    showVendorSkeleton($el);

                    PageMethods.GetMoreVendorPayments(pageIndex, filters.vendor, filters.fromDate, filters.toDate,
                        function (result) {
                            if (seq !== loadSeq) return;
                            hideVendorSkeleton();
                            if (!result || !result.rows || result.rows.length === 0) {
                                noMoreData = true;
                                loading = false;
                                return;
                            }
                            var $tbody = $(gridSel + ' tbody');
                            $.each(result.rows, function (i, r) {
                                appendVendorRow($tbody, r);
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
                            hideVendorSkeleton();
                            pageIndex--;
                            loading = false;
                        }
                    );
                }

                function showVendorSkeleton($scroll) {
                    var $tbody = $(gridSel + ' tbody');
                    if (!$tbody.length || $tbody.find('tr.vpr-skel').length) return;

                    var nameWidths = ['72%', '60%', '80%'];
                    var html = '';
                    for (var r = 0; r < 3; r++) {
                        html += '<tr class="tlrowlight vpr-skel">';
                        html += '<td align="center" style="width:8%;"><span class="vpr-skel-bar" style="width:16px;"></span></td>';
                        html += '<td align="left" style="width:40%;"><span class="vpr-skel-bar" style="width:' + nameWidths[r] + ';"></span></td>';
                        html += '<td align="left" style="width:10%;"><span class="vpr-skel-bar" style="width:28px;"></span></td>';
                        html += '<td align="left" style="width:10%;"><span class="vpr-skel-bar" style="width:24px;"></span></td>';
                        html += '<td align="left" style="width:10%;"><span class="vpr-skel-bar" style="width:28px;"></span></td>';
                        html += '<td align="left" style="width:10%;"><span class="vpr-skel-bar" style="width:22px;"></span></td>';
                        html += '<td align="left" style="width:10%;"><span class="vpr-skel-bar" style="width:24px;"></span></td>';
                        html += '</tr>';
                    }
                    $tbody.append(html);
                    suppressScrollUntil = Date.now() + 200;
                    if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
                }

                function hideVendorSkeleton() {
                    var $rows = $(gridSel + ' tbody tr.vpr-skel');
                    if (!$rows.length) return;
                    suppressScrollUntil = Date.now() + 200;
                    $rows.remove();
                }

                function appendVendorRow($tbody, r) {
                    var slNo = dataRows().length + 1;
                    $tbody.append(
                        '<tr class="tlrowlight">' +
                        '<td align="center" style="width:8%;">' + slNo + '</td>' +
                        '<td align="left" style="width:40%;">' + esc(r.unit_name) + '</td>' +
                        '<td align="left" style="width:10%;">' + metricLink('text-primary fw-bold', 'Dispatched', r.approved_challan_count, r) + '</td>' +
                        '<td align="left" style="width:10%;">' + metricLink('text-primary fw-bold', 'Delivered', r.delivered_count, r) + '</td>' +
                        '<td align="left" style="width:10%;">' + metricLink('text-danger fw-bold', 'GrnNotDone', r.grn_not_done, r) + '</td>' +
                        '<td align="left" style="width:10%;">' + metricLink('text-warning fw-bold', 'ManualGrn', r.manual_grn, r) + '</td>' +
                        '<td align="left" style="width:10%;">' + metricLink('text-success fw-bold', 'Paid', r.paid_status, r) + '</td>' +
                        '</tr>'
                    );
                }

                function metricLink(css, flag, text, r) {
                    return '<a href="#" class="' + css + ' vpr-more-link" data-flag="' + escAttr(flag) + '" data-code="' + escAttr(r.unit_code) + '" data-vendor="' + escAttr(r.unit_name) + '">' + esc(text) + '</a>';
                }

                function esc(v) {
                    return $('<div>').text(v == null ? '' : v).html();
                }

                function escAttr(v) {
                    return esc(v).replace(/"/g, '&quot;');
                }

                $(document).on('click', gridSel + ' .vpr-more-link', function (e) {
                    e.preventDefault();
                    var $a = $(this);
                    window.location.href = 'VendorReleaseReconciliation.aspx'
                        + '?vendorName=' + encodeURIComponent($a.attr('data-vendor') || '')
                        + '&vendorCode=' + encodeURIComponent($a.attr('data-code') || '')
                        + '&fromDate=' + encodeURIComponent($('#txtFromDate').val() || '')
                        + '&toDate=' + encodeURIComponent($('#txtToDate').val() || '')
                        + '&flag=' + encodeURIComponent(($a.attr('data-flag') || '').toUpperCase());
                });

                function resetVendorScroll() {
                    loadSeq++;
                    pageIndex = 0;
                    noMoreData = false;
                    loading = false;
                    captureFilters();
                    bindVendorScroll();
                    var $scroll = $(gridSel).closest('.rm-grid-scroll');
                    if ($scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                }

                captureFilters();
                bindVendorScroll();
                var $initial = $(gridSel).closest('.rm-grid-scroll');
                if ($initial.length && $initial[0].scrollHeight <= $initial.innerHeight() + 1) loadNext($initial);

                if (typeof Sys !== 'undefined' && Sys.WebForms) {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(resetVendorScroll);
                }
            });
        </script>
</asp:Content>

