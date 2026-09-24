<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FormulationMatrixList.aspx.vb" Inherits="FormulationMatrixList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <div class="rm-module rm-compact rm-formulation-list rm-formulation-matrix-list">
        <script type="text/javascript">
            function onProductSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                var values = (value || "").split('|');
                var productCode = values[0] || "";
                var skuCode = values.length > 1 ? values[1] : "";

                document.getElementById('<%=hdnProductCode.ClientID%>').value = productCode;
                document.getElementById('<%=hdnSkucode.ClientID%>').value = skuCode;
                document.getElementById('<%=hdnProductName.ClientID%>').value = text;
                document.getElementById('<%=txtProductSearch.ClientID%>').value = text;
                sender.get_element().value = text;
            }

            function clearProductSelection() {
                document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
                document.getElementById('<%=hdnSkucode.ClientID%>').value = '';
                document.getElementById('<%=hdnProductName.ClientID%>').value = '';
            }

            function resetProductField() {
                document.getElementById('<%=txtProductSearch.ClientID%>').value = '';
                clearProductSelection();
                return false;
            }

            <%-- function onRawMaterialSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                document.getElementById('<%=txtrawmatid.ClientID%>').value = value;
                document.getElementById('<%=txtSearchText.ClientID%>').value = text;
                sender.get_element().value = text;
            }

            function clearRawMaterialSelection() {
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
            }

            function resetRawMaterialField() {
                document.getElementById('<%=txtSearchText.ClientID%>').value = '';
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
                return false;
            }--%>
        </script>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Formulation Matrix</h3>
                    <p class="pageSubTitle">Browse saved formulation matrix rates</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        <div class="rm-filter-stats-row">
                            <div class="rm-filter-fields">
                                <div class="row" style="align-items: center;">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Vendor:</label>
                                            <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Brand:</label>
                                            <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Product:</label>
                                            <div class="input-group product-search-group">
                                                <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="3" runat="server" AutoComplete="Off" Placeholder="Enter Product" onkeyup="clearProductSelection();"></asp:TextBox>
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset Product"><i class="fas fa-sync-alt fa-xs"></i></button>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                                            <asp:HiddenField ID="hdnProductName" ClientIDMode="Static" runat="server" />
                                            <asp:HiddenField ID="hdnSkucode" ClientIDMode="Static" runat="server" />
                                            <asp:AutoCompleteExtender ID="aceProductSearch" runat="server"
                                                TargetControlID="txtProductSearch"
                                                ServiceMethod="ProductSearch"
                                                CompletionInterval="200"
                                                EnableCaching="false"
                                                CompletionSetCount="20"
                                                FirstRowSelected="true"
                                                OnClientItemSelected="onProductSelected"
                                                CompletionListCssClass="vmsAutoComplete"
                                                CompletionListItemCssClass="vmsAutoCompleteItem"
                                                CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                            </asp:AutoCompleteExtender>
                                        </div>
                                    </div>
                                    <%--<div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Raw Material:</label>
                                            <div class="input-group product-search-group">
                                                <asp:TextBox ID="txtSearchText" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Raw Material" onkeyup="clearRawMaterialSelection();"></asp:TextBox>
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetRawMaterialField(); return false;" title="Reset Raw Material"><i class="fas fa-sync-alt fa-xs"></i></button>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="txtrawmatid" ClientIDMode="Static" runat="server" />
                                            <asp:AutoCompleteExtender ID="aceRawMaterialSearch" runat="server"
                                                TargetControlID="txtSearchText"
                                                ServiceMethod="RawMaterialSearch"
                                                CompletionInterval="200"
                                                EnableCaching="false"
                                                CompletionSetCount="20"
                                                FirstRowSelected="true"
                                                OnClientItemSelected="onRawMaterialSelected"
                                                CompletionListCssClass="vmsAutoComplete"
                                                CompletionListItemCssClass="vmsAutoCompleteItem"
                                                CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                            </asp:AutoCompleteExtender>
                                        </div>
                                    </div>--%>
                                    <div class="col-md-3 text-center">
                                        <div class="rm-filter-actions" style="justify-content: left">
                                            <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                            <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card rm-list-fill">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Matrix List</h5>
                                <p class="mst-panel-subtitle">Saved rates for product formulation raw materials</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="gvFormulationMatrixList" runat="server" AutoGenerateColumns="False" BorderWidth="1"
                                        CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found"
                                        AllowPaging="true" PageSize="10" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                        <RowStyle CssClass="tlrowlight" />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Sl No">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSrl" Text='<%# (gvFormulationMatrixList.PageIndex * gvFormulationMatrixList.PageSize) + Container.DataItemIndex + 1 %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="6%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Formula Set">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblformulaset" Text='<%# Bind("formula_set_no") %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="12%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Vendor">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblvendor" Text='<%# Bind("vendor_name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnvendorcode" Value='<%# Bind("vendor_code") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="12%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Brand">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblbrand" Text='<%# Bind("brand_name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnbrandcode" Value='<%# Bind("brand_code") %>' />
                                                    <%--<asp:HiddenField runat="server" ID="hdnid" Value='<%# Bind("id") %>' />--%>
                                                    <asp:HiddenField runat="server" ID="hdnheaderid" Value='<%# Bind("header_id") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="12%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Product">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblProduct" Text='<%# Bind("product_name")%>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnGridProductCode" Value='<%# Bind("product_code") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="18%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Raw Material">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblraw" Text='<%# Bind("raw_material_details")%>' runat="server" />
                                                    <%--<asp:HiddenField runat="server" ID="hdnRawCode" Value='<%# Bind("rawmat_code") %>' />--%>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="18%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Rate">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRate" Text='<%# Bind("rate")%>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Right" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <div style="display: flex; align-items: center; justify-content: center">
                                                        <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="View" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" CssClass="text-primary"><i class="fa fa-eye"></i></asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                    <asp:PostBackTrigger ControlID="gvFormulationMatrixList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
