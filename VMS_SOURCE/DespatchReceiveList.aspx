<%@ Page Title="Pending Receipt Confirmation List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="DespatchReceiveList.aspx.vb" Inherits="DespatchReceiveList" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <script src="Scripts/ValidationDespatchReceiveList.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('<%= imgbtnAdd.ClientID %>').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('<%= imgbtnSearch.ClientID %>').name, '');
            }
    }

    function disableBackButton() {
        window.history.forward(1);
    }
    window.onload = disableBackButton;
    </script>
    <script type="text/javascript">
        var cal1 = new CalendarPopup();
    </script>
    <style>
        .no-record-card table tr td {
            border-radius: 10px;
            background-color: white !important;
            border: 1px solid #000000;
        }
    </style>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Pending Receipt Confirmation List</h3>
                <p class="pageSubTitle">Confirm receipt of pending despatches</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:DropDownList ID="ddlSource" CssClass="form-control select2" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                                    <asp:ListItem Value="P" Selected="True">Pending</asp:ListItem>
                                    <asp:ListItem Value="C">Confirmed</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:DropDownList ID="ddlProcessYear" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="form-control select2"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlDepot" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlRegion" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:DropDownList ID="ddlProcessMonth" runat="server" CssClass="form-control select2">
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
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan No.:</label>
                                <asp:TextBox ID="txtChallanNo" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton ImageUrl="images/ic_search.gif" ID="imgbtnSearch" runat="server" />
                                <asp:ImageButton ImageUrl="images/ic_add.gif" ID="imgbtnAdd" runat="server" />--%>
                                <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" OnClick="imgbtnSearch_Click">Search</asp:LinkButton>
                                <asp:LinkButton ID="imgbtnAdd" runat="server" CssClass="btn btn-success btn-sm" OnClick="imgbtnAdd_Click">Add</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Pending Receipt Confirmation List</h5>
                            <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive no-record-card">
                                <asp:GridView ID="gvDespatchRecvList" EmptyDataText="No record(s) found." runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" />

                                                <asp:HiddenField ID="hdnLtr" runat="server" Value='<%# Bind("total_ltr") %>' />
                                                <asp:HiddenField ID="hdnKg" runat="server" Value='<%# Bind("total_kg") %>' />

                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Unit">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUnit" runat="server" Text='<%# Eval("unitName") + "-(" + Eval("unit") + ")" %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:BoundField HeaderText="Process Year" DataField="process_year">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:BoundField HeaderText="Process Month" DataField="process_month">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:BoundField HeaderText="Region" DataField="region">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:TemplateField HeaderText="Depot">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDepot" runat="server" Text='<%# Eval("depotName") + " - " + Eval("depot") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:BoundField HeaderText="Challan No." DataField="challan_no">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:TemplateField HeaderText="Challan Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblChallanDate" runat="server" Text='<%# Bind("challan_date") %>'></asp:Label>
                                                <asp:HiddenField ID="hdnChallanDate" runat="server" Value='<%# Bind("challan_date") %>' />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:TemplateField>

                                        <%--<asp:BoundField  DataField="challan_date">
                                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                </asp:BoundField>--%>

                                        <asp:BoundField HeaderText="Ltr" DataField="total_ltr">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:BoundField HeaderText="Kg" DataField="total_kg">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:BoundField>

                                        <asp:TemplateField HeaderText="Recv. Ltr">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRecvLtr" CssClass="form-control" runat="server" Text='<%# Bind("recv_total_ltr") %>' MaxLength="16"></asp:TextBox>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Recv. Kg">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRecvKg" CssClass="form-control" runat="server" Text='<%# Bind("recv_total_kg") %>' MaxLength="16"></asp:TextBox>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Recv. Date">
                                            <ItemTemplate>
                                                <div style="position: relative;">
                                                    <asp:TextBox ID="txtRecvDate" CssClass="form-control" runat="server" Text='<%# Bind("receive_date") %>' MaxLength="10" Enabled="False"></asp:TextBox>
                                                    <a class="formCalndIcon" style="top: 4px; right: 5px;" id="Calender" runat="server">
                                                        <img src="images/p-calendar.png" id="Img1" alt="Calender" style="border: 0; position: relative;" />
                                                    </a>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                        </asp:TemplateField>

                                        <asp:BoundField HeaderText="Transporter" DataField="transporter_name">
                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                        </asp:BoundField>

                                    </Columns>

                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnSubmit" runat="server" Text="Receive" CssClass="btn btn-success btn-sm" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
