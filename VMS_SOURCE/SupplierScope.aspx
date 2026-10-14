<%@ Page Title="Supplier Scope" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="SupplierScope.aspx.vb" Inherits="SupplierScope" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid { border: 1px solid #dc3545 !important; box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important; }
        .dispatch-field-error { display: block; color: #dc3545; font-size: 12px; font-weight: 500; margin-top: 4px; line-height: 1.35; }
        .dispatch-field-error:empty { display: none; }
        .scope-hint { font-size: 11px; color: #6c757d; }
        .scope-list { height: 150px; }
    </style>
    <div class="rm-module">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Supplier Scope</h3>
                    <p class="pageSubTitle">Declare the products, shades, packs and packaging items a supplier may quote</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-sitemap"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Scope</h5>
                                <p class="mst-panel-subtitle">Supplier &rarr; Vertical &rarr; Product &rarr; Shade &rarr; Pack &rarr; Packaging items</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Supplier:<span class="mandatory">*</span></label>
                                    <asp:DropDownList ID="ddlSupplier" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSupplier_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:Label ID="valSupplier" runat="server" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Vertical:<span class="mandatory">*</span></label>
                                    <asp:DropDownList ID="ddlVertical" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlVertical_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:Label ID="valVertical" runat="server" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Product:<span class="mandatory">*</span></label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtProductSearch" runat="server" CssClass="form-control" placeholder="Code or name" AutoComplete="Off"></asp:TextBox>
                                        <div class="input-group-append">
                                            <asp:LinkButton ID="btnProductSearch" runat="server" CssClass="btn btn-outline-secondary" ToolTip="Search product" OnClick="btnProductSearch_Click"><i class="fas fa-search fa-xs"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                    <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-control mt-1" AutoPostBack="true" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:Label ID="valProduct" runat="server" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Shade:</label>
                                    <asp:ListBox ID="lstShade" runat="server" SelectionMode="Multiple" CssClass="form-control scope-list"></asp:ListBox>
                                    <span class="scope-hint">Nothing selected = all shades</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Pack:</label>
                                    <asp:ListBox ID="lstPack" runat="server" SelectionMode="Multiple" CssClass="form-control scope-list"></asp:ListBox>
                                    <span class="scope-hint">Nothing selected = all packs</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Packaging items:<span class="mandatory">*</span></label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtItemSearch" runat="server" CssClass="form-control" placeholder="Search cap, bottle, carton ..." AutoComplete="Off"></asp:TextBox>
                                        <div class="input-group-append">
                                            <asp:LinkButton ID="btnItemSearch" runat="server" CssClass="btn btn-outline-secondary" ToolTip="Search items" OnClick="btnItemSearch_Click"><i class="fas fa-search fa-xs"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                    <asp:ListBox ID="lstItemAvail" runat="server" SelectionMode="Multiple" CssClass="form-control mt-1" Height="90px"></asp:ListBox>
                                    <div class="my-1">
                                        <asp:LinkButton ID="btnItemAdd" runat="server" CssClass="btn btn-success btn-sm" ToolTip="Add selected" OnClick="btnItemAdd_Click"><i class="fas fa-arrow-down"></i> Add</asp:LinkButton>
                                        <asp:LinkButton ID="btnItemRemove" runat="server" CssClass="btn btn-outline-danger btn-sm" ToolTip="Remove selected" OnClick="btnItemRemove_Click"><i class="fas fa-arrow-up"></i> Remove</asp:LinkButton>
                                    </div>
                                    <asp:ListBox ID="lstItemSel" runat="server" SelectionMode="Multiple" CssClass="form-control" Height="90px"></asp:ListBox>
                                    <asp:Label ID="valItems" runat="server" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 text-center">
                                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary btn-sm" OnClick="btnSave_Click" />
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary btn-sm" OnClick="btnReset_Click" />
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="errormsg" Style="text-align: left; font-size: 13px; font-weight: bold;"></asp:Label>
                    </div>
                </div>

                <div class="card mt-3">
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvScope" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                EmptyDataText="No scope declared." GridLines="both" DataKeyNames="ss_id" OnRowCommand="gvScope_RowCommand">
                                <RowStyle CssClass="tlrowlight" />
                                <HeaderStyle CssClass="headerGrid" />
                                <Columns>
                                    <asp:BoundField DataField="ss_supplier_code" HeaderText="Supplier" />
                                    <asp:BoundField DataField="ss_sbl" HeaderText="Vertical" />
                                    <asp:BoundField DataField="ss_prd_code" HeaderText="Product" />
                                    <asp:TemplateField HeaderText="Shades">
                                        <ItemTemplate><%# IIf(Convert.ToInt32(Eval("shade_count")) = 0, "All", Eval("shade_count")) %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Packs">
                                        <ItemTemplate><%# IIf(Convert.ToInt32(Eval("pack_count")) = 0, "All", Eval("pack_count")) %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="item_count" HeaderText="Items" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditScope" CommandArgument='<%# Eval("ss_id") %>' CssClass="btn btn-info btn-sm gridBtn mr-1" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
                                            <asp:LinkButton ID="btnDeactivate" runat="server" CommandName="DeactivateScope" CommandArgument='<%# Eval("ss_id") %>' CssClass="btn btn-danger btn-sm" ToolTip="Deactivate" OnClientClick="return confirm('Deactivate this scope?');"><i class="fas fa-trash"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
