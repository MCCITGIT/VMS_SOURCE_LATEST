<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeFile="QC_ChemicalMaster.aspx.vb" Inherits="QC_ChemicalMaster" %>

<%@ Register TagPrefix="uc1" TagName="Footer" Src="includes/Footer.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/qc-chemical-master-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />

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

    <div class="rm-module rm-compact qcm-page">

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Chemical Master</h3>
                    <p class="pageSubTitle">Create and update chemical records</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="rm-add-form">
                    <div class="form-group mb-0">
                        <label class="form-control-label">Chemical Name:<span id="Span12" class="mandatory">*</span></label>
                        <div class="rm-add-form-controls">
                            <asp:TextBox ID="txtChemicalName" class="form-control form-control-sm" runat="server"></asp:TextBox>
                            <asp:HiddenField ID="hdnChemicalid" runat="server" />
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
                    <span class="mst-panel-icon"><i class="fas fa-flask"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Chemical List</h5>
                        <p class="mst-panel-subtitle">All chemicals currently available</p>
                    </div>
                </div>
            </div>
            <div class="card-body qcm-panel-body">
                <div class="qcm-card-wrap">
                    <asp:GridView CssClass="gv-cards" BorderWidth="0" CellSpacing="0" CellPadding="0" ID="gvChemicalList" runat="server"
                        AutoGenerateColumns="false" AllowPaging="false" Visible="true" ShowFooter="true" ShowHeader="false" GridLines="None" OnRowCommand="gvChemicalList_RowCommand">
                        <RowStyle CssClass="tlrowlight" />
                        <SelectedRowStyle />
                        <AlternatingRowStyle CssClass="tlrowdark" />
                        <PagerStyle HorizontalAlign="Center" />
                        <HeaderStyle CssClass="headerGrid" HorizontalAlign="Center" />
                        <FooterStyle CssClass="footerGrid" HorizontalAlign="Center" />
                        <Columns>
                            <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <span class="qcm-serial">
                                        <%--<span class="qcm-serial-icon" aria-hidden="true"><i class="fas fa-flask"></i></span>--%>
                                        <span class="qcm-serial-num">
                                            <asp:Label ID="lblbrandid" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        </span>
                                        <span class="qcm-serial-label">SlNo</span>

                                    </span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Brand Name" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <span class="qcm-chem">
                                        <span class="qcm-chem-kicker">Brand Name</span>
                                        <span class="qcm-chem-value">
                                            <asp:Label ID="lblbrandname" runat="server" Text='<%# Bind("chemical_name") %>'></asp:Label>
                                        </span>
                                    </span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" Visible="true">
                                <ItemTemplate>
                                    <span class="qcm-card-action">
                                        <asp:Button ID="btnEditRow" CommandName="EditRow" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="Edit" title="Edit" ToolTip="Click To Edit" CommandArgument='<%# Bind("chemical_id")%>'></asp:Button>
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
