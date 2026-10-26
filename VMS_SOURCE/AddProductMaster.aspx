<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="AddProductMaster.aspx.vb" Inherits="AddProductMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .form-control.field-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12);
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .errormsg {
            font-size: 13px;
        }
    </style>
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
            if (event.keyCode == 118) { // button Add (F7 keypress)
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    // button Add (F7 keypress)
                    validateSKUList();
                }
                //__doPostBack(document.getElementById('btnSubmit').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>
    <script type="text/javascript" src="Scripts/ValidateAddUpdate_ProductMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>

    <div class="rm-module rm-compact rm-brand-master">
        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Brand Master</h3>
                    <p class="pageSubTitle">Maintain brand details</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="rm-add-stats-row">
                    <div class="rm-add-form">
                        <div class="form-group mb-0">
                            <label class="form-control-label">Brand Name:<span id="Span2" class="mandatory">*</span></label>
                            <div class="rm-add-form-controls">
                                <asp:TextBox ID="txtBrandName" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearBrandValidation();" Placeholder="Enter Here"></asp:TextBox>
                                <asp:HiddenField ID="txtBrandId" ClientIDMode="Static" runat="server" />
                                <asp:Button ID="btnSubmit" ClientIDMode="Static" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-danger btn-sm" OnClick="btnReset_Click" />
                            </div>
                            <asp:Label ID="valBrandName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                    </div>
                    <div class="rm-stat-row mt-2">
                        <div class="rm-stat-card">
                            <div class="rm-stat-icon is-blue"><i class="fas fa-layer-group"></i></div>
                            <div>
                                <p class="rm-stat-label">Total</p>
                                <p class="rm-stat-value">
                                    <asp:Label ID="lblTotalBrands" runat="server" Text="0"></asp:Label>
                                </p>
                            </div>
                        </div>
                        <div class="rm-stat-card">
                            <div class="rm-stat-icon is-green"><i class="fas fa-check-circle"></i></div>
                            <div>
                                <p class="rm-stat-label">Active</p>
                                <p class="rm-stat-value is-green">
                                    <asp:Label ID="lblActiveBrands" runat="server" Text="0"></asp:Label>
                                </p>
                            </div>
                        </div>
                        <div class="rm-stat-card">
                            <div class="rm-stat-icon is-red"><i class="fas fa-times-circle"></i></div>
                            <div>
                                <p class="rm-stat-label">Inactive</p>
                                <p class="rm-stat-value is-red">
                                    <asp:Label ID="lblInactiveBrands" runat="server" Text="0"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 10px; font-weight: bold; color: red;" Text=""></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <div class="card rm-list-fill">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">Brand List</h5>
                        <p class="mst-panel-subtitle">All brands currently available for product mapping</p>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive rm-grid-scroll">
                    <asp:GridView CssClass="table table-hover upgradDataGrid" CellSpacing="0" CellPadding="0"
                        ID="gvbrandDetails" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Visible="true"
                        ShowFooter="false" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5"
                        PagerSettings-FirstPageText="First" PagerSettings-LastPageText="Last">
                        <RowStyle CssClass="tlrowlight" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />
                        <Columns>
                            <asp:TemplateField HeaderText="Sl No">
                                <ItemTemplate>
                                    <asp:Label ID="lblbrandid" runat="server" Text='<%# (gvbrandDetails.PageIndex * gvbrandDetails.PageSize) + Container.DataItemIndex + 1 %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" CssClass="text-center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Brand Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblbrandname" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label>
                                    <asp:HiddenField ID="hdnBrandId" runat="server" Value='<%# Bind("brand_id") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="62%" CssClass="text-left" />
                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="62%" CssClass="text-left" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblactiveText" runat="server" CssClass='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "rm-status-pill is-active", "rm-status-pill is-inactive") %>' Text='<%# IIf(UCase(Trim(CStr(Eval("active")))) = "Y", "Active", "Inactive") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlactive" CssClass="form-control form-control-sm rm-status-ddl" runat="server">
                                        <asp:ListItem Text="Active" Value="Y"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="N"></asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" CssClass="text-center" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" CssClass="text-center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" CommandName="Edit" runat="server" CssClass="text-info" ToolTip="Edit"><i class="fas fa-edit"></i></asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="btnUpdate" CommandName="Update" CssClass="text-success mr-1" runat="server" ToolTip="Update" OnClientClick="return rmConfirmStatusUpdate(this);"><i class="fas fa-check"></i></asp:LinkButton>
                                    <asp:LinkButton ID="btncancel" CommandName="Cancel" CssClass="text-danger" runat="server" ToolTip="Cancel"><i class="fas fa-times"></i></asp:LinkButton>
                                </EditItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="12%" CssClass="text-center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
</asp:Content>

