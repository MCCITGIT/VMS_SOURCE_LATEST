<%@ Page Title="Test CaseTest List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="TestCaseTestMasterList.aspx.vb" Inherits="TestCaseTestMasterList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="Scripts/ValidateUnitApplicableVendorAssign.js?key=<%= DateTime.Now.ToString %>"></script>
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

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Test CaseTest List</h3>
                <p class="pageSubTitle">Browse quality test case records</p>
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
                                <label class="form-control-label">Frequency:</label>
                                <asp:DropDownList ID="ddlFrequency" CssClass="form-control select2" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Result Type:</label>
                                <asp:DropDownList ID="ddlResultType" CssClass="form-control select2" runat="server" AutoPostBack="True" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Test Name:</label>
                                <asp:TextBox ID="txtTestName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <asp:Button ID="imgbtnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" />
                            <asp:Button ID="imgbtnAdd" runat="server" Text="Add" CssClass="btn btn-success btn-sm" />
                        </div>
                    </div>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:HiddenField ID="hdnTestHasData" runat="server" Value="0" />
                            <asp:HiddenField ID="hdnTestPageSize" runat="server" Value="20" />
                            <asp:HiddenField ID="hdnTestFrequency" runat="server" />
                            <asp:HiddenField ID="hdnTestResultType" runat="server" />
                            <asp:HiddenField ID="hdnTestName" runat="server" />
                            <div class="table-responsive tcl-grid-scroll">
                                <asp:GridView ID="gvTestList" runat="server" AutoGenerateColumns="False" EmptyDataText="No records found" AllowPaging="false" PageSize="20" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                                    <RowStyle CssClass="tlrowlight" />
                                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                    <HeaderStyle CssClass="headerGrid" />
                                    <FooterStyle CssClass="footerGrid" />
                                    <Columns>
                                        <%-- <asp:TemplateField HeaderText="Test Id" ControlStyle-Width="90%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRequistionId" Text='<%# Bind("test_id") %>' runat="server" />
                                                </ItemTemplate>
                                                <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="4%" />
                                            </asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Test Name" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUnit" Text='<%# Bind("test_name") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="8%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Frequency" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVendor" Text='<%# Bind("frequency_value")%>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="6%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Result Type" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSiteName" Text='<%# Bind("test_type_value") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref Value" ControlStyle-Width="90%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRefValue" Text='<%# Bind("ref_value") %>' runat="server" />
                                            </ItemTemplate>
                                            <ControlStyle Height="90%" Width="90%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Action" ControlStyle-Width="100%">
                                            <HeaderTemplate>
                                                <span>View</span>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                            <%--    <asp:Button ID="imgBtnSubmit" CommandName="EditTest" Visible="true" runat="server" CssClass="btn btn-info gridBtn" Text="View" title="View" ToolTip="View" CommandArgument='<%# Bind("test_id") %>'></asp:Button>
                                                --%>
                                                    <asp:LinkButton ID="btnView" runat="server" Visible="true" CommandName="EditTest" CommandArgument='<%# Bind("test_id") %>' ToolTip="View"><i class="fa fa-eye"></i></asp:LinkButton>
                                            </ItemTemplate>
                                            <ControlStyle Width="100%"></ControlStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" Width="4%" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="imgbtnSearch" EventName="Click" />
                            <asp:PostBackTrigger ControlID="gvTestList" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <style type="text/css">
        .tcl-grid-scroll,
        .tcl-grid-scroll table,
        .tcl-grid-scroll tr,
        .tcl-grid-scroll td {
            overflow-anchor: none;
        }
        .tcl-grid-scroll {
            overscroll-behavior: contain;
        }
    </style>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvTestList.ClientID %>';
            var pageIndex = 0, pageSize = 20, total = 0, loading = false, noMore = false, seq = 0;
            var filters = { frequency: '', resultType: '', name: '' };

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.tcl-skel'); }
            function scrollBox() { return $(gridSel).closest('.tcl-grid-scroll'); }
            function capture() {
                filters.frequency = $('#<%= hdnTestFrequency.ClientID %>').val() || '';
                filters.resultType = $('#<%= hdnTestResultType.ClientID %>').val() || '';
                filters.name = $('#<%= hdnTestName.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnTestPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 20;
                total = 0;
            }
            function skel() {
                var widths = ['80%', '60px', '70px', '70px', '18px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight tcl-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                $(gridSel).find('tbody').append($rows);
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnTestHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                if (!window.PageMethods || typeof PageMethods.GetMoreTestCases !== 'function') {
                    $(gridSel + ' tr.tcl-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                    return;
                }
                PageMethods.GetMoreTestCases(pageIndex, pageSize, filters.frequency, filters.resultType, filters.name, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.tcl-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) {
                        var r = res.rows[i];
                        html += '<tr class="tlrowlight">'
                            + '<td style="text-align:center">' + esc(r.name) + '</td>'
                            + '<td style="text-align:center">' + esc(r.frequency) + '</td>'
                            + '<td style="text-align:center">' + esc(r.resultType) + '</td>'
                            + '<td style="text-align:center">' + esc(r.refValue) + '</td>'
                            + '<td style="text-align:center"><a href="TestCaseTestMasterAddUpdate.aspx?id=' + esc(r.id) + '" title="View"><i class="fa fa-eye"></i></a></td></tr>';
                    }
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.tcl-skel').remove();
                    loading = false;
                    pageIndex--;
                    noMore = true;
                });
            }
            function onScroll() {
                if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                $(gridSel + ' tr.tcl-skel').remove();
                capture();
                var box = scrollBox();
                box.off('scroll.tcl').on('scroll.tcl', onScroll);
                setTimeout(function () {
                    var live = scrollBox();
                    if ($('#<%= hdnTestHasData.ClientID %>').val() === '1' && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, 0);
            }
            $(bind);
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                    try {
                        if (args.get_error && args.get_error()) return;
                        var updated = args.get_panelsUpdated() || [];
                        for (var i = 0; i < updated.length; i++) {
                            if ($(updated[i]).find(gridSel).length) { bind(); break; }
                        }
                    } catch (e) { }
                });
            }
        })();
    </script>
</asp:Content>
