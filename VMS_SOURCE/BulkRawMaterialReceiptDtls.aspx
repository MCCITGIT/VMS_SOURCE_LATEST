<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="BulkRawMaterialReceiptDtls.aspx.vb" Inherits="BulkRawMaterialReceiptDtls" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateBulkRawMaterialReceipt.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            var btnSubmit = document.getElementById('btnSubmit');
            if (event.keyCode == 118) {
                if (!btnSubmit || btnSubmit.disabled == true)
                    return false;
                else if (typeof validateReceive === "function" && validateReceive()) {
                    document.getElementById('btnSubmit').disabled = true;
                    __doPostBack(document.getElementById('btnSubmit').name, '');
                }
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }
        function disableBackButton() {
            window.history.forward(1);
        }
        function validateDecimalInput(input) {

            var value = input.value;

            // Remove anything except numbers and decimal point
            value = value.replace(/[^0-9.]/g, '');

            // Allow only one decimal point
            var parts = value.split('.');

            if (parts.length > 2) {
                value = parts[0] + '.' + parts[1];
            }

            // Maximum 2 digits after decimal
            if (parts.length === 2) {
                value = parts[0] + '.' + parts[1].substring(0, 2);
            }

            input.value = value;
        }
    </script>

    <div class="rm-module rm-compact">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Bulk Raw Material Receipt</h3>
                    <p class="pageSubTitle">Enter receipt details for bulk raw material</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-box-open"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Receipt Details</h5>
                                <p class="mst-panel-subtitle">Record received quantities for this bulk raw material despatch</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Receipt No:</label>
                                    <asp:TextBox ID="txtreceiptNo" ClientIDMode="Static" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Courier No:</label>
                                    <asp:TextBox ID="txtCourierno" ClientIDMode="Static" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                    <asp:HiddenField ID="hdnDespatchId" runat="server" />
                                    <asp:HiddenField ID="hdnRequisitionId" runat="server" />
                                    <asp:HiddenField ID="hdnReceiveId" runat="server" />
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Courier Name:</label>
                                    <asp:TextBox ID="txtcouriernm" ClientIDMode="Static" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Courier Date:</label>
                                    <asp:TextBox ID="txtcourierDT" ClientIDMode="Static" CssClass="form-control" MaxLength="10" runat="server" placeholder="dd/mm/yyyy" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Despatch Date:</label>
                                    <asp:TextBox ID="txtDOJ" ClientIDMode="Static" CssClass="form-control" MaxLength="10" runat="server" placeholder="dd/mm/yyyy" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Invoice No:</label>
                                    <asp:TextBox ID="txtinvno" ClientIDMode="Static" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Invoice Date:</label>
                                    <asp:TextBox ID="txtinvdate" ClientIDMode="Static" CssClass="form-control" MaxLength="10" runat="server" placeholder="dd/mm/yyyy" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Transporter No:</label>
                                    <asp:TextBox ID="txttransno" ClientIDMode="Static" CssClass="form-control" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Transporter Name:</label>
                                    <asp:TextBox ID="txtTransporterNM" ClientIDMode="Static" CssClass="form-control" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">LR No:</label>
                                    <asp:TextBox ID="txtlrno" ClientIDMode="Static" CssClass="form-control" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">LR Date:</label>
                                    <asp:TextBox ID="txtlrdate" ClientIDMode="Static" CssClass="form-control" MaxLength="10" runat="server" placeholder="dd/mm/yyyy" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Vehicle No:</label>
                                    <asp:TextBox ID="txtVehicleno" ClientIDMode="Static" CssClass="form-control" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Delivery Type:</label>
                                    <asp:TextBox ID="txtdeliverytype" ClientIDMode="Static" CssClass="form-control" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3" runat="server" id="divgvrequestdetails">
                            <div class="col-md-12">
                                <div class="mst-panel-header">
                                    <div class="mst-panel-header-left">
                                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                                        <div>
                                            <h5 class="mst-panel-title">Item Details</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <asp:UpdatePanel ID="upItemDetails" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="gvVendorRawMat" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                                EmptyDataText="No pending raw material found for receipt." GridLines="both"
                                                OnRowCommand="gvVendorRawMat_RowCommand" OnRowDataBound="gvVendorRawMat_RowDataBound">
                                                <RowStyle CssClass="tlrowlight" />
                                                <HeaderStyle CssClass="headerGrid" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="#">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkSelect" runat="server" Checked="true" Style="display: none" />
                                                            <asp:Label ID="lblRowNo" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                            <asp:HiddenField ID="hdnsubinvemtory" Value='<%# Bind("sub_inventory")%>' runat="server" />
                                                            <asp:HiddenField ID="hdnlocator" Value='<%# Bind("locater")%>' runat="server" />
                                                            <asp:HiddenField ID="hdnItemCode" Value='<%# Bind("rawmaterial_code")%>' runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                                        <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Raw Material">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblRawMatName" runat="server" Text='<%# Eval("rawmaterial_name") %>'></asp:Label>
                                                            <asp:HiddenField ID="hdnRawMatCode" runat="server" Value='<%# Eval("rawmaterial_code") %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Width="28%" />
                                                        <ItemStyle HorizontalAlign="Left" Width="28%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Qty. to be received">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDespQty" runat="server" Text='<%# Eval("despatch_qunt", "{0:0.##}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Width="12%" />
                                                        <ItemStyle HorizontalAlign="Right" Width="12%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Request Qty">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtQty" runat="server" CssClass="form-control text-right" Text='<%# Eval("request_quant", "{0:0.##}") %>' Enabled="false"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="12%" />
                                                        <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="12%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Received Qty">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtRecMatchQty" runat="server" CssClass="form-control text-right" Text='<%# Eval("despatch_qunt", "{0:0.##}") %>' Enabled="false"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="12%" />
                                                        <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="12%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Good">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtGood" runat="server" CssClass="form-control text-right" Text='<%# Eval("Good_Qty", "{0:0.##}") %>' oninput="validateDecimalInput(this)"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                        <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Damage">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtDamage" runat="server" CssClass="form-control text-right" Text='<%# Eval("Damage_Qty", "{0:0.##}") %>' oninput="validateDecimalInput(this)"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                        <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Short">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtShort" runat="server" CssClass="form-control text-right" Text='<%# Eval("Short_Qty", "{0:0.##}") %>' oninput="validateDecimalInput(this)"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                        <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="" Visible="false">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnAdjustRow" runat="server" CssClass="btn btn-success btn-sm" CommandName="Adjustment" Text="Adjustment" CausesValidation="false" UseSubmitBehavior="false" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Width="10%" />
                                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3" runat="server" id="divgvrequest" visible="false">
                            <div class="col-md-12">
                                <div class="mst-panel-header">
                                    <div class="mst-panel-header-left">
                                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                                        <div>
                                            <h5 class="mst-panel-title">Item Details</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <asp:GridView ID="gvReceivedItems" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                        EmptyDataText="No record(s) found." GridLines="both" Width="100%">
                                        <RowStyle CssClass="tlrowlight" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Raw Material">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblitem" runat="server" Text='<%# Bind("item_description") %>'></asp:Label>
                                                    <asp:HiddenField ID="hdnitem" runat="server" Value='<%# Bind("item_code") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="35%" />
                                                <ItemStyle HorizontalAlign="Left" Width="35%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Despatch Quantity">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbldespQty" runat="server" Text='<%# Bind("despatch_quant", "{0:0.##}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                                <ItemStyle HorizontalAlign="Right" Width="15%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Receive Quantity">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblrecpQty" runat="server" Text='<%# Bind("receive_quant", "{0:0.##}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                                <ItemStyle HorizontalAlign="Right" Width="15%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Good">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblGood" runat="server" Text='<%# Eval("Good_Qty", "{0:0.##}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="12%" />
                                                <ItemStyle HorizontalAlign="Right" Width="12%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Short">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblShort" runat="server" Text='<%# Eval("Short_Qty", "{0:0.##}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="11.5%" />
                                                <ItemStyle HorizontalAlign="Right" Width="11.5%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Damage">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDamage" runat="server" Text='<%# Eval("Damage_Qty", "{0:0.##}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" Width="10%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 text-center">
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" Visible="false" />
                                <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                        <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSubmit" />
                <asp:AsyncPostBackTrigger ControlID="btnAdjust" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:HiddenField ID="hdnAdjustTarget" runat="server" />
        <asp:ModalPopupExtender ID="mpAdjust" runat="server" PopupControlID="pnlAdjustment" TargetControlID="hdnAdjustTarget"
            BackgroundCssClass="popupBackground">
        </asp:ModalPopupExtender>
        <asp:Panel ID="pnlAdjustment" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <asp:UpdatePanel ID="upAdjustHeader" runat="server">
                            <ContentTemplate>
                                <h5 class="modal-title">Adjustment -
                                <asp:Label ID="lblHItemPop" runat="server"></asp:Label>
                                    (Qty -
                                <asp:Label ID="lblQtyPop" runat="server" Text="0"></asp:Label>)
                                </h5>
                                <asp:HiddenField ID="hdnItemCodePop" runat="server" />
                                <asp:HiddenField ID="hdnItemTypePop" runat="server" />
                                <asp:HiddenField ID="hdnRequestQtyPop" runat="server" />
                                <asp:HiddenField ID="hdnDespQtygv" runat="server" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="modal-body text-left">
                        <asp:UpdatePanel ID="upAdjustBody" runat="server">
                            <ContentTemplate>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Sub Inventory:</label>
                                            <asp:DropDownList ID="ddlSubInventoryPop" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSubInventoryPop_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Locator:</label>
                                            <asp:DropDownList ID="ddlLocatorPop" ClientIDMode="Static" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Desp Qty:</label>
                                            <div class="form-control" style="background-color: #e9ecef;">
                                                <asp:Label ID="lblDespopQty" ClientIDMode="Static" runat="server" Font-Bold="true"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label">Recp Qty:</label>
                                            <asp:TextBox runat="server" ID="txtQtyPop" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-control-label d-block">&nbsp;</label>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-info" ToolTip="Add" CausesValidation="false" OnClick="btnAdd_Click">
                                            <i class="fa fa-plus-square" aria-hidden="true"></i> Add
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                                <asp:Label ID="lblmsg" runat="server" ForeColor="Red" CssClass="d-block mb-2" Text=""></asp:Label>
                                <div class="table-responsive" style="max-height: 280px; overflow-y: auto;">
                                    <asp:GridView ID="gvAdjustDtls" runat="server" AutoGenerateColumns="false" Width="100%" AllowPaging="false" EmptyDataText="No record(s) found."
                                        CssClass="table table-hover upgradDataGrid" OnRowCommand="gvAdjustDtls_RowCommand">
                                        <RowStyle CssClass="tlrowlight" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Item Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblitemname" runat="server" Text='<%# Bind("item_name")%>'></asp:Label>
                                                    <asp:HiddenField ID="hdnitemcode" runat="server" Value='<%# Bind("item_code")%>' />
                                                    <asp:HiddenField ID="hdntypecode" runat="server" Value='<%# Bind("item_type_code")%>' />
                                                    <asp:Label ID="lbltype" runat="server" Text='<%# Bind("item_type")%>' Visible="false"></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="30%" />
                                                <ItemStyle HorizontalAlign="Left" Width="30%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Sub Inventory">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblsubinventory" runat="server" Text='<%# Bind("sub_inventory")%>'></asp:Label>
                                                    <asp:HiddenField ID="hdnsubinventorycode" runat="server" Value='<%# Bind("sub_inventory_code")%>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="20%" />
                                                <ItemStyle HorizontalAlign="Center" Width="20%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Locator">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbllocator" runat="server" Text='<%# Bind("locator")%>'></asp:Label>
                                                    <asp:HiddenField ID="hdnlocatorcode" runat="server" Value='<%# Bind("locator_code")%>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="20%" />
                                                <ItemStyle HorizontalAlign="Center" Width="20%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Qty">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblQtygv" runat="server" Text='<%# Bind("received_qty")%>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                                <ItemStyle HorizontalAlign="Right" Width="15%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkRemove" runat="server" CommandName="Remove" CausesValidation="false">
                                                    <i class="fa fa-trash" style="font-size: large; color: #dc1818;" title="Remove"></i>
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="10%" />
                                                <ItemStyle HorizontalAlign="Center" Width="10%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="modal-footer">
                        <asp:UpdatePanel ID="upAdjustFooter" runat="server">
                            <ContentTemplate>
                                <asp:Label ID="lblError" ClientIDMode="Static" runat="server" ForeColor="Red" CssClass="mr-2" Text=""></asp:Label>
                                <asp:LinkButton ID="lbtnExit" runat="server" OnClick="lbtnExit_Click" CausesValidation="false" CssClass="btn btn-secondary">Cancel</asp:LinkButton>
                                <asp:LinkButton ID="btnAdjust" runat="server" CssClass="btn btn-primary" Enabled="false" Visible="false" CausesValidation="false" OnClick="btnadjust_Click">Continue</asp:LinkButton>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <asp:HiddenField ID="hdnSuccessTarget" runat="server" />
        <asp:ModalPopupExtender ID="mpSuccess" runat="server" PopupControlID="pnlSuccess" TargetControlID="hdnSuccessTarget"
            BackgroundCssClass="popupBackground">
        </asp:ModalPopupExtender>
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <asp:Label ID="lblModalTitle" Text="Bulk Raw Material Receipt" runat="server"></asp:Label>
                        </h5>
                    </div>
                    <div class="modal-body text-center">
                        <asp:UpdatePanel ID="upSuccessBody" runat="server">
                            <ContentTemplate>
                                <asp:Label ID="lblPopMessageShow" runat="server" ForeColor="#3f7c3b" Font-Bold="true" Text=""></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="modal-footer">
                        <asp:LinkButton runat="server" ID="lbtnExit2" CssClass="btn btn-primary" OnClick="lbtnExit2_Click">Ok</asp:LinkButton>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>
