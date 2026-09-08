<%@ Page Title="Unit Despatch Plan" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="ChallanCancellationList.aspx.vb" Inherits="ChallanCancellationList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }

        function DeleteItem() {
            if (confirm("Are you sure you want to Cancel ...?")) {
                return true;
            }
            return false;
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Approved Challan Details</h3>
                <p class="pageSubTitle">Review challans approved for cancellation</p>
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
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="True" CssClass="form-control select2"
                                    TabIndex="3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="True" CssClass="form-control select2"
                                    TabIndex="3">
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
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%-- Modified-by MUKESH BHAGAT on 08-09-2026 : this page still used the old
                                     ic_search.gif ImageButton, so the button rendered as an image inside the
                                     Bootstrap box and sat differently from every other list page. Switched to
                                     the LinkButton used by UnitDespatchPlanListVr1 / VendorChallanList.
                                <asp:ImageButton ID="ImgbtnSearch" CssClass="btn btn-primary btn-sm" runat="server" ImageUrl="images/ic_search.gif" /> --%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server">Search</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="form-group row ddlPageSize">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvChallanDetails" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <%-- <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                            </asp:BoundField>--%>
                                <%-- <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select">
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="chkSelect" runat="server" />
                                                                                    <asp:HiddenField ID="hdnyear" runat="server" Value='<%# Bind("desph_challan_fin_year") %>' />
                                                                                    <asp:HiddenField ID="hdnMOnth" runat="server" Value='<%# Bind("desph_process_month") %>' />
                                                                                    <asp:HiddenField ID="hdnUnit" runat="server" Value='<%# Bind("desph_desp_unit") %>' />
                                                                                    <asp:HiddenField ID="hdnChallanId" runat="server" Value='<%# Bind("desph_challan_no") %>' />
                                                                                    <asp:HiddenField ID="hdnDepot" runat="server" Value='<%# Bind("desph_desp_depot") %>' />
                                                                                </ItemTemplate>
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                            </asp:TemplateField>--%>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Region" DataField="region">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="desph_desp_depot">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Name" DataField="depotName">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Challan No." DataField="desph_challan_no">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Challan Date" DataField="desph_challan_date" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU List" DataField="skuList">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="35%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Aproved/Pending" DataField="">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:BoundField>
                                <%--<asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Print">
                                                                                <ItemTemplate>
                                                                                    <asp:ImageButton ID="ImgbtnPrint" runat="server" AlternateText="Print" ImageUrl="~/images/printButton.png"
                                                                                        CommandName="Print" />
                                                                                </ItemTemplate>
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                            </asp:TemplateField>--%>
                                <%--<asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Action">
                                                                                <ItemTemplate>
                                                                                    <asp:ImageButton ID="ImgbtnDeleteChallan" runat="server" AlternateText="Delete Challan" onclientclick="return DeleteItem()" ToolTip="Click to delete challan" ImageUrl="~/images/ic_delete.gif"
                                                                                        CommandName="DeleteChallan" />
                                                                                </ItemTemplate>
                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                                            </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <%--<asp:Button ID="btnAprove" CssClass="but2" runat="server" Text="Approve" />--%>
                            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                            <div id="divErrorMessage"></div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
