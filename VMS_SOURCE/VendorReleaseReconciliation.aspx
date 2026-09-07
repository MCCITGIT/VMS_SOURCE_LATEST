<%@ Page Title="Vendor Invoice Account Release Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorReleaseReconciliation.aspx.vb" Inherits="VendorReleaseReconciliation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">var cal1 = new CalendarPopup();</script>
    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>

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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">

        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div id="divDepot" class="col-md-2" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddldepot" runat="server" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div id="divStatus" class="col-md-2" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2" TabIndex="2">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Paid" Value="Paid" />
                                    <asp:ListItem Text="Due" Value="Due" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div id="divType" class="col-md-2" runat="server">
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
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="btnBack" runat="server" OnClick="btnBack_Click" Text="Back" ToolTip="Back" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card rm-list-fill">
                <%--<div class="card">--%>
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <%--<h5 class="mst-panel-title">Vendor List</h5>--%>
                            <asp:Label ID="lblPanelTitle" runat="server" CssClass="mst-panel-title" Text="Vendor List"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive rm-grid-scroll">
                        <asp:GridView ID="gvVendorInvoiceDtls" runat="server" AutoGenerateColumns="false" AllowPaging="True" PageSize="10" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField DataField="org_id" Visible="false" />
                                <asp:BoundField HeaderText="Release ID" DataField="desph_release_id">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Depot" DataField="depot_name">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice No" DataField="Invoice_No">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice Date" DataField="Invoice_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice Value" DataField="Invoice_Value"
                                    DataFormatString="{0:N2}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Release No" DataField="Release_No">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Release Date" DataField="Release_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="GRN No" DataField="GRN_No">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="GRN Date" DataField="GRN_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Voucher No" DataField="Voucher_No">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Amount Paid" DataField="Payment_Status"
                                    DataFormatString="{0:N2}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Amount Due" DataField="PendingAmount"
                                    DataFormatString="{0:N2}">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                            </Columns>

                            <%--<Columns>
                        <asp:TemplateField HeaderText="Sl No">
                            <ItemTemplate>
                                <%# (gvVendorInvoiceDtls.PageIndex * gvVendorInvoiceDtls.PageSize) + Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                        </asp:TemplateField>
                        <asp:BoundField
                            HeaderText="Release No"
                            DataField="desph_release_id">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Depot"
                            DataField="desph_desp_depot">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Transporter Name"
                            DataField="desph_transporter_name">
                            <HeaderStyle HorizontalAlign="Left" Width="30%" />
                            <ItemStyle HorizontalAlign="Left" Width="30%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Invoice Value"
                            DataField="desph_invoice_value"
                            DataFormatString="{0:N2}">
                            <HeaderStyle HorizontalAlign="Right" Width="15%" />
                            <ItemStyle HorizontalAlign="Right" Width="15%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Dispatch Date"
                            DataField="created_date"
                            DataFormatString="{0:dd-MM-yyyy}">
                            <HeaderStyle HorizontalAlign="Center" Width="15%" />
                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                        </asp:BoundField>
                    </Columns>--%>
                        </asp:GridView>
                    </div>
                    <div class="custom-pagination">

                        <div class="page-selector">

                            <span class="page-label">Page</span>

                            <asp:DropDownList
                                ID="ddlPageNumber"
                                runat="server"
                                CssClass="selectpicker page-dropdown p-page-selector"
                                data-live-search="true"
                                data-size="5"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlPageNumber_SelectedIndexChanged">
                            </asp:DropDownList>

                            <span class="page-label">of
                        <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                            </span>

                        </div>

                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
        </ContentTemplate>


        <Triggers>

            <asp:AsyncPostBackTrigger
                ControlID="ddlUnit"
                EventName="SelectedIndexChanged" />


            <asp:AsyncPostBackTrigger
                ControlID="ImgbtnSearch"
                EventName="Click" />


            <asp:AsyncPostBackTrigger
                ControlID="ddlPageNumber"
                EventName="SelectedIndexChanged" />

        </Triggers>


    </asp:UpdatePanel>
    <%--</div>--%>
            </div>
            <script type="text/javascript">

                function initializePageDropdown() {

                    $('.selectpicker').selectpicker();

                }


                $(document).ready(function () {

                    initializePageDropdown();

                });


                // Required for ASP.NET WebForms postback / UpdatePanel
                if (typeof Sys !== "undefined") {

                    Sys.WebForms.PageRequestManager.getInstance()
                        .add_endRequest(function () {

                            initializePageDropdown();

                        });

                }

            </script>
</asp:Content>
