<%@ Page Title="Indent PO Download" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="IndentPoDownload.aspx.vb" Inherits="IndentPoDownload" %>



<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/Autocomplete.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F9 keypress)
                __doPostBack(document.getElementById('<%= imgbtnSearch.ClientID %>').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }

    </script>

    <script type="text/javascript">
        function validateMandatoryFields() {

            var errorMessage = "";
            var isValid = true;
            debugger

            var ddlDepot = document.getElementById('<%= ddlDepot.ClientID %>');
            var ddlyear = document.getElementById('<%= ddlyear.ClientID %>');
            var lblErrorMessage = document.getElementById('<%= lblErrorMessage.ClientID %>');

            lblErrorMessage.innerText = "";
            [ddlDepot, ddlRegion, ddlStatus].forEach(function (field) {
                field.style.backgroundColor = "";
            });

            if (!ddlDepot.value) {
                errorMessage += "Depot is mandatory. ";
                ddlDepot.style.backgroundColor = "yellow !important";
                isValid = false;
            }

            if (!ddlyear.value) {
                errorMessage += "Year is mandatory. ";
                ddlDepot.style.backgroundColor = "yellow !important";
                isValid = false;
            }


            if (!isValid) {
                lblErrorMessage.innerText = errorMessage;
                lblErrorMessage.style.color = "red";
            }

            return isValid;
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Depot Indents PO Download</h3>
                <p class="pageSubTitle">Download purchase orders against depot indents</p>
            </div>
        </div>
        <div class="rightFung">
            <asp:Button ID="btnAddNewIndent" runat="server" Text="Add Colorant Indent" Visible="false" CssClass="btn btn-primary btn-sm" />
            <asp:Button ID="btnAddIndustrialIndent" runat="server" Text="Add Industrial Colorant Indent" Visible="false" CssClass="btn btn-warning btn-sm" />
            <asp:Button ID="btnAddSTPIndent" runat="server" Text="Add STP Product Indent" Visible="false" CssClass="btn btn-info btn-sm" />
            <asp:Button ID="btnAddOtherIndent" runat="server" Text="Add Other Product Indent" Visible="false" CssClass="btn btn-secondary btn-sm" />
        </div>
    </div>

    <div class="dotOption">
        <span class="dotFung"><span class="dot dotCkl"></span><span class="dotOptionTx">Request for PO upload</span></span>
        <span class="dotFung"><span class="dot1 dotCkl"></span><span class="dotOptionTx">Approved</span></span>
        <span class="dotFung"><span class="dot4 dotCkl"></span><span class="dotOptionTx">Rejected</span></span>
    </div>

    <asp:UpdatePanel ID="upnlerrormsg" runat="server">
        <ContentTemplate>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Region:</label>
                        <asp:DropDownList ID="ddlRegion" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Depot:<span id="Span1" class="mandatory">*</span></label>
                        <asp:DropDownList ID="ddlDepot" CssClass="form-control select2" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Process Year:</label>
                        <asp:DropDownList ID="ddlyear" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Process Month:</label>
                        <asp:DropDownList ID="ddlMonth" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                            <asp:ListItem Value="">All</asp:ListItem>
                            <asp:ListItem Value="E">Entered</asp:ListItem>
                            <asp:ListItem Value="Y">Approved</asp:ListItem>
                            <asp:ListItem Value="N">Rejected</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Product:</label>
                        <asp:ListBox ID="ddlproduct" SelectionMode="Multiple" CssClass="form-control" placeholder="Select" runat="server"></asp:ListBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ImageUrl="images/ic_search.gif" ID="imgbtnSearch" runat="server" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                        <%--<asp:ImageButton ImageUrl="images/printButton.png" ID="imgbtnPrint" runat="server" />--%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Depot Indents PO Download List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvIndentList" runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found" OnRowCommand="gvIndentList_RowCommand">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Region">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRegion" runat="server" Text='<%# Bind("depot_region") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Depot">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepotCode" runat="server" Text='<%# Bind("depot_code") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Depot Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepotName" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Indent No.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblindentno" runat="server" Text='<%# Bind("indent_no") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="SKU List">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSKUList" runat="server" Text='<%# Bind("indent_skus") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="24%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblApprvRejctStatus" runat="server" Text=""></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Remarks">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Text='<%# Bind("remarks") %>' Enabled="false" Style="border-radius: 8px; height: 33px"></asp:TextBox>
                                        <asp:HiddenField ID="hdnindentId" runat="server" Value='<%# Bind("indent_no") %>' />
                                        <asp:HiddenField ID="hdnfinyr" runat="server" Value='<%# Bind("fin_year") %>' />
                                        <asp:HiddenField ID="hdnfinmonth" runat="server" Value='<%# Bind("fin_month") %>' />
                                        <asp:HiddenField ID="hdndoc" runat="server" Value='<%# Bind("doc_path") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="PO Request Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblpodate" runat="server" Text='<%# Bind("indh_ho_request_date") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <div style="display: flex; align-items: center; justify-content: center">
                                            <asp:ImageButton runat="server" Visible="false" ID="btndownload" CommandName="download" CommandArgument='<%# Eval("doc_path") %>' ImageUrl="~/images/ic_downbutton.jpg" Width="25px" Height="25px" ToolTip="Download Indent invoice" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>

                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:PostBackTrigger ControlID="gvIndentList" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="Scripts/jquery.sumoselect.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$('.select2').select2();
            $(<%=ddlproduct.ClientID%>).SumoSelect({
                selectAll: true,
                search: true,
                csvDispCount: 2,
                searchText: 'Search...',
            });
        });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            //$('.select2').select2();
            $(<%=ddlproduct.ClientID%>).SumoSelect({
                selectAll: true,
                search: true,
                csvDispCount: 2,
                searchText: 'Search...',
            });
        });

    </script>
</asp:Content>
