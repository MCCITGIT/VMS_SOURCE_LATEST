<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FormulationMstrList.aspx.vb" Inherits="FormulationMstrList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <div class="rm-module rm-compact rm-formulation-list">
        <script type="text/javascript">
            function onProductSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                document.getElementById('<%=hdnProductCode.ClientID%>').value = value;
                document.getElementById('<%=txtProductSearch.ClientID%>').value = text + " (" + value + ")";
                sender.get_element().value = text + " (" + value + ")";
            }

            function clearProductSelection() {
                document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
        }

        function resetProductField() {
            document.getElementById('<%=txtProductSearch.ClientID%>').value = '';
            document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
        }
        </script>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Product Formulation</h3>
                    <p class="pageSubTitle">Browse product formulation records</p>
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
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Brand:</label>
                                            <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Vendor:<span id="Span2" class="mandatory">*</span></label>
                                            <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                            <asp:HiddenField ID="HiddenField1" runat="server" ClientIDMode="Static" />
                                        </div>
                                    </div>
                                    <div class="col-md-3" runat="server" visible="false">
                                        <div class="form-group">
                                            <label class="form-control-label">Raw Material:</label>
                                            <asp:DropDownList ID="ddlRawMat" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Product:</label>
                                            <div class="input-group product-search-group">
                                                <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Product" onkeyup="clearProductSelection();"></asp:TextBox>
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset SKU"><i class="fas fa-sync-alt fa-xs"></i></button>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
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
                                    <div class="col-md-3">
                                        <div class="rm-filter-actions">
                                            <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                            <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--<div class="rm-stat-row">
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                <div>
                                    <p class="rm-stat-label">Total</p>
                                    <p class="rm-stat-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-green"><i class="fas fa-tags"></i></div>
                                <div>
                                    <p class="rm-stat-label">Brands</p>
                                    <p class="rm-stat-value is-green"><asp:Label ID="lblBrandCount" runat="server" Text="0"></asp:Label></p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-orange"><i class="fas fa-boxes"></i></div>
                                <div>
                                    <p class="rm-stat-label">SKUs</p>
                                    <p class="rm-stat-value is-orange"><asp:Label ID="lblSkuCount" runat="server" Text="0"></asp:Label></p>
                                </div>
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
                                <h5 class="mst-panel-title">Brand List</h5>
                                <p class="mst-panel-subtitle">All brands currently available for product mapping</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="gvFormulationList" runat="server" AutoGenerateColumns="False" BorderWidth="1"
                                        CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found"
                                        AllowPaging="true" PageSize="10" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                                        <RowStyle CssClass="tlrowlight" />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Srl No" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSrl" Text='<%# (gvFormulationList.PageIndex * gvFormulationList.PageSize) + Container.DataItemIndex + 1 %>' runat="server" />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Brand" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblbrand" Text='<%# Bind("Brand_Name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnbrandcode" Value='<%# Bind("Brand_Code") %>' />
                                                    <asp:HiddenField runat="server" ID="hdnid" Value='<%# Bind("fh_id") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="8%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Vendor" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblvendor" Text='<%# Bind("vendor_name") %>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnvendorcode" Value='<%# Bind("vendor_code") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="8%" />
                                            </asp:TemplateField>
                                            <%--<asp:TemplateField HeaderText="Raw Material" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblraw" Text='<%# Bind("Raw_Mat_Name")%>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnRawCode" Value='<%# Bind("Raw_Mat_Code") %>' />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="6%" />
                                        </asp:TemplateField>--%>
                                            <asp:TemplateField HeaderText="Sku" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSku" Text='<%# Bind("Sku_Desc")%>' runat="server" />
                                                    <asp:HiddenField runat="server" ID="hdnSkucode" Value='<%# Bind("Sku_Code") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Left" Width="6%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Version">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblVersion" Text='<%# Eval("sf_version") %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="SKU Price (&#8377;)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSkuPrice" Text='<%# String.Format("{0:0.00}", Eval("sf_sku_price")) %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Right" Width="6%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Packs">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPacks" Text='<%# Eval("pack_count") %>' runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <div style="display: flex; align-items: center; justify-content: center">
                                                        <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="View" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" CssClass="text-primary"><i class="fa fa-eye"></i></asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                                <ControlStyle></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                    <asp:PostBackTrigger ControlID="gvFormulationList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

