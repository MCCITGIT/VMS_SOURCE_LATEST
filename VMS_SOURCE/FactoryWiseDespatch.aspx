<%@ Page Title="Vendor Wise Unit Despatch" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FactoryWiseDespatch.aspx.vb" Inherits="FactoryWiseDespatch" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Wise Unit Despatch</h3>
                <p class="pageSubTitle">Despatches by vendor and source unit</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Region:</label>
                        <asp:DropDownList ID="ddlRegion" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRegion_SelectedIndexChanged" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddlDepot" CssClass="form-control" runat="server" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Factory:</label>
                        <asp:DropDownList ID="ddlUnit" CssClass="form-control" runat="server" />
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Year: <strong style="color: red;">*</strong></label>
                        <asp:DropDownList ID="ddlProcessYr" CssClass="form-control" runat="server"></asp:DropDownList>
                        <%--<asp:TextBox ID="txtfromDate" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>--%>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Month: <strong style="color: red;">*</strong></label>
                        <asp:DropDownList ID="ddlProcessMnth" CssClass="form-control" runat="server">
                            <asp:ListItem Value="01">January</asp:ListItem>
                            <asp:ListItem Value="02">February</asp:ListItem>
                            <asp:ListItem Value="03">March</asp:ListItem>
                            <asp:ListItem Value="04">April</asp:ListItem>
                            <asp:ListItem Value="05">May</asp:ListItem>
                            <asp:ListItem Value="06">Jun</asp:ListItem>
                            <asp:ListItem Value="07">July</asp:ListItem>
                            <asp:ListItem Value="08">August</asp:ListItem>
                            <asp:ListItem Value="09">September</asp:ListItem>
                            <asp:ListItem Value="10">October</asp:ListItem>
                            <asp:ListItem Value="11">November</asp:ListItem>
                            <asp:ListItem Value="12">December</asp:ListItem>
                        </asp:DropDownList>
                        <%--<asp:TextBox ID="txtToDate" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>--%>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Product Category:</label>
                        <asp:DropDownList ID="ddlproductcat" CssClass="form-control" runat="server" />
                    </div>
                </div>
                <div class="col-md-3" style="display: none;">
                    <div class="form-group">
                        <label class="form-control-label">Products:</label>
                        <asp:DropDownList ID="ddlproductcode" CssClass="form-control" runat="server" />
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <asp:Button ID="btndownload" runat="server" CssClass="btn btn-primary btn-sm" ToolTip="Download" OnClick="btndownload_Click" Text="Download" />
                    <%--<asp:Button ID="imgbtnExport" runat="server" Text="Export" CssClass="btn btn-success btn-sm" />--%>
                    <%--<asp:Button ID="imgbtnAdd" runat="server" Text="Add" CssClass="btn btn-success btn-sm" />--%>
                </div>
            </div>
            <asp:Label ID="lblErrMsg" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
