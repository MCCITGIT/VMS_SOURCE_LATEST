<%@ Page Title="Vendor Factory Link" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorFactoryLink.aspx.vb" Inherits="VendorFactoryLink" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--single {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }
        .dispatch-field-error { display: block; color: #dc3545; font-size: 12px; font-weight: 500; margin-top: 4px; line-height: 1.35; }
        .dispatch-field-error:empty { display: none; }
        .vfl-hint { display: block; font-size: 11px; color: #6c757d; margin-top: 4px; }
        .vfl-sub { font-size: 11px; color: #6c757d; }
        .vfl-type { display: inline-block; padding: 1px 6px; border-radius: 8px; background: #f1f3f5; color: #495057; font-size: 10.5px; margin-left: 4px; }
        .vfl-type.is-mfg { background: #e9f7ef; color: #1e7e34; }
        .vfl-current { margin-top: 2px; padding: 8px 10px; border-radius: 6px; background: #f6f8fb; border: 1px solid #e3e8ee; font-size: 12.5px; }
    </style>
    <div class="rm-module rm-vendor-factory">
        <%-- the result popup (RmActionPopup.Show) needs rmShowResult from this script --%>
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript">
            function vflSetError(id, lbl, msg) { var c = document.getElementById(id), l = document.getElementById(lbl); if (c) { c.classList.add('field-invalid'); } if (l) { l.innerHTML = msg; } }
            function vflClearError(id, lbl) { var c = document.getElementById(id), l = document.getElementById(lbl); if (c) { c.classList.remove('field-invalid'); } if (l) { l.innerHTML = ''; } }

            /* factory autocomplete (MSTRDB.mstr_org, org_type FACTORY): value = org_code, text = "300:Howrah - Mfg (SHIBPUR) [MFG]" */
            function onFactorySelected(sender, e) {
                document.getElementById('hdnOrgCode').value = e.get_value();
                document.getElementById('txtFactorySearch').value = e.get_text();
                sender.get_element().value = e.get_text();
                vflClearError('txtFactorySearch', 'valFactory');
            }
            function clearFactorySelection() { document.getElementById('hdnOrgCode').value = ''; vflClearError('txtFactorySearch', 'valFactory'); }
            function resetFactoryField() {
                document.getElementById('txtFactorySearch').value = '';
                document.getElementById('hdnOrgCode').value = '';
                vflClearError('txtFactorySearch', 'valFactory');
                return false;
            }
            function validateSaveLink() {
                var ok = true, v = document.getElementById('ddlVendor');
                vflClearError('ddlVendor', 'valVendor'); vflClearError('txtFactorySearch', 'valFactory');
                if (!v || v.value === '') { vflSetError('ddlVendor', 'valVendor', 'Please select Vendor.'); ok = false; }
                if ((document.getElementById('hdnOrgCode').value || '') === '') { vflSetError('txtFactorySearch', 'valFactory', 'Please select the factory from the list.'); ok = false; }
                return ok;
            }
        </script>

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Vendor Factory Link</h3>
                    <p class="pageSubTitle">The Berger factory nearest to each FG vendor. HO and the Material Department compare a vendor's raw-material prices with the cost at that factory.</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hdnOrgCode" ClientIDMode="Static" runat="server" />

                <%-- ================= entry ================= --%>
                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-industry"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Link a vendor to its factory</h5>
                                <p class="mst-panel-subtitle">One factory per vendor. Saving a different factory replaces the current one (the old link is kept inactive).</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="rm-filter-stats-row">
                            <div class="rm-filter-fields">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                                            <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Factory:<span class="mandatory">*</span></label>
                                            <div class="input-group product-search-group">
                                                <asp:TextBox ID="txtFactorySearch" ClientIDMode="Static" CssClass="form-control" TabIndex="2" runat="server" AutoComplete="Off"
                                                    Placeholder="Type 2+ letters: code, name or city" onkeyup="clearFactorySelection();"></asp:TextBox>
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="return resetFactoryField();" title="Reset"><i class="fas fa-sync-alt fa-xs"></i></button>
                                                </div>
                                            </div>
                                            <asp:AutoCompleteExtender ID="aceFactory" runat="server" TargetControlID="txtFactorySearch" ServiceMethod="FactorySearch" MinimumPrefixLength="2"
                                                CompletionInterval="200" EnableCaching="false" CompletionSetCount="20" FirstRowSelected="true" OnClientItemSelected="onFactorySelected"
                                                CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem" CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                            </asp:AutoCompleteExtender>
                                            <asp:Label ID="valFactory" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Remarks:</label>
                                            <asp:TextBox ID="txtRemarks" ClientIDMode="Static" CssClass="form-control" runat="server" TabIndex="3" MaxLength="500" AutoComplete="Off"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <asp:Panel ID="pnlCurrent" runat="server" Visible="false" CssClass="vfl-current">
                                            <b>Current factory of this vendor:</b> <asp:Literal ID="litCurrent" runat="server"></asp:Literal>
                                        </asp:Panel>
                                        <span class="vfl-hint"><asp:Literal ID="litHint" runat="server" Text="Select a vendor to see its factory."></asp:Literal></span>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 text-center">
                                        <asp:Button ID="btnSave" runat="server" Text="Save factory" CssClass="btn btn-primary btn-sm" OnClientClick="return validateSaveLink();" OnClick="btnSave_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary btn-sm" OnClick="btnReset_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="errormsg"></asp:Label>
                    </div>
                </div>

                <%-- ================= overview ================= --%>
                <div class="card rm-list-fill">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Vendor factories</h5>
                                <p class="mst-panel-subtitle"><asp:Literal ID="litListSub" runat="server" Text="Every vendor with a factory. Edit loads the vendor into the form above."></asp:Literal></p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvAll" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid" EmptyDataText="No vendor linked yet." GridLines="both"
                                OnRowCommand="gvAll_RowCommand" OnRowDataBound="gvAll_RowDataBound">
                                <RowStyle CssClass="tlrowlight" />
                                <HeaderStyle CssClass="headerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor">
                                        <ItemTemplate><%# Eval("vendor_name") %><br /><span class="vfl-sub"><%# Eval("vfl_vendor_code") %></span></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Factory">
                                        <ItemTemplate>
                                            <%# Eval("vfl_org_code") %> &ndash; <%# Eval("org_name") %><span class='<%# IIf(Convert.ToString(Eval("depo_type")) = "MFG", "vfl-type is-mfg", "vfl-type") %>'><%# Eval("depo_type") %></span><br />
                                            <span class="vfl-sub"><%# Eval("org_city") %><%# IIf(Convert.ToString(Eval("org_state")) = "", "", ", " & Convert.ToString(Eval("org_state"))) %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="vfl_remarks" HeaderText="Remarks" />
                                    <asp:TemplateField HeaderText="Last changed">
                                        <ItemTemplate><%# Eval("last_changed_by") %><br /><span class="vfl-sub"><%# Eval("last_changed", "{0:dd-MMM-yyyy HH:mm}") %></span></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="70px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditVendor" CommandArgument='<%# Eval("vfl_vendor_code") %>' CssClass="btn btn-info btn-sm gridBtn" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
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
