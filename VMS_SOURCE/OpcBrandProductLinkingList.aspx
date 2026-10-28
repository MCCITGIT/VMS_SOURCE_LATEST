<%@ Page Title="Brand Product Linking" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OpcBrandProductLinkingList.aspx.vb" Inherits="OpcBrandProductLinkingList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Brand Product Linking</h3>
                    <p class="pageSubTitle">Browse and manage brand and product linkings</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Brand:<span id="spanBrand" class="mandatory p-vendor-select">*</span></label>
                            <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-4 form-btn-mt">
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
                        <h5 class="mst-panel-title">Linking List</h5>
                        <p class="mst-panel-subtitle">All brands with submitted product linkings</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                        ID="gvBrandLinks" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10"
                        ShowFooter="false" GridLines="both" EmptyDataText="No records found"
                        PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                        OnRowCommand="gvBrandLinks_RowCommand">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvBrandLinks.PageIndex * gvBrandLinks.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Brand Id">
                                <ItemTemplate>
                                    <asp:Label ID="lblBrandId" runat="server" Text='<%# Bind("brand_id") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Brand Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblBrandName" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <div style="display: flex; align-items: center; justify-content: center">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditLink" CommandArgument='<%# Eval("brand_id") %>' ToolTip="Edit"><i class="fa fa-edit"></i></asp:LinkButton>
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
