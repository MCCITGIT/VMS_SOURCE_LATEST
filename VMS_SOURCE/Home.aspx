<%@ Page Title="Dashboard" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Home.aspx.vb" Inherits="Home" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--  start chart--%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="includes/home-dashboard.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />

    <%-- Modified-by MUKESH BHAGAT on 14-09-2026 : draws the "Overall Serviceability" donut from
         data-dispatch/data-pending on #skuOverallChart (set server-side in Home.aspx.vb
         BuildSkuSummaryPanel - see its comment for why this moved out of a per-render inline
         script). Registered ONCE here, not regenerated per postback: runs on first page load
         (DOMContentLoad) and on every async postback after that via
         Sys.WebForms.PageRequestManager's add_endRequest - the same pattern already used on
         UnitDespatchPlanAddUpdateVr1.aspx for "re-run this after every partial postback". --%>
    <script type="text/javascript">
        function renderSkuDonut() {
            var el = document.getElementById('skuOverallChart');
            if (!el || typeof Chart === 'undefined') { return; }
            var dispatch = parseFloat(el.getAttribute('data-dispatch')) || 0;
            var pending = parseFloat(el.getAttribute('data-pending')) || 0;
            var existing = Chart.getChart ? Chart.getChart(el) : null;
            if (existing) { existing.destroy(); }
            new Chart(el, {
                type: 'doughnut',
                data: {
                    labels: ['Dispatched', 'Pending'],
                    datasets: [{
                        data: [dispatch, pending],
                        backgroundColor: ['#0ca30c', '#e9ecef'],
                        borderColor: '#ffffff',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: false,
                    cutout: '68%',
                    plugins: { legend: { display: false }, tooltip: { enabled: (dispatch + pending) > 0 } }
                }
            });
        }
        document.addEventListener('DOMContentLoaded', renderSkuDonut);
        if (typeof Sys !== 'undefined' && Sys.WebForms) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(renderSkuDonut);
        }
    </script>

    <style>
        .legend {
            display: flex;
            gap: 20px;
            margin: 12px 0;
            font-size: 13px;
            color: #333;
        }

            .legend > div {
                display: flex;
                align-items: center;
                gap: 6px;
            }

        .dot {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            flex-shrink: 0;
        }

            .dot.total-load {
                background: #2f8fd6; /* same blue as bar-fill.total-load */
            }

            .dot.total-dispatch {
                background: #2ecc71; /* same green as bar-fill.total-dispatch */
            }

        /* Modified-by MUKESH BHAGAT on 14-09-2026 : chart and list back on the same row (per
           explicit confirmation) - the donut column takes some width from the list again, so the
           label is the part that gives: it shrinks and truncates with an ellipsis (full name on
           hover via title=) rather than the row wrapping to two lines or overflowing into a
           clipped horizontal scroll. */
        .sku-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .sku-label {
            flex: 1 1 auto;
            min-width: 40px;
            font-size: 13px;
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis; /* full name still available on hover via the title attribute */
        }

        /* Modified-by MUKESH BHAGAT on 14-09-2026 : replaced .sku-bars / .bar-track / .bar-fill
           (two overlapping progress bars) with a 10-dot pictogram. 1 dot = SKU's Total_Load_NOP / 10;
           dispatch fills dots left to right, with a partial (pie-style) fill for a dot that isn't
           fully dispatched, built server-side in Home.aspx.vb BindLoadDispatchChart(). */
        .sku-dots {
            display: flex;
            align-items: center;
            gap: 5px;
            flex: 0 0 auto;
        }

        .sku-dot {
            box-sizing: border-box; /* 14-09-2026: keeps the bordered empty dot the same 16x16
                                       outer size as the borderless full/partial dots, so all 10
                                       stay on one vertical line instead of the border pushing the
                                       empty dot's box to 19x19 and knocking it out of alignment */
            width: 16px;
            height: 16px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .sku-dot-full {
            background: #0ca30c;
        }

        .sku-dot-empty {
            background: transparent;
            border: 1.5px solid #2f8fd6;
            opacity: 0.55;
        }

        .sku-stats {
            flex: 0 0 auto;
            white-space: nowrap;
            font-size: 12px;
            color: #444;
        }

        .pending-value {
            color: #444;
        }

            .pending-value.pending-active {
                color: #e74c3c; /* flag nonzero pending in red so it stands out */
            }

        .sku-badge {
            min-width: 52px;
            padding: 4px 8px;
            border-radius: 12px;
            color: #fff;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
        }

        .badge-danger {
            background: #e74c3c;
        }

        .badge-warning {
            background: #f39c12;
        }

        .badge-info {
            background: #f1c40f;
        }

        .badge-success {
            background: #27ae60;
        }

        /* Modified-by MUKESH BHAGAT on 14-09-2026 : side-by-side again - list on the left, overall
           serviceability donut on the right, per explicit confirmation after trying both. */
        .sku-panel-row {
            display: flex;
            align-items: stretch;
            gap: 24px;
        }

        .sku-list-col {
            flex: 1 1 68%;
            min-width: 0; /* lets the row shrink instead of overflowing when the card narrows */
        }

        .sku-summary-col {
            flex: 1 1 32%;
            min-width: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-left: 1px solid #f0f0f0;
            padding-left: 20px;
        }

        .sku-summary-inner {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
            width: 100%;
        }

        .sku-summary-title {
            font-size: 12px;
            font-weight: 600;
            color: #888;
            letter-spacing: .3px;
            text-transform: uppercase;
        }

        .sku-donut-wrap {
            /* Modified-by MUKESH BHAGAT on 14-09-2026 : the ring itself wasn't visible - the
               "pending" slice used #dce6f0, too close to the white card to render as anything but
               blank space. Switched to the same gray the old bar-track used (proven visible on
               this card elsewhere) and added a faint outline here so the ring reads even when the
               dispatched share is tiny (a few % green sliver against a near-white remainder).
               Shrunk to 130px so the side column stays a reasonable width next to the list.
               Chart is drawn non-responsive at this exact pixel size (set in
               BuildSkuSummaryPanel) so there's no resize-observer timing to race against on the
               next async postback (vendor/year/month search). */
            position: relative;
            width: 130px;
            height: 130px;
            border-radius: 50%;
            box-shadow: inset 0 0 0 1px #eef1f4;
        }

        .sku-donut-center {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            pointer-events: none;
        }

        .sku-donut-pct {
            font-size: 20px;
            font-weight: 700;
            line-height: 1.1;
        }

        .sku-donut-caption {
            font-size: 11px;
            color: #999;
            margin-top: 2px;
        }

        .sku-summary-stats {
            display: flex;
            flex-direction: column;
            gap: 6px;
            font-size: 13px;
            color: #444;
            width: 100%;
        }

            .sku-summary-stats > div {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 10px;
            }

            .sku-summary-stats .dot {
                margin-right: 6px;
            }

        @media (max-width: 820px) {
            .sku-panel-row {
                flex-direction: column;
            }

            .sku-summary-col {
                border-left: none;
                border-top: 1px solid #f0f0f0;
                padding-left: 0;
                padding-top: 20px;
            }
        }
        .p-pdl-select-box > span{
            min-width: 200px !important;
        }
        .p-pdl-select-box span ul li.select2-results__option {
            text-align: center;
        }
    </style>

    <%-- For Lazy Loading --%>
    <style>
        .rm-grid-scroll {
            max-height: 400px;
            overflow-y: auto;
        }
    </style>

    <div class="vms-home">

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Dashboard</h3>
                    <p class="pageSubTitle">Despatch, pending load and vendor insights</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <asp:Literal ID="litPending" runat="server" Visible="false"></asp:Literal>
                <asp:Literal ID="litDespatch" runat="server" Visible="false">></asp:Literal>

                <div id="divSearch" class="card" runat="server">
                    <div class="card-body">
                        <div runat="server">
                            <div class="row align-items-center">
                                <div id="divVendor" class="col-md-3" runat="server">
                                    <div class="form-group">
                                        <label class="form-control-label">Vendor:</label>
                                        <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Process Year:</label>
                                        <asp:DropDownList ID="ddlProcessYr" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Process Month:</label>
                                        <asp:DropDownList ID="ddlProcessMnth" CssClass="form-control select2" runat="server">
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
                                    <%--<asp:Button ID="btnSearch" runat="server"
                                Text="Search"
                                CssClass="btn btn-primary btn-sm mt-2"
                                OnClick="btnSearch_Click" />--%>
                                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm rmp-btn-icon" ToolTip="Search" OnClick="btnSearch_Click"><i class="fas fa-search"></i></asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divNewsCard" class="card" runat="server">
                    <div class="card-body">
                        <div class="row" runat="server">
                            <div class="col-md-12">
                                <div class="flashComplainBTCCard">
                                    <div class="newCard w100 home-card-flash">
                                        <div class="newCardHead">
                                            <h3 class="newHeadTitle">Flash News</h3>
                                        </div>
                                        <div class="newCardBody">
                                            <div class="noRecordFnew" id="news_marquee_scroll" runat="server">No new updates at the moment.</div>
                                        </div>
                                    </div>
                                    <a class="complainBTCCard" id="tblComplainRegistrationLink" runat="server" href="https://bpilsharepoint1.bergerindia.com:97" target="_blank" title="For Product Complaint Click Here">
                                        <div class="newCard">
                                            <i class="fas fa-comment-dots cbtcImg"></i>
                                            <p>Complain/BTC</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--Modified-by MUKESH BHAGAT on 20-08-2026 : restored from old UAT source (Action Required panel and Last Stock Update Date)--%>
                <div id="divAction" class="card" runat="server">
                    <div class="card-body">
                        <div class="row" runat="server">
                            <div class="col-md-8">
                                <div class="newCard w100 home-card-action">
                                    <div class="newCardHead">
                                        <h3 class="newHeadTitle">Action Required</h3>
                                    </div>
                                    <div class="newCardBody">
                                        <div id="tdActionReq" runat="server" class="home-action-list"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="newCard w100 home-card-stock">
                                    <div class="newCardHead">
                                        <h3 class="newHeadTitle">Stock As On</h3>
                                    </div>
                                    <div class="newCardBody">
                                        <div class="home-stock-chip">
                                            <asp:Label ID="lblLastStockUpdateDate" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divSumData" class="card" runat="server">
                    <div class="card-body">
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                <div class="newCard w100 home-card-action">
                                    <div class="newCardHead">
                                        <h3 class="newHeadTitle">Brand Wise</h3>
                                    </div>
                                    <div class="newCardBody">
                                        <div class="table-responsive rm-grid-scroll">
                                            <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                                ID="gvBrandList" runat="server" AutoGenerateColumns="false" PageSize="10" Visible="true" OnRowCommand="gvBrandList_RowCommand"
                                                ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                                <RowStyle CssClass="tlrowlight" />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <FooterStyle CssClass="footerGrid" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Sl No">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblbrandid" runat="server" Text='<%# (gvBrandList.PageIndex * gvBrandList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Brand Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblBrandName" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTotalLoad" runat="server" Text='<%# Bind("total_load") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Despatched">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTotalDes" runat="server" Text='<%# Bind("total_despatched") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Serviceability(%)">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblKg" runat="server" Text='<%# Bind("serviceability_percentage") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbView"
                                                                runat="server"
                                                                Text="View"
                                                                CssClass="btn btn-sm btn-primary"
                                                                CommandName="ViewBrand">
                                                                <i class="fa fa-arrow-right"></i>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="newCard w100 home-card-stock">
                                    <div class="newCardHead">
                                        <h3 class="newHeadTitle">Vendor Wise</h3>
                                    </div>
                                    <div class="newCardBody">
                                        <div class="table-responsive rm-grid-scroll">
                                            <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                                ID="gvVendorList" runat="server" AutoGenerateColumns="false" PageSize="10" Visible="true" OnRowCommand="gvVendorList_RowCommand"
                                                ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                                <RowStyle CssClass="tlrowlight" />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <FooterStyle CssClass="footerGrid" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Sl No">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblbrandid" runat="server" Text='<%# (gvVendorList.PageIndex * gvVendorList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Vendor Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                                            <asp:HiddenField ID="hdnVednorCode" runat="server" Value='<%# Bind("vendor_unit")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTotalLoad" runat="server" Text='<%# Bind("Total_Load_NOP") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Despatched">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTotalDes" runat="server" Text='<%# Bind("Total_Despatched_NOP") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Serviceability(%)">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblKg" runat="server" Text='<%# Bind("Dispatch_Percentage") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbViewVendor"
                                                                runat="server"
                                                                Text="View"
                                                                CssClass="btn btn-sm btn-primary"
                                                                CommandName="ViewVendor">
                                                                <i class="fa fa-arrow-right"></i>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--<div id="divData" runat="server">
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
                                ID="gvPendingDespatchList" runat="server" AutoGenerateColumns="false" PageSize="10" Visible="true"
                                ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblbrandid" runat="server" Text='<%# (gvPendingDespatchList.PageIndex * gvPendingDespatchList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU Code">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSkuCode" runat="server" Text='<%# Bind("sku_code") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnUnitCode" runat="server" Value='<%# Bind("unit_code")%>' />
                                            <asp:HiddenField ID="hdnUnitname" runat="server" Value='<%# Bind("unit_name")%>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" CssClass="text-left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="LTR">
                                        <ItemTemplate>
                                            <asp:Label ID="lblLtr" runat="server" Text='<%# Bind("total_ltr") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KG">
                                        <ItemTemplate>
                                            <asp:Label ID="lblKg" runat="server" Text='<%# Bind("total_kg") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Pending NOP">
                                        <ItemTemplate>
                                            <asp:Label ID="lblKg" runat="server" Text='<%# Bind("pending_nop") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>--%>
                <div id="divSkuChart" class="card" runat="server">
                    <div class="card-body">
                        <div class="dashboard" runat="server">
                            <div class="mst-panel-header">
                                <div class="mst-panel-header-left">
                                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                                    <div>
                                        <h5 id="ChartTitle" class="mst-panel-title">SKU List</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="legend">
                                <div><span class="dot total-load"></span>Total Load</div>
                                <div><span class="dot total-dispatch"></span>Total Dispatch</div>
                            </div>
                            <%-- Modified-by MUKESH BHAGAT on 14-09-2026 : card split in half - the SKU
                                 list on the left, an overall Total Load vs Total Dispatch donut with the
                                 serviceability % in the centre on the right. Donut markup and its Chart.js
                                 script are built server-side in BindLoadDispatchChart() (litSkuSummary),
                                 same pattern as the SKU rows (litSkuRows), so both refresh together on
                                 every vendor/year/month search postback. --%>
                            <div class="sku-panel-row">
                                <div class="sku-list-col">
                                    <div id="chartContainer" style="height: 250px; overflow-y: auto;">
                                        <asp:Literal ID="litSkuRows" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <div class="sku-summary-col">
                                    <asp:Literal ID="litSkuSummary" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divDespatch" class="card" runat="server">
                    <div class="card-body">
                        <div runat="server">
                            <div class="mst-panel-header">
                                <div class="mst-panel-header-left">
                                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                                    <div>
                                        <h5 id="DespatchTitle" class="mst-panel-title">Pending Despatch List</h5>
                                    </div>
                                </div>
                                <div class="p-pdl-select-box" style="display: flex; align-items: center; column-gap: 5px;">
                                    <asp:DropDownList ID="ddlVendorList" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendorList_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:Button ID="btnResetVendorFilter" runat="server"
                                        Text="Reset"
                                        CssClass="btn btn-sm btn-outline-secondary" OnClick="btnResetVendorFilter_Click" />
                                </div>
                            </div>
                            <div class="table-responsive rm-grid-scroll">
                                <asp:GridView ID="gvVendorDispatch" runat="server" AutoGenerateColumns="false" OnRowCommand="gvVendorDispatch_RowCommand" ClientIDMode="Static"
                                    Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Vendor Name" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vm_vendor_name") %>'></asp:Label>
                                                <asp:HiddenField ID="hdnVednorCode" runat="server" Value='<%# Bind("ddrh_vendor_id")%>' />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Depot" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDepot" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Order Sl No." HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOrderId" runat="server" Text='<%# Bind("ddrh_order_sl_no") %>'></asp:Label>
                                                <asp:Label ID="lblRequestId" Visible="false" runat="server" Text='<%# Bind("ddrh_hdr_req_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Request Date" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequestDate" runat="server" Text='<%# Bind("ReqDate") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Despatch To" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("vom_org_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                        </asp:TemplateField>
                                        <%--<asp:TemplateField HeaderText="Transporter Name" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTransporter" runat="server" Text='<%# Bind("tm_transporter_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                        </asp:TemplateField>--%>


                                        <asp:TemplateField HeaderText="Truck" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lbllm_desc" runat="server" Text='<%# Bind("lm_desc") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <%--<asp:TemplateField HeaderText="Status" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>--%>

                                        <%--<asp:TemplateField HeaderText="View" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Button ID="btnViewDetails" CommandName="ViewDetails" CssClass="btn btn-info btn-   sm"
                                        runat="server" CommandArgument='<%# Bind("ddrh_hdr_req_id") %>' Text="View" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="4%" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                            </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row" runat="server" id="divUnit"></div>
                <div class="row" runat="server" id="divDepot"></div>

                <div class="row" runat="server" id="divHo">
                    <div class="col-md-8">
                        <div class="dbQuikCardList">
                            <div class="loopQuikCars qk-despatch">
                                <div class="qk-top">
                                    <h3 class="quikName">Total Despatch (Vol)</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-box-open quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblTotalDespatch">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="quikLink" OnClick="lnkViewDetails_Click">
                                   View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-pending">
                                <div class="qk-top">
                                    <h3 class="quikName">Pending load (Vol)</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-hourglass-start quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblPendingLoad">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkPendingLoadDetails" runat="server" CssClass="quikLink" OnClick="lnkPendingLoadDetails_Click">
                                 View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-complaints">
                                <div class="qk-top">
                                    <h3 class="quikName">Vendor Complaints</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-vector-square quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblVendorComplaints">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkVendorComplaintDetails" runat="server" CssClass="quikLink" OnClick="lnkVendorComplaintDetails_Click">
    View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-docs" style="display: none;">
                                <div class="qk-top">
                                    <h3 class="quikName">New Documents</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-campground quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblNewDoc">0</asp:Label>
                                    </div>
                                </div>
                                <a class="quikLink">View Details <i class="fas fa-chevron-right"></i></a>
                            </div>

                            <div class="loopQuikCars qk-expired">
                                <div class="qk-top">
                                    <h3 class="quikName">Expired Documents</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-folder-minus quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblExpDoc">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkExpieredDoc" runat="server" CssClass="quikLink" OnClick="lnkExpieredDoc_Click">
    View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-indent">
                                <div class="qk-top">
                                    <h3 class="quikName">Unapproved indent</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-campground quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblUnapprovedIndent">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkUnapproveIndent" runat="server" CssClass="quikLink" OnClick="lnkUnapproveIndent_Click">
                                  View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-challan">
                                <div class="qk-top">
                                    <h3 class="quikName">Unapproved Despatch Challans</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-shekel-sign quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblUnapprovedDespatch">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkUnapprovedDespatch" runat="server" CssClass="quikLink" OnClick="lnkUnapprovedDespatch_Click">
                                  View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-legal">
                                <div class="qk-top">
                                    <h3 class="quikName">Unapproved Legal/Statutory</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-weight-hanging quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblUnapprovedLegal">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkUnApprovedDoc" runat="server" CssClass="quikLink" OnClick="lnkUnApprovedDoc_Click">
    View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-audit">
                                <div class="qk-top">
                                    <h3 class="quikName">Audited Vendor</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-stopwatch-20 quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblAuditedVendorCount">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkAuditCount" runat="server" CssClass="quikLink" OnClick="lnkAuditCount_Click">
    View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>

                            <div class="loopQuikCars qk-sample">
                                <div class="qk-top">
                                    <h3 class="quikName">Sample Tested Vendor</h3>
                                    <span class="qk-gauge" aria-hidden="true"></span>
                                </div>
                                <div class="quikFungView">
                                    <div class="quikImgView">
                                        <i class="fas fa-universal-access quikImg"></i>
                                    </div>
                                    <div class="quikDtls">
                                        <asp:Label class="quikNo" runat="server" ID="lblSampleTestedVendorCount">0</asp:Label>
                                    </div>
                                </div>
                                <asp:LinkButton ID="lnkSampleTestedCount" runat="server" CssClass="quikLink" OnClick="lnkSampleTestedCount_Click">
    View Details <i class="fas fa-chevron-right"></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                        <div class="newCard home-card-chart">
                            <div class="newCardHead">
                                <h3 class="newHeadTitle">2025-2026 Despatch and Pending load</h3>
                            </div>
                            <div class="newCardBody">
                                <div id="chart-container" class="home-chart-frame">
                                    <canvas id="salesChart" style="width: 100% !important; height: 228px !important;"></canvas>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-md-4">
                        <div class="newCard home-card-links">
                            <div class="newCardHead">
                                <h3 class="newHeadTitle">Quick Links</h3>
                            </div>
                            <div class="newCardBody">
                                <div class="menu" role="menu" aria-label="Quick menu" id="tblQuickMenu" runat="server"></div>

                                <ul class="qukLinkNav" id="tdQuickLink" runat="server" style="display: none"></ul>
                            </div>
                        </div>
                        <div class="newCard home-card-vendor-ty">
                            <div class="newCardHead">
                                <h3 class="newHeadTitle">Top 4 Vendor(TY)</h3>
                            </div>
                            <div class="newCardBody">
                                <div class="table-responsive tvlGridHt">
                                    <asp:GridView ID="gvTopvendor" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0 custGvTopvendorGrid" CellSpacing="0" CellPadding="0">
                                        <RowStyle CssClass="tlrowlight" />
                                        <SelectedRowStyle />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Vendor">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_vendor_name" runat="server" Text='<%# Bind("ty_vendor") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Position">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("ty_vendor_rank") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="newCard home-card-vendor-ly">
                            <div class="newCardHead">
                                <h3 class="newHeadTitle">Top 4 Vendor(LY)</h3>
                            </div>
                            <div class="newCardBody">
                                <div class="table-responsive tvlGridHt">
                                    <asp:GridView ID="gvTop3Vend" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0 custGvTopvendorGrid" CellSpacing="0" CellPadding="0">
                                        <RowStyle CssClass="tlrowlight" />
                                        <SelectedRowStyle />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Vendor">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_vendor_name" runat="server" Text='<%# Bind("ly_vendor") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Position">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("ly_vendor_rank") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="newCard home-card-vendor-lvl">
                            <div class="newCardHead">
                                <h3 class="newHeadTitle">Vendor Level Wsie Despatch</h3>
                            </div>
                            <div class="newCardBody">
                                <div class="table-responsive tvlGridHt">
                                    <asp:GridView ID="gvVendorDespatch" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0 custGvTopvendorGrid" CellSpacing="0" CellPadding="0">
                                        <RowStyle CssClass="tlrowlight" />
                                        <SelectedRowStyle />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Vendor Level">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_vendor_lvl" runat="server" Text='<%# Bind("vld_level") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Despatch Vol">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_despatch_vol" runat="server" Text='<%# Bind("vld_vol") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <%--<div class="row">
                <div class="col-md-12">
                    <div class="newCard">
                        <div class="newCardBody">
                            <div class="lastDateView">
                                <h3>
                                    <asp:Label ID="lblDayNumber" runat="server"></asp:Label>
                                </h3>
                                <p>
                                    <asp:Label ID="lblMonthName" runat="server"></asp:Label>
                                    <asp:Label ID="lblYear" runat="server"></asp:Label>
                                    <asp:Label ID="lblDayName" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>--%>

                <%--            <map name="Map" id="CEO_desk_Map" style="display: none;">
                <area href="Score_Card.aspx" id="imgScoreCard" runat="server" visible="false" shape="RECT" coords="291,1,376,25" alt="CEO ScoreCard" />
                <area href="CEO_desk.aspx" id="imgDashBoard" runat="server" visible="false" shape="RECT" coords="391,1,476,25" alt="CEO DashBoard" />
            </map>--%>

                <%--Start Total Despatch (Vol)--%>
                <asp:HiddenField ID="HiddenField1" runat="server" />
                <asp:ModalPopupExtender ID="mp1" runat="server"
                    PopupControlID="Panel3" TargetControlID="HiddenField1">
                </asp:ModalPopupExtender>
                <asp:Panel ID="Panel3" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Details</h5>
                                <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>--%>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                            <asp:GridView ID="gvDtls" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                <RowStyle CssClass="tlrowlight" />
                                                <SelectedRowStyle />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <FooterStyle CssClass="footerGrid" />
                                                <Columns>

                                                    <asp:TemplateField HeaderText="Unit Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblUnitName" Text='<%# Bind("vendor") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ControlStyle></ControlStyle>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Depot Despatch">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDepotDespatch" Text='<%# Bind("depot_vol") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ControlStyle></ControlStyle>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Direct Despatch">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDirectDespatch" Text='<%# Bind("direct_vol") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ControlStyle></ControlStyle>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnmp1ClosePopup" OnClick="btnmp1ClosePopup_Click" runat="server" CssClass="btn btn-secondary" Text="Close" />

                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnmp1ClosePopup" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <%--End Total Despatch (Vol)--%>


                <%--Start Pending Load--%>
                <asp:HiddenField ID="HiddenField2" runat="server" />
                <asp:ModalPopupExtender ID="mpPendingLoad" runat="server"
                    PopupControlID="pnlPendingLoad" TargetControlID="HiddenField2">
                </asp:ModalPopupExtender>
                <asp:Panel ID="pnlPendingLoad" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Pending Load - Level 1</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                            <asp:GridView ID="gvPendingLoad" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                <RowStyle CssClass="tlrowlight" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                <Columns>

                                                    <asp:TemplateField HeaderText="Vendor">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblVendor" runat="server" Text='<%# Eval("vendor") %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Pending Load">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPendingLoad" runat="server" Text='<%# Eval("pending_load", "{0:N2}") %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <ItemStyle HorizontalAlign="Right" Width="30%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnClosePendingLoad" runat="server" Text="Close" CssClass="btn btn-secondary" OnClick="btnClosePendingLoad_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnClosePendingLoad" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <%--End Pending Load--%>


                <asp:HiddenField ID="HiddenField_Complaints" runat="server" />
                <asp:ModalPopupExtender ID="mpComplaints" runat="server"
                    PopupControlID="Panel_Complaints" TargetControlID="HiddenField_Complaints">
                </asp:ModalPopupExtender>
                <asp:Panel ID="Panel_Complaints" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Monthly Complaints Summary</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Panel runat="server" ID="divComplaintscount">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvComplaints" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid" OnRowCommand="gvComplaints_RowCommand">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Vendor">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblVendor" Text='<%# Eval("vendor") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="No. of Complaints">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblComplaints" Text='<%# Eval("noOfcomplaints") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnView" runat="server" CommandName="ViewComplaints" CommandArgument='<%# Eval("unit_code") %>'
                                                                    Text="View" CssClass="btn btn-info btn-sm tableBtnXs" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </asp:Panel>

                                        <div id="panel_Comaplaints_details" runat="server">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">

                                                <asp:GridView ID="gvCoplaintsDtl" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid" OnRowCommand="gvComplaints_RowCommand">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SKU">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSKu" Text='<%# Eval("sku") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Complaint ID">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblcomID" Text='<%# Eval("vc_complaints_id") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Complaint Date">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblcomdate" Text='<%# Eval("complaints_date") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Complaint Remarks">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblcomdate" Text='<%# Eval("vc_remarks") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Complaint Status">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblcomdate" Text='<%# Eval("vc_status") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                            <%--<div class="row form-btn-mt">
                                            <div class="col-md-12 text-center">
                                                <asp:Button ID="btnComplaintBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnComplaintBack_Click" />
                                            </div>
                                        </div>--%>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnCloseComplaints" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="btnCloseComplaints_Click" />
                                        <asp:Button ID="btnComplaintBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnComplaintBack_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnCloseComplaints" EventName="Click" />
                                        <asp:AsyncPostBackTrigger ControlID="btnComplaintBack" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>


                <asp:HiddenField ID="HiddenField_LegalDocs" runat="server" />
                <asp:ModalPopupExtender ID="mpLegalDocs" runat="server"
                    PopupControlID="Panel_LegalDocs" TargetControlID="HiddenField_LegalDocs">
                </asp:ModalPopupExtender>
                <asp:Panel ID="Panel_LegalDocs" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Legal Documents (Expired & To be Expire in Next 10 Days)</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Panel runat="server" ID="divExpireDoc">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvLegalDocs" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid"
                                                    OnRowCommand="gvLegalDocs_RowCommand">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Vendor">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblVendor" Text='<%# Eval("vendor") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="80%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Count">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDocCount" Text='<%# Eval("expire_doc_count") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnView" runat="server" CommandName="ViewExpireDoc" CommandArgument='<%# Eval("unit_code") %>'
                                                                    Text="View" CssClass="btn btn-info btn-sm tableBtnXs" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </asp:Panel>
                                        <div id="divExpiredocdtls" runat="server">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvExpiredocDtl" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Parameter Name">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblParam" Text='<%# Eval("vlm_param_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="80%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Valid From">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblvalidFrom" Text='<%# Eval("validfrom") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Valid Till">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblValidTill" Text='<%# Eval("validtill") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="10%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                            <%-- <div class="row form-btn-mt">
                                            <div class="col-md-12 text-center">
                                                <asp:Button ID="btnLegalExpireBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnLegalExpireBack_Click" />
                                            </div>
                                        </div>--%>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnCloseLegalDocs" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="btnCloseLegalDocs_Click" />
                                        <asp:Button ID="btnLegalExpireBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnLegalExpireBack_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnCloseLegalDocs" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>


                <asp:HiddenField ID="HiddenUnApproved" runat="server" />
                <asp:ModalPopupExtender ID="mpUnApprovedDoc" runat="server"
                    PopupControlID="PanelUnApprobvedDoc" TargetControlID="HiddenUnApproved">
                </asp:ModalPopupExtender>
                <asp:Panel ID="PanelUnApprobvedDoc" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Unapproved Legal/Statutory Documents</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Panel runat="server" ID="divLegalApprove">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvUnApprovedDoc" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid" OnRowCommand="gvUnApprovedDoc_RowCommand">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Vendor">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblVendor" Text='<%# Eval("vendor") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="80%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Count">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDocCount" Text='<%# Eval("unapproved_legal_doc_count") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnView" runat="server" CommandName="ViewLegalApprove" CommandArgument='<%# Eval("unit_code") %>'
                                                                    Text="View" CssClass="btn btn-info btn-sm tableBtnXs" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </asp:Panel>

                                        <div id="divLegalApproveDtl" runat="server">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvLegalApproveDtl" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Parameter Name">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbllegalApproveParam" Text='<%# Eval("vlm_param_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="80%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblegalStatus" Text='<%# Eval("status") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="20%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                            <%--<div class="row form-btn-mt">
                                            <div class="col-md-12 text-center">
                                                <asp:Button ID="btnLegalApproveBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnLegalApproveBack_Click" />
                                            </div>
                                        </div>--%>
                                        </div>

                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnUnApprovedDoc" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="btnUnApprovedDoc_Click" />
                                        <asp:Button ID="btnLegalApproveBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnLegalApproveBack_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnUnApprovedDoc" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>


                <asp:HiddenField ID="HiddenAuditCount" runat="server" />
                <asp:ModalPopupExtender ID="mpAuditCount" runat="server"
                    PopupControlID="PanelAuditCount" TargetControlID="HiddenAuditCount">
                </asp:ModalPopupExtender>
                <asp:Panel ID="PanelAuditCount" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Audited Vendor Count</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                            <asp:GridView ID="gvAuditCount" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                <RowStyle CssClass="tlrowlight" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Unit Code">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblAuditUnitCode" Text='<%# Eval("unit_code") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Vendor">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblVendor" Text='<%# Eval("vendor") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <ItemStyle HorizontalAlign="Left" Width="90%" />
                                                    </asp:TemplateField>

                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnAuditCount" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="btnAuditCount_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnAuditCount" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>


                <asp:HiddenField ID="HiddenSampleTestedCount" runat="server" />
                <asp:ModalPopupExtender ID="mpSampleTestedCount" runat="server"
                    PopupControlID="PanelSampleTestedCount" TargetControlID="HiddenSampleTestedCount">
                </asp:ModalPopupExtender>
                <asp:Panel ID="PanelSampleTestedCount" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Sample Tested Vendor Count</h5>
                            </div>
                            <div class="modal-body">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                            <asp:GridView ID="gvSampleCount" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                <RowStyle CssClass="tlrowlight" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Unit Code">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblUnitCode" Text='<%# Eval("unit_code") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Vendor">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblVendor" Text='<%# Eval("vendor") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <ItemStyle HorizontalAlign="Left" Width="90%" />
                                                    </asp:TemplateField>

                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="modal-footer">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnSampleTestedClose" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="btnSampleTestedClose_Click" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnSampleTestedClose" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:Panel>


                <script>
                    const chartEl = document.getElementById('salesChart');
                    if (chartEl) {
                        const ctx = chartEl.getContext('2d');
                        const pendingData = [<%= litPending.Text %>];
                        const despatchData = [<%= litDespatch.Text %>];
                        const salesChart = new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"],
                                datasets: [
                                    {
                                        label: "Pending Loads",
                                        data: pendingData,
                                        borderColor: "#c0392b",
                                        backgroundColor: "rgba(192, 57, 43, 0.10)",
                                        tension: 0.35,
                                        fill: true,
                                        pointRadius: 3,
                                        pointHoverRadius: 5,
                                        pointBackgroundColor: "#c0392b",
                                        borderWidth: 2
                                    },
                                    {
                                        label: "Total Despatch",
                                        data: despatchData,
                                        borderColor: "#1b5a8c",
                                        backgroundColor: "rgba(27, 90, 140, 0.10)",
                                        tension: 0.35,
                                        fill: true,
                                        pointRadius: 3,
                                        pointHoverRadius: 5,
                                        pointBackgroundColor: "#1b5a8c",
                                        borderWidth: 2
                                    }
                                ]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                interaction: {
                                    intersect: false,
                                    mode: "index"
                                },
                                plugins: {
                                    legend: {
                                        position: "top",
                                        labels: {
                                            boxWidth: 10,
                                            boxHeight: 10,
                                            padding: 10,
                                            font: { size: 11, weight: "600" },
                                            color: "#10385a"
                                        }
                                    },
                                    tooltip: {
                                        backgroundColor: "#10385a",
                                        titleColor: "#fff",
                                        bodyColor: "#fff",
                                        padding: 10,
                                        cornerRadius: 8
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: false,
                                        ticks: {
                                            stepSize: 10,
                                            color: "#6b7b8f",
                                            font: { size: 10 }
                                        },
                                        grid: { color: "#e8eef4" },
                                        title: {
                                            display: true,
                                            text: "Loads (Volume)",
                                            color: "#6b7b8f",
                                            font: { size: 11, weight: "600" }
                                        }
                                    },
                                    x: {
                                        ticks: {
                                            color: "#6b7b8f",
                                            font: { size: 10 }
                                        },
                                        grid: { display: false },
                                        title: {
                                            display: true,
                                            text: "Months",
                                            color: "#6b7b8f",
                                            font: { size: 11, weight: "600" }
                                        }
                                    }
                                }
                            }
                        });
                    }
                </script>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <script>
        $(function () {
    var pageIndex = 0;
    var loading = false;
    var noMoreData = false;

    $('#gvVendorDispatch').closest('.rm-grid-scroll').on('scroll', function () {
        var $el = $(this);
        var nearBottom = $el.scrollTop() + $el.innerHeight() >= $el[0].scrollHeight - 50;

        if (!nearBottom || loading || noMoreData) return;

        loading = true;
        pageIndex++;

        var vendorUnit = $('#ddlVendorList').val() || '';
        var year = $('#<%= ddlProcessYr.ClientID %>').val();
        var month = $('#<%= ddlProcessMnth.ClientID %>').val();

        PageMethods.GetMoreDispatch(pageIndex, vendorUnit, year, month,
            function (result) {
                if (!result.rows || result.rows.length === 0) {
                    noMoreData = true;
                    loading = false;
                    return;
                }
                $.each(result.rows, function (i, r) {
                    appendDispatchRow($('#gvVendorDispatch tbody'), r);
                });
                if ($('#gvVendorDispatch tbody tr').length >= result.total) {
                    noMoreData = true;
                }
                loading = false;
            },
            function (err) {
                loading = false;
                console.error(err);
            }
        );
    });

    // reset + reload from scratch when the vendor filter changes
    $('#ddlVendorList').on('change', function () {
        pageIndex = 0;
        noMoreData = false;
        // the existing OnSelectedIndexChanged postback (ddlVendorList_SelectedIndexChanged)
        // already re-binds page 0 server-side via BindVendorDispatchGrid, so no extra JS needed here
    });

    function appendDispatchRow($tbody, r) {
        $tbody.append(
            '<tr class="tlrowlight">' +
            '<td class="text-center">' + r.vm_vendor_name + '</td>' +
            '<td class="text-center">' + r.depot_name + '</td>' +
            '<td class="text-center">' + r.ddrh_order_sl_no + '</td>' +
            '<td class="text-center">' + r.ReqDate + '</td>' +
            '<td class="text-center">' + r.vom_org_name + '</td>' +
            '<td class="text-center">' + r.lm_desc + '</td>' +
            '</tr>'
        );
    }
});
    </script>
</asp:Content>
