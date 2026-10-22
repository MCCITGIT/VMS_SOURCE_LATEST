<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FGVendorMstrDtls.aspx.vb" Inherits="FGVendorMstrDtls" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module textarea.form-control.field-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--single {
            border: 1px solid #dc3545 !important;
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

        .fg-vendor-code-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .fg-vendor-code-row .form-control {
                flex: 1;
                min-width: 0;
            }

            .fg-vendor-code-row .btn {
                white-space: nowrap;
                flex: 0 0 auto;
            }
    </style>
    <div class="rm-module">
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript" src="Scripts/ValidateFGVendorMstrDtls.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {              
                document.getElementById('btnSubmit').click()             
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
            else if (event.keyCode == 120) { // button Search (F9 keypress)
                __doPostBack(document.getElementById('btnReset').name, '');
            }
        }

        function onVendorSelected(sender, e) {
            var value = e.get_value();
            var text = e.get_text();
            document.getElementById('hdnVendorId').value = value;
            document.getElementById('txtVendorSearch').value = text;
            sender.get_element().value = text;
            __doPostBack('<%= btnLoadVendor.UniqueID %>', '');
        }

        function clearVendorSelection() {
            document.getElementById('hdnVendorId').value = '';
        }

        function resetVendorField() {
            document.getElementById('txtVendorSearch').value = '';
            document.getElementById('hdnVendorId').value = '';
            __doPostBack('<%= btnLoadVendor.UniqueID %>', '');
            return false;
        }
    </script>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">FG Vendor Master - Add</h3>
                <p class="pageSubTitle">Create and maintain vendor records</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Label ID="lblConfirmMsg" Visible="true" Style="color: Red; font-size: small; font-weight: bold;" runat="server"></asp:Label>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-truck"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Vendor Details</h5>
                            <p class="mst-panel-subtitle">Basic identification for the FG vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-control-label">Vendor :<span id="lblGroup1" class="mandatory">*</span></label>
                                <div class="fg-vendor-code-row">
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtVendorSearch" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearVendorSelection();" Placeholder="Enter Here"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetVendorField(); return false;" title="Reset Vendor"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                    </div>
                                    <asp:Button ID="btnLoadVendor" runat="server" ClientIDMode="Static" Text="Load" CssClass="btn btn-primary btn-sm" CausesValidation="false" UseSubmitBehavior="false" OnClick="btnLoadVendor_Click" />
                                </div>
                                <asp:HiddenField ID="hdnVendorId" ClientIDMode="Static" runat="server" />
                                <asp:AutoCompleteExtender ID="aceVendorSearch" runat="server"
                                    TargetControlID="txtVendorSearch"
                                    ServiceMethod="VendorSearch"
                                    CompletionInterval="200"
                                    EnableCaching="false"
                                    CompletionSetCount="20"
                                    FirstRowSelected="true"
                                    OnClientItemSelected="onVendorSelected"
                                    CompletionListCssClass="vmsAutoComplete"
                                    CompletionListItemCssClass="vmsAutoCompleteItem"
                                    CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                </asp:AutoCompleteExtender>
                            </div>
                        </div>                
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-map-marker-alt"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Address Details</h5>
                            <p class="mst-panel-subtitle">Registered address of the vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine1" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 02:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine2" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>                       
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">City:</label>
                                <asp:TextBox CssClass="form-control" ID="txtCity" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">State:</label>
                                <asp:TextBox CssClass="form-control" ID="txtState" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">District:</label>
                                <asp:TextBox CssClass="form-control" ID="txtdistrict" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Pin:</label>
                                <asp:TextBox CssClass="form-control" ID="txtPin" MaxLength="6" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-map-marker-alt"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Site Details</h5>
                            <p class="mst-panel-subtitle">Registered site deatisl of the vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Site Id:<span class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlsiteid" ClientIDMode="Static" CssClass="form-control select2" runat="server"></asp:DropDownList>
                                <asp:Label ID="valSite" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                            </div>
                        </div>            
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                    <div class="row mt-3">
                        <div class="col-md-12 text-center">
                            <asp:LinkButton ID="btnSubmit" TabIndex="31" runat="server" ClientIDMode="Static" CssClass="btn btn-success btn-sm" OnClientClick="return validateFGVendorSubmit();">Submit</asp:LinkButton>                            
                            <asp:LinkButton ID="btnReset" TabIndex="33" runat="server" CssClass="btn btn-danger btn-sm">Reset</asp:LinkButton>
                            <asp:LinkButton ID="btnBack" TabIndex="34" runat="server" CssClass="btn btn-secondary btn-sm" CausesValidation="false" OnClick="btnBack_Click">Back</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnBack" />
        </Triggers>
    </asp:UpdatePanel>
    </div>
</asp:Content>
