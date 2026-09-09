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
                    <div class="mst-panel-header">
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
                                ID="gvFgVendorlist" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true" OnPageIndexChanging="gvFgVendorlist_PageIndexChanging" OnRowCommand="gvFgVendorlist_RowCommand"
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
                                                Text='<%# Bind("delivered_qty") %>'
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
                                            <asp:HiddenField ID="hdnInvAmt" runat="server" Value='<%# Bind("invoice_amount") %>' />
                                            <asp:HiddenField ID="hdnAmtPaid" runat="server" Value='<%# Bind("amount_paid") %>' />
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
</asp:Content>

