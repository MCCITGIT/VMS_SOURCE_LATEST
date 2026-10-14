<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialRequisitionDtls.aspx.vb" Inherits="RawMaterialRequisitionDtls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module textarea.form-control.field-invalid,
        .rm-module select.form-control.field-invalid + .select2-container .select2-selection--single {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .rm-requisition-actions {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px;
        }
    </style>
    <div class="rm-module rm-requisition-dtls">
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript" src="Scripts/ValidateRawMaterialRequisitionDtls.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    validateRawMaterialRequisitionSubmit();
                }
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }
        function disableBackButton() {
            window.history.forward(1);
        }

        function wireRequisitionValidationClear() {
            var ddlUnit = document.getElementById("ddlUnit");
            var ddlVendor = document.getElementById("ddlVendor");

            if (ddlUnit && typeof clearUnitValidation === "function") {
                ddlUnit.addEventListener("change", clearUnitValidation);
                if (window.jQuery) {
                    jQuery(ddlUnit).on("select2:select select2:clear", clearUnitValidation);
                }
            }

            if (ddlVendor && typeof clearVendorValidation === "function") {
                ddlVendor.addEventListener("change", clearVendorValidation);
                if (window.jQuery) {
                    jQuery(ddlVendor).on("select2:select select2:clear", clearVendorValidation);
                }
            }
        }

        if (window.Sys && Sys.Application) {
            Sys.Application.add_load(wireRequisitionValidationClear);
        } else {
            document.addEventListener("DOMContentLoaded", wireRequisitionValidationClear);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Raw Material Requisition Details</h3>
                <p class="pageSubTitle">Line details of the raw material requisition</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-plus"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Add Requisition</h5>
                            <p class="mst-panel-subtitle">Select an RM vendor and enter raw material requisition details</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Name:<span id="Span1" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlUnit" ClientIDMode="Static" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                <asp:Label ID="valUnit" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                            </div>
                        </div>                        
                        <div class="col-md-4" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Supplier:</label>
                                <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                                <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">PO No:<span id="Span2" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlPono" ClientIDMode="Static" runat="server" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddlPono_SelectedIndexChanged"></asp:DropDownList>
                                <asp:Label ID="valPO" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                <asp:HiddenField ID="hdnSupplierCode" runat="server"/>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="rm-requisition-actions">
                                <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" OnClick="imgbtnSearch_Click" OnClientClick="return validateRawMaterialRequisitionSearch();" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-outline-secondary btn-sm rm-btn-icon" ID="btnRefresh" runat="server" ClientIDMode="Static" OnClick="btnRefresh_Click" CausesValidation="false" ToolTip="Refresh"><i class="fas fa-sync-alt"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <asp:GridView ID="gvVendorRawMat" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid"
                                    EmptyDataText="No records added." GridLines="both">
                                    <RowStyle CssClass="tlrowlight" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Vendor Name">
                                            <ItemTemplate>
                                                <%--<asp:HiddenField ID="hdnId" runat="server" Value='<%# Bind("id") %>' />--%>
                                                <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                                <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                                <asp:HiddenField ID="hdnRate" runat="server" Value='<%# Bind("rate") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="rawmat_code" HeaderText="Raw Material Code" ReadOnly="true" />
                                        <asp:BoundField DataField="rawmat_name" HeaderText="Raw Material Name" ReadOnly="true" /> 

                                        <asp:BoundField DataField="qty" HeaderText="Quantity" ReadOnly="true" />   
                                        <asp:BoundField DataField="rate" HeaderText="Rate" ReadOnly="true" />
                                        <asp:BoundField DataField="amount" HeaderText="Amount" ReadOnly="true" />
                                        <asp:BoundField DataField="pending_qty" HeaderText="Pending Quantity" ReadOnly="true" />  
                                                                                          
                                        <asp:TemplateField HeaderText="Quantity Required">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hdnPendingQty" runat="server" Value='<%# Eval("pending_qty") %>' />
                                                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control form-control-sm" AutoComplete="Off"
                                                    onkeypress="return allowRateTwoDecimal(event, this);"
                                                    oninput="sanitizeRateTwoDecimal(this); clearRequisitionGridFieldValidation(this);"
                                                    onblur="formatRateTwoDecimal(this);"
                                                    onchange="clearRequisitionGridFieldValidation(this);"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Required Delivery Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtReqDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date" AutoComplete="Off"
                                                    oninput="clearRequisitionGridFieldValidation(this);"
                                                    onchange="clearRequisitionGridFieldValidation(this);"></asp:TextBox>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="12%" />
                                        </asp:TemplateField>                                        
                                        <asp:TemplateField HeaderText="Remarks">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control form-control-sm" AutoComplete="Off"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" Visible="false" OnClientClick="return validateRawMaterialRequisitionSubmit();" />
                            <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" />
                           <%-- <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />--%>
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
        </Triggers>
    </asp:UpdatePanel>
    </div>
</asp:Content>

