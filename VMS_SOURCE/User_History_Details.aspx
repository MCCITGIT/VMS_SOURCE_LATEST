<%@ Page Title="User Profile List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="User_History_Details.aspx.vb" Inherits="User_History" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidationUserIdGroup.js"></script>
    <script type="text/javascript" src="Scripts/ValidationUser_history.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 119) { // button search (F8 keypress)
                if (validatedate()) {
                    __doPostBack(document.getElementById('btnSearch').name, '');
                }
            }
            if (event.keyCode == 120) { // button clear (F9 keypress)

                __doPostBack(document.getElementById('btnClear').name, '');
            }
        }
    </script>
    <script type="text/javascript">var cal1 = new CalendarPopup(); function FromDate_onclick() { }
        function ToDate_onclick() {
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">User Login History Details</h3>
                <p class="pageSubTitle">Login activity for the selected user</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">User Group:</label>
                                <asp:DropDownList ID="ddlUserGroup" CssClass="form-control select2" runat="server"></asp:DropDownList>
                                <asp:HiddenField ID="hdnUserGroup" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">User Id:</label>
                                <asp:DropDownList ID="ddlUserId" CssClass="form-control select2" runat="server">
                                    <asp:ListItem Value="0">Select</asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hdnUserId" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Period From:</label>
                                <asp:TextBox ID="txtFromDate" TextMode="Date" MaxLength="10" CssClass="form-control" runat="server"></asp:TextBox>
                                <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtFromDate,'FromDate','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="FromDate" alt="Calender" style="vertical-align: middle; border: 0" onclick="return FromDate_onclick()" />
                                </a>--%>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Period To:</label>
                                <asp:TextBox ID="txtToDate" TextMode="Date" MaxLength="10" CssClass="form-control" runat="server"></asp:TextBox>
                                <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtToDate,'ToDate','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="ToDate" alt="Calender" style="vertical-align: middle; border: 0" onclick="return ToDate_onclick()" />
                                </a>--%>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Search For:</label>
                                <asp:DropDownList ID="ddlSearchFor" CssClass="form-control select2" runat="server">
                                    <asp:ListItem>Detail</asp:ListItem>
                                    <asp:ListItem>Summary</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ImageUrl="images/ic_search.gif" ID="btnSearch" runat="server" />--%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="btnSearch" runat="server" OnClick="btnSearch_Click">Search</asp:LinkButton>
                                <asp:Button ID="btnClear" CssClass="btn btn-secondary btn-sm" runat="server" Text="Clear" />
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>
            </div>

            <div class="card">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div class="mst-panel-header" style="padding-top: 0;">
                        <div class="mst-panel-header-left">
                            <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                            <div>
                                <h5 class="mst-panel-title">User Login History Details</h5>
                                <p class="mst-panel-subtitle">Login activity for the selected user</p>
                            </div>
                        </div>
                    </div>
                    <div class="form-group ddlPageSize" style="display: flex; align-items: center; padding: 0 15px; display:none;">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div>
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <asp:HiddenField ID="hdnHistoryMode" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnHistoryPage" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnHistoryPageSize" runat="server" ClientIDMode="Static" />
                        <asp:GridView ID="gvUserHistory" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" style="margin-bottom: 0">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderText="User Id" DataField="uh_userid">
                                    <ItemStyle HorizontalAlign="center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="User Group" DataField="uh_user_group">
                                    <ItemStyle HorizontalAlign="center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Logged Date" DataField="logdate">
                                    <ItemStyle HorizontalAlign="center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Logged Time" DataField="logtime">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>

                        <asp:GridView ID="gvUserHistoryCount" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" OnPageIndexChanging="gvUserHistoryCount_PageIndexChanging">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="User Id" DataField="uh_userid"></asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="From Date" DataField="fromDate"></asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="To Date" DataField="toDate"></asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Total Count" DataField="totalCount"></asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        $(function () {
            var pageIndex = parseInt($('#hdnHistoryPage').val(), 10) || 0;
            var loading = false;
            var noMoreData = false;
            var suppressScrollUntil = 0;
            var filters = {};

            function captureFilters() {
                filters.userGroup = $('#<%= ddlUserGroup.ClientID %>').val() || '';
                filters.userId = $('#<%= hdnUserId.ClientID %>').val() || '';
                filters.fromDate = $('#<%= txtFromDate.ClientID %>').val() || '';
                filters.toDate = $('#<%= txtToDate.ClientID %>').val() || '';
                filters.searchType = $('#hdnHistoryMode').val() || $('#<%= ddlSearchFor.ClientID %>').val() || 'Detail';
                filters.pageSize = parseInt($('#hdnHistoryPageSize').val(), 10) || 15;
                pageIndex = parseInt($('#hdnHistoryPage').val(), 10) || 0;
            }

            function gridSel() {
                return filters.searchType === 'Summary'
                    ? '#<%= gvUserHistoryCount.ClientID %>'
                    : '#<%= gvUserHistory.ClientID %>';
            }

            function dataRows() {
                return $(gridSel() + ' tbody tr').not('.hist-skel').not('.headerGrid').not('.PagerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function placeRows(html) {
                var $pager = $(gridSel()).find('tr.PagerGrid').first();
                if ($pager.length) $pager.before(html);
                else $(gridSel()).find('tbody').append(html);
            }

            function loadNext($el) {
                if (!$('#hdnHistoryMode').val() || loading || noMoreData || dataRows().length === 0) return;
                loading = true;
                pageIndex++;
                showHistorySkeleton($el);

                PageMethods.GetMoreUserHistory(pageIndex, filters.pageSize, filters.userGroup, filters.userId, filters.fromDate, filters.toDate, filters.searchType,
                    function (result) {
                        hideHistorySkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        $.each(result.rows, function (i, r) {
                            appendHistoryRow(r);
                        });
                        if ((pageIndex + 1) * filters.pageSize >= result.total || result.rows.length < filters.pageSize) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel()).closest('.table-responsive');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                    },
                    function () {
                        hideHistorySkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showHistorySkeleton($scroll) {
                if ($(gridSel()).find('tr.hist-skel').length) return;
                var widths = ['62%', '70%', '58%', '48%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight hist-skel">';
                    for (var c = 0; c < 4; c++) {
                        html += '<td align="center"><span class="grid-skel-bar" style="width:' + widths[(c + r) % 4] + ';"></span></td>';
                    }
                    html += '</tr>';
                }
                placeRows(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideHistorySkeleton() {
                var $rows = $(gridSel()).find('tr.hist-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendHistoryRow(r) {
                var html;
                if (filters.searchType === 'Summary') {
                    html = '<tr class="tlrowlight">' +
                        '<td align="center">' + esc(r.uh_userid) + '</td>' +
                        '<td align="center">' + esc(r.fromDate) + '</td>' +
                        '<td align="center">' + esc(r.toDate) + '</td>' +
                        '<td align="center">' + esc(r.totalCount) + '</td>' +
                        '</tr>';
                } else {
                    html = '<tr class="tlrowlight">' +
                        '<td align="center">' + esc(r.uh_userid) + '</td>' +
                        '<td align="center">' + esc(r.uh_user_group) + '</td>' +
                        '<td align="center">' + esc(r.logdate) + '</td>' +
                        '<td align="center">' + esc(r.logtime) + '</td>' +
                        '</tr>';
                }
                placeRows(html);
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            function bindHistoryScroll() {
                captureFilters();
                noMoreData = false;
                loading = false;
                var $scroll = $('.table-responsive').has(gridSel()).first();
                if (!$scroll.length) $scroll = $('.table-responsive').first();
                $scroll.off('scroll.histskel').on('scroll.histskel', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($scroll.scrollTop() + $scroll.innerHeight() < $scroll[0].scrollHeight - 50) return;
                    loadNext($scroll);
                });
                if ($('#hdnHistoryMode').val() && dataRows().length > 0 && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
            }

            bindHistoryScroll();
            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(bindHistoryScroll);
            }
        });
    </script>
</asp:Content>
