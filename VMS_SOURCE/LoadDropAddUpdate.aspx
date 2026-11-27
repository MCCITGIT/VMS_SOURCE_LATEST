<%@ Page Title="Load Drop Add / Update" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="LoadDropAddUpdate.aspx.vb" Inherits="LoadDropAddUpdate" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationLoadDropAddUpdate.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { //Add (F7 keypress)
                document.getElementById('btnSubmit').click()
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Load Drop Request Add/Update</h3>
                <p class="pageSubTitle">Raise or revise a load drop request</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="true" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlDepot" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:DropDownList ID="ddlProcessYr" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:DropDownList ID="ddlProcessMnth" CssClass="form-control select2" runat="server">
                                    <asp:ListItem>01</asp:ListItem>
                                    <asp:ListItem>02</asp:ListItem>
                                    <asp:ListItem>03</asp:ListItem>
                                    <asp:ListItem>04</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>06</asp:ListItem>
                                    <asp:ListItem>07</asp:ListItem>
                                    <asp:ListItem>08</asp:ListItem>
                                    <asp:ListItem>09</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>11</asp:ListItem>
                                    <asp:ListItem>12</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlProduct" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="4"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <asp:GridView ID="gvSKUDetails" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No SKU Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                        <asp:HiddenField ID="hdnUom" runat="server" Value='<%# Bind("skuUom") %>' />
                                        <asp:HiddenField ID="hdnVol" runat="server" Value='<%# Bind("skuVol") %>' />
                                        <asp:HiddenField ID="hdnTransitDay" runat="server" Value='<%# Bind("transitDays") %>' />
                                        <asp:HiddenField ID="hdnSKUCode" runat="server" Value='<%# Bind("load_sku_code") %>' />
                                        <asp:HiddenField ID="hdnLineNum" runat="server" Value='<%# Bind("line_num") %>' />
                                        <asp:HiddenField ID="hdnSkuDesc" runat="server" Value='<%# Bind("skuDesc") %>' />
                                        <asp:HiddenField ID="hdnDepotCode" runat="server" Value='<%# Bind("load_depot") %>' />
                                        <asp:HiddenField ID="hdnCurrSkuStatus" runat="server" Value='<%# Bind("CurrSkuStatus") %>' />
                                        <asp:HiddenField ID="hdnUnitCode" runat="server" Value='<%# Bind("load_vend_unit") %>' />

                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Region" DataField="DepotRegion">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="DepotName">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU Code" DataField="load_sku_code">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="14%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Description" DataField="skuDesc">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="23%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="23%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="23%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Auto Indent" DataField="calculatedAuto">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot Indent" DataField="load_depot_indent_nop_pending">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Despatch Till Date" DataField="calculatedDespatch" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>

                                <asp:TemplateField HeaderText="Pending Qty" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPendingLoad" runat="server" Text='<%# Bind("pendingLoad") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Drop Qty Till Date" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDropLoadTillDate" runat="server" Text='<%# Bind("load_drop_nop") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Drop Qty" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtDropLoad" CssClass="form-control" Width="80px" runat="server" Text='<%# Bind("pendingLoad") %>' MaxLength="30" Enabled="false"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-12 text-center">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:Button ID="btnSubmit" ClientIDMode="Static" CssClass="btn btn-success btn-sm" runat="server" Text="Submit" />
                                    <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" />
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnSubmit" />
                                    <asp:PostBackTrigger ControlID="btnCancel" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <asp:Label ID="lblErrMsg" CssClass="errormsg" ClientIDMode="Static" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlRegion"
                EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
