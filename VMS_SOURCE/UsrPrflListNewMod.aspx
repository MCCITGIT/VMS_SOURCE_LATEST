<%@ Page Title="User Profile List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UsrPrflListNewMod.aspx.vb" Inherits="UsrPrflListNewMod" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>

    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) {  // button Add (F7 keypress)	    		    
                __doPostBack(document.getElementById('ImgbtnAdd').name, '');
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)

                __doPostBack(document.getElementById('ImgbtnSearch').name, '');
            }
        }
        //-->
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">User Profile List</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Depot:</label>
                        <asp:DropDownList ID="ddlBranch" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">Department:</label>
                        <asp:DropDownList ID="ddlDepartment" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="form-control-label">User Group:</label>
                        <asp:DropDownList ID="ddlUserGroup" CssClass="form-control select2" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Search User Name:</label>
                        <asp:TextBox ID="txtSearchUserName" CssClass="form-control" runat="server" placeholder="Enter here..."></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <asp:LinkButton ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click" CssClass="btn btn-primary btn-sm">Search</asp:LinkButton>
                        <asp:LinkButton ID="ImgbtnAdd" runat="server" OnClick="ImgbtnAdd_Click" CssClass="btn btn-success btn-sm">Add</asp:LinkButton>
                        <asp:LinkButton ID="ImgbtnPrint" runat="server" OnClick="ImgbtnPrint_Click" CssClass="btn btn-warning btn-sm">Print</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header" style="padding-top: 0;">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">User Profile List</h5>
                        <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="display: flex; align-items: center; padding: 0 15px;display:none;">
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
                <asp:GridView ID="gvUserProfile" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                    Visible="true" OnRowDataBound="gvUserProfile_RowDataBound" CssClass="table table-hover upgradDataGrid">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Sl.No."></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="User Id" DataField="usp_user_id"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Department" DataField="usp_dept"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="User Name" DataField="usp_name"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Branch" DataField="usp_branch"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Region" DataField="usp_region"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Designation" DataField="usp_desig"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="User Group" DataField="usp_group_code"></asp:BoundField>
                        <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Status" DataField="active"></asp:BoundField>
                    </Columns>
                </asp:GridView>
                <div id="Div_User_List_Grid" runat="server" visible="false">
                    <table class="table table-hover upgradDataGrid" border="1">
                        <tbody>
                            <tr class="headerGrid">
                                <th style="text-align: center;">Sl.No.</th>
                                <th style="text-align: center;">User Id</th>
                                <th style="text-align: center;">User Name</th>
                                <th style="text-align: center;">Branch</th>
                                <th style="text-align: center;">Region</th>
                                <th style="text-align: center;">Department</th>
                                <th style="text-align: center;">Designation</th>
                                <th style="text-align: center;">User Group</th>
                            </tr>
                            <tr class="tlrowlight">
                                <td style="text-align: center;" colspan="8">No Records Found</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var pageIndex = 0;
            var loading = false;
            var noMoreData = false;
            var suppressScrollUntil = 0;
            var gridSel = '#<%= gvUserProfile.ClientID %>';
            var filters = {
                branch: $('#<%= ddlBranch.ClientID %>').val() || '',
                department: $('#<%= ddlDepartment.ClientID %>').val() || '',
                userGroup: $('#<%= ddlUserGroup.ClientID %>').val() || '',
                userName: $('#<%= txtSearchUserName.ClientID %>').val() || '',
                pageSize: parseInt($('#<%= ddlPageSize.ClientID %>').val(), 10) || 15
            };

            function dataRows() {
                return $(gridSel + ' tbody tr').not('.usr-skel').not('.headerGrid').filter(function () {
                    return $(this).children('td[colspan]').length === 0;
                });
            }

            function loadNext($el) {
                if (loading || noMoreData || dataRows().length === 0) return;
                loading = true;
                pageIndex++;
                showUserSkeleton($el);

                PageMethods.GetMoreUserProfiles(pageIndex, filters.branch, filters.userGroup, filters.userName, filters.department, filters.pageSize,
                    function (result) {
                        hideUserSkeleton();
                        if (!result || !result.rows || result.rows.length === 0) {
                            noMoreData = true;
                            loading = false;
                            return;
                        }
                        var $tbody = $(gridSel + ' tbody');
                        $.each(result.rows, function (i, r) {
                            appendUserRow($tbody, r, pageIndex * filters.pageSize + i + 1);
                        });
                        if (dataRows().length >= result.total || result.rows.length < filters.pageSize) noMoreData = true;
                        loading = false;
                        var $scroll = $(gridSel).closest('.table-responsive');
                        if (!noMoreData && $scroll.length && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
                    },
                    function () {
                        hideUserSkeleton();
                        pageIndex--;
                        loading = false;
                    }
                );
            }

            function showUserSkeleton($scroll) {
                var $tbody = $(gridSel + ' tbody');
                if (!$tbody.length || $tbody.find('tr.usr-skel').length) return;
                var widths = ['46px', '70%', '62%', '78%', '66%', '54%', '60%', '48%', '40%'];
                var html = '';
                for (var r = 0; r < 3; r++) {
                    html += '<tr class="tlrowlight usr-skel">';
                    for (var c = 0; c < widths.length; c++) {
                        var w = c === 0 ? '16px' : widths[c];
                        html += '<td align="center"><span class="grid-skel-bar" style="width:' + w + ';"></span></td>';
                    }
                    html += '</tr>';
                }
                $tbody.append(html);
                suppressScrollUntil = Date.now() + 200;
                if ($scroll && $scroll.length) $scroll.scrollTop($scroll[0].scrollHeight);
            }

            function hideUserSkeleton() {
                var $rows = $(gridSel + ' tbody tr.usr-skel');
                if (!$rows.length) return;
                suppressScrollUntil = Date.now() + 200;
                $rows.remove();
            }

            function appendUserRow($tbody, r, slNo) {
                var active = String(r.active || '').toLowerCase() === 'y';
                var nameLink = '<a href="UsrPrfileAddNewMod.aspx?UserId=' + encodeURIComponent(r.usp_user_id || '') + '" class="gridlink">' + esc(r.usp_name) + '</a>';
                var rowStyle = active ? '' : ' style="background-color:Red;color:White;"';
                $tbody.append(
                    '<tr class="tlrowlight"' + rowStyle + '>' +
                    '<td align="center">' + slNo + '</td>' +
                    '<td align="center">' + esc(r.usp_user_id) + '</td>' +
                    '<td align="center">' + esc(r.usp_dept) + '</td>' +
                    '<td align="center">' + nameLink + '</td>' +
                    '<td align="center">' + esc(r.usp_branch) + '</td>' +
                    '<td align="center">' + esc(r.usp_region) + '</td>' +
                    '<td align="center">' + esc(r.usp_desig) + '</td>' +
                    '<td align="center">' + (active ? 'Active' : 'InActive') + '</td>' +
                    '<td align="center">' + esc(r.active) + '</td>' +
                    '</tr>'
                );
            }

            function esc(v) {
                return $('<div>').text(v == null ? '' : v).html();
            }

            var $scroll = $(gridSel).closest('.table-responsive');
            $scroll.on('scroll', function () {
                if (Date.now() < suppressScrollUntil) return;
                if ($scroll.scrollTop() + $scroll.innerHeight() < $scroll[0].scrollHeight - 50) return;
                loadNext($scroll);
            });
            if ($scroll.length && dataRows().length > 0 && $scroll[0].scrollHeight <= $scroll.innerHeight() + 1) loadNext($scroll);
        });
    </script>
</asp:Content>
