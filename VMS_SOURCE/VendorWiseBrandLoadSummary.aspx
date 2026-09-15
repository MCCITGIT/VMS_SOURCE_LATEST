<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorWiseBrandLoadSummary.aspx.vb" Inherits="VendorWiseBrandLoadSummary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/css/bootstrap-select.min.css" rel="stylesheet" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js"></script>

    <%-- Modified-by MUKESH BHAGAT on 15-09-2026 : Serviceability (%) shown as a colored status
         pill instead of plain text - same 4-tier thresholds/colors already used for the Dispatch %
         badge on Home.aspx / VendorWiseLoadSummary.aspx, so "orange" and "red" mean the same
         severity everywhere in the app. Colored in code-behind (gvFgVendorlist_RowDataBound). --%>
    <style>
        .pct-pill {
            display: inline-block;
            min-width: 52px;
            padding: 4px 8px;
            border-radius: 12px;
            color: #fff;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
        }

        .pct-pill-danger {
            background: #e74c3c;
        }

        .pct-pill-warning {
            background: #f39c12;
        }

        .pct-pill-info {
            background: #f1c40f;
        }

        .pct-pill-success {
            background: #27ae60;
        }
    </style>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap');

        /* ---------- Table container ---------- */
        .rm-brand-master .rm-grid-scroll {
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 2px 12px rgba(30, 60, 90, .12);
            overflow: auto;
            padding: 0 !important;
        }

        .rm-brand-master table.upgradDataGrid {
            width: 100%;
            margin: 0 !important;
            border: none !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            background: #fff;
            font-family: 'Nunito', 'Segoe UI', sans-serif;
        }

        /* ---------- Header (original colors kept) ---------- */
        .rm-brand-master .upgradDataGrid tr.headerGrid th {
            position: sticky;
            top: 0;
            z-index: 2;
            padding: 12px 14px !important;
            white-space: nowrap;
        }

            .rm-brand-master .upgradDataGrid tr.headerGrid th::before {
                font-family: "Font Awesome 6 Free", "Font Awesome 5 Free";
                font-weight: 900;
                font-size: 11px;
                margin-right: 7px;
            }

            .rm-brand-master .upgradDataGrid tr.headerGrid th:nth-child(1)::before {
                content: "\f292";
            }

            .rm-brand-master .upgradDataGrid tr.headerGrid th:nth-child(2)::before {
                content: "\f54e";
            }

            .rm-brand-master .upgradDataGrid tr.headerGrid th:nth-child(3)::before {
                content: "\f466";
            }

            .rm-brand-master .upgradDataGrid tr.headerGrid th:nth-child(4)::before {
                content: "\f0d1";
            }

            .rm-brand-master .upgradDataGrid tr.headerGrid th:nth-child(5)::before {
                content: "\f201";
            }

        /* ---------- Rows ---------- */
        .rm-brand-master .upgradDataGrid tr.tlrowlight {
            background: #fff !important;
            border: none !important;
            box-shadow: none !important;
        }

            .rm-brand-master .upgradDataGrid tr.tlrowlight td {
                background: #fff !important;
                color: #5b6b82;
                font-size: 13px;
                padding: 10px 14px !important;
                border: none !important;
                border-bottom: 1px solid #e6ebf1 !important;
                box-shadow: none !important;
                vertical-align: middle !important;
                transition: background .15s ease;
            }

            .rm-brand-master .upgradDataGrid tr.tlrowlight:last-child td {
                border-bottom: none !important;
            }

            .rm-brand-master .upgradDataGrid tr.tlrowlight:hover td {
                background: #f4f9fe !important;
            }

            /* Sl No */
            .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(1) {
                color: #8a97a8;
                font-weight: 600;
            }

            /* Vendor name with avatar circle */
            .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(2) > span {
                display: inline-flex;
                align-items: center;
                gap: 12px;
                color: #4f6282;
                font-weight: 600;
            }

                .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(2) > span::before {
                    content: "\f54e";
                    font-family: "Font Awesome 6 Free", "Font Awesome 5 Free";
                    font-weight: 900;
                    font-size: 13px;
                    flex-shrink: 0;
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    background: #e8f4fd;
                    color: #1da1f2;
                    box-shadow: 0 0 0 2px #fff, 0 1px 5px rgba(0, 0, 0, .15);
                }

            /* Total Load / Dispatched */
            .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(3) {
                color: #4f6282;
                font-weight: 600;
                font-variant-numeric: tabular-nums;
            }

            .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(4) {
                color: #6b7a90;
                font-variant-numeric: tabular-nums;
            }

            /* ---------- Serviceability column ---------- */
            .rm-brand-master .upgradDataGrid tr.tlrowlight td:nth-child(5) {
                white-space: nowrap;
                text-align: center !important;
            }

        /* Pill (percentage text, sits below the bar) */
        .pct-pill {
            /* bar settings */
            --stick: 5px; /* stick width */
            --gap: 4px; /* space between sticks */
            --bar-h: 18px; /* stick height */
            --bar-w: calc(var(--stick) * 10 + var(--gap) * 9); /* exactly 10 sticks */
            --n: 0; /* filled sticks (set per tier) */
            position: relative;
            display: inline-block;
            min-width: 64px;
            margin-top: calc(var(--bar-h) + 8px); /* room for the bar above */
            padding: 3px 10px;
            border-radius: 10px;
            color: #fff;
            font-size: 12px;
            font-weight: 600;
            line-height: 1.3;
            text-align: center;
            letter-spacing: .3px;
        }

            /* Bar: track + fill, centered above the pill */
            .pct-pill::before,
            .pct-pill::after {
                content: "";
                position: absolute;
                top: calc(-1 * (var(--bar-h) + 6px));
                left: 50%;
                margin-left: calc(var(--bar-w) / -2);
                height: var(--bar-h);
                pointer-events: none;
            }

            /* Track: 10 gray sticks */
            .pct-pill::before {
                width: var(--bar-w);
                background: repeating-linear-gradient(90deg, #dfe5ec 0 var(--stick), transparent var(--stick) calc(var(--stick) + var(--gap)));
                border: 1px solid #ffa9a9;
            }

            /* Fill: colored sticks, count set from code-behind (pct-n-0 ... pct-n-10) */
            .pct-pill::after {
                width: max(0px, calc(var(--n) * (var(--stick) + var(--gap)) - var(--gap)));
                max-width: var(--bar-w);
                background: repeating-linear-gradient(90deg, var(--bar-color, #7f8fa6) 0 var(--stick), transparent var(--stick) calc(var(--stick) + var(--gap)));
                animation: svcGrow .6s ease-out;
            }

        @keyframes svcGrow {
            from {
                width: 0;
            }
        }

        /* Tier colors: pill + stick color */
        .pct-pill-danger {
            background: #e7483b;
            --bar-color: #e7483b;
        }

        .pct-pill-warning {
            background: #ef9e40;
            --bar-color: #ef9e40;
        }

        .pct-pill-info {
            background: #c9c78a;
            --bar-color: #b5a91c;
        }

        .pct-pill-success {
            background: #9cc9a3;
            --bar-color: #2e9e5b;
        }

        /* Number of filled sticks (out of 10) */
        .pct-pill.pct-n-0 {
            --n: 0;
        }

        .pct-pill.pct-n-1 {
            --n: 1;
        }

        .pct-pill.pct-n-2 {
            --n: 2;
        }

        .pct-pill.pct-n-3 {
            --n: 3;
        }

        .pct-pill.pct-n-4 {
            --n: 4;
        }

        .pct-pill.pct-n-5 {
            --n: 5;
        }

        .pct-pill.pct-n-6 {
            --n: 6;
        }

        .pct-pill.pct-n-7 {
            --n: 7;
        }

        .pct-pill.pct-n-8 {
            --n: 8;
        }

        .pct-pill.pct-n-9 {
            --n: 9;
        }

        .pct-pill.pct-n-10 {
            --n: 10;
        }

        /* 0% = all 10 sticks gray */
        .pct-pill.pct-n-0::after {
            display: none;
        }
    </style>
    </style>
    </style>

    <div class="rm-module rm-compact rm-brand-master">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Wise Brand Load</h3>
                    <p class="pageSubTitle">View vendor-wise dispatched and pending loads</p>
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
                                        <div style="display: flex; flex-direction: column; gap: 2px; min-width: 35%;">
                                            <label class="form-control-label">Brand:</label>
                                            <asp:TextBox ID="txtBrand" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off"></asp:TextBox>
                                        </div>
                                        <div style="display: flex; flex-direction: column; gap: 2px">
                                            <label class="form-control-label">Search Vendor:</label>
                                            <asp:TextBox ID="txtVendor" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" Placeholder="Enter Here"></asp:TextBox>
                                        </div>
                                        <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-danger btn-sm" OnClick="btnReset_Click" />
                                        <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" OnClick="btnBack_Click" />
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
                                <h5 id="panelTitle" class="mst-panel-title">Product List</h5>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                ID="gvFgVendorlist" runat="server" AutoGenerateColumns="false" Visible="true"
                                ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                                OnRowDataBound="gvFgVendorlist_RowDataBound">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
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

                                            <asp:Label ID="lblVendorName"
                                                runat="server"
                                                Text='<%# Bind("vendor_name") %>'>
                                            </asp:Label>

                                            <asp:HiddenField ID="hdnVendorCode"
                                                runat="server"
                                                Value='<%# Bind("vendor_code") %>' />

                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="35%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="35%" CssClass="text-left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Total Load">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTotalLoad"
                                                runat="server"
                                                Text='<%# Bind("total_load") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Dispatched">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDispatched"
                                                runat="server"
                                                Text='<%# Bind("total_despatched") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Serviceability (%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblServiceability"
                                                runat="server"
                                                Text='<%# Bind("serviceability_percentage") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" CssClass="text-center" />
                                    </asp:TemplateField>
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
    </div>
</asp:Content>

