<%@ Page Title="Vendor SKU Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_SKU_Master.aspx.vb" Inherits="Vendor_SKU_Master" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }

            if (event.keyCode == 118) {  // button Add (F7 keypress)
                //	        __doPostBack(document.getElementById('imgbtnAdd').name, '');
                document.getElementById('imgbtnAdd').click()
            }
        }
        //-->
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor SKU LIST</h3>
                <p class="pageSubTitle">Browse and manage vendor SKUs</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Source:</label>
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" TabIndex="1" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">SKU Code:</label>
                        <asp:TextBox ID="txtSkuCode" runat="server" CssClass="form-control" text-align="center"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                        <asp:LinkButton ID="imgbtnAdd" PostBackUrl="~/Vendor_SKU_AddUpdate.aspx" runat="server" CssClass="btn btn-success btn-sm" OnClick="imgbtnAdd_Click">Add</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">User Login History Details</h5>
                        <p class="mst-panel-subtitle">Login activity for the selected user</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="display: flex; align-items: center;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvVendorSKUList" runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid" AllowPaging="True" EmptyDataText="No Record Found." DataKeyNames="v_sku_code">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        <%--<asp:HiddenField ID="hdnDepot" runat="server" 
                                                     Value='<%# Bind("v__depot") %>' />--%>

                                        <asp:HiddenField ID="hdnvendor_unit" runat="server"
                                            Value='<%# Bind("v_vendor_unit") %>' />

                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="SKU" DataField="v_sku_code">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>
                                <%--<asp:BoundField HeaderText="Description" DataField="SkuDescription"><HeaderStyle HorizontalAlign="Center"/><ItemStyle HorizontalAlign="Center" Width="15%"/></asp:BoundField>--%>
                                <asp:ButtonField CommandName="Update" HeaderText="Description" ShowHeader="True"
                                    DataTextField="SkuDescription">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle Font-Underline="false" ForeColor="Blue" Width="20%" HorizontalAlign="Center" />
                                </asp:ButtonField>
                                <asp:BoundField HeaderText="Applicable Depots" DataField="ApplicableDepot">
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger
                            ControlID="imgbtnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" runat="server" Font-Size="10px" Font-Bold="true"></asp:Label>
        </div>
    </div>
</asp:Content>
