<%@ Page Title="Token Vendor Requisition List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TokenVendorRequisitionList.aspx.vb" Inherits="TokenVendorRequisitionList" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <%--<script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>--%>

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
    <script type="text/javascript">
        var cal1 = new CalendarPopup();
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Token Requisition List (Vendor)</h3>
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
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlTokenVendor" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Unit Name:</label>
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorUnit" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Requisition Id:</label>
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorRequisition" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">From Date:</label>
                        <asp:TextBox ID="txtFromDate" CssClass="form-control" runat="server" ReadOnly="true" MaxLength="10"></asp:TextBox>
                        <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtFromDate,'RequisitionFromDate','dd/MM/yyyy');" style="top: 31px;">
                            <img src="images/p-calendar.png" id="RequisitionFromDate" alt="Calender" style="border: 0; margin-top: -4px; position: absolute; margin-left: 5px" />
                        </a>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">To Date:</label>
                        <asp:TextBox ID="txtTodate" CssClass="form-control" runat="server" ReadOnly="true" MaxLength="10"></asp:TextBox>
                        <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtTodate,'RequisitionToDate','dd/MM/yyyy');" style="top: 31px;">
                            <img src="images/p-calendar.png" id="RequisitionToDate" alt="Calender" style="border: 0; margin-top: -4px; position: absolute; margin-left: 5px" />
                        </a>
                    </div>
                </div>
                <div class="col-md-2 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" OnClick="imgbtnSearch_Click" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
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
                    <h5 class="mst-panel-title">Token Requisition List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvRequistionList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" CssClass="table table-hover upgradDataGrid">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Requisition Id" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRequistionId" Text='<%# Bind("trh_id") %>' runat="server" />

                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Requisition Date" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblcreated_date" Text='<%# Bind("created_date")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit Name" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnit" Text='<%# Bind("trh_unit") %>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor Name" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendor" Text='<%# Bind("VendorName")%>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Site Name" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSiteName" Text='<%# Bind("trh_site_name") %>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Description" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesc" Text='<%# Bind("trh_desc") %>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="No. of items" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNoOfitems" Text='<%# Bind("items") %>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Qty." ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTotalQty" Text='<%# Bind("totalQty") %>' runat="server" />
                                        </ItemTemplate>

                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="5%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action" Visible="false" ControlStyle-Width="100%">
                                        <HeaderTemplate>
                                            <span>Action</span>

                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imgBtnSubmit" ImageUrl="~/images/ic_view.gif" CommandArgument='<%# Bind("trh_id") %>' CommandName="EditRequisition" Style="width: 25%" ToolTip="View" runat="server" />
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
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                        <asp:PostBackTrigger ControlID="gvRequistionList" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
