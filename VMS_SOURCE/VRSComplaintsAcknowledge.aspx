<%@ Page Title="Vendor Audit Entry" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VRSComplaintsAcknowledge.aspx.vb" Inherits="VRSComplaintsAcknowledge" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Cpmplaints Score</h3>
                <p class="pageSubTitle">Acknowledge complaint scores raised against vendors</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Fin Year:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel5">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlFinYear" class="form-control form-control-sm select2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Quarter:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlQuarter" class="form-control form-control-sm select2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlQuarter_SelectedIndexChanged" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel4">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendor" class="form-control form-control-sm select2" runat="server" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-4 form-btn-mt">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                        <ContentTemplate>
                            <asp:Button ID="btnSearch" runat="server" ToolTip="Click to Search" Text="Search" CssClass="btn btn-primary btn-sm" />&nbsp;
                                    <asp:Button ID="btnReset" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />
                            <asp:Button ID="btnExport" runat="server" ToolTip="Click to Export" Text="Export" CssClass="btn btn-success btn-sm" OnClick="btnExport_Click" />
                        </ContentTemplate>
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
                    <h5 class="mst-panel-title">Vendor Cpmplaints Score</h5>
                    <p class="mst-panel-subtitle">Acknowledge complaint scores raised against vendors</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div style="max-height: 300px; overflow-y: auto;">
                                <asp:GridView ID="gvAuditList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0"
                                    CellSpacing="0" CellPadding="0" OnRowCommand="gvAuditList_RowCommand" OnRowDataBound="gvAuditList_RowDataBound">
                                    <RowStyle CssClass="tlrowlight" />
                                    <SelectedRowStyle />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Unit code">
                                            <ItemTemplate>
                                                <asp:Label ID="lblParameterType" Text='<%# Bind("unit_code")%>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnUnit" Value='<%# Bind("unit_code") %>' />
                                                <asp:HiddenField runat="server" ID="hdnQuarter" Value='<%# Bind("vch_quarter_id") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Unit Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblParameterName" Text='<%# Bind("unit_name")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" Width="30%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Total Volume">
                                            <ItemTemplate>
                                                <asp:Label ID="lblavg_vol" Text='<%# Bind("vcd_monthly_avg_vol")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Total Complaints">
                                            <ItemTemplate>
                                                <asp:Label ID="lblvcd_total_complaints" Text='<%# Bind("vcd_total_complaints")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Justified Complaints">
                                            <ItemTemplate>
                                                <asp:Label ID="lblvcd_total_justified_complaints" Text='<%# Bind("vcd_total_justified_complaints")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Complaints Tendency Ratio">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTendencyRatio" Text='<%# Bind("vch_complaint_tendency_ratio")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Max Score">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMaxScore" Text='<%# Bind("vch_total_max_score")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Obtained Score">
                                            <ItemTemplate>
                                                <asp:Label ID="lblvch_total_obtain_score" Text='<%# Bind("vch_total_obtain_score")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <div style="white-space: nowrap;">
                                                    <asp:UpdatePanel runat="server">
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="btnView" runat="server" Text="View" CommandName="ViewDetails" CssClass="btn btn-success btn-sm" Style="padding: 2px 8px; font-size: 12px;" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        </asp:TemplateField>
                                    </Columns>

                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="gvAuditList" />
                            <%--<asp:PostBackTrigger ControlID="btnSubmit" />--%>
                            <asp:PostBackTrigger ControlID="btnSearch" />
                            <asp:PostBackTrigger ControlID="btnExport" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-md-12 text-center">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel9">
                        <ContentTemplate>
                            <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm ml-2" OnClick="btnBack_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>

        <asp:UpdatePanel runat="server" ID="UpdatePanel10">
            <ContentTemplate>
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <%--Complaints Details Popup--%>

    <asp:HiddenField ID="HiddenField3" runat="server" />
    <asp:ModalPopupExtender ID="mpComplaints" runat="server"
        PopupControlID="Panel4" TargetControlID="HiddenField3">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel4" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Complaints Details</h5>
                <asp:Button ID="btnComplaintsClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnComplaintsClosePopup_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvComplaintsDtls" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="SKU Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_sku_code" Text='<%# Bind("vc_sku_code") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SKU Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblsku" Text='<%# Bind("sku") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Complaints Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_complaints_id" Text='<%# Bind("vc_complaints_id") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Complaints Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_complaints_date" Text='<%# Bind("vc_complaints_date") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remarks">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_remarks" Text='<%# Bind("vc_remarks") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_status" Text='<%# Bind("vc_status") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Settle Remarks">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_settleRemarks" Text='<%# Bind("vc_settleRemarks") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Settle Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvc_settle_date" Text='<%# Bind("vc_settle_date") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Complaints Details Popup--%>
</asp:Content>
