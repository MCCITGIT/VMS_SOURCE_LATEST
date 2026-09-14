<%@ Page Title="Vendor Invoice Account Release Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="VendorReleaseReconciliation.aspx.vb" Inherits="VendorReleaseReconciliation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">var cal1 = new CalendarPopup();</script>
    <script src="Scripts/FunctionValidator.js" type="text/javascript"></script>
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Vendor Invoice Account Release Details</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">

        <contenttemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-control-label">Vendor:</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div id="divDepot" class="col-md-2" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Depot:</label>
                                <asp:DropDownList ID="ddldepot" runat="server" CssClass="form-control select2" TabIndex="2"></asp:DropDownList>
                            </div>
                        </div>
                        <div id="divStatus" class="col-md-2" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Status:</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2" TabIndex="2">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Paid" Value="Paid" />
                                    <asp:ListItem Text="Due" Value="Due" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div id="divType" class="col-md-2" runat="server">
                            <div class="form-group">
                                <label class="form-control-label">Type:</label>
                                <asp:DropDownList ID="ddltype" runat="server" CssClass="form-control select2" TabIndex="2">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Depot Despatch" Value="Depot Despatch" />
                                    <asp:ListItem Text="Direct Despatch" Value="Direct Despatch" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">From Date:</label>
                                <asp:TextBox ID="txtFromDate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                                <%--<a href="javascript:cal1.select(document.forms[0].txtFromDate,'FromDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="FromDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-control-label">To Date:</label>
                                <asp:TextBox ID="txtTodate" CssClass="form-control" runat="server" MaxLength="10"></asp:TextBox>
                                <%-- <a href="javascript:cal1.select(document.forms[0].txtTodate,'ToDt','dd/MM/yyyy');">
                                                                <img src="images/date_icon.gif" id="ToDt" runat="server" alt="Calender" style="border: 0" />
                                                            </a>--%>
                                <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTodate" Format="dd/MM/yyyy" />
                            </div>
                        </div>
                        <div class="col-md-3 form-btn-mt">
                            <div class="form-group">
                                <%--<asp:ImageButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" ImageUrl="images/ic_search.gif" ToolTip="Search" AlternateText="Search" />--%>
                                <asp:LinkButton CssClass="btn btn-primary btn-sm" ID="ImgbtnSearch" runat="server" OnClick="ImgbtnSearch_Click" ToolTip="Search" Text="Search"></asp:LinkButton>
                                <asp:LinkButton CssClass="btn btn-success btn-sm" ID="btndownload" runat="server" OnClick="btndownload_Click" Text="Download" ToolTip="Download" />
                                <asp:LinkButton CssClass="btn btn-secondary btn-sm" ID="btnBack" runat="server" OnClick="btnBack_Click" Text="Back" ToolTip="Back" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card rm-list-fill">
                <%--<div class="card">--%>
                <div class="mst-panel-header">
                    <div class="mst-panel-header-left">
                        <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                        <div>
                            <%--<h5 class="mst-panel-title">Vendor List</h5>--%>
                            <asp:Label ID="lblPanelTitle" runat="server" CssClass="mst-panel-title" Text="Vendor List"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive rm-grid-scroll">
                        <asp:GridView ID="gvVendorInvoiceDtls" runat="server" AutoGenerateColumns="false" PageSize="10" CssClass="table table-hover upgradDataGrid" EmptyDataText="No Record Found">
                            <rowstyle cssclass="tlrowlight" />
                            <pagerstyle cssclass="PagerGrid" horizontalalign="left" />
                            <headerstyle cssclass="headerGrid" />
                            <footerstyle cssclass="footerGrid" />
                            <columns>
                                <asp:BoundField DataField="org_id" Visible="false" />
                                <asp:BoundField HeaderText="Type" DataField="Type">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Release ID" DataField="desph_release_id">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Depot" DataField="depot_name">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice No" DataField="Invoice_No">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="10%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="10%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice Date" DataField="Invoice_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Invoice Value" DataField="Invoice_Value"
                                    DataFormatString="{0:N2}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Release No" DataField="Release_No">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Release Date" DataField="Release_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="GRN No" DataField="GRN_No">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="GRN Date" DataField="GRN_Date"
                                    DataFormatString="{0:dd-MMM-yyyy}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="7%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Voucher No" DataField="Voucher_No">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Amount Paid" DataField="Payment_Status"
                                    DataFormatString="{0:N2}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Amount Due" DataField="PendingAmount"
                                    DataFormatString="{0:N2}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="PO No" DataField="po_number">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Rtv Qty" DataField="rtv_qty"
                                    DataFormatString="{0:N2}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Rtv Reason" DataField="rtv_reason">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Deliver Qty" DataField="deliver_qty"
                                    DataFormatString="{0:N2}">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Grn Status" DataField="grn_status">
                                    <headerstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                    <itemstyle horizontalalign="Center" verticalalign="Middle" width="8%" />
                                </asp:BoundField>
                                <%-- Modified-by MUKESH BHAGAT on 11-09-2026 : Status column. Dispatch List: Admin / HO
                                     can mark a release "Cancelled by Vendor" and attach the credit note; Paid List:
                                     shows the status and the attached documents. Values filled in RowDataBound. --%>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hdnReleaseId" runat="server" Value='<%# Eval("desph_release_id") %>' />
                                        <asp:HiddenField ID="hdnInvNo" runat="server" Value='<%# Eval("Invoice_No") %>' />
                                        <asp:HiddenField ID="hdnInvDate" runat="server" Value='<%# Eval("Invoice_Date") %>' />
                                        <asp:HiddenField ID="hdnInvValue" runat="server" Value='<%# Eval("Invoice_Value") %>' />
                                        <asp:Label ID="lblRowStatus" runat="server" CssClass="d-block"></asp:Label>
                                        <asp:LinkButton ID="lnkMarkCancelled" runat="server" CommandName="MarkCancelled" Visible="false"
                                            CssClass="btn btn-outline-danger btn-sm mt-1" ToolTip="Mark this invoice as cancelled by the vendor and attach the credit note">Cancelled by Vendor</asp:LinkButton>
                                        <asp:LinkButton ID="lnkViewDocs" runat="server" CommandName="ViewCancelDocs" Visible="false"
                                            CssClass="btn btn-outline-primary btn-sm mt-1" ToolTip="View the attached credit note / supporting documents"><i class="fa fa-paperclip"></i>&nbsp;Documents</asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                </asp:TemplateField>
                            </Columns>

                            <%--<Columns>
                        <asp:TemplateField HeaderText="Sl No">
                            <ItemTemplate>
                                <%# (gvVendorInvoiceDtls.PageIndex * gvVendorInvoiceDtls.PageSize) + Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="5%" />
                            <ItemStyle HorizontalAlign="Center" Width="5%" />
                        </asp:TemplateField>
                        <asp:BoundField
                            HeaderText="Release No"
                            DataField="desph_release_id">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Depot"
                            DataField="desph_desp_depot">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Transporter Name"
                            DataField="desph_transporter_name">
                            <HeaderStyle HorizontalAlign="Left" Width="30%" />
                            <ItemStyle HorizontalAlign="Left" Width="30%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Invoice Value"
                            DataField="desph_invoice_value"
                            DataFormatString="{0:N2}">
                            <HeaderStyle HorizontalAlign="Right" Width="15%" />
                            <ItemStyle HorizontalAlign="Right" Width="15%" />
                        </asp:BoundField>
                        <asp:BoundField
                            HeaderText="Dispatch Date"
                            DataField="created_date"
                            DataFormatString="{0:dd-MM-yyyy}">
                            <HeaderStyle HorizontalAlign="Center" Width="15%" />
                            <ItemStyle HorizontalAlign="Center" Width="15%" />
                        </asp:BoundField>
                    </Columns>--%>
                        </asp:GridView>
                    </div>
                    <%--<div class="custom-pagination">

                        <div class="page-selector">

                            <span class="page-label">Page</span>

                            <asp:DropDownList
                                ID="ddlPageNumber"
                                runat="server"
                                CssClass="selectpicker page-dropdown p-page-selector"
                                data-live-search="true"
                                data-size="5"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlPageNumber_SelectedIndexChanged">
                            </asp:DropDownList>

                            <span class="page-label">of
                        <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                            </span>

                        </div>

                    </div>--%>
                    <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                    <div id="divErrorMessage"></div>
                </div>

                <%-- Modified-by MUKESH BHAGAT on 11-09-2026 : "Cancelled by Vendor" popups.
                     pnlCancelByVendor - remarks + credit-note PDF, saved through a full postback
                     (btnSaveCancel is a PostBackTrigger: a FileUpload cannot post through an async
                     update). pnlCancelDocs - the documents already attached, download, add another,
                     undo. Same ModalPopupExtender / bootstrapModal pattern as IndentsList.aspx. --%>
                <asp:HiddenField ID="hdnCancelTarget" runat="server" />
                <asp:HiddenField ID="hdnDocsTarget" runat="server" />

                <asp:ModalPopupExtender ID="mpCancel" runat="server" PopupControlID="pnlCancelByVendor"
                    TargetControlID="hdnCancelTarget" CancelControlID="btnCancelCancel" BackgroundCssClass="popupBackground">
                </asp:ModalPopupExtender>
                <asp:Panel ID="pnlCancelByVendor" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Cancelled by Vendor</h5>
                            </div>
                            <div class="modal-body">
                                <p class="mb-2">
                                    Release ID: <asp:Label ID="lblCancelReleaseId" runat="server" Font-Bold="true"></asp:Label>
                                    &nbsp;|&nbsp; Invoice No: <asp:Label ID="lblCancelInvoiceNo" runat="server" Font-Bold="true"></asp:Label>
                                </p>
                                <div class="form-group">
                                    <label class="form-control-label">Credit Note / Supporting Document (PDF):<span class="mandatory">*</span></label>
                                    <asp:FileUpload ID="fuCancelDoc" runat="server" CssClass="form-control-file" accept=".pdf" />
                                </div>
                                <div class="form-group">
                                    <label class="form-control-label">Remarks:</label>
                                    <asp:TextBox ID="txtCancelRemarks" runat="server" CssClass="form-control h-auto" TextMode="MultiLine" Rows="3" MaxLength="500" placeholder="Reason given by the vendor, credit note no., etc."></asp:TextBox>
                                </div>
                                <small class="text-muted">The release will move from the Dispatch List to the Paid List with status "Cancelled by Vendor". More documents can be attached later from the Paid List.</small>
                            </div>
                            <div class="modal-footer">
                                <asp:Label ID="lblCancelError" runat="server" Text="" ForeColor="Red"></asp:Label>
                                <asp:Button ID="btnSaveCancel" CssClass="btn btn-danger" runat="server" Text="Mark Cancelled &amp; Save" OnClick="btnSaveCancel_Click"
                                    OnClientClick="return confirm('Mark this invoice as Cancelled by Vendor? It will move to the Paid List.');" />
                                <asp:Button ID="btnCancelCancel" CssClass="btn btn-secondary" runat="server" Text="Close" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <asp:ModalPopupExtender ID="mpDocs" runat="server" PopupControlID="pnlCancelDocs"
                    TargetControlID="hdnDocsTarget" CancelControlID="btnCloseDocs" BackgroundCssClass="popupBackground">
                </asp:ModalPopupExtender>
                <asp:Panel ID="pnlCancelDocs" runat="server" CssClass="modalPanel1 bootstrapModal" Style="display: none;">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Cancelled by Vendor - Documents</h5>
                            </div>
                            <div class="modal-body">
                                <p class="mb-2">
                                    Release ID: <asp:Label ID="lblDocsReleaseId" runat="server" Font-Bold="true"></asp:Label>
                                    &nbsp;|&nbsp; Invoice No: <asp:Label ID="lblDocsInvoiceNo" runat="server" Font-Bold="true"></asp:Label>
                                </p>
                                <div class="table-responsive">
                                    <asp:GridView ID="gvCancelDocs" runat="server" AutoGenerateColumns="false" CssClass="table table-hover upgradDataGrid" EmptyDataText="No document attached.">
                                        <RowStyle CssClass="tlrowlight" />
                                        <HeaderStyle CssClass="headerGrid" />
                                        <Columns>
                                            <asp:BoundField HeaderText="#" DataField="vcd_doc_srl_no">
                                                <HeaderStyle HorizontalAlign="Center" Width="5%" /><ItemStyle HorizontalAlign="Center" Width="5%" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Document" DataField="vcd_doc_org_filename">
                                                <HeaderStyle HorizontalAlign="Left" Width="35%" /><ItemStyle HorizontalAlign="Left" Width="35%" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Remarks" DataField="vcd_remarks">
                                                <HeaderStyle HorizontalAlign="Left" Width="30%" /><ItemStyle HorizontalAlign="Left" Width="30%" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Uploaded By" DataField="created_user">
                                                <HeaderStyle HorizontalAlign="Center" Width="10%" /><ItemStyle HorizontalAlign="Center" Width="10%" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Uploaded On" DataField="created_date" DataFormatString="{0:dd-MMM-yyyy HH:mm}">
                                                <HeaderStyle HorizontalAlign="Center" Width="12%" /><ItemStyle HorizontalAlign="Center" Width="12%" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Download">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkDownloadCancelDoc" runat="server" CommandName="DownloadCancelDoc" CommandArgument='<%# Eval("vcd_id") %>'
                                                        CssClass="btn btn-outline-success btn-sm" ToolTip="Download"><i class="fa fa-download"></i></asp:LinkButton>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="8%" /><ItemStyle HorizontalAlign="Center" Width="8%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Label ID="lblDocsError" runat="server" Text="" ForeColor="Red"></asp:Label>
                                <asp:Button ID="btnAddCancelDoc" CssClass="btn btn-primary" runat="server" Text="Add Document" OnClick="btnAddCancelDoc_Click" />
                                <asp:Button ID="btnUndoCancel" CssClass="btn btn-warning" runat="server" Text="Undo Cancellation" OnClick="btnUndoCancel_Click"
                                    OnClientClick="return confirm('Undo the cancellation? The release will return to the Dispatch List. The documents stay on file but are hidden.');" />
                                <asp:Button ID="btnCloseDocs" CssClass="btn btn-secondary" runat="server" Text="Close" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>
        </ContentTemplate>


        <triggers>

            <asp:AsyncPostBackTrigger
                ControlID="ddlUnit"
                EventName="SelectedIndexChanged" />


            <asp:AsyncPostBackTrigger
                ControlID="ImgbtnSearch"
                EventName="Click" />

            <%-- Modified-by MUKESH BHAGAT on 11-09-2026 : file upload and file download need a FULL postback --%>
            <asp:PostBackTrigger ControlID="btnSaveCancel" />
            <asp:PostBackTrigger ControlID="gvCancelDocs" />


            <%--<asp:AsyncPostBackTrigger
                ControlID="ddlPageNumber"
                EventName="SelectedIndexChanged" />--%>
        </triggers>


    </asp:UpdatePanel>
    <%--</div>--%>
          <%--  </div>--%>
            <script type="text/javascript">

                function initializePageDropdown() {

                   /* $('.selectpicker').selectpicker();*/

                }


                $(document).ready(function () {

                    initializePageDropdown();

                });


                // Required for ASP.NET WebForms postback / UpdatePanel
                if (typeof Sys !== "undefined") {

                    Sys.WebForms.PageRequestManager.getInstance()
                        .add_endRequest(function () {

                            initializePageDropdown();

                        });

                }

            </script>
</asp:Content>
