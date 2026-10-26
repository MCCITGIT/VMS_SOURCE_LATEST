<%@ Page Title="Add Brand Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="AddBrandMaster.aspx.vb" Inherits="AddBrandMaster" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/add-brand-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    // button Add (F7 keypress)
                    validateSKUList();
                }
                //__doPostBack(document.getElementById('btnSubmit').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateAddUpdateBrandMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>

    <div class="rm-module rm-compact abm-page">

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Add Brand Master</h3>
                <p class="pageSubTitle">Create and update brand records</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="rm-add-form">
                <div class="form-group mb-0">
                    <label class="form-control-label">Brand Name:<span id="Span12" class="mandatory">*</span></label>
                    <div class="rm-add-form-controls">
                        <asp:TextBox ID="txtBrandName" ClientIDMode="Static" class="form-control" runat="server" AutoComplete="Off" Placeholder="Enter Here"></asp:TextBox>
                        <asp:HiddenField ID="txtBrandId" ClientIDMode="Static" runat="server" />
                        <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-danger btn-sm" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />
                    </div>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="card rm-list-fill">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-tags"></i></span>
                <div>
                    <h5 class="mst-panel-title">Brand List</h5>
                    <p class="mst-panel-subtitle">All brands currently available</p>
                </div>
            </div>
        </div>
        <div class="card-body abm-panel-body">
            <div class="abm-card-wrap">
                <asp:GridView BorderWidth="0" CssClass="gv-cards" CellSpacing="0" CellPadding="0" ID="gvbrandDetails" runat="server" AutoGenerateColumns="false" AllowPaging="false" Visible="true" ShowFooter="true" ShowHeader="false" GridLines="None">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <span class="abm-serial">
                                    <%--<span class="abm-serial-icon" aria-hidden="true"><i class="fas fa-tag"></i></span>--%>
                                    <span class="abm-serial-label">SlNo.:</span>
                                    <span class="abm-serial-num">
                                        <asp:Label ID="lblbrandid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </span>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Brand Name" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <span class="abm-brand">
                                    <span class="abm-brand-kicker">Brand Name</span>
                                    <span class="abm-brand-name">
                                        <asp:Label ID="lblbrandname" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label>
                                    </span>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="true">
                            <ItemTemplate>
                                <span class="abm-card-action">
                                    <asp:Button ID="btnEditRow" CommandName="EditRow" Visible="true" runat="server" CssClass="btn btn-outline-primary gridBtn" Text="Edit" title="Edit" ToolTip="Click To Edit" CommandArgument='<%# Bind("brand_id")%>'></asp:Button>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    </div>
</asp:Content>
