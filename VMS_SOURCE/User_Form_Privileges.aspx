<%@ Page Title="User Form Privileges " Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="User_Form_Privileges.aspx.vb" Inherits="User_Form_Access" %>

<%--<%@ Register TagPrefix="uc1" TagName="Footer" Src="includes/Footer.ascx" %>--%>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server"></asp:Content>--%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">User Form Privileges</h3>
                <p class="pageSubTitle">Grant form level privileges to users</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <div class="mst-panel-header">
                <div class="mst-panel-header-left">
                    <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                    <div>
                        <h5 class="mst-panel-title">User Form Privileges</h5>
                        <p class="mst-panel-subtitle">Grant form level privileges to users</p>
                    </div>
                </div>
            </div>
            <div class="form-group ddlPageSize" style="display: flex; align-items: center;">
                <label class="col-auto form-control-label">User Group</label>
                <div style="min-width: 180px;">
                    <asp:DropDownList ID="ddlUsrGrp" CssClass="form-control select2" runat="server" AutoPostBack="true"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="card-body">

            <div class="table-responsive">
                <asp:GridView ID="gvUsrFrmAccess" runat="server" AutoGenerateColumns="false" AllowPaging="False" ShowFooter="true"
                    Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid"
                    OnRowCancelingEdit="gvUsrFrmAccess_RowCancelingEdit" OnRowEditing="gvUsrFrmAccess_RowEditing">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="Sl.No." HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblSerialNo" runat="server" Text=''></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Form name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Label ID="lblFormName" runat="server" Text='<%# Bind("FORM_DESC") %>'></asp:Label>
                                <asp:HiddenField ID="hdnFormCode" runat="server" Value='<%# Bind("FORM_CODE") %>' />
                            </ItemTemplate>
                            <%--<EditItemTemplate>
                                    <asp:TextBox ID="txtFormName" CssClass="txtBox" runat="server" Width="75px" Text='<%# Bind("FORM_DESC") %>'></asp:TextBox>
                                </EditItemTemplate>   --%>                         
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Read" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkRead" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkRead" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Add" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkAdd" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkAdd" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkEdit" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkEdit" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Delete" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkDelete" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkDelete" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Print" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkPrint" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkPrint" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Approval" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="ChkApproval" runat="server" Width="75px" Enabled="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="ChkApproval" runat="server" Width="75px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Quick Link" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlQuickLink" runat="server" CssClass="form-control" Enabled="false" DataValueField='<%# Bind("QUICK_LINK") %>'>
                                    <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlQuickLink" runat="server" CssClass="form-control" DataValueField='<%# Bind("QUICK_LINK") %>'>
                                    <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnEdit" CommandName="edit" runat="server" ImageUrl="~/Images/edit.jpg" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="btnUpdate" CommandName="update" runat="server" ImageUrl="~/Images/b_save.gif" />
                                <asp:ImageButton ID="btnCancel" CommandName="cancel" runat="server" ImageUrl="~/Images/b_cancel.gif" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div id="Div_Usr_Frm_Access_Grid" runat="server" visible="false">
                    <table class="table table-hover upgradDataGrid" border="1">
                        <tbody>
                            <tr class="headerGrid">
                                <td style="width: 114px; height: 20px;" align="center">Sl No</td>
                                <td style="width: 114px; height: 20px;" align="center">Form Name</td>
                                <td style="width: 114px; height: 20px;" align="center">Read</td>
                                <td style="width: 114px; height: 20px;" align="center">Add</td>
                                <td style="width: 114px; height: 20px;" align="center">Edit </td>
                                <td style="width: 114px; height: 20px;" align="center">Delete</td>
                                <td style="width: 114px; height: 20px;" align="center">Print</td>
                                <td style="width: 114px; height: 20px;" align="center">Approval</td>
                                <td style="width: 114px; height: 20px;" align="center">QuickLink</td>
                            </tr>
                            <tr class="tlrowlight">
                                <td style="text-align: center;" colspan="9">No Records Found</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
