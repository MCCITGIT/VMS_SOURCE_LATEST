<%@ Page Title="Add/Update Despatch Challan" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="UnitDespatchPlanAddUpdateVr1.aspx.vb" Inherits="UnitDespatchPlanAddUpdateVr1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="Scripts/Validation.js" type="text/javascript"></script>
    <script src="Scripts/ValidateEstimationUpload.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            // Modified-by MUKESH BHAGAT on 07-09-2026 : ClientID resolution - bare ids return
            // null under the MasterPage prefix, so F7/F8 threw instead of clicking.
            if (event.keyCode == 118) {  // button Add (F7 keypress)
                var b = document.getElementById('<%= btnSubmit.ClientID %>');
                if (b) { b.click(); }
            }
            else if (event.keyCode == 119) { // button Search (F8 keypress)
                var c = document.getElementById('<%= btnCancel.ClientID %>');
                if (c) { c.click(); }
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
        //-->
    </script>

    <script type="text/javascript">
        function HideLoading() {
            var loading_icon = document.getElementById("loading");
            loading_icon.style.visibility = 'hidden';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function ShowLoading() {

            var loading_icon = document.getElementById("loading");
            loading_icon.style.visibility = 'visible';
            //loading_icon.style.visibility = (loading_icon.style.visibility == 'visible') ? 'hidden' : 'visible';
        }

        function aceSelected(sender, e) {
            var value = e.get_value();
            //var text = e._item.innerText;
            var text = e.get_text();

            document.getElementById('<%=hdnTranspoterId.ClientID%>').value = value;
            document.getElementById('<%=txtTransporter.ClientID%>').value = text;

            //sender.get_element().value = text;
            //document.getElementById("btnShowdealerDetails").click();
        }
    </script>

    <script type="text/javascript">
        function regex(e) {
            // var regex = new RegExp("^[a-zA-Z0-9_]*$");
            var regex = new RegExp("^\\s+$");

            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                e.preventDefault();
                // alert('Please Enter Alphabet');
                return false;
            }
            else {
                return true;
            }
        }
    </script>

    <script type="text/javascript">
        // Modified-by MUKESH BHAGAT on 07-09-2026 : these lookups used bare ids, which return
        // null under the MasterPage's ctl00_ContentPlaceHolder1_ prefixing - both handlers threw
        // on every load. Resolved through ClientID, with a null guard.
        document.addEventListener("DOMContentLoaded", function () {
            var maxDate = new Date().toISOString().split('T')[0];
            var cenvatDt = document.getElementById('<%= txtCenvatDt.ClientID %>');
            if (cenvatDt) { cenvatDt.setAttribute('max', maxDate); }
            var challanDt = document.getElementById('<%= txtChallanDt.ClientID %>');
            if (challanDt) { challanDt.setAttribute('max', maxDate); }
        });
    </script>
    <script src="Scripts/ValidateUnitDespatchAddUpdate.js?time=<%=  DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>" type="text/javascript"></script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Add/Update Despatch Challan</h3>
                <p class="pageSubTitle">Create and update despatch challans</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:Label ID="lblChallanNo" runat="server" CssClass="text-right mb-2 d-flex justify-content-end font-weight-bold"></asp:Label>
    <asp:HiddenField ID="hdnChallanno" runat="server" />
    <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : invoice number as loaded in edit mode, so the
         duplicate-invoice check can skip the challan's own number when it is unchanged. --%>
    <asp:HiddenField ID="hdnOriginalInvoiceNo" runat="server" />
    <asp:HiddenField ID="hdnNoMaster" runat="server" />
    <asp:HiddenField ID="hdnMaxDespLimit" runat="server" />
    <asp:HiddenField ID="hdnLotNo" runat="server" />
    <asp:HiddenField ID="hdnUnitOracleId" runat="server" />
    <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source --%>
    <asp:HiddenField ID="hdnindentyn" runat="server" />
    <asp:HiddenField ID="hdnUnitCode" runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Challan Date:<span class="mandatory">*</span></label>
                                <asp:TextBox ID="txtChallanDt" CssClass="form-control" MaxLength="10" TabIndex="1" runat="server"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtChallanDt" Format="dd/MM/yyyy" />
                                <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtChallanDt,'ChallanDt','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="ChallanDt" runat="server" alt="Calender" style="border: 0" />
                                </a>--%>
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
                                <label class="form-control-label">Depot:<span class="mandatory">*</span></label>
                                <asp:ListBox ID="chkbxListLocation" runat="server" CssClass="form-control" SelectionMode="Multiple" placeholder="Select" TabIndex="26" AutoPostBack="true" OnSelectedIndexChanged="chkbxListLocation_SelectedIndexChanged"></asp:ListBox>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Source:</label>
                                <asp:Label ID="lblUnit" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product:<span class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlProduct" runat="server" AutoPostBack="True" CssClass="form-control select2" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged" TabIndex="4">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">All SKU:<span class="mandatory">*</span></label>
                                <asp:DropDownList ID="ddlAllSku" runat="server" AutoPostBack="True" CssClass="form-control select2" TabIndex="5">
                                    <asp:ListItem Text="Yes" Value="Y" />
                                    <asp:ListItem Text="No" Value="N" Selected="True" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Year:</label>
                                <asp:Label ID="lblYear" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Process Month:</label>
                                <asp:Label ID="lblmonth" runat="server" CssClass="labelDataPoint"></asp:Label>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Invoicing Depot:<span class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlDeliveryDepot" runat="server" AutoPostBack="True" CssClass="form-control select2"
                                            TabIndex="3">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source --%>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Indent:<span class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel_Indent" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlIndent" runat="server" CssClass="form-control select2" AutoPostBack="true" Enabled="false">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Site Name:<span class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlSite" runat="server" AutoPostBack="true" CssClass="form-control select2">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">PO No.:<span class="mandatory">*</span></label>
                                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlPONo" runat="server" AutoPostBack="true" CssClass="form-control select2">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Berger Approved Transporter Y/N:</label>
                        <asp:UpdatePanel ID="UpdatePanel9" runat="server" class="mt-2">
                            <ContentTemplate>
                                <asp:CheckBox ID="chkApprovedTranspoterYN" CssClass="checkRadioGroup" runat="server" OnCheckedChanged="chkApprovedTranspoterYN_CheckedChanged" AutoPostBack="true" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                        <ContentTemplate>
                            <div class="form-group">
                                <label class="form-control-label">Transpoter Name/Id:<span class="mandatory" style="font-size: 9px;">* (Atleast 3 characters)</span></label>
                                <div class="flexInputDiv">
                                    <asp:TextBox ID="txtTranspoterName" runat="server" CssClass="form-control" placeholder="Search By Traspoter Name/Id"></asp:TextBox>
                                    <asp:LinkButton ID="btnResetdealerDetails" runat="server" Text="Reset" CssClass="refreshIcon">
                                       <i class="fas fa-sync"></i>
                                    </asp:LinkButton>
                                </div>
                                <asp:HiddenField ID="hdnTranspoterId" runat="server" />

                                <asp:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="txtTranspoterName"
                                    ServiceMethod="TranspoterSearch" MinimumPrefixLength="3" EnableCaching="false"
                                    CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem"
                                    CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight" OnClientItemSelected="aceSelected"
                                    OnClientPopulated="HideLoading" BehaviorID="AutoCompleteEx" CompletionListElementID="Panel1"
                                    OnClientPopulating="ShowLoading" FirstRowSelected="true" OnClientHidden="HideLoading"
                                    OnClientHiding="HideLoading">
                                    <Animations>
                                                    <OnShow>
                                                        <Sequence>
                                                            <OpacityAction Opacity="0" />
                                                            <HideAction Visible="true" />
                                                            <ScriptAction Script="
                                                                // Cache the size and setup the initial size
                                                                var behavior = $find('AutoCompleteEx');
                                                                if (!behavior._height) {
                                                                    var target = behavior.get_completionList();
                                                                    behavior._height = target.offsetHeight - 2;
                                                                    target.style.height = '0px';
                                                                }" />
                                
                                                            <Parallel Duration=".4">
                                                                <FadeIn />
                                                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                                                            </Parallel>
                                                        </Sequence>
                                                    </OnShow>
                                                    <OnHide>
                            
                                                        <Parallel Duration=".4">
                                                            <FadeOut />
                                                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                                                        </Parallel>
                                                    </OnHide>
                                    </Animations>
                                </asp:AutoCompleteExtender>

                                <img alt="Loading..." src="images/ajax-loader.gif" id="loading" class="inputLoading" />
                                <asp:Panel ID="Panel1" runat="server" ScrollBars="Vertical" Style="overflow-y: scroll; position: absolute; left: 0; top: 0">
                                </asp:Panel>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Transporter:<span class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtTransporter" CssClass="form-control" TabIndex="6" runat="server" MaxLength="500"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Truck No:<span class="mandatory">*</span></label>
                        <%-- Modified-by MUKESH BHAGAT on 07-09-2026 : must sit inside an UpdatePanel -
                             the Indent selection posts back asynchronously and auto-fills this field
                             (PopulateIndentDetails), but a control outside a panel is never
                             re-rendered, so the vehicle number was set server-side yet never showed.
                             MaxLength raised 10 -> 20: Pando vehicle numbers like "WB 61 B 7116"
                             are longer than 10 and would be un-typeable manually. --%>
                        <asp:UpdatePanel ID="UpdatePanelTruckNo" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtTruckNo" CssClass="form-control" TabIndex="7" runat="server" MaxLength="20"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Invoice No:<span class="mandatory">*</span></label>
                        <asp:TextBox ID="txtCenvatNo" CssClass="form-control" TabIndex="8" runat="server" MaxLength="24" onkeypress="return regex(event);" AutoComplete="off" onpaste="return false"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Invoice Date:<span class="mandatory">*</span></label>
                        <asp:TextBox ID="txtCenvatDt" CssClass="form-control" MaxLength="10" TabIndex="9" runat="server" onfocus="setMaxDate()"></asp:TextBox>
                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtCenvatDt" Format="dd/MM/yyyy" />
                        <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtCenvatDt,'cenvatDt','dd/MM/yyyy');">
                            <img src="images/date_icon.gif" id="cenvatDt" alt="Calendar" style="border: 0" />
                        </a>--%>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Road Permit No:<span class="mandatory">*</span></label>
                        <asp:TextBox ID="txtRoadPermitNo" CssClass="form-control" TabIndex="7" runat="server" MaxLength="30"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">E-Way Bill No:</label>
                        <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtEwayBillNo" CssClass="form-control" TabIndex="7" runat="server" MaxLength="30"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">E-Way Bill Date:</label>
                        <asp:UpdatePanel ID="UpdatePanel14" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtEwayBillDate" CssClass="form-control" MaxLength="10" TabIndex="9" runat="server"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtEwayBillDate" Format="dd/MM/yyyy" />
                                <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtEwayBillDate,'ewayDt','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="ewayDt" alt="Calender" style="border: 0" />
                                </a>--%>
                                <%--<asp:TextBox ID="txtEwayBillDate" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>--%>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Valid Upto:</label>
                        <asp:UpdatePanel ID="UpdatePanel15" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtValidUpto" CssClass="form-control" MaxLength="10" TabIndex="9" runat="server"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtValidUpto" Format="dd/MM/yyyy" />
                                <%--<a class="formCalndIcon" href="javascript:cal1.select(document.forms[0].txtValidUpto,'validUptoDt','dd/MM/yyyy');">
                                    <img src="images/date_icon.gif" id="validUptoDt" alt="Calender" style="border: 0" />
                                </a>--%>
                                <%--<asp:TextBox ID="txtValidUpto" runat="server" class="form-control" MaxLength="10" TextMode="Date"></asp:TextBox>--%>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Final Invoice Value (After Tax):<span id="Span1" class="mandatory" runat="server">*</span></label>
                        <asp:TextBox ID="txtFinalInvoiceValue" CssClass="form-control" MaxLength="10" step="0.01" TextMode="Number" TabIndex="10" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group" style="display: flex; align-items: flex-start; gap: 30px;">
                        <div style="width: 48%">
                            <label class="form-control-label">Upload Actual Invoice Copy:<span class="mandatory">*</span><span id="Span4" class="mandatory" runat="server"></span></label>
                            <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                                <ContentTemplate>
                                    <asp:FileUpload ID="sch_fld1" runat="server" CssClass="form-control" />
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnSubmit" />
                                </Triggers>
                            </asp:UpdatePanel>
                            <asp:HiddenField ID="hdnFileName" runat="server" />
                            <%-- Modified-by MUKESH BHAGAT on 24-08-2026 : invoice OCR extract + validation
                             (same OCR service as Dispatch_Details.aspx -> InvoiceOcrExtract.ashx)
                             Modified-by MUKESH BHAGAT on 27-08-2026 : the visible "Extract & Validate"
                             button is gone - the OCR check now runs silently when Submit is clicked,
                             and this message area / the panel below appear only when the bill fails. --%>
                            <div id="divInvoiceOcrMessage" style="margin-top: 5px; font-size: 12px;"></div>
                            <asp:HiddenField ID="hdnOcrVerified" runat="server" Value="N" />
                            <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : stored invoice copy - shows the
                             uploaded file's name and a download button when a document exists. --%>
                            <asp:HiddenField ID="hdnInvDocPath" runat="server" />
                            <asp:HiddenField ID="hdnInvDocFile" runat="server" />
                        </div>
                        <div>
                            <asp:Label ID="lblInvDocName" runat="server" Visible="false"
                                Style="display: block; font-size: 11px; color: #6c757d; margin-top: 4px; white-space: nowrap; overflow: hidden"></asp:Label>
                            <asp:LinkButton ID="lnkDownloadInvoice" runat="server" Visible="false"
                                CssClass="btn btn-primary btn-sm" CausesValidation="false"
                                OnClick="lnkDownloadInvoice_Click"
                                ToolTip="Download the uploaded invoice copy"
                                Style="margin-top: 4px;">
                            <i class="fa fa-download"></i>&nbsp;Download Invoice
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
                <%-- Modified-by MUKESH BHAGAT on 24-08-2026 : optional E-Way bill document.
                     Saved next to the invoice copy under Challan_Docs\<dd_MM_yyyy>.
                     Modified-by MUKESH BHAGAT on 27-08-2026 : moved out of the "E-Way Bill No"
                     column into its own column beside the invoice upload, so the two upload
                     fields line up and the top row keeps a uniform height. --%>
                <div class="col-md-6">
                    <div class="form-group">

                        <asp:UpdatePanel ID="UpdatePanelEway" runat="server" style="display: flex; align-items: center; gap: 30px;">
                            <ContentTemplate>
                                <div style="width: 48%">
                                    <label class="form-control-label">Upload E-Way Bill:</label>
                                    <asp:FileUpload ID="sch_fld_eway" runat="server" CssClass="form-control" />
                                    <%-- Modified-by MUKESH BHAGAT on 26-08-2026 : download link for the
                                     stored E-Way bill. Hidden until a document actually exists. --%>
                                    <asp:HiddenField ID="hdnEwayDocPath" runat="server" />
                                    <asp:HiddenField ID="hdnEwayDocFile" runat="server" />
                                </div>
                                <%-- Modified-by MUKESH BHAGAT on 31-08-2026 : show the stored file's
                                     name above the download button. --%>
                                <div>
                                    <asp:Label ID="lblEwayDocName" runat="server" Visible="false"
                                        Style="display: block; font-size: 11px; color: #6c757d; margin-top: 4px;white-space: nowrap;"></asp:Label>
                                    <asp:LinkButton ID="lnkDownloadEway" runat="server" Visible="false"
                                        CssClass="btn btn-primary btn-sm" CausesValidation="false"
                                        OnClick="lnkDownloadEway_Click"
                                        ToolTip="Download the uploaded E-Way bill"
                                        Style="margin-top: 4px;">
                                    <i class="fa fa-download"></i>&nbsp;Download E-Way Bill
                                    </asp:LinkButton>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btnSubmit" />
                                <asp:PostBackTrigger ControlID="lnkDownloadEway" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>

            <%-- Modified-by MUKESH BHAGAT on 24-08-2026 : GSTN of the invoicing depot (from the depot
                 master) and of the supplier (from the selected site). Read-only - they are reference
                 values the uploaded bill is checked against. --%>
            <%-- Modified-by MUKESH BHAGAT on 27-08-2026 : both boxes must sit inside an UpdatePanel.
                 ddlDeliveryDepot and ddlSite post back asynchronously, so anything outside an
                 UpdatePanel is never re-rendered - the server was setting these values correctly but
                 the browser never received them, which is why the Depot GSTN stayed blank. --%>
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Invoicing Depot GSTN:<span class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanelDepotGstn" runat="server" UpdateMode="Always">
                            <ContentTemplate>
                                <asp:TextBox ID="txtDepotGstn" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlDeliveryDepot" EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlSite" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Supplier GSTN:<span class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanelSupplierGstn" runat="server" UpdateMode="Always">
                            <ContentTemplate>
                                <asp:TextBox ID="txtSupplierGstn" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlDeliveryDepot" EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlSite" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>

            <%-- Modified-by MUKESH BHAGAT on 08-09-2026 : full-page blocking loader shown while the
                 uploaded bill is being validated by OCR (same look as the master page UpdateProgress),
                 so the user can neither edit fields nor miss that something is in progress. --%>
            <div id="divOcrLoader" class="pageLoader" style="display: none;">
                <div class="innerLoader">
                    <img class="loaderImg" alt="progress" src="images/ajax-loader.gif" />
                    <p class="loaderTx">Validating the uploaded invoice, please wait...</p>
                </div>
            </div>

            <%-- Modified-by MUKESH BHAGAT on 24-08-2026 : values read from the uploaded bill by OCR.
                 Read-only - shown for verification against what the user entered above. --%>
            <div class="row" id="divInvoiceOcrPanel" style="display: none;">
                <div class="col-md-12">
                    <div class="card" style="border-left: 3px solid #1F4E79;">
                        <div class="card-body" style="padding: 10px 15px;">
                            <label class="form-control-label" style="font-weight: 600;">Values read from the uploaded bill (OCR)</label>
                            <div class="row">
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Invoice No:</label>
                                        <input type="text" id="txtOcrInvoiceNo" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Invoice Date:</label>
                                        <input type="text" id="txtOcrInvoiceDate" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Gross Value:<span class="mandatory">*</span></label>
                                        <input type="text" id="txtOcrGrossValue" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Total Quantity:</label>
                                        <input type="text" id="txtOcrTotalQty" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Supplier GSTN:</label>
                                        <input type="text" id="txtOcrSupplierGstn" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label class="form-control-label">Recipient GSTN:</label>
                                        <input type="text" id="txtOcrRecipientGstn" class="form-control" readonly="readonly" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="form-group row ddlPageSize">
                        <label for="ddlPageSize" class="col-auto form-control-label">
                            <asp:Label ID="Label4" runat="server" Text="Results Per Page:"></asp:Label>
                        </label>
                        <div class="col-md-1">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control select2" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvSKUDetails" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            Visible="true" BorderWidth="1" CssClass="table table-hover upgradDataGrid" ShowFooter="true"
                            EmptyDataText="No SKU Found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="S.No" ItemStyle-HorizontalAlign="Left">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                        <asp:HiddenField ID="hdnUom" runat="server" Value='<%# Bind("skuUom") %>' />
                                        <asp:HiddenField ID="hdnVol" runat="server" Value='<%# Bind("skuVol") %>' />
                                        <asp:HiddenField ID="hdnTransitDay" runat="server" Value='<%# Bind("transitDays") %>' />
                                        <asp:HiddenField ID="hdnSKUCode" runat="server" Value='<%# Bind("load_sku_code") %>' />
                                        <asp:HiddenField ID="hdnLineNum" runat="server" Value='<%# Bind("line_num") %>' />
                                        <asp:HiddenField ID="hdnSkuDesc" runat="server" Value='<%# Bind("skuDesc") %>' />
                                        <asp:HiddenField ID="hdnSkuRate" runat="server" Value='<%# Bind("SkuRate") %>' />
                                        <asp:HiddenField ID="hdnSkuGST" runat="server" Value='<%# Bind("SkuGST") %>' />
                                        <asp:HiddenField ID="hdnDepotCode" runat="server" Value='<%# Bind("load_depot") %>' />
                                        <asp:HiddenField ID="hdnCurrSkuStatus" runat="server" Value='<%# Bind("CurrSkuStatus") %>' />

                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:TemplateField>

                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot" DataField="DepotName">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="8%" />
                                </asp:BoundField>

                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="SKU Code" DataField="load_sku_code">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Description" DataField="skuDesc">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="20%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Rate (per unit)" DataField="skuRate">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Auto Indent" DataField="calculatedAuto">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Depot Indent" DataField="load_depot_indent_nop_pending">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                    HeaderText="Despatch Till Date" DataField="calculatedDespatch" ControlStyle-Width="10%">
                                    <ControlStyle Width="10%"></ControlStyle>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:BoundField>
                                <%--<asp:BoundField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Pending Load" DataField="pendingLoad">
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="This Despatch" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPendingLoad" runat="server" Text='<%# Bind("pendingLoad") %>'></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblftrThisDesp1" runat="server" Text='Total'></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="This Despatch" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtThisDesp" CssClass="txtBox" runat="server" Text='<%# Bind("pendingLoad") %>' TextMode="Number"
                                            Width="45px" MaxLength="30" Enabled="False"></asp:TextBox>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblftrThisDesp" runat="server" Text=''></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="6%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total Rate (Inc. GST)" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTotalRate" runat="server" Text=''></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblftrTotalRate" runat="server" Text=''></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                                </asp:TemplateField>

                                <%-- <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                        <asp:Button ID="btnGo" CommandName="ShowQuantity" runat="server" CssClass="but2" Text="Go" />
                                                                </ItemTemplate>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                                <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10%" />
                                                            </asp:TemplateField>--%>

                                <asp:TemplateField HeaderText="LOT" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtLOT" CssClass="txtBox" runat="server" Text='<%# Bind("despd_lot_no") %>'
                                            Width="170px" Enabled="False"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                    <FooterStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="18%" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnDelete" CssClass="btn btn-danger btn-sm" runat="server" Text="Delete" />
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-success btn-sm" Text="Submit" />
                            <asp:Button ID="btnCancel" CssClass="btn btn-secondary btn-sm" runat="server" Text="Cancel" PostBackUrl="~/UnitDespatchPlanListVr1.aspx" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                            <div id="divErrorMessage"></div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlAllSku"
                EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="chkbxListLocation"
                EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlProduct"
                EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlRegion"
                EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlDeliveryDepot"
                EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="UpdatePanel8" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hdnTargetID_Quantity" runat="server" />
            <asp:HiddenField ID="hdnTargetID1" runat="server" />
            <%-- <asp:ModalPopupExtender ID="ModalPopupExtender1" runat="server" OkControlID="btnCance"
    PopupControlID="pnlQuantity" TargetControlID="hdnTargetID1" CancelControlID="btnCance"
    BackgroundCssClass="popupBackground">
</asp:ModalPopupExtender>--%>
            <asp:ModalPopupExtender ID="ModalPopupExtender2" runat="server" OkControlID="btnCance" PopupControlID="pnlQuantity" TargetControlID="hdnTargetID_Quantity" CancelControlID="btnCance" BackgroundCssClass="popupBackground">
            </asp:ModalPopupExtender>
            <%-- <asp:ModalPopupExtender ID="ModalPopupExtender2" runat="server" PopupControlID="pnlQuantity"
    TargetControlID="hdnTargetID_Quantity" BackgroundCssClass="popupBackground">
</asp:ModalPopupExtender>--%>
            <asp:ModalPopupExtender ID="ModalPopupExtender3" runat="server" OkControlID="btnOk" PopupControlID="PnlOk" TargetControlID="hdnTargetID1" CancelControlID="btnOk" BackgroundCssClass="popupBackground">
            </asp:ModalPopupExtender>

        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="divDespatchQuantity" runat="server">
        <asp:Panel ID="pnlQuantity" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
            <div class="modal-dialog">
                <div class="modal-content">
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                        <ContentTemplate>
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <asp:Label ID="lblSpPopupHdr" runat="server" Font-Bold="True"></asp:Label></h5>
                                <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>--%>
                            </div>
                            <div class="modal-body">
                                <table style="width: 99%; border: 1px solid #66CCFF">
                                    <tr>
                                        <td style="background-color: #E6F5FB; width: 30%; text-align: right; font-weight: bold; border-bottom: 1px solid #66CCFF;">SKU
                                        </td>
                                        <td align="left" style="border-bottom: 1px solid #66CCFF;">
                                            <asp:Label ID="lblSKU" runat="server"></asp:Label>
                                            <asp:HiddenField ID="hdnDespChallanNo" runat="server" />
                                            <asp:HiddenField ID="hdnFinYear" runat="server" />
                                            <asp:HiddenField ID="hdnDespatchUnit" runat="server" />
                                            <asp:HiddenField ID="hdnDepotCode" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background-color: #E6F5FB; width: 30%; text-align: right; font-weight: bold; border-bottom: 1px solid #66CCFF;">SKU Description
                                        </td>
                                        <td align="left" style="border-bottom: 1px solid #66CCFF;">
                                            <asp:Label ID="lblSKUDescription" runat="server"></asp:Label>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="background-color: #E6F5FB; width: 30%; text-align: right; font-weight: bold;">Total Quantity
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="lblTotalDespatchQuantity" runat="server"></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                                <table style="width: 100%; border: 1px solid #66CCFF">
                                    <tr>
                                        <th colspan="3" style="width: 5%; border-bottom: 1px solid #66CCFF; border-right: 1px solid #66CCFF; background-color: #E6F5FB;">Details
                                        </th>
                                        <th style="width: 20%; border-bottom: 1px solid #66CCFF; background-color: #E6F5FB;">Quantity
                                        </th>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%">IND
                                        </td>
                                        <td style="width: 20%">
                                            <asp:Label ID="lblPONo1" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td style="width: 30%">
                                            <asp:TextBox ID="txtDate1" runat="server" MaxLength="10" Width="130px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtQuantity1" runat="server" MaxLength="10" Width="64px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr class="tlrowdark">
                                        <td>IND
                                        </td>
                                        <td>
                                            <asp:Label ID="lblPONo2" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Width="130px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtQuantity2" runat="server" MaxLength="10" Width="64px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>IND
                                        </td>
                                        <td>
                                            <asp:Label ID="lblPONo3" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDate3" runat="server" MaxLength="10" Width="130px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtQuantity3" runat="server" MaxLength="10" Width="64px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr class="tlrowdark">
                                        <td>IND
                                        </td>
                                        <td>
                                            <asp:Label ID="lblPONo4" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDate4" runat="server" MaxLength="10" Width="130px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtQuantity4" runat="server" MaxLength="10" Width="64px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>IND
                                        </td>
                                        <td>
                                            <asp:Label ID="lblPONo5" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDate5" runat="server" MaxLength="10" Width="130px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtQuantity5" runat="server" MaxLength="10" Width="64px" Style="background-color: inherit;"></asp:TextBox>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="btnAddSP" runat="server" Text="Add" CssClass="btn btn-primary" />
                                <asp:Button ID="btnCance" runat="server" Text="Cancel" CssClass="btn btn-secondary" />
                            </div>


                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
    </div>

    <asp:Panel ID="PnlOk" runat="server" CssClass="modalPanel bootstrapModal" Style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                    <ContentTemplate>
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <asp:Label ID="Label1" runat="server" ForeColor="White" Font-Bold="true" Text="Message"></asp:Label>
                            </h5>
                        </div>
                        <div class="modal-body">
                            <asp:Label ID="lblPopMessage" runat="server" ForeColor="#7f0037" Font-Bold="true" Text=""></asp:Label>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnOk" runat="server" Text="Ok" CssClass="btn btn-primary" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript" src="Scripts/jquery.sumoselect.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.select2').select2();
            $(<%=chkbxListLocation.ClientID%>).SumoSelect({
                selectAll: true,
                search: true,
                csvDispCount: 2,
                searchText: 'Search...',
            });

        });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $('.select2').select2();
            $(<%=chkbxListLocation.ClientID%>).SumoSelect({
                selectAll: true,
                search: true,
                csvDispCount: 2,
                searchText: 'Search...',
            });

        });

    </script>

    <%-- ================================================================================
         Modified-by MUKESH BHAGAT on 24-08-2026 : Invoice OCR extract + validation.
         Re-uses the existing OCR service already used by Dispatch_Details.aspx
         (InvoiceOcrExtract.ashx -> COLORANT_OCR api/extract-invoice). The handler writes
         the RAW api json back to the browser, so any field the api returns is readable here.
         Validation rules:
           Gross value ....... mandatory - must match Final Invoice Value (After Tax)
           Invoice no / date . mandatory - must match exactly, else the bill is rejected
           Total quantity .... optional  - shown, mismatch only warns
           Supplier/Recipient GSTN . optional - shown, mismatch only warns
         NOTE: control ids are emitted through ClientID because this page runs under
         MasterPage.master (bare getElementById would not resolve).
         ================================================================================ --%>
    <script type="text/javascript">

        // Flip to false if UAT shows the OCR service does not reliably return a gross value.
        var OCR_REQUIRE_GROSS_VALUE = true;

        // Money comparison tolerance (rounding noise between OCR and keyed value).
        var OCR_AMOUNT_TOLERANCE = 0.01;

        // Candidate json field names. The first one present in the response wins.
        // Finalise these once the sample OCR response is available.
        var OCR_FIELDS = {
            invoiceNo: ['invoice_no', 'invoiceNo', 'invoice_number', 'bill_no'],
            invoiceDate: ['invoice_date', 'invoiceDate', 'bill_date'],
            grossValue: ['amount', 'gross_value', 'grossValue', 'total_amount', 'invoice_value', 'grand_total'],
            totalQty: ['total_quantity', 'totalQuantity', 'quantity', 'total_qty', 'qty'],
            supplierGstn: ['supplier_gstn', 'supplierGstn', 'supplier_gst', 'seller_gstin', 'supplier_gstin', 'gstin_supplier'],
            recipientGstn: ['recipient_gstn', 'recipientGstn', 'recipient_gst', 'buyer_gstin', 'recipient_gstin', 'gstin_recipient']
        };

        function ocrPick(obj, names) {
            for (var i = 0; i < names.length; i++) {
                var v = obj[names[i]];
                if (v !== undefined && v !== null && String(v).trim() !== '') {
                    return String(v).trim();
                }
            }
            return '';
        }

        function ocrEl(id) { return document.getElementById(id); }

        function ocrMsg(text, type) {
            var d = ocrEl('divInvoiceOcrMessage');
            if (!d) { return; }
            var cls = (type === 'danger') ? 'text-danger' : (type === 'success') ? 'text-success' : 'text-muted';
            d.innerHTML = '<span class="' + cls + '" style="font-weight:600;">' + text + '</span>';
        }

        // dd-MM-yyyy / yyyy-MM-dd / dd/MM/yyyy  ->  dd/MM/yyyy (the format this page uses)
        function ocrNormalizeDate(value) {
            if (!value) { return ''; }
            var s = String(value).trim().replace(/\//g, '-');
            var p = s.split('-');
            if (p.length !== 3) { return String(value).trim(); }
            var d, m, y;
            if (p[0].length === 4) { y = p[0]; m = p[1]; d = p[2]; }
            else { d = p[0]; m = p[1]; y = p[2]; }
            if (y.length === 2) { y = '20' + y; }
            return ('0' + d).slice(-2) + '/' + ('0' + m).slice(-2) + '/' + y;
        }

        function ocrNormalizeText(value) {
            return String(value || '').trim().toUpperCase().replace(/\s+/g, '');
        }

        function ocrToNumber(value) {
            if (value === undefined || value === null) { return NaN; }
            var s = String(value).replace(/[^0-9.\-]/g, '');
            return s === '' ? NaN : parseFloat(s);
        }

        // Modified-by MUKESH BHAGAT on 27-08-2026 : quantity actually being despatched -
        // the sum of every "This Despatch" box whose grid row is ticked.
        function ocrGridDespatchTotal() {
            var boxes = document.querySelectorAll('input[id$="txtThisDesp"]');
            var total = 0, found = false;
            for (var i = 0; i < boxes.length; i++) {
                var row = boxes[i].closest ? boxes[i].closest('tr') : null;
                var chk = row ? row.querySelector('input[type="checkbox"][id*="chkSelect"]') : null;
                if (chk && !chk.checked) { continue; }
                var v = ocrToNumber(boxes[i].value);
                if (!isNaN(v)) { total += v; found = true; }
            }
            return found ? total : NaN;
        }

        function ocrSetVerified(flag) {
            var h = ocrEl('<%= hdnOcrVerified.ClientID %>');
            if (h) { h.value = flag ? 'Y' : 'N'; }
        }

        // Any manual edit after a successful check invalidates the verification, so the
        // next Submit silently re-validates against the bill.
        function ocrBindInvalidators() {
            var ids = ['<%= txtCenvatNo.ClientID %>', '<%= txtCenvatDt.ClientID %>', '<%= txtFinalInvoiceValue.ClientID %>', '<%= sch_fld1.ClientID %>'];
            for (var i = 0; i < ids.length; i++) {
                var el = ocrEl(ids[i]);
                if (el && !el.getAttribute('data-ocr-bound')) {
                    el.setAttribute('data-ocr-bound', '1');
                    el.addEventListener('change', function () { ocrSetVerified(false); });
                }
            }
        }

        // Modified-by MUKESH BHAGAT on 27-08-2026 : the OCR check is no longer a separate
        // button. Submit is intercepted: the bill is validated silently first, and only a
        // failed bill blocks the save and shows the panel with what the bill contains.
        // If the OCR service itself is unreachable the save proceeds (fail-open) so a
        // service outage can never stop despatches - flip OCR_FAIL_OPEN to change that.
        var OCR_FAIL_OPEN = true;
        var ocrPassThrough = false;

        function bindInvoiceUploadExtract() {
            var btn = ocrEl('<%= btnSubmit.ClientID %>');
            if (btn && !btn.getAttribute('data-ocr-bound')) {
                btn.setAttribute('data-ocr-bound', '1');
                btn.addEventListener('click', function (e) {
                    if (ocrPassThrough) { ocrPassThrough = false; return; }   // continuing after a passed check

                    var h = ocrEl('<%= hdnOcrVerified.ClientID %>');
                    if (h && h.value === 'Y') { return; }                     // already validated, nothing changed

                    var fileUpload = ocrEl('<%= sch_fld1.ClientID %>');
                    if (!fileUpload || !fileUpload.files || fileUpload.files.length === 0) {
                        return;                                               // no new bill -> existing behaviour
                    }

                    if (!/\.pdf$/i.test(fileUpload.files[0].name)) {
                        e.preventDefault();
                        ocrMsg('Please upload a PDF invoice file.', 'danger');
                        fileUpload.value = '';
                        return;
                    }

                    e.preventDefault();                                       // hold the save, check the bill first
                    triggerInvoiceOcrUpload(fileUpload, btn);
                });
            }
            ocrBindInvalidators();
        }

        function ocrContinueSubmit(btn) {
            ocrPassThrough = true;
            btn.click();
        }

        // Modified-by MUKESH BHAGAT on 31-08-2026 : while the bill is being validated the
        // user must not be able to Delete or Cancel out from under the pending save.
        // Modified-by MUKESH BHAGAT on 08-09-2026 : also raise/lower the full-page loader so
        // every field on the page is blocked (not just the three buttons) while the check runs.
        function ocrLockActions(lock) {
            var ids = ['<%= btnSubmit.ClientID %>', '<%= btnDelete.ClientID %>', '<%= btnCancel.ClientID %>'];
            for (var i = 0; i < ids.length; i++) {
                var el = ocrEl(ids[i]);
                if (el) { el.disabled = lock; }
            }
            var loader = ocrEl('divOcrLoader');
            if (loader) { loader.style.display = lock ? 'flex' : 'none'; }
        }

        function triggerInvoiceOcrUpload(fileUpload, btn) {
            var file = fileUpload.files[0];
            var formData = new FormData();
            formData.append('file', file, file.name);

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'InvoiceOcrExtract.ashx', true);

            ocrLockActions(true);
            ocrSetVerified(false);
            ocrMsg('Validating the uploaded invoice, please wait...', 'info');

            xhr.onload = function () {
                ocrLockActions(false);

                var result;
                try { result = JSON.parse(xhr.responseText); }
                catch (e) { result = null; }

                if (xhr.status === 200 && result && result.success) {
                    applyInvoiceOcrResult(result, fileUpload, btn);
                } else if (result && result.message) {
                    // the service answered and rejected the document -> block the save
                    ocrSetVerified(false);
                    fileUpload.value = '';
                    ocrMsg('Bill rejected: ' + result.message, 'danger');
                } else if (OCR_FAIL_OPEN) {
                    // the service itself failed -> do not hold up the despatch
                    ocrContinueSubmit(btn);
                } else {
                    ocrMsg('Invoice validation service is unavailable. Please try again.', 'danger');
                }
            };

            xhr.onerror = function () {
                ocrLockActions(false);
                if (OCR_FAIL_OPEN) {
                    ocrContinueSubmit(btn);
                } else {
                    ocrMsg('Invoice validation service is unavailable. Please try again.', 'danger');
                }
            };

            xhr.send(formData);
        }

        function applyInvoiceOcrResult(result, fileUpload, btn) {

            var ocrInvNo = ocrPick(result, OCR_FIELDS.invoiceNo);
            var ocrInvDate = ocrNormalizeDate(ocrPick(result, OCR_FIELDS.invoiceDate));
            var ocrGross = ocrPick(result, OCR_FIELDS.grossValue);
            var ocrQty = ocrPick(result, OCR_FIELDS.totalQty);
            var ocrSupGstn = ocrPick(result, OCR_FIELDS.supplierGstn);
            var ocrRecGstn = ocrPick(result, OCR_FIELDS.recipientGstn);

            // filled in either way, but only shown when the bill fails validation
            ocrEl('txtOcrInvoiceNo').value = ocrInvNo;
            ocrEl('txtOcrInvoiceDate').value = ocrInvDate;
            ocrEl('txtOcrGrossValue').value = ocrGross;
            ocrEl('txtOcrTotalQty').value = ocrQty;
            ocrEl('txtOcrSupplierGstn').value = ocrSupGstn;
            ocrEl('txtOcrRecipientGstn').value = ocrRecGstn;

            var txtInvNo = ocrEl('<%= txtCenvatNo.ClientID %>');
            var txtInvDate = ocrEl('<%= txtCenvatDt.ClientID %>');
            var txtValue = ocrEl('<%= txtFinalInvoiceValue.ClientID %>');

            var errors = [];
            var warnings = [];

            // ---- Invoice number : mandatory, must match exactly ----
            if (!ocrInvNo) {
                errors.push('Invoice number could not be read from the bill.');
            } else if (ocrNormalizeText(txtInvNo.value) === '') {
                txtInvNo.value = ocrInvNo;                       // empty -> fill from the bill
            } else if (ocrNormalizeText(txtInvNo.value) !== ocrNormalizeText(ocrInvNo)) {
                errors.push('Invoice No does not match the uploaded bill (bill shows "' + ocrInvNo + '").');
            }

            // ---- Invoice date : mandatory, must match exactly ----
            if (!ocrInvDate) {
                errors.push('Invoice date could not be read from the bill.');
            } else if (ocrNormalizeText(txtInvDate.value) === '') {
                txtInvDate.value = ocrInvDate;
            } else if (ocrNormalizeDate(txtInvDate.value) !== ocrInvDate) {
                errors.push('Invoice Date does not match the uploaded bill (bill shows "' + ocrInvDate + '").');
            }

            // ---- Gross value : mandatory ----
            var ocrGrossNum = ocrToNumber(ocrGross);
            if (isNaN(ocrGrossNum)) {
                if (OCR_REQUIRE_GROSS_VALUE) {
                    errors.push('Gross value could not be read from the bill.');
                }
            } else if (ocrToNumber(txtValue.value) === 0 || txtValue.value === '') {
                txtValue.value = ocrGrossNum;
            } else if (Math.abs(ocrToNumber(txtValue.value) - ocrGrossNum) > OCR_AMOUNT_TOLERANCE) {
                errors.push('Final Invoice Value does not match the bill (bill shows ' + ocrGrossNum + ').');
            }

            // ---- Total quantity : optional ----
            // Modified-by MUKESH BHAGAT on 27-08-2026 : compare against the quantity actually being
            // despatched - the sum of the "This Despatch" boxes on ticked grid rows. (The earlier
            // anchor, lblTotalDespatchQuantity, sits in the per-SKU popup and is never filled in,
            // so the check silently never ran.)
            var gridQty = ocrGridDespatchTotal();
            var ocrQtyNum = ocrToNumber(ocrQty);
            if (!isNaN(ocrQtyNum) && !isNaN(gridQty) && gridQty > 0 && Math.abs(ocrQtyNum - gridQty) > 0.001) {
                warnings.push('quantity on the bill (' + ocrQtyNum + ') differs from the despatched quantity (' + gridQty + ')');
            }

            // ---- GSTN : optional, compared against the master values when available ----
            var mstSup = ocrEl('<%= txtSupplierGstn.ClientID %>');
            var mstRec = ocrEl('<%= txtDepotGstn.ClientID %>');
            if (ocrSupGstn && mstSup && ocrNormalizeText(mstSup.value) !== '' &&
                ocrNormalizeText(mstSup.value) !== ocrNormalizeText(ocrSupGstn)) {
                warnings.push('supplier GSTN on the bill differs from the site GSTN');
            }
            if (ocrRecGstn && mstRec && ocrNormalizeText(mstRec.value) !== '' &&
                ocrNormalizeText(mstRec.value) !== ocrNormalizeText(ocrRecGstn)) {
                warnings.push('recipient GSTN on the bill differs from the invoicing depot GSTN');
            }

            // ---- E-Way bill number : optional convenience ----
            // Modified-by MUKESH BHAGAT on 27-08-2026 : the COLOURANT_INV_AI service reads the
            // e-way bill number off the invoice; fill the field when empty, warn on mismatch.
            var ocrEway = ocrPick(result, ['eway_bill_no', 'ewayBillNo', 'eway_no']);
            var txtEway = ocrEl('<%= txtEwayBillNo.ClientID %>');
            if (ocrEway && txtEway) {
                if (ocrNormalizeText(txtEway.value) === '') {
                    txtEway.value = ocrEway;
                } else if (ocrNormalizeText(txtEway.value) !== ocrNormalizeText(ocrEway)) {
                    warnings.push('E-Way bill no on the bill (' + ocrEway + ') differs from the entered value');
                }
            }

            if (errors.length > 0) {
                // mandatory check failed -> the save is blocked and, only now, the user is
                // shown what the bill contains alongside the reasons
                ocrSetVerified(false);
                fileUpload.value = '';
                ocrEl('divInvoiceOcrPanel').style.display = '';
                ocrMsg('Bill rejected: ' + errors.join(' ') + ' Please correct the details and upload the correct bill.', 'danger');
                return;
            }

            // Modified-by MUKESH BHAGAT on 31-08-2026 : optional checks (quantity, GSTN,
            // E-Way no) no longer pass silently - the user must consciously accept them
            // through a confirm dialog. OK -> save proceeds; Cancel -> save is held, the
            // panel shows what the bill contains, and the next Submit re-validates.
            if (warnings.length > 0) {
                var proceed = window.confirm(
                    'Please note:\n\n- ' + warnings.join('\n- ') +
                    '\n\nDo you want to continue saving this despatch?');
                if (!proceed) {
                    ocrSetVerified(false);
                    ocrEl('divInvoiceOcrPanel').style.display = '';
                    ocrMsg('Save cancelled: ' + warnings.join('; ') + '.', 'danger');
                    return;
                }
            }

            // bill matches -> continue the save the user asked for
            ocrSetVerified(true);
            ocrEl('divInvoiceOcrPanel').style.display = 'none';
            ocrMsg('', 'info');
            ocrContinueSubmit(btn);
        }

        document.addEventListener('DOMContentLoaded', function () { bindInvoiceUploadExtract(); });

        // re-bind after every partial postback and reset stale verification
        // (an UpdatePanel refresh clears the file input, so the bill must be re-selected)
        if (typeof Sys !== 'undefined' && Sys.WebForms) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                bindInvoiceUploadExtract();
                var panel = ocrEl('divInvoiceOcrPanel');
                if (panel) { panel.style.display = 'none'; }
                ocrSetVerified(false);
            });
        }

    </script>
</asp:Content>
