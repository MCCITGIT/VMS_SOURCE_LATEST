<%@ Page Title="Brand Product Linking" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OpcBrandProductLinking.aspx.vb" Inherits="OpcBrandProductLinking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .rm-module .form-control.field-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .dispatch-field-error {
    display: block;
    color: #dc3545;
    font-size: 11px;
    font-weight: 500;
    margin-top: 0px;
    line-height: 1;
        }

        .dispatch-field-error:empty {
            display: none;
        }

        .link-page-message {
            display: block;
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .link-page-message:empty {
            display: none;
        }

        .product-select-hint {
            display: block;
            color: #6c757d;
            font-size: 11px;
            margin-top: 4px;
        }
    </style>
    <script type="text/javascript">
        function initProductMultiSelect() {
            var $product = $('#ddlProduct');
            if (!$product.length || !$.fn.select2) {
                return;
            }
            if ($product.data('select2')) {
                $product.select2('destroy');
            }
            $product.select2({
                width: '100%',
                placeholder: 'Select product',
                closeOnSelect: false,
                allowClear: true
            });
        }

        $(document).ready(function () {
            setTimeout(initProductMultiSelect, 0);
        });
    </script>

    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Brand Product Linking</h3>
                    <p class="pageSubTitle">Manage Brand And Product Linking</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-link"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Link Brand And Product</h5>
                        <p class="mst-panel-subtitle">Select a brand and one or more products, add them to the list, then submit.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Brand:<span class="mandatory">*</span></label>
                            <asp:DropDownList ID="ddlBrand" runat="server" ClientIDMode="Static" CssClass="form-control select2"></asp:DropDownList>
                            <asp:Label ID="valBrand" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-control-label">Product:<span class="mandatory">*</span></label>
                            <asp:ListBox ID="ddlProduct" runat="server" ClientIDMode="Static" SelectionMode="Multiple" CssClass="form-control select2"></asp:ListBox>
                            <span class="product-select-hint">Select one product or several.</span>
                            <asp:Label ID="valProduct" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">&nbsp;</label>
                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-success btn-sm" ToolTip="Add" OnClick="btnAdd_Click">
                                <i class="fas fa-plus"></i> Add
                            </asp:LinkButton>
                        </div>
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
                        <p class="mst-panel-subtitle">Links waiting to be saved</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:Label ID="lblMessage" runat="server" ClientIDMode="Static" CssClass="link-page-message"></asp:Label>
                <div class="table-responsive">
                    <asp:GridView ID="gvLinks" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover upgradDataGrid"
                        GridLines="None"
                        ShowHeaderWhenEmpty="True"
                        EmptyDataText="No links added yet."
                        OnRowCommand="gvLinks_RowCommand">
                        <RowStyle CssClass="tlrowlight" />
                        <HeaderStyle CssClass="headerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="Sl No">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="BrandName" HeaderText="Brand" />
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="PrdCode" HeaderText="Product Code" />
                            <asp:BoundField DataField="PrdSbl" HeaderText="Vertical" />
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnRemove" runat="server"
                                        CssClass="btn btn-danger btn-sm"
                                        CommandName="RemoveLink"
                                        CommandArgument='<%# Container.DataItemIndex %>'
                                        CausesValidation="False"
                                        OnClientClick="return confirm('Remove this link from the list?');"
                                        ToolTip="Remove">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                <div class="row">
                    <div class="col-md-12 text-center mt-3">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" CausesValidation="False" OnClick="btnReset_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
