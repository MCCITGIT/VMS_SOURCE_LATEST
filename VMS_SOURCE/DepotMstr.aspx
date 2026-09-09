<%@ Page Title="Depot Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="DepotMstr.aspx.vb" Inherits="DepotMstr" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <script type="text/javascript" src="Scripts/ValidateDepotMstrJS.js?key=<%= DateTime.Now.ToString %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                __doPostBack(document.getElementById('imgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('imgbtnSearch').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <style type="text/css">
        .box-label {
            border: 1px solid #bfc9d3;
            border-radius: 8px;
            padding: 6px 12px;
            min-height: 0px;
            background-color: #fff;
            font-weight: 400;
            color: #24425c;
        }

        .box-label.textarea-label {
            min-height: 72px;
            white-space: pre-wrap;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Berger Location</h3>
                <p class="pageSubTitle">Maintain company location and depot details</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group pb-0">
                        <label class="form-control-label">Region:</label>
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="formField select2"></asp:DropDownList>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group pb-0">
                        <label class="form-control-label">Depot:</label>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlDepot" class="formField select2" runat="server" AutoPostBack="True" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <asp:Button ID="imgbtnBack" runat="server" Text="Back" CssClass="btn btn-secondary btn-sm" />
                </div>
            </div>
        </div>
    </div>
    <!-- Display lblErrorMessage below the card -->
    <div class="row">
        <div class="col-md-12">
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>
            <div class="card" runat="server" id="div1">
                <div class="card-body">
                    <legend style="font-size: 16px; font-weight: bold; padding: 0px; color: #333; margin-bottom: 15px;">Depot Details</legend>
                    <!-- Row for Address 1 and Address 2 -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Address 1:</label>
                                <label class="form-control-label box-label textarea-label" id="lblAddr1" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Address 2:</label>
                                <label class="form-control-label box-label textarea-label" id="lblAddr2" runat="server"></label>
                            </div>
                        </div>
                    </div>

                    <!-- Row for other details -->
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">City:</label>
                                <label class="form-control-label box-label" id="lblcity" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">State:</label>
                                <label class="form-control-label box-label" id="lblstate" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">PinCode:</label>
                                <label class="form-control-label box-label" id="lblpin" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Phone No:</label>
                                <label class="form-control-label box-label" id="lblphno" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">Email ID:</label>
                                <label class="form-control-label box-label" id="lblemail" runat="server"></label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group pb-0">
                                <label class="form-control-label">GSTN No:</label>
                                <label class="form-control-label box-label" id="lblgstn" runat="server"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript" src="Scripts/jquery.sumoselect.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.select2').select2();
        });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $('.select2').select2();
        });
    </script>
</asp:Content>
