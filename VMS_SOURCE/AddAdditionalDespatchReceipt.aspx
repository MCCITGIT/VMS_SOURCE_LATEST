<%@ Page Title="Add Additional Despatch Receipt" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="AddAdditionalDespatchReceipt.aspx.vb" Inherits="AddAdditionalDespatchReceipt" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script src="Scripts/ValidationAdditionalDespatchReceipt.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {

                // button Add (F7 keypress)
                document.getElementById("btnSubmit").click();
                //__doPostBack(document.getElementById('btnSubmit').name, '');	            
            }
            else if (event.keyCode == 119) {
                document.getElementById("btnCancel").click();
                //__doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <script type="text/javascript">
        var cal1 = new CalendarPopup();
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Add Additional Despatch Receipt</h3>
                <p class="pageSubTitle">Record receipts against an existing despatch</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan No:</label>
                                <asp:Label ID="lblChallanNo" runat="server" CssClass="labelDataPoint" Text="(Auto-Generated)"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan Date:<span id="Span1" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtChallanDate" ClientIDMode="Static" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                                <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtChallanDate,'ChallanDate','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="ChallanDate" alt="Calender" style="border: 0" />
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:<span id="Span5" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlRegion" ClientIDMode="Static" runat="server" CssClass="form-control select2" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Source:<span id="Span2" class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlSource" ClientIDMode="Static" CssClass="form-control select2" runat="server">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlRegion" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:<span id="Span3" class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlProcessYear" CssClass="form-control select2" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:<span id="Span4" class="mandatory">*</span></label>
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
                                <label class="form-control-label">Transporter Name:<span id="Span7" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtTransporterName" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="30"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Road Permit No.:<span id="Span8" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtRoadPermitNo" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="30"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Truck No.:<span id="Span9" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtTruckNo" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Challan No.:<span id="Span10" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtCenvatNo" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="20"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vednor Challan Date:<span id="Span11" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtCenvatDate" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                                <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtCenvatDate,'CenvatDate','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="CenvatDate" alt="Calender" style="border: 0" />
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Received Ltr:<span id="Span12" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtReceivedLtr" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="16" Text="0.00"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Received Kg:<span id="Span13" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtReceivedKg" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="16" Text="0.00"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Receipt Date:<span id="Span14" class="mandatory">*</span></label>
                                <asp:TextBox ID="txtReceiptDate" ClientIDMode="Static" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                                <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtReceiptDate,'ReceiptDate','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="ReceiptDate" alt="Calender" style="border: 0" />
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-success btn-sm" />
                                <asp:Button ID="btnCancel" ClientIDMode="Static" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-sm" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
