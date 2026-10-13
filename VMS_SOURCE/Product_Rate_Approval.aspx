<%@ Page Title="Product Rate Approval History" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Rate_Approval.aspx.vb" Inherits="Product_Rate_Approval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .pra-kv { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 8px 16px; font-size: 12.5px; }
        .pra-kv b { color: #375973; }
        .pra-badge { display: inline-block; padding: 1px 8px; border-radius: 10px; font-size: 11px; font-weight: 600; color: #fff; white-space: nowrap; }
        .pra-APPROVED { background: #28a745; } .pra-INACTIVE { background: #6c757d; } .pra-PENDING { background: #e0a800; }
        .pra-REJECTED { background: #dc3545; } .pra-SUPERSEDED { background: #adb5bd; } .pra-PENDING_VENDOR { background: #17a2b8; }
        .pra-row-active td { background: #eaf7ee !important; }
        .pra-small { font-size: 11px; color: #666; }
        .pra-rm { font-size: 11.5px; }
        .pra-remarks { font-size: 11.5px; color: #721c24; }

        /* side-by-side comparison matrix */
        .pra-wrap { overflow-x: auto; }
        .pra-matrix { border-collapse: separate; border-spacing: 0; font-size: 12px; min-width: 100%; }
        .pra-matrix th, .pra-matrix td { border: 1px solid #d9dee3; padding: 5px 8px; vertical-align: top; white-space: nowrap; }
        .pra-matrix thead th { background: #375973; color: #fff; font-weight: 600; text-align: center; vertical-align: middle; }
        .pra-matrix thead th.pra-col-active { background: #1e7e34; }
        .pra-matrix thead th.pra-col-rejected { background: #a71d2a; }
        .pra-matrix thead th.pra-col-superseded { background: #7d868e; }
        .pra-matrix thead th.pra-col-pending { background: #c69500; }
        .pra-matrix thead th.pra-col-pending_vendor { background: #117a8b; }
        .pra-matrix thead th.pra-col-inactive { background: #5a6268; }
        .pra-matrix th.pra-rowhead, .pra-matrix td.pra-rowhead { position: sticky; left: 0; background: #f4f6f8; text-align: left; font-weight: 600; color: #375973; min-width: 220px; white-space: normal; z-index: 1; }
        .pra-matrix td.pra-val { text-align: right; }
        .pra-matrix td.pra-up { background: #fde8e8; color: #9b1c1c; }       /* price went up vs previous column */
        .pra-matrix td.pra-down { background: #e6f6ea; color: #136f2d; }     /* price went down */
        .pra-matrix td.pra-new { background: #fff3cd; }                      /* raw material / pack added */
        .pra-matrix td.pra-gone { background: #f1f3f5; color: #adb5bd; text-align: center; }
        .pra-matrix tr.pra-total td { background: #eaf0f4; font-weight: 700; }
        .pra-matrix tr.pra-section td { background: #dde7ee; font-weight: 700; color: #375973; text-align: left; }
        .pra-hdr-sub { font-size: 10.5px; font-weight: 400; opacity: .9; display: block; }
        .pra-legend { font-size: 11px; color: #555; margin-top: 6px; }
        .pra-legend span { display: inline-block; padding: 1px 8px; margin-right: 6px; border: 1px solid #d9dee3; }
    </style>

    <div class="rm-module">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Product Rate Approval - History</h3>
                    <p class="pageSubTitle">Every negotiation revision and approved release of one SKU formulation</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-flask"></i></span>
                    <div>
                        <h5 class="mst-panel-title"><asp:Literal ID="litSku" runat="server"></asp:Literal></h5>
                        <p class="mst-panel-subtitle"><asp:Literal ID="litActive" runat="server"></asp:Literal></p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="pra-kv">
                    <div><b>Brand:</b> <asp:Literal ID="litBrand" runat="server"></asp:Literal></div>
                    <div><b>Vendor:</b> <asp:Literal ID="litVendor" runat="server"></asp:Literal></div>
                    <div><b>Approved releases:</b> <asp:Literal ID="litReleases" runat="server"></asp:Literal></div>
                    <div><b>Total revisions:</b> <asp:Literal ID="litRows" runat="server"></asp:Literal></div>
                </div>
                <asp:Label ID="lblErrorMessage" runat="server" CssClass="errormsg" Style="font-size: 11px; font-weight: bold;"></asp:Label>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-columns"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Rate comparison - every revision side by side (oldest to newest)</h5>
                        <p class="mst-panel-subtitle">Each column is one submission. A cell shows ratio % @ price per raw material; colour = change against the previous column.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="pra-wrap"><asp:Literal ID="litMatrix" runat="server"></asp:Literal></div>
                <div class="pra-legend">
                    <span class="pra-up" style="background:#fde8e8;">price up</span><span style="background:#e6f6ea;">price down</span><span style="background:#fff3cd;">added</span><span style="background:#f1f3f5;color:#adb5bd;">removed</span>
                    Hover a column header for the remarks of that submission.
                </div>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-history"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Timeline (newest first)</h5>
                        <p class="mst-panel-subtitle">Green row = release currently in force. Open any row to see its full formulation and packaging.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid" EmptyDataText="No records." GridLines="Both" OnRowDataBound="gvHistory_RowDataBound">
                        <RowStyle CssClass="tlrowlight" />
                        <HeaderStyle CssClass="headerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="Version">
                                <ItemTemplate><b><%# Eval("version_text") %></b></ItemTemplate>
                                <ItemStyle Width="13%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate><span class='pra-badge pra-<%# Eval("sf_status") %>'><%# Eval("sf_status") %></span></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="8%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SKU price (&#8377;)">
                                <ItemTemplate><%# String.Format("{0:0.00}", Eval("sf_sku_price")) %></ItemTemplate>
                                <ItemStyle HorizontalAlign="Right" Width="7%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Raw materials (ratio @ price) / Packs">
                                <ItemTemplate>
                                    <div class="pra-rm"><%# Eval("rawmat_summary") %></div>
                                    <div class="pra-small"><%# Eval("pack_summary") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Submitted">
                                <ItemTemplate><%# Eval("submitted_by") %><br /><span class="pra-small"><%# String.Format("{0:dd/MM/yyyy HH:mm}", Eval("submitted_on")) %></span>
                                    <div class="pra-small"><%# Eval("vendor_remarks") %></div></ItemTemplate>
                                <ItemStyle Width="12%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HO decision">
                                <ItemTemplate><%# Eval("sf_approved_by") %><br /><span class="pra-small"><%# If(Eval("sf_approved_on") Is DBNull.Value, "", String.Format("{0:dd/MM/yyyy HH:mm}", Eval("sf_approved_on"))) %></span>
                                    <div class="pra-remarks"><%# Eval("sf_ho_remarks") %></div></ItemTemplate>
                                <ItemStyle Width="14%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="In force">
                                <ItemTemplate><span class="pra-small"><%# If(Eval("sf_release_no") Is DBNull.Value, "", String.Format("{0:dd/MM/yyyy}", Eval("sf_valid_from")) & " - " & If(Eval("sf_valid_to") Is DBNull.Value, "now", String.Format("{0:dd/MM/yyyy}", Eval("sf_valid_to")))) %></span></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="10%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Open">
                                <ItemTemplate><a href='Product_Formulation.aspx?id=<%# Eval("sf_id") %>' class="text-primary" title="Open this version"><i class="fa fa-eye"></i></a></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="5%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div style="text-align: center; margin-top: 10px;">
                    <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" OnClick="btnBack_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
