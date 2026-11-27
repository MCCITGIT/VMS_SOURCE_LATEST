<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Formulation_Rate_Revision_List.aspx.vb" Inherits="Formulation_Rate_Revision_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="rm-module rm-compact rsm-page">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Formulation Rate Revision List</h3>
                    <p class="pageSubTitle">List of formulation revision rates vendor wise</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3" id="colVendorFilter" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="btnAdd_Click" ToolTip="Add">
                            <i class="fas fa-plus"></i> Add
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Formulation Revision List</h5>
                        <p class="mst-panel-subtitle">Formulation revision rates for each vendor</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                        ID="gvFormulation" runat="server" AutoGenerateColumns="false" AllowPaging="false" PageSize="10"
                        ShowFooter="false" GridLines="both" EmptyDataText="No records found"
                        PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvFormulation.PageIndex * gvFormulation.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Vendor">
                                <ItemTemplate>
                                    <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="16%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Formulation">
                                <ItemTemplate>
                                    <asp:Label ID="lblFormulation" runat="server" Text='<%# Bind("sku_description") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                            </asp:TemplateField>

                            <%-- 04-11-2026 MUKESH BHAGAT: the permission is per FORMULATION now (all raw material and packaging rates), so one row per formulation;
                                 the prices are the SKU price of the permitted release and of the newest proposal --%>
                            <asp:TemplateField HeaderText="Current SKU price">
                                <ItemTemplate>
                                    <asp:Label ID="lblOldRate" runat="server" Text='<%# Eval("old_rate", "{0:0.00}") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="8%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Proposed SKU price">
                                <ItemTemplate>
                                    <asp:Label ID="lblNewRate" runat="server" Text='<%# Eval("new_rate", "{0:0.00}") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="8%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblRevStatus" runat="server" Text='<%# Eval("rev_status") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="14%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Effective from">
                                <ItemTemplate>
                                    <asp:Label ID="lblEffective" runat="server" Text='<%# Eval("effective_from", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Permission by">
                                <ItemTemplate>
                                    <asp:Label ID="lblPermBy" runat="server" Text='<%# Eval("permitted_by") %>'></asp:Label>
                                    <br /><span class="text-muted" style="font-size: 11px;"><%# Eval("permitted_on", "{0:dd/MM/yyyy}") %></span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Open">
                                <ItemTemplate>
                                    <a href='Product_Formulation.aspx?id=<%# Eval("latest_sf_id") %>' title="Open the formulation / negotiation"><i class="fa fa-eye"></i></a>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

