<%@ Page Title="Link Raw Material" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorRawMaterialLink.aspx.vb" Inherits="VendorRawMaterialLink" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module textarea.form-control.field-invalid {
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
    </style>
    <div class="rm-module rm-vendor-link">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript" src="Scripts/VendorRawMaterialLinking.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>

        <script type="text/javascript">
            document.onkeydown = checkValue;
            function checkValue() {
                if (event.keyCode == 118) { // button Add (F7 keypress)
                    if (document.getElementById('btnSubmit').disabled == true)
                        return false;
                    else {
                        // button Add (F7 keypress)
                        validateVendorRawMaterialLinkAdd();
                    }
                    //__doPostBack(document.getElementById('btnSubmit').name, '');
                }
                else if (event.keyCode == 119) {
                    __doPostBack(document.getElementById('btnCancel').name, '');
                }
            }

            function disableBackButton() {
                window.history.forward(1);
            }

            function onRawMaterialSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                document.getElementById('<%=txtrawmatid.ClientID%>').value = value;
                document.getElementById('<%=txtSearchText.ClientID%>').value = text;
                sender.get_element().value = text;
                if (typeof clearRawMatValidation === 'function') {
                    clearRawMatValidation();
                }
            }

            function clearRawMaterialSelection() {
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
                if (typeof clearRawMatValidation === 'function') {
                    clearRawMatValidation();
                }
            }

            function resetRawMaterialField() {
                var rawMatText = document.getElementById('<%=txtSearchText.ClientID%>');
                var rawMatCode = document.getElementById('<%=txtrawmatid.ClientID%>');

                if (rawMatText) {
                    rawMatText.value = '';
                }
                if (rawMatCode) {
                    rawMatCode.value = '';
                }

                if (typeof clearRawMatValidation === 'function') {
                    clearRawMatValidation();
                }

                return false;
            }
        </script>
        <script type="text/javascript">
            function onProductSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                document.getElementById('<%=hdnVendorCode.ClientID%>').value = value;
                <%-- document.getElementById('<%=txtVendorSearch.ClientID%>').value = text + " (" + value + ")";
                sender.get_element().value = text + " (" + value + ")";--%>
                document.getElementById('<%=txtVendorSearch.ClientID%>').value = text;
                sender.get_element().value = text;

                setProductSearchState(true);
                if (typeof clearVendorValidation === 'function') {
                    clearVendorValidation();
                }
            }

            function clearProductSelection() {
                document.getElementById('<%=hdnVendorCode.ClientID%>').value = '';
                if (typeof clearVendorValidation === 'function') {
                    clearVendorValidation();
                }
            }

            function resetVendorField() {
                document.getElementById('<%=txtVendorSearch.ClientID%>').value = '';
                document.getElementById('<%=hdnVendorCode.ClientID%>').value = '';
                setProductSearchState(false);
                if (typeof clearVendorValidation === 'function') {
                    clearVendorValidation();
                }
            }
            function setProductSearchState(isLocked) {
                var txtProduct = document.getElementById('txtVendorSearch');
                var btnReset = document.getElementById('btnVendor');

                if (btnReset) {
                    btnReset.disabled = !!isLocked;
                }

                if (txtProduct && isLocked) {
                    txtProduct.setAttribute('readonly', 'readonly');
                }
            }
            function resetRawmatField() {
                document.getElementById('<%=txtSearchText.ClientID%>').value = '';
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
                if (typeof clearRawMatValidation === 'function') {
                    clearRawMatValidation();
                }
            }
        </script>

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Raw Material Linking</h3>
                    <p class="pageSubTitle">Link raw materials to their vendors</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-link"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Link Raw Material</h5>
                                <p class="mst-panel-subtitle">Search a raw material and link it to the selected vendor</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <%--<div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:<span id="Span1" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                        </div>--%>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtVendorSearch" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearProductSelection();" Placeholder="Enter Vendor"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" id="btnVendor" class="btn btn-outline-secondary product-reset-btn" onclick="resetVendorField(); return false;" title="Reset Vendor"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                    </div>
                                    <asp:HiddenField ID="hdnVendorCode" ClientIDMode="Static" runat="server" />
                                    <asp:AutoCompleteExtender ID="aceVendorSearch" runat="server"
                                        TargetControlID="txtVendorSearch"
                                        ServiceMethod="VendorSearch"
                                        CompletionInterval="200"
                                        EnableCaching="false"
                                        CompletionSetCount="20"
                                        FirstRowSelected="true"
                                        OnClientItemSelected="onProductSelected"
                                        CompletionListCssClass="vmsAutoComplete"
                                        CompletionListItemCssClass="vmsAutoCompleteItem"
                                        CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                    </asp:AutoCompleteExtender>
                                    <asp:Label ID="valVendorSearch" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Search Raw Material:<span id="Span2" class="mandatory">*</span></label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtSearchText" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearRawMaterialSelection();" Placeholder="Enter Here"></asp:TextBox>
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
                                    <asp:Label ID="valSearchText" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group rm-vendor-link-add">
                                    <label class="form-control-label">&nbsp;</label>
                                    <div class="rm-filter-actions">
                                        <%--<asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ToolTip="Add"><i class="fas fa-plus"></i></asp:LinkButton>--%>
                                        <asp:Button
                                            ID="btnAdd"
                                            runat="server"
                                            Text="+"
                                            CssClass="btn btn-success btn-sm rm-btn-icon"
                                            ToolTip="Add" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvVendorRawMat" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                        EmptyDataText="No records added." GridLines="both">
                                        <RowStyle CssClass="tlrowlight" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Vendor Name">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="hdnId" runat="server" Value='<%# Bind("id") %>' />
                                                    <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                                    <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="rawmat_code" HeaderText="Raw Material Code" ReadOnly="true" />
                                            <asp:BoundField DataField="rawmat_name" HeaderText="Raw Material Name" ReadOnly="true" />
                                            <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblactiveText" runat="server" CssClass='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "Active", "Inactive") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="ddlactive" CssClass="form-control form-control-sm rm-status-ddl" runat="server">
                                                        <asp:ListItem Text="Active" Value="Y"></asp:ListItem>
                                                        <asp:ListItem Text="Inactive" Value="N"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEdit" CommandName="Edit" runat="server" CssClass="btn btn-info btn-sm gridBtn mr-1" ToolTip="Edit"
                                                        Visible='<%# (Not String.IsNullOrWhiteSpace(Convert.ToString(Eval("id")))) %>'><i class="fas fa-edit"></i></asp:LinkButton>
                                                    <asp:LinkButton ID="btnDeleteRow" runat="server" CommandName="DeleteRow" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-danger btn-sm" ToolTip="Delete" OnClientClick="return rmConfirmAction(this, 'delete');"><i class="fas fa-trash"></i></asp:LinkButton>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <div class="rm-edit-actions">
                                                        <asp:LinkButton ID="btnUpdate" CommandName="Update" CssClass="btn rm-grid-btn rm-grid-btn-save" runat="server" ToolTip="Update" OnClientClick="return rmConfirmStatusUpdate(this);"><i class="fas fa-check"></i></asp:LinkButton>
                                                        <asp:LinkButton ID="btncancel" CommandName="Cancel" CssClass="btn rm-grid-btn rm-grid-btn-cancel" runat="server" ToolTip="Cancel"><i class="fas fa-times"></i></asp:LinkButton>
                                                    </div>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        <div class="row">
                            <div class="col-md-12 text-center">
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" Visible="false" />
                                <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" />

                            </div>
                        </div>
                        <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
