<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialVendorMstr.aspx.vb" Inherits="RawMaterialVendorMstr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        /*.rm-module .form-control.field-invalid,
        .rm-module textarea.form-control.field-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }*/

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
    </style>

    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript" src="Scripts/ValidateRawMaterialVendorMstr.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    validateRawMaterialVendorInputs();
                }
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="rm-module rm-compact">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material Vendor Master - Add</h3>
                    <p class="pageSubTitle">Create and maintain raw material vendor records</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-truck"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Vendor Details</h5>
                        <p class="mst-panel-subtitle">Basic identification for the raw material vendor</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:Label ID="lblConfirmMsg" Visible="true" Style="color: Red; font-size: small; font-weight: bold;" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Vendor Code:<span id="lblGroup1" class="mandatory">*</span></label>
                            <div class="dFlexC">
                                <asp:TextBox CssClass="form-control" ID="txtUnitCode" ClientIDMode="Static" MaxLength="5" ReadOnly="true" runat="server" TabIndex="1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Name:<span id="lblGroup2" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtUnitName" ClientIDMode="Static" MaxLength="20" runat="server" AutoComplete="Off" TabIndex="2" onkeyup="clearUnitNameValidation();"></asp:TextBox>
                            <asp:Label ID="valUnitName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">GST Registration Number:<span id="lblGroup3" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtGstRegNo" ClientIDMode="Static" runat="server" AutoComplete="Off" TabIndex="3" onkeyup="clearGstRegNoValidation();"></asp:TextBox>
                            <asp:Label ID="valGstRegNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
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
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-control-label">Address:<span id="lblGroup4" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtLine1" ClientIDMode="Static" TextMode="MultiLine" Rows="3" AutoComplete="Off" runat="server" TabIndex="4" onkeyup="clearLine1Validation();" oninput="clearLine1Validation();"></asp:TextBox>
                            <asp:Label ID="valLine1" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">City:<span id="lblGroup5" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtCity" ClientIDMode="Static" AutoComplete="Off" runat="server" TabIndex="5" onkeyup="clearCityValidation();"></asp:TextBox>
                            <asp:Label ID="valCity" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">State:<span id="lblGroup6" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtState" ClientIDMode="Static" AutoComplete="Off" runat="server" TabIndex="6" onkeyup="clearStateValidation();"></asp:TextBox>
                            <asp:Label ID="valState" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Pincode:<span id="lblGroup7" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtPin" ClientIDMode="Static" AutoComplete="Off" runat="server" TabIndex="7" onkeyup="clearPinValidation();"></asp:TextBox>
                            <asp:Label ID="valPin" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-info-circle"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Other Details</h5>
                        <p class="mst-panel-subtitle">Contact information and active status</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Contact Person:<span id="lblGroup8" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtContactPerson" ClientIDMode="Static" AutoComplete="Off" runat="server" TabIndex="8" onkeyup="clearContactPersonValidation();"></asp:TextBox>
                            <asp:Label ID="valContactPerson" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Mobile Number:<span id="lblGroup9" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtMobileNo" ClientIDMode="Static" MaxLength="10" runat="server" AutoComplete="Off" TabIndex="9"
                                onkeypress="return allowOnlyMobileNumberKey(event);"
                                oninput="sanitizeMobileNumberInput(this); clearMobileNoValidation();"></asp:TextBox>
                            <asp:Label ID="valMobileNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">E-mail:<span id="lblGroup10" class="mandatory">*</span></label>
                            <asp:TextBox CssClass="form-control" ID="txtEmail" ClientIDMode="Static" AutoComplete="Off" runat="server" TabIndex="10" onkeyup="clearEmailValidation();"></asp:TextBox>
                            <asp:Label ID="valEmail" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Active:<span id="lblGroup11" class="mandatory">*</span></label>
                            <div class="checkRadioGroup">
                                <asp:RadioButton ID="rbtnActiveY" Text="Yes" GroupName="activeRadio" Checked="true" runat="server" />
                                <asp:RadioButton ID="rbtnActiveN" Text="No" GroupName="activeRadio" runat="server" />
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="padding-left: 15px;"></asp:Label>
                    <div id="divErrorMessage"></div>

                </div>
                <div class="row mt-3">
                    <div class="col-md-12 text-center">
                        <asp:Button ID="btnSubmit" ClientIDMode="Static" TabIndex="31" runat="server" Text="Submit" CssClass="btn btn-success btn-sm" OnClick="btnSubmit_Click" />
                        <asp:LinkButton ID="btnCancel" TabIndex="32" runat="server" CssClass="btn btn-secondary btn-sm">Back</asp:LinkButton>
                        <asp:LinkButton ID="btnReset" TabIndex="33" runat="server" CssClass="btn btn-danger btn-sm">Reset</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

