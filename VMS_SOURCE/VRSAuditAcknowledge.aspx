<%@ Page Title="Vendor Audit Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VRSAuditAcknowledge.aspx.vb" Inherits="VRSAuditAcknowledge" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>

    <script type="text/javascript">
        function confirmRemove() {
            return confirm("Are you sure you want to remove?");
        }
    </script>

    <script type="text/javascript">
        function validateObtainedScore(input) {
            var maxScore = parseFloat(input.closest('tr').querySelector('[id$="hdnMaxScore"]').value);

            var obtainedScore = input.value;
            if (obtainedScore === "") {
                return;
            }
            if (isNaN(obtainedScore)) {
                alert('Please enter a valid number.');
                input.value = '';
                return;
            }

            obtainedScore = parseFloat(obtainedScore);

            if (obtainedScore > maxScore) {
                alert('Obtained Score cannot be greater than Max Score.');
                input.value = '';
            }
        }

        function Submit() {
            return confirm("Are you sure you want to submit?");
        }

        function confirmSubmit() {
            return confirm("Are you sure to confirm? Once submitted, you cannot modify it.");
        }
    </script>
    <style type="text/css">
        .Progressoverlay {
            position: fixed;
            z-index: 999;
            height: 100%;
            width: 100%;
            top: 0;
            background-color: Black;
            filter: alpha(opacity=60);
            opacity: 0.6;
            -moz-opacity: 0.8;
        }

        .modal-popup {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 10000;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content-custom {
            background-color: #fff;
            padding: 0px;
            border-radius: 6px;
            width: 80%;
            max-height: 90%;
            overflow-y: auto;
        }

        .modal-header-custom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #408967;
            padding: 10px 20px;
        }

            .modal-header-custom h5 {
                margin: 0px;
                padding: 0px;
                color: #FFF;
                font-size: 16px;
                line-height: 19px;
                letter-spacing: 0.3px;
            }

        .close-btn {
            background: #FFF;
            border: none;
            font-size: 25px;
            color: #ff0000;
            font-weight: bold;
            padding: 0px 0px 5px 0px;
            line-height: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            margin: 0px;
        }

        .modal-body-custom {
            font-size: 12px; /* Smaller font size for content */
            padding: 20px;
        }
    </style>
    <%-- <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
   <%-- <asp:UpdateProgress ID="updProgress" runat="server" DisplayAfter="0">
        <ProgressTemplate>
            <div class="pageLoader">
                <div class="innerLoader">
                    <img class="loaderImg" alt="progress" src="images/ajax-loader.gif" />
                    <p class="loaderTx">Processing... Please Wait.</p>\
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Audit Details</h3>
                <p class="pageSubTitle">Acknowledge audit findings raised against vendors</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6" style="display: flex; column-gap: 20px;">
                    <div class="form-group" style="width: 100%;">
                        <label class="form-control-label">Fin Year:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel5">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlFinYear" class="form-control form-control-sm select2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="form-group" style="width: 100%;">
                        <label class="form-control-label">Quarter:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlQuarter" class="form-control form-control-sm select2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlQuarter_SelectedIndexChanged" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor:</label>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel4">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendor" class="form-control form-control-sm select2" runat="server" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                        <ContentTemplate>
                            <asp:Button ID="btnSearch" runat="server" ToolTip="Click to Search" Text="Search" CssClass="btn btn-primary btn-sm" />&nbsp;
                                    <asp:Button ID="btnReset" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />
                            <asp:Button ID="btnExport" runat="server" ToolTip="Click to Reset" Text="Export" OnClick="btnExport_Click" CssClass="btn btn-success btn-sm" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnExport" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">Vendor Audit List</h5>
                    <p class="mst-panel-subtitle">Acknowledge audit findings raised against vendors</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div style="max-height: 200px; overflow-y: auto;">
                                <asp:GridView ID="gvAuditList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0" CellSpacing="0" CellPadding="0">
                                    <RowStyle CssClass="tlrowlight" />
                                    <SelectedRowStyle />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Parameter Type">
                                            <ItemTemplate>
                                                <asp:Label ID="lblParameterType" Text='<%# Bind("ap_parameter_type")%>' runat="server" />
                                                <asp:HiddenField runat="server" ID="lblPId" Value='<%# Bind("ap_p_id") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Parameter Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblParameterName" Text='<%# Bind("ap_parameter_name")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Max Score">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMaxScore" Text='<%# Bind("ap_max_score")%>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnMaxScore" Value='<%# Bind("ap_max_score") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Obtained Score">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtObtainedScore" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("ah_obtained_score") %>' oninput="validateObtainedScore(this);" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Remarks">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAuditRemarks" Text='<%# Bind("ah_remarks")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" Width="40%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="gvAuditList" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>

            <div class="row mt-2">
                <div class="col-md-12 text-center">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel9">
                        <ContentTemplate>
                            <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm ml-2" OnClick="btnBack_Click" />
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
</asp:Content>




