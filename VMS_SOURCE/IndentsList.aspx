<%@ Page Title="Indent List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="IndentsList.aspx.vb" Inherits="IndentsList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidationIndentList.js"></script>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F8 keypress)
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
                <h3 class="pageTitle">Depot Indents List</h3>
                <p class="pageSubTitle">Track and action depot indents</p>
            </div>
        </div>

        <div class="rightFung">
            <asp:Button ID="btnAddNewIndent" runat="server" Text="Add Colorant Indent" CssClass="btn btn-primary btn-sm" />
            <asp:Button ID="btnAddIndustrialIndent" runat="server" Text="Add Industrial Colorant Indent" CssClass="btn btn-warning btn-sm" />
            <asp:Button ID="btnAddSTPIndent" runat="server" Text="Add STP Product Indent" CssClass="btn btn-info btn-sm" />
            <asp:Button ID="btnAddOtherIndent" runat="server" Text="Add Other Product Indent" CssClass="btn btn-secondary btn-sm" />
        </div>
    </div>

    <div class="dotOption">
        <span class="dotFung"><span class="dot dotCkl"></span><span class="dotOptionTx">Request for PO upload</span></span>
        <span class="dotFung"><span class="dot1 dotCkl"></span><span class="dotOptionTx">Approved</span></span>
        <span class="dotFung"><span class="dot4 dotCkl"></span><span class="dotOptionTx">Rejected</span></span>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
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
                                <label class="form-control-label">Process Year:<span id="Span2" class="mandatory">*</span></label>
                                <asp:Label ID="lblFinYear" runat="server" CssClass="form-control"></asp:Label>
                                <asp:HiddenField ID="hdnSubmitAccess" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:Label ID="lblFinMonth" runat="server" CssClass="form-control"></asp:Label>
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
                                <%--<asp:ImageButton CssClass="mr5" ImageUrl="images/ic_search.gif" ID="imgbtnSearch" runat="server" />
                        <asp:ImageButton ImageUrl="images/printButton.png" ID="imgbtnPrint" runat="server" />--%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server">Search</asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-warning btn-sm" ID="imgbtnPrint" runat="server" OnClick="imgbtnPrint_Click">Print</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Depot Indents List</h5>
                            <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="gvIndentList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" BorderWidth="1" CssClass="table table-hover upgradDataGrid" OnRowCommand="gvIndentList_RowCommand">
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
                                            DataNavigateUrlFormatString="AddUpdateIndentEntry.aspx?RegionCode={0}&amp;DepotCode={1}&amp;FinYear={2}&amp;FinMonth={3}&amp;IndentNo={4}&amp;IndentDate={5}&amp;Approved={6}"
                                            HeaderText="Indent No." DataTextField="indent_no1" />

                                        <asp:HyperLinkField DataNavigateUrlFields="depot_region,depot_code,fin_year,fin_month,indent_no,indent_date,approved_yn"
                                            DataNavigateUrlFormatString="AddUpdateIndentEntry.aspx?RegionCode={0}&amp;DepotCode={1}&amp;FinYear={2}&amp;FinMonth={3}&amp;IndentNo={4}&amp;IndentDate={5}&amp;Approved={6}"
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
                                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Remarks" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Text='<%# Bind("remarks") %>'></asp:TextBox>
                                                <asp:HiddenField ID="hdnindentId" runat="server" Value='<%# Bind("indent_no") %>' />
                                                <asp:HiddenField ID="hdnfinyr" runat="server" Value='<%# Bind("fin_year") %>' />
                                                <asp:HiddenField ID="hdnfinmonth" runat="server" Value='<%# Bind("fin_month") %>' />
                                                <asp:HiddenField ID="hdndoc" runat="server" Value='<%# Bind("doc_path") %>' />
                                            </ItemTemplate>

                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="20%" Height="50px" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="PO Request Date" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblpodate" runat="server" Text='<%# Bind("indh_ho_request_date") %>'></asp:Label>
                                            </ItemTemplate>

                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="12%" Height="50px" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <div style="display: flex; align-items: center; justify-content: center">
                                                    <%--<asp:ImageButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="ViewHistory" CommandArgument='<%# Container.DataItemIndex %>' ImageUrl="~/images/ic_view.gif" Width="25px" Height="25px" ToolTip="View History" />
                                            <asp:ImageButton ID="btnSendMail" runat="server" Visible="false" Text="Send Mail" CommandName="SendMail" CommandArgument='<%# Container.DataItemIndex %>' ImageUrl="~/images/icons8-send-64.png" Width="25px" Height="25px" ToolTip="Request for Upload Indent invoice" />
                                            <asp:ImageButton runat="server" Visible="false" ID="btndownload" CommandName="download" CommandArgument='<%# Eval("doc_path") %>' ImageUrl="~/images/ic_downbutton.jpg" Width="25px" Height="25px" ToolTip="Download Indent invoice" />--%>

                                                    <asp:LinkButton ID="btnView" runat="server" Visible="true" Text="View" CommandName="ViewHistory" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View History"><i class="fa fa-eye"></i></asp:LinkButton>
                                                    <asp:LinkButton ID="btnSendMail" runat="server" Visible="false" Text="Send Mail" CommandName="SendMail" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Request for Upload Indent invoice"><i class="fa fa-upload" style="color:#00c219;"></i></asp:LinkButton>
                                                    <asp:LinkButton runat="server" Visible="false" ID="btndownload" CommandName="download" CommandArgument='<%# Eval("doc_path") %>' ToolTip="Download Indent invoice"><i class="fa fa-download" style="color:#3adede;"></i></asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
                                <asp:PostBackTrigger ControlID="gvIndentList" />
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

            <asp:UpdatePanel ID="UpdatePanel8" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hdnTargetID" runat="server" />
                    <asp:HiddenField ID="hdnTargetID1" runat="server" />
                    <asp:ModalPopupExtender
                        ID="mp1"
                        runat="server"
                        PopupControlID="pnlMessageBox"
                        TargetControlID="hdnTargetID"
                        CancelControlID="btnCancel"
                        BackgroundCssClass="popupBackground">
                    </asp:ModalPopupExtender>

                    <asp:Panel ID="pnlMessageBox" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Enter Remarks</h5>
                                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>--%>
                                </div>
                                <div class="modal-body">
                                    <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control h-auto" TextMode="MultiLine" Rows="4" placeholder="Write your remarks here..."></asp:TextBox>
                                    <asp:HiddenField ID="hdnemail" runat="server" />
                                    <asp:HiddenField ID="hdnccmail" runat="server" />
                                    <asp:HiddenField ID="hdnbccmail" runat="server" />
                                    <asp:HiddenField ID="hdnpopdepot" runat="server" />
                                    <asp:HiddenField ID="hdnpopfinyr" runat="server" />
                                    <asp:HiddenField ID="hdnpopindentId" runat="server" />
                                    <asp:HiddenField ID="hdnpopfinmonth" runat="server" />
                                </div>
                                <div class="modal-footer">
                                    <asp:Label ID="lblpoperror" runat="server" Text="" ForeColor="Red"></asp:Label>
                                    <asp:Button ID="btnSentMail" CssClass="btn btn-primary" runat="server" Text="Send Mail" OnClientClick="return validateRemarks();" OnClick="btnSentMail_Click1" />
                                    <asp:Button ID="btnCancel" CssClass="btn btn-secondary" runat="server" Text="Cancel" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:ModalPopupExtender
                        ID="mp2"
                        runat="server"
                        PopupControlID="pnlMessageBox1"
                        TargetControlID="hdnTargetID1"
                        CancelControlID="btnCancel1"
                        BackgroundCssClass="popupBackground">
                    </asp:ModalPopupExtender>

                    <asp:Panel ID="pnlMessageBox1" runat="server" CssClass="modalPanel1 bootstrapModal" Style="display: none;">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Indent History</h5>
                                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>--%>
                                </div>
                                <div class="modal-body">
                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                        <ContentTemplate>
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvIndentHistory" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Region">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblRegion" runat="server" Text='<%# Bind("depot_regn") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Depot">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDepotCode" runat="server" Text='<%# Bind("indh_depot") %>'></asp:Label>
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

                                                        <asp:TemplateField HeaderText="Fin Year" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblFinYear" runat="server" Text='<%# Bind("indh_fin_year") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Indent No" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblIndentNo" runat="server" Text='<%# Bind("indh_indent_no") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Indent Date" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="txtIndentDate" runat="server" Text='<%# Bind("indh_indent_date") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="txtAction" runat="server" TextMode="MultiLine" Text='<%# Bind("action") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="25%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action Date" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="txtActionDate" runat="server" Text='<%# Bind("created_date") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action By" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="txtActionBy" runat="server" Text='<%# Bind("created_user") %>'></asp:Label>
                                                            </ItemTemplate>

                                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                            <asp:Label ID="lblpoperror1" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="btnCancel1" CssClass="btn btn-secondary" runat="server" Text="Cancel" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>

            <script type="text/javascript">
                function validateRemarks() {
                    const remarksField = document.getElementById('<%= txtRemarks.ClientID %>');
            const errorMessage = document.getElementById('<%= lblpoperror.ClientID %>');

            if (remarksField.value.trim() === "") {
                remarksField.style.backgroundColor = "yellow";
                errorMessage.innerText = "Please add HO Remark.";
                return false;
            } else {
                remarksField.style.backgroundColor = "";
                errorMessage.innerText = "";
                return true;
            }
        }
            </script>

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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
