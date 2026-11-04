<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialCodeLinking.aspx.vb" Inherits="RawMaterialCodeLinking" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
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

        .rm-code-link-actions {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
            padding-top: 8px;
        }

        .rm-code-link-search-actions {
            display: flex;
            align-items: flex-end;
            gap: 8px;
            padding-bottom: 4px;
        }

        .rm-rawmat-code-link .upgradDataGrid td.rm-berger-code-cell {
            background: #f1f5f9 !important;
        }

        .rm-rawmat-code-link .upgradDataGrid .rm-berger-code-ddl {
            width: 100%;
            min-width: 180px;
            background: #ffffff;
        }

        .rm-rawmat-code-link .upgradDataGrid th.rm-not-sold-header {
            white-space: normal !important;
            line-height: 1.35;
            letter-spacing: 0.02em;
        }

        body:has(.rm-module) .select2-container--default .select2-selection--single .select2-selection__rendered {
            text-align: left;
        }
    </style>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                var submitBtn = document.getElementById('btnSubmit');
                if (!submitBtn || submitBtn.disabled === true) {
                    return false;
                }
                validateRawMaterialCodeLinkingSubmit();
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnReset').name, '');
            }
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

        function resetProductField() {
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

        function resetBergerCodeSearchField() {
            var bergerSearch = document.getElementById('<%=txtBergerCodeSearch.ClientID%>');
            if (bergerSearch) {
                bergerSearch.value = '';
            }
            return false;
        }
    </script>
    <script type="text/javascript" src="Scripts/ValidateRawMaterialCodeLinking.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>

    <div class="rm-module rm-compact rm-rawmat-code-link">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material Code Linking</h3>
                    <p class="pageSubTitle">Link Berger codes to raw materials</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanelMain" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Search Raw Material:</label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtSearchText" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearRawMaterialSelection();" Placeholder="Enter Here"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset Raw Material"><i class="fas fa-sync-alt fa-xs"></i></button>
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
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Search Berger Code:</label>
                                    <div class="input-group product-search-group">
                                        <asp:TextBox ID="txtBergerCodeSearch" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" Placeholder="Enter Berger Code"></asp:TextBox>
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetBergerCodeSearchField(); return false;" title="Reset Berger Code"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <%-- 02-11-2026 MUKESH BHAGAT: raw materials and the vendors' packaging items share this page; the Berger code list follows each row's type --%>
                                    <label class="form-control-label">Type:</label>
                                    <asp:DropDownList ID="ddlItemType" runat="server" ClientIDMode="AutoID" CssClass="form-control">
                                        <asp:ListItem Value="" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="RM" Text="Raw Material"></asp:ListItem>
                                        <asp:ListItem Value="PKG" Text="Packaging"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="form-control-label">Status:</label>
                                    <div class="input-group product-search-group">
                                        <asp:DropDownList ID="ddlStatus" runat="server" ClientIDMode="AutoID" CssClass="form-control select2">
                                            <%--<asp:ListItem Text="Select" Value=""></asp:ListItem>
                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                            <asp:ListItem Text="Submitted" Value="Submitted"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 form-btn-mt">
                                <asp:LinkButton CssClass="btn btn-primary rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" OnClientClick="return searchCodeLinkWithLoader();" ToolTip="Search"><i class="fa fa-search" aria-hidden="true"></i></asp:LinkButton>
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-danger btn-sm" OnClick="btnReset_Click" CausesValidation="false" />
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 10px; font-weight: bold; color: red;" Text=""></asp:Label>
                    </div>
                </div>

                <div class="card rm-list-fill">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Raw Material List</h5>
                                <p class="mst-panel-subtitle">Select a Berger code for each raw material</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive rm-grid-scroll">
                            <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                ID="gvrawMatDetails" ClientIDMode="Static" runat="server" AutoGenerateColumns="false" AllowPaging="false" Visible="true"
                                ShowFooter="false" GridLines="both" EmptyDataText="No records found.">
                                <RowStyle CssClass="tlrowlight" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl No" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblrawmatdid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Type" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemType" runat="server" Text='<%# If(Convert.ToString(Eval("item_type")).Trim().ToUpper() = "PKG", "Packaging", "Raw Material") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnItemType" runat="server" Value='<%# Eval("item_type") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Code" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblrawmatcode" runat="server" Text='<%# Bind("Raw_Mat_Code") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnrawmatcode" runat="server" Value='<%# Bind("Raw_Mat_Code") %>' />
                                            <asp:HiddenField ID="hdnId" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblrawmatname" runat="server" Text='<%# Bind("Raw_Mat_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="32%" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="32%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Berger Code" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <%--<asp:DropDownList ID="ddlBergerCode" runat="server" CssClass="form-control select2" onchange="clearCodeLinkGridFieldValidation(this);"></asp:DropDownList>--%>
                                            <%--<asp:DropDownList ID="ddlBergerCode" runat="server" ClientIDMode="AutoID" CssClass="form-control select2" TabIndex="2" onchange="clearCodeLinkGridFieldValidation(this);"></asp:DropDownList>--%>
                                            <%-- 30-10-2026 MUKESH BHAGAT: lazy-loading select2 (ajax, 30 rows a page). The chosen code travels in hdnBergerCode;
                                                 the <select> is rendered by the code-behind with only the saved option, select2 fetches the rest on demand. --%>
                                            <asp:HiddenField ID="hdnBergerCode" runat="server" />
                                            <asp:Literal ID="litBergerSelect" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="25%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="25%" CssClass="rm-berger-code-cell" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Berger doesn't sell this product." HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkBergerNotSold" runat="server" onclick="toggleBergerCodeDropdown(this);" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="rm-not-sold-header" HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        <div class="rm-code-link-actions">
                            <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" OnClientClick="return submitCodeLinkWithLoader();" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSubmit" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script>
        function toggleBergerCodeDropdown(chk) {
            var row = chk.closest ? chk.closest("tr") : null;
            if (!row) {
                return;
            }

            var ddl = row.querySelector("select");
            if (!ddl) {
                return;
            }

            if (chk.checked) {
                ddl.value = "";
                ddl.classList.remove("field-invalid");
                var hdn = row.querySelector("input[id$='hdnBergerCode']");
                if (hdn) { hdn.value = ""; }
            }

            ddl.disabled = chk.checked;
            if (window.jQuery && window.jQuery(ddl).data("select2")) {
                var $ddl = window.jQuery(ddl);
                if (chk.checked) {
                    $ddl.val(null).trigger("change");
                }
                $ddl.prop("disabled", chk.checked);
            }
        }

        /* ---- 30-10-2026 MUKESH BHAGAT: Berger Code = lazy-loading select2 -------------------------------------
           Nothing is loaded with the page except the saved option of each row. Typing (or scrolling the list)
           calls the page method BergerCodeSearch, 30 rows a page. The chosen value is copied to hdnBergerCode,
           which is what the server reads on Submit. */
        var BERGER_PAGE_SIZE = 30;
        function bergerSearchTransport(params, success, failure) {
            var term = (params.data && params.data.term) || '';
            var page = (params.data && params.data.page) || 1;
            // select2 keeps what the transport returns and reads .status / calls .abort() on it - so always hand back an object
            var ctrl = (typeof AbortController === "function") ? new AbortController() : null;
            var req = { status: 200, abort: function () { req.status = 0; if (ctrl) { ctrl.abort(); } } };
            fetch('<%= ResolveUrl("~/RawMaterialCodeLinking.aspx") %>/BergerCodeSearch', {
                method: 'POST', credentials: 'same-origin', signal: ctrl ? ctrl.signal : undefined,
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify({ term: term, page: page, itemType: (params.data && params.data.type) || 'RM' })       // 02-11-2026: RM or PKG items of the Berger item master, by the row's type
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
        function initBergerCodeSelect2() {
            if (!window.jQuery || !window.jQuery.fn.select2) { return; }
            window.jQuery("#gvrawMatDetails select.rm-berger-ajax").each(function () {
                var $ddl = window.jQuery(this);
                if ($ddl.data("select2")) { return; }           // already wired (UpdatePanel re-renders the grid, so new elements arrive clean)
                $ddl.select2({
                    width: "100%",
                    placeholder: "Type to search Berger code",
                    allowClear: true,
                    minimumInputLength: 0,
                    dropdownParent: window.jQuery(document.body),
                    ajax: {
                        delay: 300,
                        transport: bergerSearchTransport,
                        data: function (params) { return { term: params.term || '', page: params.page || 1, type: $ddl.attr('data-type') || 'RM' }; },
                        processResults: function (data, params) {
                            params.page = params.page || 1;
                            return { results: data.items || [], pagination: { more: (params.page * BERGER_PAGE_SIZE) < (data.total || 0) } };
                        },
                        cache: true
                    }
                }).on("change", function () {
                    var row = this.closest("tr");
                    var hdn = row ? row.querySelector("input[id$='hdnBergerCode']") : null;
                    if (hdn) { hdn.value = this.value || ""; }
                    if (typeof clearCodeLinkGridFieldValidation === "function") { clearCodeLinkGridFieldValidation(this); }
                });
            });
        }
        window.jQuery(document).ready(function () { setTimeout(initBergerCodeSelect2, 0); });
        if (typeof Sys !== "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () { setTimeout(initBergerCodeSelect2, 0); });
        }

        // function initBergerCodeSelect2() {
        //     var $grid = window.jQuery("#gvrawMatDetails");
        //     if (!$grid.length || !window.jQuery.fn.select2) {
        //         return;
        //     }

        //     $grid.find("select.select2").each(function () {
        //         var $ddl = window.jQuery(this);
        //         if ($ddl.data("select2")) {
        //             $ddl.select2("destroy");
        //         }
        //         $ddl.select2({
        //             width: "100%",
        //             dropdownParent: window.jQuery(document.body)
        //         });
        //     });
        // }

        // window.jQuery(document).ready(function () {
        //     setTimeout(initBergerCodeSelect2, 0);
        // });

        // if (typeof Sys !== "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager) {
        //     Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        //         setTimeout(initBergerCodeSelect2, 0);
        //     });
        // }

        // window.jQuery(document).on("scroll", ".rm-grid-scroll", function () {
        //     window.jQuery("#gvrawMatDetails select.select2").each(function () {
        //         var $ddl = window.jQuery(this);
        //         if ($ddl.data("select2")) {
        //             $ddl.select2("close");
        //         }
        //     });
        // });
    </script>
</asp:Content>
