<%@ Page Title="Vendor rating" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="vrs_Serviceability.aspx.vb" Inherits="vrs_Serviceability" %>

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
                <h3 class="pageTitle">Serviceability</h3>
                <p class="pageSubTitle">Vendor serviceability scores used in rating</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Quarter:</label>
                                <asp:DropDownList ID="ddlquartor" class="form-control select2" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Vendor:</label>
                                <asp:TextBox ID="txtVendorcode" runat="server" class="form-control" AutoComplete="off" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnsearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" />
                            <asp:Label ID="lblError" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>

            <div runat="server" id="divServiceability">
                <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                    <ContentTemplate>
                        <h6>Final Serviceability</h6>
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <asp:UpdatePanel runat="server">
                                            <ContentTemplate>
                                                <div class="table-responsive">
                                                    <asp:GridView ID="gvServiceAbility" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                                        AllowPaging="true" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                                        <RowStyle CssClass="tlrowlight" />
                                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                        <HeaderStyle CssClass="headerGrid" />
                                                        <FooterStyle CssClass="footerGrid" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSlno" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Product Code" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_ProductCode" runat="server" Text='<%# Bind("productcode") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Product Name" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_ProductName" runat="server" Text='<%# Bind("productname") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="30%" />
                                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="30%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Depot Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_depottotaldispatch" runat="server" Text='<%# Bind("depot_total_deptdispatch") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Pending Depot Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_pendingdepotdispatch" runat="server" Text='<%# Bind("depot_pending_dispatch") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Depot Serviceability" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_DepotServiceability" runat="server" Text='<%# Bind("depot_serviceabilty") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Direct Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_directtotaldispatch" runat="server" Text='<%# Bind("direct_total_deptdispatch") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Pending Direct Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_pendingdirectdispatch" runat="server" Text='<%# Bind("direct_pending_dispatch") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Direct Serviceability" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_DepotServiceability" runat="server" Text='<%# Bind("direct_serviceabilty") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Final Serviceability" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbl_FinalServiceability" runat="server" Text='<%# Bind("final_serviceablity") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                    <%-- <asp:HiddenField ID="hdnOk" runat="server" />
                                            <asp:ModalPopupExtender ID="mpStatutory" runat="server"
                                                PopupControlID="Panel1" TargetControlID="hdnOk">
                                            </asp:ModalPopupExtender>--%>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <%--  <div class="container" runat="server" id="divdircectdispatch">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                      <h6>Direct Dispatch</h6>
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                
                                <div class="col-md-12">
                                    <asp:UpdatePanel runat="server">
                                        <ContentTemplate>
                                            <%-- Modified-by MUKESH BHAGAT on 08-09-2026 : table-responsive gives the grid the
                                                 440px scroll box (upgrad-style.css) so the sticky headerGrid row stays pinned. --%>
                                            <div class="table-responsive">
                                            <asp:GridView ID="gvDirectDispatch" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                                AllowPaging="true" PageSize="20" CssClass="upgradDataGrid"  border="1" CellSpacing="0" CellPadding="0">
                                                <RowStyle CssClass="tlrowlight" Font-Strikeout="False"  />
                                                <SelectedRowStyle />
                                                <PagerStyle HorizontalAlign="Center" />
                                                <HeaderStyle CssClass="headerGrid" HorizontalAlign="Center" />
                                                <FooterStyle CssClass="footerGrid" HorizontalAlign="Center" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblSlno" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Product Code" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                             <asp:Label ID="lbl_ProductCode" runat="server" Text='<%# Bind("productcode") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Product Name" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbl_ProductName" runat="server" Text='<%# Bind("productname") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbl_totaldispatch" runat="server" Text='<%# Bind("total_deptdispatch") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Pending Dispatch" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbl_pendingdispatch" runat="server" Text='<%# Bind("pending_dispatch") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Serviceability" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbl_pendingdispatch" runat="server" Text='<%# Bind("serviceabilty") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                            </div>
                                          
                                           
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                               
                            </div>

                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>--%>

            <%--Statutory Details Popup--%>
            <%--  <asp:Panel ID="Panel1" runat="server" CssClass="modal-popup">
            <div class="modal-content-custom">
                <div class="modal-header-custom">
                    <h5>Statutory Details</h5>
                    <asp:Button ID="btnClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnClosePopup_Click" />
                </div>
                <div class="modal-body-custom">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <div class="row mb-1">
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Target Score:</label>
                                        <asp:TextBox ID="txttotalTargetScore" runat="server" class="form-control" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Obtain Score:</label>
                                        <asp:TextBox ID="txttotalObtainScore" runat="server" class="form-control" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Obtain Percentage:</label>
                                        <asp:TextBox ID="txttotalObtainPercentage" runat="server" class="form-control" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Obtain Weightage:</label>
                                        <asp:TextBox ID="txtWeightage" runat="server" class="form-control" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <hr />

                            <%-- Modified-by MUKESH BHAGAT on 08-09-2026 : this grid had neither the upgradDataGrid
                                 class nor a headerGrid header row, so the global sticky rule could not apply. Both
                                 added, plus the table-responsive scroll box, to freeze the header like the others. --%>
                            <div class="table-responsive">
                            <asp:GridView ID="gvStatutoryDetails" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-striped upgradDataGrid">
                                <HeaderStyle CssClass="headerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Slno." ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSlno" Text='<%# Bind("parameter_code") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="4%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Legal and Statutory Requirements Status" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblParameterName" Text='<%# Bind("parameter_name") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnParameterCode" Value='<%# Bind("parameter_code") %>' />
                                            <asp:HiddenField runat="server" ID="hdnParameterName" Value='<%# Bind("parameter_name") %>' />
                                            <asp:HiddenField runat="server" ID="hdnVlsObligation" Value='<%# Bind("vlm_obligation") %>' />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vendor obligation" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblObligation" Text='<%# Bind("vlm_obligation") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnObligation" Value='<%# Bind("vlm_obligation") %>' />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Availability" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAvailability" Text='<%# Bind("vlm_availability") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnAvailability" Value='<%# Bind("vlm_availability") %>' />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Target Score" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTargetScore" Text='<%# Bind("vlsm_score") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnTargetScore" Value='<%# Bind("vlsm_score") %>' />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Obtained Score" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="txtObtainedScore" Text='<%# Bind("obt_score") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="5%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Valid Till Date" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtValidDate" runat="server" class="form-control" MaxLength="10" Enabled="false" TextMode="Date" Text='<%# Bind("valid_till") %>'></asp:TextBox>
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Issuing Authority" ControlStyle-Width="90%">
                                        <ItemTemplate>
                                            <asp:Label ID="txtIssueAuthority" Text='<%# Bind("valid_auth") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>
            </div>
        </asp:Panel>--%>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
