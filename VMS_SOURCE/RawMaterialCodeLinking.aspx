<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialCodeLinking.aspx.vb" Inherits="RawMaterialCodeLinking" %>

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
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
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
    <div class="rm-module rm-compact rm-rawmat-code-link">
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
                            <div class="col-md-4">
                                <div class="form-group mb-0">
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
                            <div class="col-md-4">
                                <div class="form-group mb-0">
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
                                <div class="form-group mb-0">
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
                            <div class="col-md-2">
                                <div class="form-group mb-0">
                                    <label class="form-control-label">&nbsp;</label>
                                    <div class="rm-code-link-search-actions">
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" OnClientClick="return searchCodeLinkWithLoader();" ToolTip="Search">Search</asp:LinkButton>
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-danger btn-sm" OnClick="btnReset_Click" CausesValidation="false" />
                                    </div>
                                </div>
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
                                    <asp:TemplateField HeaderText="Raw Material Code" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblrawmatcode" runat="server" Text='<%# Bind("Raw_Mat_Code") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnrawmatcode" runat="server" Value='<%# Bind("Raw_Mat_Code") %>' />
                                            <asp:HiddenField ID="hdnId" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Raw Material Name" HeaderStyle-HorizontalAlign="Center">
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
                                            <asp:DropDownList ID="ddlBergerCode" runat="server" ClientIDMode="AutoID" CssClass="form-control select2"></asp:DropDownList>
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
            }

            ddl.disabled = chk.checked;
            if (window.jQuery && window.jQuery(ddl).data("select2")) {
                var $ddl = window.jQuery(ddl);
                if (chk.checked) {
                    $ddl.val("").trigger("change");
                }
                $ddl.prop("disabled", chk.checked);
            }
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
