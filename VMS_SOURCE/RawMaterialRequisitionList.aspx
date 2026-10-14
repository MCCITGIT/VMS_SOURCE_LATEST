<%@ Page Title="Raw Material Requisition List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialRequisitionList.aspx.vb" Inherits="RawMaterialRequisitionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <div class="rm-module rm-compact">
        <style type="text/css">
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
                        <div class="rm-filter-stats-row">
                            <div class="rm-filter-fields">
                                <div class="rm-filter-inline">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Vendor:</label>
                                        <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Supplier:</label>
                                        <asp:DropDownList ID="ddlRawMatvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Approval Status:</label>
                                        <asp:DropDownList ID="ddlApprovalstatus" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="rm-filter-actions">
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                        <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" OnClick="ImgbtnAdd_Click" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="rm-stat-row">
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
                        <div class="table-responsive rm-grid-scroll rm-fit-grid">
                            <asp:GridView BorderWidth="0" CssClass="table table-hover upgradDataGrid rm-fit-grid" CellSpacing="0" CellPadding="0"
                                ID="gvRequisition" runat="server" ClientIDMode="Static" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true"
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
</asp:Content>
