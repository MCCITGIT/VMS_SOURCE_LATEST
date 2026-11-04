<%@ Page Title="Raw Material Creation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OpcRawMaterialCreation.aspx.vb" Inherits="OpcRawMaterialCreation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
    </style>
    <script type="text/javascript">
        function clearRmCreationValidation() {
            var vendor = document.getElementById('ddlVendor');
            var name = document.getElementById('txtRmName');
            var valVendor = document.getElementById('valVendor');
            var valName = document.getElementById('valRmName');
            if (vendor) { vendor.classList.remove('field-invalid'); }
            if (name) { name.classList.remove('field-invalid'); }
            if (valVendor) { valVendor.innerHTML = ''; }
            if (valName) { valName.innerHTML = ''; }
        }

        function setRmFieldError(controlId, labelId, message) {
            var control = document.getElementById(controlId);
            var label = document.getElementById(labelId);
            if (control) { control.classList.add('field-invalid'); }
            if (label) { label.innerHTML = message; }
        }

        function validateOpcRawMaterialCreation() {
            clearRmCreationValidation();
            var isValid = true;
            var vendor = document.getElementById('ddlVendor');
            var name = document.getElementById('txtRmName');
            var vendorValue = vendor ? (vendor.value || '').replace(/^\s+|\s+$/g, '') : '';
            var nameValue = name ? (name.value || '').replace(/^\s+|\s+$/g, '') : '';

            if (vendor && !vendor.disabled && vendorValue === '') {
                setRmFieldError('ddlVendor', 'valVendor', 'Please select a vendor.');
                isValid = false;
            }
            if (nameValue === '') {
                setRmFieldError('txtRmName', 'valRmName', 'Enter the name.');
                isValid = false;
            } else if (nameValue.length < 3) {
                setRmFieldError('txtRmName', 'valRmName', 'Name must be at least 3 characters.');
                isValid = false;
            }
            return isValid;
        }
    </script>

    <div class="rm-module rm-compact rsm-page">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material / Packaging Creation</h3>
                    <p class="pageSubTitle">Create and maintain vendor raw material and packaging entries</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-flask"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Item Details</h5>
                        <p class="mst-panel-subtitle">Pick the type, the vendor and the name. The code is generated on save (MAN... raw material, PKG... packaging). Packaging items are created by the vendor.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:Label ID="lblMessage" runat="server" ClientIDMode="Static" CssClass="errormsg"></asp:Label>
                <div class="row">
                    <asp:Panel ID="pnlRmCode" runat="server" CssClass="col-md-3" Visible="false">
                        <div class="form-group">
                            <label class="form-control-label">Code:</label>
                            <asp:TextBox ID="txtRmCode" runat="server" ClientIDMode="Static" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                    </asp:Panel>
                    <div class="col-md-3">
                        <div class="form-group">
                            <%-- 02-11-2026 MUKESH BHAGAT: Type RM / PKG - packaging items share this master; only a vendor (UNIT) login can create a Packaging item --%>
                            <label class="form-control-label">Type:<span class="mandatory">*</span></label>
                            <asp:DropDownList ID="ddlItemType" runat="server" ClientIDMode="Static" CssClass="form-control">
                                <asp:ListItem Value="RM" Text="Raw Material"></asp:ListItem>
                                <asp:ListItem Value="PKG" Text="Packaging"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                            <asp:DropDownList ID="ddlVendor" runat="server" ClientIDMode="Static" CssClass="form-control select2"></asp:DropDownList>
                            <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Name:<span class="mandatory">*</span></label>
                            <asp:TextBox ID="txtRmName" runat="server" ClientIDMode="Static" CssClass="form-control" AutoComplete="Off" MaxLength="200" onkeyup="clearRmCreationValidation();"></asp:TextBox>
                            <asp:Label ID="valRmName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <asp:Panel ID="pnlActive" runat="server" CssClass="col-md-3" Visible="false">
                        <div class="form-group">
                            <label class="form-control-label">Active:<span class="mandatory">*</span></label>
                            <div class="checkRadioGroup">
                                <asp:RadioButton ID="rbtnActiveY" Text="Yes" GroupName="activeRadio" Checked="true" runat="server" />
                                <asp:RadioButton ID="rbtnActiveN" Text="No" GroupName="activeRadio" runat="server" />
                            </div>
                        </div>
                    </asp:Panel>
                </div>
                <div class="row">
                    <div class="col-md-12 text-center mt-3">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" OnClientClick="return validateOpcRawMaterialCreation();" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" CausesValidation="False" OnClick="btnReset_Click" Visible="false" />
                        <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" CausesValidation="False" OnClick="btnBack_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>
