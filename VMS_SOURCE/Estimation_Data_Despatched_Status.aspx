<%@ Page Title="Estimation Data Despatched Status" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Estimation_Data_Despatched_Status.aspx.vb" Inherits="Estimation_Data_Despatched_Status" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/Validation_Estimation_Data_Despatch_Status.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            //	    if(event.keyCode == 118){  // button Add (F7 keypress)	    		    0
            //		    __doPostBack(document.getElementById('ImgbtnAdd').name,'');
            //	    }
            if (event.keyCode == 119) {
                if (ValidatePaymentSearch()) { // button Search (F8 keypress)    		    	        
                    __doPostBack(document.getElementById('ImgbtnSearch').name, '');
                }
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">SKU Wise Despatch Status</h3>
                <p class="pageSubTitle">Despatch status against estimates, SKU wise</p>
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
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Despatched Source:</label>
                                <asp:DropDownList ID="ddlDsptchdUnit" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlProduct" runat="server" AppendDataBoundItems="True" AutoPostBack="True" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Fin Year:<span id="lblGroup" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtFinYear" runat="server" CssClass="form-control" MaxLength="4"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Month:<span id="Span3" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtMonth" runat="server" CssClass="form-control" MaxLength="2" TabIndex="5"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Format:</label>
                                <asp:DropDownList ID="ddlPrntOptn" CssClass="form-control select2" valign="Center" runat="server" AutoPostBack="True" AppendDataBoundItems="True">
                                    <%--<asp:ListItem>Select Print Option</asp:ListItem>--%>
                                    <asp:ListItem Value="PdfFormat">PDF</asp:ListItem>
                                    <asp:ListItem Value="ExcelFormat" Selected="True">Excel</asp:ListItem>
                                    <asp:ListItem Value="WordFormat">Word</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <%--<asp:ImageButton ImageUrl="images/ic_search.gif" ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" AlternateText="Search" />--%>
                            <asp:LinkButton ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" AlternateText="Search" OnClick="ImgbtnSearch_Click">Search</asp:LinkButton>
                            <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" TabIndex="31" runat="server" Text="Submit" />
                            <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" TabIndex="32" runat="server" Text="Cancel" />
                        </div>
                    </div>
                    <div id="divErrMsg1" class="errormsg"></div>
                </div>
            </div>
            <div class="card" id="td_gvitem_mid" runat="server">
                <div class="card-body">
                    <div class="form-group row ddlPageSize">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="lblResultspPage" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvDsptchdStat" runat="server" AutoGenerateColumns="false" AllowPaging="true"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Srl.No">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'
                                            Font-Bold="True"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="3%" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="region" HeaderText="Region">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="4%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_depot" HeaderText="Depot">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="9%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_sku_code" HeaderText="SKU">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="23%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_average" HeaderText="Average">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_estimate_nop" HeaderText="Estimate">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_tsl_factor" HeaderText="TSL Factor">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_tsl_nop" HeaderText="TSL">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_stock" HeaderText="Stock">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_auto_indent" HeaderText="Auto Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="load_depot_indent_nop" HeaderText="Branch Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Desp_date" HeaderText="Desp-to Date">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="INTRANSIT" HeaderText="INTRANSIT">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RECEIVED at Depot" HeaderText="RECEIVED at Depot">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Last_Desp_date" HeaderText="Last Despatch Date">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="pending_auto_indent" HeaderText="Pending Auto Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="pending_manual_indent" HeaderText="Pending Manual Indent">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="current_despatch" HeaderText="Current Despatch">
                                    <ItemStyle HorizontalAlign="right" />
                                    <HeaderStyle HorizontalAlign="Center" Width="7%" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div id="tblrental" runat="server">
                        <asp:Label ID="lblNoRecrds" CssClass="errormsg" runat="server"></asp:Label>
                        <asp:Label ID="lblErrMsg" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        <div id="divErrMsg"></div>
                    </div>
                    <div id="divErrorMessage1"></div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
    </asp:UpdatePanel>



</asp:Content>
