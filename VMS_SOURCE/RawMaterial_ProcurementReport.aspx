<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterial_ProcurementReport.aspx.vb" Inherits="RawMaterial_ProcurementReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript">var cal1 = new CalendarPopup();</script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else if (validateRawMaterialRequisitionSubmit()) {
                    document.getElementById('btnSubmit').disabled = true;
                    __doPostBack(document.getElementById('btnSubmit').name, '');
                }
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }
        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <div class="rm-module rm-compact rm-rawmaterial-list rm-procurement-report">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material Procurement Report</h3>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor Name:</label>
                                    <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-control select2" TabIndex="1"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-control-label">Supplier:</label>
                                    <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group rm-date-field">
                                    <label class="form-control-label">From Date:</label>
                                    <asp:TextBox ID="txtFromDate" ClientIDMode="Static" CssClass="form-control" MaxLength="10" TabIndex="3" runat="server" autocomplete="off"></asp:TextBox>
                                    <asp:CalendarExtender ID="CalendarExtender1" CssClass="OpenCalender" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy" PopupPosition="BottomLeft" Animated="false" />
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group rm-date-field">
                                    <label class="form-control-label">To Date:</label>
                                    <asp:TextBox ID="txtTodate" ClientIDMode="Static" CssClass="form-control" MaxLength="10" TabIndex="4" runat="server" autocomplete="off"></asp:TextBox>
                                    <asp:CalendarExtender ID="CalendarExtender2" CssClass="OpenCalender" runat="server" TargetControlID="txtTodate" Format="dd/MM/yyyy" PopupPosition="BottomLeft" Animated="false" />
                                </div>
                            </div>
                        </div>
                        <div class="row rm-report-actions">
                            <div class="col-md-12 text-center">
                                <asp:Button ID="btnSubmit" CssClass="btn btn-success btn-sm" runat="server" Text="Generate" TabIndex="5" OnClick="btnSubmit_Click" />
                                <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" TabIndex="6" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:Label ID="lblErrMsg" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                                <div id="divErrorMessage"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSubmit" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

</asp:Content>

