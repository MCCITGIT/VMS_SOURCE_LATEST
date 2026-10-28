<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorPO_DepotLinking.aspx.vb" Inherits="VendorPO_DepotLinking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <%--<style type="text/css">
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
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/VendorPO_DepotLinking.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <script type="text/javascript">
        function checkAllDepot(checkbox) {
            var list = document.getElementById('chkbxListApplDepots');
            if (!list) {
                return;
            }
            var boxes = list.getElementsByTagName('input');
            for (var i = 0; i < boxes.length; i++) {
                boxes[i].checked = checkbox.checked;
            }
        }
    </script>

    <div class="rm-module rm-compact">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor PO Depot Linking</h3>
                    <p class="pageSubTitle">Track Vendor PO Depot Linking</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanelFilter" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor:</label>
                                    <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">PO No:</label>
                                    <asp:DropDownList ID="ddlPoNo" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-4 form-btn-mt">
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" ClientIDMode="Static" ToolTip="Search">Search</asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="btnExcel" runat="server" ClientIDMode="Static" ToolTip="Download Excel"><i class="fa fa-file-excel"></i>&nbsp;Download Excel</asp:LinkButton>
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnExcel" />
            </Triggers>
        </asp:UpdatePanel>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Select Depots</h5>
                        <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:UpdatePanel ID="UpdatePanelGrid" runat="server">
                    <ContentTemplate>
                        <div class="CheckBoxList">
                            <asp:CheckBox ID="chkSelectAll" ClientIDMode="Static" runat="server" CssClass="checkAll" Text="Select All" onclick="checkAllDepot(this)" />
                            <asp:CheckBoxList ID="chkbxListApplDepots" ClientIDMode="Static" runat="server" TabIndex="3" RepeatColumns="3"
                                RepeatDirection="Horizontal" Width="100%" AutoPostBack="False">
                            </asp:CheckBoxList>
                        </div>
                        <div class="text-center">
                            <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClientClick="return validateVendorPoDepotLink();" />
                        </div>
                        <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlvendor" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>
