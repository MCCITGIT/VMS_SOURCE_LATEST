<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialPoEntry.aspx.vb" Inherits="RawMaterialPoEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <style>
        .p-vendor-select select2-selection select2-selection--single {
            height: 36px !important;
        }

        .po-saved-backdrop {
            background: rgba(31, 41, 55, 0.48);
        }

        .po-saved-popup {
            width: 380px;
            max-width: 92vw;
            margin: 0;
            padding: 0 0 22px;
            background: #ffffff;
            border: 1px solid #eee8de;
            border-radius: 18px;
            box-shadow: 0 22px 48px rgba(31, 41, 55, 0.22);
            overflow: hidden;
            text-align: center;
            font-family: "Inter", Arial, Helvetica, sans-serif;
            animation: po-saved-in 0.28s ease;
        }

            .po-saved-popup::before {
                content: "";
                display: block;
                height: 4px;
                background: linear-gradient(90deg, #15803d 0%, #22a35a 55%, #86efac 100%);
            }

        .po-saved-body {
            padding: 26px 28px 8px;
            background: #ffffff;
        }

        .po-saved-icon {
            width: 58px;
            height: 58px;
            margin: 0 auto 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e8f8ee;
            border: 1px solid #86d5a4;
            border-radius: 50%;
            box-shadow: 0 0 0 8px #f3fbf6;
            color: #15803d;
            font-size: 22px;
            animation: po-saved-pop 0.34s ease;
        }

        .po-saved-title {
            margin: 0 0 6px;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.2;
            letter-spacing: -0.02em;
            color: #111827;
        }

        .po-saved-message {
            display: block;
            margin: 0;
            font-size: 14px;
            font-weight: 500;
            line-height: 1.45;
            color: #64748b;
        }

        .po-saved-number {
            display: inline-block;
            margin: 16px 0 6px;
            padding: 8px 14px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.3;
            letter-spacing: 0.02em;
            color: #15803d;
        }

            .po-saved-number:empty {
                display: none;
            }

        .po-saved-footer {
            padding: 8px 28px 0;
            background: #ffffff;
            text-align: center;
        }

        .po-saved-popup .po-saved-preview,
        .po-saved-popup .po-saved-ok {
            display: inline-block;
            min-width: 140px;
            margin: 0 6px;
            padding: 8px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.4;
            text-decoration: none;
            vertical-align: middle;
        }

        .po-saved-popup .po-saved-preview {
            background: #ffffff;
            border: 1px solid #2f6fed;
            color: #2f6fed;
        }

            .po-saved-popup .po-saved-preview:hover,
            .po-saved-popup .po-saved-preview:focus {
                background: #eef4ff;
                color: #1f5bd6;
            }

        .po-saved-popup .po-saved-ok {
            background: #2f6fed;
            border: 0;
            box-shadow: 0 8px 16px rgba(47, 111, 237, 0.24);
            color: #ffffff;
        }

            .po-saved-popup .po-saved-ok:hover,
            .po-saved-popup .po-saved-ok:focus {
                background: #245ed4;
                color: #ffffff;
            }

        @keyframes po-saved-in {
            from {
                opacity: 0;
                transform: translateY(12px) scale(0.96);
            }

            to {
                opacity: 1;
                transform: none;
            }
        }

        @keyframes po-saved-pop {
            from {
                transform: scale(0.7);
            }

            to {
                transform: scale(1);
            }
        }

        .rm-module .form-control.field-invalid,
        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--single {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .po-grid-invalid {
            border: 1px solid #dc3545 !important;
            border-radius: 12px;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .po-upload-success {
            display: block;
            color: #15803d;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .po-upload-success:empty {
                display: none;
            }

        .po-ref-badge {
            display: inline-block;
            padding: 6px 12px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            color: #15803d;
        }

            .po-ref-badge:empty {
                display: none;
            }
    </style>
    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material PO Entry</h3>
                    <p class="pageSubTitle">Request And Manage Raw Material Requests</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="rm-filter-stats-row">
                    <div class="rm-filter-fields">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-control-label">Upload Filled Template:</label>
                                    <asp:FileUpload ID="fuPoTemplate" runat="server" ClientIDMode="Static" CssClass="form-control" accept=".xls,.xlsx,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mt-3">
                                    <asp:Button ID="btnUploadTemplate" runat="server" Text="Upload" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" CausesValidation="False" OnClick="btnUploadTemplate_Click" OnClientClick="return validatePoTemplateUpload();" />
                                    <asp:Button ID="btnDownloadTemplate" runat="server" Text="Download Template" CssClass="btn btn-success btn-sm" ClientIDMode="Static" CausesValidation="False" OnClick="btnDownloadTemplate_Click" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mt-3">
                                    <asp:Label ID="lblRefPoNo" runat="server" ClientIDMode="Static" CssClass="po-ref-badge"></asp:Label>
                                    <asp:HiddenField ID="hdnRefPoNo" runat="server" ClientIDMode="Static" />
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblUploadMsg" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <%--<asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>--%>
                <div class="rm-filter-stats-row">
                    <div class="rm-filter-fields">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Supplier:<span id="spanVendor" class="mandatory p-vendor-select">*</span></label>
                                    <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                    <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    <asp:HiddenField ID="hdnRmVendor" runat="server" ClientIDMode="Static" />
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Product:<span id="spanProduct" class="mandatory p-vendor-select">*</span></label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Product" onkeyup="clearProductSelection();"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset SKU"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                    </div>
                                    <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                                    <asp:AutoCompleteExtender ID="aceProductSearch" runat="server"
                                        TargetControlID="txtProductSearch"
                                        ServiceMethod="RawMaterialSearch"
                                        CompletionInterval="200"
                                        EnableCaching="false"
                                        CompletionSetCount="20"
                                        FirstRowSelected="true"
                                        OnClientItemSelected="onProductSelected"
                                        CompletionListCssClass="vmsAutoComplete"
                                        CompletionListItemCssClass="vmsAutoCompleteItem"
                                        CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                    </asp:AutoCompleteExtender>
                                    <asp:Label ID="valProduct" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Quantity:<span id="spanQty" class="mandatory">*</span></label>
                                    <asp:TextBox ID="txtQty" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Qty" inputmode="numeric" oninput="this.value = this.value.replace(/[^0-9]/g, '');"></asp:TextBox>
                                    <asp:Label ID="valQty" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Rate:<span id="spanRate" class="mandatory">*</span></label>
                                    <asp:TextBox ID="txtRate" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Rate" inputmode="numeric" oninput="this.value = this.value.replace(/[^0-9]/g, '');"></asp:TextBox>
                                    <asp:Label ID="valRate" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">GST:<span id="spanPrdGst" class="mandatory p-vendor-select">*</span></label>
                                    <asp:DropDownList ID="ddlPrdGst" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server">
                                        <asp:ListItem Text="Select" Value="" />
                                        <asp:ListItem Text="18%" Value="18" />
                                        <asp:ListItem Text="12%" Value="12" />
                                    </asp:DropDownList>
                                    <asp:Label ID="lblPrdGst" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-1">
                                <div class="mt-3">
                                    <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm rm-btn-icon" ClientIDMode="Static" ToolTip="Add" OnClick="ImgbtnAdd_Click"><i class="fas fa-plus"></i></asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="rm-filter-stats-row">
                    <div class="rm-filter-fields">
                        <div class="row">
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Freight:<span id="spanFreight" class="mandatory">*</span></label>
                                    <asp:TextBox ID="txtFreight" ClientIDMode="Static" CssClass="form-control" TabIndex="4" runat="server" AutoComplete="Off" Placeholder="Enter Freight" inputmode="numeric" oninput="this.value = this.value.replace(/[^0-9]/g, '');"></asp:TextBox>
                                    <asp:Label ID="lblFreight" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Freight GST:</label>
                                    <asp:DropDownList ID="ddlGst" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server">
                                        <asp:ListItem Text="Select" Value="" />
                                        <asp:ListItem Text="18%" Value="18" />
                                        <asp:ListItem Text="12%" Value="12" />
                                    </asp:DropDownList>
                                    <asp:Label ID="lblGst" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card rm-list-fill" runat="server" id="tr1">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Product List</h5>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:Panel ID="pnlPoGrid" runat="server" CssClass="table-responsive rm-grid-scroll">
                                <asp:GridView ID="gvPoItems"
                                    runat="server"
                                    AutoGenerateColumns="False"
                                    CssClass="table table-hover upgradDataGrid"
                                    GridLines="None"
                                    ShowHeaderWhenEmpty="True"
                                    EmptyDataText="No items added yet."
                                    OnRowCommand="gvPoItems_RowCommand">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />

                                    <Columns>
                                        <%--<asp:BoundField DataField="VendorName" HeaderText="Vendor" />--%>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                        <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                        <asp:BoundField DataField="Qty" HeaderText="Qty" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="Rate" HeaderText="Rate" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="Gst" HeaderText="GST %" DataFormatString="{0:0.##}" />
                                        <asp:BoundField DataField="GstAmount" HeaderText="GST Amt" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />

                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnRemoveItem"
                                                    runat="server"
                                                    CssClass="btn btn-danger btn-sm"
                                                    CommandName="RemoveItem"
                                                    CommandArgument='<%# Container.DataItemIndex %>'
                                                    CausesValidation="False"
                                                    OnClientClick="return confirm('Remove this item from the grid?');"
                                                    ToolTip="Remove">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                            <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </ContentTemplate>
                        <%--<Triggers>
                            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                            <asp:PostBackTrigger ControlID="gvFormulationList" />
                        </Triggers>--%>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-center mt-3">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" OnClick="btnSubmit_Click" OnClientClick="return validatePoSubmit();" />
                    <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" OnClick="btnBack_Click" />
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hdnPoSavedTarget" runat="server" />
    <asp:ModalPopupExtender ID="mpePoSaved" runat="server"
        TargetControlID="hdnPoSavedTarget"
        PopupControlID="pnlPoSaved"
        BackgroundCssClass="po-saved-backdrop">
    </asp:ModalPopupExtender>
    <asp:Panel ID="pnlPoSaved" runat="server" CssClass="po-saved-popup" Style="display: none;">
        <div class="po-saved-body">
            <div class="po-saved-icon"><i class="fas fa-check"></i></div>
            <h5 class="po-saved-title">Success</h5>
            <asp:Label ID="lblPoSavedMessage" runat="server" CssClass="po-saved-message" Text="PO saved successfully."></asp:Label>
            <asp:Label ID="lblPoNo" runat="server" CssClass="po-saved-number"></asp:Label>
        </div>
        <div class="po-saved-footer">
            <asp:HyperLink ID="lnkPreviewPdf" runat="server" Target="_blank" CssClass="btn po-saved-preview" Text="Preview PDF" Visible="false"></asp:HyperLink>
            <asp:Button ID="btnPoSavedOk" runat="server" Text="OK" CssClass="btn po-saved-ok" OnClick="btnPoSavedOk_Click" />
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function onProductSelected(sender, e) {
            var value = e.get_value();
            var text = e.get_text();
            document.getElementById('<%=hdnProductCode.ClientID%>').value = value;
            document.getElementById('<%=txtProductSearch.ClientID%>').value = text;
            sender.get_element().value = text;
        }

        function clearProductSelection() {
            document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
        }

        function resetProductField() {
            var rawMatText = document.getElementById('<%=txtProductSearch.ClientID%>');
            var rawMatCode = document.getElementById('<%=hdnProductCode.ClientID%>');

            if (rawMatText) {
                rawMatText.value = '';
            }
            if (rawMatCode) {
                rawMatCode.value = '';
            }

            return false;
        }

        function clearPoField(controlId, labelId) {
            var control = document.getElementById(controlId);
            var label = document.getElementById(labelId);
            if (control) {
                control.classList.remove("field-invalid");
            }
            if (label) {
                label.innerHTML = "";
            }
        }

        function setPoFieldError(controlId, labelId, message) {
            var control = document.getElementById(controlId);
            var label = document.getElementById(labelId);
            if (control) {
                control.classList.add("field-invalid");
            }
            if (label) {
                label.innerHTML = message;
            }
        }

        function clearPoGridError() {
            var panel = document.getElementById("<%=pnlPoGrid.ClientID%>");
            var label = document.getElementById("valGrid");
            if (panel) {
                panel.classList.remove("po-grid-invalid");
            }
            if (label) {
                label.innerHTML = "";
            }
        }

        function setPoGridError(message) {
            var panel = document.getElementById("<%=pnlPoGrid.ClientID%>");
            var label = document.getElementById("valGrid");
            if (panel) {
                panel.classList.add("po-grid-invalid");
            }
            if (label) {
                label.innerHTML = message;
            }
        }

        function poGridHasItems() {
            var grid = document.getElementById("<%=gvPoItems.ClientID%>");
            if (!grid) {
                return false;
            }
            return (grid.innerText || "").indexOf("No items added yet.") < 0;
        }

        function validatePoSubmit() {
            clearPoField("ddlVendor", "valVendor");
            clearPoField("ddlGst", "lblGst");
            clearPoField("txtFreight", "lblFreight");
            clearPoGridError();

            var vendor = document.getElementById("ddlVendor");
            if (!vendor || vendor.value.trim() === "") {
                setPoFieldError("ddlVendor", "valVendor", "Please select a vendor.");
                return false;
            }

            var freight = document.getElementById("txtFreight");
            var freightText = freight ? freight.value.trim() : "";
            var freightNumber = Number(freightText);
            if (freightText === "" || isNaN(freightNumber) || freightNumber < 0) {
                setPoFieldError("txtFreight", "lblFreight", "Please enter a valid freight.");
                return false;
            }

            if (!poGridHasItems()) {
                setPoGridError("Please add at least one product.");
                return false;
            }

            return rmConfirmPostback("btnSubmit", "submit");
        }

        function validatePoTemplateUpload() {
            var label = document.getElementById("lblUploadMsg");
            var fileInput = document.getElementById("fuPoTemplate");
            var fileName = fileInput ? fileInput.value.trim().toLowerCase() : "";

            if (label) {
                label.className = "dispatch-field-error";
                label.innerHTML = "";
            }

            if (fileName === "") {
                if (label) {
                    label.innerHTML = "Please choose the filled template to upload.";
                }
                return false;
            }

            if (!/\.(xls|xlsx)$/.test(fileName)) {
                if (label) {
                    label.innerHTML = "Only Excel files (.xls, .xlsx) can be uploaded.";
                }
                return false;
            }

            return true;
        }
    </script>
</asp:Content>

