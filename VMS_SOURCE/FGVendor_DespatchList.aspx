<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FGVendor_DespatchList.aspx.vb" Inherits="FGVendor_DespatchList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('<%= imgbtnSearch.ClientID %>').name, '');
            }
        }
        function disableBackButton() {
            window.history.forward(1);
        }
        window.onload = disableBackButton;
    </script>
    <style type="text/css">
        .rm-confirm-title {
            margin: 0 0 8px;
            color: #111827;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        .rm-confirm-text {
            margin: 0 0 22px;
            color: #64748b;
            font-size: 14px;
            line-height: 1.45;
            white-space: pre-line;
        }

        .rm-confirm-dialog.is-error .rm-confirm-title {
            color: #e11d48;
        }

        .rm-confirm-dialog.is-error .rm-confirm-text {
            text-align: left;
            color: #e11d48 !important;
            font-weight: 600;
        }

        .rm-confirm-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

            .rm-confirm-actions .btn {
                min-width: 110px;
            }

        .rm-module #lblErrorMessage,
        .rm-module span[id$="lblErrorMessage"] {
            display: none !important;
        }

        .rm-module .rm-stat-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .rm-module .rm-stat-card {
            background: #eff2f5;
            border: 1px solid #eee8de;
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 8px 22px rgba(80, 60, 30, 0.06);
            min-height: 96px;
        }

        .rm-module .rm-stat-icon {
            width: 22px;
            height: 22px;
            margin-bottom: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

            .rm-module .rm-stat-icon.is-blue {
                color: #2f6fed;
            }

            .rm-module .rm-stat-icon.is-orange {
                color: #e7a23a;
            }

            .rm-module .rm-stat-icon.is-green {
                color: #22a35a;
            }

            .rm-module .rm-stat-icon.is-red {
                color: #e11d48;
            }

        .rm-module .rm-stat-label {
            margin: 0 0 4px 0;
            color: #7d8899;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .rm-module .rm-stat-value {
            margin: 0;
            color: #111827;
            font-size: 32px;
            line-height: 1;
            font-weight: 800;
        }

            .rm-module .rm-stat-value.is-green {
                color: #15803d;
            }

            .rm-module .rm-stat-value.is-red {
                color: #e11d48;
            }

        .rm-compact .rm-grid-actions {
            padding-top: 8px;
            text-align: center;
            flex-shrink: 0;
        }

        .rm-compact .rm-stat-value.is-orange {
            color: #d9822b;
        }

        .rm-compact .rm-add-form-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .rm-compact .rm-add-form-controls .form-control {
                flex: 1 1 auto;
                min-width: 0;
            }

            .rm-compact .rm-add-form-controls .btn {
                margin: 0 !important;
                height: 36px;
                min-width: 88px;
            }

        .rm-compact .rm-stat-row {
            flex: 1 1 58%;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            margin-bottom: 0;
        }

        .rm-compact .rm-stat-card {
            min-height: 0;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-radius: 12px;
        }

        .rm-compact .rm-stat-icon {
            margin-bottom: 0;
            font-size: 20px;
            width: 24px;
            height: 20px;
        }

        .rm-compact .rm-stat-label {
            margin: 0;
            font-size: 10px;
        }

        .rm-compact .rm-stat-value {
            font-size: 20px;
        }

        .rm-compact .rm-list-fill {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            min-height: 0;
            margin-bottom: 0;
        }

            .rm-compact .rm-list-fill .card-body {
                flex: 1 1 auto;
                overflow: auto;
                padding-top: 8px;
                display: flex;
                flex-direction: column;
                min-height: 0;
            }

        .rm-card,
        .rm-metric-card,
        .rm-upload-box,
        .rm-list-card,
        .rm-status-badge,
        .rm-stat-card {
            transition: box-shadow 0.22s ease, border-color 0.22s ease, background-color 0.22s ease, transform 0.22s ease;
        }

            .rm-metric-card:hover,
            .rm-stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 22px rgba(80, 60, 30, 0.08);
            }
    </style>

    <div class="rm-module rm-compact">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Dispatch List</h3>
                    <p class="pageSubTitle">Review incoming dispatch requests, monitor vendor status and open individual requests for further processing.</p>
                </div>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <div class="rm-filter-stats-row">
                            <div class="rm-filter-fields">
                                <div class="rm-filter-inline">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Supplier:</label>
                                        <asp:DropDownList ID="ddlRawMatvendor" ClientIDMode="Static" CssClass="form-control select2" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Status:</label>
                                        <asp:DropDownList ID="ddlStatus" ClientIDMode="Static" CssClass="form-control select2" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="rm-filter-actions">
                                        <asp:LinkButton CssClass="btn btn-primary btn-sm rm-btn-icon" ID="imgbtnSearch" runat="server" ClientIDMode="Static" ToolTip="Search"><i class="fas fa-search"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="rm-stat-row">
                                <div class="rm-stat-card">
                                    <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                    <div>
                                        <p class="rm-stat-label">Total</p>
                                        <p class="rm-stat-value">
                                            <asp:Label ID="lblTotalRequests" runat="server" Text="0"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="rm-stat-card">
                                    <div class="rm-stat-icon is-orange"><i class="fas fa-clock"></i></div>
                                    <div>
                                        <p class="rm-stat-label">Pending</p>
                                        <p class="rm-stat-value is-orange">
                                            <asp:Label ID="lblPendingRequests" runat="server" Text="0"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="rm-stat-card">
                                    <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                                    <div>
                                        <p class="rm-stat-label">Approved</p>
                                        <p class="rm-stat-value is-green">
                                            <asp:Label ID="lblCompletedRequests" runat="server" Text="0"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    </div>
                </div>

                <div class="card">
                    <div class="mst-panel-header">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Recent Dispatch Requests</h5>
                                <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:GridView
                                        ID="gvDispatchList"
                                        runat="server"
                                        AutoGenerateColumns="false"
                                        AllowPaging="true"
                                        PageSize="10"
                                        Visible="true"
                                        BorderWidth="0"
                                        CssClass="table table-hover upgradDataGrid"
                                        EmptyDataText="No dispatch requests found."
                                        PagerSettings-Mode="NumericFirstLast"
                                        PagerSettings-PageButtonCount="5"
                                        PagerSettings-FirstPageText="First"
                                        PagerSettings-LastPageText="Last">

                                        <RowStyle CssClass="tlrowlight" />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />

                                        <Columns>
                                            <asp:TemplateField HeaderText="SR. NO." HeaderStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSrl" runat="server" Text='<%# (gvDispatchList.PageIndex * gvDispatchList.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" Width="10%" />
                                                <ItemStyle HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="REQUEST ID" HeaderStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <span class="request-id-wrap">
                                                        <i class="fas fa-file-alt"></i>
                                                        #<asp:Label ID="lblReqId" runat="server" CssClass="request-id-text" Text='<%# Bind("orh_Id") %>'></asp:Label>
                                                    </span>
                                                    <asp:HiddenField runat="server" ID="hdnReqId" Value='<%# Bind("orh_Id") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" Width="16%" />
                                                <ItemStyle HorizontalAlign="Left" Width="16%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="VENDOR" HeaderStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <div class="vendor-cell">
                                                        <div>
                                                            <div class="vendor-name">
                                                                <asp:Label ID="lblVendor" runat="server" Text='<%# Bind("unit_name") %>'></asp:Label>
                                                            </div>
                                                            <div class="vendor-sub">Vendor</div>
                                                        </div>
                                                    </div>
                                                    <asp:HiddenField runat="server" ID="hdnVendorCode" Value='<%# Bind("orh_vendor_code") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" Width="42%" />
                                                <ItemStyle HorizontalAlign="Left" Width="42%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="REQUEST DATE" HeaderStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblReqDate" runat="server" Text='<%# Bind("created_date") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" Width="18%" />
                                                <ItemStyle HorizontalAlign="Left" Width="18%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="ACTION" HeaderStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <div style="display: flex; align-items: center; justify-content: center;">
                                                        <asp:LinkButton
                                                            runat="server"
                                                            ID="lbtnDetails"
                                                            Text=""
                                                            OnClick="lbtnDetails_Click"
                                                            ToolTip="View Details"
                                                            CssClass="grid-action">
                                                <i class="fas fa-arrow-right"></i>
                                                        </asp:LinkButton>

                                                        <asp:Label
                                                            runat="server"
                                                            ID="lblcheck"
                                                            CssClass="status-complete"
                                                            ToolTip="Completed"
                                                            Visible="false">
                                                <i class="fas fa-check"></i>
                                                        </asp:Label>
                                                    </div>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="14%" />
                                                <ItemStyle HorizontalAlign="Center" Width="14%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                                    <asp:PostBackTrigger ControlID="gvDispatchList" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
