<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorWiseLoadSummary.aspx.vb" Inherits="VendorWiseLoadSummary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/css/bootstrap-select.min.css" rel="stylesheet" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js"></script>

    <%-- Modified-by MUKESH BHAGAT on 14-09-2026 : SKU list redesigned as a 10-dot pictogram per
         row (was a plain GridView with a numeric "Dispatch %" column) with an overall
         serviceability donut beside it - same design as Home.aspx's SKU List panel, ported here
         since this page reads the same [GetLoadDespatchSummary] columns for one vendor. Markup
         and rendering logic (BindSkuList / BuildSkuSummaryPanel) mirror Home.aspx/Home.aspx.vb
         exactly - see those files for the fuller design-history comments. --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                background: #2f8fd6;
            }

            .dot.total-dispatch {
                background: #2ecc71;
            }

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

        .sku-dots {
            display: flex;
            align-items: center;
            gap: 5px;
            flex: 0 0 auto;
        }

        .sku-dot {
            box-sizing: border-box;
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
                color: #e74c3c;
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

        .sku-panel-row {
            display: flex;
            align-items: stretch;
            gap: 24px;
        }

        .sku-list-col {
            flex: 1 1 68%;
            min-width: 0;
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
    </style>
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

    <div class="rm-module rm-compact rm-brand-master">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Wise Despatch</h3>
                    <p class="pageSubTitle">Track vendor-wise SKU availability and despatch information.</p>
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
                                        <div style="display: flex; flex-direction: column; gap: 2px ;
                                         min-width: 35%;">
                                            <label class="form-control-label">Vendor:</label>
                                            <asp:TextBox ID="txtVendor" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off"></asp:TextBox>
                                        </div>
                                        <div style="display: flex; flex-direction: column; gap: 2px">
                                            <label class="form-control-label">Search SKU:</label>
                                            <asp:TextBox ID="txtSku" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" Placeholder="Enter Here"></asp:TextBox>
                                        </div>
                                        <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
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
                                <h5 id="panelTitle" class="mst-panel-title">Product List</h5>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="legend">
                            <div><span class="dot total-load"></span>Total Load</div>
                            <div><span class="dot total-dispatch"></span>Total Dispatch</div>
                        </div>
                        <div class="sku-panel-row">
                            <div class="sku-list-col">
                                <div id="chartContainer" style="height: 400px; overflow-y: auto;">
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

