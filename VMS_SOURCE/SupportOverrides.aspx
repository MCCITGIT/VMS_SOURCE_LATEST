<%@ Page Title="Support Overrides" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="SupportOverrides.aspx.vb" Inherits="SupportOverrides" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .so-desc { font-size: 11.5px; color: #666; margin-top: 4px; min-height: 16px; }
        .so-status { display: inline-block; padding: 1px 8px; border-radius: 10px; font-size: 11px; font-weight: 600; color: #fff; }
        .so-Active { background: #28a745; }
        .so-Scheduled { background: #17a2b8; }
        .so-Expired { background: #6c757d; }
        .so-Disabled { background: #dc3545; }
        .so-warn { background: #fff3cd; border: 1px solid #ffeeba; color: #856404; padding: 6px 10px; border-radius: 4px; font-size: 12px; margin-bottom: 8px; }
        .field-invalid { border: 1px solid #dc3545 !important; }
        .dispatch-field-error { display: block; color: #dc3545; font-size: 12px; font-weight: 500; margin-top: 4px; }
        .dispatch-field-error:empty { display: none; }
    </style>

    <div class="rm-module">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Support Overrides</h3>
                    <p class="pageSubTitle">Temporary exceptions and runtime switches - no code change or deployment needed</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:Panel ID="pnlDenied" runat="server" Visible="false" CssClass="card">
            <div class="card-body">
                <h5 style="color: #dc3545;">Support Overrides - access denied</h5>
                <asp:Literal ID="litDenied" runat="server"></asp:Literal>
                <a href="Home.aspx" class="btn btn-secondary btn-sm">Back to Home</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlContent" runat="server">
        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-life-ring"></i></span>
                    <div>
                        <h5 class="mst-panel-title"><asp:Literal ID="litFormTitle" runat="server" Text="Add override"></asp:Literal></h5>
                        <p class="mst-panel-subtitle">Changes take effect within one minute. Every change is logged with your user id.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="so-warn"><i class="fas fa-exclamation-triangle"></i>&nbsp; An override bypasses a business check. Always give a date range for unit exceptions and write the ticket / reason in Remarks.</div>
                <asp:HiddenField ID="hdnId" runat="server" />
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-control-label">Override:<span class="mandatory">*</span></label>
                            <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged"></asp:DropDownList>
                            <div class="so-desc"><asp:Literal ID="litDesc" runat="server"></asp:Literal></div>
                            <asp:Label ID="valType" runat="server" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Unit / Vendor:<asp:Label ID="lblScopeReq" runat="server" CssClass="mandatory" Text="*"></asp:Label></label>
                            <asp:DropDownList ID="ddlScope" runat="server" CssClass="form-control select2"></asp:DropDownList>
                            <asp:TextBox ID="txtScope" runat="server" CssClass="form-control" Visible="false" MaxLength="50" AutoComplete="Off" Placeholder="Unit code, e.g. V02 (blank = all)"></asp:TextBox>
                            <asp:Label ID="valScope" runat="server" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-control-label">Value:<asp:Label ID="lblValueReq" runat="server" CssClass="mandatory" Text="*"></asp:Label></label>
                            <asp:TextBox ID="txtValue" runat="server" CssClass="form-control" MaxLength="100" AutoComplete="Off"></asp:TextBox>
                            <asp:Label ID="valValue" runat="server" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-control-label">Valid From - To:</label>
                            <div style="display: flex; gap: 6px;">
                                <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <asp:Label ID="valDates" runat="server" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div class="form-group">
                            <label class="form-control-label">Remarks / ticket / reason:<span class="mandatory">*</span></label>
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" MaxLength="500" AutoComplete="Off"></asp:TextBox>
                            <asp:Label ID="valRemarks" runat="server" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-3" style="display: flex; align-items: flex-end; gap: 6px; padding-bottom: 16px;">
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary btn-sm" OnClick="btnSave_Click" OnClientClick="return rmConfirmPostback('btnSave', 'submit');" ClientIDMode="Static" />
                        <asp:Button ID="btnReset" runat="server" Text="Clear" CssClass="btn btn-secondary btn-sm" OnClick="btnReset_Click" />
                    </div>
                </div>
                <asp:Label ID="lblErrorMessage" runat="server" ClientIDMode="Static" CssClass="errormsg" Style="font-size: 11px; font-weight: bold;"></asp:Label>
            </div>
        </div>

        <div class="card">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Overrides</h5>
                        <p class="mst-panel-subtitle">Active = in force now. Scheduled / Expired = outside the date range. Disabled = switched off.</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="False" CssClass="table table-hover upgradDataGrid" EmptyDataText="No overrides defined." GridLines="Both" DataKeyNames="so_id">
                        <RowStyle CssClass="tlrowlight" />
                        <HeaderStyle CssClass="headerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate><span class='so-status so-<%# Eval("status") %>'><%# Eval("status") %></span></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="7%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Override">
                                <ItemTemplate><%# TypeLabel(Eval("so_key")) %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="scope_name" HeaderText="Unit / Vendor" ItemStyle-Width="12%" />
                            <asp:BoundField DataField="so_value" HeaderText="Value" ItemStyle-Width="7%" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="so_valid_from" HeaderText="From" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="8%" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="so_valid_to" HeaderText="To" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="8%" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="so_remarks" HeaderText="Remarks" />
                            <asp:TemplateField HeaderText="Changed by">
                                <ItemTemplate><%# Eval("modified_by") %><%# If(Eval("modified_by") Is DBNull.Value, Eval("created_by"), "") %><br /><small><%# String.Format("{0:dd/MM/yyyy HH:mm}", If(Eval("modified_on") Is DBNull.Value, Eval("created_on"), Eval("modified_on"))) %></small></ItemTemplate>
                                <ItemStyle Width="11%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("so_id") %>' CssClass="text-primary mr-2" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
                                    <asp:LinkButton ID="btnDisable" runat="server" CommandName="Disable" CommandArgument='<%# Eval("so_id") %>' CssClass="text-danger" ToolTip="Disable now"
                                        Visible='<%# Eval("so_active_yn").ToString() = "Y" %>' OnClientClick="return rmConfirmAction(this, 'update');"><i class="fas fa-power-off"></i></asp:LinkButton>
                                    <asp:LinkButton ID="btnEnable" runat="server" CommandName="Enable" CommandArgument='<%# Eval("so_id") %>' CssClass="text-success" ToolTip="Enable"
                                        Visible='<%# Eval("so_active_yn").ToString() <> "Y" %>' OnClientClick="return rmConfirmAction(this, 'update');"><i class="fas fa-check-circle"></i></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="7%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        </asp:Panel>
    </div>
</asp:Content>
