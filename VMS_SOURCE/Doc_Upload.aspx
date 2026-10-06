<%@ Page Title="Doc Upload" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Doc_Upload.aspx.vb" Inherits="Doc_Upload" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script src="Scripts/red.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/Validation_Doc_Upload.js"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                document.getElementById('btnSubmit').click();
            }

            //            if (event.keyCode == 119) { // button Search (F8 keypress)

            //                __doPostBack(document.getElementById('btnCancel').name, '');

            //            }
            //	    else if(event.keyCode == 123){// button Pending (F12 keypress)
            //		    __doPostBack(document.getElementById('btnPending').name,'');
            //		    //alert("Pending");
            //	    }
        }
        function newwindow(page) {
            var docwindow = window.open(page, 'mywindow', 'width=600,height=400,toolbar=no,location=yes,directories=yes,status=yes,menubar=no,scrollbars=yes,copyhistory=yes,resizable = yes');
        }
    </script>
    <script type="text/javascript">
        var cal1 = new CalendarPopup();
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Document Upload</h3>
                <p class="pageSubTitle">Upload and manage supporting documents</p>
            </div>
        </div>
        <div class="rightFung">
            <%--<asp:ImageButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm" ImageUrl="images/ic_add.gif" /--%>
            <asp:LinkButton ID="ImgbtnAdd" runat="server" CssClass="btn btn-success btn-sm" OnClick="ImgbtnAdd_Click">Add</asp:LinkButton>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div class="mst-panel-header" style="padding-top: 0;">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <h5 class="mst-panel-title">Document Upload List</h5>
                            <p class="mst-panel-subtitle">Document Upload</p>
                        </div>
                    </div>
                </div>
                <div class="form-group ddlPageSize" style="display: flex; align-items: center; padding: 0px;">
                    <label for="ddlPageSize" class="col-auto form-control-label mr-2">
                        <asp:Label ID="Label1" runat="server" Text="Results Per Page:"></asp:Label>
                    </label>
                    <div>
                        <asp:DropDownList ID="ddlPageSize" CssClass="form-control select2" runat="server" AutoPostBack="true"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvMasterLinkDocList" runat="server" AutoGenerateColumns="false"
                    AllowPaging="True" Visible="true" OnPageIndexChanging="gvMasterLinkDocList_PageIndexChanging" OnRowDataBound="gvMasterLinkDocList_RowDataBound" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                    <RowStyle CssClass="tlrowlight" />
                    <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                    <HeaderStyle CssClass="headerGrid" />
                    <FooterStyle CssClass="footerGrid" />
                    <Columns>
                        <%--<asp:BoundField HeaderText="Sl. No.">
                                                                <ItemStyle HorizontalAlign="Center" Width="5%" />
                                                            </asp:BoundField>--%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'
                                    Font-Bold="True"></asp:Label>
                                <%--<asp:HiddenField ID="hdnGenId" runat="server" Value='<%# Bind("sdocs_gen_id") %>' />--%>
                                <asp:HiddenField ID="hdnFileName" runat="server" Value='<%# Bind("sdocs_file_name") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                        </asp:TemplateField>
                        <%--<asp:BoundField DataField="sdocs_from_depot" HeaderText="From Depot">
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:BoundField>--%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="From Depot">
                            <ItemTemplate>
                                <%--<asp:Label ID="lblFromDepot" runat="server" Width="94%" Text='<%# Bind("sdocs_from_depot") %>'
                                                                        Font-Bold="True"></asp:Label>--%>
                                <asp:LinkButton runat="server" ID="lnk_FrmDpt" CommandName="PopulateDtl" Text='<%# Bind("sdocs_from_depot") %>'></asp:LinkButton>
                                <asp:HiddenField ID="hdnGenId" runat="server" Value='<%# Bind("sdocs_gen_id") %>' />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="sdocs_to_depot" HeaderText="To Depot">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="sdocs_fin_year" HeaderText="Year">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="sdocs_doc_catg" HeaderText="Doc Type">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15%" />
                        </asp:BoundField>
                        <%--<asp:BoundField HeaderText="Document Title" DataField="sdocs_doc_title">
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                                            </asp:BoundField>--%>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Title">
                            <ItemTemplate>
                                <asp:Label ID="lblTitle" runat="server" Text='<%# Bind("sdocs_doc_title") %>' Font-Bold="True"></asp:Label>
                                <%-- <img id="img_new" src="images/ag_new2.gif" alt="New" style="border: 0" />--%>
                                <asp:Image ID="img_new" runat="server" ImageUrl="images/new0408.gif" Visible="False" />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                            <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="sdocs_doc_no" HeaderText="Doc No.">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="sdocs_doc_date" HeaderText="Date">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="sdocs_remarks" HeaderText="Remarks">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="17%" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>

                <div id="Div_MasterLinkDocs_Grid" visible="true" runat="server">
                    <table border="1" class="table table-hover upgradDataGrid">
                        <tr class="headerGrid">
                            <th style="text-align: center;">Sl. No.</th>
                            <th style="text-align: center;">From Depot</th>
                            <th style="text-align: center;">To Depot</th>
                            <th style="text-align: center;">Fin Year</th>
                            <th style="text-align: center;">Doc Type</th>
                            <th style="text-align: center;">Document Title</th>
                            <th style="text-align: center;">Doc No.</th>
                            <th style="text-align: center;">Date</th>
                            <th style="text-align: center;">Remarks</th>
                        </tr>
                        <tr class="tlrowlight">
                            <td style="text-align: center;">No Records</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <div id="tdDetails">
                <div id="divDetailsSection" visible="true" runat="server">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lblSaveConfirmMsg" runat="server" Style="font-weight: bold; font-size: small; color: red"></asp:Label>
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">From: <span id="Span19" class="mandatory">*</span></label>
                                        <asp:TextBox ID="txtFromDepot" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                        <asp:HiddenField ID="hdnFrmDepot" runat="server"></asp:HiddenField>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Region:</label>
                                        <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Depot:<span id="Span7" class="mandatory">*</span></label>
                                        <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="3"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Fin Year:<span id="Span11" class="mandatory" runat="server"></span></label>
                                        <asp:TextBox ID="txtFinYear" runat="server" CssClass="form-control" MaxLength="100" ReadOnly="True"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Document Type:<span id="Span3" class="mandatory">*</span></label>
                                        <asp:DropDownList ID="ddlDocType" CssClass="form-control select2" AutoPostBack="False" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Title:<span id="Span5" class="mandatory" runat="server">*</span></label>
                                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="80"></asp:TextBox>
                                        <asp:HiddenField ID="hdnDocGenId" runat="server"></asp:HiddenField>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Remark:</label>
                                        <asp:TextBox ID="txtRemark" CssClass="form-control" TabIndex="17" TextMode="MultiLine" MaxLength="1000" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Doc No.:<span class="mandatory">*</span></label>
                                        <asp:TextBox ID="txtDocNo" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Doc Date:<span class="mandatory">*</span></label>
                                        <asp:TextBox ID="txtdocdt" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                        <a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtdocdt,'Due_Date','dd/MM/yyyy');" style="top: 25px; right: 10px;">
                                            <img src="images/p-calendar.png" id="Due_Date" alt="Calender" style="border: 0" />
                                        </a>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Uploaded By:<span id="Span1" class="mandatory" runat="server">*</span></label>
                                        <asp:TextBox ID="txtUpdatedBy" runat="server" CssClass="form-control" MaxLength="100" ReadOnly="True"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">Uploaded Date:<span id="Span2" class="mandatory" runat="server">*</span></label>
                                        <asp:TextBox ID="txtUpdatedDt" runat="server" CssClass="form-control" MaxLength="100" ReadOnly="True"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-control-label">File to Upload:<span id="Span4" class="mandatory" runat="server"></span></label>
                                        <asp:FileUpload ID="sch_fld" runat="server" CssClass="form-control" />
                                        <asp:HiddenField ID="hdnFileName" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" ToolTip="Submit" runat="server" CssClass="btn btn-success btn-sm" Text="Submit" />
                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" Text="Delete" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-secondary btn-sm" Text="Cancel" />
                </div>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
            <div id="divErrorMessage"></div>
        </div>
    </div>
</asp:Content>
