<%@ Page Title="LOV Master List" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Lov_Master_List.aspx.vb" Inherits="Lov_Master_List" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="Scripts/ValidationLovMaster.js"></script>

    <style>
        .lov-master-list-edit-item tbody tr td:last-child {
           display: flex;
           column-gap: 5px;
           justify-content: center;
        }
    </style>
    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">LOV Master List</h3>
                <p class="pageSubTitle">Maintain system lists of values</p>
            </div>
        </div>
        <div class="rightFung">
            <a href="Lov_Details_List.aspx" title="LOV Details" class="btn btn-success btn-sm">LOV Details</a>
        </div>
    </div>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">LOV Master List</h5>
                    <p class="mst-panel-subtitle">Maintain system lists of values</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <asp:Label ID="lblLOVCode" runat="server" Style="color: Red; font-size: small; font-weight: bold;"></asp:Label>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div id="divErrorMessage"></div>

            <div class="table-responsive">
                <asp:GridView ID="gvLovMstr" runat="server" AutoGenerateColumns="false" AllowPaging="false"
                    Visible="true" ShowFooter="true" BorderWidth="1px" EmptyDataText="There are No Data..."
                    OnRowCancelingEdit="gvLovMstr_RowCancelingEdit" OnRowEditing="gvLovMstr_RowEditing" CssClass="table table-hover upgradDataGrid lov-master-list-edit-item">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <asp:TemplateField HeaderText="LOV Type" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblLovType" runat="server" Text='<%# Bind("lov_Type") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtType" CssClass="form-control" runat="server" Text='<%# Bind("lov_Type") %>'></asp:TextBox>
                                <asp:HiddenField ID="hdntxtType" runat="server" Value='<%# Bind("lov_Type") %>' />
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtType" CssClass="form-control" runat="server"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LOV Desc" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblLovDesc" runat="server" Text='<%# Bind("lov_desc") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDesc" CssClass="form-control" runat="server" Text='<%# Bind("lov_desc") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtDesc" CssClass="form-control" runat="server"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LOV Value" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblLovValue" runat="server" Text='<%# Bind("lov_value") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList CssClass="form-control" ID="ddlValue" runat="server" DataTextField='<%# Bind("lov_value") %>' DataValueField='<%# Bind("lov_value") %>'>
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlValue" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LOV Seq" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblLovSeq" runat="server" Text='<%# Bind("lov_seq") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtSeq" CssClass="form-control" runat="server" Text='<%# Bind("lov_seq") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtSeq" CssClass="form-control" runat="server"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Field1 Type" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblField1" runat="server" Text='<%# Bind("lov_field1_type") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlField1" runat="server" CssClass="form-control" DataTextField='<%# Bind("lov_field1_type") %>' DataValueField='<%# Bind("lov_field1_type") %>'>
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlField1" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Field2 Type" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblField2" runat="server" Text='<%# Bind("lov_field2_type") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlField2" runat="server" CssClass="form-control" DataTextField='<%# Bind("lov_field2_type") %>' DataValueField='<%# Bind("lov_field2_type") %>'>
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlField2" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Field3 Type" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblField3" runat="server" Text='<%# Bind("lov_field3_type") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlField3" runat="server" CssClass="form-control" DataTextField='<%# Bind("lov_field3_type") %>' DataValueField='<%# Bind("lov_field3_type") %>'>
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlField3" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label ID="lblActive" runat="server" Text='<%# Bind("active") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control" DataTextField='<%# Bind("active") %>' DataValueField='<%# Bind("active") %>'>
                                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" CommandName="edit" runat="server" CssClass="btn btn-primary gridBtn">Edit</asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="btnUpdate" CommandName="update" runat="server" CssClass="btn btn-success gridBtn">Save</asp:LinkButton>
                                <asp:LinkButton ID="btnCancel" CommandName="cancel" runat="server" CssClass="btn btn-secondary gridBtn">Cancel</asp:LinkButton>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:LinkButton ID="btnInsert" CommandName="insert" runat="server" CssClass="btn btn-success gridBtn">Save</asp:LinkButton>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div id="Div_Lov_Mstr_Grid" runat="server" visible="false">
                    <table border="1" class="table table-hover upgradDataGrid">
                        <tr class="headerGrid">
                            <th style="text-align: center;">LOV Type</th>
                            <th style="text-align: center;">LOV Desc</th>
                            <th style="text-align: center;">LOV Value</th>
                            <th style="text-align: center;">LOV Seq</th>
                            <th style="text-align: center;">Field1 Type </th>
                            <th style="text-align: center;">Field2 Type</th>
                            <th style="text-align: center;">Field3 Type</th>
                            <th style="text-align: center;">Active</th>
                            <th style="text-align: center;">Action</th>
                        </tr>
                        <tr class="tlrowlight">
                            <td style="text-align: center;">
                                <asp:TextBox ID="txtType" CssClass="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td style="text-align: center;">
                                <asp:TextBox ID="txtDesc" CssClass="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td style="text-align: center;">
                                <asp:DropDownList ID="ddlValue" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: center;">
                                <asp:TextBox ID="txtSeq" CssClass="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td style="text-align: center;">
                                <asp:DropDownList ID="ddlField1" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: center;">
                                <asp:DropDownList ID="ddlField2" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: center;">
                                <asp:DropDownList ID="ddlField3" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="AlphaNum" Value="A"></asp:ListItem>
                                    <asp:ListItem Text="Numeric" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: center;">
                                <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: center;">
                                <asp:LinkButton ID="btnInsert" runat="server" CssClass="btn btn-success btn-sm">Save</asp:LinkButton>
                            </td>
                        </tr>
                        <tr class="tlrowlight">
                            <td style="text-align: center;" colspan="9">
                                <asp:Label ID="lblErrorMessage1" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                                <div id="divErrorMessage1"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
