<%@ Page Title="Vendor Challan List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorChallanList.aspx.vb" Inherits="VendorChallanList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : FunctionValidator.js is commented out in MasterPage; code-behind RegisterStartupScript calls fnNewWindow('ReportViewer.aspx') for Print --%>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }

        function DeleteItem() {
            if (confirm("Are you sure you want to delete ...?")) {
                return true;
            }
            return false;
        }
    </script>
    <style>
        .no-record-card table tr td {
            border-radius: 10px;
            background-color: white !important;
            border: 1px solid #000000;
        }

        .p-popup-table table tr td span {
            font-size: 10px;
        }

        .p-vendor-dispatch-table table tr td {
            padding: 5px;
        }

        .popupvendor {
            height: 450px !important;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Challan List</h3>
                <p class="pageSubTitle">Track challans raised by vendors</p>
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
                                <label class="form-control-label">Type:</label>
                                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                    <asp:ListItem Value="Direct" Text="Direct Despatch" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="Depot" Text="Depot Despatch"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3">
                                    <asp:ListItem>01</asp:ListItem>
                                    <asp:ListItem>02</asp:ListItem>
                                    <asp:ListItem>03</asp:ListItem>
                                    <asp:ListItem>04</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>06</asp:ListItem>
                                    <asp:ListItem>07</asp:ListItem>
                                    <asp:ListItem>08</asp:ListItem>
                                    <asp:ListItem>09</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>11</asp:ListItem>
                                    <asp:ListItem>12</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan No.:</label>
                                <asp:TextBox ID="txtChallanNo" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3" style="display: none;">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2" Enabled="false">
                                    <asp:ListItem Value="P" Text="Pending"></asp:ListItem>
                                    <asp:ListItem Value="A" Text="Approved" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" ImageUrl="images/ic_search.gif" />
                                <asp:ImageButton CssClass="btn btn-success btn-sm" ID="ImgbtnAdd" runat="server" ImageUrl="images/ic_add.gif" PostBackUrl="~/UnitDespatchPlanAddUpdateVr1.aspx" Visible="false" />--%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="ImgbtnAdd" runat="server" PostBackUrl="~/UnitDespatchPlanAddUpdateVr1.aspx" Visible="false"></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="form-group row ddlPageSize">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="table-responsive no-record-card">
                        <asp:GridView ID="gvChallanDetails" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select" Visible="false">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                        <%--<asp:HiddenField ID="hdnyear" runat="server" Value='<%# Bind("desph_challan_fin_year") %>' />
                                                                                    <asp:HiddenField ID="hdnMOnth" runat="server" Value='<%# Bind("desph_process_month") %>' />
                                                                                    <asp:HiddenField ID="hdnUnit" runat="server" Value='<%# Bind("desph_desp_unit") %>' />
                                                                                    <asp:HiddenField ID="hdnChallanId" runat="server" Value='<%# Bind("desph_challan_no") %>' />
                                                                                    <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("desph_desp_depot") %>' />
                                                                                    <asp:HiddenField ID="hdndocpath" runat="server" Value='<%# Bind("doc_path") %>' />
                                                                                    <asp:HiddenField ID="hdnorgpath" runat="server" Value='<%# Bind("org_filename") %>' />--%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Despatch Type" DataField="despatch_type">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Region" DataField="region">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="desph_desp_depot">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Name" DataField="depotName">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                                                HeaderText="Challan No." DataField="desph_challan_no">
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Challan No.">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lbtnChallanNo" Text='<%# Bind("desph_challan_no") %>' CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CommandName="ViewDetails" Style="color: #005aad"></asp:LinkButton>
                                        <asp:HiddenField ID="hdnyear" runat="server" Value='<%# Bind("desph_challan_fin_year") %>' />
                                        <asp:HiddenField ID="hdnMOnth" runat="server" Value='<%# Bind("desph_process_month") %>' />
                                        <asp:HiddenField ID="hdnUnit" runat="server" Value='<%# Bind("desph_desp_unit") %>' />
                                        <asp:HiddenField ID="hdnChallanId" runat="server" Value='<%# Bind("desph_challan_no") %>' />
                                        <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("desph_desp_depot") %>' />
                                        <asp:HiddenField ID="hdndocpath" runat="server" Value='<%# Bind("doc_path") %>' />
                                        <asp:HiddenField ID="hdnorgpath" runat="server" Value='<%# Bind("org_filename") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Challan Date" DataField="desph_challan_date" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU List" DataField="skuList">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Vendor Invoice No" DataField="vendor_invoice_no">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Vendor Invoice Date" DataField="vendor_invoice_dt">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Aproved/Pending" DataField="">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgbtnPrint" runat="server" AlternateText="Print" ImageUrl="~/images/printButton.png"
                                            CommandName="Print" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Action" Visible="false">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ID="ImgbtnDeleteChallan" runat="server" AlternateText="Delete Challan" OnClientClick="return DeleteItem()" ToolTip="Click to delete challan" ImageUrl="~/images/ic_delete.gif"
                                                                                        CommandName="DeleteChallan" />--%>
                                        <%--<asp:Button ID="btnViewDetails" CommandName="ViewDetails" CssClass="btn btn-info btn-sm"
                                                                                                runat="server" CommandArgument='<%# Bind("desph_challan_no") %>' Text="View" />--%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Download">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgbtndownloadChallan" runat="server" AlternateText="Download Challan" Height="70px" ToolTip="Click to download challan" ImageUrl="~/images/download.gif"
                                            CommandName="DownloadChallan" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:HiddenField ID="hdnTargetID2" runat="server" />
                        <asp:ModalPopupExtender ID="ModalPopupExtender2" runat="server" OkControlID="btnCancelPartner" PopupControlID="pnlAddPartners" TargetControlID="hdnTargetID2" CancelControlID="btnCancelPartner" BackgroundCssClass="modalBackground">
                        </asp:ModalPopupExtender>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnAprove" CssClass="btn btn-success btn-sm" runat="server" Text="Approve" Visible="false" />
                            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                            <div id="divErrorMessage"></div>
                        </div>
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlAddPartners" runat="server" CssClass="popupvendor" Width="60%" Style="overflow: auto;" Height="400px" BackColor="#f5f5f5">
                <div class="modal-header" style="padding: 12px">
                    <asp:Label ID="Label1" runat="server" ForeColor="White" Font-Bold="true" Text="Vendor Despatch"></asp:Label>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" class="p-vendor-dispatch-table">
                        <ContentTemplate>
                            <table style="font-family: Verdana; font-size: 8pt; font-weight: bold;">
                                <tr>
                                    <td colspan="4">
                                        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                            <ContentTemplate>
                                                <div class="table-responsive p-popup-table">
                                                    <asp:GridView ID="gvDispatchAssignDtls" runat="server" AutoGenerateColumns="False"
                                                        BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No record(s) found."
                                                        AllowPaging="false" ShowFooter="false">
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
                                    <%--<td>Upload Actual Invoice Copy. <span style="color: red;">*</span>
                            </td>--%>
                                    <%--<td>
                                <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                                    <ContentTemplate>
                                        <asp:FileUpload ID="sch_fld1" runat="server" />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:PostBackTrigger ControlID="btnSave" />
                                    </Triggers>
                                </asp:UpdatePanel>

                            </td>--%>
                                </tr>
                                <%--<tr align="left">
                            <td style="height: 19px">
                                <asp:Label ID="Label2" CssClass="errormsg" Visible="true" runat="server"></asp:Label><div
                                    id="lblErrorMessage">
                                </div>
                            </td>
                        </tr>--%>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" Text="Save" runat="server" Visible="false" CssClass="btn btn-primary" />
                    <asp:Button ID="btnCancelPartner" runat="server" Font-Bold="true" Text="Cancel" value="Cancel" class="btn btn-secondary" />
                </div>
            </asp:Panel>

        </ContentTemplate>
       <Triggers>
            <asp:PostBackTrigger ControlID="gvChallanDetails" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
