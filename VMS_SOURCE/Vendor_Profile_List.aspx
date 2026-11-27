<%@ Page Title="Production Vendor Master" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Vendor_Profile_List.aspx.vb" Inherits="Vendor_Profile_List" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { //Add (F7 keypress)
                //	            if (ValidateVandorUnit())
                //{
                document.getElementById('ImgbtnAdd').click()
                //}

            }
            //            else if(event.keyCode == 119)
            //	        { // button Search (F8 keypress)
            //	            __doPostBack(document.getElementById('btnCancel').name,'');
            //	        }
            //	        else if(event.keyCode == 120)
            //	        { // button Search (F9 keypress)
            //	            __doPostBack(document.getElementById('btnReset').name,'');
            //	        }
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Production Vendor Master</h3>
                <p class="pageSubTitle">Browse and manage production vendors</p>
            </div>
        </div>
        <div class="rightFung">
            <asp:LinkButton ID="ImgbtnAdd" runat="server" class="btn btn-success btn-sm" OnClick="ImgbtnAdd_Click">Add</asp:LinkButton>
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
            <div class="form-group ddlPageSize"  style="display: flex; align-items: center; padding: 0px; display:none;">
                <label for="ddlPageSize" class="col-auto form-control-label">
                    <asp:Label ID="Label1" runat="server" Text="Results Per Page:"></asp:Label>
                </label>
                <div>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvVendorProfile" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                            OnRowDataBound="gvVendorProfile_RowDataBound" Visible="true" BorderWidth="1" style="margin-bottom: 0" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <%--<asp:BoundField HeaderText="Unit Code" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left"
                            DataField="unit_code" />
                         <ItemStyle HorizontalAlign="Center" Width="10%" />
                        </asp:BoundField>  --%>

                                <asp:BoundField HeaderText="Source Code" DataField="unit_code">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Source Name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataField="unit_name">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Status" HeaderStyle-HorizontalAlign="Center" DataField="active">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Created User" HeaderStyle-HorizontalAlign="Center" DataField="created_user">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>


                                <asp:BoundField HeaderText="Created Date" HeaderStyle-HorizontalAlign="Center" DataField="created_date">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlPageSize"
                            EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var pageIndex = 0;
            var loading = false;
            var noMoreData = false;
            var suppressScrollUntil = 0;
            var gridSel = '#<%= gvVendorProfile.ClientID %>';
            var pageSize = parseInt($('#<%= ddlPageSize.ClientID %>').val(), 10) || 15;

            function dataRows() {
                return $(gridSel + ' tbody tr').not('.vendor-skel').not('.headerGrid').not('.PagerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function loadNext($el) {
                if (loading || noMoreData || dataRows().length === 0) return;
                loading = true;
                pageIndex++;
                showVendorSkeleton($el);

                PageMethods.GetMoreVendorProfiles(pageIndex, pageSize,
                    function (result) {
                        hideVendorSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        var $tbody = $(gridSel + ' tbody');
                        $.each(result.rows, function (i, r) {
                            appendVendorRow($tbody, r, pageIndex * pageSize + i + 1);
                        });
                        if (dataRows().length >= result.total || result.rows.length < pageSize) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.table-responsive');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                    },
                    function () {
                        hideVendorSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showVendorSkeleton($scroll) {
                var $tbody = $(gridSel + ' tbody');
                if (!$tbody.length || $tbody.find('tr.vendor-skel').length) return;
                var widths = [
                    ['16px', '55%', '72%', '48%', '64%', '58%'],
                    ['16px', '48%', '64%', '42%', '70%', '50%'],
                    ['16px', '60%', '78%', '52%', '58%', '66%']
                ];
                var aligns = ['center', 'center', 'center', 'center', 'center', 'center'];
                var colWidths = ['5%', '10%', '15%', '10%', '15%', '15%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight vendor-skel">';
                    for (var c = 0; c < colWidths.length; c++) {
                        html += '<td align="' + aligns[c] + '" style="width:' + colWidths[c] + ';"><span class="grid-skel-bar" style="width:' + widths[r][c] + ';"></span></td>';
                    }
                    html += '</tr>';
                }
                $tbody.append(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideVendorSkeleton() {
                var $rows = $(gridSel + ' tbody tr.vendor-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendVendorRow($tbody, r, slNo) {
                var active = String(r.active || '').toLowerCase() === 'y';
                var nameLink = '<a href="Vendor_Profile_Add.aspx?UnitCode=' + encodeURIComponent(r.unit_code || '') + '" class="gridlink">' + esc(r.unit_name) + '</a>';
                var rowStyle = active ? '' : ' style="background-color:Red;color:White;"';
                $tbody.append(
                    '<tr class="tlrowlight"' + rowStyle + '>' +
                    '<td align="center" style="width:5%;">' + slNo + '</td>' +
                    '<td align="center" style="width:10%;">' + esc(r.unit_code) + '</td>' +
                    '<td align="center" style="width:15%;">' + nameLink + '</td>' +
                    '<td align="center" style="width:10%;">' + (active ? 'Active' : 'InActive') + '</td>' +
                    '<td align="center" style="width:15%;">' + esc(r.created_user) + '</td>' +
                    '<td align="center" style="width:15%;">' + esc(r.created_date) + '</td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            function bindVendorScroll() {
                var $scroll = $(gridSel).closest('.table-responsive');
                $scroll.off('scroll.vendorskel').on('scroll.vendorskel', function () {
                    if (Date.now() < suppressScrollUntil) return;
                    if ($scroll.scrollTop() + $scroll.innerHeight() < $scroll[0].scrollHeight - 50) return;
                    loadNext($scroll);
                });
                if ($scroll.length && dataRows().length > 0 && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
            }

            bindVendorScroll();
            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    pageIndex = 0;
                    noMoreData = false;
                    loading = false;
                    pageSize = parseInt($('#<%= ddlPageSize.ClientID %>').val(), 10) || 15;
                    bindVendorScroll();
                });
            }
        });
    </script>
</asp:Content>
