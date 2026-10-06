<%@ Page Title="OCSpecification List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OCSpecificationList.aspx.vb" Inherits="OCSpecificationList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : MasterPage mangles IDs (ctl00_ContentPlaceHolder1_...); use UniqueID instead of bare IDs --%>
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack('<%= imgbtnAdd.UniqueID %>', '');
            }
            else if (event.keyCode == 119) {
                __doPostBack('<%= imgbtnSearch.UniqueID %>', '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <script type="text/javascript">var cal1 = new CalendarPopup();</script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">OCSpecification List</h3>
                <p class="pageSubTitle">Browse quality control specifications</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <asp:Label ID="lblPopMessage" runat="server"></asp:Label>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vender:</label>
                                <asp:DropDownList ID="ddlVender" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">From Date:</label>
                                <asp:TextBox ID="txtFromDate" CssClass="form-control" MaxLength="10" TabIndex="23" runat="server"></asp:TextBox>
                                <asp:calendarextender id="CalendarExtender1" runat="server" targetcontrolid="txtFromDate" format="dd/MM/yyyy" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">To Date:</label>
                                <asp:TextBox ID="txtTodate" CssClass="form-control" MaxLength="10" TabIndex="24" runat="server"></asp:TextBox>
                                <asp:calendarextender id="CalendarExtender2" runat="server" targetcontrolid="txtTodate" format="dd/MM/yyyy" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlproduct" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-12 text-center">
                            <div class="form-group">
                                <asp:ImageButton ImageUrl="images/p-search.png" CssClass="btn btn-primary btn-sm" ID="imgbtnSearch" runat="server" />
                                <asp:ImageButton ImageUrl="~/images/p-plus.png" CssClass="btn btn-success btn-sm" ID="imgbtnAdd" runat="server" PostBackUrl="~/OC_Specification_Dtls.aspx" />
                                <asp:ImageButton ImageUrl="~/images/p-downloads.png" CssClass="btn btn-info btn-sm" ID="imgDownload" runat="server" PostBackUrl="~/OCSpecificationUpload.aspx" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <asp:GridView ID="gvOcSpecification" runat="server" AutoGenerateColumns="False" AllowPaging="True" BorderWidth="1" CssClass="table table-hover upgradDataGrid" EmptyDataText="No record(s) found.">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Sl.No">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <ItemStyle Width="2%" HorizontalAlign="Center" />
                                    <HeaderStyle Width="2%" HorizontalAlign="Center" />

                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Vender" DataField="VenderName">

                                    <ItemStyle Width="30%" />
                                    <HeaderStyle Width="30%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="product" DataField="ProductCode">
                                    <ItemStyle Width="10%" />
                                    <HeaderStyle Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Batch No" DataField="BatchNo">
                                    <ItemStyle Width="8%" />
                                    <HeaderStyle Width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Batch Date" DataField="BatchDate" DataFormatString="{0:dd/MM/yyyy}">
                                    <ItemStyle Width="10%" />
                                    <HeaderStyle Width="10%" />
                                </asp:BoundField>
                                <%--<asp:BoundField  HeaderStyle-HorizontalAlign ="Center"  ItemStyle-HorizontalAlign="Center" HeaderText ="Specification" DataField="Specifications" >
                                                <ItemStyle Width="20%" />
                                                <HeaderStyle Width="20%" />
                                                </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:ImageButton runat="server" ID="btnedit" CommandName="edit" ImageUrl="~/images/edit.jpg" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Confirm">
                                    <ItemTemplate>
                                        <asp:ImageButton runat="server" ID="btnconfirm" CommandName="confirm" OnClientClick="return confirm('Are you sure to confirm?');" ImageUrl="~/images/ic_ok.gif" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                    <HeaderStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Download">
                                    <ItemTemplate>
                                        <asp:ImageButton runat="server" Visible="false" ID="btndownload" CommandName="download" ImageUrl="~/images/ic_downbutton.jpg" Width="30px" Height="20px" />
                                        <asp:HiddenField ID="hdhdrID" runat="server" Value='<%# Bind("hdrid") %>' />
                                        <asp:HiddenField ID="hdnconfirmstatus" runat="server" Value='<%# Bind("confirm_YN") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="5%" HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>
                            <SortedAscendingCellStyle BackColor="#F5F7FB" />
                            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                            <SortedDescendingCellStyle BackColor="#E9EBEF" />
                            <SortedDescendingHeaderStyle BackColor="#4870BE" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
