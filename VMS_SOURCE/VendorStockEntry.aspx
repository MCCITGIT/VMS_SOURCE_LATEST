<%@ Page Title="Brand Test Linking" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorStockEntry.aspx.vb" Inherits="VendorStockEntry" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/ValidationLovDetails.js"></script>
    <script type="text/javascript" src="Scripts/BrandProductLinking.js"></script>
    <script type="text/javascript">var cal1 = new CalendarPopup(); function scheme_effective_date_onclick() { }</script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    // button Add (F7 keypress)
                    validateVendorStockEntry();
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

    <script>
        function IsnumbKeY(evt) {
            var chrcode = (evt.which) ? evt.which : evt.keyCode;
            if (chrcode > 31 && (chrcode < 46 || chrcode > 57))
                return false;
            return true;
        }
    </script>
    <script type="text/javascript" src="Scripts/VendorStockEntry.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>


    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Stock Entry</h3>
                <p class="pageSubTitle">Record stock held at the vendor site</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:<span class="mandatory">*</span></label>
                        <asp:DropDownList ID="ddlVendor" class="form-control" AutoPostBack="true" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">As On Date:<span class="mandatory">*</span></label>
                        <asp:TextBox ID="txtAsOndate" class="form-control" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="txtAsOndate" ErrorMessage="Choose only the enabled dates" Type="Date" OnInit="RangeValidator2_Init">*Enter Correct date</asp:RangeValidator>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <asp:Button ID="imgbtnSearch" runat="server" ToolTip="Search" Text="Search" CssClass="btn btn-primary btn-sm" />
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="grdStockEntry" runat="server" AutoGenerateColumns="False" ShowFooter="True" EmptyDataText="No records found" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl.No." HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRowNo" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU CODE">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSkuCode" runat="server" Text='<%# Bind("sku_code") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU NAME">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSkuName" runat="server" Text='<%# Bind("sku_desc") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="40%" />
                                        <ItemStyle HorizontalAlign="Center" Width="40%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="NOP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNop" runat="server" class="form-control" onkeypress="return IsnumbKeY(event)" Text='<%# Bind("vssm_nop") %>' OnTextChanged="txtNop_TextChanged" AutoPostBack="true"></asp:TextBox>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:Label ID="txtPacksize" runat="server" Text='<%# Bind("packsize") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="10%" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        <FooterTemplate>
                                            <asp:Label ID="lbltotaltxt" runat="server" Text="Total:"></asp:Label>
                                        </FooterTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Volume">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtValue" runat="server" class="form-control" onkeypress="return IsnumbKeY(event)" Text='<%# Bind("vssm_vol") %>' ReadOnly="true" Style="display: none;"></asp:TextBox>
                                            <asp:Label ID="lblValue" runat="server" Text='<%# Bind("vssm_vol") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                        <FooterTemplate>
                                            <asp:Label ID="lbltotal" runat="server" Style="color: red" Text="0.00"></asp:Label>
                                        </FooterTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="row mt-3">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-sm" />
                    <asp:Button ID="btnReset" runat="server" Text="Back" CssClass="btn btn-warning btn-sm" ToolTip="List Page" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
