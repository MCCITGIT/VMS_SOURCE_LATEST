<%@ Page Title="Review Missing Invoice" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="MissingInvoiceReview.aspx.vb" Inherits="MissingInvoiceReview" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- Author: MUKESH BHAGAT, 13-11-2026.
         Head office page. Lists the invoices that vendors uploaded for challans that were saved without one
         (table challan_invoice_resubmit). The invoice no / date entered by the vendor is shown beside the values saved on the
         challan with a Match / Differs flag. Every upload is mapped (attached to the challan) or rejected BY HAND - nothing is
         attached automatically. --%>
    <script type="text/javascript">
        function mirConfirmMap(differs) {
            return confirm(differs
                ? 'The invoice no or date entered by the vendor DIFFERS from the challan. Open the PDF and check it first.\n\nAttach this invoice to the challan anyway?'
                : 'Attach this invoice to the challan?');
        }
        function mirCheckReject(btn) {
            var tr = btn.closest('tr');
            var r = tr.querySelector('input[id$="txtReason"]');
            if (!r || !r.value.trim()) { alert('Please type the reason for rejecting.'); if (r) r.focus(); return false; }
            return confirm('Reject this upload? The vendor will see the reason and can upload again.');
        }
    </script>

    <div class="container-fluid">
        <div class="card">
            <div class="card-header"><strong>Review Missing Invoice</strong></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Status:</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Value="PENDING" Text="Pending review" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="MAPPED" Text="Mapped"></asp:ListItem>
                                <asp:ListItem Value="REJECTED" Text="Rejected"></asp:ListItem>
                                <asp:ListItem Value="REPLACED" Text="Replaced by a newer upload"></asp:ListItem>
                                <asp:ListItem Value="ALL" Text="All"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Vendor unit code:</label>
                            <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" MaxLength="50" placeholder="e.g. V69 (leave blank for all)"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <div class="form-group">
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm" Text="Search" />
                        </div>
                    </div>
                </div>
                <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>

                <div class="table-responsive">
                    <asp:GridView ID="gvReview" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm"
                        EmptyDataText="Nothing to show for this filter.">
                        <Columns>
                            <asp:TemplateField HeaderText="Vendor">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hdnCirId" runat="server" Value='<%# Eval("cir_id") %>' />
                                    <%# Server.HtmlEncode(Eval("unit_code").ToString()) %> - <%# Server.HtmlEncode(Eval("unit_name").ToString()) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="challan_no" HeaderText="Challan No" />
                            <asp:BoundField DataField="challan_date" HeaderText="Challan Date" />
                            <asp:BoundField DataField="challan_inv_no" HeaderText="Invoice No on challan" />
                            <asp:BoundField DataField="challan_inv_date" HeaderText="Invoice Date on challan" />
                            <asp:BoundField DataField="challan_inv_value" HeaderText="Invoice Value" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="sub_inv_no" HeaderText="Invoice No entered by vendor" />
                            <asp:BoundField DataField="sub_inv_date" HeaderText="Invoice Date entered by vendor" />
                            <asp:TemplateField HeaderText="Match">
                                <ItemTemplate>
                                    No: <b style='color:<%# If(Eval("no_match").ToString() = "Y", "green", "red") %>'><%# If(Eval("no_match").ToString() = "Y", "Match", "Differs") %></b><br />
                                    Date: <b style='color:<%# If(Eval("date_match").ToString() = "Y", "green", "red") %>'><%# If(Eval("date_match").ToString() = "Y", "Match", "Differs") %></b>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="File">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkView" runat="server" CommandName="ViewFile" CommandArgument='<%# Container.DataItemIndex %>'
                                        Text='<%# Server.HtmlEncode(If(Eval("org_filename").ToString() <> "", Eval("org_filename").ToString(), Eval("file_name").ToString())) %>'></asp:LinkButton>
                                    <asp:HiddenField ID="hdnPath" runat="server" Value='<%# Eval("doc_path") %>' />
                                    <asp:HiddenField ID="hdnFile" runat="server" Value='<%# Eval("file_name") %>' />
                                    <asp:HiddenField ID="hdnStatus" runat="server" Value='<%# Eval("status") %>' />
                                    <asp:HiddenField ID="hdnDiffers" runat="server" Value='<%# If(Eval("no_match").ToString() = "Y" AndAlso Eval("date_match").ToString() = "Y", "N", "Y") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Uploaded">
                                <ItemTemplate><%# Server.HtmlEncode(Eval("uploaded_by").ToString()) %><br /><%# Eval("uploaded_on") %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status / Review">
                                <ItemTemplate>
                                    <b><%# Eval("status") %></b>
                                    <%# If(Eval("challan_has_doc").ToString() = "Y" AndAlso Eval("status").ToString() = "PENDING", "<br /><span style='color:red'>Challan already has an invoice copy</span>", "") %>
                                    <%# If(Eval("reviewed_by").ToString() <> "", "<br />" & Server.HtmlEncode(Eval("reviewed_by").ToString()) & " " & Eval("reviewed_on").ToString(), "") %>
                                    <%# If(Eval("remarks").ToString() <> "", "<br />" & Server.HtmlEncode(Eval("remarks").ToString()), "") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Panel ID="pnlActions" runat="server" Visible='<%# Eval("status").ToString() = "PENDING" %>'>
                                        <asp:Button ID="btnMap" runat="server" CssClass="btn btn-success btn-sm" Text="Map to challan" CommandName="MapUpload"
                                            CommandArgument='<%# Container.DataItemIndex %>'
                                            OnClientClick='<%# "return mirConfirmMap(" & If(Eval("no_match").ToString() = "Y" AndAlso Eval("date_match").ToString() = "Y", "false", "true") & ");" %>' />
                                        <br />
                                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" MaxLength="450" placeholder="Reason for rejecting"></asp:TextBox>
                                        <asp:Button ID="btnReject" runat="server" CssClass="btn btn-danger btn-sm" Text="Reject" CommandName="RejectUpload"
                                            CommandArgument='<%# Container.DataItemIndex %>' OnClientClick="return mirCheckReject(this);" />
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
