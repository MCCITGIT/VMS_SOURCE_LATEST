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

        // Modified-by MUKESH BHAGAT on 18-09-2026 : From Date - To Date search validation.
        // The Search LinkButton posts back through __doPostBack, which skips the browser's own
        // min/max checking, so a typed (not picked) date has to be checked here. Every limit is
        // read from the inputs' own min / max / data-max-range-days attributes (set server-side),
        // so there is one source of truth; the server re-validates regardless.
        // yyyy-MM-dd strings compare correctly as plain text.
        function validateChallanSearch() {
            var from = document.getElementById('txtFromDate');
            var to = document.getElementById('txtToDate');
            var lbl = document.getElementById('lblSearchError');
            if (!from || !to) { return true; }

            function show(d) { var p = d.split('-'); return p[2] + '/' + p[1] + '/' + p[0]; }
            function fail(msg, el) { if (lbl) { lbl.innerHTML = msg; } if (el) { el.focus(); } return false; }

            if (lbl) { lbl.innerHTML = ''; }
            if (!from.value) { return fail('Please select From Date.', from); }
            if (!to.value) { return fail('Please select To Date.', to); }
            if (from.min && from.value < from.min) { return fail('From Date cannot be earlier than ' + show(from.min) + '.', from); }
            if (to.max && to.value > to.max) { return fail('To Date cannot be later than today (' + show(to.max) + ').', to); }
            if (from.max && from.value > from.max) { return fail('From Date cannot be later than today (' + show(from.max) + ').', from); }
            if (from.value > to.value) { return fail('From Date cannot be later than To Date.', from); }

            var maxDays = parseInt(to.getAttribute('data-max-range-days'), 10);
            if (!isNaN(maxDays) && maxDays > 0) {
                var days = Math.round((new Date(to.value) - new Date(from.value)) / 86400000) + 1;
                if (days > maxDays) { return fail('Please search a period of at most ' + maxDays + ' days (selected: ' + days + ').', to); }
            }
            return true;
        }
    </script>
    <style>
        .no-record-card table tr td {
            /*border-radius: 10px;*/
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
                        <%-- Modified-by MUKESH BHAGAT on 18-09-2026 : the Process Year / Process Month dropdowns
                             are replaced by a From Date - To Date calendar (HTML5 date inputs, the same
                             TextMode="Date" already used on MonthYearWiseUnitDespatch.aspx etc.).
                             min / max / data-max-range-days are set in code-behind (InitSearchDates):
                               min = 01-Jan of the oldest year in dbo.fin_year - the same [FinYr_Details_Get]
                                     data the old Process Year dropdown listed, so the calendar goes back
                                     exactly as far as the dropdown did and no further
                               max = today - a future date cannot be picked
                             The browser greys out anything outside min..max in the picker; typed values are
                             checked by validateChallanSearch() and, authoritatively, again on the server
                             (TryGetSearchDates). Search now runs SP [Unit_Dspatch_Get_Challan_Detail_vr5]. --%>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">From Date:<span class="mandatory">*</span></label>
                                <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TextMode="Date" CssClass="form-control" TabIndex="3"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">To Date:<span class="mandatory">*</span></label>
                                <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TextMode="Date" CssClass="form-control" TabIndex="3"></asp:TextBox>
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
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click" OnClientClick="return validateChallanSearch();">Search</asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="ImgbtnAdd" runat="server" PostBackUrl="~/UnitDespatchPlanAddUpdateVr1.aspx" Visible="false"></asp:LinkButton>
                            </div>
                        </div>
                        <%-- Modified-by MUKESH BHAGAT on 18-09-2026 : From / To date validation message --%>
                        <div class="col-md-12">
                            <asp:Label ID="lblSearchError" runat="server" ClientIDMode="Static" CssClass="errormsg"></asp:Label>
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
                                <%-- Modified-by MUKESH BHAGAT on 11-09-2026 : GRN No / GRN Date / SKU NOP from SP _vr4.
                                     Inserting them here shifts the "Aproved/Pending" and "Print" cell indexes used in
                                     gvChallanDetails_RowDataBound (11->14, 12->15). --%>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="GRN No" DataField="GRN_No">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="GRN Date" DataField="GRN_Date">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU NOP (Pcs)" DataField="sku_nop">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
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
