<%@ Page Title="Upload Missing Invoice" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="MissingInvoiceUpload.aspx.vb" Inherits="MissingInvoiceUpload" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- Author: MUKESH BHAGAT, 13-11-2026.
         Vendors upload the invoice copy (PDF) for despatch challans that were saved without one. Each upload is only STAGED
         (table challan_invoice_resubmit); head office checks it on Review Missing Invoice and attaches it to the challan.
         Only challans of the signed-in vendor that still have no invoice copy are listed, so a vendor with nothing missing
         sees an empty list. No bill check (OCR) is run here by design. --%>
    <script type="text/javascript">
        var MIU_MAX_BYTES = 10 * 1024 * 1024;   // 10 MB, same limit the server enforces

        function miuToday() {
            var d = new Date();
            return d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2);
        }

        // Row check before the postback. The server repeats every one of these checks.
        function miuCheckRow(btn) {
            var tr = btn.closest('tr');
            var inv = tr.querySelector('input[id$="txtInvNo"]');
            var dt = tr.querySelector('input[id$="txtInvDate"]');
            var fu = tr.querySelector('input[type="file"]');
            if (!inv || !inv.value.trim()) { alert('Please enter the Invoice No.'); if (inv) inv.focus(); return false; }
            if (!dt || !dt.value) { alert('Please enter the Invoice Date.'); if (dt) dt.focus(); return false; }
            if (dt.value > miuToday()) { alert('Invoice Date cannot be in the future.'); dt.focus(); return false; }
            if (!fu || !fu.files || fu.files.length === 0) { alert('Please choose the invoice file (PDF).'); return false; }
            var f = fu.files[0];
            if (!/\.pdf$/i.test(f.name)) { alert('Only a PDF file can be uploaded.'); return false; }
            if (f.size <= 0) { alert('The chosen file is empty.'); return false; }
            if (f.size > MIU_MAX_BYTES) { alert('The file is larger than 10 MB. Please upload a smaller PDF.'); return false; }
            return confirm('Submit this invoice for the challan?');
        }
    </script>

    <div class="container-fluid">
        <div class="card">
            <div class="card-header"><strong>Upload Missing Invoice</strong></div>
            <div class="card-body">
                <p>These despatch challans were saved without an invoice copy. For each one, enter the invoice number and date, choose the invoice
                    PDF and click <b>Submit</b>. Head office will check it and attach it to the challan. A challan disappears from this list once its
                    invoice copy has been attached.</p>
                <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>

                <div class="table-responsive">
                    <asp:GridView ID="gvMissing" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm"
                        EmptyDataText="No challan of yours is waiting for an invoice. Nothing to upload." DataKeyNames="challan_no">
                        <Columns>
                            <asp:BoundField DataField="challan_no" HeaderText="Challan No" />
                            <asp:BoundField DataField="challan_date" HeaderText="Challan Date" />
                            <asp:BoundField DataField="invoice_no" HeaderText="Invoice No on challan" />
                            <asp:BoundField DataField="invoice_date" HeaderText="Invoice Date on challan" />
                            <asp:BoundField DataField="invoice_value" HeaderText="Invoice Value" DataFormatString="{0:N2}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# StatusText(Eval("sub_status"), Eval("sub_on"), Eval("sub_remarks")) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice No">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtInvNo" runat="server" CssClass="form-control" MaxLength="100"
                                        Text='<%# If(Eval("sub_inv_no").ToString() <> "", Eval("sub_inv_no"), Eval("invoice_no")) %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice Date">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtInvDate" runat="server" CssClass="form-control" TextMode="Date"
                                        Text='<%# Eval("invoice_date_iso") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice file (PDF)">
                                <ItemTemplate>
                                    <asp:FileUpload ID="fuInvoice" runat="server" CssClass="form-control" accept=".pdf,application/pdf" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hdnChallanNo" runat="server" Value='<%# Eval("challan_no") %>' />
                                    <asp:Button ID="btnSubmitInvoice" runat="server" CssClass="btn btn-success btn-sm" CommandName="SubmitInvoice"
                                        CommandArgument='<%# Container.DataItemIndex %>'
                                        Text='<%# If(Eval("sub_status").ToString() = "PENDING", "Replace", "Submit") %>'
                                        OnClientClick="return miuCheckRow(this);" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
