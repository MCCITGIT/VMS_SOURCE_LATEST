<%@ Page Title="Vendor Scope" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorScope.aspx.vb" Inherits="VendorScope" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--single,
        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--multiple {
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

        /* pack multi-select (select2 tags) */
        .rm-module .select2-container--default .select2-selection--multiple {
            min-height: 34px;
            border-color: #ced4da;
        }

            .rm-module .select2-container--default .select2-selection--multiple .select2-selection__choice {
                background: #e8f1fb;
                border-color: #c9ddf3;
                color: #1f4e79;
                font-size: 12px;
                margin-top: 4px;
            }

            .rm-module .select2-container--default .select2-selection--multiple .select2-selection__choice__remove {
                color: #1f4e79;
            }

        .scope-hint {
            display: block;
            font-size: 11px;
            color: #6c757d;
            margin-top: 4px;
        }

        .scope-pill {
            display: inline-block;
            min-width: 34px;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11.5px;
            font-weight: 600;
            text-align: center;
        }

            .scope-pill.is-all {
                background: #e9f7ef;
                color: #1e7e34;
            }

            .scope-pill.is-some {
                background: #e8f1fb;
                color: #1f4e79;
            }

        .scope-list-sub {
            font-size: 11px;
            color: #42505d;
        }
        .headerGrid-subTex {
            font-size: 10px;
            color: #dfe6ed;
        }

        /* shade-wise pack table */
        .scope-shades {
            max-height: 420px;
            overflow-y: auto;
            border: 1px solid #e3e8ee;
            border-radius: 6px;
        }

            .scope-shades table {
                margin: 0;
            }

            .scope-shades th {
                position: sticky;
                top: 0;
                z-index: 1;
            }

            .scope-shades td {
                vertical-align: middle;
                padding: 6px 8px;
            }

            .scope-shades .scope-shade-name {
                white-space: nowrap;
                font-weight: 600;
            }

                .scope-shades .scope-shade-name small {
                    display: block;
                    font-weight: 400;
                    color: #6c757d;
                }

            .scope-shades tr.is-off td {
                opacity: .55;
            }

            .scope-shades tr.is-off .select2-container {
                pointer-events: none;
            }

        .scope-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
            font-size: 12px;
        }

            .scope-toolbar a {
                margin-left: 10px;
            }
    </style>

    <script type="text/javascript">
        /* ---------- small field helpers (same look as the other procurement pages) ---------- */
        function vsSetError(controlId, labelId, message) {
            var c = document.getElementById(controlId), l = document.getElementById(labelId);
            if (c) { c.classList.add('field-invalid'); }
            if (l) { l.innerHTML = message; }
        }
        function vsClearError(controlId, labelId) {
            var c = document.getElementById(controlId), l = document.getElementById(labelId);
            if (c) { c.classList.remove('field-invalid'); }
            if (l) { l.innerHTML = ''; }
        }

        /* ---------- product autocomplete: searches inside the selected vertical ---------- */
        function vsVertical() { var d = document.getElementById('ddlVertical'); return d ? (d.value || '') : ''; }
        function vsSetProductContext() {
            if (typeof $find !== 'function') { return; }
            var b = $find('bhvScopeProduct');
            if (b) { b.set_contextKey(vsVertical()); }
        }
        function onVerticalChanged() {
            vsClearError('ddlVertical', 'valVertical');
            vsSetProductContext();
            resetProductField();
        }
        function onProductSelected(sender, e) {
            document.getElementById('hdnProductCode').value = e.get_value();
            document.getElementById('hdnProductName').value = e.get_text();
            document.getElementById('txtProductSearch').value = e.get_text();
            sender.get_element().value = e.get_text();
            vsClearError('txtProductSearch', 'valProduct');
            __doPostBack('<%= btnProductPicked.UniqueID %>', '');     // loads the shade-wise pack table of this product
        }
        function clearProductSelection() {
            document.getElementById('hdnProductCode').value = '';
            vsClearError('txtProductSearch', 'valProduct');
        }
        function resetProductField() {
            var t = document.getElementById('txtProductSearch');
            if (t) { t.value = ''; }
            document.getElementById('hdnProductCode').value = '';
            document.getElementById('hdnProductName').value = '';
            vsClearError('txtProductSearch', 'valProduct');
            return false;
        }
        function focusProductIfEmpty() {
            var t = document.getElementById('txtProductSearch');
            if (vsVertical() === '') { vsSetError('ddlVertical', 'valVertical', 'Please select Vertical first.'); if (t) { t.blur(); } return false; }
            return true;
        }

        /* ---------- shade-wise pack table ---------- */
        function vsShadeToggled(cb) {
            var tr = cb.closest('tr');
            if (tr) { tr.classList.toggle('is-off', !cb.checked); }
            vsCountShades();
        }
        function vsAllShades(on) {
            document.querySelectorAll('.scope-shades input.scope-shade-chk').forEach(function (cb) { cb.checked = on; vsShadeToggled(cb); });
            return false;
        }
        function vsCountShades() {
            var all = document.querySelectorAll('.scope-shades input.scope-shade-chk'), on = 0;
            all.forEach(function (cb) { if (cb.checked) { on++; } });
            var l = document.getElementById('lblShadeCount');
            if (l) { l.innerText = all.length === 0 ? '' : (on === 0 ? 'No shade ticked = every shade (and every pack) is allowed.' : on + ' of ' + all.length + ' shade(s) allowed.'); }
        }
        function vsInitShades() {
            document.querySelectorAll('.scope-shades input.scope-shade-chk').forEach(function (cb) { var tr = cb.closest('tr'); if (tr) { tr.classList.toggle('is-off', !cb.checked); } });
            vsCountShades();
        }

        function validateScopeSave() {
            var ok = true;
            vsClearError('ddlVendor', 'valVendor'); vsClearError('ddlVertical', 'valVertical'); vsClearError('txtProductSearch', 'valProduct');
            var v = document.getElementById('ddlVendor');
            if (!v || v.value === '') { vsSetError('ddlVendor', 'valVendor', 'Please select Vendor.'); ok = false; }
            if (vsVertical() === '') { vsSetError('ddlVertical', 'valVertical', 'Please select Vertical.'); ok = false; }
            if ((document.getElementById('hdnProductCode').value || '') === '') { vsSetError('txtProductSearch', 'valProduct', 'Please select Product from the list.'); ok = false; }
            return ok;
        }

        function vsPageInit() { vsSetProductContext(); vsInitShades(); }
        document.addEventListener('DOMContentLoaded', vsPageInit);
        if (window.Sys && Sys.Application) { Sys.Application.add_load(vsPageInit); }
    </script>

    <div class="rm-module rm-compact rm-vendor-scope">
        <%-- the result popup (RmActionPopup.Show) needs rmShowResult from this script --%>
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Scope</h3>
                    <p class="pageSubTitle">Declare which products, shades and packs each vendor makes. Product Formulation offers a vendor only what is declared here.</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnProductName" ClientIDMode="Static" runat="server" />
                <asp:Button ID="btnProductPicked" runat="server" ClientIDMode="Static" Style="display: none;" OnClick="btnProductPicked_Click" UseSubmitBehavior="false" CausesValidation="false" />

                <%-- ================= scope entry ================= --%>
                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-sitemap"></i></span>
                            <div>
                                <h5 class="mst-panel-title">
                                    <asp:Literal ID="litFormTitle" runat="server" Text="Declare scope"></asp:Literal></h5>
                                <p class="mst-panel-subtitle">Vendor &rarr; Vertical &rarr; Product &rarr; shades, each with its own packs. Untick a shade to exclude it; leave a shade's packs empty to allow all of them.</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="rm-filter-stats-row">
                            <div class="rm-filter-fields">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" onchange="vsClearError('ddlVendor','valVendor');"></asp:DropDownList>
                                            <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Vertical:<span class="mandatory">*</span></label>
                                            <asp:DropDownList ID="ddlVertical" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server" onchange="onVerticalChanged();"></asp:DropDownList>
                                            <asp:Label ID="valVertical" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label class="form-control-label">Product:<span class="mandatory">*</span></label>
                                            <div class="input-group product-search-group">
                                                <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="3" runat="server" AutoComplete="Off"
                                                    Placeholder="Type 3+ letters of the code or name" onfocus="focusProductIfEmpty();" onkeyup="clearProductSelection();"></asp:TextBox>
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="return resetProductField();" title="Reset Product"><i class="fas fa-sync-alt fa-xs"></i></button>
                                                </div>
                                            </div>
                                            <asp:AutoCompleteExtender ID="aceProductSearch" runat="server" TargetControlID="txtProductSearch" ServiceMethod="ProductSearch" UseContextKey="true" BehaviorID="bhvScopeProduct"
                                                CompletionInterval="200" EnableCaching="false" CompletionSetCount="20" FirstRowSelected="true" OnClientItemSelected="onProductSelected"
                                                CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem" CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                            </asp:AutoCompleteExtender>
                                            <asp:Label ID="valProduct" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <%-- shade-wise packs: one row per shade of the product (a single "(no shade)" row for products without shades) --%>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label class="form-control-label">Shades &amp; packs:</label>
                                            <asp:Panel ID="pnlShades" runat="server" Visible="false">
                                                <div class="scope-toolbar">
                                                    <span id="lblShadeCount" class="scope-hint" style="margin: 0;"></span>
                                                    <span><a href="#" onclick="return vsAllShades(true);">Tick all</a><a href="#" onclick="return vsAllShades(false);">Untick all</a></span>
                                                </div>
                                                <div class="scope-shades table-responsive">
                                                    <table class="table table-sm table-hover upgradDataGrid">
                                                        <thead>
                                                            <tr class="headerGrid">
                                                                <th style="width: 48px;">Allow</th>
                                                                <th style="width: 28%;">Shade</th>
                                                                <th>Packs <span class="headerGrid-subTex">(empty = all packs of this shade)</span></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <asp:Repeater ID="rptShades" runat="server">
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td class="text-center">
                                                                            <asp:HiddenField ID="hdnShd" runat="server" Value='<%# Eval("shd_code") %>' />
                                                                            <asp:CheckBox ID="chkShade" runat="server" CssClass="scope-shade-chk-wrap" />
                                                                        </td>
                                                                        <td class="scope-shade-name"><%# Eval("shd_name") %><small><%# Eval("pack_hint") %></small></td>
                                                                        <td>
                                                                            <asp:ListBox ID="lstPacks" runat="server" SelectionMode="Multiple" CssClass="form-control select2" data-placeholder="All packs" Style="width: 100%;"></asp:ListBox>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </asp:Panel>
                                            <span class="scope-hint">
                                                <asp:Literal ID="litShadeHint" runat="server" Text="Pick a product first."></asp:Literal></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 text-center">
                                        <asp:Button ID="btnSave" runat="server" Text="Save scope" CssClass="btn btn-primary btn-sm" OnClientClick="return validateScopeSave();" OnClick="btnSave_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary btn-sm" OnClick="btnReset_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="errormsg"></asp:Label>
                    </div>
                </div>

                <%-- ================= declared scopes ================= --%>
                <div class="card rm-list-fill">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Declared scopes</h5>
                                <p class="mst-panel-subtitle">
                                    <asp:Literal ID="litListSub" runat="server" Text="Every active scope, grouped by vendor. Edit opens it in the form above."></asp:Literal>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvScope" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                EmptyDataText="No scope declared yet." GridLines="both" DataKeyNames="vs_id" OnRowCommand="gvScope_RowCommand" OnRowDataBound="gvScope_RowDataBound">
                                <RowStyle CssClass="tlrowlight" />
                                <HeaderStyle CssClass="headerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor">
                                        <ItemTemplate>
                                            <%# Eval("vendor_name") %><br />
                                            <span class="scope-list-sub"><%# Eval("vs_vendor_code") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="vs_sbl" HeaderText="Vertical" />
                                    <asp:TemplateField HeaderText="Product">
                                        <ItemTemplate>
                                            <%# Eval("vs_prd_code") %>
                                            <span class="scope-list-sub" style="display: block;"><%# Eval("prd_name") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Shades" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="20%">
                                        <ItemTemplate>
                                            <span class='<%# IIf(Convert.ToInt32(Eval("shade_count")) = 0, "scope-pill is-all", "scope-pill is-some") %>'><%# IIf(Convert.ToInt32(Eval("shade_count")) = 0, "All", Eval("shade_count")) %></span>
                                            <span class="scope-list-sub" style="display: block; text-align: left;"><%# Eval("shade_names") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Packs (per shade)" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="22%">
                                        <ItemTemplate>
                                            <span class='<%# IIf(Convert.ToInt32(Eval("pack_count")) = 0, "scope-pill is-all", "scope-pill is-some") %>'><%# IIf(Convert.ToInt32(Eval("pack_count")) = 0, "All", Eval("pack_count")) %></span>
                                            <span class="scope-list-sub" style="display: block; text-align: left;"><%# Eval("pack_names") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Declared by">
                                        <ItemTemplate>
                                            <%# Eval("created_by") %><br />
                                            <span class="scope-list-sub"><%# Eval("created_on", "{0:dd-MMM-yyyy}") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditScope" CommandArgument='<%# Eval("vs_id") %>' CssClass="text-info" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
                                            <asp:LinkButton ID="btnDeactivate" runat="server" CommandName="DeactivateScope" CommandArgument='<%# Eval("vs_id") %>' CssClass="text-danger" ToolTip="Deactivate" OnClientClick="return confirm('Deactivate this scope? The vendor will no longer see this product on Product Formulation.');"><i class="fas fa-trash"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
