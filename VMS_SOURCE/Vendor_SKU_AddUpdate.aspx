<%@ Page Title="Vendor SKU Add/Update" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_SKU_AddUpdate.aspx.vb" Inherits="Vendor_SKU_AddUpdate" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script src="Scripts/ValidateVendorMaster.js" type="text/javascript"></script>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {

            //	        if (event.keyCode == 118) {  // button Add (F7 keypress)
            //	            //	        __doPostBack(document.getElementById('imgbtnAdd').name, '');
            //                      document.getElementById('imgbtnAdd').click()
            //	        }

            if (event.keyCode == 118) {  // button Add (F7 keypress)
                //	        __doPostBack(document.getElementById('imgbtnAdd').name, '');
                document.getElementById('btnSubmit').click()
            }
        }
        //-->
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor SKU Master</h3>
                <p class="pageSubTitle">Create and maintain vendor SKU records</p>
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
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">SKU Code:</label>
                        <asp:TextBox ID="txtSKU" MaxLength="16" CssClass="form-control" runat="server"></asp:TextBox>
                        <%--<img alt="" src="images/help_icon.gif" style="border: 0;" class="formCalndIcon" />--%>
                        <i class="fas fa-info-circle formCalndIcon" style="top: 29px; right: 10px;"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Description:</label>
                        <asp:TextBox ID="txtDesc" MaxLength="50" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <asp:LinkButton ID="btnSkuCode" runat="server" CssClass="btn btn-primary btn-sm">Click</asp:LinkButton>
                        <%--<asp:Button ID="btnSkuCode" runat="server" Text="Click" CssClass="btn btn-primary btn-sm" />--%>
                    </div>
                </div>
            </div>
            <div id="divErrorMessage"></div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <h5 style="font-size: 14px;">Selected Depots</h5>
                <asp:GridView ID="gvVendorAdd" runat="server" AutoGenerateColumns="False" AllowPaging="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <%-- <asp:BoundField HeaderText ="Select" DataField="" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        --%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select" ItemStyle-Width="5%">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkSelect" runat="server" />
                                <%--<asp:HiddenField ID="hdnCheck" runat="server" 
                                                     Value='<%# Bind("") %>' />--%>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle Width="5%" HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("depot_code") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:TemplateField>
                        <%-- <asp:BoundField HeaderText ="Region" DataField="depot_regn" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                          
                        </asp:BoundField>
                        <asp:BoundField HeaderText ="Depot" DataField="depot_code" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        
                        <asp:BoundField HeaderText ="Name" DataField="depot_name" >
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>--%>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Region" DataField="depot_regn">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Depot" DataField="depot_code">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Name" DataField="depot_name">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="TSL" ItemStyle-Width="10%">
                            <ItemTemplate>
                                <asp:TextBox ID="txtTsl" MaxLength="5" CssClass="form-control" runat="server"></asp:TextBox>
                                <%--<asp:HiddenField ID="hdnTsl" runat="server" Value='<%# Bind("v_tsl_factor") %>' />--%>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle Width="15%"></ItemStyle>
                        </asp:TemplateField>
                        <%--<asp:BoundField HeaderText ="TSL Factor" DataField="v_tsl_factor" >
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        --%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="P/S" ItemStyle-Width="15%">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlPA" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="PRIMARY">PRIMARY</asp:ListItem>
                                    <asp:ListItem Value="SECONDARY">SECONDARY</asp:ListItem>
                                </asp:DropDownList>
                                <%--<asp:HiddenField ID="hdnPAld" runat="server" Value='<%# Bind("v_primary_secondary") %>' />--%>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle Width="15%"></ItemStyle>
                        </asp:TemplateField>
                        <%-- <asp:BoundField HeaderText ="P/A" DataField="v_primary_secondary" >
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>  --%>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <table style="width: 100%; border: 0px; margin: 0px 0px 10px 0px;">
                        <tr>
                            <td style="text-align: center;">Select from Below Table</td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <asp:ImageButton ID="ImgbtnTrans" runat="server" Height="35px" ImageUrl="~/images/ic_downbutton.jpg"
                                    Style="position: static" Width="35px" />
                                <asp:ImageButton ID="ImgbtnTransUp" runat="server" Height="35px" ImageUrl="~/images/ic_Upbutton.jpg"
                                    Style="position: static" Width="35px" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="dflexCSb">
                <div class="form-group row ddlFinYear">
                    <label for="ddlPageSize" class="col-auto form-control-label">Select Region:</label>
                    <div class="col-auto">
                        <asp:DropDownList ID="ddlRegion" CssClass="form-control select2" runat="server" AutoPostBack="True">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group row ddlPageSize">
                    <label for="ddlPageSize" class="col-auto form-control-label">
                        <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                    </label>
                    <div class="col-auto">
                        <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvVendorSelect" runat="server" AutoGenerateColumns="False" AllowPaging="True" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <%--<asp:BoundField  HeaderStyle-HorizontalAlign ="Center" 
                              ItemStyle-HorizontalAlign="Center" HeaderText ="Select" DataField="" >
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>--%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select" ItemStyle-Width="5%">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkSel" runat="server" />
                                <%--<asp:HiddenField ID="hdnCheck" runat="server" 
                                                     Value='<%# Bind("") %>' />--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("depot_code") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:TemplateField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Region" DataField="depot_regn">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Depot" DataField="depot_code">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                            HeaderText="Name" DataField="depot_name">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="row mt-2">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" runat="server" Text="Submit" />
                    <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
