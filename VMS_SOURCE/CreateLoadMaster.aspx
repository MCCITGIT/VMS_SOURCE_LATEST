<%@ Page Title="Create Load Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="CreateLoadMaster.aspx.vb" Inherits="CreateLoadMaster" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--<script src="Scripts/csspopup.js" type="text/javascript"></script>--%>
    <script src="Scripts/ValidateEstimationUpload.js" type="text/javascript"></script>

    <style type="text/css">
        #blanket {
            background-color: #111;
            opacity: 0.65;
            filter: alpha(opacity=65);
            position: absolute;
            z-index: 9001;
            top: 0px;
            left: 0px;
            width: 100%;
        }

        #popUpDiv {
            position: absolute;
            background-color: #eeeeee;
            width: 300px;
            height: 100px;
            z-index: 9002;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Create Load Master</h3>
                <p class="pageSubTitle">Define load configurations used for despatch</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:HiddenField ID="hdnFileName" runat="server" />
                                <asp:Button ID="btnBoth" runat="server" Style="display: none" />
                                <asp:Label ID="lblYear" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:Label ID="lblMonth" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Stock As On:</label>
                                <asp:Label ID="lblStockAsOn" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-5 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton ID="ImageButton2" runat="server" CssClass="btn btn-info btn-sm" AlternateText="Home"
                                    ImageUrl="~/images/printButton.png" />--%>
                                <asp:LinkButton ID="ImageButton2" runat="server" CssClass="btn btn-info btn-sm" AlternateText="Home" OnClick="ImageButton2_Click">Print</asp:LinkButton>
                                <asp:Button ID="btnProcess" runat="server" CssClass="btn btn-primary btn-sm" Text="Create" />
                                <%--Modified-by MUKESH BHAGAT on 20-08-2026 : restored from old UAT source--%>
                                <asp:Button ID="btnSendMail" runat="server" CssClass="btn btn-primary btn-sm" Text="Send Mail" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" id="tabGrid" runat="server">
                <div class="card-body">
                    <div class="form-group row ddlPageSize">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:" Visible="False"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true" Visible="False"></asp:DropDownList>
                        </div>
                    </div>
                    <asp:Label ID="lblNotFound" runat="server"></asp:Label>
                    <div class="table-responsive">
                        <asp:GridView ID="gvNotFound" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left"
                                    ControlStyle-Width="5%">
                                    <ControlStyle Width="5%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Year" DataField="tmp_year" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Month" DataField="tmp_month" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="tmp_depot" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU Code" DataField="tmp_sku" ControlStyle-Width="20%">
                                    <ControlStyle Width="5%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Average NOP" DataField="tmp_avg" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Estimated NOP" DataField="tmp_est" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>

                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="card" id="tabSummery" runat="server" visible="false">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Start Time:</label>
                                <asp:Label ID="lblStartTime" runat="server" CssClass="labelDataPoint"></asp:Label>
                                <asp:HiddenField ID="hdnStart" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process End Time:</label>
                                <asp:Label ID="lblEndTime" runat="server" CssClass="labelDataPoint"></asp:Label>
                                <asp:HiddenField ID="hdnEnd" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Elapsed Time:</label>
                                <asp:Label ID="lblEclapsedTime" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Total Records:</label>
                                <asp:Label ID="lblTotalRecords" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
            </div>


            <div runat="server" id="divPopup" style="display: none; position: absolute; background-color: #eeeeee; width: 300px; height: 100px; z-index: 9002;">
                <table style="width: 100%;">
                    <tr>
                        <td colspan="2" style="font-size: 16px">File with same name already exists.Do you want to Delete and Poceed?
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <asp:Button ID="btnYes" runat="server" Text="Yes" CssClass="but4" Width="40px" />
                        </td>
                        <td style="text-align: center">
                            <asp:Button ID="btnNo" runat="server" Text="No" CssClass="but4" Width="40px" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="blanket" style="display: none;"></div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

