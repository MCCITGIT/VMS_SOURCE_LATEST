<%@ Page Title="Legal Score" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="vrs_legal_score.aspx.vb" Inherits="vrs_legal_score" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateLegalScore.js"></script>
    <script type="text/javascript">
        function isNumeric(event, element) {
            debugger;
            var charCode = event.which ? event.which : event.keyCode;

            // Allow numbers (0-9)
            if (charCode >= 48 && charCode <= 57) {
                return true;
            }

            // Allow only one decimal point (.)
            if (charCode === 46) {
                if (element.value.includes(".")) {
                    return false; // Prevent multiple decimals
                }
                return true;
            }
            // Prevent minus (-) key (charCode 45)
            if (charCode === 45) {
                return false;
            }

            // Prevent all other characters
            return false;
        }

        function validateObtainedScore(input) {
            var maxScore = parseFloat(input.closest('tr').querySelector('[id$="hdnTargetScore"]').value);

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
                alert('Obtained Score cannot be greater than Target Score.');
                input.value = '';
            }
        }
    </script>

    <style>
        .p-vrs-legal-table td:has(a[title="Download Document"]) {
            display: flex;
            width: 100% !important;
            gap: 4px;
            align-items: center;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Legal Score</h3>
                <p class="pageSubTitle">Legal compliance scores used in vendor rating</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Fin Year:</label>
                                <asp:DropDownList ID="ddlFinYear" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">Quarter:</label>
                                <asp:DropDownList ID="ddlquartor" class="form-control select2" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlvendor" class="form-control select2" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-4 form-btn-mt">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel8">
                                <ContentTemplate>
                                    <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />

                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <asp:Label ID="lblError" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card" runat="server" id="div2" visible="false">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Legal Score</h5>
                            <p class="mst-panel-subtitle">Legal compliance scores used in vendor rating</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive p-vrs-legal-table" style="max-height: 300px; overflow-y: auto;">
                                <asp:GridView ID="gvLegalScoreList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid" OnRowDataBound="gvLegalScoreList_RowDataBound">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Slno.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSlno" Text='<%# Bind("parameter_code") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Legal and Statutory Requirements Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblParameterName" Text='<%# Bind("parameter_name") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnParameterCode" Value='<%# Bind("parameter_code") %>' />
                                                <asp:HiddenField runat="server" ID="hdnparamshortname" Value='<%# Bind("parameter_short_name") %>' />
                                                <asp:HiddenField runat="server" ID="hdnParameterName" Value='<%# Bind("parameter_name") %>' />
                                                <asp:HiddenField runat="server" ID="hdnVlsObligation" Value='<%# Bind("vlm_obligation") %>' />
                                                <asp:HiddenField runat="server" ID="hdnenableYN" Value='<%# Bind("enable") %>' />
                                                <asp:HiddenField runat="server" ID="hdnsubmitbutton" Value='<%# Bind("submitbutton") %>' />
                                                <asp:HiddenField runat="server" ID="hdnconfirmbutton" Value='<%# Bind("confirmbutton") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendor obligation">
                                            <ItemTemplate>
                                                <asp:Label ID="lblObligation" Text='<%# Bind("vlm_obligation") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnObligation" Value='<%# Bind("vlm_obligation") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Availability">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAvailability" Text='<%# Bind("vlm_availability") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnAvailability" Value='<%# Bind("vlm_availability") %>' />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%" />
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Target Score">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTargetScore" Text='<%# Bind("vlsm_score") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnTargetScore" Value='<%# Bind("vlsm_score") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Obtained Score">
                                            <ItemTemplate>
                                                <asp:TextBox runat="server" class="form-control" ID="txtObtainedScore" onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                                                    oninput="validateObtainedScore(this);" Style="text-align: right;" Text='<%# Bind("obt_score") %>' Enabled="false" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Valid From Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtValidFromDate" runat="server" class="form-control" MaxLength="10" TextMode="Date" Text='<%# Bind("valid_from") %>'></asp:TextBox>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Valid Till Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtValidDate" runat="server" class="form-control" MaxLength="10" TextMode="Date" Text='<%# Bind("valid_till") %>'></asp:TextBox>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issuing Authority">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtIssueAuthority" runat="server" class="form-control" AutoComplete="off" Text='<%# Bind("valid_auth") %>'></asp:TextBox>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Upload Document">
                                            <ItemTemplate>

                                                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                                                <asp:HiddenField runat="server" ID="hdnFilePath" Value='<%# Bind("file_path") %>' />
                                                <asp:Label ID="lblFileName" Text="" runat="server" Visible="False" />

                                                <asp:LinkButton ID="lnkDownload" runat="server"
                                                    CommandArgument='<%# Eval("file_path") %>'
                                                    OnCommand="lnkDownload_Command"
                                                    Visible='<%# Not String.IsNullOrEmpty(Eval("file_path").ToString()) %>'
                                                    ToolTip="Download Document"
                                                    CausesValidation="false"
                                                    UseSubmitBehavior="false"><i class="fa fa-download" style="color:#3adede;"></i></asp:LinkButton>

                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="20%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server"
                                                    Text='<%# Eval("status") %>'
                                                    Style="font-size: 14px;" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-3">
                        <asp:Button ID="btnSubmit" runat="server" Visible="false" Text="Save" CssClass="btn btn-primary btn-sm" />
                        <asp:Button ID="btnConSub" runat="server" Text="Save & Submit" CssClass="btn btn-warning btn-sm" />
                        <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" />
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnConSub" />
            <asp:PostBackTrigger ControlID="btnSubmit" />
            <asp:PostBackTrigger ControlID="gvLegalScoreList" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
