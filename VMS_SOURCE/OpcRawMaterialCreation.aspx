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
                    <%-- 05-11-2026: the captions follow the login - vendor = Packaging, HO = Raw Material (set in Page_Load) --%>
                    <h3 class="pageTitle"><asp:Label ID="lblPageTitle" runat="server" Text="Raw Material / Packaging Creation"></asp:Label></h3>
                    <p class="pageSubTitle"><asp:Label ID="lblPageSub" runat="server" Text="HO creates raw materials for all vendors; vendors create their packaging items"></asp:Label></p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-flask"></i></span>
                    <div>
                        <h5 class="mst-panel-title"><asp:Label ID="lblPanelTitle" runat="server" Text="Item Details"></asp:Label></h5>
                        <p class="mst-panel-subtitle"><asp:Label ID="lblPanelSub" runat="server" Text="Enter the item name. The code is generated on save."></asp:Label></p>
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
                    <%-- 04-11-2026 MUKESH BHAGAT: the item type is no longer chosen. HO enters raw materials (for ALL vendors); a vendor (UNIT login) enters packaging only.
                         ddlItemType stays on the page (hidden) so the saved type of an edited item is known. --%>
                    <asp:Panel ID="pnlType" runat="server" Visible="false" CssClass="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Type:</label>
                            <asp:DropDownList ID="ddlItemType" runat="server" ClientIDMode="Static" CssClass="form-control">
                                <asp:ListItem Value="RM" Text="Raw Material"></asp:ListItem>
                                <asp:ListItem Value="PKG" Text="Packaging"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlVendor" runat="server" CssClass="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                            <asp:DropDownList ID="ddlVendor" runat="server" ClientIDMode="Static" CssClass="form-control select2"></asp:DropDownList>
                            <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlScope" runat="server" Visible="false" CssClass="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Applies to:</label>
                            <asp:TextBox ID="txtScope" runat="server" CssClass="form-control" ReadOnly="true" Text="All vendors"></asp:TextBox>
                        </div>
                    </asp:Panel>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label"><asp:Label ID="lblNameCaption" runat="server" Text="Name:"></asp:Label><span class="mandatory">*</span></label>
                            <asp:TextBox ID="txtRmName" runat="server" ClientIDMode="Static" CssClass="form-control" AutoComplete="Off" MaxLength="200" onkeyup="clearRmCreationValidation();"></asp:TextBox>
                            <asp:Label ID="valRmName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <%-- HO only, raw material: link the Berger code here, or tick "Berger doesn't buy this product" (same columns as Raw Material Code Linking).
                         Both can be left empty and linked later on Raw Material Code Linking. --%>
                    <%-- 05-11-2026: order = Name, then the tick box, then the Berger Code (the tick box switches the dropdown off) --%>
                    <asp:Panel ID="pnlBergerTick" runat="server" Visible="false" CssClass="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">&nbsp;</label>
                            <div class="checkRadioGroup" style="padding-top: 6px;">
                                <asp:CheckBox ID="chkBergerNotBuy" runat="server" ClientIDMode="Static" Text="&nbsp;Berger doesn't buy this product" />
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlBerger" runat="server" Visible="false" CssClass="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Berger Code:</label>
                            <asp:HiddenField ID="hdnBergerCode" runat="server" ClientIDMode="Static" />
                            <asp:Literal ID="litBergerSelect" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>
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
    <script type="text/javascript">
        /* 04-11-2026 MUKESH BHAGAT: Berger Code = lazy-loading select2 (page method BergerCodeSearch of this page, 30 rows a page, raw material items only).
           The chosen code is copied to hdnBergerCode, which is what the server reads on Submit. Ticking "Berger doesn't buy" clears and disables it. */
        var BERGER_PAGE_SIZE = 30;
        function bergerSearchTransport(params, success, failure) {
            var term = (params.data && params.data.term) || '';
            var page = (params.data && params.data.page) || 1;
            var ctrl = (typeof AbortController === "function") ? new AbortController() : null;
            var req = { status: 200, abort: function () { req.status = 0; if (ctrl) { ctrl.abort(); } } };
            fetch('<%= ResolveUrl("~/OpcRawMaterialCreation.aspx") %>/BergerCodeSearch', {
                method: 'POST', credentials: 'same-origin', signal: ctrl ? ctrl.signal : undefined,
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify({ term: term, page: page })
            }).then(function (r) {
                req.status = r.status;
                if (!r.ok) { return r.text().then(function (t) { throw new Error('HTTP ' + r.status + ' ' + t.substring(0, 300)); }); }
                return r.json();
            }).then(function (j) { success(j.d || { items: [], total: 0 }); })
              .catch(function (err) {
                  if (req.status !== 0 && window.console) { console.error('Berger code search failed:', err); }
                  try { failure(); } catch (e) { }
              });
            return req;
        }
        function toggleBergerNotBuy() {
            var chk = document.getElementById('chkBergerNotBuy');
            var sel = document.getElementById('ddlBergerCode');
            var hdn = document.getElementById('hdnBergerCode');
            if (!chk || !sel) { return; }
            var $sel = window.jQuery(sel);
            if (chk.checked) {
                if (hdn) { hdn.value = ''; }
                $sel.val(null).trigger('change.select2');
                $sel.prop('disabled', true);
            } else {
                $sel.prop('disabled', false);
            }
        }
        function initBergerCodeSelect2() {
            if (!window.jQuery || !window.jQuery.fn.select2) { return; }
            var el = document.getElementById('ddlBergerCode');
            if (!el) { return; }
            var $ddl = window.jQuery(el);
            if ($ddl.data("select2")) { return; }
            $ddl.select2({
                width: "100%",
                placeholder: "Type to search Berger code",
                allowClear: true,
                minimumInputLength: 0,
                dropdownParent: window.jQuery(document.body),
                ajax: {
                    delay: 300,
                    transport: bergerSearchTransport,
                    data: function (params) { return { term: params.term || '', page: params.page || 1 }; },
                    processResults: function (data, params) {
                        params.page = params.page || 1;
                        return { results: data.items || [], pagination: { more: (params.page * BERGER_PAGE_SIZE) < (data.total || 0) } };
                    },
                    cache: true
                }
            }).on("change", function () {
                var hdn = document.getElementById('hdnBergerCode');
                if (hdn) { hdn.value = this.value || ""; }
            });
            var chk = document.getElementById('chkBergerNotBuy');
            if (chk) { chk.addEventListener('click', toggleBergerNotBuy); }
            toggleBergerNotBuy();
        }
        window.jQuery(document).ready(function () { setTimeout(initBergerCodeSelect2, 0); });
    </script>
</asp:Content>
