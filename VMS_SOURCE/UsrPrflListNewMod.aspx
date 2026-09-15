<%@ Page Title="User Profile List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UsrPrflListNewMod.aspx.vb" Inherits="UsrPrflListNewMod" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

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
            <div class="form-group ddlPageSize" style="display: flex; align-items: center; padding: 0 15px;">
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
                <asp:GridView ID="gvUserProfile" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                    Visible="true" OnRowDataBound="gvUserProfile_RowDataBound" OnPageIndexChanging="gvUserProfile_IndexChanging" CssClass="table table-hover upgradDataGrid">
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
</asp:Content>
