<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialMaster.aspx.vb" Inherits="RawMaterialMaster" %>

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
    </style>
    <div class="rm-module rm-compact rm-rawmat-master">
    <%-- AutoComplete suggestion list styling now lives in includes/upgrad-style.css
         (.vmsAutoComplete / .vmsAutoCompleteItem / .vmsAutoCompleteItemHighlight) --%>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    // button Add (F7 keypress)
                    validateSKUList();
                }
                //__doPostBack(document.getElementById('btnSubmit').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }

        function onRawMaterialSelected(sender, e) {
            var value = e.get_value();
            var text = e.get_text();
            document.getElementById('<%=txtrawmatid.ClientID%>').value = value;
            <%--document.getElementById('<%=txtSearchText.ClientID%>').value = text + " (" + value + ")";--%>
            document.getElementById('<%=txtSearchText.ClientID%>').value = text ;
            //sender.get_element().value = text + " (" + value + ")";
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
    </script>
    <script type="text/javascript" src="Scripts/ValidateRawMaterialMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Raw Material Tracking Configuration</h3>
                <p class="pageSubTitle">Configure which raw materials are tracked</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="rm-add-stats-row">
                <div class="rm-add-form">
                    <div class="form-group mb-0">
                        <label class="form-control-label">Search Raw Material:<span id="Span2" class="mandatory">*</span></label>
                        <div class="rm-add-form-controls">
                            <div class="input-group product-search-group" style="flex: 1 1 auto; min-width: 0;">
                                <asp:TextBox ID="txtSearchText" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearRawMaterialSelection();" Placeholder="Enter Here"></asp:TextBox>
                                <div class="input-group-append">
                                    <button type="button" class="btn btn-outline-secondary product-reset-btn" onclick="resetProductField(); return false;" title="Reset SKU"><i class="fas fa-sync-alt fa-xs"></i></button>
                                </div>
                            </div>
                            <asp:HiddenField ID="txtrawmatid" ClientIDMode="Static" runat="server" />
                            <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-danger btn-sm" OnClick="btnReset_Click" />
                        </div>
                        <asp:Label ID="valSearchText" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
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
                    </div>
                </div>
                <div class="rm-stat-row">
                    <div class="rm-stat-card">
                        <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                        <div>
                            <p class="rm-stat-label">Total</p>
                            <p class="rm-stat-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></p>
                        </div>
                    </div>
                    <div class="rm-stat-card">
                        <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                        <div>
                            <p class="rm-stat-label">Active</p>
                            <p class="rm-stat-value is-green"><asp:Label ID="lblActiveCount" runat="server" Text="0"></asp:Label></p>
                        </div>
                    </div>
                    <div class="rm-stat-card">
                        <div class="rm-stat-icon is-red"><i class="fas fa-times-circle"></i></div>
                        <div>
                            <p class="rm-stat-label">Inactive</p>
                            <p class="rm-stat-value is-red"><asp:Label ID="lblInactiveCount" runat="server" Text="0"></asp:Label></p>
                        </div>
                    </div>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 10px; font-weight: bold; color: red;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="card rm-list-fill">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Raw Material List</h5>
                    <p class="mst-panel-subtitle">All Raw Material currently available</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive rm-grid-scroll">
                <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                    ID="gvrawMatDetails" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true"
                    ShowFooter="false" GridLines="both" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                    PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="Sl No" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblrawmatdid" runat="server" Text='<%# (gvrawMatDetails.PageIndex * gvrawMatDetails.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Raw Material Code" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblrawmatcode" runat="server" Text='<%# Bind("Raw_Mat_Code") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Raw Material Name" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblrawmatname" runat="server" Text='<%# Bind("Raw_Mat_Name") %>'></asp:Label>
                                <asp:HiddenField ID="hdnrawmatid" runat="server" Value='<%# Bind("Raw_Mat_Code") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="57%" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="57%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblactiveText" runat="server" CssClass='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "Active", "Inactive") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlactive" CssClass="form-control form-control-sm rm-status-ddl" runat="server">
                                    <asp:ListItem Text="Active" Value="Y"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" CommandName="Edit" runat="server" CssClass="text-info" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="btnUpdate" CommandName="Update" CssClass="text-success mr-1" runat="server" ToolTip="Update" OnClientClick="return rmConfirmStatusUpdate(this);"><i class="fas fa-check"></i></asp:LinkButton>
                                <asp:LinkButton ID="btncancel" CommandName="Cancel" CssClass="text-danger" runat="server" ToolTip="Cancel"><i class="fas fa-times"></i></asp:LinkButton>
                            </EditItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>

