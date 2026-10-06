<%@ Page Title="Test Result Entry" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="DeviationsFGQuality.aspx.vb" Inherits="DeviationsFGQuality" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>
    <script type="text/javascript">
        function showRejectPopup() {
            document.getElementById('<%= pnlRejectPopup.ClientID %>').style.display = 'flex';
        }

        function hideRejectPopup() {
            document.getElementById('<%= pnlRejectPopup.ClientID %>').style.display = 'none';
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


        function validateSubmit() {
            debugger
            var isValid = true;
            var gridView = document.getElementById("gvTestList");
            if (gridView) {
                var rows = gridView.getElementsByTagName('tr');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];

                    var lblFrequency = row.querySelector('[id$="hdnFrequency"]');
                    var Frequency = "";
                    if (lblFrequency) {
                        Frequency = lblFrequency.value;
                    }

                    var hdnTestType = row.querySelector('[id$="hdnTestType"]');
                    var TestType = ""
                    if (hdnTestType) {
                        TestType = hdnTestType.value;
                    }

                    var txtResult = row.querySelector('[id$="txtResultValue"]');
                    var txtResultVal = "";
                    if (txtResult) {
                        txtResultVal = txtResult.value;
                    }

                    var ddlResult = row.querySelector('[id$="ddlResultValue"]');
                    ddlResultVal = "";
                    if (ddlResult) {
                        ddlResultVal = ddlResult.value;
                    }

                    if (Frequency == "F01") {
                        let result_val = "";
                        if (TestType == "TT02") {
                            result_val = ddlResultVal
                        } else {
                            result_val = txtResultVal
                        }
                        if (result_val == "") {
                            row.style.backgroundColor = '#F08080';
                            isValid = false;
                        }
                        else {
                            row.style.backgroundColor = 'white';
                            isValid = true;
                        }
                    };
                };
            };

            var gridView2 = document.getElementById("gvExteriorTestList");
            if (gridView2) {
                var rows = gridView2.getElementsByTagName('tr');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];

                    var lblFrequency = row.querySelector('[id$="hdnFrequency"]');
                    var Frequency = "";
                    if (lblFrequency) {
                        Frequency = lblFrequency.value;
                    }

                    var hdnTestType = row.querySelector('[id$="hdnTestType"]');
                    var TestType = ""
                    if (hdnTestType) {
                        TestType = hdnTestType.value;
                    }

                    var txtResult = row.querySelector('[id$="txtResultValue"]');
                    var txtResultVal = "";
                    if (txtResult) {
                        txtResultVal = txtResult.value;
                    }

                    var ddlResult = row.querySelector('[id$="ddlResultValue"]');
                    ddlResultVal = "";
                    if (ddlResult) {
                        ddlResultVal = ddlResult.value;
                    }

                    if (Frequency == "F01") {
                        let result_val = "";
                        if (TestType == "TT02") {
                            result_val = ddlResultVal
                        } else {
                            result_val = txtResultVal
                        }
                        if (result_val == "") {
                            row.style.backgroundColor = '#F08080';
                            isValid = false;
                        }
                        else {
                            row.style.backgroundColor = 'white';
                            isValid = true;
                        }
                    };
                };
            };


            if (isValid && confirm("Are you sure you want to submit?")) {
                isValid = true;
            }
            else {
                isValid = false;
            }

            return isValid;
        };


        function confirmSubmit() {
            return confirm("Are you sure to confirm? Once confirmed, you cannot modify it.");
        }

        function oninputDecimal(ctrl) {
            ctrl.value = ctrl.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');
        };

        function validateObtainedScore(input, event) {
            var value = input.value;
            debugger
            var testType = row.querySelector('[id$="hdnTestType"]');

            if (event.key === "Backspace") {
                return;
            }

            if (testType === "TT03") {
                if (!/^[a-zA-Z0-9]*$/.test(value)) {
                    alert('Please enter a valid alphanumeric value.');
                    input.value = '';
                    return;
                }
            } else {
                if (value === "") {
                    alert('Please enter a number.');
                    return;
                }

                if (isNaN(value)) {
                    alert('Please enter a valid number.');
                    input.value = '';
                    return;
                }
            }
        }

        // Attach event listener for 'keydown' event
        //document.querySelector('input').addEventListener('keydown', function (event) {
        //    validateObtainedScore(this, event);
        //});

    </script>
    <%--<script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var currentDate = new Date();
            currentDate.setDate(currentDate.getDate() - 7);
            document.getElementById('txtBatchDate').setAttribute('min', currentDate.toISOString().split('T')[0]);
        });
    </script>--%>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Deviations in FG quality</h3>
                <p class="pageSubTitle">Log deviations found in finished goods quality</p>
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
                                <asp:UpdatePanel runat="server" ID="UpdatePanel12">
                                    <ContentTemplate>
                                        <label class="form-control-label">Fin Year:</label>
                                        <asp:DropDownList ID="ddlFinYear" class="form-control form-control-sm select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel4">
                                    <ContentTemplate>
                                        <label class="form-control-label">Quarter:</label>
                                        <asp:DropDownList ID="ddlQuarter" class="form-control select2" runat="server" AutoPostBack="true" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel5">
                                    <ContentTemplate>
                                        <label class="form-control-label">Vendor:</label>
                                        <asp:DropDownList ID="ddlVendor" class="form-control select2" runat="server" AutoPostBack="true" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                                    <ContentTemplate>
                                        <label class="form-control-label">Brand:</label>
                                        <asp:DropDownList ID="ddlBrand" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlBrand_SelectedIndexChanged" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3" style="display: none;">
                            <div class="form-group">
                                <label class="form-control-label">Upload File:</label>
                                <asp:FileUpload runat="server" class="form-control" ID="FileUpload1" />
                            </div>
                        </div>
                        <div class="col-md-12" style="text-align: center;">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                                <ContentTemplate>
                                    <asp:Button ID="btnUpload" runat="server" ToolTip="Click to Upload File" Text="Upload" CssClass="btn btn-primary btn-sm" Visible="false" />
                                    <asp:Button ID="imgbtnAdd" runat="server" ToolTip="Click to Download File" Text="Download" CssClass="btn btn-success btn-sm" Visible="false" />
                                    <asp:Button ID="btnSearch" runat="server" ToolTip="Click to Search" Text="Search" CssClass="btn btn-success btn-sm" />
                                    <asp:Button ID="btnReset" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:UpdatePanel runat="server" ID="UpdatePanel6">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlProduct" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged" />
                                        <asp:HiddenField runat="server" ID="hdnProduct" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>

                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-control-label">SKU:</label>
                                <asp:UpdatePanel runat="server" ID="UpdatePanel7">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlSku" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSku_SelectedIndexChanged" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel8">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch No:</label>
                                        <asp:TextBox ID="txtBatchNo" runat="server" class="form-control"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <%--<div class="col-md-2">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel12">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch Date:</label>
                                        <asp:TextBox ID="txtBatchDate" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>--%>
                    </div>
                    <div class="mst-panel-header" style="padding: 10px 0;">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Deviations in FG quality</h5>
                                <p class="mst-panel-subtitle">Log deviations found in finished goods quality</p>
                            </div>
                        </div>
                    </div>
                    <%--<div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-control-label">Product:</label>
                                <asp:UpdatePanel runat="server" ID="UpdatePanel4">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlProduct" class="form-control" runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnProduct" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel6">
                                    <ContentTemplate>
                                        <label class="form-control-label">Shade:</label>
                                        <asp:TextBox ID="txtShade" runat="server" class="form-control"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel7">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch No:</label>
                                        <asp:TextBox ID="txtBatchNo" runat="server" class="form-control"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel8">
                                    <ContentTemplate>
                                        <label class="form-control-label">Batch Date:</label>
                                        <asp:TextBox ID="txtBatchDate" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>--%>
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
                                                <asp:TemplateField HeaderText="Sl no.">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSlno" Text='<%# Bind("slno") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Test Name">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblTestName" Text='<%# Bind("test_name") %>' runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnTestId" Value='<%# Bind("test_id") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnTestType" Value='<%# Bind("test_type") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnFrequency" Value='<%# Bind("frequency_code") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnStatus" Value='<%# Bind("status") %>' />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Left" />
                                                    <ItemStyle HorizontalAlign="Left" Width="40%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Frequency">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ref Value">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Actual">
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hdnResultValue" Value='<%# Bind("result_value")%>' runat="server" />
                                                        <asp:DropDownList runat="server" class="form-control" ID="ddlResultValue" Visible="false"></asp:DropDownList>
                                                        <asp:TextBox runat="server" class="form-control" ID="txtResultValue" Visible="false" oninput="validateObtainedScore(this);"></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Qualify Y/N">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStatus" Style="font-weight: bold" Text='<%# Bind("status")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action" Visible="false">
                                                    <HeaderTemplate>
                                                        <span>View</span>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:Panel runat="server" ID="pnlValid" Visible="false"><i class="fas fa-check-circle checkIcon"></i></asp:Panel>
                                                        <asp:Panel runat="server" ID="pnlInvalid" Visible="false"><i class="fas fa-times-circle crossIcon"></i></asp:Panel>
                                                        <%--<asp:Button ID="imgBtnSubmit" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandName="EditTest"></asp:Button>--%>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
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
                        <div class="col-md-12">
                            <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                                <ContentTemplate>
                                    <asp:HiddenField runat="server" ID="hdnpackSize" />
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvExteriorTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                            <RowStyle CssClass="tlrowlight" />
                                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="headerGrid" />
                                            <FooterStyle CssClass="footerGrid" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sl no.">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSlno" Text='<%# Bind("slno") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Test Name">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblTestName" Text='<%# Bind("test_name") %>' runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnTestId" Value='<%# Bind("test_id") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnTestType" Value='<%# Bind("test_type") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnFrequency" Value='<%# Bind("frequency_code") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnStatus" Value='<%# Bind("status") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnSkuVale" Value='<%# Bind("refSkuValue") %>' />

                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Left" />
                                                    <ItemStyle HorizontalAlign="Left" Width="40%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Frequency">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ref Value">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Actual">
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hdnResultValue" Value='<%# Bind("result_value")%>' runat="server" />
                                                        <asp:DropDownList runat="server" class="form-control" ID="ddlResultValue" Visible="false"></asp:DropDownList>
                                                        <asp:TextBox runat="server" class="form-control" ID="txtResultValue" Visible="false" oninput="validateObtainedScore(this);"></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Qualify Y/N">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStatus" Style="font-weight: bold" Text='<%# Bind("status")%>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action" Visible="false">
                                                    <HeaderTemplate>
                                                        <span>View</span>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:Panel runat="server" ID="pnlValid" Visible="false"><i class="fas fa-check-circle checkIcon"></i></asp:Panel>
                                                        <asp:Panel runat="server" ID="pnlInvalid" Visible="false"><i class="fas fa-times-circle crossIcon"></i></asp:Panel>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="gvExteriorTestList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-12 text-center">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel9">
                                <ContentTemplate>
                                    <asp:HiddenField ID="hdnId" runat="server" />
                                    <asp:Button ID="btnSubmit" runat="server" ToolTip="Save" Text="Save" CssClass="btn btn-success btn-sm" OnClientClick="return validateSubmit();" />
                                    <asp:Button ID="btnConsubmit" runat="server" ToolTip="Save & Submit" Text="Save & Submit" CssClass="btn btn-warning btn-sm" OnClientClick="return confirmSubmit();" />
                                    <asp:Button ID="btnApprove" runat="server" ToolTip="Approve" Text="Approve" CssClass="btn btn-primary btn-sm" />
                                    <%--<asp:Button ID="btnReject" runat="server" ToolTip="Reject" Text="Reject" CssClass="btn btn-danger btn-sm" />--%>
                                    <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-danger btn-sm"
                                        OnClientClick="showRejectPopup(); return false;" />

                                    <asp:Button ID="btnBack" runat="server" ToolTip="Back" Text="Back" CssClass="btn btn-dark btn-sm" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel10">
                        <ContentTemplate>
                            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:Panel ID="pnlRejectPopup" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Reject Remarks</h5>
                            <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>--%>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Enter Remarks:</label>
                                        <asp:TextBox ID="txtRejectRemarks" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Enter remarks..." />
                                    </div>
                                </div>
                            </div>
                            <asp:Label ID="lblPopupError" runat="server" ForeColor="Red" Visible="false" />
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnSubmitRemarks" runat="server" Text="Submit" CssClass="btn btn-success" />
                            <asp:Button ID="btnClosePopup" runat="server" Text="Close" CssClass="btn btn-secondary" OnClientClick="hideRejectPopup(); return false;" />
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
