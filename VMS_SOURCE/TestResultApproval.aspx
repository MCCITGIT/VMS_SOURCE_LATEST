<%@ Page Title="Test Result Aproval" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TestResultApproval.aspx.vb" Inherits="TestResultApproval" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/TestResultApprove.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
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
                <h3 class="pageTitle">Test Result Approval</h3>
                <p class="pageSubTitle">Review and approve quality test results</p>
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
                                <asp:TextBox ID="txtVendor" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Brand Name:</label>
                                <asp:TextBox ID="txtBrand" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:TextBox ID="txtProduct" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Shade:</label>
                                <asp:TextBox ID="txtShade" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Batch No:</label>
                                <asp:TextBox ID="txtBatchNo" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Batch Date:</label>
                                <asp:TextBox ID="txtBdate" ReadOnly="true" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">
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
                                                <asp:TemplateField HeaderText="Ref Value" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Frequency" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Actual" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblActual" Text='<%# Bind("trd_test_output") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Qualify" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblQualify" Text='<%# Bind("status") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </div>

                        <div class="col-md-12 text-center">
                            <div class="form-group">
                                <%-- <label class="form-control-label">Remarks:<span style="color: red;">*</span></label>--%>
                                <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Height="25" Width="250"></asp:TextBox>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-success btn-sm" />
                    <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-danger btn-sm" />
                    <asp:Button ID="btnBack" runat="server" Text="Cancel" ToolTip="BackToList" CssClass="btn btn-dark btn-sm" />
                    <%--<asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />--%>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>

            <%-- Begin--%>
            <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLongTitle">Modal title</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            ...
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary">Save changes</button>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
