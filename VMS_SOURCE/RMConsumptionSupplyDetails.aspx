<%@ Page Title="RM Consumption Supply Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RMConsumptionSupplyDetails.aspx.vb" Inherits="RMConsumptionSupplyDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <%--<asp:ToolkitScriptManager runat="server"></asp:ToolkitScriptManager>--%>

    <style>
        .p-rm-supply-table table tbody tr:nth-child(4) {
            box-shadow: none !important;
        }

        .upgradDataGrid .tlrowlight {
            box-shadow: none !important;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">RM Consumtion Supply Details</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>


    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Quarter:<span id="Span12" class="mandatory">*</span></label>
                        <asp:DropDownList ID="ddlQuarter" CssClass="form-control select2" runat="server" AutoPostBack="true" />

                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server" AutoPostBack="true" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Product:</label>
                        <asp:TextBox ID="txtProduct" CssClass="form-control" runat="server"></asp:TextBox>

                    </div>
                </div>
                <div class="col-md-12 form-btn-mt text-center">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnExportConsumption" runat="server" Text="Export Cunsumption" CssClass="btn btn-success btn-sm" OnClick="btnExportConsumption_Click" />
                    <asp:Button ID="btnExportAllocation" runat="server" Text="Export Allocation" CssClass="btn btn-info btn-sm" OnClick="btnExportAllocation_Click" />
                    <%-- <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm"/>--%>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:UpdatePanel ID="updetails" runat="server">
                <ContentTemplate>
                    <div class="table-responsive p-rm-supply-table">
                        <asp:GridView CssClass="upgradDataGrid" border="1" CellSpacing="0" CellPadding="0" ID="gvConsumption" runat="server"
                            AutoGenerateColumns="false" AllowPaging="false" Visible="true" ShowFooter="false" GridLines="both" OnRowCommand="gvConsumption_RowCommand" OnDataBound="gvConsumption_DataBound">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <AlternatingRowStyle CssClass="tlrowdark" />
                            <PagerStyle HorizontalAlign="Center" />
                            <HeaderStyle CssClass="headerGrid" HorizontalAlign="Center" />
                            <FooterStyle CssClass="footerGrid" HorizontalAlign="Center" />
                            <Columns>
                                <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblbrandid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("vendorname") %>'></asp:Label>
                                        <asp:HiddenField runat="server" ID="hdnvendorId" Value='<%#Eval("vendorid") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Chemical Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lChemical" runat="server" Text='<%# Bind("tc_chemical_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Allocation" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAlloted" runat="server" Text='<%# Bind("alloted") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Supply" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSupply" runat="server" Text='<%# Bind("supply") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Consumption" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConsumption" runat="server" Text='<%# Bind("consumption") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="true">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnView" runat="server" Visible="true" CommandName="ViewDetails" CommandArgument='<%# Eval("vendorid") & "|" & Eval("vendorid") %>' ToolTip="Click To View Details"><i class="fa fa-eye"></i></asp:LinkButton>
                                        <%-- <asp:Button ID="btnView" CommandName="ViewDetails" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="Click To View Details" CommandArgument='<%# Eval("vendorid") & "|" & Eval("vendorid") %>'></asp:Button>--%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvConsumption" EventName="RowCommand" />
                </Triggers>
                <%-- <Triggers>
                                     <asp:PostBackTrigger ControlID="btnView" />
                                 </Triggers>--%>
            </asp:UpdatePanel>
        </div>
    </div>

    <%--Rm Consumption Details Popup--%>
    <asp:HiddenField ID="HiddenField6" runat="server" />
    <asp:ModalPopupExtender ID="mpRmConsumtion" runat="server"
        PopupControlID="Panel5" TargetControlID="HiddenField6">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel5" runat="server" CssClass="modal-popup">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Comsumption Details</h5>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">

                            <!-- Header Section -->
                            <asp:UpdatePanel ID="updtl" runat="server">
                                <ContentTemplate>
                                    <div class="header-section">
                                        <div class="row align-items-center">
                                            <!-- Product Image -->
                                            <div class="col-auto">
                                                <div class="product-image-wrapper">
                                                    <img src="./images/product-placeholder.png" alt="Product Image" class="product-image">
                                                </div>
                                            </div>

                                            <!-- Product Info -->
                                            <div class="col">

                                                <div class="product-info">
                                                    <span class="quarterly-badge" id="rmquarter" runat="server">Quarterly: Q4</span>
                                                    <h2 class="dealer-name" id="lbvendor" runat="server">Santanu Nag Rahul</h2>
                                                    <div class="product-details">
                                                        <div class="detail-item">
                                                            <i class="fas fa-box-open"></i>
                                                            <span>Product:</span>
                                                            <strong id="lbproduct" runat="server">Bison Putty</strong>
                                                        </div>
                                                        <div class="detail-item">
                                                            <i class="fas fa-tag"></i>
                                                            <span>Brand:</span>
                                                            <strong>Bison Putty</strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Total Dispatch Badge -->
                                            <div class="col-auto">
                                                <div class="dispatch-badge">
                                                    <span class="dispatch-label">TOTAL DISPATCH</span>
                                                    <span class="dispatch-value" id="dispatchvol" runat="server">100 MT</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <div class="stats-section">
                                <div class="row">

                                    <!-- Allocation Card -->
                                    <div class="col-md-3 mb-3">
                                        <div class="stat-card allocation-card allocationBColr">
                                            <div class="stat-card-header">
                                                <div class="stat-icon allocation-icon">
                                                    <i class="fas fa-chart-pie"></i>
                                                </div>
                                                <h5 class="stat-title">Allocation</h5>
                                                <div class="stat-decoration">
                                                    <i class="fas fa-truck"></i>
                                                </div>
                                            </div>
                                            <div class="stat-card-body">
                                                <asp:UpdatePanel ID="upAllocation" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Repeater ID="rptAllocation" runat="server">
                                                            <ItemTemplate>
                                                                <div class="stat-row">
                                                                    <div class="stat-label">
                                                                        <span class="label-name"><%# Eval("tc_chemical_name") %></span>
                                                                        <span class="per-unit">Per unit: <%# Eval("tc_rm_dosage") %></span>
                                                                    </div>
                                                                    <span class="stat-value"><%# Eval("alloted") %></span>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Supply Card -->
                                    <div class="col-md-3 mb-3">
                                        <div class="stat-card supply-card supplyBColr">
                                            <div class="stat-card-header">
                                                <div class="stat-icon supply-icon">
                                                    <i class="fas fa-dolly"></i>
                                                </div>
                                                <h5 class="stat-title">Supply</h5>
                                                <div class="stat-decoration">
                                                    <i class="fas fa-shopping-cart"></i>
                                                </div>
                                            </div>

                                            <div class="stat-card-body">
                                                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Repeater ID="rptSupply" runat="server">
                                                            <ItemTemplate>
                                                                <div class="stat-row">
                                                                    <div class="stat-label">
                                                                        <span class="label-name"><%# Eval("tc_chemical_name") %></span>
                                                                        <span class="per-unit">Per unit: <%# Eval("tc_rm_dosage") %></span>
                                                                    </div>
                                                                    <span class="stat-value"><%# Eval("supply") %></span>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Consumption Card -->
                                    <div class="col-md-3 mb-3">
                                        <div class="stat-card consumption-card consumptionBColr">
                                            <div class="stat-card-header">
                                                <div class="stat-icon consumption-icon">
                                                    <i class="fas fa-tint"></i>
                                                </div>
                                                <h5 class="stat-title">Consumption</h5>
                                                <div class="stat-decoration">
                                                    <i class="fas fa-seedling"></i>
                                                </div>
                                            </div>
                                            <div class="stat-card-body">
                                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Repeater ID="rptConsumption" runat="server">
                                                            <ItemTemplate>
                                                                <div class="stat-row">
                                                                    <div class="stat-label">
                                                                        <span class="label-name"><%# Eval("tc_chemical_name") %></span>
                                                                        <span class="per-unit">Per unit: <%# Eval("tc_rm_dosage") %></span>
                                                                    </div>
                                                                    <span class="stat-value"><%# Eval("consumption") %></span>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Remaining Card -->
                                    <div class="col-md-3 mb-3">
                                        <div class="stat-card remaining-card remainingBColr">
                                            <div class="stat-card-header">
                                                <div class="stat-icon remaining-icon">
                                                    <i class="fas fa-layer-group"></i>
                                                </div>
                                                <h5 class="stat-title">Remaining</h5>
                                                <div class="stat-decoration">
                                                    <i class="fas fa-hourglass-half"></i>
                                                </div>
                                            </div>
                                            <div class="stat-card-body">
                                                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Repeater ID="rptRemaining" runat="server">
                                                            <ItemTemplate>
                                                                <div class="stat-row">
                                                                    <div class="stat-label">
                                                                        <span class="label-name"><%# Eval("tc_chemical_name") %></span>
                                                                        <span class="per-unit">Per unit: <%# Eval("tc_rm_dosage") %></span>
                                                                    </div>
                                                                    <span class="stat-value"><%# Eval("remaning") %></span>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--  <div style="display: none;">
                            <asp:UpdatePanel runat="server">
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="flashComplainBTCCard">
                                                <div class="newCard w100">
                                                    <div class="newCardHead">
                                                        <h3 class="newHeadTitle"></h3>
                                                    </div>
                                                    <div class="newCardBody">
                                                        <div class="noRecordFnew" id="lblVendor" runat="server">No new updates at the moment.</div>
                                                    </div>
                                                </div>
                                                <a class="complainBTCCard" id="tblComplainRegistrationLink" runat="server" target="_blank" title="For Product Complaint Click Here">
                                                    <div class="newCard">

                                                        <p id="lbprodvol" runat="server">Complain/BTC</p>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvDtls" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <SelectedRowStyle />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Chemical">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitName" Text='<%# Bind("tc_chemical_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Allocation">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDepotDespatch" Text='<%# Bind("consumption") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvSupply" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <SelectedRowStyle />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Chemical">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitName" Text='<%# Bind("tc_chemical_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Supply">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDepotDespatch" Text='<%# Bind("supply") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvConsumeDtl" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <SelectedRowStyle />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Chemical">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitName" Text='<%# Bind("tc_chemical_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Consumption">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDepotDespatch" Text='<%# Bind("consumption") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="table-responsive" style="overflow-y: auto; max-height: 300px;">
                                                <asp:GridView ID="gvRemain" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <SelectedRowStyle />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Chemical">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitName" Text='<%# Bind("tc_chemical_name") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Left" />
                                                            <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remaining">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDepotDespatch" Text='<%# Bind("remaning") %>' runat="server" />
                                                            </ItemTemplate>
                                                            <ControlStyle></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Right" />
                                                            <ItemStyle HorizontalAlign="Right" Width="20%" />
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>--%>
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

</asp:Content>
