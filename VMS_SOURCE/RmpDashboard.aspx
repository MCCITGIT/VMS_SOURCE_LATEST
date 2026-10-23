<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RmpDashboard.aspx.vb" Inherits="RmpDashboard" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rmp-dashboard.css?v=1.0.0.<%= DateTime.Now.Ticks.ToString() %>" rel="stylesheet" type="text/css" />

    <style>
        .mst-panel-icon {
            width: 28px;
            height: 28px;
            min-width: 28px;
            margin-right: 10px;
            font-size: 13px;
            border-radius: 10px;
            background: #eaf1ff;
            color: #2f6fed;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        /*.upgradDataGrid th {
            padding: 10px 16px !important;
            font-size: 10px !important;
        }*/
    </style>

    <div class="rm-module rm-compact rmpDashboardWrap">

        <%--<!-- ================= PAGE HEADER ================= -->--%>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fa fa-home"></i></a>
                <span class="diveider">/</span>
                <div class="pageTitleWrap">
                    <p class="pageTitle">RM Purchase Dashboard</p>
                    <p class="pageSubTitle">Raw material procurement &amp; production usage overview</p>
                </div>
            </div>
        </div>

        <%-- ================= SEARCH FILTERS ================= --%>
        <div class="card">
            <div class="card-body">
                <%-- <div class="rmp-filter-stats-row">
                    <div class="rmp-filter-fields">--%>
                <div class="row">
                    <div id="divVendor" class="col-md-3" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <%--<asp:DropDownList ID="ddlVendor" runat="server" CssClass="form-control">
                                    </asp:DropDownList>--%>
                            <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div id="divDuration" class="col-md-2" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Duration:</label>
                            <asp:DropDownList ID="ddlDurationType" runat="server" AutoPostBack="true" CssClass="form-control select2" OnSelectedIndexChanged="ddlDurationType_SelectedIndexChanged">
                                <asp:ListItem Text="Select Duration" Value=""></asp:ListItem>
                                <asp:ListItem Text="Monthly" Value="M"></asp:ListItem>
                                <asp:ListItem Text="Yearly" Value="Y"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div id="divYear" class="col-md-2" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Year:</label>
                            <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-2" id="monthDiv" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Month:</label>
                            <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm" ToolTip="Search" OnClick="btnSearch_Click">Search</asp:LinkButton>
                    </div>
                </div>
                <%--</div>
                </div>--%>
            </div>
        </div>

        <%--<!-- ================= RM VENDORS TABLE ================= -->--%>
        <div id="divPurchaseRecord" class="card rm-list-fill" runat="server">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Approved vs Unapproved Vendor Purchase</h5>
                        <p class="mst-panel-subtitle">Compare quantities purchased from approved and unapproved vendors</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <div id="divGvVerList" visible="false" runat="server" style="text-align: center; padding: 20px 10px; font-size: 12px; color: #94a3b8;">
                        <p>No Data Available</p>
                    </div>
                    <asp:GridView
                        ID="gvVerifiedVendorList"
                        runat="server"
                        AutoGenerateColumns="false"
                        AllowPaging="true"
                        PageSize="10"
                        Visible="true"
                        BorderWidth="0"
                        CssClass="table table-hover upgradDataGrid"
                        EmptyDataText="No dispatch requests found."
                        PagerSettings-Mode="NumericFirstLast"
                        PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First"
                        PagerSettings-LastPageText="Last">

                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />

                        <Columns>
                            <asp:TemplateField HeaderText="SR. NO.">
                                <ItemTemplate>
                                    <asp:Label ID="lblSrl" runat="server"
                                        Text='<%# (gvVerifiedVendorList.PageIndex * gvVerifiedVendorList.PageSize) + Container.DataItemIndex + 1 %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="5%" />
                                <ItemStyle HorizontalAlign="Left" Width="5%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Raw Material Name">
                                <ItemTemplate>
                                    <span class="request-id-wrap">
                                        <%--<i class="fas fa-file-alt"></i>--%>
                                        <asp:Label ID="lblRmName" runat="server" CssClass="request-id-text" Text='<%# Eval("rmm_material_name") %>'></asp:Label>
                                        <asp:HiddenField runat="server" ID="hdnRmCode" Value='<%# Bind("orvd_rawmat_code") %>' />
                                    </span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25%" />
                                <ItemStyle HorizontalAlign="Left" Width="25%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="APPROVED">
                                <ItemTemplate>
                                    <div class="vendor-cell">
                                        <div>
                                            <div class="vendor-name">
                                                <asp:Label ID="lblVerifiedVendor" runat="server" Text='<%# Eval("ver_ven_qty_supplied") %>'></asp:Label>
                                                <asp:HiddenField runat="server" ID="hdnRmVenCode" Value='<%# Bind("orh_rawmaterial_vender_code") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Right" Width="8%" />
                                <ItemStyle HorizontalAlign="Right" Width="8%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="UNAPPROVED">
                                <ItemTemplate>
                                    <asp:Label ID="lblUnverifiedVendor" runat="server" Text='<%# Eval("unver_ven_qty_supplied") %>'></asp:Label>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Right" Width="8%" />
                                <ItemStyle HorizontalAlign="Right" Width="8%" />

                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TOTAL">
                                <ItemTemplate>
                                    <asp:Label ID="lblTotal" runat="server" Text='<%# Eval("total_qty_supplied") %>'></asp:Label>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Right" Width="8%" />
                                <ItemStyle HorizontalAlign="Right" Width="8%" />

                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Consumed">
                                <ItemTemplate>
                                    <asp:Label ID="lblConsumed" runat="server" Text='<%# Eval("total_qty_consumed") %>'></asp:Label>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Right" Width="8%" />
                                <ItemStyle HorizontalAlign="Right" Width="8%" />

                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="PERCENTAGE">
                                <ItemTemplate>
                                    <asp:Label ID="lblConsPer" runat="server" Text='<%# Eval("qty_consumed_percentage") & " %" %>'></asp:Label>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Right" Width="8%" />
                                <ItemStyle HorizontalAlign="Right" Width="8%" />

                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div id="RmPendingList" class="card rm-list-fill" runat="server">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Raw Material Pending & In Transit</h5>
                        <p class="mst-panel-subtitle">Track pending and in-transit raw material requests</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <div id="divGvPenList" visible="false" runat="server" style="text-align: center; padding: 20px 10px; font-size: 12px; color: #94a3b8;">
                        <p>No Data Available</p>
                    </div>
                    <asp:GridView
                        ID="gvRmPendingList"
                        runat="server"
                        AutoGenerateColumns="false"
                        AllowPaging="true"
                        PageSize="10"
                        Visible="true"
                        OnRowCommand="gvRmPendingList_RowCommand"
                        BorderWidth="0"
                        CssClass="table table-hover upgradDataGrid"
                        EmptyDataText="No dispatch requests found."
                        PagerSettings-Mode="NumericFirstLast"
                        PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First"
                        PagerSettings-LastPageText="Last">

                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />

                        <Columns>
                            <asp:TemplateField HeaderText="SR. NO.">
                                <ItemTemplate>
                                    <asp:Label ID="lblSrl" runat="server"
                                        Text='<%# (gvRmPendingList.PageIndex * gvRmPendingList.PageSize) + Container.DataItemIndex + 1 %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="10%" />
                                <ItemStyle HorizontalAlign="Left" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="REQUEST ID">
                                <ItemTemplate>
                                    <span class="request-id-wrap">
                                        <i class="fas fa-file-alt"></i>
                                        <asp:Label ID="lblReqId" runat="server" CssClass="request-id-text" Text='<%# Eval("req_id") %>'></asp:Label>
                                    </span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="16%" />
                                <ItemStyle HorizontalAlign="Left" Width="16%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="VENDOR">
                                <ItemTemplate>
                                    <div class="vendor-cell">
                                        <div>
                                            <div class="vendor-name">
                                                <asp:Label ID="lblVendor" runat="server" Text='<%# Eval("RawMaterialVendorName") %>'></asp:Label>
                                                <asp:HiddenField runat="server" ID="hdnRmCode" Value='<%# Bind("RawMaterialVendorCode") %>' />
                                            </div>
                                            <%--  <div class="vendor-sub">
                                        Vendor
                                    </div>--%>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="42%" />
                                <ItemStyle HorizontalAlign="Left" Width="42%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="STATUS">
                                <ItemTemplate>
                                    <span class='<%# GetStatusCss(Eval("Status").ToString()) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Left" Width="18%" />
                                <ItemStyle HorizontalAlign="Left" Width="18%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="VIEW" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <div style="display: flex; align-items: center; justify-content: center;">
                                        <asp:LinkButton
                                            runat="server"
                                            ID="lbtnDetails"
                                            Text=""
                                            CommandName="Details"
                                            CommandArgument='<%# Container.DataItemIndex %>'
                                            ToolTip="View Details"
                                            CssClass="grid-action">
                                        <i class="fas fa-eye"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="14%" />
                                <ItemStyle HorizontalAlign="Center" Width="14%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <%--<!-- ================= CHARTS ================= -->--%>
        <div id="divCharts" runat="server" visible="false">
            <%--<!-- Purchased vs Used bar chart -->--%>
            <asp:HiddenField ID="hdnRmChartData" runat="server" />
            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Quantity Purchased vs Used</h5>
                            <p class="mst-panel-subtitle">Quantity Purchased vs Used</p>
                        </div>
                    </div>
                    <div class="rmp-legend">
                        <div class="rmp-legend-item"><span class="rmp-legend-dot" style="background: #1b5a8c"></span>Purchased</div>
                        <div class="rmp-legend-item"><span class="rmp-legend-dot" style="background: #188038"></span>Used</div>
                    </div>
                </div>
                <div class="card-body rmp-bars-wrap">
                    <div class="rmp-bars-scroll" id="rmpBarsScroll">
                        <div class="rmp-bars-inner" id="rmpBarsInner">
                            <!-- Dynamic bars -->
                            <div class="rmp-bars" id="rmpBars"></div>

                            <!-- Dynamic labels -->
                            <div class="rmp-bar-labels" id="rmpBarLabels"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hdnRmList" runat="server" />
    <asp:ModalPopupExtender ID="mpRmList" runat="server"
        PopupControlID="PanelRawMaterialList" TargetControlID="hdnRmList">
    </asp:ModalPopupExtender>
    <asp:Panel ID="PanelRawMaterialList" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="modalPanel bootstrapModal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Raw Materials List</h5>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upPendingList" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                <asp:GridView ID="gvRmList" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                    <RowStyle CssClass="tlrowlight" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Raw Material Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRmName" Text='<%# Eval("rmm_material_name") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnRmCode" Value='<%# Bind("ord_rawmaterial_code") %>' />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Left" Width="40%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Requested Qty">
                                            <ItemTemplate>
                                                <asp:Label ID="lblReqQty" Text='<%# Eval("ord_qty") %>' runat="server" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Right" />
                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Dispatched Qty">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDisQty" Text='<%# Eval("dis_qty") %>' runat="server" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Right" />
                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Dispatched Qty">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPenQty" Text='<%# Eval("pen_qty") %>' runat="server" />
                                            </ItemTemplate>
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
                            <asp:Button ID="btnRmListClose" runat="server" CssClass="btn btn-secondary" Text="Close" OnClientClick="closeRmPopup(); return false;" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnRmListClose" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">

        function loadRmChart() {

            var hiddenField =
                document.getElementById('<%= hdnRmChartData.ClientID %>');

            if (!hiddenField)
                return;

            var json = hiddenField.value;

            if (!json)
                return;

            var data;

            try {
                data = JSON.parse(json);
            }
            catch (e) {
                console.error("Invalid RM chart JSON", e);
                return;
            }

            renderRmChart(data);
        }


        var RMP_CHART_BAR_AREA = 150;


        function getRmChartLayout() {

            var root =
                document.querySelector(".rmpDashboardWrap");

            var styles = root
                ? window.getComputedStyle(root)
                : null;

            var groupWidth = 76;
            var groupGap = 25;

            if (styles) {
                groupWidth =
                    parseFloat(styles.getPropertyValue("--rmp-bar-group-width")) || groupWidth;

                groupGap =
                    parseFloat(styles.getPropertyValue("--rmp-bar-group-gap")) || groupGap;
            }

            return {
                groupWidth: groupWidth,
                groupGap: groupGap
            };
        }


        function updateRmChartScrollWidth(itemCount) {

            var barsInner =
                document.getElementById("rmpBarsInner");

            if (!barsInner || itemCount <= 0) {
                if (barsInner) {
                    barsInner.style.minWidth = "";
                }
                return;
            }

            var layout = getRmChartLayout();
            var totalWidth =
                (itemCount * layout.groupWidth) +
                (Math.max(0, itemCount - 1) * layout.groupGap);

            barsInner.style.minWidth = totalWidth + "px";
        }


        function renderRmChart(data) {

            var barsContainer =
                document.getElementById("rmpBars");

            var labelsContainer =
                document.getElementById("rmpBarLabels");


            barsContainer.innerHTML = "";
            labelsContainer.innerHTML = "";


            if (!data || data.length === 0) {

                updateRmChartScrollWidth(0);

                barsContainer.innerHTML =
                    "<div class='rmp-no-data'>No data available</div>";

                return;
            }


            //-----------------------------------------
            // Find maximum quantity
            //-----------------------------------------

            var maxValue = 0;

            data.forEach(function (item) {

                var purchased =
                    parseFloat(item.PurchasedQty) || 0;

                var used =
                    parseFloat(item.UsedQty) || 0;


                if (purchased > maxValue)
                    maxValue = purchased;

                if (used > maxValue)
                    maxValue = used;

            });


            if (maxValue <= 0)
                maxValue = 1;


            updateRmChartScrollWidth(data.length);


            //-----------------------------------------
            // Create bars
            //-----------------------------------------

            data.forEach(function (item) {

                var purchasedQty =
                    parseFloat(item.PurchasedQty) || 0;

                var usedQty =
                    parseFloat(item.UsedQty) || 0;


                var purchasedHeight =
                    Math.round((purchasedQty / maxValue) * RMP_CHART_BAR_AREA);

                var usedHeight =
                    Math.round((usedQty / maxValue) * RMP_CHART_BAR_AREA);

                if (purchasedQty > 0 && purchasedHeight < 3)
                    purchasedHeight = 3;

                if (usedQty > 0 && usedHeight < 3)
                    usedHeight = 3;


                //---------------------------------
                // Bar Group
                //---------------------------------

                var barGroup =
                    document.createElement("div");

                barGroup.className =
                    "rmp-bar-group";


                //---------------------------------
                // Purchased
                //---------------------------------

                var purchasedWrapper =
                    document.createElement("div");

                purchasedWrapper.className =
                    "rmp-bar-item";


                var purchasedValue =
                    document.createElement("span");

                purchasedValue.className =
                    "rmp-bar-value";

                purchasedValue.innerText =
                    formatQuantity(purchasedQty);


                var purchasedBar =
                    document.createElement("div");

                purchasedBar.className =
                    "rmp-bar purchased";

                purchasedBar.style.height =
                    purchasedHeight + "px";

                purchasedBar.title =
                    "Purchased: " +
                    purchasedQty.toLocaleString();


                purchasedWrapper.appendChild(
                    purchasedValue
                );

                purchasedWrapper.appendChild(
                    purchasedBar
                );


                //---------------------------------
                // Used
                //---------------------------------

                var usedWrapper =
                    document.createElement("div");

                usedWrapper.className =
                    "rmp-bar-item";


                var usedValue =
                    document.createElement("span");

                usedValue.className =
                    "rmp-bar-value";

                usedValue.innerText =
                    formatQuantity(usedQty);


                var usedBar =
                    document.createElement("div");

                usedBar.className =
                    "rmp-bar used";

                usedBar.style.height =
                    usedHeight + "px";

                usedBar.title =
                    "Used: " +
                    usedQty.toLocaleString();


                usedWrapper.appendChild(
                    usedValue
                );

                usedWrapper.appendChild(
                    usedBar
                );


                //---------------------------------
                // Add both bars
                //---------------------------------

                barGroup.appendChild(
                    purchasedWrapper
                );

                barGroup.appendChild(
                    usedWrapper
                );

                barsContainer.appendChild(
                    barGroup
                );


                //---------------------------------
                // Raw material label
                //---------------------------------

                var label =
                    document.createElement("span");

                label.innerText =
                    item.RawMaterialCode;

                label.title =
                    item.RawMaterialCode;

                labelsContainer.appendChild(
                    label
                );

            });

        }


        function formatQuantity(value) {

            if (value >= 1000000)
                return (value / 1000000).toFixed(1) + "M";

            if (value >= 1000)
                return (value / 1000).toFixed(1) + "K";

            return value.toFixed(0);
        }


        function initRmChart() {
            loadRmChart();
        }

        document.addEventListener("DOMContentLoaded", initRmChart);

        if (typeof Sys !== "undefined" &&
            Sys.WebForms &&
            Sys.WebForms.PageRequestManager) {

            Sys.WebForms.PageRequestManager
                .getInstance()
                .add_endRequest(initRmChart);
        }

        function closeRmPopup() {

            var modal = $find('<%= mpRmList.ClientID %>');

            if (modal) {
                modal.hide();
            }

            // remove stuck modal background
            $('.modalBackground').remove();

            // restore body state
            $('body').removeClass('modal-open');
        }

    </script>

</asp:Content>
