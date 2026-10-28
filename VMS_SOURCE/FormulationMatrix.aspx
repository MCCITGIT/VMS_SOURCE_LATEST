<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FormulationMatrix.aspx.vb" Inherits="FormulationMatrix" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .form-control.field-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12);
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
    </style>
    <div class="rm-module rm-compact rm-formulation-matrix">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript" src="Scripts/ValidateFormulationMatrix.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
        <script type="text/javascript">
            function setProductSearchState(isLocked) {
                var txtProduct = document.getElementById('txtProductSearch');
                var btnReset = document.getElementById('btnResetProduct');

                if (btnReset) {
                    btnReset.disabled = !!isLocked;
                }

                if (txtProduct && isLocked) {
                    txtProduct.setAttribute('readonly', 'readonly');
                }
            }

            function onProductSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                var values = (value || "").split('|');
                var productCode = values[0] || "";
                var skuCode = values.length > 1 ? values[1] : "";

                document.getElementById('<%=hdnProductCode.ClientID%>').value = productCode;
                document.getElementById('<%=hdnSkucode.ClientID%>').value = skuCode;
                document.getElementById('<%=txtProductSearch.ClientID%>').value = text;
                document.getElementById('<%=hdnProductName.ClientID%>').value = text;
                setProductSearchState(true);
                sender.get_element().value = text;
                if (typeof clearProductValidation === "function") {
                    clearProductValidation();
                }
            }

            function clearProductSelection() {
                document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
                if (typeof clearProductValidation === "function") {
                    clearProductValidation();
                }
            }

            function resetProductField() {
                var txtProduct = document.getElementById('txtProductSearch');
                var hdnProductCode = document.getElementById('<%=hdnProductCode.ClientID%>');
                var hdnProductName = document.getElementById('<%=hdnProductName.ClientID%>');
                var hdnSkucode = document.getElementById('<%=hdnSkucode.ClientID%>');

                if (txtProduct) {
                    txtProduct.value = '';
                    txtProduct.disabled = false;
                    txtProduct.removeAttribute('readonly');
                }
                if (hdnProductCode) {
                    hdnProductCode.value = '';
                }
                if (hdnProductName) {
                    hdnProductName.value = '';
                }
                if (hdnSkucode) {
                    hdnSkucode.value = '';
                }

                setProductSearchState(false);
                if (typeof clearProductValidation === "function") {
                    clearProductValidation();
                }
                __doPostBack('<%=btnResetProductPostback.UniqueID%>', '');
            }

            function syncProductResetButtonState() {
                var txtProduct = document.getElementById('txtProductSearch');
                var btnReset = document.getElementById('btnResetProduct');
                if (!txtProduct || !btnReset) {
                    return;
                }

                var isLocked = txtProduct.disabled ||
                    txtProduct.readOnly ||
                    txtProduct.getAttribute('readonly') === 'readonly';
                btnReset.disabled = isLocked;
            }

            function allowRateTwoDecimal(evt, control) {
                var charCode = evt.which ? evt.which : evt.keyCode;
                if (charCode === 8 || charCode === 9 || charCode === 13 || charCode === 37 || charCode === 39 || charCode === 46) {
                    return true;
                }

                var charValue = String.fromCharCode(charCode);
                if (!/[0-9.]/.test(charValue)) {
                    return false;
                }

                var value = control.value || "";
                if (charValue === ".") {
                    return value.indexOf(".") === -1;
                }

                var dotIndex = value.indexOf(".");
                if (dotIndex !== -1) {
                    var decimals = value.substring(dotIndex + 1);
                    var hasSelection = control.selectionStart !== control.selectionEnd;
                    if (!hasSelection && control.selectionStart > dotIndex && decimals.length >= 2) {
                        return false;
                    }
                }

                return true;
            }

            function sanitizeRateTwoDecimal(control) {
                var value = control.value || "";
                value = value.replace(/[^0-9.]/g, "");

                if (value.indexOf(".") !== -1) {
                    var parts = value.split(".");
                    value = parts[0] + "." + parts.slice(1).join("");
                }

                var dotIndex = value.indexOf(".");
                if (dotIndex !== -1) {
                    var intPart = value.substring(0, dotIndex);
                    var decPart = value.substring(dotIndex + 1, dotIndex + 3);
                    value = intPart + "." + decPart;
                }

                control.value = value;
            }

            function formatRateTwoDecimal(control) {
                var value = (control.value || "").trim();
                if (value === "") {
                    return;
                }

                var numValue = parseFloat(value);
                if (isNaN(numValue)) {
                    control.value = "";
                    return;
                }

                control.value = numValue.toFixed(2);
            }

            document.addEventListener('DOMContentLoaded', syncProductResetButtonState);
        </script>

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>               
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Formulation Matrix</h3>
                    <p class="pageSubTitle">Enter and update rates for the selected product formulation</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-flask"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Search Formulation</h5>
                        <p class="mst-panel-subtitle">Select a product to load its available raw material formulation</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Product:<span class="mandatory">*</span></label>
                            <div class="input-group product-search-group">
                                <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="1" runat="server" AutoComplete="Off" Placeholder="Enter Product" onkeyup="clearProductSelection();"></asp:TextBox>
                                <div class="input-group-append">
                                    <button type="button" id="btnResetProduct" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset Product">
                                        <i class="fas fa-sync-alt fa-xs"></i>
                                    </button>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                            <asp:HiddenField ID="hdnProductName" ClientIDMode="Static" runat="server" />
                            <asp:HiddenField ID="hdnSkucode" ClientIDMode="Static" runat="server" />
                            <asp:HiddenField ID="hdnEditHeaderId" ClientIDMode="Static" runat="server" />
                            <asp:AutoCompleteExtender ID="aceProductSearch" runat="server" TargetControlID="txtProductSearch" ServiceMethod="ProductSearch" CompletionInterval="200" EnableCaching="false" CompletionSetCount="20" FirstRowSelected="true" OnClientItemSelected="onProductSelected"
                                CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem" CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                            </asp:AutoCompleteExtender>
                            <asp:Label ID="valProductSearch" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                            <asp:LinkButton ID="btnResetProductPostback" runat="server" Style="display: none;" OnClick="btnResetProductPostback_Click"></asp:LinkButton>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label d-none d-md-block">&nbsp;</label>
                            <div class="rm-filter-actions">
                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm rm-btn-icon" ClientIDMode="Static" CausesValidation="false" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Text=""></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Formulation List</h5>
                        <p class="mst-panel-subtitle">Available raw materials for the selected product. Enter rate and submit or update</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-fit-grid">
                    <asp:GridView ID="gvFormulationMatrix" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                        EmptyDataText="Select a product to view formulation details." GridLines="both">
                        <RowStyle CssClass="tlrowlight" />
                        <HeaderStyle CssClass="headerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="Sl No" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblSlNo" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="6%" />
                                <ItemStyle HorizontalAlign="Center" CssClass="col-sl" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Formula Set">
                                <ItemTemplate>
                                    <asp:Label ID="lblFormulaSet" runat="server" Text='<%# Bind("formula_set_no") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" CssClass="formula-set-cell" VerticalAlign="Middle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Vendor">
                                <ItemTemplate>
                                    <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" CssClass="col-vendor" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Brand">
                                <ItemTemplate>
                                    <asp:Label ID="lblBrandName" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnId" runat="server" Value='<%# Bind("id") %>' />
                                    <asp:HiddenField ID="hdnHeaderId" runat="server" Value='<%# Bind("header_id") %>' />
                                    <asp:HiddenField ID="hdnBrandCode" runat="server" Value='<%# Bind("brand_code") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" CssClass="col-brand" />
                            </asp:TemplateField>                            
                            <asp:TemplateField HeaderText="Product Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblProductName" runat="server" Text='<%# Bind("product_name") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnGridProductCode" runat="server" Value='<%# Bind("product_code") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" CssClass="col-product" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Raw Material Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblRawMatName" runat="server" Text='<%# Bind("rawmat_name") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnRawMatCode" runat="server" Value='<%# Bind("rawmat_code") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" CssClass="col-rm" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Consumption Ratio">
                                <ItemTemplate>
                                    <asp:Label ID="lblRatio" runat="server" Text='<%# Bind("ratio") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" CssClass="col-ratio" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rate">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRate" runat="server" CssClass="form-control form-control-sm text-right" Text='<%# Bind("rate") %>' AutoComplete="Off"
                                        onkeypress="return allowRateTwoDecimal(event, this);"
                                        oninput="sanitizeRateTwoDecimal(this); if (typeof clearGridValidation === 'function') { clearGridValidation(); }"
                                        onblur="formatRateTwoDecimal(this);"></asp:TextBox>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="12%" />
                                <ItemStyle HorizontalAlign="Right" CssClass="col-rate" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnUpdateRow" runat="server" CommandName="SaveRow" CommandArgument='<%# Container.DataItemIndex %>'
                                        CausesValidation="false" CssClass="text-success" ToolTip="Save"
                                        OnClientClick="return validateFormulationMatrixUpdate(this);"><i class="fas fa-save"></i></asp:LinkButton>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="8%" />
                                <ItemStyle HorizontalAlign="Center" CssClass="col-action" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                <div class="row">
                    <div class="col-md-12 text-center">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" Visible="false"
                            CausesValidation="false" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
