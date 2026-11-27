<%@ Page Title="GRN Upload" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="GrnUpload.aspx.vb" Inherits="GrnUpload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%-- Added by MUKESH BHAGAT on 04-11-2026 : HO uploads GRN No / GRN Date (Excel) for despatch releases that have no GRN number yet. --%>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">GRN Upload</h3>
                <p class="pageSubTitle">Make "GRN not done" releases "GRN done" by uploading GRN No and GRN Date</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-2" EnableViewState="false"></asp:Label>

    <asp:Panel ID="pnlMain" runat="server">

        <div class="card">
            <div class="card-header"><strong>Step 1 - Download the template</strong>
                <span class="text-muted">&nbsp;every release that has no GRN number yet (leave the filters empty for all)</span></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Depot:</label>
                            <asp:DropDownList ID="ddlDepot" runat="server" CssClass="form-control select2"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">Release from:</label>
                            <asp:TextBox ID="txtFromDate" CssClass="form-control" runat="server" MaxLength="10" placeholder="dd/mm/yyyy"></asp:TextBox>
                            <asp:CalendarExtender ID="ceFrom" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy" />
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">Release to:</label>
                            <asp:TextBox ID="txtToDate" CssClass="form-control" runat="server" MaxLength="10" placeholder="dd/mm/yyyy"></asp:TextBox>
                            <asp:CalendarExtender ID="ceTo" runat="server" TargetControlID="txtToDate" Format="dd/MM/yyyy" />
                        </div>
                    </div>
                    <div class="col-md-1 form-btn-mt">
                        <div class="form-group">
                            <asp:LinkButton ID="btnTemplate" runat="server" CssClass="btn btn-success btn-sm" Text="Download" ToolTip="Download the Excel template" />
                        </div>
                    </div>
                </div>
                <asp:Label ID="lblPendingCount" runat="server" CssClass="text-muted" EnableViewState="false"></asp:Label>
            </div>
        </div>

        <div class="card">
            <div class="card-header"><strong>Step 2 - Fill GRN No and GRN Date, then upload</strong>
                <span class="text-muted">&nbsp;only the last two columns; do not change the first column (Row Key)</span></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <asp:FileUpload ID="fuExcel" runat="server" CssClass="form-control" accept=".xlsx,.xls" />
                    </div>
                    <div class="col-md-3">
                        <asp:LinkButton ID="btnCheck" runat="server" CssClass="btn btn-primary btn-sm" Text="Check file" ToolTip="Checks every row, nothing is saved yet" />
                    </div>
                </div>
                <ul class="mt-2 mb-0 text-muted small">
                    <li>GRN Date as dd/mm/yyyy; it cannot be in the future or before the release date.</li>
                    <li>Rows where both GRN No and GRN Date are left blank are ignored.</li>
                    <li>A row that already has a GRN, has only one of the two filled, or repeats a Row Key is rejected; the other rows are still saved.</li>
                    <li>"Check file" saves nothing. Only "Confirm and save" updates the GRN data, and every change is logged.</li>
                </ul>
            </div>
        </div>

        <asp:Panel ID="pnlResult" runat="server" Visible="false">
            <div class="card">
                <div class="card-header"><strong>Step 3 - Result</strong></div>
                <div class="card-body">
                    <asp:Label ID="lblSummary" runat="server" CssClass="d-block mb-2 font-weight-bold"></asp:Label>
                    <div class="mb-2">
                        <asp:LinkButton ID="btnConfirm" runat="server" CssClass="btn btn-success btn-sm" Text="Confirm and save" Visible="false"
                            OnClientClick="return confirm('Save the GRN No and GRN Date of all checked rows? This updates the GRN data.');" />
                        <asp:LinkButton ID="btnDownloadResult" runat="server" CssClass="btn btn-secondary btn-sm" Text="Download result" />
                    </div>
                    <div class="table-responsive rm-grid-scroll" style="max-height: 420px; overflow: auto;">
                        <asp:GridView ID="gvResult" runat="server" AutoGenerateColumns="false" CssClass="table table-hover upgradDataGrid" EmptyDataText="No rows">
                            <RowStyle CssClass="tlrowlight" />
                            <HeaderStyle CssClass="headerGrid" />
                            <Columns>
                                <asp:BoundField HeaderText="Excel row" DataField="row_no" />
                                <asp:BoundField HeaderText="Row Key" DataField="vdr_id" />
                                <asp:BoundField HeaderText="GRN No" DataField="grn_no" />
                                <asp:BoundField HeaderText="GRN Date" DataField="grn_date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField HeaderText="Result" DataField="result" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <asp:Label ID="lblGridNote" runat="server" CssClass="text-muted small" EnableViewState="false"></asp:Label>
                </div>
            </div>
        </asp:Panel>

    </asp:Panel>
</asp:Content>
