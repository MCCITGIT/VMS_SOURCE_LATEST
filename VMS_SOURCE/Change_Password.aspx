<%@ Page Title="Change Password" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Change_Password.aspx.vb" Inherits="Change_Password" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidationFlashMaster.js"></script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Change Password</h3>
                <p class="pageSubTitle">Update your account password</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <%--Modified-by MUKESH BHAGAT on 20-08-2026 : restored from old UAT source--%>
            <asp:HiddenField ID="hdnOldPwd" runat="server" />
            <asp:HiddenField ID="hdnStatus" runat="server" />
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Old Password:<span class="mandatory" id="spanOldPwd">*</span></label>
                                <asp:TextBox ID="txtOldPwd" CssClass="form-control" TextMode="Password" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">New Password:<span class="mandatory" id="span1">*</span></label>
                                <asp:TextBox ID="txtNewPwd" CssClass="form-control" TextMode="Password" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Confirm Password:<span class="mandatory" id="span2">*</span></label>
                                <asp:TextBox ID="txtConPwd" CssClass="form-control" TextMode="Password" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-12 form-btn-mt text-center">
                            <div class="form-group">
                                <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" runat="server" Text="Submit" />
                                <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" />
                                <asp:Button ID="btnReset" CssClass="btn btn-danger btn-sm" runat="server" Text="Reset" />
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblPwdErrMsg" runat="server" CssClass="errormsg"></asp:Label>
                    <asp:Label ID="lblErrMsg" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
