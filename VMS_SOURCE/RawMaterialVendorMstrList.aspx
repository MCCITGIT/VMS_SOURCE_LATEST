<%@ Page Title="Raw Material Vendor Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="RawMaterialVendorMstrList.aspx.vb" Inherits="RawMaterialVendorMstrList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>

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
                /*padding-top: 8px;*/
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
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                __doPostBack(document.getElementById('ImgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="rm-module rm-compact rm-vendor-mstr-list">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Raw Material Vendor Master</h3>
                    <p class="pageSubTitle">Browse and manage raw material vendors</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <asp:UpdatePanel ID="UpdatePanelFilter" runat="server">
            <ContentTemplate>
                <div class="card">
                    <div class="card-body">
                        <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-control-label">Vendor Name:</label>
                                    <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-6 form-btn-mt">
                                <div class="rm-filter-actions">
                                    <asp:LinkButton ID="imgbtnSearch" runat="server" CssClass="btn btn-primary btn-sm" ClientIDMode="Static" OnClick="imgbtnSearch_Click" ToolTip="Search">Search</asp:LinkButton>
                                    <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="ImgbtnAdd_Click" ToolTip="Add">Add</asp:LinkButton>
                                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="rm-stat-row mt-2">
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                                <div>
                                    <p class="rm-stat-label">Total</p>
                                    <p class="rm-stat-value">
                                        <asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                                <div>
                                    <p class="rm-stat-label">Active</p>
                                    <p class="rm-stat-value is-green">
                                        <asp:Label ID="lblActiveCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                            <div class="rm-stat-card">
                                <div class="rm-stat-icon is-red"><i class="fas fa-times-circle"></i></div>
                                <div>
                                    <p class="rm-stat-label">Inactive</p>
                                    <p class="rm-stat-value is-red">
                                        <asp:Label ID="lblInactiveCount" runat="server" Text="0"></asp:Label>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="card rm-list-fill">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Vendor List</h5>
                        <p class="mst-panel-subtitle">All raw material vendors currently on record</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <asp:UpdatePanel ID="UpdatePanelGrid" runat="server">
                        <ContentTemplate>
                            <asp:GridView BorderWidth="1" CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                                ID="gvRawMatVendorDetails" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true"
                                ShowFooter="false" GridLines="both" EmptyDataText="No records found"
                                PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                                PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last"
                                OnRowCommand="gvRawMatVendorDetails_RowCommand">
                                <RowStyle CssClass="tlrowlight" />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSlNo" runat="server" Text='<%# (gvRawMatVendorDetails.PageIndex * gvRawMatVendorDetails.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="4%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Vendor Code">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorCode" runat="server" Text='<%# Bind("vendor_code") %>'></asp:Label>
                                            <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Vendor Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="12%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="GST No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGstNo" runat="server" Text='<%# Bind("gst_no") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Address">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAddress" runat="server" Text='<%# Bind("address") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="16%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Contact Person">
                                        <ItemTemplate>
                                            <asp:Label ID="lblContactPerson" runat="server" Text='<%# Bind("contact_person") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Mobile No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMobileNo" runat="server" Text='<%# Bind("mobile_no") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEmailId" runat="server" Text='<%# Bind("email") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="14%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" CssClass='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# If(Convert.ToString(Eval("active")).Trim().ToUpper() = "Y", "Active", "Inactive") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <div style="display: flex; align-items: center; justify-content: center">
                                                <asp:LinkButton ID="btnEdit" runat="server" Visible="true" Text="Edit" CommandName="EditVendor" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Edit"><i class="fa fa-edit"></i></asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnReset" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="ddlVendor" EventName="SelectedIndexChanged" />
                            <asp:PostBackTrigger ControlID="gvRawMatVendorDetails" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
