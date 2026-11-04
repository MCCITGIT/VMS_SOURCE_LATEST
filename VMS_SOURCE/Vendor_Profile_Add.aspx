<%@ Page Title="Vendor Master - Add" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_Profile_Add.aspx.vb" Inherits="Vendor_Profile_Add" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <style type="text/css">
        .vms-yn-toggle {
            display: inline-flex;
            align-items: center;
            min-height: 32px;
            padding-top: 6px;
        }

            .vms-yn-toggle label {
                display: none;
            }

            .vms-yn-toggle input[type="checkbox"] {
                appearance: none;
                -webkit-appearance: none;
                width: 44px;
                height: 24px;
                margin: 0;
                background: #cbd5e1;
                border-radius: 24px;
                position: relative;
                cursor: pointer;
                outline: none;
                vertical-align: middle;
                transition: background 0.2s ease;
            }

                .vms-yn-toggle input[type="checkbox"]::after {
                    content: "";
                    position: absolute;
                    width: 18px;
                    height: 18px;
                    background: #fff;
                    border-radius: 50%;
                    top: 3px;
                    left: 3px;
                    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.25);
                    transition: transform 0.2s ease;
                }

                .vms-yn-toggle input[type="checkbox"]:checked {
                    background: #22a35a;
                }

                    .vms-yn-toggle input[type="checkbox"]:checked::after {
                        transform: translateX(20px);
                    }
    </style>
    <script src="Scripts/ValidateVendorUnitMaster.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {
                // button Search (F7 keypress)
                //	            if (ValidateVandorUnit())
                //{
                //__doPostBack(document.getElementById('btnSubmit').name,'');
                document.getElementById('btnSubmit').click()
                // }

            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
            else if (event.keyCode == 120) { // button Search (F9 keypress)
                __doPostBack(document.getElementById('btnReset').name, '');
            }
        }
        //-->
    </script>
    <script type="text/javascript">
        var cal1 = new CalendarPopup(); function scheme_effective_date_onclick() { }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Master - Add</h3>
                <p class="pageSubTitle">Create and maintain vendor records</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:Label ID="lblConfirmMsg" Visible="true" Style="color: Red; font-size: small; font-weight: bold;" runat="server"></asp:Label>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Vendor Source Code:<span id="lblGroup3" class="mandatory">*</span></label>
                                <div class="dFlexC">
                                    <asp:TextBox CssClass="form-control" ID="txtUnitCode" MaxLength="3" runat="server"></asp:TextBox>
                                    <asp:LinkButton ID="btnCheckUnitCode" runat="server" TabIndex="31" CssClass="btn btn-primary btn-sm">Check Unit Code</asp:LinkButton>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Name:<span id="lblGroup2" class="mandatory">*</span></label>
                                <asp:TextBox CssClass="form-control" ID="txtUnitName" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Region:</label>
                                <asp:DropDownList ID="ddlRegion" CssClass="form-control select2" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">E-mail:</label>
                                <asp:TextBox CssClass="form-control" ID="txtEmail" MaxLength="100" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address:<span id="Group1" class="mandatory">*</span></label>
                                <asp:TextBox CssClass="form-control" ID="txtLine1" MaxLength="30" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 02:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine2" MaxLength="30" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Residential Address 03:</label>
                                <asp:TextBox CssClass="form-control" ID="txtLine3" MaxLength="30" runat="server"></asp:TextBox>
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
                                <asp:TextBox CssClass="form-control" ID="txtState" MaxLength="20" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Pin:</label>
                                <asp:TextBox CssClass="form-control" ID="txtPin" MaxLength="6" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <h3 class="eachDtlsTitle">Registration Details</h3>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Sale Tax Reg. No.:</label>
                                <asp:TextBox CssClass="form-control" ID="txtSaleTaxRegNo" MaxLength="30" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">TIN No.:</label>
                                <asp:TextBox CssClass="form-control" ID="txtTINno" MaxLength="30" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">CENVAT Reg. No.:</label>
                                <asp:TextBox CssClass="form-control" ID="txtCENVATRegNo" MaxLength="100" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">CENVAT Reg. Date:</label>
                                <div id="divDate" runat="server">
                                    <asp:TextBox ID="txtbxdate" runat="server" CssClass="form-control" MaxLength="10" placeholder="DD/MM/YYYY"></asp:TextBox>
                                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtbxdate" Format="dd/MM/yyyy" />
                                  <%--  <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtbxdate,'txtbxdate','dd/MM/yyyy');">
                                        <img id="scheme_effective_date0" alt="Calender" src="images/date_icon.gif" style="border: 0" />
                                    </a>--%>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Allow Freight Cost:</label>
                                <div class="vms-yn-toggle">
                                    <asp:CheckBox ID="chkAllowFreight" runat="server" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Active:</label>
                                <div class="checkRadioGroup">
                                    <asp:RadioButton ID="rbtnActiveY" Text="Yes" GroupName="activeRadio" Checked="true" runat="server" />
                                    <asp:RadioButton ID="rbtnActiveN" Text="No" GroupName="activeRadio" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnReset" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div id="divErrorMessage"></div>
            <div class="row mt-3">
                <div class="col-md-12 text-center">
                    <asp:LinkButton ID="btnSubmit" TabIndex="31" runat="server" CssClass="btn btn-success btn-sm">Submit</asp:LinkButton>
                    <asp:LinkButton ID="btnCancel" TabIndex="32" runat="server" CssClass="btn btn-secondary btn-sm">Cancel</asp:LinkButton>
                    <asp:LinkButton ID="btnReset" TabIndex="33" runat="server" CssClass="btn btn-danger btn-sm">Reset</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
