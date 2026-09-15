<%@ Page Title="Vendor Invoice Account Release Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorInvoiceAc_ReleaseDtls.aspx.vb" Inherits="VendorInvoiceAc_ReleaseDtls" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">var cal1 = new CalendarPopup();</script>
    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
    <style>
        .vendor-name-column {
            min-width: 150px;
        }
    </style>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Invoice Account Release Details</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddldepot" runat="server" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2" TabIndex="2">
                            <asp:ListItem Text="Select" Value="" />
                            <asp:ListItem Text="Paid" Value="Paid" />
                            <asp:ListItem Text="Due" Value="Due" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Type:</label>
                        <asp:DropDownList ID="ddltype" runat="server" CssClass="form-control select2" TabIndex="2">
                            <asp:ListItem Text="Select" Value="" />
                            <asp:ListItem Text="Depot Despatch" Value="Depot Despatch" />
                            <asp:ListItem Text="Direct Despatch" Value="Direct Despatch" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">From Date:</label>
                        <asp:TextBox ID="txtFromDate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                        <%--<a href="javascript:cal1.select(document.forms[0].txtFromDate,'FromDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="FromDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy" />
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">To Date:</label>
                        <asp:TextBox ID="txtTodate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                        <%-- <a href="javascript:cal1.select(document.forms[0].txtTodate,'ToDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="ToDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTodate" Format="dd/MM/yyyy" />
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" ImageUrl="images/ic_search.gif" ToolTip="Search" AlternateText="Search" />--%>
                        <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click" ToolTip="Search" Text="Search"></asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-success btn-sm" ID="btndownload" runat="server" OnClick="btndownload_Click" Text="Download" ToolTip="Download" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <asp:GridView ID="gvVendorInvoiceDtls" runat="server" AutoGenerateColumns="false" AllowPaging="True" OnRowDataBound="gvVendorInvoiceDtls_RowDataBound" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                            </asp:BoundField>--%>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Type" DataField="Type">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Vendor Name" DataField="vendor_unit_name">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" CssClass="vendor-name-column" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Depot" DataField="depot_name">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Despatched Date" DataField="InvoiceUploadDate">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Invoice No" DataField="Invoice_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Invoice Date" DataField="Invoice_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Invoice Value" DataField="Invoice_Value">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Release No" DataField="Release_No" ControlStyle-Width="6%">
                            <ControlStyle Width="10%"></ControlStyle>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Release Date" DataField="Release_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="GRN No" DataField="GRN_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="GRN Date" DataField="GRN_Date">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Voucher No" DataField="Voucher_No">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Amount Paid" DataField="Payment_Status">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Amount Due" DataField="PendingAmount">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div id="divErrorMessage"></div>
        </div>
    </div>

</asp:Content>
