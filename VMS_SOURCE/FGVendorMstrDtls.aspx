<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FGVendorMstrDtls.aspx.vb" Inherits="FGVendorMstrDtls" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .rm-module .form-control.field-invalid,
        .rm-module textarea.form-control.field-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .fg-vendor-code-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .fg-vendor-code-row .form-control {
                flex: 1;
                min-width: 0;
            }

            .fg-vendor-code-row .btn {
                white-space: nowrap;
                flex: 0 0 auto;
            }
    </style>
    <div class="rm-module">
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {              
                document.getElementById('btnSubmit').click()             
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
            else if (event.keyCode == 120) { // button Search (F9 keypress)
                __doPostBack(document.getElementById('btnReset').name, '');
            }
        }       
    </script>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">FG Vendor Master - Add</h3>
                <p class="pageSubTitle">Create and maintain vendor records</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Label ID="lblConfirmMsg" Visible="true" Style="color: Red; font-size: small; font-weight: bold;" runat="server"></asp:Label>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-truck"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Vendor Details</h5>
                            <p class="mst-panel-subtitle">Basic identification for the FG vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor :<span id="lblGroup1" class="mandatory">*</span></label>
                                <div class="fg-vendor-code-row">
                                     <asp:DropDownList ID="ddlVendor" ClientIDMode="Static" CssClass="form-control select2" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged"></asp:DropDownList>
                                </div>
                            </div>
                        </div>                      
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Name:<span id="lblGroup2" class="mandatory">*</span></label>
                                <asp:TextBox CssClass="form-control" ID="txtUnitName" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>                        
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-map-marker-alt"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Address Details</h5>
                            <p class="mst-panel-subtitle">Registered address of the vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine1" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 02:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine2" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 03:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine3" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 04:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine4" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>                        
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">City:</label>
                                <asp:TextBox CssClass="form-control" ID="txtCity" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">State:</label>
                                <asp:TextBox CssClass="form-control" ID="txtState" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">District:</label>
                                <asp:TextBox CssClass="form-control" ID="txtdistrict" ReadOnly="true" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Pin:</label>
                                <asp:TextBox CssClass="form-control" ID="txtPin" MaxLength="6" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-map-marker-alt"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Site Details</h5>
                            <p class="mst-panel-subtitle">Registered site deatisl of the vendor</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Site Id:</label>
                                <asp:TextBox CssClass="form-control" ID="txtsiteid" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Site Code:</label>
                                <asp:TextBox CssClass="form-control" ID="txtsitecode" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>                       
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                    <div class="row mt-3">
                        <div class="col-md-12 text-center">
                            <asp:LinkButton ID="btnSubmit" TabIndex="31" runat="server" ClientIDMode="Static" CssClass="btn btn-success btn-sm" OnClientClick="return rmConfirmAction(this, 'submit');">Submit</asp:LinkButton>
                            <asp:LinkButton ID="btnCancel" TabIndex="32" runat="server" CssClass="btn btn-secondary btn-sm">Cancel</asp:LinkButton>
                            <asp:LinkButton ID="btnReset" TabIndex="33" runat="server" CssClass="btn btn-danger btn-sm">Reset</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>
