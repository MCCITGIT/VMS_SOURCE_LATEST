<%@ Page Title="Legal Score" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="vrs_legal_score_appr_reject.aspx.vb" Inherits="vrs_legal_score_appr_rej" %>

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

        function checkAll(evnt) {
            debugger
            var theGridView = document.getElementById("gvLegalScoreList");
            for (var rowno = 1; rowno < theGridView.rows.length; rowno++) {
                var chkbxcntrl_id = theGridView.rows[rowno].cells[0].children[0].id;
                //  console.log(chkbxcntrl_id, "checkbox id");
                if (chkbxcntrl_id != null && chkbxcntrl_id != '') {
                    document.getElementById(chkbxcntrl_id).checked = document.getElementById(evnt.id).checked;
                }
            }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Legal Score Approval</h3>
                <p class="pageSubTitle">Approve or reject submitted legal scores</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="btnUpd" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Fin Year:</label>
                                <asp:DropDownList ID="ddlFinYear" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Quarter:</label>
                                <asp:DropDownList ID="ddlquartor" class="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlquartor_SelectedIndexChanged" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" class="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Unit:</label>
                                <asp:DropDownList ID="ddlvendor" class="form-control select2" runat="server">
                                </asp:DropDownList>

                            </div>
                        </div>
                        <div class="col-md-12 form-btn-mt text-center">
                            <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                            <asp:LinkButton ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" CausesValidation="false" />
                            <asp:Button ID="btnExport" runat="server" ToolTip="Click to Reset" Text="Export" OnClick="btnExport_Click" CssClass="btn btn-success btn-sm" />
                        </div>
                    </div>
                    <asp:Label ID="lblError" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>
            <div class="card" runat="server" id="div2" visible="false">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Legal Score Approval</h5>
                            <p class="mst-panel-subtitle">Approve or reject submitted legal scores</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                <ContentTemplate>
                                    <div style="height: calc(100vh - 290px); overflow-y: auto;">
                                        <%--    <asp:UpdatePanel ID="UpdatePanelgv" runat="server">
                                            <ContentTemplate>--%>
                                        <asp:HiddenField runat="server" ID="hdnFilecount" Value="0" />
                                        <asp:GridView ID="gvLegalScoreList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                            AllowPaging="true" PageSize="20" CssClass="upgradDataGrid" border="1" CellSpacing="0"
                                            CellPadding="0" OnRowDataBound="gvLegalScoreList_RowDataBound">
                                            <RowStyle CssClass="tlrowlight" Font-Strikeout="False" />
                                            <SelectedRowStyle />
                                            <%--<AlternatingRowStyle CssClass="tlrowdark" />--%>
                                            <HeaderStyle CssClass="headerGrid" HorizontalAlign="Center" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="#">
                                                    <HeaderTemplate>
                                                        <asp:CheckBox ID="chkSelectAll" runat="server" onclick="checkAll(this);" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnstatus" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="3%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Slno.">
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hdnparamcode" runat="server" Value='<%# Bind("parameter_code") %>' />
                                                        <asp:Label ID="lblSlno" Text='<%# Bind("parameter_code") %>' runat="server" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="3%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Legal and Statutory Requirements Status">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblParameterName" Text='<%# Bind("parameter_name") %>' runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnParameterCode" Value='<%# Bind("parameter_code") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnParameterName" Value='<%# Bind("parameter_name") %>' />
                                                        <asp:HiddenField runat="server" ID="hdnVlsObligation" Value='<%# Bind("vlm_obligation") %>' />

                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Left" />
                                                    <ItemStyle HorizontalAlign="Left" Width="20%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Vendor obligation">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblObligation" Text='<%# Bind("vlm_obligation") %>' runat="server" />
                                                        <asp:HiddenField runat="server" ID="hdnObligation" Value='<%# Bind("vlm_obligation") %>' />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Availability">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlAvailability" class="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlAvailability_SelectedIndexChanged" />
                                                        <asp:HiddenField runat="server" ID="hdnAvailability" Value='<%# Bind("vlm_availability") %>' />
                                                    </ItemTemplate>
                                                    <ControlStyle Height="90%" Width="90%" />
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="9%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Target Score">
                                                    <ItemTemplate>
                                                        <asp:TextBox class="form-control form-control-sm" ID="txtTargetScore" runat="server" Style="text-align: right;" Text='<%# Bind("vlsm_score") %>' Enabled="false" />
                                                        <asp:HiddenField runat="server" ID="hdnTargetScore" Value='<%# Bind("vlsm_score") %>' />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Obtained Score">
                                                    <ItemTemplate>
                                                        <asp:TextBox runat="server" class="form-control form-control-sm" ID="txtObtainedScore" onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                                                            oninput="validateObtainedScore(this);" Style="text-align: right;" Text='<%# Bind("obt_score") %>' Enabled="false" />
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Valid From Date">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtValidFromDate" runat="server" class="form-control form-control-sm" MaxLength="10" TextMode="Date" Enabled="false" Text='<%# Bind("valid_from") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Valid Till Date">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtValidDate" runat="server" class="form-control form-control-sm" MaxLength="10" TextMode="Date" Enabled="false" Text='<%# Bind("valid_till") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="4%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Issuing Authority">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtIssueAuthority" runat="server" class="form-control form-control-sm" AutoComplete="off" Enabled="false" Text='<%# Bind("valid_auth") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="14%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Upload Document">
                                                    <ItemTemplate>
                                                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control form-control-sm" Visible="false" />

                                                        <asp:HiddenField runat="server" ID="hdnFilePath" Value='<%# Bind("file_path") %>' />
                                                        <asp:Label ID="lblFileName" Text="" runat="server" Visible="False" />

                                                        <asp:LinkButton ID="lnkDownload" runat="server"
                                                            CommandArgument='<%# Eval("file_path") %>'
                                                            OnCommand="lnkDownload_Command"
                                                            Visible='<%# Not String.IsNullOrEmpty(Eval("file_path").ToString()) %>'
                                                            CausesValidation="false"
                                                            UseSubmitBehavior="false"><i class="fa fa-download" style="color:#3adede;"></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="7%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Status">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStatus" runat="server"
                                                            Text='<%# If(Eval("status") = "P", "Pending", If(Eval("status") = "Y", "Approved", If(Eval("status") = "N", "Rejected", Eval("status")))) %>'
                                                            Style="font-size: 14px;" />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Remarks">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtrejRemarks" runat="server" class="form-control form-control-sm" Text='<%# Bind("remarks") %>' AutoComplete="off"></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ControlStyle></ControlStyle>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                </asp:TemplateField>


                                                <%-- <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <div style="white-space: nowrap;">
                                                            <asp:LinkButton ID="btnApprove" runat="server" Text="Approve"
                                                                CssClass="btn btn-success btn-sm"
                                                                Style="padding: 2px 8px; font-size: 12px;"
                                                                CommandArgument='<%# Eval("parameter_code") %>'
                                                                CommandName="LegalApprove"
                                                                CausesValidation="false" />

                                                            <asp:Button ID="btnReject" runat="server" Text="Reject"
                                                                CssClass="btn btn-danger btn-sm"
                                                                Style="padding: 2px 8px; font-size: 12px;"
                                                                UseSubmitBehavior="false" CommandName="LegalReject" />

                                                            <asp:Panel ID="pnlRemarks" runat="server" Visible="false"
                                                                Style="min-width: 50px; max-width: 80px; word-wrap: break-word; white-space: normal;">
                                                                <asp:Label ID="lblRemarks" runat="server"
                                                                    Text='<%# Eval("remarks") %>'
                                                                    Style="font-size: 13px;" />
                                                            </asp:Panel>
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" Width="9%" />
                                                </asp:TemplateField>--%>
                                            </Columns>
                                        </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="gvLegalScoreList" />
                                </Triggers>

                                <%-- <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnApprove" EventName="Click" />
                                              </Triggers>--%>
                            </asp:UpdatePanel>
                            <!-- Remarks Modal -->

                            <%-- <div id="customRemarksModal" class="custom-modal-overlay">
                                            <div class="custom-modal">
                                                <div class="custom-modal-header">Enter Rejection Remarks</div>
                                                <div>
                                                    <asp:HiddenField ID="hdnRejectParamCode" runat="server" />
                                                    <asp:HiddenField ID="hdnRejectTargetScore" runat="server" />
                                                    <asp:HiddenField ID="hdnAvl" runat="server" />
                                                    <asp:TextBox ID="txtRejectRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" Width="100%" placeholder="Enter remarks..." />
                                                    <asp:RequiredFieldValidator ID="rfvRemarks" runat="server" ControlToValidate="txtRejectRemarks"
                                                        ErrorMessage="Remarks are required." CssClass="text-danger" Display="Dynamic" />
                                                </div>
                                                <div class="custom-modal-footer">
                                                    <asp:Button ID="btnSubmitRemarks" runat="server" CssClass="btn btn-danger" Text="Reject" OnClick="btnSubmitRemarks_Click" />
                                                    <asp:Button ID="btnBack" runat="server" CssClass="btn btn-dark" Text="Cancel"
                                                        OnClientClick="closeRemarksModal(); return false;" />
                                                </div>
                                            </div>
                                        </div>--%>
                        </div>
                        <div class="text-center mt-2">
                            <asp:LinkButton ID="btnApprove" runat="server" Text="Approve" CausesValidation="false" Visible="true" CssClass="btn btn-success btn-sm" OnClick="btnApprove_Click" />
                            <asp:Button ID="btnReject" runat="server" Text="Reject" CausesValidation="false" Visible="true" CssClass="btn btn-danger btn-sm" OnClick="btnReject_Click" />
                            <asp:Button ID="btnDownloadDoc" runat="server" Text="Download All" CausesValidation="false" CssClass="btn btn-info btn-sm" OnClick="btnDownloadDoc_Click" />
                            <asp:LinkButton ID="btnCancel" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" CausesValidation="false" />

                        </div>
                        <%--  </ContentTemplate>
                                        <Triggers>
                                            <asp:PostBackTrigger ControlID="gvLegalScoreList" />
                                           
                                        </Triggers>
                                    </asp:UpdatePanel>--%>
                    </div>
                </div>
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
            <asp:PostBackTrigger ControlID="btnDownloadDoc" />

        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
