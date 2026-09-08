<%@ Page Title="Test Result Entry" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TestCaseResultEntry.aspx.vb" Inherits="TestCaseResultEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/TestCaseResultEntryJs.js?key=<%= DateTime.Now.ToString %>"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
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

        //function validateSubmit() {
        //    debugger
        //    var isValid = true;
        //    var gridView = document.getElementById("gvTestList");
        //    if (gridView) {
        //        var rows = gridView.getElementsByTagName('tr');
        //        for (var i = 0; i < rows.length; i++) {
        //            var row = rows[i];

        //            var lblFrequency = row.querySelector('[id$="hdnFrequency"]');
        //            var Frequency = "";
        //            if (lblFrequency) {
        //                Frequency = lblFrequency.value;
        //            }

        //            var hdnTestType = row.querySelector('[id$="hdnTestType"]');
        //            var TestType = ""
        //            if (hdnTestType) {
        //                TestType = hdnTestType.value;
        //            }

        //            var txtResult = row.querySelector('[id$="txtResultValue"]');
        //            var txtResultVal = "";
        //            if (txtResult) {
        //                txtResultVal = txtResult.value;
        //            }

        //            var ddlResult = row.querySelector('[id$="ddlResultValue"]');
        //            ddlResultVal = "";
        //            if (ddlResult) {
        //                ddlResultVal = ddlResult.value;
        //            }

        //            if (Frequency == "F01") {
        //                let result_val = "";
        //                if (TestType == "TT02") {
        //                    result_val = ddlResultVal
        //                } else {
        //                    result_val = txtResultVal
        //                }
        //                if (result_val == "") {
        //                    row.style.backgroundColor = '#F08080';
        //                    isValid = false;
        //                }
        //            };
        //        };
        //    };

        //    if (isValid && confirm("Are you sure you want to submit?")) {
        //        isValid = true;
        //    }
        //    else {
        //        isValid = false;
        //    }

        //    return isValid;
        //};

        function oninputDecimal(ctrl) {
            ctrl.value = ctrl.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');
        };
    </script>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var currentDate = new Date();
            currentDate.setDate(currentDate.getDate() - 7);
            document.getElementById('txtBatchDate').setAttribute('min', currentDate.toISOString().split('T')[0]);
        });
    </script>
    <script>
            flatpickr("#<%= txtBatchDate.ClientID %>", {
                dateFormat: "d/m/y",
                minDate: "2026-09-01"
            });
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Test Result Entry</h3>
                <p class="pageSubTitle">Record results against quality test cases</p>
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
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="true" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Brand:</label>
                                <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:DropDownList ID="ddlProduct" ClientIDMode="Static" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3" style="display: none;">
                            <div class="form-group">
                                <label class="form-control-label">Upload File:</label>
                                <asp:FileUpload runat="server" ClientIDMode="Static" class="form-control" ID="FileUpload1" />
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                                <ContentTemplate>
                                    <asp:Button ID="btnUpload" ClientIDMode="Static" runat="server" ToolTip="Click to Upload File" Text="Upload" CssClass="btn btn-primary btn-sm" Visible="false" />
                                    <asp:Button ID="imgbtnAdd" ClientIDMode="Static" runat="server" ToolTip="Click to Download File" Text="Download" CssClass="btn btn-success btn-sm" Visible="false" />
                                    <asp:Button ID="btnReset" ClientIDMode="Static" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel6">
                                    <ContentTemplate>
                                        <label class="form-control-label">Shade:</label>
                                        <asp:TextBox ID="txtShade" ClientIDMode="Static" runat="server" CssClass="form-control"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel7">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch No:</label>
                                        <asp:TextBox ID="txtBatchNo" ClientIDMode="Static" runat="server" CssClass="form-control"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel8">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch Date:</label>
                                        <asp:TextBox ID="txtBatchDate" ClientIDMode="Static" runat="server" CssClass="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                            <RowStyle CssClass="tlrowlight" />
                                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="headerGrid" />
                                            <FooterStyle CssClass="footerGrid" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Slno." ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSlno" Text='<%# Bind("slno") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Test Name" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblTestName" Text='<%# Bind("test_name") %>' runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnTestId" Value='<%# Bind("test_id") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnTestType" Value='<%# Bind("test_type") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnFrequency" Value='<%# Bind("frequency_code") %>' />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Frequency" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ref Value" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Actual" ControlStyle-Width="90%">
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hdnResultValue" Value='<%# Bind("result_value")%>' runat="server" />
                                                        <asp:DropDownList runat="server" class="form-control" ID="ddlResultValue" Visible="false"></asp:DropDownList>
                                                        <asp:TextBox runat="server" class="form-control" ID="txtResultValue" Visible="false"></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action" ControlStyle-Width="100%" Visible="false">
                                                    <HeaderTemplate>
                                                        <span>View</span>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:Panel runat="server" ID="pnlValid" Visible="false"><i class="fas fa-check-circle checkIcon"></i></asp:Panel>
                                                        <asp:Panel runat="server" ID="pnlInvalid" Visible="false"><i class="fas fa-times-circle crossIcon"></i></asp:Panel>
                                                        <%--<asp:Button ID="imgBtnSubmit" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandName="EditTest"></asp:Button>--%>
                                                    </ItemTemplate>
                                                    <ControlStyle Width="100%"></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <%--<asp:AsyncPostBackTrigger ControlID="btnUpload" EventName="Click" />--%>
                                    <asp:PostBackTrigger ControlID="gvTestList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-md-12 text-center">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel9">
                                <ContentTemplate>
                                    <asp:HiddenField ID="hdnId" ClientIDMode="Static" runat="server" />
                                    <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" ToolTip="Submit" Text="Submit" CssClass="btn btn-success btn-sm" OnClientClick="return validateSubmit();" />
                                    <asp:Button ID="btnBack" ClientIDMode="Static" runat="server" ToolTip="Back" Text="Back" CssClass="btn btn-dark btn-sm" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel10">
                        <ContentTemplate>
                            <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
