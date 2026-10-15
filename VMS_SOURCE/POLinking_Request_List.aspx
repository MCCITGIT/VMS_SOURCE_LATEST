<%@ Page Title="PO SKU Linking Request List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="POLinking_Request_List.aspx.vb" Inherits="POLinking_Request_List" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <script src="Scripts/ValidateVendorUnitMaster.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {  // button Add (F7 keypress)	    		    
                __doPostBack(document.getElementById('ImgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('ImgbtnSearch').name, '');
            }
        }
        //-->
    </script>
    <script type="text/javascript">
        var cal1 = new CalendarPopup(); function scheme_effective_date_onclick() { }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">PO Linking Request List</h3>
                <p class="pageSubTitle">Purchase order linking requests, with status</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddlDepot" class="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" class="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" class="form-control select2" runat="server">
                            <asp:ListItem Value="N" Selected="True">Linking Pending</asp:ListItem>
                            <asp:ListItem Value="Y">Linking Done</asp:ListItem>
                            <asp:ListItem Value="R">Rejected</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2 form-btn-mt">
                    <asp:Button ID="ImgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="ImgbtnSearch_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">PO Linking Request List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:GridView ID="gvProduct" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10"
                    Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No records found" OnRowCommand="gvProduct_RowCommand" OnPageIndexChanging="gvProduct_PageIndexChanging" OnRowDataBound="gvProduct_RowDataBound">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="Srl No." HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnHdrID" Value='<%# Bind("airh_hdr_id") %>' />
                                <asp:HiddenField runat="server" ID="hdnIsReject" Value='<%# Bind("airh_reject_request") %>' />
                                <asp:HiddenField runat="server" ID="hdnIsLinked" Value='<%# Bind("isLinked") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Depot" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lbldepot_name" runat="server" Text='<%# Bind("depot_name") %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnDepotCode" Value='<%# Bind("airh_depot") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Vendor" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                <asp:HiddenField runat="server" ID="hdnVendorCode" Value='<%# Bind("airh_vendor") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="PO Number" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblPONumber" runat="server" Text='<%# Bind("aird_po_no") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="SKU" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSKU" runat="server" Text='<%# Bind("sku_code") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Site ID" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSiteID" runat="server" Text='<%# Bind("site_name") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Request Date" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblReqDate" runat="server" Text='<%# Bind("req_date") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Resend Mail" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="lbtnMail" Text="" CommandName="SendMail" ToolTip="Send Mail" Style="font-size: 14px"><i class="fa fa-envelope"></i></asp:LinkButton>
                                <asp:Label runat="server" ID="lblcheck" CssClass="text-success" Visible="false"><i class="fa fa-check" aria-hidden="true"></i></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblReject" CssClass="text-secondary" Visible="false">Rejected</asp:Label>
                                <asp:LinkButton runat="server" ID="lbtnReject" CommandName="Reject" ToolTip="Reject" CssClass="text-danger" Style="font-size: 14px" OnClientClick="return confirm('Are you Sure to Reject this PO Linking Request?')"><i class="fa fa-times-circle fa-1x"></i></asp:LinkButton>
                                <%--<asp:Button runat="server" ID="btnReject" Text="Reject" CommandName="Reject" CssClass="oldBtn-danger" />--%>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
