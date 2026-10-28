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

        .rm-rawmat-code-link .upgradDataGrid .rm-berger-code-input {
            /*display: block;
            width: 100%;
            min-width: 160px;
            max-width: 240px;
            margin: 0 auto;
            min-height: 40px !important;
            height: 40px !important;
            padding: 8px 12px !important;*/
            background: #ffffff !important;
            /*border: 1px solid #64748b !important;
            border-radius: 8px !important;
            color: #0f172a !important;
            font-size: 14px !important;
            font-weight: 600 !important;
            letter-spacing: 0.02em;*/
            box-shadow: inset 0 1px 3px rgba(15, 23, 42, 0.08) !important;
        }

            .rm-rawmat-code-link .upgradDataGrid .rm-berger-code-input:focus {
                background: #ffffff !important;
                border-color: #2563eb !important;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2), inset 0 1px 3px rgba(15, 23, 42, 0.06) !important;
                outline: none;
            }

            .rm-rawmat-code-link .upgradDataGrid .rm-berger-code-input::placeholder {
                color: #64748b !important;
                font-weight: 400 !important;
                opacity: 1;
            }

            .rm-rawmat-code-link .upgradDataGrid .rm-berger-code-input.field-invalid {
                border-color: #dc3545 !important;
                box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.15) !important;
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
                            <div class="col-md-5">
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
                            <div class="col-md-3">
                                <div class="form-group mb-0">
                                    <label class="form-control-label">&nbsp;</label>
                                    <div class="rm-code-link-search-actions">
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" OnClientClick="return validateRawMaterialCodeLinkingSearch();" ToolTip="Search">Search</asp:LinkButton>
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
                                <p class="mst-panel-subtitle">Enter or update Berger code for each raw material</p>
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
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="45%" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="45%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Berger Code" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtBergerCode" runat="server" CssClass="form-control form-control-sm rm-berger-code-input" AutoComplete="Off"
                                                Placeholder="Enter Berger code" oninput="clearCodeLinkGridFieldValidation(this);"></asp:TextBox>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" CssClass="rm-berger-code-cell" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        <div class="rm-code-link-actions">
                            <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" OnClientClick="return validateRawMaterialCodeLinkingSubmit();" />
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
</asp:Content>
