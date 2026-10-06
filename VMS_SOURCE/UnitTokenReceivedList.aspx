<%@ Page Title="Token Requisition List (Vendor)" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UnitTokenReceivedList.aspx.vb" Inherits="UnitTokenReceivedList" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key="&<%= DateTime.Now.ToString %> ></script>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('imgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Token Despatches List For Receive</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Unit Name:</label>
                        <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlTokenVendor" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Requisition Id:</label>
                        <asp:DropDownList ID="ddlVendorRequisition" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Despatch Id:</label>
                        <asp:DropDownList ID="ddlDespatchId" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server">
                            <asp:ListItem Value="">Select</asp:ListItem>
                            <asp:ListItem Value="P">Pending</asp:ListItem>
                            <asp:ListItem Value="R">Received</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2 form-btn-mt">
                    <div class="form-group">
                        <asp:ImageButton ImageUrl="images/p-search.png" title="Search" CssClass="btn btn-primary btn-sm py-2" ID="imgbtnSearch" runat="server" />
                    </div>
                </div>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header" style="padding-top: 0;">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Token Despatches List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvRequistionList" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvRequistionList_RowDataBound" EmptyDataText="No records found" AllowPaging="true" OnPageIndexChanging="gvProductList_PageIndexChanging" OnRowCommand="gvTokenVendorList_RowCommand" PageSize="10" CssClass="table table-hover upgradDataGrid">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Requisition  Id" ControlStyle-Width="90%" Visible="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesc" Text='<%# Bind("tdh_requisition_id")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="2%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Despatch Id" ControlStyle-Width="90%" Visible="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRequistionId" Text='<%# Bind("tdh_despatch_id")%>' runat="server" />
                                            <asp:HiddenField runat="server" Value='<%# Bind("treh_recieve_id")%>' ID="hdnReceive" />
                                            <asp:HiddenField runat="server" Value='<%# Bind("tdh_despatch_id")%>' ID="hdnDespatch" />
                                            <asp:HiddenField runat="server" Value='<%# Bind("tdh_requisition_id")%>' ID="hdnRequisition" />
                                            <asp:HiddenField runat="server" Value='<%# Bind("tdh_token_vendor")%>' ID="hdnTokenVendor" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="2%" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Unit Name" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnit" Text='<%# Bind("unit_name")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Courrier Name" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNoOfitems" Text='<%# Bind("tdh_transporter")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--               <asp:TemplateField HeaderText="Truck No." ControlStyle-Width="90%" >
                                            <ItemTemplate>
                                                 <asp:Label ID="lblTotalQty" Text='<%# Bind("tdh_truck_no")%>' runat="server" />
                                            </ItemTemplate>

                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Challan No." ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_vendor_challan_no" Text='<%# Bind("tdh_vendor_challan_no")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Challan Date" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_vendor_challan_date" Text='<%# Bind("tdh_vendor_challan_date")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Road Permit" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lbltdh_road_permit" Text='<%# Bind("tdh_road_permit")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <%--            <asp:TemplateField HeaderText="Print" ControlStyle-Width="100%" >
                                                      <HeaderTemplate>
                                                          <span>Despatch Advise</span>
                                                         
                                                      </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgBtnPrint" ImageUrl="~/images/printButton.png" CommandArgument='<%# Bind("tdh_despatch_id")%>' CommandName="PrintDespatch" Style="width:25%" ToolTip="Print" runat="server" />
                                            </ItemTemplate>

                                            <ControlStyle  Width="100%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="4%" />
                                        </asp:TemplateField>  --%>
                                    <asp:TemplateField HeaderText="View" ControlStyle-Width="100%">
                                        <HeaderTemplate>
                                            <span>View</span>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imgBtnSubmit" ImageUrl="~/images/p-view.png" title="View" CommandArgument='<%# Bind("tdh_despatch_id")%>' CommandName="EditRequisition" Style="width: 27%" ToolTip="View" runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Width="100%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>


                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="gvRequistionList" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
