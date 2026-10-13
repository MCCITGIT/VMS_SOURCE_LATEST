<%@ Page Title="Factory Applicable Vendor" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FactoryApplicableVendor.aspx.vb" Inherits="FactoryApplicableVendor" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>
    <script type="text/javascript">
        function validateObtainedScore(input) {
            var maxScore = parseFloat(input.closest('tr').querySelector('[id$="hdnMaxScore"]').value);

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
                alert('Obtained Score cannot be greater than Max Score.');
                input.value = '';
            }
        }

        function Submit() {
            return confirm("Are you sure you want to submit?");
        }

        function confirmSubmit() {
            return confirm("Are you sure to confirm? Once submitted, you cannot modify it.");
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Factory Applicable Vendor</h3>
                <p class="pageSubTitle">Map vendors applicable to each factory</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <!-- Factory Dropdown -->
                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="form-control-label">Factory:</label>
                                <asp:UpdatePanel runat="server" ID="UpdatePanelFactory">
                                    <ContentTemplate>
                                        <asp:DropDownList
                                            ID="ddlFactory"
                                            runat="server"
                                            CssClass="form-control select2"
                                            AutoPostBack="True">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-1">
                            <asp:Button
                                ID="btnSearch"
                                runat="server"
                                Text="Search"
                                CssClass="btn btn-sm btn-primary"
                                Style="margin-top: 19px" />
                        </div>
                    </div>
                    <div class="mst-panel-header" style="padding: 15px 0px 0px 0px;">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">Factory Applicable Vendor</h5>
                                <p class="mst-panel-subtitle">Map vendors applicable to each factory</p>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-2" id="vendorRow" runat="server">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="form-control-label">Vendors:</label>
                                <asp:UpdatePanel runat="server" ID="UpdatePanelVendors">
                                    <ContentTemplate>
                                        <div class="CheckBoxList" style="max-height: 300px; overflow-y: auto;">
                                            <asp:CheckBoxList
                                                ID="cblVendors"
                                                runat="server"
                                                CssClass="form-check checkbox-spacing"
                                                RepeatLayout="Table"
                                                RepeatDirection="Horizontal"
                                                RepeatColumns="3"
                                                style="padding-left: 0 !important;">
                                            </asp:CheckBoxList>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-12 d-flex justify-content-center">
                            <asp:UpdatePanel runat="server" ID="UpdatePanelButtons">
                                <ContentTemplate>
                                    <asp:Button
                                        ID="btnSubmit"
                                        runat="server"
                                        Text="Submit"
                                        CssClass="btn btn-success btn-sm mx-2" />
                                    <asp:Button
                                        ID="btnBack"
                                        runat="server"
                                        Text="Back"
                                        CssClass="btn btn-danger btn-sm mx-2" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>

                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
