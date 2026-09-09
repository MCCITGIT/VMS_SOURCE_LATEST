<%@ Page Title="Token Vendor Add/Update" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TokenRequestAddUpdate_Factory.aspx.vb" Inherits="TokenRequestAddUpdate_Factory" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateTokenVendorAddUpdate.js?key="&<%= DateTime.Now.ToString %> ></script>
    <script src="Scripts/ValidateTokenRequestAddUpdate_Factory.js?time=&<%= DateTime.Now.ToString %>" type="text/javascript"></script>

    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }
        //-->
        function RedirectToListScreen() {
            window.location.href = "TokenRequestList_Factory.aspx";
            return false;
        }
    </script>
    <script type="text/javascript">

        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('imgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Token Requisition Add/Update</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Factory Name:<span id="Span8" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel8" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlFactory" runat="server" CssClass="form-control select2" AutoPostBack="true">
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnCartonCapacity" runat="server" />
                                        <asp:HiddenField ID="hdnSessionId" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Name:<span id="Span9" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlVendor" runat="server" CssClass="form-control select2" AutoPostBack="true">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlFactory" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Requisition Month:<span id="Span10" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlRequisitionMonth" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Requisition Year:<span id="Span11" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlRequisitionYear" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Token Type:<span id="Span2" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlTokenType" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Token Month:<span id="Span1" runat="server" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Token Year:<span id="Span5" runat="server" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control select2">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Product Name:<span id="Span6" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-control select2" AutoPostBack="true">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlVendor" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Pack Size Name:<span id="Span7" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlPackSize" runat="server" CssClass="form-control select2" AutoPostBack="true">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlProduct" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Denomination Name:<span id="Span4" runat="server" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlValue" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Total Quantity:<span id="Span12" runat="server" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                         <div class="col-md-2 form-btn-mt">
                            <div class="form-group">
                                <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-primary btn-sm" />
                                <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm"/>
                                <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                                    <ContentTemplate>
                                        <asp:Label ID="lblValidationMessage" runat="server" ForeColor="Red" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                                    <ContentTemplate>
                                        <asp:Label ID="lblNB" runat="server" ForeColor="Red" Text="* Total quantity against requisition can not exceed more than 1 lac.  "></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between; padding: 15px 0 0">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Requisition Details</h5>
                        <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel9" runat="server">
                <ContentTemplate>
                    <div class="table-responsive">
                        <asp:GridView ID="gvTokenDetails" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid" EmptyDataText="No record(s) found." AllowPaging="False" ShowFooter="False">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="#">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="2%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Factory">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFactory" runat="server" Text='<%# Eval("factory_code") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnFactoryCode" runat="server" Value='<%#Eval("tm_factory_code")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendor" runat="server" Text='<%# Eval("vendor_code") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%#Eval("tm_vendor_code")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Token Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTokenType" runat="server" Text='<%# Eval("type") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnTokenType" runat="server" Value='<%#Eval("tm_type")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Token Month">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMonth" runat="server" Text='<%# Eval("token_month") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnTokenMonth" runat="server" Value='<%#Eval("tm_token_month")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Token Year">
                                    <ItemTemplate>
                                        <asp:Label ID="lblYear" runat="server" Text='<%# Eval("token_year") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnTokenYear" runat="server" Value='<%#Eval("tm_token_year")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Product">
                                    <ItemTemplate>
                                        <asp:Label ID="lblproduct" runat="server" Text='<%# Eval("product") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnProduct" runat="server" Value='<%#Eval("tm_product")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Pack Size">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPacksize" runat="server" Text='<%# Eval("pack") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnPackSize" runat="server" Value='<%#Eval("tm_pack")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Denomination">
                                    <ItemTemplate>
                                        <asp:Label ID="lblValue" runat="server" Text='<%# Eval("denomination") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnTokenValue" runat="server" Value='<%#Eval("tm_denomination")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity">
                                    <ItemTemplate>
                                        <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("qty") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnQuantity" runat="server" Value='<%#Eval("tm_qty")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Month">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequisitionMonth" runat="server" Text='<%# Eval("requisition_month") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnRequisitionMonth" runat="server" Value='<%#Eval("tm_requisition_month")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Year">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRequisitionYear" runat="server" Text='<%# Eval("requisition_year") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnRequisitionYear" runat="server" Value='<%#Eval("tm_requisition_year")%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Button ID="btnCmdRemove" runat="server" Text="Remove" title="Remove" class="btn btn-danger btn-sm"
                                            CommandName="CmdRemove" OnClientClick="return confirm('Are you sure to remove?')"
                                            CommandArgument='<%# Container.DataItemIndex %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAdd" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
            <div class="row">
                <div class="col-md-12 text-center form-btn-mt">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success btn-sm" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
