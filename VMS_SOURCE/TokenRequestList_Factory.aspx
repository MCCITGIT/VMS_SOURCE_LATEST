<%@ Page Title="FACTORY TOKEN REQUISITION LIST" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TokenRequestList_Factory.aspx.vb" Inherits="TokenRequestList_Factory" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationIndentList_HO.js"></script>

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
                <h3 class="pageTitle">FACTORY TOKEN REQUISITION LIST</h3>
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
                        <label class="form-control-label">Factory:<span id="Span1" class="mandatory">*</span></label>
                        <asp:DropDownList ID="ddlFactory" CssClass="form-control select2" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlVendor" runat="server" CssClass="form-control select2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                            <asp:ListItem Value="">Select</asp:ListItem>
                            <asp:ListItem Value="Y">Generated</asp:ListItem>
                            <asp:ListItem Value="N">Not Generated</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
                        <asp:LinkButton ID="imgbtnAdd" runat="server" CssClass="btn btn-warning btn-sm">Add</asp:LinkButton>

                        <%--<asp:ImageButton ImageUrl="images/p-search.png" ID="imgbtnSearch" runat="server" class="btn btn-primary btn-sm py-2" />
                        <asp:ImageButton ImageUrl="~/images/p-plus.png" ID="imgbtnAdd" runat="server" class="btn btn-warning btn-sm py-2" />--%>
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
                    <h5 class="mst-panel-title">FACTORY TOKEN REQUISITION LIST</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvTokenRequisitionList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" CssClass="table table-hover upgradDataGrid">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="#">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Factory">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFactory" runat="server" Text='<%# Bind("FactoryName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("VendorName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Requisition Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSessionId" runat="server" Text='<%# Bind("ts_session_id") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnSessionId" runat="server" Value='<%# Bind("ts_session_id") %>'></asp:HiddenField>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("TokenStatus") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Requisition Date" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRequisitionDate" runat="server" Text='<%# Bind("RequisitionDate") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="1%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="1%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
