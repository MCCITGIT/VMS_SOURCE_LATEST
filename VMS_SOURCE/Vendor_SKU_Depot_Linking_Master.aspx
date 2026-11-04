<%@ Page Title="Vendor SKU Linking Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_SKU_Depot_Linking_Master.aspx.vb" Inherits="Vendor_SKU_Depot_Linking_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationVendorSKUDepotMaster.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
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
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor SKU Linking Master</h3>
                <p class="pageSubTitle">Link vendor SKUs to the depots they serve</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <%-- Modified-by MUKESH BHAGAT on 03-09-2026 : grid vendor dropdowns now use the plain
         "select2" class handled by MasterPage's global $('.select2').select2() - the same
         convention the team applied to Vendor_SKU_Depot_Linking_Master_DD.aspx. The earlier
         page-local select2 init + containment CSS caused the horizontal drag and is removed. --%>
    <script type="text/javascript">
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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">SKU:<span style="color: red;">*</span></label>
                                <asp:HiddenField ID="hdnskucode1" runat="server" />
                                <asp:TextBox ID="txtSkuCode" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="false"></asp:TextBox>
                                <asp:AutoCompleteExtender ID="AutoCompleteExtender2" runat="server" TargetControlID="txtSkuCode"
                                    ServiceMethod="SKUSearch" MinimumPrefixLength="3" EnableCaching="false"
                                    CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem"
                                    CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight" OnClientItemSelected="aceSelected2"
                                    OnClientPopulated="HideLoading1" BehaviorID="AutoCompleteEx1" CompletionListElementID="Panel2"
                                    OnClientPopulating="ShowLoading1" FirstRowSelected="true" OnClientHidden="HideLoading1"
                                    OnClientHiding="HideLoading1">
                                    <Animations>
                                                                <OnShow>
                                                                    <Sequence>
                                                                        <OpacityAction Opacity="0" />
                                                                        <HideAction Visible="true" />
                                                                        <ScriptAction Script="
                                                                            // Cache the size and setup the initial size
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
                                <asp:Panel ID="Panel2" runat="server" ScrollBars="Vertical" Height="150" Width="400"
                                    Style="overflow-y: scroll; position: absolute; left: 0; top: 0; text-align: left;">
                                </asp:Panel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" AutoPostBack="true" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlDepot" ClientIDMode="Static" CssClass="form-control select2" TabIndex="3" AutoPostBack="true" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Source:</label>
                                <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="4" AutoPostBack="true" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3" runat="server" visible="false">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlActive" ClientIDMode="Static" runat="server" CssClass="form-control select2">
                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Active" Value="Y"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton ID="imgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" ImageUrl="~/images/ic_search.gif" />--%>

                                <asp:LinkButton ID="imgbtnSearch" ClientIDMode="Static" CssClass="btn btn-primary btn-sm" runat="server">Search</asp:LinkButton>
                            </div>
                        </div>

                    </div>
                </div>
            </div>


            <asp:HiddenField ID="hdnSKUCode" runat="server" />
            <asp:HiddenField ID="hdnNewVendorName" runat="server" />
            <asp:HiddenField ID="hdnSkuLinkHasData" runat="server" Value="0" />
            <asp:HiddenField ID="hdnSkuLinkPageSize" runat="server" Value="15" />
            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Linking List</h5>
                            <p class="mst-panel-subtitle">All brands with submitted product linkings</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="form-group row ddlPageSize" style="display: none;">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvVendorSKUList" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" ShowFooter="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="There are No Data..."
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
                                        <asp:TextBox ID="lblftrskudes" runat="server" AutoPostBack="true" CssClass="form-control" OnTextChanged="txtftrSKUdsec_OnTextChanged" Enabled="true"></asp:TextBox>
                                        <%-- Modified-by MUKESH BHAGAT on 01-09-2026 : the suggestion list used a Panel
                                             pinned at left:0/top:0 inside the .table-responsive scroll area, so it
                                             rendered at the container corner or was clipped - users saw only the
                                             loading icon and no list. Switched to the toolkit's default flyout
                                             (appended to the page body and positioned at the textbox), the same
                                             pattern as IndentEntry_Add.aspx. --%>
                                        <asp:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="lblftrskudes"
                                            ServiceMethod="SKUSearch" MinimumPrefixLength="3" EnableCaching="false"
                                            CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem"
                                            CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight" OnClientItemSelected="aceSelected"
                                            OnClientPopulated="HideLoading" BehaviorID="AutoCompleteEx"
                                            OnClientPopulating="ShowLoading" FirstRowSelected="true" OnClientHidden="HideLoading"
                                            OnClientHiding="HideLoading">
                                        </asp:AutoCompleteExtender>

                                        <%-- Modified-by MUKESH BHAGAT on 02-09-2026 : unique id - was "loading",
                                             duplicating the header spinner's id, so this one never showed. --%>
                                        <img alt="Loading..." src="images/progress.gif" id="loadingFooter" class="inputLoading" />
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
                                        <%-- <asp:TextBox ID="txtftrSKU" CssClass="txtBox" AutoPostBack="true" OnTextChanged="txtftrSKU_OnTextChanged" runat="server"  Width="95%"></asp:TextBox>--%>

                                        <asp:TextBox ID="txtftrSKU" CssClass="form-control" Enabled="false" runat="server"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="11%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TSL Factor" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lbltslfactor" runat="server" Text='<%# Bind("v_tsl_factor") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbledittslfactor" runat="server" Text='<%# Bind("v_tsl_factor") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtftrtslfactor" CssClass="form-control" runat="server"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="P/S" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPS" runat="server" Text='<%# Bind("v_primary_secondary") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditPS" runat="server" Text='<%# Bind("v_primary_secondary") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlftrPS" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="PRIMARY">PRIMARY</asp:ListItem>
                                            <%--  <asp:ListItem Value="SECONDARY">SECONDARY</asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Region" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRegion" runat="server" Text='<%# Bind("depot_regn") %>'></asp:Label>

                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditRegion" runat="server" Text='<%# Bind("depot_regn") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblftrRegion" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />

                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Depot" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepot" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnDepot1" runat="server" Value='<%# Bind("v_depot") %>' />
                                        <asp:HiddenField ID="hdnDepotname" runat="server" Value='<%# Bind("depot_name") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="lbleditDepot" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("v_depot") %>' />
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlftrDepot" runat="server" CssClass="form-control" TabIndex="3">
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />

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
                                        <%--   <asp:Label ID="lblNewVendor1" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>--%>
                                        <%-- Modified-by MUKESH BHAGAT on 03-09-2026 : plain "select2" class, initialised by
                                             the MasterPage global init - same convention as the DD page --%>
                                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" TabIndex="4" Visible="true" OnSelectedIndexChanged="ddlNewVendor_SelectedIndexChanged" AutoPostBack="true"
                                            runat="server">
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddleditVendor" CssClass="form-control select2" TabIndex="4" Visible="true"
                                            runat="server">
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlftrVendor" CssClass="form-control select2" TabIndex="1"
                                            runat="server">
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# Bind("active") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnactive" runat="server" Value='<%# Bind("active") %>' />
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control">
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
                                        <asp:ImageButton ID="btnEdit" Visible="false" CommandName="edit" runat="server" ImageUrl="~/Images/edit.jpg" />
                                        <asp:ImageButton ID="btnChange" CommandName="change" runat="server" title="Save" ImageUrl="~/Images/p-save.png" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ImageButton ID="btnUpdate" CommandName="update" runat="server" title="Save" ImageUrl="~/Images/p-save.png" />
                                        <asp:ImageButton ID="btnCancel" CommandName="cancel" runat="server" title="Cancel" ImageUrl="~/Images/p-cancel.png" />
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:ImageButton ID="btnInsert" CommandName="insert" runat="server" title="Cancel" ImageUrl="~/Images/p-cancel.png" />
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" runat="server" Font-Size="10px" Font-Bold="true"></asp:Label>
        </ContentTemplate>
        <%--        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="ddlPageSize" EventName="SelectedIndexChanged" />
        </Triggers>--%>
    </asp:UpdatePanel>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvVendorSKUList.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0, suppressUntil = 0;
            var filters = { vendor: '', depot: '', sku: '', region: '' };
            var vendors = null;

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.link-skel'); }
            function scrollBox() { return $(gridSel).closest('.table-responsive'); }
            function capture() {
                filters.vendor = $('#ddlVendor').val() || '';
                filters.depot = $('#ddlDepot').val() || '';
                filters.sku = $('#<%= hdnskucode1.ClientID %>').val() || '';
                filters.region = $('#ddlRegion').val() || '';
                var size = parseInt($('#<%= hdnSkuLinkPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['24px', '70%', '50px', '28px', '40px', '24px', '70%', '70%', '80%', '22px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) {
                    cells += '<td style="text-align:center;width:' + ['4%', '21%', '11%', '6%', '8%', '4%', '14%', '15%', '18%', '10%'][i] + '"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                }
                return '<tr class="tlrowlight link-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                var $footer = $(gridSel).find('tr.footerGrid').first();
                if ($footer.length) $footer.before($rows);
                else $(gridSel).find('tbody').append($rows);
            }
            function vendorSelect(id, selected) {
                var html = '<select id="' + id + '" class="form-control select2 sku-link-vendor">';
                for (var i = 0; i < vendors.length; i++) {
                    var v = vendors[i];
                    html += '<option value="' + esc(v.code) + '"' + (v.code === selected ? ' selected' : '') + '>' + esc(v.name) + '</option>';
                }
                return html + '</select>';
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnSkuLinkHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && (pageIndex + 1) * pageSize >= total) { noMore = true; return; }
                if (total && dataRows().length >= total) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                var box = scrollBox();
                if (box.length && box[0].scrollHeight > box[0].clientHeight) {
                    suppressUntil = Date.now() + 200;
                    box.scrollTop(box[0].scrollHeight);
                }
                PageMethods.GetMoreVendorSkuLinks(pageIndex, pageSize, filters.vendor, filters.depot, filters.sku, filters.region, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.link-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (res.vendors && res.vendors.length) vendors = res.vendors;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        var n = pageIndex * pageSize + i + 1;
                        var vendorCell = '';
                        var actionCell = '';
                        if (r.vendor) {
                            var selId = 'skuLinkVendor' + n;
                            vendorCell = vendorSelect(selId, r.vendor)
                                + '<input type="hidden" class="js-sku" id="skuLinkSku' + n + '" value="' + esc(r.sku) + '" />'
                                + '<input type="hidden" class="js-depotname" id="skuLinkDepot' + n + '" value="' + esc(r.depotName) + '" />'
                                + '<input type="hidden" class="js-vendorname" id="skuLinkVendorName' + n + '" value="' + esc(r.vendorName) + '" />';
                            actionCell = '<img id="skuLinkSave' + n + '" class="sku-link-save" title="Save" alt="Save" src="Images/p-save.png" style="cursor:pointer" />';
                        }
                        html += '<tr class="tlrowlight" data-depot="' + esc(r.depot) + '" data-sku="' + esc(r.sku) + '" data-tsl="' + esc(r.tsl) + '" data-ps="' + esc(r.ps) + '">'
                            + '<td style="text-align:center">' + n + '</td>'
                            + '<td style="text-align:center">' + esc(r.skuDesc) + '</td>'
                            + '<td style="text-align:center">' + esc(r.sku) + '</td>'
                            + '<td style="text-align:center">' + esc(r.tsl) + '</td>'
                            + '<td style="text-align:center">' + esc(r.ps) + '</td>'
                            + '<td style="text-align:center">' + esc(r.region) + '</td>'
                            + '<td style="text-align:center">' + esc(r.depotName) + '</td>'
                            + '<td style="text-align:center">' + esc(r.vendorName) + '</td>'
                            + '<td style="text-align:center">' + vendorCell + '</td>'
                            + '<td style="text-align:center">' + actionCell + '</td></tr>';
                    }
                    if (html) {
                        place(html);
                        if (window.jQuery && jQuery.fn.select2) $(gridSel + ' select.sku-link-vendor').not('.select2-hidden-accessible').select2();
                    }
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.link-skel').remove();
                    loading = false;
                    pageIndex--;
                });
            }
            function onScroll() {
                if (Date.now() < suppressUntil) return;
                var el = this;
                if (el.scrollTop + el.clientHeight >= el.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++; vendors = null;
                capture();
                var box = scrollBox();
                box.off('scroll.skuLink').on('scroll.skuLink', onScroll);
                if ($('#<%= hdnSkuLinkHasData.ClientID %>').val() === '1' && box.length && box[0].scrollHeight <= box[0].clientHeight + 2) loadNext();
            }
            $(document).on('click', '.sku-link-save', function (ev) {
                ev.preventDefault();
                var tr = $(this).closest('tr');
                var sel = tr.find('select.sku-link-vendor')[0];
                var nameBox = document.getElementById('<%= hdnNewVendorName.ClientID %>');
                if (!sel) return false;
                if (nameBox && sel.selectedIndex >= 0) nameBox.value = sel.options[sel.selectedIndex].text;
                if (!ValidateUpdate(sel.id, tr.find('.js-sku').attr('id'), tr.find('.js-depotname').attr('id'), tr.find('.js-vendorname').attr('id'), '<%= hdnNewVendorName.ClientID %>', 'lblErrorMessage', this.id)) return false;
                PageMethods.SaveVendorSkuLink(tr.attr('data-depot'), sel.value, tr.attr('data-sku'), tr.attr('data-tsl'), tr.attr('data-ps'), function (msg) {
                    if (msg === 'ok') {
                        alert('Data updated successfully');
                        var search = document.getElementById('imgbtnSearch');
                        if (search) search.click();
                    } else if (msg) {
                        alert(msg);
                    }
                });
                return false;
            });
            $(bind);
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(bind);
            }
        })();
    </script>
</asp:Content>
