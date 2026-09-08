<%@ Page Title="FG Quality list" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="vrs_FGQualityList.aspx.vb" Inherits="vrs_FGQualityList" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateLegalScore.js"></script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Deviations in FG quality List</h3>
                <p class="pageSubTitle">Browse finished goods quality deviations</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row" style="flex-wrap: nowrap;">
                <div class="col-md-2">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel6">
                            <ContentTemplate>
                                <label class="form-control-label">Fin Year:</label>
                                <asp:DropDownList ID="ddlFinYear" class="form-control form-control-sm select2" runat="server" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" AutoPostBack="true" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel4">
                            <ContentTemplate>
                                <label class="form-control-label">Quarter:</label>
                                <asp:DropDownList ID="ddlQuarter" class="form-control form-control-sm select2" runat="server" OnSelectedIndexChanged="ddlQuarter_SelectedIndexChanged" AutoPostBack="true" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel5">
                            <ContentTemplate>
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlVendor" class="form-control form-control-sm select2" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" runat="server" AutoPostBack="true" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                            <ContentTemplate>
                                <label class="form-control-label">Brand:</label>
                                <asp:DropDownList ID="ddlBrand" class="form-control form-control-sm select2" runat="server" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>

                <div class="col-md-4 form-btn-mt">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                        <ContentTemplate>
                            <asp:Button ID="btnUpload" runat="server" ToolTip="Click to Upload File" Text="Upload" CssClass="btn btn-primary btn-sm" Visible="false" />
                            <asp:Button ID="imgbtnAdd" runat="server" ToolTip="Click to Download File" Text="Download" CssClass="btn btn-success btn-sm" Visible="false" />
                            <asp:Button ID="btnSearch" runat="server" ToolTip="Click to Search" Text="Search" OnClick="btnSearch_Click" CssClass="btn btn-primary btn-sm" />&nbsp;
                                   
                                    <asp:Button ID="btnReset" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />&nbsp;
                                     <asp:Button ID="btnExport" runat="server" ToolTip="Click to Export" Text="Export" OnClick="btnExport_Click" CssClass="btn btn-success btn-sm" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnExport" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Deviations in FG quality List</h5>
                    <p class="mst-panel-subtitle">Browse finished goods quality deviations</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <%-- Modified-by MUKESH BHAGAT on 08-09-2026 : table-responsive gives the grid the
                                 440px scroll box (upgrad-style.css) so the sticky headerGrid row stays pinned. --%>
                            <div class="table-responsive">
                            <asp:GridView ID="gvTesthdrList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                AllowPaging="true" PageSize="20" CssClass="upgradDataGrid m-0" CellSpacing="0" CellPadding="0" OnPageIndexChanging="gvTesthdrList_PageIndexChanging" OnRowCommand="gvTesthdrList_RowCommand">
                                <RowStyle CssClass="tlrowlight" />
                                <SelectedRowStyle />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>

                                    <asp:TemplateField HeaderText="Vendor">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTestName" Text='<%# Bind("vq_vendorname") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnVendorId" Value='<%# Bind("vq_vendorid") %>' />
                                            <asp:HiddenField runat="server" ID="hdnBrandid" Value='<%# Bind("vq_brand_id") %>' />

                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="30%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Brand">
                                        <ItemTemplate>
                                            <asp:Label ID="lblbrand" Text='<%# Bind("vq_brandname")%>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="20%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product">
                                        <ItemTemplate>
                                            <asp:Label ID="lblproduct" Text='<%# Bind("vq_product_code")%>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU">
                                        <ItemTemplate>
                                            <asp:Label ID="lblsku" Text='<%# Bind("vq_sku_code")%>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Score">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTotal_score" Text='<%# Bind("vq_total_score")%>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Obtain Score">
                                        <ItemTemplate>
                                            <asp:Label ID="lblobtainscore" Text='<%# Bind("vq_obtain_score")%>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <%--<asp:Button ID="btnView" runat="server" CommandName="ViewProductDetails" CommandArgument='<%# Eval("vq_vendorid") & "|" & Eval("vq_brand_id") & "|" & Eval("vq_quarter") & "|" & Eval("vq_product_code") & "|" & Eval("vq_sku_code") %>'
                                                Text="View" CssClass="btn btn-info btn-sm tableBtnXs" />--%>
                                                    <asp:LinkButton ID="btnView" runat="server" Visible="true"  CommandName="ViewProductDetails" CommandArgument='<%# Eval("vq_vendorid") & "|" & Eval("vq_brand_id") & "|" & Eval("vq_quarter") & "|" & Eval("vq_product_code") & "|" & Eval("vq_sku_code") %>' ToolTip="View History"><i class="fa fa-eye"></i></asp:LinkButton>
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <%--<asp:AsyncPostBackTrigger ControlID="btnUpload" EventName="Click" />--%>
                            <asp:PostBackTrigger ControlID="gvTesthdrList" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-md-12 text-center">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel9">
                        <ContentTemplate>
                            <asp:HiddenField ID="hdnId" runat="server" />
                            <asp:Button ID="btnCancel" runat="server" Text="Back" OnClick="btnCancel_Click" CssClass="btn btn-secondary btn-sm" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:UpdatePanel runat="server" ID="UpdatePanel10">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
