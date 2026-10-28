<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeFile="QC_ChemicalProductLiking.aspx.vb" Inherits="QC_ChemicalProductLiking" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <link href="includes/qc-chemical-product-liking-cards.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Scripts/ChemicalProductLinking.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
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

        function validateObtainedScore(input) {
            // var maxScore = parseFloat(input.closest('tr').querySelector('[id$="hdnMaxScore"]').value);

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


        }

        <%-- function checkAllProduct(checkbox) {
            var cbl = document.getElementById('<%=chkbxListApplProducts.ClientID%>').getElementsByTagName("input");
            for (i = 0; i < cbl.length; i++) cbl[i].checked = checkbox.checked;
        }--%>

    </script>
    <link type="text/css" rel="Stylesheet" href="includes/select2.min.css" />


    <script type="text/javascript" src="Scripts/BrandProductLinking.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>




    <div class="cpl-page">

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Add Chemical Product Linking - Details</h3>
                    <p class="pageSubTitle">Browse and manage user profiles</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="row cpl-filter">
                    <div class="col-md-4">
                        <div class="form-group mb-0">
                            <label class="form-control-label">Product:</label>
                            <asp:DropDownList ID="ddlproduct" class="form-control form-control-sm select2" AutoPostBack="true" OnSelectedIndexChanged="ddlproduct_SelectedIndexChanged" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <%--<div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Search Text:</label>
                                <input type="text" class="form-control form-control-sm" id="searchInput" placeholder="Type to search..." oninput="searchText()">
                            </div>
                        </div>--%>
                </div>
            </div>
        </div>

        <div class="card rm-list-fill">
            <div class="card-body cpl-panel-body">
                <div class="cpl-card-wrap">
                    <asp:GridView ID="gvChemicalList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                        AllowPaging="true" PageSize="20" CssClass="gv-cards" BorderWidth="0" GridLines="None" CellSpacing="0"
                        CellPadding="0" ShowHeader="true" OnRowDataBound="gvChemicalList_RowDataBound">
                        <RowStyle CssClass="tlrowlight" Font-Strikeout="False" />
                        <SelectedRowStyle />
                        <%--<AlternatingRowStyle CssClass="tlrowdark" />--%>
                        <HeaderStyle CssClass="headerGrid" HorizontalAlign="Center" />
                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Center" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <HeaderTemplate>
                                    <span class="cpl-select-all">
                                        <asp:CheckBox ID="chkSelectAll" runat="server" onclick="checkAll(this);" />
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cpl-select">
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnstatus" />
                                    </span>
                                </ItemTemplate>
                                <ControlStyle></ControlStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="3%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Chemical">
                                <ItemTemplate>
                                    <span class="cpl-chem">
                                        <span class="cpl-chem-kicker"><i class="fas fa-flask" aria-hidden="true"></i>Chemical</span>
                                        <span class="cpl-chem-value">
                                            <asp:HiddenField ID="hdnchecmicalid" runat="server" Value='<%# Bind("tc_chemical_id") %>' />
                                            <asp:Label ID="lblchemical" Text='<%# Bind("tc_chemical_name") %>' runat="server" />
                                        </span>
                                    </span>
                                </ItemTemplate>
                                <ControlStyle></ControlStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="45%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Dosage(%)">
                                <ItemTemplate>
                                    <span class="cpl-dose">
                                        <span class="cpl-dose-kicker"><i class="fas fa-percent" aria-hidden="true"></i>Dosage(%)</span>
                                        <span class="cpl-dose-field">
                                            <asp:TextBox ID="txtDosage" runat="server" class="form-control form-control-sm" Text='<%# Bind("dosage") %>' oninput="validateObtainedScore(this);" AutoComplete="off"></asp:TextBox>
                                        </span>
                                    </span>
                                </ItemTemplate>
                                <ControlStyle></ControlStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="45%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <%--<div class="form-group">
                            <div class="CheckBoxList">
                                <asp:CheckBox ID="CheckBox1" runat="server" CssClass="checkAll" Text="Select All" onclick="checkAllProduct(this)" />
                                <asp:CheckBoxList ID="chkbxListApplProducts" runat="server" TabIndex="14" RepeatColumns="4"
                                    RepeatDirection="Horizontal" Width="100%" AutoPostBack="False">
                                </asp:CheckBoxList>
                            </div>
                        </div>--%>
                <div class="row">
                    <div class="col-md-12 text-center cpl-actions">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary btn-sm" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-sm" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" />
                    </div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server" Style="text-align: left; font-size: 13px; font-weight: bold;" Text=""></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>


    </div>

    <script type="text/javascript" src="Scripts/select2.full.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //Initialize Select2 Elements
            $('.select2').select2();
        });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $('.select2').select2();
        });

    </script>
</asp:Content>
