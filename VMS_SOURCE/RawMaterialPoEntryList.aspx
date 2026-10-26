<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialPoEntryList.aspx.vb" Inherits="RawMaterialPoEntryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material PO Entry List</h3>
                    <p class="pageSubTitle">Manage Raw Material Requests</p>
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
                            <label class="form-control-label">Supplier:<span id="spanVendor" class="mandatory p-vendor-select">*</span></label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                            <asp:HiddenField ID="hdnRmVendor" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
                    <div class="col-md-4 form-btn-mt">
                        <asp:LinkButton ID="lbBtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" ToolTip="Search" OnClick="lbBtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton ID="lbBtnAdd" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" ToolTip="Add" OnClick="lbBtnAdd_Click">Add</asp:LinkButton>
                    </div>
                    <%--<div class="col-md-2">
                                <div class="mt-3">
                                    <asp:LinkButton ID="lbBtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add" OnClick="lbBtnAdd_Click"><i class="fas fa-plus"></i></asp:LinkButton>
                                </div>
                            </div>--%>
                </div>
            </div>
        </div>

        <div class="card rm-list-fill" runat="server" id="tr1">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Supplier List</h5>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="gvPoList" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found"
                                AllowPaging="true" PageSize="10" OnPageIndexChanging="gvPoList_PageIndexChanging">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Srl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrl" runat="server" Text='<%# (gvPoList.PageIndex * gvPoList.PageSize) + Container.DataItemIndex + 1 %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PO No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPoNo" runat="server" Text='<%# HttpUtility.HtmlEncode(Convert.ToString(Eval("display_po_no"))) %>' />
                                            <%--<asp:HiddenField ID="hdnPoId" runat="server" Value='<%# Eval("rmph_id") %>' />--%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Supplier">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendor" runat="server" Text='<%# Eval("vendor_name") %>' />
                                            <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Eval("vendor_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Left" Width="14%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Supplier Code">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorCode" runat="server" Text='<%# Eval("vendor_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Product">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProduct" runat="server" Text='<%# Eval("product_name") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Left" Width="16%" />
                                    </asp:TemplateField>--%>
                                    <%--<asp:TemplateField HeaderText="Product NAme">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("product_name") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:Label ID="lblQty" runat="server" Text='<%# Eval("qty", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Rate">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("rate", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Right" Width="8%" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Amount">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("amount", "{0:N2}") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <a href='<%# "RawMaterialPoPdf.aspx?po=" & Eval("po_no") %>' target="_blank" class="rm-btn-icon text-primary" title="Preview PDF">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

