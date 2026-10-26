<%@ Page Title="Test Result List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TestCaseTestResultList.aspx.vb" Inherits="TestCaseTestResultList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>
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
                <h3 class="pageTitle">Test Result List</h3>
                <p class="pageSubTitle">Browse recorded quality test results</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server" AutoPostBack="true" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Brand:</label>
                                <asp:DropDownList ID="ddlBrand" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlProduct" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Batch No:</label>
                                <asp:TextBox ID="txtBatchNo" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Batch From Date:</label>
                                <asp:TextBox ID="txtAsOndate" runat="server" CssClass="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">To Date:</label>
                                <asp:TextBox ID="txtAsOndateTo" runat="server" CssClass="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>

                        <%--<div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Test Name:</label>
                                <asp:TextBox ID="txtTestName" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>--%>
                        <div class="col-md-3 form-btn-mt">
                            <asp:Button ID="imgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                            <asp:Button ID="imgbtnExport" runat="server" Text="Export" CssClass="btn btn-info btn-sm" />
                            <%--<asp:Button ID="imgbtnAdd" runat="server" Text="Add" CssClass="btn btn-success btn-sm" />--%>
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView ID="gvTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Vendor" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequistionId" Text='<%# Bind("vendor_name") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Brand Name" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUnit" Text='<%# Bind("brand_name") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Product" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVendor" Text='<%# Bind("prd_desc")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Shade" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSiteName" Text='<%# Bind("shade") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Batch No." ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBatchNo" Text='<%# Bind("batch_no") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Batch Date" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBatchDate" Text='<%# Bind("batch_date") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Action" ControlStyle-Width="100%">
                                            <HeaderTemplate>
                                                <span>View</span>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%--<asp:Button ID="imgBtnSubmit" CommandName="EditTest" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandArgument='<%# Bind("result_id") %>'></asp:Button>--%>
                                                <div style="display: flex;align-items: center;">
                                                    <asp:LinkButton ID="imgBtnSubmit" runat="server" Visible="true" Text="View" CommandName="EditTest" CommandArgument='<%# Bind("result_id") %>' ToolTip="View"><i class="fa fa-eye"></i></asp:LinkButton>
                                                    &nbsp;
                                                   <%-- <asp:Button ID="btnEdit" Visible="false" runat="server" CssClass="btn btn-success gridBtn" Text="Edit" title="Edit" ToolTip="Edit"></asp:Button>--%>
                                                    <asp:LinkButton ID="btnEdit" runat="server" Visible="true" Text="View" ToolTip="View History"><i class="fa fa-pen" style="color: #ffbd21"></i></asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                            <ControlStyle Width="100%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>

                                        <%--<asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="true">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upnlBtn" runat="server">
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="btnExport" CommandName="EditRow" Visible="true" runat="server" Text="Export" title="Export" ToolTip="Click To Export" CommandArgument='<%# Bind("vendor_code")%>'></asp:LinkButton>

                                                        </ContentTemplate>
                                                        <Triggers>
                                                            <asp:PostBackTrigger ControlID="btnExport" />
                                                        </Triggers>
                                                    </asp:UpdatePanel>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                            <asp:PostBackTrigger ControlID="gvTestList" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
