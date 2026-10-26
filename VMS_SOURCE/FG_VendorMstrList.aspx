<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FG_VendorMstrList.aspx.vb" Inherits="FG_VendorMstrList" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                document.getElementById('ImgbtnAdd').click();
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">FG Vendor Master</h3>
                <p class="pageSubTitle">Browse and manage production vendors</p>
            </div>
        </div>
        <div class="rightFung">
            <asp:LinkButton ID="ImgbtnAdd" runat="server" class="btn btn-success btn-sm" OnClick="ImgbtnAdd_Click">Add</asp:LinkButton>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Vendor Details</h5>
                        <p class="mst-panel-subtitle">Login activity for the selected user</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="display: flex; align-items: center; padding: 0px;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="Label1" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="form-group mb-0">
                        <label class="form-control-label">Vendor Name:</label>
                        <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2" style="display: flex; align-items: flex-end;">
                    <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                </div>
            </div>
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvVendorProfile" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            OnRowDataBound="gvVendorProfile_RowDataBound" Visible="true"
                            OnPageIndexChanging="gvVendorProfile_IndexChanging" BorderWidth="1" Style="margin-bottom: 0" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>                                

                                <asp:BoundField HeaderText="Source Code" DataField="unit_code">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Source Name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataField="unit_name">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>

                               

                                <asp:BoundField HeaderText="Status" HeaderStyle-HorizontalAlign="Center" DataField="active">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Created User" HeaderStyle-HorizontalAlign="Center" DataField="created_user">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Created Date" HeaderStyle-HorizontalAlign="Center" DataField="created_date">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>
                                 <asp:BoundField HeaderText="Oracle ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataField="oracle_id">
     <HeaderStyle HorizontalAlign="Center" />
     <ItemStyle HorizontalAlign="Center" Width="15%" />
 </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="imgbtnSearch"
                            EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>
