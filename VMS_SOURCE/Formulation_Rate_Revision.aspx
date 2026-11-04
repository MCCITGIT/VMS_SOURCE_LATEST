<%@ Page Title="Formulation Rate Revision" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Formulation_Rate_Revision.aspx.vb" Inherits="Formulation_Rate_Revision" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="rm-module rm-compact rsm-page">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Formulation Rate Revision</h3>
                    <p class="pageSubTitle">Manage formulation rates vendor wise</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-3" id="colVendorFilter" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Formulation:</label>
                            <asp:DropDownList ID="ddlFormulation" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFormulation_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-control-label">Raw Material List:</label>
                            <asp:ListBox ID="ddlRmList" ClientIDMode="Static" SelectionMode="Multiple" CssClass="form-control select2" data-placeholder="Select" runat="server"></asp:ListBox>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-control-label">Packaging List:</label>
                            <asp:ListBox ID="ddlPkgList" ClientIDMode="Static" SelectionMode="Multiple" CssClass="form-control select2" data-placeholder="Select" runat="server"></asp:ListBox>
                        </div>
                    </div>
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="btnApprove" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="btnApprove_Click" ToolTip="Let the vendor change the rates of the selected items"> Give permission
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-danger btn-sm" ClientIDMode="Static" ToolTip="Back" OnClick="btnBack_Click">Back
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

