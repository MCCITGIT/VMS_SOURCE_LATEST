<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeFile="RMSupplierMaster.aspx.vb" Inherits="RMSupplierMaster" %>

<%@ Register TagPrefix="uc1" TagName="Footer" Src="includes/Footer.ascx" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/rm-supplier-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Scripts/ValidateAddUpdateBrandMaster.js"></script>
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

    <%--asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>

    <div class="rm-module rm-compact rsm-page">

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Supplier Master</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="rm-add-form">
                <div class="form-group mb-0">
                    <label class="form-control-label">Supplier Name:<span id="Span12" class="mandatory">*</span></label>
                    <div class="rm-add-form-controls">
                        <asp:TextBox ID="txtSupplier" class="form-control form-control-sm" runat="server"></asp:TextBox>
                        <asp:HiddenField ID="hdnSupplierid" runat="server" />
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-sm" OnClick="btnCancel_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" />
                    </div>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="card rm-list-fill">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-truck"></i></span>
                <div>
                    <h5 class="mst-panel-title">Supplier List</h5>
                    <p class="mst-panel-subtitle">All suppliers currently available</p>
                </div>
            </div>
        </div>
        <div class="card-body rsm-panel-body">
            <div class="rsm-card-wrap">
                <asp:GridView CssClass="gv-cards" ID="gvSupplierList" runat="server"
                    AutoGenerateColumns="false" AllowPaging="false" Visible="true" ShowFooter="true" ShowHeader="false"
                    GridLines="None" BorderWidth="0" CellSpacing="0" CellPadding="0" OnRowCommand="gvSupplierList_RowCommand">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <span class="rsm-serial">
                                    <%--<span class="rsm-serial-icon" aria-hidden="true"><i class="fas fa-industry"></i></span>--%>
                                    <span class="rsm-serial-label">SlNo</span>
                                    <span class="rsm-serial-num">
                                        <asp:Label ID="lblbrandid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </span>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supplier Name" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <span class="rsm-name">
                                    <span class="rsm-name-kicker">Supplier Name</span>
                                    <span class="rsm-name-value">
                                        <asp:Label ID="lblSuppliername" runat="server" Text='<%# Bind("supplier_name") %>'></asp:Label>
                                    </span>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="true">
                            <ItemTemplate>
                                <span class="rsm-card-action">
                                    <asp:Button ID="btnEditRow" CommandName="EditRow" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="Edit" title="Edit" ToolTip="Click To Edit" CommandArgument='<%# Bind("supplier_id")%>'></asp:Button>
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
