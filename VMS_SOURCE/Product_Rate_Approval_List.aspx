<%@ Page Title="Product Rate Approval List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Rate_Approval_List.aspx.vb" Inherits="Product_Rate_Approval_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .pra-badge { display: inline-block; padding: 1px 8px; border-radius: 10px; font-size: 11px; font-weight: 600; color: #fff; white-space: nowrap; }
        .pra-APPROVED { background: #28a745; } .pra-INACTIVE { background: #6c757d; } .pra-PENDING { background: #e0a800; }
        .pra-REJECTED { background: #dc3545; } .pra-SUPERSEDED { background: #adb5bd; } .pra-PENDING_VENDOR { background: #17a2b8; }
        .pra-small { font-size: 11px; color: #666; }
    </style>

    <div class="rm-module">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Product Rate Approval</h3>
                    <p class="pageSubTitle">SKU formulations under negotiation and their approval history</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-search"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Search</h5>
                        <p class="mst-panel-subtitle">Pending approvals are listed first</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Brand:</label>
                            <asp:DropDownList ID="ddlBrand" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlvendor" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Show:</label>
                            <asp:DropDownList ID="ddlView" runat="server" CssClass="form-control">
                                <asp:ListItem Value="NEGOTIATION" Text="Under negotiation (pending / rejected)" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="ACTIVE" Text="Approved releases in force"></asp:ListItem>
                                <asp:ListItem Value="ALL" Text="Everything (full history)"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3" style="display: flex; align-items: flex-end; padding-bottom: 16px;">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSearch_Click" />
                    </div>
                </div>
                <asp:Label ID="lblErrorMessage" runat="server" CssClass="errormsg" Style="font-size: 11px; font-weight: bold;"></asp:Label>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found." GridLines="Both"
                        AllowPaging="true" PageSize="15" OnPageIndexChanging="gvList_PageIndexChanging" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5" PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                        <HeaderStyle CssClass="headerGrid" />
                        <Columns>
                            <asp:BoundField DataField="brand_name" HeaderText="Brand" ItemStyle-Width="12%" />
                            <asp:BoundField DataField="vendor_name" HeaderText="Vendor" ItemStyle-Width="14%" />
                            <asp:BoundField DataField="product_name" HeaderText="SKU" />
                            <asp:BoundField DataField="version_text" HeaderText="Release / Revision" ItemStyle-Width="11%" ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate><span class='pra-badge pra-<%# Eval("sf_status") %>'><%# Eval("sf_status") %></span></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SKU price (&#8377;)">
                                <ItemTemplate><%# String.Format("{0:0.00}", Eval("sf_sku_price")) %></ItemTemplate>
                                <ItemStyle HorizontalAlign="Right" Width="7%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Submitted">
                                <ItemTemplate><%# Eval("created_by") %><br /><span class="pra-small"><%# String.Format("{0:dd/MM/yyyy HH:mm}", Eval("created_on")) %></span></ItemTemplate>
                                <ItemStyle Width="10%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HO decision">
                                <ItemTemplate><%# Eval("sf_approved_by") %><br /><span class="pra-small"><%# If(Eval("sf_approved_on") Is DBNull.Value, "", String.Format("{0:dd/MM/yyyy HH:mm}", Eval("sf_approved_on"))) %></span></ItemTemplate>
                                <ItemStyle Width="10%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <a href='Product_Rate_Approval.aspx?id=<%# Eval("sf_id") %>' class="text-primary mr-2" title="Negotiation history"><i class="fas fa-history"></i></a>
                                    <a href='Product_Formulation.aspx?id=<%# Eval("sf_id") %>' class="text-success" title='<%# If(Eval("sf_status").ToString() = "PENDING", "Open to approve / reject", "Open") %>'><i class="fa fa-eye"></i></a>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="7%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
