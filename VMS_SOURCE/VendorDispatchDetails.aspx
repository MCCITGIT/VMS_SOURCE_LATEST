<%@ Page Title="Unit Despatch Plan" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorDispatchDetails.aspx.vb" Inherits="VendorDispatchDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <script type="text/javascript">
        function regex(e) {

            // var regex = new RegExp("^[a-zA-Z0-9_]*$");
            var regex = new RegExp("^\\s+$");

            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                e.preventDefault();
                // alert('Please Enter Alphabet');
                return false;
            }
            else {
                return true;
            }
        }
    </script>
    <%-- <script src="Scripts/DespatchDetails.js" type="text/javascript"></script>--%>
    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <script src="Scripts/DespatchDetails.js" type="text/javascript"></script>
    <style>
        .p-vendor-dispatch-table table tr td {
            padding: 3px;
        }
    </style>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Unit Despatch Plan</h3>
                <p class="pageSubTitle">Despatch details for the selected vendor</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Month:</label>
                                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Year:</label>
                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList runat="server" ID="ddlStatus" CssClass="form-control select2">
                                    <asp:ListItem Text="Pending"></asp:ListItem>
                                    <asp:ListItem Text="Despatched"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Search Keyword:</label>
                                <asp:TextBox ID="TextSearchKeyword" CssClass="form-control" onkeyup="Search_Gridview(this)" placeholder="Search Keyword" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-2 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" ImageUrl="images/ic_search.gif" />--%>
                                <asp:LinkButton ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive ">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="gvVendorDispatch" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                                    Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found" OnRowDataBound="gvVendorDispatch_RowDataBound1">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Order Sl No." HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOrderId" runat="server" Text='<%# Bind("ddrh_order_sl_no") %>'></asp:Label>
                                                <asp:Label ID="lblRequestId" Visible="false" runat="server" Text='<%# Bind("ddrh_hdr_req_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Request Date" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequestDate" runat="server" Text='<%# Bind("ReqDate") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Despatch To" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("vom_org_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Transporter Name" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTransporter" runat="server" Text='<%# Bind("tm_transporter_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="Truck" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lbllm_desc" runat="server" Text='<%# Bind("lm_desc") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="View" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Button ID="btnViewDetails" CommandName="ViewDetails" CssClass="btn btn-info btn-sm"
                                                    runat="server" CommandArgument='<%# Bind("ddrh_hdr_req_id") %>' Text="View" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="4%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>

                                <asp:HiddenField ID="hdnTargetID2" runat="server" />
                                <asp:ModalPopupExtender ID="ModalPopupExtender2" runat="server" OkControlID="btnCancelPartner" PopupControlID="pnlAddPartners" TargetControlID="hdnTargetID2" CancelControlID="btnCancelPartner" BackgroundCssClass="modalBackground">
                                </asp:ModalPopupExtender>


                                <asp:HiddenField ID="hdnOk" runat="server" />
                                <asp:ModalPopupExtender ID="ModalPopupExtender1" runat="server"
                                    PopupControlID="Panel1" TargetControlID="hdnOk">
                                </asp:ModalPopupExtender>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnBack" runat="server" Text="Back" OnClick="btnBack_Click" CssClass="btn btn-secondary btn-sm" />
                        </div>
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlAddPartners" runat="server" CssClass="popupvendor" Width="60%" Style="overflow: auto;" Height="400px" BackColor="#f5f5f5">
                <div class="modal-header" style="padding: 12px;">
                    <asp:Label ID="Label1" runat="server" Text="Vendor Despatch" Style="color: White; font-weight: bold;"></asp:Label>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" class="p-vendor-dispatch-table">
                        <ContentTemplate>
                            <table cellspacing="10px" width="100%" style="font-family: Verdana; font-size: 8pt; font-weight: bold;">
                                <tr>
                                    <td colspan="4">
                                        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                            <ContentTemplate>
                                                <div class="table-responsive">
                                                    <asp:GridView ID="gvDispatchAssignDtls" runat="server" AutoGenerateColumns="False"
                                                        Align="Center" EmptyDataText="No record(s) found."
                                                        AllowPaging="false" BorderWidth="1" CssClass="table table-hover upgradDataGrid" ShowFooter="false">
                                                        <RowStyle CssClass="tlrowlight" />
                                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                        <HeaderStyle CssClass="headerGrid" />
                                                        <FooterStyle CssClass="footerGrid" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="SKU Code" HeaderStyle-HorizontalAlign="center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSKUCode" runat="server" Text='<%# Bind("ddrd_sku_code") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="SKU Name" HeaderStyle-HorizontalAlign="center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSkuName" runat="server" Text='<%# Bind("sku_desc") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Pack Size" HeaderStyle-HorizontalAlign="center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblPackSize" runat="server" Text='<%# Bind("ddrd_sku_pack") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Qty" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSumofQty" runat="server" Text='<%# Bind("sum_of_qty") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                            </asp:TemplateField>


                                                            <asp:TemplateField HeaderText="Uom" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblUom" runat="server" Text='<%# Bind("sku_uom") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Volume" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSumofVolume" runat="server" Text='<%# Bind("sum_of_volume") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Rate" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblrate" runat="server" Text='<%# Bind("SkuRate") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Total Rate (Inc. GST)" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblTotalRate" runat="server" Text=""></asp:Label>
                                                                    <asp:HiddenField ID="hdnSkuRate" runat="server" Value='<%# Bind("SkuRate") %>' />
                                                                    <asp:HiddenField ID="hdnSkuGST" runat="server" Value='<%# Bind("SkuGST") %>' />
                                                                    <asp:HiddenField ID="hdnUom" runat="server" Value='<%# Bind("sku_uom")%>' />
                                                                    <asp:HiddenField ID="hdnqty" runat="server" Value='<%# Bind("sum_of_qty") %>' />
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="display: flex; justify-content: flex-end">
                                            <div style="width: 115px; text-align: center">
                                                <label>Total : </label>
                                            </div>
                                            <div style="width: 115px; text-align: center">
                                                <asp:Label ID="lbltotalrateincgst" runat="server" Text=""></asp:Label>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Invoice No. <span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtInvoiceNo" runat="server" CssClass="form-control" MaxLength="24" onkeypress="return regex(event);" AutoComplete="off" onpaste="return false"></asp:TextBox>
                                        <asp:HiddenField ID="hdn_dispatchAssignHdr" runat="server"></asp:HiddenField>
                                    </td>
                                    <td>Invoice Date <span style="color: red;">*</span>
                                    </td>
                                    <td class="customCalender">
                                        <asp:TextBox ID="txtInvoiceDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender" CssClass="OpenCalender" runat="server" TargetControlID="txtInvoiceDate" Format="dd/MM/yyyy" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Transporter Name <span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTransporterName" ReadOnly="true" runat="server" CssClass="form-control"></asp:TextBox>
                                    </td>
                                    <td>Vehicle No. <%--<span style="color: red;">*</span>--%>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtLorryNo" runat="server" CssClass="form-control"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>E-Way Bill No. 
                               <%-- <span style="color: red;">*</span>--%>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtWayBill" runat="server" CssClass="form-control"></asp:TextBox>
                                    </td>
                                    <td>E-Way Bill Date 
                                <%--<span style="color: red;">*</span>--%>
                                    </td>
                                    <td class="customCalender">
                                        <asp:TextBox ID="txtewaybilldate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender2" CssClass="OpenCalender" runat="server" TargetControlID="txtewaybilldate" Format="dd/MM/yyyy" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Valid Up to 
                                <%--<span style="color: red;">*</span>--%>
                                    </td>
                                    <td class="customCalender">
                                        <asp:TextBox ID="txtvalidupto" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender1" CssClass="OpenCalender" runat="server" TargetControlID="txtvalidupto" Format="dd/MM/yyyy" />
                                    </td>
                                    <td>Final Invoice Value (After Tax) <span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtfinalinvoicevalue" runat="server" CssClass="form-control"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>PO Number 
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtpono" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Upload Actual Invoice Copy. <span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                                            <ContentTemplate>
                                                <asp:FileUpload ID="sch_fld1" runat="server" />
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="btnSave" />
                                            </Triggers>
                                        </asp:UpdatePanel>

                                    </td>
                                </tr>
                                <tr align="left">
                                    <td style="height: 19px">
                                        <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label><div
                                            id="divErrorMessage">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" Text="Save" runat="server" Font-Bold="true" class="btn btn-primary" />
                    <asp:Button ID="btnCancelPartner" runat="server" Font-Bold="true" Text="Cancel" Width="75px" class="btn btn-secondary" />
                </div>
            </asp:Panel>
            <asp:Panel ID="Panel1" runat="server" CssClass="popup" Width="20%" Height="150px" Style="overflow: auto;">
                <div style="background-color: #6699FF; height: 15px; text-align: center; padding: 2px;">
                    <asp:Label ID="Label2" runat="server" ForeColor="White" Font-Bold="true" Text="Vendor Despatch"></asp:Label>
                </div>
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                    <ContentTemplate>
                        <table width="100%" cellspacing="15px">
                            <tr>
                                <td style="text-align: center;">
                                    <asp:Label runat="server" ID="lblPopMessage" Font-Bold="true"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <asp:Button ID="btnOK" runat="server" Font-Bold="true"
                                        Text="OK" Width="75px" CssClass="but5" />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
