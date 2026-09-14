<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorWiseLoadSummary.aspx.vb" Inherits="VendorWiseLoadSummary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/css/bootstrap-select.min.css" rel="stylesheet" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js"></script>

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
                        <div class="table-responsive rm-grid-scroll">
                            <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                ID="gvFgVendorlist" runat="server" AutoGenerateColumns="false" Visible="true"
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
                                    <asp:TemplateField HeaderText="SKU Name">
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hdnVendor"
                                                runat="server"
                                                Value='<%# Bind("VendorUnit") %>' />

                                            <asp:Label ID="lblSkuName"
                                                runat="server"
                                                Text='<%# Bind("SKU_Name") %>'>
                                            </asp:Label>

                                            <asp:HiddenField ID="hdnSkuCode"
                                                runat="server"
                                                Value='<%# Bind("SKU") %>' />

                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="30%" CssClass="text-left" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="30%" CssClass="text-left" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Total Load">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTotalLoad"
                                                runat="server"
                                                Text='<%# Bind("Total_Load_NOP") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Dispatched">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDispatched"
                                                runat="server"
                                                Text='<%# Bind("Total_Despatched_NOP") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Pending Load">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPendingLoad"
                                                runat="server"
                                                Text='<%# Bind("Pending_Load_NOP") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Dispatch %">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDispatchPercentage"
                                                runat="server"
                                                Text='<%# Bind("Dispatch_Percentage") %>'>
                                            </asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
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

