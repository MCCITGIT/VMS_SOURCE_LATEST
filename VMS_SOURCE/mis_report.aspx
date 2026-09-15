<%@ Page Title="MIS Report" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="mis_report.aspx.vb" Inherits="mis_report" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%-- Modified-by MUKESH BHAGAT on 15-09-2026 : new page, copied down from vrs_legal_score.aspx's
         breadcrumb/card structure but with everything except Fin Year + Export removed - no
         Quarter, no Vendor, no on-screen grid. Export runs [dbo].[vrs_getvendor_score_report] for
         the selected Fin Year and streams the result straight to an .xlsx download
         (MisVendorScoreExcelExport.vb) - nothing is shown on the page itself. --%>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">MIS Report</h3>
                <p class="pageSubTitle">Vendor score report export</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row align-items-end">
                <div class="col-md-3">
                    <div class="form-group pb-0">
                        <label class="form-control-label">Fin Year:</label>
                        <asp:DropDownList ID="ddlFinYear" class="form-control select2" runat="server" />
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn btn-primary btn-sm" OnClick="btnExport_Click" />
                </div>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="color: red; font-weight: bold;"></asp:Label>
        </div>
    </div>

</asp:Content>
