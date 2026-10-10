<%@ Page Title="User Form Access" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UsrFrmAccssNewMod.aspx.vb" Inherits="UsrFrmAccssNewMod" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">User Form Access</h3>
                <p class="pageSubTitle">Control which forms a user can open</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">User Group:</label>
                        <asp:DropDownList ID="ddlUsrGrp" CssClass="form-control select2" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">User ID:</label>
                        <asp:DropDownList ID="ddlUsrID" CssClass="form-control select2" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="mst-panel-header" style="padding: 10px 0px 0px 0px">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">User Form Access List</h5>
                        <p class="mst-panel-subtitle">Control which forms a user can open</p>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <table style="width: 100%; border: 0px; padding: 0px; margin: 0px;">
                            <tr>
                                <td style="text-align: center; width: 40%;">
                                    <h5 class="ufaafTx">Applicable Forms</h5>
                                </td>
                                <td style="text-align: center; width: 20%;"></td>
                                <td style="text-align: center; width: 40%;">
                                    <h5 class="ufaafTx">Available Forms</h5>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center; width: 40%;">
                                    <asp:ListBox ID="LstApplFrms" CssClass="form-control ufaafCtrl" SelectionMode="Multiple" Height="150px" runat="server"></asp:ListBox>
                                </td>
                                <td style="text-align: center; width: 20%;">
                                    <div>
                                        <asp:Button ID="btnRL" CssClass="btn btn-primary btn-sm" runat="server" Text="<<" />
                                        <asp:Button ID="btnLR" CssClass="btn btn-primary btn-sm" runat="server" Text=">>" />
                                    </div>
                                </td>
                                <td style="text-align: center; width: 40%;">
                                    <asp:ListBox ID="LstAvlbFrms" CssClass="form-control ufaafCtrl" SelectionMode="Multiple" Height="150px" runat="server"></asp:ListBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" runat="server" Text="Submit" />
                    <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" />
                    <asp:Button ID="btnReset" CssClass="btn btn-danger btn-sm" runat="server" Text="Reset" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
