<%@ Page Title="Indent List (HO)" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="IndentsList_HO.aspx.vb" Inherits="IndentsList_HO" %>



<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/ValidationIndentList_HO.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('<%= imgbtnAdd.ClientID %>').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('<%= imgbtnSearch.ClientID %>').name, '');
            }
    }

    function disableBackButton() {
        window.history.forward(1);
    }
    window.onload = disableBackButton;
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Depot Indents List (HO)</h3>
                <p class="pageSubTitle">Track depot indents at head office</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
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
                        <asp:DropDownList ID="ddlDepot" AutoPostBack="true" CssClass="select2 form-control" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Process Year:</label>
                        <asp:Label ID="lblFinYear" runat="server" CssClass="labelDataPoint"></asp:Label>
                        <asp:HiddenField ID="hdnSubmitAccess" runat="server" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Process Month:</label>
                        <asp:Label ID="lblFinMonth" runat="server" CssClass="labelDataPoint"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="select2 form-control">
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
                        <asp:ListBox ID="ddlproduct" SelectionMode="Multiple" placeholder="Select" runat="server" CssClass="form-control"></asp:ListBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ImageUrl="images/ic_search.gif" ID="imgbtnSearch" runat="server" />
                        <asp:ImageButton CssClass="btn btn-success btn-sm" ImageUrl="images/ic_add.gif" ID="imgbtnAdd" runat="server" />
                        <asp:ImageButton CssClass="btn btn-warning btn-sm" ImageUrl="images/printButton.png" ID="imgbtnPrint" runat="server" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-success btn-sm" ID="imgbtnAdd" runat="server" OnClick="imgbtnAdd_Click">Add</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-warning btn-sm" ID="imgbtnPrint" runat="server" OnClick="imgbtnPrint_Click">Print</asp:LinkButton>
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
                    <h5 class="mst-panel-title">Depot Indents List (HO)</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvIndentList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkDelete" runat="server" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Approve">
                                    <ItemTemplate>
                                        <asp:RadioButton ID="rdobtnApprove" runat="server" GroupName="Status" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Reject">
                                    <ItemTemplate>
                                        <asp:RadioButton ID="rdobtnReject" runat="server" GroupName="Status" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Region">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRegion" runat="server" Text='<%# Bind("depot_region") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Depot">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepotCode" runat="server" Text='<%# Bind("depot_code") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Depot Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepotName" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                                <asp:HyperLinkField DataNavigateUrlFields="depot_region,depot_code,fin_year,fin_month,indent_no,indent_date,approved_yn"
                                    DataNavigateUrlFormatString="AddUpdateIndentEntry_HO.aspx?RegionCode={0}&amp;DepotCode={1}&amp;FinYear={2}&amp;FinMonth={3}&amp;IndentNo={4}&amp;IndentDate={5}&amp;Approved={6}"
                                    HeaderText="Indent No." DataTextField="indent_no1" />

                                <asp:HyperLinkField DataNavigateUrlFields="depot_region,depot_code,fin_year,fin_month,indent_no,indent_date,approved_yn"
                                    DataNavigateUrlFormatString="AddUpdateIndentEntry_HO.aspx?RegionCode={0}&amp;DepotCode={1}&amp;FinYear={2}&amp;FinMonth={3}&amp;IndentNo={4}&amp;IndentDate={5}&amp;Approved={6}"
                                    HeaderText="Indent Date" DataTextField="indent_date1" />

                                <%--<asp:TemplateField HeaderText="Indent Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIndentDate" runat="server" Text='<%# Bind("indent_date") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>--%>

                                <asp:TemplateField HeaderText="SKU List">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSKUList" runat="server" Text='<%# Bind("indent_skus") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="30%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="lblApprvRejctStatus" runat="server" Text=""></asp:Label>
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Remarks" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Text='<%# Bind("remarks") %>'></asp:TextBox>
                                    </ItemTemplate>

                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="40%" Height="50px" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" runat="server" Text="Approve / Reject" CssClass="btn btn-success btn-sm" />
                </div>
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
