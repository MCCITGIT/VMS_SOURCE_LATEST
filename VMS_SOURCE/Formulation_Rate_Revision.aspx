<%@ Page Title="Formulation Rate Revision" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Formulation_Rate_Revision.aspx.vb" Inherits="Formulation_Rate_Revision" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="rm-module rm-compact rsm-page frm-rate-revision">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript">
            function checkAllFormulation(checkbox) {
                var list = document.getElementById('cblFormulation');
                if (!list) return;
                var boxes = list.getElementsByTagName('input');
                for (var i = 0; i < boxes.length; i++) {
                    if (boxes[i].type === 'checkbox') boxes[i].checked = checkbox.checked;
                }
            }
        </script>
        <style type="text/css">
            .frm-rate-revision .CheckBoxList {
                max-height: 360px;
                overflow-y: auto;
                padding: 10px 12px 12px;
            }
            .frm-rate-revision .CheckBoxList .checkAll {
                display: block;
                margin: 0 0 12px 0;
            }
            .frm-rate-revision #cblFormulation {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
                gap: 12px 28px;
                list-style: none;
                margin: 0;
                padding: 0;
                width: 100%;
            }
            .frm-rate-revision #cblFormulation li {
                display: flex;
                align-items: flex-start;
                min-width: 0;
            }
            .frm-rate-revision #cblFormulation input[type="checkbox"] {
                width: 16px;
                height: 16px;
                margin: 2px 8px 0 0;
                flex-shrink: 0;
            }
            .frm-rate-revision #cblFormulation label {
                font-weight: 500;
                color: #495057;
                font-size: 12px;
                line-height: 16px;
                margin: 0;
                white-space: normal;
            }
        </style>
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Formulation Rate Revision</h3>
                    <p class="pageSubTitle">Manage formulation rates vendor wise</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-3" id="colVendorFilter" runat="server">
                        <div class="form-group">
                            <label class="form-control-label">Vendor:</label>
                            <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label class="form-control-label">Formulation:</label>
                            <div class="CheckBoxList">
                                <asp:CheckBox ID="chkSelectAll" ClientIDMode="Static" runat="server" CssClass="checkAll" Text="Select All" onclick="checkAllFormulation(this)" />
                                <asp:CheckBoxList ID="cblFormulation" ClientIDMode="Static" runat="server"
                                    RepeatLayout="UnorderedList" RepeatDirection="Vertical" Width="100%" AutoPostBack="False">
                                </asp:CheckBoxList>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-btn-mt">
                        <asp:LinkButton ID="btnApprove" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="btnApprove_Click" ToolTip="Let the vendor change the rates of the selected formulations"> Give permission
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-danger btn-sm" ClientIDMode="Static" ToolTip="Back" OnClick="btnBack_Click">Back
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
