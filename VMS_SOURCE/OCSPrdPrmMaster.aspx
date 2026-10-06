<%@ Page Title="OC SPECIFICATION PARAMS LIST" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OCSPrdPrmMaster.aspx.vb" Inherits="OCSPrdPrmMaster" %>


<%@ Register TagPrefix="uc1" TagName="Footer" Src="includes/Footer.ascx" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : FunctionValidator.js is commented out in MasterPage; ValidateSubmit needs ValidateRequired/ValidateDropDown1/GetErrorRow/SetErrorColor/SetControlFocus --%>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script src="Scripts/ValidatePrdPrmMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">OC Specifivation Params List</h3>
                <p class="pageSubTitle">Maintain specification parameters per product</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product Name:</label>
                                <asp:DropDownList ID="ddlparam" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">OC Specifivation Params List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <span class="errormsg">*Note : Please enter drop down parameters with coma saparetor..!!</span>
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvParamsList" runat="server" AutoGenerateColumns="False" EmptyDataText="No record(s) found."
                            EnableModelValidation="True" ShowFooter="true" AllowPaging="true" PageSize="15" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Product Code" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPrdCode" runat="server" Text='<%# Bind("product_code") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox CssClass="form-control" ID="txtPrdCode" runat="server" Text='<%# Bind("product_code") %>'></asp:TextBox>
                                        <asp:TextBox CssClass="form-control" ID="txtfreqq" runat="server" Text='<%# Bind("frequencycode") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtPrdCode1" CssClass="form-control" runat="server"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductname" runat="server" Text='<%# Bind("product_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnId" runat="server" Value='<%# Bind("product_code") %>'></asp:HiddenField>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlprodname" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                        <asp:HiddenField ID="hdnprdid" runat="server" Value='<%# Bind("opph_id") %>'></asp:HiddenField>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlprdname" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Parameters Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParams" runat="server" Text='<%# Bind("params") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtparams" CssClass="form-control" runat="server" Text='<%# Bind("params") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtparam" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Frequency" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblfrequency" runat="server" Text='<%# Bind("frequency")%>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlfreq" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlfreqncy" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# Bind("active") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlActive_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="NumericYN" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNumeric" runat="server" Text='<%# Bind("numericYN") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlNumeric" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlNumeric_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Min Value" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMinValue" runat="server" Text='<%# Bind("min_value") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtminValue" CssClass="form-control" runat="server" Text='<%# Bind("min_value") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtminValueft" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Max Value" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMaxValue" runat="server" Text='<%# Bind("max_value") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtmaxValue" CssClass="form-control" runat="server" Text='<%# Bind("max_value") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtmaxValueft" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="DropdownYN" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDropdown" runat="server" Text='<%# Bind("dropdownYN") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlDropdown" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlDropdown_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Drop Down Params" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDropDownParam" runat="server" Text='<%# Bind("DrpDwnParams") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtDropDownParam" CssClass="form-control" runat="server" Text='<%# Bind("DrpDwnParams") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtDropDownParam_ftr" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%--<asp:Button ID="btnEdit" CommandName="Edit" Width="90%" CssClass="but1" runat="server" Text="Edit" />--%>

                                        <%--<asp:ImageButton ID="btnEdit" CommandName="Edit" runat="server" ImageUrl="~/Images/edit.jpg" />--%>
                                        <asp:LinkButton ID="btnEdit" CommandName="Edit" runat="server"><i class="fa fa-wrench"></i></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%-- <asp:Button ID="btnUpdate" CommandName="Update" Width="90%" CssClass="but1" runat="server" Text="Update" />
                                                     <asp:Button ID="btnCancel" CommandName="Cancel" Width="90%" CssClass="but1" runat="server" Text="Cancel" />--%>

                                        <%--<asp:ImageButton ID="btnUpdate" CommandName="Update" runat="server" ImageUrl="~/Images/b_save.gif" />
                                        <asp:ImageButton ID="btnCancel" CommandName="Cancel" runat="server" ImageUrl="~/Images/b_cancel.gif" />--%>
                                        <asp:LinkButton ID="btnUpdate" CommandName="Update" runat="server" title="Save"><i class="fa fa-check-circle" style="color:#00ff21"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" CommandName="Cancel" runat="server" title="Cancel"><i class="fa fa-times-circle" style="color:#ff6a00;"></i></asp:LinkButton>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <%-- <asp:Button ID="btnSubmit" CommandName="Submit" Width="90%" CssClass="but1" runat="server" Text="Submit" />--%>

                                        <%--<asp:ImageButton ID="btnSubmit" CommandName="Submit" runat="server" ImageUrl="~/Images/b_save.gif" />--%>
                                        <asp:LinkButton ID="btnSubmit" CommandName="Submit" runat="server"><i class="fa fa-check-circle" style="color:#00ff21"></i></asp:LinkButton>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
