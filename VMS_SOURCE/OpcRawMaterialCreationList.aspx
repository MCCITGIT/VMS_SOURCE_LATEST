<%@ Page Title="Raw Material Creation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OpcRawMaterialCreationList.aspx.vb" Inherits="OpcRawMaterialCreationList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material / Packaging List</h3>
                    <p class="pageSubTitle">Browse and manage vendor raw material and packaging entries</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-4" id="colVendorFilter" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">Type:</label>
                            <asp:DropDownList ID="ddlItemType" ClientIDMode="Static" CssClass="form-control" runat="server">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="RM" Text="Raw Material"></asp:ListItem>
                                <asp:ListItem Value="PKG" Text="Packaging"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Name / code:</label>
                            <asp:TextBox ID="txtSearch" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" MaxLength="200" Placeholder="Name or code"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="lbBtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" ToolTip="Search" OnClick="lbBtnSearch_Click">Search</asp:LinkButton>
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
                        <h5 class="mst-panel-title">Raw Material / Packaging List</h5>
                        <p class="mst-panel-subtitle">Raw materials and packaging items created for vendor use</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                        ID="gvRmList" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10"
                        ShowFooter="false" GridLines="both" EmptyDataText="No records found"
                        PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                        OnRowCommand="gvRmList_RowCommand" OnRowDataBound="gvRmList_RowDataBound">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvRmList.PageIndex * gvRmList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text='<%# If(Convert.ToString(Eval("rmm_item_type")).Trim().ToUpper() = "PKG", "Packaging", "Raw Material") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnItemType" runat="server" Value='<%# Eval("rmm_item_type") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblRmCode" runat="server" Text='<%# Bind("rmm_code") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblRmName" runat="server" Text='<%# Bind("rmm_material_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Vendor">
                                <ItemTemplate>
                                    <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="22%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("rmm_status") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblActive" runat="server" CssClass='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "Active", "Inactive") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <div style="display: flex; align-items: center; justify-content: center">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRm" CommandArgument='<%# Eval("rmm_code") %>' ToolTip="Edit"><i class="fa fa-edit"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
