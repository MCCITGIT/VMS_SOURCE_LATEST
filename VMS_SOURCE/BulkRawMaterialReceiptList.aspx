<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="BulkRawMaterialReceiptList.aspx.vb" Inherits="BulkRawMaterialReceiptList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <div class="rm-module rm-compact rm-receipt-list">
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnReset').name, '');
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
                <h3 class="pageTitle">Bulk Raw Material Receipt List</h3>
                <p class="pageSubTitle">Browse and track bulk raw material receipts</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanelFilter" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                    <div class="rm-filter-stats-row">
                        <div class="rm-filter-fields">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Supplier:</label>
                                        <asp:DropDownList ID="ddlRawMatvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Status:</label>
                                        <asp:DropDownList ID="ddlStatus" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="rm-filter-actions">
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="rm-stat-row">
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                <div>
                                    <p class="rm-stat-label">Total</p>
                                    <p class="rm-stat-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-orange"><i class="fas fa-clock"></i></div>
                                <div>
                                    <p class="rm-stat-label">Pending</p>
                                    <p class="rm-stat-value is-orange"><asp:Label ID="lblPendingCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                                <div>
                                    <p class="rm-stat-label">Received</p>
                                    <p class="rm-stat-value is-green"><asp:Label ID="lblReceivedCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card rm-list-fill">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Receipt List</h5>
                    <p class="mst-panel-subtitle">All bulk raw material receipts and their status</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive rm-grid-scroll rm-fit-grid">
                <asp:UpdatePanel ID="UpdatePanelGrid" runat="server">
                    <ContentTemplate>
                        <asp:GridView BorderWidth="0" CssClass="table table-hover upgradDataGrid rm-fit-grid" CellSpacing="0" CellPadding="0"
                            ID="gvReceipt" runat="server" ClientIDMode="Static" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true"
                            ShowFooter="false" GridLines="None" EmptyDataText="No records found"
                            PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                            PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                            OnRowCommand="gvReceipt_RowCommand">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Sl No">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvReceipt.PageIndex * gvReceipt.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Request Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequestId" runat="server" Text='<%# Bind("requisition_id") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Despatch Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDespatchId" runat="server" Text='<%# Bind("despatch_id") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnDespatchId" runat="server" Value='<%# Bind("despatch_id") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Despatch Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDespatchDate" runat="server" Text='<%# Bind("despatch_date", "{0:dd-MM-yyyy}") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnRequisitionId" runat="server" Value='<%# Bind("requisition_id") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="RM Vendor">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRmVendor" runat="server" Text='<%# Bind("rawmat_vendor_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnRmVendorId" runat="server" Value='<%# Bind("rawmat_vendor_code") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="14%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Courier Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCourierId" runat="server" Text='<%# Bind("courier_id") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Request Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequestQty" runat="server" Text='<%# Bind("request_qty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="7%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Despatch Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDespatchQty" runat="server" Text='<%# Bind("despatch_qty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="7%" />

                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Receive ID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReceivedId" runat="server" Text='<%# Bind("received_id") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnReceivedId" runat="server" Value='<%# Bind("received_id") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Receive Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReceiveQty" runat="server" Text='<%# Bind("received_qty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="7%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Pending Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPendingQty" runat="server" Text='<%# Bind("pending_qty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="7%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Invoice No">
                                    <ItemTemplate>
                                        <asp:Label ID="lblinvno" runat="server" Text='<%# Bind("invoice_no") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Invoice Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblinvdate" runat="server" Text='<%# Bind("invoice_date") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <div style="display: flex; align-items: center; justify-content: center">
                                            <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="ViewReceipt"
                                                CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View"><i class="fa fa-eye"></i></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:PostBackTrigger ControlID="gvReceipt" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
