<%@ Page Title="Test CaseTest List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TestCaseTestMasterList.aspx.vb" Inherits="TestCaseTestMasterList" %>

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
                <h3 class="pageTitle">Test CaseTest List</h3>
                <p class="pageSubTitle">Browse quality test case records</p>
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
                                <label class="form-control-label">Frequency:</label>
                                <asp:DropDownList ID="ddlFrequency" CssClass="form-control select2" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Result Type:</label>
                                <asp:DropDownList ID="ddlResultType" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Test Name:</label>
                                <asp:TextBox ID="txtTestName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <asp:Button ID="imgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                            <asp:Button ID="imgbtnAdd" runat="server" Text="Add" CssClass="btn btn-success btn-sm" />
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
                                        <%-- <asp:TemplateField HeaderText="Test Id" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRequistionId" Text='<%# Bind("test_id") %>' runat="server" />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Test Name" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUnit" Text='<%# Bind("test_name") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Frequency" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVendor" Text='<%# Bind("frequency_value")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="6%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Result Type" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSiteName" Text='<%# Bind("test_type_value") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref Value" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRefValue" Text='<%# Bind("ref_value") %>' runat="server" />
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
                                            <%--    <asp:Button ID="imgBtnSubmit" CommandName="EditTest" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandArgument='<%# Bind("test_id") %>'></asp:Button>
                                                --%>
                                                    <asp:LinkButton ID="btnView" runat="server" Visible="true" CommandName="EditTest" CommandArgument='<%# Bind("test_id") %>' ToolTip="View"><i class="fa fa-eye"></i></asp:LinkButton>
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
                            <asp:PostBackTrigger ControlID="gvTestList" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
