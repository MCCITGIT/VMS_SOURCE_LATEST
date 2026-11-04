<%@ Page Title="Vendor SKU Linking Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_SKU_Depot_Linking_Master_DD.aspx.vb" Inherits="Vendor_SKU_Depot_Linking_Master_DD" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : FunctionValidator.js is commented out in MasterPage.master; ValidationDDVendorSKUDepotMaster.js (ValidateSearch/ValidateUpdate/ValidateInsert) needs ValidateRequired/SetControlFocus from it --%>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationDDVendorSKUDepotMaster.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : master page mangles IDs and imgbtnSearch is now a LinkButton (no name attribute) - use ClientID and .click() so F8 hotkey works --%>
            if (event.keyCode == 119) { // button Search (F8 keypress)
                document.getElementById('<%= imgbtnSearch.ClientID %>').click();
            }
        }
        //-->
    </script>

    <script type="text/javascript">
        // Modified-by MUKESH BHAGAT on 02-09-2026 : this pair drives the FOOTER (grid add-row)
        // SKU search spinner. Both spinner images carried id="loading", so getElementById
        // always found the header one first and the footer search flashed the header's
        // spinner instead of its own. The footer image is now id="loadingFooter".
        function HideLoading() {
            var loading_icon = document.getElementById("loadingFooter");
            loading_icon.style.visibility = 'hidden';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function ShowLoading() {
            var loading_icon = document.getElementById("loadingFooter");
            loading_icon.style.visibility = 'visible';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function aceSelected(sender, e) {
            var value = e.get_value();

            var text = e.get_text();
            debugger;

            document.getElementById('<%=hdnSKUCode.ClientID%>').value = value;
            // getSKUDetails();
        }

        function HideLoading1() {
            var loading_icon = document.getElementById("loading");
            loading_icon.style.visibility = 'hidden';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function ShowLoading1() {
            var loading_icon = document.getElementById("loading");
            loading_icon.style.visibility = 'visible';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function aceSelected2(sender, e) {
            var value = e.get_value();

            var text = e.get_text();
            debugger;

            document.getElementById('<%=hdnskucode1.ClientID%>').value = value;
            // getSKUDetails();
        }

        function initVendorSkuGridSelect2() {
            $('.vendor-sku-dd-grid select.select2-grid-vendor:visible').each(function () {
                var $el = $(this);
                if ($el.data('select2')) {
                    $el.select2('destroy');
                }
                $el.select2({
                    width: '100%',
                    dropdownAutoWidth: false
                });
            });
        }

        $(document).ready(function () {
            setTimeout(initVendorSkuGridSelect2, 0);
        });

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                setTimeout(initVendorSkuGridSelect2, 0);
            });
        }

        // Modified-by MUKESH BHAGAT on 03-09-2026 : the shared validator paints required-field
        // errors yellow on the NATIVE control (FunctionValidator.js -> SetErrorColor). The
        // vendor dropdowns here are select2, whose native <select> is hidden - so the yellow
        // was applied but invisible. This wrapper also paints the visible select2 box, giving
        // dropdowns the same yellow highlight the SKU textbox already shows.
        if (typeof SetErrorColor === 'function') {
            var vmsBaseSetErrorColor = SetErrorColor;
            SetErrorColor = function (controlID, isCss) {
                vmsBaseSetErrorColor(controlID, isCss);
                var el = document.getElementById(controlID);
                if (el && window.jQuery && jQuery(el).data('select2')) {
                    jQuery(el).next('.select2-container').find('.select2-selection')
                        .css('background-color', isCss ? '' : 'yellow');
                }
            };
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor SKU Linking Direct</h3>
                <p class="pageSubTitle">Link vendor SKUs used for direct despatch</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">SKU:<span style="color: red;">*</span></label>
                                <asp:HiddenField ID="hdnskucode1" runat="server" />
                                <div class="flexInputDiv">
                                    <asp:TextBox ID="txtSkuCode" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <asp:AutoCompleteExtender ID="AutoCompleteExtender2" runat="server"
                                    TargetControlID="txtSkuCode"
                                    ServiceMethod="SKUSearch"
                                    MinimumPrefixLength="3"
                                    EnableCaching="false"
                                    CompletionListCssClass="vmsAutoComplete"
                                    CompletionListItemCssClass="vmsAutoCompleteItem"
                                    CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight"
                                    OnClientItemSelected="aceSelected2"
                                    OnClientPopulated="HideLoading1"
                                    OnClientPopulating="ShowLoading1"
                                    BehaviorID="AutoCompleteEx1"
                                    CompletionListElementID="Panel2"
                                    FirstRowSelected="true"
                                    OnClientHidden="HideLoading1"
                                    OnClientHiding="HideLoading1">
                                    <Animations>
                                    <OnShow>
                                        <Sequence>
                                            <OpacityAction Opacity="0" />
                                            <HideAction Visible="true" />
                                            <ScriptAction Script="
                                                var behavior = $find('AutoCompleteEx1');
                                                if (!behavior._height) {
                                                    var target = behavior.get_completionList();
                                                    behavior._height = target.offsetHeight - 2;
                                                    target.style.height = '0px';
                                                }" />
                                            <Parallel Duration=".4">
                                                <FadeIn />
                                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx1')._height" />
                                            </Parallel>
                                        </Sequence>
                                    </OnShow>
                                    <OnHide>
                                        <Parallel Duration=".4">
                                            <FadeOut />
                                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx1')._height" EndValue="0" />
                                        </Parallel>
                                    </OnHide>
                                    </Animations>
                                </asp:AutoCompleteExtender>
                                <img alt="Loading..." src="images/progress.gif" id="loading" class="inputLoading" />
                                <asp:Panel ID="Panel2" runat="server" Style="overflow-y: scroll; position: absolute; left: 0; top: 0; text-align: left;">
                                </asp:Panel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Source:</label>
                                <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" TabIndex="4" AutoPostBack="true" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ImageUrl="~/images/ic_search.gif" />--%>
                                <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card">
        <div class="card-body">
            <div class="form-group row ddlPageSize" style="display:none;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div class="col-md-1">
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
            <div class="table-responsive dd-grid-scroll">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnSKUCode" runat="server" />
                        <asp:HiddenField ID="hdnNewVendorName" runat="server" />
                        <asp:HiddenField ID="hdnDdSkuHasData" runat="server" Value="0" />
                        <asp:HiddenField ID="hdnDdSkuPageSize" runat="server" Value="15" />
                        <asp:GridView ID="gvVendorSKUList" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" ShowFooter="true" EmptyDataText="There are No Data..."
                            OnRowCancelingEdit="gvVendorSKUList_RowCancelingEdit" OnRowEditing="gvVendorSKUList_RowEditing">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Sr No" HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SKU Description" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblskudes" runat="server" Text='<%# Bind("SkuDescription") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditskudes" runat="server" Text='<%# Bind("SkuDescription") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="lblftrskudes" CssClass="form-control" runat="server" AutoPostBack="true" OnTextChanged="txtftrSKUdsec_OnTextChanged" Enabled="true"></asp:TextBox>
                                        <asp:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="lblftrskudes"
                                            ServiceMethod="SKUSearch" MinimumPrefixLength="3" EnableCaching="false"
                                            CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem"
                                            CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight" OnClientItemSelected="aceSelected"
                                            OnClientPopulated="HideLoading" BehaviorID="AutoCompleteEx" CompletionListElementID="Panel1"
                                            OnClientPopulating="ShowLoading" FirstRowSelected="true" OnClientHidden="HideLoading"
                                            OnClientHiding="HideLoading">
                                            <Animations>
                                                                <OnShow>
                                                                    <Sequence>
                                                                        <OpacityAction Opacity="0" />
                                                                        <HideAction Visible="true" />
                                                                        <ScriptAction Script="
                                                                            // Cache the size and setup the initial size
                                                                            var behavior = $find('AutoCompleteEx');
                                                                            if (!behavior._height) {
                                                                                var target = behavior.get_completionList();
                                                                                behavior._height = target.offsetHeight - 2;
                                                                                target.style.height = '0px';
                                                                            }" />

                                                                        <Parallel Duration=".4">
                                                                            <FadeIn />
                                                                            <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                                                                        </Parallel>
                                                                    </Sequence>
                                                                </OnShow>
                                                                <OnHide>

                                                                    <Parallel Duration=".4">
                                                                        <FadeOut />
                                                                        <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                                                                    </Parallel>
                                                                </OnHide>
                                            </Animations>
                                        </asp:AutoCompleteExtender>

                                        <%-- Modified-by MUKESH BHAGAT on 02-09-2026 : unique id - was "loading",
                                             duplicating the header spinner's id, so this one never showed. --%>
                                        <img alt="Loading..." src="images/progress.gif" id="loadingFooter" class="inputLoading" />
                                        <asp:Panel ID="Panel1" runat="server" ScrollBars="Vertical" Height="150" Width="400"
                                            Style="overflow-y: scroll; position: absolute; left: 0; top: 0; text-align: left;">
                                        </asp:Panel>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SKU" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSKU" runat="server" Text='<%# Bind("v_sku_code") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnskucode1" runat="server" Value='<%# Bind("v_sku_code") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditSKU" runat="server" Text='<%# Bind("v_sku_code") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtftrSKU" CssClass="form-control" Enabled="false" runat="server"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Current Vendor" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCurrentVendor" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnvendor" runat="server" Value='<%# Bind("v_vendor_unit") %>' />
                                        <asp:HiddenField ID="hdnvendorname" runat="server" Value='<%# Bind("vendor_name") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditVendor" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblftrVendor" runat="server" Visible="true"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="New Vendor" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" TabIndex="4" Visible="true" OnSelectedIndexChanged="ddlNewVendor_SelectedIndexChanged" AutoPostBack="true"
                                            runat="server">
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddleditVendor" CssClass="form-control select2" TabIndex="4" Visible="true" runat="server">
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlftrVendor" CssClass="form-control select2" TabIndex="1" runat="server">
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%--<asp:DropDownList ID="ddlActive" runat="server" Width="50px"
                                                SelectedValue='<%# Bind("active") %>'>
                                                <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                                <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                            </asp:DropDownList>--%>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control select2" Width="80px" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control select2" Width="80px">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnactive" runat="server" Value='<%# Bind("active") %>' />
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control" Width="80px">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ID="btnEdit" Visible="false" CommandName="edit" runat="server" ImageUrl="~/Images/edit.jpg" />
                                        <asp:ImageButton ID="btnChange" CommandName="change" runat="server" ImageUrl="~/Images/b_save.gif" />--%>
                                        <asp:LinkButton ID="btnEdit" Visible="false" CommandName="edit" CssClass="btn btn-primary gridBtn" runat="server">Edit</asp:LinkButton>
                                        <asp:LinkButton ID="btnChange" CommandName="change" CssClass="btn btn-success gridBtn" runat="server">Save</asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%--<asp:ImageButton ID="btnUpdate" CommandName="update" runat="server" ImageUrl="~/Images/b_save.gif" />
                                        <asp:ImageButton ID="btnCancel" CommandName="cancel" runat="server" ImageUrl="~/Images/b_cancel.gif" />--%>
                                        <asp:LinkButton ID="btnUpdate" CommandName="update" CssClass="btn btn-success gridBtn" runat="server"><i class="fa fa-check-circle" style="color:#00e731;"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" CommandName="cancel" CssClass="btn btn-primary gridBtn" runat="server"><i class="fa fa-times-circle" style="color:#e70000;"></i></asp:LinkButton>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <%--<asp:ImageButton ID="btnInsert" CommandName="insert" runat="server" ImageUrl="~/Images/b_save.gif" />--%>
                                        <asp:LinkButton ID="btnInsert" CommandName="insert" CssClass="btn btn-success gridBtn" runat="server">Save</asp:LinkButton>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:Label ID="lblErrorMessage" CssClass="errormsg" runat="server" Font-Size="10px" Font-Bold="true"></asp:Label>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger
                            ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <style type="text/css">
        .dd-grid-scroll,
        .dd-grid-scroll table,
        .dd-grid-scroll tr,
        .dd-grid-scroll td {
            overflow-anchor: none;
        }
        .dd-grid-scroll {
            overscroll-behavior: contain;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvVendorSKUList.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { vendor: '', skuHidden: '', skuText: '' };
            var vendors = null;

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.dd-skel'); }
            function scrollBox() { return $(gridSel).closest('.dd-grid-scroll'); }
            function capture() {
                filters.vendor = $('#<%= ddlVendor.ClientID %>').val() || '';
                filters.skuHidden = $('#<%= hdnskucode1.ClientID %>').val() || '';
                filters.skuText = $('#<%= txtSkuCode.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnDdSkuPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '50px', '70%', '80%', '36px', '40px'];
                var cols = ['4%', '21%', '11%', '15%', '18%', '6%', '10%'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center;width:' + cols[i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight dd-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                var $footer = $(gridSel).find('tr.footerGrid').first();
                if ($footer.length) $footer.before($rows);
                else $(gridSel).find('tbody').append($rows);
            }
            function vendorSelect(id, selected) {
                var html = '<select id="' + id + '" class="form-control select2 dd-link-vendor">';
                for (var i = 0; i < vendors.length; i++) {
                    html += '<option value="' + esc(vendors[i].code) + '"' + (vendors[i].code === selected ? ' selected' : '') + '>' + esc(vendors[i].name) + '</option>';
                }
                return html + '</select>';
            }
            function activeSelect(id, selected) {
                return '<select id="' + id + '" class="form-control select2 dd-link-active" style="width:80px">'
                    + '<option value="Y"' + (selected === 'Y' ? ' selected' : '') + '>Yes</option>'
                    + '<option value="N"' + (selected !== 'Y' ? ' selected' : '') + '>No</option></select>';
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnDdSkuHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                PageMethods.GetMoreDdVendorSkus(pageIndex, pageSize, filters.vendor, filters.skuHidden, filters.skuText, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.dd-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (res.vendors && res.vendors.length) vendors = res.vendors;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var n = pageIndex * pageSize + i + 1;
                        var vendorCell = '', actionCell = '';
                        if (r.vendor) {
                            vendorCell = vendorSelect('ddVendor' + n, r.vendor)
                                + '<input type="hidden" class="js-sku" id="ddSku' + n + '" value="' + esc(r.sku) + '" />'
                                + '<input type="hidden" class="js-vendorname" id="ddVendorName' + n + '" value="' + esc(r.vendorName) + '" />';
                            actionCell = '<a href="javascript:void(0)" id="ddSave' + n + '" class="btn btn-success gridBtn dd-link-save">Save</a>';
                        }
                        var activeCell = r.active ? activeSelect('ddActive' + n, r.active) : '';
                        html += '<tr class="tlrowlight" data-sku="' + esc(r.sku) + '" data-oldvendor="' + esc(r.vendor) + '">'
                            + '<td style="text-align:center">' + n + '</td>'
                            + '<td style="text-align:center">' + esc(r.skuDesc) + '</td>'
                            + '<td style="text-align:center">' + esc(r.sku) + '</td>'
                            + '<td style="text-align:center" class="js-current">' + esc(r.vendorName) + '</td>'
                            + '<td style="text-align:center">' + vendorCell + '</td>'
                            + '<td style="text-align:center">' + activeCell + '</td>'
                            + '<td style="text-align:center">' + actionCell + '</td></tr>';
                    }
                    if (html) {
                        place(html);
                        if (window.jQuery && jQuery.fn.select2) $(gridSel + ' select.dd-link-vendor, ' + gridSel + ' select.dd-link-active').not('.select2-hidden-accessible').select2();
                    }
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.dd-skel').remove();
                    loading = false;
                    pageIndex--;
                });
            }
            function onScroll() {
                if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++; vendors = null;
                capture();
                var box = scrollBox();
                box.off('scroll.ddSku').on('scroll.ddSku', onScroll);
                if ($('#<%= hdnDdSkuHasData.ClientID %>').val() === '1' && box.length && box[0].scrollHeight <= box[0].clientHeight + 2) loadNext();
            }
            $(document).on('click', '.dd-link-save', function (ev) {
                ev.preventDefault();
                var tr = $(this).closest('tr');
                var sel = tr.find('select.dd-link-vendor')[0];
                var active = tr.find('select.dd-link-active');
                var nameBox = document.getElementById('<%= hdnNewVendorName.ClientID %>');
                if (!sel) return false;
                if (nameBox && sel.selectedIndex >= 0) nameBox.value = sel.options[sel.selectedIndex].text;
                if (!ValidateUpdate(sel.id, tr.find('.js-sku').attr('id'), tr.find('.js-vendorname').attr('id'), '<%= hdnNewVendorName.ClientID %>', '<%= lblErrorMessage.ClientID %>', this.id)) return false;
                PageMethods.SaveDdVendorSkuLink(sel.value, tr.attr('data-oldvendor'), tr.attr('data-sku'), active.length ? active.val() : '', function (msg) {
                    if (msg === 'ok') {
                        alert('Data updated successfully');
                        tr.find('.js-current').text(sel.options[sel.selectedIndex].text);
                        tr.find('.js-vendorname').val(sel.options[sel.selectedIndex].text);
                        tr.attr('data-oldvendor', sel.value);
                    } else if (msg === 'exists') {
                        alert('Data already exists');
                    } else if (msg) {
                        alert(msg);
                    }
                });
                return false;
            });
            $(bind);
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                    var panels = args.get_panelsUpdated();
                    for (var i = 0; i < panels.length; i++) {
                        if ($(panels[i]).find(gridSel).length) { bind(); break; }
                    }
                });
            }
        })();
    </script>
</asp:Content>
