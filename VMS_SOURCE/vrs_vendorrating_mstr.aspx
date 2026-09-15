<%@ Page Title="Vendor rating" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="vrs_vendorrating_mstr.aspx.vb" Inherits="vrs_vendorrating_mstr" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<%@ Register Src="~/CircularProgressBar.ascx" TagPrefix="uc" TagName="CircularProgressBar" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateLegalScore.js"></script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Rating Master</h3>
                <p class="pageSubTitle">Configure vendor rating parameters and weights</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Fin Year:</label>
                        <asp:DropDownList ID="ddlFinYear" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFinYear_SelectedIndexChanged" />
                    </div>
                </div>

                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Quarter:</label>
                        <asp:DropDownList ID="ddlquartor" CssClass="form-control select2" runat="server" />
                    </div>
                </div>

                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Search Type:</label>
                        <asp:DropDownList ID="ddlType" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                            <asp:ListItem Text="Group Wise" Value="GRPS"></asp:ListItem>
                            <asp:ListItem Text="Individual" Value="INDV"></asp:ListItem>
                            <asp:ListItem Text="Head Wise" Value="HEAD"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="col-md-3" runat="server" id="divSrcHeadGrp">
                    <div class="form-group">
                        <label class="form-control-label">Head:</label>
                        <asp:DropDownList ID="ddlHead" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlHead_SelectedIndexChanged">
                            <asp:ListItem Text="Legal Statutory" Value="LEGSTA"></asp:ListItem>
                            <asp:ListItem Text="Quality" Value="FGQ"></asp:ListItem>
                            <asp:ListItem Text="Audit" Value="AUDIT"></asp:ListItem>
                            <asp:ListItem Text="Service" Value="SERV"></asp:ListItem>
                            <asp:ListItem Text="Complaints" Value="COMP"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="col-md-3" runat="server" id="divSrcVendorGroup">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Group:</label>
                        <asp:DropDownList ID="ddlVendorGrp" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendorGrp_SelectedIndexChanged" />
                    </div>
                </div>

                <div class="col-md-3" runat="server" id="divSrcVendor">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Unit:</label>
                        <asp:DropDownList ID="ddlVendor" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" />
                    </div>
                </div>

                <div class="col-md-3" runat="server" id="divSrcProductGroup">
                    <div class="form-group">
                        <label class="form-control-label">Product Group:</label>
                        <asp:DropDownList ID="ddlBrand" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlBrand_SelectedIndexChanged" />
                    </div>
                </div>

                <div class="col-md-3" runat="server" id="divSrcProduct">
                    <div class="form-group">
                        <label class="form-control-label">Product:</label>
                        <asp:DropDownList ID="ddlProduct" CssClass="form-control select2" runat="server" AutoPostBack="true" />
                    </div>
                </div>

                <div class="col-md-3 form-btn-mt">
                    <div class="form-group form-btn-mt" style="display: flex; gap: 2px; margin-top: 0 !important;">
                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnsearch_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-warning btn-sm" OnClick="btnReset_Click" CausesValidation="false" />
                    </div>
                </div>

            </div>
            <asp:Label ID="lblError" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>

    <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
        <ContentTemplate>
            <div class="row" runat="server" id="divVendorScoreCategoryLyTyWise">
                <div class="col-md-7">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="grupItemList">
                                        <div class="badge-wrap">
                                            <svg class="badge-svg" viewBox="0 0 200 140" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Platinum badge">
                                                <polygon points="100,5 173,40 173,100 100,135 27,100 27,40" fill="transparent" stroke="#b68900" stroke-width="8" stroke-linejoin="round" />
                                                <polygon points="100,18 160,48 160,92 100,122 40,92 40,48" fill="transparent" stroke="#b68900" stroke-width="5" stroke-linejoin="round" opacity="0.35" />
                                                <text x="100" y="78" text-anchor="middle" font-family="Inter, Roboto, Arial" font-weight="800" font-size="24" fill="#b68900">Platinum</text>
                                            </svg>
                                        </div>
                                        <div class="content">
                                            <div class="numbers">
                                                <div class="sub">Unit Count</div>
                                                <div class="big">
                                                    <asp:Label runat="server" ID="lblPlatinumCount"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="p-progress-container">
                                        <div class="progress-bar" id="progPlatinum" runat="server" style="width: 45%; height: 100%; background-color: #b68900">45%</div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="grupItemList">
                                        <div class="badge-wrap">
                                            <svg class="badge-svg" viewBox="0 0 200 140" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Gold badge">
                                                <!-- outer hexagon -->
                                                <polygon
                                                    points="100,5 173,40 173,100 100,135 27,100 27,40"
                                                    fill="transparent"
                                                    stroke="#66b201"
                                                    stroke-width="8"
                                                    stroke-linejoin="round" />

                                                <!-- inner border -->
                                                <polygon
                                                    points="100,18 160,48 160,92 100,122 40,92 40,48"
                                                    fill="transparent"
                                                    stroke="#66b201"
                                                    stroke-width="5"
                                                    stroke-linejoin="round"
                                                    opacity="0.35" />

                                                <!-- text -->
                                                <text x="100" y="78" text-anchor="middle" font-family="Inter, Roboto, Arial" font-weight="800" font-size="24" fill="#66b201">Gold</text>
                                            </svg>
                                        </div>
                                        <div class="content">
                                            <div class="numbers">
                                                <div class="sub">Unit Count</div>
                                                <div class="big">
                                                    <asp:Label runat="server" ID="lblGoldCount"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="p-progress-container">
                                        <div class="progress-bar" id="progGold" runat="server" style="width: 45%; height: 100%; background-color: #66b201">45%</div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="grupItemList">
                                        <div class="badge-wrap">
                                            <svg class="badge-svg" viewBox="0 0 200 140" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Silver badge">
                                                <polygon points="100,5 173,40 173,100 100,135 27,100 27,40" fill="transparent" stroke="#b31400" stroke-width="8" stroke-linejoin="round" />
                                                <polygon points="100,18 160,48 160,92 100,122 40,92 40,48" fill="transparent" stroke="#b31400" stroke-width="5" stroke-linejoin="round" opacity="0.35" />
                                                <text x="100" y="78" text-anchor="middle" font-family="Inter, Roboto, Arial" font-weight="800" font-size="24" fill="#b31400">Silver</text>
                                            </svg>
                                        </div>
                                        <div class="content">
                                            <div class="numbers">
                                                <div class="sub">Unit Count</div>
                                                <div class="big">
                                                    <asp:Label runat="server" ID="lblSilverCount"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="p-progress-container">
                                        <div class="progress-bar" id="progSilver" runat="server" style="width: 45%; height: 100%; background-color: #b31400">45%</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="grupItemList">
                                        <div class="badge-wrap">
                                            <svg class="badge-svg" viewBox="0 0 200 140" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Bronze badge" style="width: 120px; height: auto;">
                                                <!-- Outer hexagon (flattened vertically) -->
                                                <polygon points="100,5 173,40 173,100 100,135 27,100 27,40"
                                                    fill="transparent"
                                                    stroke="#008db6"
                                                    stroke-width="6"
                                                    stroke-linejoin="round" />

                                                <!-- Inner trim -->
                                                <polygon points="100,18 160,48 160,92 100,122 40,92 40,48"
                                                    fill="transparent"
                                                    stroke="#008db6"
                                                    stroke-width="4"
                                                    stroke-linejoin="round"
                                                    opacity="0.35" />

                                                <!-- Text -->
                                                <text x="100" y="78"
                                                    text-anchor="middle"
                                                    font-family="Inter, Roboto, Arial"
                                                    font-weight="800"
                                                    font-size="20"
                                                    fill="#008db6">Bronze</text>
                                            </svg>
                                        </div>
                                        <div class="content">
                                            <div class="numbers">
                                                <div class="sub">Unit Count</div>
                                                <div class="big">
                                                    <asp:Label runat="server" ID="lblBronzeCount"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="p-progress-container">
                                        <div class="progress-bar" id="progBronze" runat="server" style="width: 45%; height: 100%; background-color: #008db6">45%</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-5">
                    <div class="card" runat="server" id="div2">
                        <div class="card-body">
                            <div class="custTabs">
                                <nav>
                                    <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                        <button class="nav-link active" id="nav-ty-tab" data-bs-toggle="tab" data-bs-target="#nav-ty" type="button" role="tab" aria-controls="nav-ty" aria-selected="true">TY Top 1 Unit</button>
                                        <button class="nav-link" id="nav-ly-tab" data-bs-toggle="tab" data-bs-target="#nav-ly" type="button" role="tab" aria-controls="nav-ly" aria-selected="false">LY Top 1 Unit</button>
                                    </div>
                                </nav>
                                <div class="tab-content" id="nav-tabContent">
                                    <div class="tab-pane fade show active p-2" id="nav-ty" role="tabpanel" aria-labelledby="nav-ty-tab">
                                        <asp:GridView ID="gvTy" runat="server" ShowHeader="false" AutoGenerateColumns="False" CssClass="noBorder" Width="100%" BorderWidth="0" EmptyDataText="No records found" OnRowCommand="gvTy_RowCommand">
                                            <RowStyle CssClass="tlrowlight" />
                                            <SelectedRowStyle />
                                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="headerGrid" />
                                            <FooterStyle CssClass="footerGrid" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Vendor">
                                                    <ItemTemplate>
                                                        <div class="tyNlyLab">
                                                            <i class="fas fa-building"></i>
                                                            <asp:Label ID="lbl_vendor_name_Ty" runat="server" Text='<%# Bind("ty_vendor") %>'></asp:Label>
                                                            <asp:HiddenField runat="server" ID="hdnTyYear" Value='<%#Eval("ty_finYear") %>' />
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="70%" />
                                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="70%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnTyView" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("ty_vendor_code") & "|" & Eval("ty_finYear") %>' Text="View" CssClass="singelLink">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                                        <%--<asp:Button CssClass="btn btn-info btn-sm tableBtnXs" />--%>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="30%" />
                                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="30%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                    <div class="tab-pane fade p-2" id="nav-ly" role="tabpanel" aria-labelledby="nav-ly-tab">
                                        <asp:GridView ID="gvLy" runat="server" ShowHeader="false" AutoGenerateColumns="False" CssClass="noBorder" Width="100%" EmptyDataText="No records found" BorderWidth="0" OnRowCommand="gvLy_RowCommand">
                                            <RowStyle CssClass="tlrowlight" />
                                            <SelectedRowStyle />
                                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="headerGrid" />
                                            <FooterStyle CssClass="footerGrid" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Vendor">
                                                    <ItemTemplate>
                                                        <div class="tyNlyLab">
                                                            <i class="fas fa-building"></i>
                                                            <asp:Label ID="lbl_vendor_name_Ly" runat="server" Text='<%# Bind("ly_vendor") %>'></asp:Label>
                                                            <asp:HiddenField runat="server" ID="hdnLyYear" Value='<%#Eval("ly_finYear") %>' />
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="70%" />
                                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="70%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnLyView" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("ly_vendor_code") & "|" & Eval("ly_finYear") %>' Text="View" CssClass="singelLink">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                                        <%--<asp:Button CssClass="btn btn-info btn-sm tableBtnXs" />--%>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="30%" />
                                                    <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="30%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" id="divTopVendor" runat="server">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="eachDataPoint">
                                <li style="width: 100%;">
                                    <p class="hWeightLabel" style="font-size: 12px;">Top Unit Details</p>
                                    <p class="hWeightData" id="topVendorname" runat="server"></p>
                                    <asp:HiddenField ID="HiddenField4" runat="server" />
                                </li>
                                <li style="border: 0px;">
                                    <p class="hWeightLabel" style="font-size: 12px;">Current Quarter Obtain Weightage</p>
                                    <p class="hWeightData" id="topObtainWeightage" runat="server"></p>
                                </li>
                            </ul>
                            <div class="row">
                                <div class="col-md-8">
                                    <asp:Chart ID="PerformanceChart" runat="server" Height="155" style="width: 100%;">
                                        <Series>
                                            <asp:Series Name="Performance" ChartType="Line" BorderWidth="4" Color="#007d9c"></asp:Series>
                                        </Series>
                                        <ChartAreas>
                                            <asp:ChartArea Name="ChartArea1">
                                                <AxisX Title="Time" />
                                                <AxisY Title="Performance" />
                                            </asp:ChartArea>
                                        </ChartAreas>
                                    </asp:Chart>
                                </div>
                                <div class="col-md-4">
                                    <div class="gradeObtainSection mstPageFullGrade">
                                        <div class="GradeView" style="display: none;">
                                            <p class="GradeLabel">Grade</p>
                                            <div class="GradeLabel">
                                                <asp:Label runat="server" ID="lbltopgrade">Platinum</asp:Label>
                                            </div>
                                        </div>
                                        <div class="cqowBadge">
                                            <asp:Image runat="server" ID="imgGrade" src="images/gold.png" class="badgeStar" alt="img" />
                                            <asp:Label runat="server" ID="lblTop1Grade" class="badgeTx gold">Gold</asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h4 class="gridTitleTx">Top 10 Unit List</h4>
                            <div class="table-responsive tvlGridHt" style="height:auto; max-height: 190px;">
                                <asp:GridView ID="gvTopvendor" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0 custGvTopvendorGrid" CellSpacing="0" CellPadding="0">
                                    <RowStyle CssClass="tlrowlight" />
                                    <SelectedRowStyle />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Vendor">
                                            <ItemTemplate>
                                                <asp:Label ID="lbl_vendor_name" runat="server" Text='<%# Bind("vendor") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Q1">
                                            <ItemTemplate>
                                                <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("Q1") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Q2">
                                            <ItemTemplate>
                                                <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("Q2") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Q3">
                                            <ItemTemplate>
                                                <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("Q3") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Q4">
                                            <ItemTemplate>
                                                <asp:Label ID="lbl_obtain_weightage" runat="server" Text='<%# Bind("Q4") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="15%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- All Header List --%>
            <div class="row" runat="server" id="divHeaderList" visible="false">
                <div class="col-md-12">
                    <h4 class="gridTitleTx">All Header List</h4>
                </div>
                <asp:Repeater ID="rptHeadGrp" runat="server" OnItemDataBound="rptHeadGrp_ItemDataBound" OnItemCommand="rptHeadGrp_ItemCommand">
                    <ItemTemplate>
                        <div class="col-md-3">
                            <div class="p-card-content">
                                <h4 class="vendorName" style="padding: 0px 0px 10px 0px; min-height: 45px;"><%#Eval("vendor_name") %></h4>
                                <div class="p-unit-volume" style="column-gap: 30px;">
                                    <div class="quikImgView">
                                        <asp:Image runat="server" ID="imgGrpHead" src="images/gold.png" class="quikImg" Style="width: auto; height: 55px;" alt="img" />
                                    </div>
                                    <div class="p-unit-volume-item">
                                        <div class="p-card-item">
                                            <h4 class="vendorName" style="padding: 0px; min-height: auto;"><%#Eval("head_name") %></h4>
                                            <%-- <span><%#Eval("head_name") %></span>--%>
                                            <asp:HiddenField runat="server" ID="hdrheadname" Value='<%#Eval("head_name") %>' />
                                            <%-- <asp:Label runat="server" class="value" ID="lblGrpTotalUnitCount" Text='<%#Eval("unit_count") %>'></asp:Label>
                                                    <asp:HiddenField runat="server" ID="hdrGrpGrade" Value='<%#Eval("grade_name") %>' />
                                                    <asp:HiddenField runat="server" ID="hdnVendorGroupId" Value='<%#Eval("vendor_id") %>' />--%>
                                        </div>
                                        <div class="p-card-item">
                                            <span>Obtain Weightage:</span>
                                            <asp:Label runat="server" class="value" ID="lblobtainHead" Text='<%#Eval("obtain_weightage") %>'></asp:Label>
                                        </div>
                                        <div class="p-card-item">
                                            <span>Max Weightage</span>
                                            <asp:Label runat="server" class="value" ID="lblmaxhead" Text='<%#Eval("maxWeightage") %>'></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-card-item" style="margin: 6px 0px 4px 0px;">
                                    <span>Total Score:</span>
                                    <asp:Label runat="server" class="value" ID="lblHeadTotalScore" Text='<%#Eval("obtain_percentage") %>'></asp:Label>
                                </div>
                                <div class="p-progress-container" style="margin: 0px; height: 8px;">
                                    <div class="progress-bar" id="LineHeadProgressBar" runat="server" style="width: 45%; height: 100%;"></div>
                                </div>
                                <%--<div class="footerAction" style="justify-content: center;">
                                            <asp:LinkButton ID="LnkGroupViewDetails" runat="server" title="View Details" class="vViewDtlsLink" OnClick="LnkGroupViewDetails_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                        </div>--%>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <%-- End All Header List --%>


            <%--<div class="card" runat="server" style="display: none;" id="div1" visible="false">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <asp:GridView ID="gvVendor_Rate" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                        AllowPaging="true" PageSize="20" CssClass="upgradDataGrid m-0" border="1" CellSpacing="0" CellPadding="0" OnRowDataBound="gvVendor_Rate_RowDataBound"
                                        OnRowCommand="gvVendor_Rate_RowCommand">
                                        <RowStyle CssClass="tlrowlight" />
                                        <SelectedRowStyle />
                                        <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <FooterStyle CssClass="footerGrid" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Sl No">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSlno" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Vendor">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_vendor_name" runat="server" Text='<%# Bind("vendor") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="35%" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="35%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Statutory(15.00)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_StatutoryWeightage" runat="server" Text='<%# Bind("Statutory") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Quality(21.70)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_QualityWeightage" runat="server" Text='<%# Bind("Quality") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Audit(21.70)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_AuditWeightage" runat="server" Text='<%# Bind("Audit") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Service(20.00)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_ServiceWeightage" runat="server" Text='<%# Bind("Service") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Complaints(21.70)">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl_ComplaintsWeightage" runat="server" Text='<%# Bind("Complaints") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <asp:Button ID="btnView" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("unit_code") %>'
                                                        Text="View Details" CssClass="btn btn-info btn-sm tableBtnXs" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>--%>

            <div class="row" runat="server" id="divVendorGroup" visible="false">
                <div class="col-md-12">
                    <h4 class="gridTitleTx">All Vendor List</h4>
                </div>
                <asp:Repeater ID="reptVendorGroup" runat="server" OnItemDataBound="reptVendorGroup_ItemDataBound" OnItemCommand="reptVendorGroup_ItemCommand">
                    <ItemTemplate>
                        <div class="col-md-3">
                            <div class="p-card-content">
                                <h4 class="vendorName" style="padding: 0px 0px 10px 0px; min-height: 45px;"><%#Eval("vendor_name") %></h4>
                                <div class="p-unit-volume" style="column-gap: 30px;">
                                    <asp:Image runat="server" ID="imgGrpGrade" src="images/gold.png" class="badgeStar" Style="width: auto; height: 55px;" alt="img" />
                                    <div class="p-unit-volume-item">
                                        <div class="p-card-item">
                                            <span>Total Unit Count:</span>
                                            <asp:Label runat="server" class="value" ID="lblGrpTotalUnitCount" Text='<%#Eval("unit_count") %>'></asp:Label>
                                            <asp:HiddenField runat="server" ID="hdrGrpGrade" Value='<%#Eval("grade_name") %>' />
                                            <asp:HiddenField runat="server" ID="hdnVendorGroupId" Value='<%#Eval("vendor_id") %>' />
                                        </div>
                                        <div class="p-card-item">
                                            <span>Total Volume:</span>
                                            <asp:Label runat="server" class="value" ID="lblGrpTotalVol" Text='<%#Eval("avg_vol") %>'></asp:Label>
                                        </div>
                                        <div class="p-card-item">
                                            <span>Score</span>
                                            <asp:Label runat="server" class="value" ID="Label2" Text='<%#Eval("grade_name") %>'></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-card-item" style="margin: 6px 0px 4px 0px;">
                                    <span>Total Score:</span>
                                    <asp:Label runat="server" class="value" ID="lblGrpTotalScore" Text='<%#Eval("score") %>'></asp:Label>
                                </div>
                                <div class="p-progress-container" style="margin: 0px; height: 8px;">
                                    <div class="progress-bar" id="LinerProgressBar" runat="server" style="width: 45%; height: 100%;"></div>
                                </div>
                                <div class="footerAction" style="justify-content: center;">
                                    <asp:LinkButton ID="LnkGroupViewDetails" runat="server" title="View Details" class="vViewDtlsLink" OnClick="LnkGroupViewDetails_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="card" runat="server" id="divVendorRating" visible="false">
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">All Unit List</h5>
                            <p class="mst-panel-subtitle">Record findings from a vendor audit</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
<%--                        <div class="col-md-12">
                            <h4 class="gridTitleTx" style="font-size: 14px !important;"></h4>
                        </div>--%>
                        <asp:Repeater ID="RatingRepeater" runat="server" OnItemDataBound="RatingRepeater_ItemDataBound" OnItemCommand="RatingRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="col-md-3">
                                    <div class="card">
                                        <div class="card-body dataContSet">
                                            <h4 class="vendorName"><%#Eval("vendor") %></h4>
                                            <div class="vScoreDtlsView">
                                                <div class="vScoreView">
                                                    <div class="graphData">
                                                        <uc:CircularProgressBar ID="CircularProgressBar1" runat="server" />
                                                    </div>
                                                </div>
                                                <div class="vDtlsView">
                                                    <ul class="vendorRatingList">
                                                        <li>
                                                            <p class="vRatingLabel">Statutory(10.00)</p>
                                                            <p class="vRatingDataPoint">
                                                                <asp:Label ID="StatutoryObtainScore" runat="server" Text='<%#Eval("Statutory") %>'></asp:Label>
                                                            </p>
                                                        </li>
                                                        <li>
                                                            <p class="vRatingLabel">Quality(20.00)</p>
                                                            <p class="vRatingDataPoint">
                                                                <asp:Label ID="QualityObtainScore" runat="server" Text='<%#Eval("Quality") %>'></asp:Label>
                                                            </p>
                                                        </li>
                                                        <li>
                                                            <p class="vRatingLabel">Audit(15.00)</p>
                                                            <p class="vRatingDataPoint">
                                                                <asp:Label ID="AuditObtainScore" runat="server" Text='<%#Eval("Audit") %>'></asp:Label>
                                                            </p>
                                                        </li>
                                                        <li>
                                                            <p class="vRatingLabel">Service(30.00)</p>
                                                            <p class="vRatingDataPoint">
                                                                <asp:Label ID="ServeiceObtainScore" runat="server" Text='<%#Eval("Service") %>'></asp:Label>
                                                            </p>
                                                        </li>
                                                        <li>
                                                            <p class="vRatingLabel">Complaints(25.00)</p>
                                                            <p class="vRatingDataPoint">
                                                                <asp:Label ID="CompObtainScore" runat="server" Text='<%#Eval("Complaints") %>'></asp:Label>
                                                            </p>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="footerAction">
                                                <asp:LinkButton ID="LnkViewDetails" runat="server" title="View Details" class="vViewDtlsLink" OnClick="LnkViewDetails_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                                <asp:LinkButton ID="LnkViewProduct" runat="server" title="View Product" class="vViewDtlsLink" CommandName="ViewProduct" CommandArgument='<%#Eval("unit_code") %>'>View Product <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                            </div>
                                            <asp:HiddenField ID="hdnTotal" Value='<%#Eval("total") %>' runat="server" />
                                            <asp:HiddenField ID="hdnvendorID" Value='<%#Eval("unit_code") %>' runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div class="col-md-12 text-center">
                            <asp:Button ID="Button1" runat="server" Text="Back" OnClick="btnback_Click" CssClass="btn btn-secondary btn-sm" />
                        </div>
                    </div>
                </div>
            </div>

            <div runat="server" id="divVendorDashboard" visible="false">
                <div class="row">
                    <div class="col-md-12">
                        <div class="headCattgList">
                            <div class="headCattgBox gColorOne">
                                <asp:HiddenField ID="hdnIndvendorid" runat="server" />
                                <div class="headTitLink">
                                    <p class="headTitle">Statutory</p>
                                    <asp:LinkButton ID="LnkStatutoryDtls" runat="server" CssClass="ViewDtlsLink" OnClick="LnkStatutoryDtls_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                </div>
                                <ul class="eachDataPoint">
                                    <li>
                                        <p class="hWeightLabel">Obtain Weightage</p>
                                        <p class="hWeightData" id="StatutoryObtainWeigtage" runat="server"></p>
                                        <asp:HiddenField ID="hdn_hdrSat" runat="server" />
                                    </li>
                                    <li>
                                        <p class="hWeightLabel">Max Weightage</p>
                                        <p class="hWeightData" id="StatutoryMaxWeigtage" runat="server"></p>
                                    </li>
                                </ul>
                            </div>
                            <div class="headCattgBox gColorTwo">
                                <div class="headTitLink">
                                    <p class="headTitle">Quality</p>
                                    <%-- <a href="#" title="View Details" class="ViewDtlsLink">View Details <i class="fas fa-chevron-right"></i></a>--%>
                                    <asp:LinkButton ID="LnkQualityDtls" runat="server" CssClass="ViewDtlsLink" OnClick="LnkQualityDtls_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                </div>
                                <ul class="eachDataPoint">
                                    <li>
                                        <p class="hWeightLabel">Obtain Weightage</p>
                                        <p class="hWeightData" id="QualityObtainWeigtage" runat="server"></p>
                                        <asp:HiddenField ID="hdn_Qualtityhdr" runat="server" />
                                    </li>
                                    <li>
                                        <p class="hWeightLabel">Max Weightage</p>
                                        <p class="hWeightData" id="QualityMaxWeigtage" runat="server"></p>
                                    </li>
                                </ul>
                            </div>
                            <div class="headCattgBox gColorThree">
                                <div class="headTitLink">
                                    <p class="headTitle">Audit</p>
                                    <asp:LinkButton ID="LnkAuditDtls" runat="server" CssClass="ViewDtlsLink" OnClick="LnkAuditDtls_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                    <%--<a href="#" title="View Details" class="ViewDtlsLink">View Details <i class="fas fa-chevron-right"></i></a>--%>
                                </div>
                                <ul class="eachDataPoint">
                                    <li>
                                        <p class="hWeightLabel">Obtain Weightage</p>
                                        <p class="hWeightData" id="AuditObtainWeigtage" runat="server"></p>
                                        <asp:HiddenField ID="hdn_Audithdr" runat="server" />
                                    </li>
                                    <li>
                                        <p class="hWeightLabel">Max Weightage</p>
                                        <p class="hWeightData" id="AuditMaxWeigtage" runat="server"></p>
                                    </li>
                                </ul>
                            </div>
                            <div class="headCattgBox gColorFour">
                                <div class="headTitLink">
                                    <p class="headTitle">Service</p>
                                    <asp:LinkButton ID="LnkServiceDtls" runat="server" CssClass="ViewDtlsLink" OnClick="LnkServiceDtls_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                    <%--<a href="#" title="View Details" class="ViewDtlsLink">View Details <i class="fas fa-chevron-right"></i></a>--%>
                                </div>
                                <ul class="eachDataPoint">
                                    <li>
                                        <p class="hWeightLabel">Obtain Weightage</p>
                                        <p class="hWeightData" id="ServiceObtainWeigtage" runat="server"></p>
                                        <asp:HiddenField ID="hdn_Servicehdr" runat="server" />
                                    </li>
                                    <li>
                                        <p class="hWeightLabel">Max Weightage</p>
                                        <p class="hWeightData" id="ServiceMaxWeigtage" runat="server"></p>
                                    </li>
                                </ul>
                            </div>
                            <div class="headCattgBox gColorFive">
                                <div class="headTitLink">
                                    <p class="headTitle">Complaints</p>
                                    <asp:LinkButton ID="LnkSCpomplaintsDtls" runat="server" CssClass="ViewDtlsLink" OnClick="LnkSCpomplaintsDtls_Click">View Details <i class="fas fa-chevron-right"></i></asp:LinkButton>
                                    <%-- <a href="#" title="View Details" class="ViewDtlsLink">View Details <i class="fas fa-chevron-right"></i></a>--%>
                                </div>
                                <ul class="eachDataPoint">
                                    <li>
                                        <p class="hWeightLabel">Obtain Weightage</p>
                                        <p class="hWeightData" id="ComplaintsObtainWeigtage" runat="server"></p>
                                        <asp:HiddenField ID="hdn_Complaintshdr" runat="server" />
                                    </li>
                                    <li>
                                        <p class="hWeightLabel">Max Weightage</p>
                                        <p class="hWeightData" id="ComplaintsMaxWeigtage" runat="server"></p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="cardChart">
                                            <div class="card">
                                                <div class="card-body p-0 text-center">
                                                    <asp:Chart ID="Chart1" runat="server" EnableViewState="true">
                                                        <Series>
                                                            <asp:Series Name="Series1" ChartType="StackedColumn"></asp:Series>
                                                        </Series>
                                                        <ChartAreas>
                                                            <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                                                        </ChartAreas>
                                                    </asp:Chart>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="gradeObtainSection">
                                            <div class="GradeView" style="display: none">
                                                <p class="GradeLabel">Grade</p>
                                                <div class="GradeLabel">
                                                    <asp:Label runat="server" ID="lblGrade">Platinum </asp:Label>
                                                </div>
                                            </div>
                                            <div class="blackCardBadge">
                                                <div class="glowC"></div>
                                                <div class="flotingItem">
                                                    <asp:Image runat="server" ID="imgInnerGrade" src="images/gold.png" class="badgeStar" alt="img" />
                                                    <asp:Label runat="server" ID="lblInnerGrade" class="badgeTx gold">Gold</asp:Label>
                                                </div>
                                            </div>
                                            <div class="obtainWthArea">
                                                <ul class="obtainListView">
                                                    <li>
                                                        <i class="fas fa-dot-circle"></i>
                                                        <div class="obtainListFung">
                                                            <span class="obtainWthLabel">Obtain Weightage:</span>
                                                            <asp:Label runat="server" ID="lblObtain">100</asp:Label>
                                                            <asp:Label runat="server" ID="Label1">%</asp:Label>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <i class="fas fa-dot-circle"></i>
                                                        <div class="obtainListFung">
                                                            <span class="obtainWthLabel">Penalty Score:</span>
                                                            <asp:Label runat="server" ID="penaltyLabel">100</asp:Label>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <i class="fas fa-dot-circle"></i>
                                                        <div class="obtainListFung">
                                                            <span class="obtainWthLabel">Final Score:</span>
                                                            <asp:Label runat="server" ID="finalLabel">100</asp:Label>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12 text-center mb-3 mt-1">
                                        <asp:Button ID="btnback" runat="server" Text="Back" OnClick="btnback_Click" CssClass="btn btn-secondary btn-sm" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Start Old Grid View -->
                <%-- <div class="card" style="display: none;">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="row pl-2">
                                            <div class="col-md-12">
                                                <asp:GridView ID="gvVendorHeader" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                                    AllowPaging="true" PageSize="20" CssClass="upgradDataGrid" border="1" CellSpacing="0" CellPadding="0" OnRowCommand="gvVendorHeader_RowCommand">
                                                    <RowStyle CssClass="tlrowlight" />
                                                    <SelectedRowStyle />
                                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="headerGrid" />
                                                    <FooterStyle CssClass="footerGrid" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="SlNo" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSlno" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Head" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hdn_hdr_id" runat="server" Value='<%# Bind("hdr_id") %>' />
                                                                <asp:HyperLink ID="lbl_hdr_id" runat="server" Text='<%# Bind("Head") %>'></asp:HyperLink>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Obtain Weightage" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_ObtainWeightage_value" runat="server" Text='<%# Bind("obtain_weightage") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Max Weightage" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_maxWeightage_value" runat="server" Text='<%# Bind("maxWeightage") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="21%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnView" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("hdr_id") & "|" & Eval("Head") %>'
                                                                    Text="View" CssClass="btn btn-info btn-sm" />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                <!-- End Old Grid View -->
            </div>
        </ContentTemplate>
        <Triggers>
            <%-- <asp:AsyncPostBackTrigger ControlID="gvVendor_Rate" EventName="RowCommand" />--%>
            <asp:AsyncPostBackTrigger ControlID="RatingRepeater" EventName="ItemCommand" />
        </Triggers>
    </asp:UpdatePanel>

    <%--Vendor wise product Popup--%>
    <asp:HiddenField ID="HiddenField5" runat="server" />
    <asp:ModalPopupExtender ID="mpVendorWiseProduct" runat="server"
        PopupControlID="PannelvendorwiseProduct" TargetControlID="HiddenField5">
    </asp:ModalPopupExtender>
    <asp:Panel ID="PannelvendorwiseProduct" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Vendor Product</h5>
                <asp:Button ID="btnProductPopup" runat="server" Text="×" OnClick="btnProductPopup_Click" CssClass="close-btn" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvVendorWiseProduct" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" CssClass="upgradDataGrid m-0 custGvTopvendorGrid" CellSpacing="0" CellPadding="0">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Product">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_product_name" runat="server" Text='<%# Bind("product_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="40%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q1">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_Q1" runat="server" Text='<%# Bind("Q1") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q2">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_Q2" runat="server" Text='<%# Bind("Q2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q3">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_Q3" runat="server" Text='<%# Bind("Q3") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q4">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_Q4" runat="server" Text='<%# Bind("Q4") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TOTAL">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_TOTAL" runat="server" Text='<%# Bind("TOTAL") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Vendor wise product Popup--%>

    <%--Statutory Details Popup--%>
    <asp:HiddenField ID="hdnOk" runat="server" />
    <asp:ModalPopupExtender ID="mpStatutory" runat="server"
        PopupControlID="Panel1" TargetControlID="hdnOk">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel1" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Statutory Details</h5>
                <asp:Button ID="btnClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnClosePopup_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="row mb-1">
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Target Score:</label>
                                    <asp:TextBox ID="txttotalTargetScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Score:</label>
                                    <asp:TextBox ID="txttotalObtainScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Percentage:</label>
                                    <asp:TextBox ID="txttotalObtainPercentage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Weightage:</label>
                                    <asp:TextBox ID="txtWeightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <hr />

                        <asp:GridView ID="gvStatutoryDetails" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Slno.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSlno" Text='<%# Bind("parameter_code") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Legal and Statutory Requirements Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParameterName" Text='<%# Bind("parameter_name") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnParameterCode" Value='<%# Bind("parameter_code") %>' />
                                        <asp:HiddenField runat="server" ID="hdnParameterName" Value='<%# Bind("parameter_name") %>' />
                                        <asp:HiddenField runat="server" ID="hdnVlsObligation" Value='<%# Bind("vlm_obligation") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Width="35%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor obligation">
                                    <ItemTemplate>
                                        <asp:Label ID="lblObligation" Text='<%# Bind("vlm_obligation") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnObligation" Value='<%# Bind("vlm_obligation") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Availability">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAvailability" Text='<%# Bind("vlm_availability") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnAvailability" Value='<%# Bind("vlm_availability") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Target Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTargetScore" Text='<%# Bind("vlsm_score") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnTargetScore" Value='<%# Bind("vlsm_score") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Obtained Score">
                                    <ItemTemplate>
                                        <asp:Label ID="txtObtainedScore" Text='<%# Bind("obt_score") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Valid Till Date">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtValidDate" runat="server" class="form-control form-control-sm" MaxLength="10" Enabled="false" TextMode="Date" Text='<%# Bind("valid_till") %>'></asp:TextBox>
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issuing Authority">
                                    <ItemTemplate>
                                        <asp:Label ID="txtIssueAuthority" Text='<%# Bind("valid_auth") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Statutory Details Popup--%>

    <%--Quality Details Popup--%>

    <asp:HiddenField ID="HiddenField1" runat="server" />
    <asp:ModalPopupExtender ID="mpQuality" runat="server"
        PopupControlID="Panel2" TargetControlID="HiddenField1">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel2" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Quality Details</h5>
                <asp:Button ID="btnQualityPopupclose" runat="server" Text="×" CssClass="close-btn" OnClick="btnQualityPopupclose_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="row mb-1">
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Target Score:</label>
                                    <asp:TextBox ID="txtQualitytargetScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Score:</label>
                                    <asp:TextBox ID="txtQualityTotalObtainScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <%--   <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Obtain Percentage:</label>
                                        <asp:TextBox ID="txtQualityObtainPercentage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>--%>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Weightage:</label>
                                    <asp:TextBox ID="txtQualityObtainWeightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <hr />

                        <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="Repeater1_ItemDataBound">
                            <ItemTemplate>

                                <div style="display: flex; justify-content: space-between; align-items: center; background: #ededed; padding: 0 15px;">
                                    <h5 runat="server" class="gridTitleTx qd-table-main-head">
                                        <%# Eval("bm_brand_name") %>
                                    </h5>
                                    <h5 runat="server" class="gridTitleTx qd-table-main-head">
                                        <%# Eval("sku_desc") %>
                                    </h5>
                                </div>



                                <%--<asp:Label ID="lblBrand" runat="server"> <%# Eval("bm_brand_name") %></asp:Label>--%>
                                <asp:HiddenField runat="server" ID="hdnBrand" Value='<%# Eval("bm_brand_name") %>' />
                                <asp:HiddenField runat="server" ID="hdnsku" Value='<%# Eval("sku_code") %>' />
                                <asp:GridView ID="gvTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found"
                                    CssClass="upgradDataGrid" border="1" CellSpacing="0" CellPadding="0">
                                    <RowStyle CssClass="tlrowlight" />
                                    <SelectedRowStyle />

                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Slno.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSlno" Text='<%# Bind("slno") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Test Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTestName" Text='<%# Bind("test_name") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnTestId" Value='<%# Bind("test_id") %>' />
                                                <asp:HiddenField runat="server" ID="hdnTestType" Value='<%# Bind("test_type") %>' />
                                                <asp:HiddenField runat="server" ID="hdnFrequency" Value='<%# Bind("frequency_code") %>' />
                                                <asp:HiddenField runat="server" ID="hdnStatus" Value='<%# Bind("status") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Frequency">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref Value">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Actual">
                                            <ItemTemplate>
                                                <asp:Label ID="lblResultValue" Text='<%# Bind("result_value")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qualify Y/N">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" Style="font-weight: bold" Text='<%# Bind("status")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Action" Visible="false">
                                            <HeaderTemplate>
                                                <span>View</span>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Panel runat="server" ID="pnlValid" Visible="false"><i class="fas fa-check-circle checkIcon"></i></asp:Panel>
                                                <asp:Panel runat="server" ID="pnlInvalid" Visible="false"><i class="fas fa-times-circle crossIcon"></i></asp:Panel>
                                                <%--<asp:Button ID="imgBtnSubmit" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandName="EditTest"></asp:Button>--%>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>

                                <asp:GridView ID="gvExteriorTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="true" PageSize="20" CssClass="upgradDataGrid" border="1" CellSpacing="0" CellPadding="0">
                                    <RowStyle CssClass="tlrowlight" />
                                    <SelectedRowStyle />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Slno.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSlno" Text='<%# Bind("slno") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Test Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTestName" Text='<%# Bind("test_name") %>' runat="server" />
                                                <asp:HiddenField runat="server" ID="hdnTestId" Value='<%# Bind("test_id") %>' />
                                                <asp:HiddenField runat="server" ID="hdnTestType" Value='<%# Bind("test_type") %>' />
                                                <asp:HiddenField runat="server" ID="hdnFrequency" Value='<%# Bind("frequency_code") %>' />
                                                <asp:HiddenField runat="server" ID="hdnStatus" Value='<%# Bind("status") %>' />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Frequency">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequency" Text='<%# Bind("frequency")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref Value">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRefValue" Text='<%# Bind("refvalue")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Actual">
                                            <ItemTemplate>
                                                <asp:Label ID="lblResultValue" Text='<%# Bind("result_value")%>' runat="server" />
                                                <asp:HiddenField ID="hdnResultValue" Value='<%# Bind("result_value")%>' runat="server" />
                                                <%-- <asp:DropDownList runat="server" class="form-control form-control-sm" ID="ddlResultValue" Visible="false"></asp:DropDownList>
                                                    <asp:TextBox runat="server" class="form-control form-control-sm" ID="txtResultValue" Visible="false" oninput="validateObtainedScore(this);"></asp:TextBox>--%>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qualify Y/N">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" Style="font-weight: bold" Text='<%# Bind("status")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Action" Visible="false">
                                            <HeaderTemplate>
                                                <span>View</span>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Panel runat="server" ID="pnlValid" Visible="false"><i class="fas fa-check-circle checkIcon"></i></asp:Panel>
                                                <asp:Panel runat="server" ID="pnlInvalid" Visible="false"><i class="fas fa-times-circle crossIcon"></i></asp:Panel>
                                            </ItemTemplate>
                                            <ControlStyle></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Quality Details Popup--%>

    <%--Audit Details Popup--%>
    <asp:HiddenField ID="HiddenField2" runat="server" />
    <asp:ModalPopupExtender ID="mpAudit" runat="server"
        PopupControlID="Panel3" TargetControlID="HiddenField2">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel3" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Audit Details</h5>
                <asp:Button ID="btnAuditClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnAuditClosePopup_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="row mb-1">
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Target Score:</label>
                                    <asp:TextBox ID="txtAuditTargetScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Score:</label>
                                    <asp:TextBox ID="txtAuditObtainScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Percentage:</label>
                                    <asp:TextBox ID="txtAuditObtainPercentage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Weightage:</label>
                                    <asp:TextBox ID="txtAuditObtainWeightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <hr />

                        <asp:GridView ID="gvAuditDetails" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <%--<asp:TemplateField HeaderText="Parameter ID" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <%--<asp:Label ID="lblPId" Text='<%# Bind("ap_p_id") %>' runat="server"/>--%>
                                <%--<asp:HiddenField runat="server" ID="lblPId" Value='<%# Bind("ap_p_id") %>' />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="Parameter Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParameterType" Text='<%# Bind("ap_parameter_type")%>' runat="server" />
                                        <asp:HiddenField runat="server" ID="lblPId" Value='<%# Bind("ap_p_id") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Parameter Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParameterName" Text='<%# Bind("ap_parameter_name")%>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Width="55%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Max Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMaxScore" Text='<%# Bind("ap_max_score")%>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnMaxScore" Value='<%# Bind("ap_max_score") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Obtained Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblObtainedScore" Text='<%# Bind("ah_obtained_score")%>' runat="server" />
                                        <%--    <asp:TextBox ID="txtObtainedScore" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("ah_obtained_score") %>' oninput="validateObtainedScore(this);"/>--%>
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Audit Details Popup--%>

    <%--Complaints Details Popup--%>

    <asp:HiddenField ID="HiddenField3" runat="server" />
    <asp:ModalPopupExtender ID="mpComplaints" runat="server"
        PopupControlID="Panel4" TargetControlID="HiddenField3">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel4" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Complaints Details</h5>
                <asp:Button ID="btnComplaintsClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnComplaintsClosePopup_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="row mb-1">
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Target Score:</label>
                                    <asp:TextBox ID="txtCompTargetScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Score:</label>
                                    <asp:TextBox ID="txtCompObtainScore" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                            <%--<div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Total Obtain Percentage:</label>
                                        <asp:TextBox ID="txtCompObtainPercentage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>--%>
                            <div class="col-md-3">
                                <div class="form-group pb-0">
                                    <label class="form-control-label">Total Obtain Weightage:</label>
                                    <asp:TextBox ID="txtCompObtainWeightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <hr />

                        <asp:GridView ID="gvComplaintsDtls" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Total Complaints">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTotalComp" Text='<%# Bind("vcd_total_complaints") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnVendorId" Value='<%# Bind("vch_vendor_id") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Justified Complaints">
                                    <ItemTemplate>
                                        <asp:Label ID="lblJustComp" Text='<%# Bind("vcd_total_justified_complaints") %>' runat="server" />
                                        <asp:HiddenField runat="server" ID="hdnHeaderId" Value='<%# Bind("vch_header_id") %>' />
                                        <asp:HiddenField runat="server" ID="hdnDtlsId" Value='<%# Bind("vcd_vch_dtls_id") %>' />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total Volume(Kg)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvol" Text='<%# Bind("mavd_avg_vol") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Complaint Tendency Ratio">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTendRatio" Text='<%# Bind("vch_complaint_tendency_ratio") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Max Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTotalMaxScr" Text='<%# Bind("vch_total_max_score") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Obtain Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblObtScr" Text='<%# Bind("vch_total_obtain_score") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:TemplateField>

                                <%-- <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:Button ID="btnView" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("vch_vendor_id") & "|" & Eval("vch_quarter_id") %>'
                                                            Text="View" CssClass="btn btn-info btn-sm" />
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" Width="6%" />
                                                </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Complaints Details Popup--%>

    <%-- Service Details Popup--%>
    <%--   <asp:HiddenField ID="HiddenField6" runat="server" />
        <asp:ModalPopupExtender ID="mpService" runat="server"
            PopupControlID="Panel5" TargetControlID="HiddenField6">
        </asp:ModalPopupExtender>
        <asp:Panel ID="Panel5" runat="server" CssClass="modal-popup">
            <div class="modal-content-custom">
                <div class="modal-header-custom">
                    <h5>Service Details</h5>
                    <asp:Button ID="btnCloseServicePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnCloseServicePopup_Click" />
                </div>
                <div class="modal-body-custom">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>--%>


    <asp:HiddenField ID="HiddenField7" runat="server" />
    <asp:ModalPopupExtender ID="mpgrpService" runat="server"
        PopupControlID="Panel6" TargetControlID="HiddenField7">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel6" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5>Service Details</h5>
                <asp:Button ID="btnCloseServicegrp" runat="server" Text="×" CssClass="close-btn" OnClick="btnCloseServicegrp_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:Panel runat="server" ID="divProductGroup">
                            <div class="row mb-1">
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Vendor Serviceability:</label>
                                        <asp:TextBox ID="txtVendorServiceAblity" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Target Weightage:</label>
                                        <asp:TextBox ID="txtgrpServicetargetweightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Obtain Weightage:</label>
                                        <asp:TextBox ID="txtgrpServiceObtainweightage" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>

                            </div>
                            <hr />
                            <asp:GridView ID="gvgrpService" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid" OnRowCommand="gvgrpService_RowCommand">
                                <RowStyle CssClass="tlrowlight" />
                                <SelectedRowStyle />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Brand Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblbrandname" Text='<%# Bind("bm_brand_name") %>' runat="server" />
                                            <asp:HiddenField runat="server" ID="hdnbrandId" Value='<%# Bind("vgs_brand_id") %>' />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="20%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="(Depot+Direct) Total Dispatch">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldepotToltaldispatch" Text='<%# Bind("vgs_despatch_vol") %>' runat="server" />

                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Group Serviceablity">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTargetScore" Text='<%# Bind("vgs_group_serviceablity") %>' runat="server" />

                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:Button ID="btnView" runat="server" CommandName="ViewProductDetails" CommandArgument='<%# Eval("vgs_vendor_id") & "|" & Eval("vgs_brand_id") %>'
                                                Text="View" CssClass="btn btn-info btn-sm tableBtnXs" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                        <asp:Panel runat="server" ID="divProduct">
                            <div class="row mb-1">
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Product Group:</label>
                                        <asp:TextBox ID="txtServiceBrandName" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Product Group Volume:</label>
                                        <asp:TextBox ID="txtServiceTotalVol" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group pb-0">
                                        <label class="form-control-label">Product Group Serviceability:</label>
                                        <asp:TextBox ID="txtServiceGrpserviceablity" runat="server" class="form-control form-control-sm" Enabled="false" AutoComplete="off"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <asp:GridView ID="gvServiceDtls" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                                <RowStyle CssClass="tlrowlight" />
                                <SelectedRowStyle />
                                <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="headerGrid" />
                                <FooterStyle CssClass="footerGrid" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblprdname" Text='<%# Bind("productname") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="35%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Depot Total Dispatch">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldepotToltaldispatch" Text='<%# Bind("vs_depot_total_deptdispatch") %>' runat="server" />

                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Direct Total Dispatch">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTargetScore" Text='<%# Bind("vs_direct_total_deptdispatch") %>' runat="server" />

                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Depot Pending Dispatch">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPendingDispatch" Text='<%# Bind("vs_depot_pending_dispatch") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Direct Pending Dispatch">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldirectpendingdispatch" Text='<%# Bind("vs_direct_pending_dispatch") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Average Vol" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAvgvol" Text='<%# Bind("avgvol") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Dispatch Vol" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldispvol" Text='<%# Bind("total_diapatch_vol") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Final Serviceablity">
                                        <ItemTemplate>
                                            <asp:Label ID="txtFinalserv" Text='<%# Bind("vs_final_serviceablity") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Average Serviceablity" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="txtObtainedScore" Text='<%# Bind("obtain_percentage_service") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Obtained Weightage" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="txtObtainedScore" Text='<%# Bind("obtain_Weightage_service") %>' runat="server" />
                                        </ItemTemplate>
                                        <ControlStyle></ControlStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="10%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <div class="col-md-12 form-btn-mt" style="text-align: center">
                                <asp:Button ID="btnServiceBack" runat="server" Text="Back" CssClass="btn btn-danger btn-sm" OnClick="btnServiceBack_Click" />
                            </div>
                        </asp:Panel>




                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Service Details Popup--%>

    <%--LY TY Details Popup--%>
    <asp:HiddenField ID="HiddenField6" runat="server" />
    <asp:ModalPopupExtender ID="mpLYTyDetails" runat="server"
        PopupControlID="Panel5" TargetControlID="hdnOk">
    </asp:ModalPopupExtender>
    <asp:Panel ID="Panel5" runat="server" CssClass="modal-popup">
        <div class="modal-content-custom">
            <div class="modal-header">
                <h5>
                    <asp:Label runat="server" ID="lblLtTyPopHdr"></asp:Label></h5>
                <asp:Button ID="btnLyTyPop" runat="server" Text="×" CssClass="close-btn" OnClick="btnLyTyPop_Click" />
            </div>
            <div class="modal-body-custom">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>

                        <asp:GridView ID="gvLyTyDetails" runat="server" AutoGenerateColumns="false" CssClass="upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <SelectedRowStyle />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Unit Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParameterName" Text='<%# Bind("Vendor") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Width="35%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q1">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLyTyQ1" Text='<%# Bind("Q1") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q2">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLyTyQ2" Text='<%# Bind("Q2") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q3">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLyTyQ3" Text='<%# Bind("Q3") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Q4">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLyTyQ4" Text='<%# Bind("Q4") %>' runat="server" />
                                    </ItemTemplate>
                                    <ControlStyle></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>
    <%-- End Statutory Details Popup--%>
</asp:Content>
