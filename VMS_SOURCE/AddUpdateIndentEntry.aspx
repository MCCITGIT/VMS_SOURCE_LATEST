<%@ Page Title="Add / Update Indent Entry" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="AddUpdateIndentEntry.aspx.vb" Inherits="AddUpdateIndentEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <script type="text/javascript" src="Scripts/ValidationAddUpdateIndentEntry.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
    <script type="text/javascript">
        document.onkeydown = checkValue;
        function checkValue() {
            if (event.keyCode == 118) { // button Add (F7 keypress)
                if (document.getElementById('btnSubmit').disabled == true)
                    return false;
                else {
                    // button Add (F7 keypress)
                    validateSKUList();
                }
                //__doPostBack(document.getElementById('btnSubmit').name, '');
            }
            else if (event.keyCode == 119) {
                __doPostBack(document.getElementById('btnCancel').name, '');
            }
        }

        function disableBackButton() {
            window.history.forward(1);
        }
        function showmodal() {
            //debugger;
            $('#exampleModal').modal('show')
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Add - Update Indent Entry</h3>
                <p class="pageSubTitle">Raise or revise a depot indent</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" Visible="true" runat="server" Text=""></asp:Label>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlRegion" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlDepot" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlVendorProduct" EventName="SelectedIndexChanged" />
                </Triggers>
            </asp:UpdatePanel>
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Indent No.:</label>
                        <asp:Label ID="lblIndentNo" runat="server" Text="(Auto-Generated)" CssClass="labelDataPoint"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Indent Date:</label>
                        <asp:Label ID="lblIndentDate" runat="server" CssClass="labelDataPoint"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Region:</label>
                        <asp:DropDownList ID="ddlRegion" runat="server" CssClass="form-control select2" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Depot:<span id="Span1" class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlDepot" ClientIDMode="Static" runat="server" AutoPostBack="True" CssClass="form-control select2">
                                </asp:DropDownList>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlDepot"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Fin Year:</label>
                        <asp:Label ID="lblFinYear" runat="server" CssClass="labelDataPoint"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Fin Month:</label>
                        <asp:Label ID="lblFinMonth" runat="server" CssClass="labelDataPoint"></asp:Label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Product:<span id="Span3" class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorProduct" runat="server" AutoPostBack="True" CssClass="form-control select2">
                                </asp:DropDownList>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlRegion"
                                    EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlDepot"
                                    EventName="SelectedIndexChanged" />
                                <%-- <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit" 
                                                        EventName="SelectedIndexChanged" />--%>
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Vendor Source:<span id="Span2" class="mandatory">*</span></label>
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlVendorUnit" ClientIDMode="Static" runat="server" AutoPostBack="True" CssClass="form-control select2"></asp:DropDownList>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlRegion"
                                    EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlDepot"
                                    EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorProduct"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-control-label">Upload Customer PO Copy:</label>
                        <asp:UpdatePanel ID="UpdatePanel8" runat="server">
                            <ContentTemplate>
                                <asp:FileUpload ID="sch_fld1" runat="server" CssClass="form-control" />
                                <%--  <span id="Span2" class="mandatory">*</span>--%>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlRegion" EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlDepot" EventName="SelectedIndexChanged" />
                                <asp:AsyncPostBackTrigger ControlID="ddlVendorProduct" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-3 form-btn-mt">
                    <div class="form-group">
                        <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" runat="server" id="btnadditional" data-target=".bd-example-modal-lg">
                            PO Linking Request
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <table style="width: 100%;">
                <tr>
                    <td style="text-align: center; border: solid 1px #d7d7d7; padding: 5px; background-color: #f9f9f9; width: 100%; font-family: Verdana; font-size: 10px; font-weight: bold;">
                        <span>ENTER NOP</span>
                    </td>
                </tr>

                <tr>
                    <td style="text-align: center; border: solid 1px #d7d7d7; padding: 5px; background-color: #f9f9f9; width: 100%; font-family: Verdana; font-size: 10px; font-weight: bold;">
                        <b style='color: red;'>*</b><span> After entering Indent NOP, enter tab to see 
                                the change in Indent to Estimate (%).</span>
                    </td>
                </tr>
            </table>
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvIndentSKUList" runat="server" AutoGenerateColumns="False" BorderWidth="1" CssClass="table table-hover upgradDataGrid m-0" EmptyDataText="No records found">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowNo" runat="server" Width="94%" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SKU Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSKUCode" runat="server" Text='<%# Bind("sku_desc") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnfldSKUCode" runat="server" Value='<%# Bind("v_sku_code") %>' />
                                        <asp:HiddenField ID="hdnfldSKUUOM" runat="server" Value='<%# Bind("sku_uom") %>' />
                                        <asp:HiddenField ID="hdnfldSKUVol" runat="server" Value='<%# Bind("sku_volume") %>' />
                                        <asp:HiddenField ID="hdnfldTSl" runat="server" Value='<%# Bind("tsl") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Three Months Average">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLoadAverage" runat="server" Text='<%# Bind("load_average") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Stock as on">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCurrentStock" runat="server" Text='<%# Bind("current_stock") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Pending<br />Load">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPendingLoad" runat="server" Text='<%# Bind("pending_load") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Depot Indent-to-Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIndentToDate" runat="server" Text='<%# Bind("load_depot_indent_nop") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Despatch-to-Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDespatchToDate" runat="server" Text='<%# Bind("load_despatched_nop") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Indent to Estimate (%) <b style='color:red;'>*</b>">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPercentage" runat="server" Text='<%# Bind("load_percent") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="5%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Indent NOP" ControlStyle-Width="90%" ControlStyle-Height="90%">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtNewLoad" CssClass="form-control" runat="server" MaxLength="6"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="8%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Justification for additional load." ControlStyle-Width="90%"
                                    ControlStyle-Height="90%">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Width="40%" Height="50px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <%-- <asp:AsyncPostBackTrigger ControlID="ddlRegion" 
                                            EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="ddlDepot" 
                                            EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="ddlVendorUnit" 
                                            EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="ddlVendorProduct" 
                                            EventName="SelectedIndexChanged" />--%>
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="row mt-3">
                <div class="col-md-12 text-right indentEntryTotal">
                    <p>Total Ltr: <asp:Label ID="lblTotLtr" runat="server"></asp:Label></p>
                    <p>Total Kg: <asp:Label ID="lblTotKg" runat="server"></asp:Label></p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success btn-sm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-sm" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-danger btn-sm" />
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <asp:HiddenField ID="hdnskucode" runat="server" />
    <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" id="exampleModal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">PO Linking Request Entry</h5>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>
                <%-- <asp:UpdatePanel ID="updatemodalpopup" runat="server">
                            <ContentTemplate>--%>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <%--<div class="d-flex align-items-center">
                                        <small style="width: 65px;">Depot: </small>
                                        <asp:Label ID="lbldepot" CssClass="p-0 fw600" runat="server"></asp:Label>
                                    </div>--%>
                            <%--<div class="d-flex align-items-center mt-3" >
                                        <small style="width: 65px;">Vendor :<span style="color:red;">*</span> </small>
                                        <%--<asp:Label ID="lblvendor" CssClass="p-0 fw600" runat="server"></asp:Label>--%>
                            <%--<asp:UpdatePanel ID="updatevendor" runat="server">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="ddlvndor" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlvndor_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>    --%>
                            <%--</div>--%>
                            <label class="form-control-label">Depot:</label>
                            <asp:Label ID="lbldepot" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="form-control-label">Vendor:<span style="color: red;">*</span></label>
                            <%--<asp:Label ID="lblvendor" CssClass="p-0 fw600" runat="server"></asp:Label>--%>
                            <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlvndor" ClientIDMode="Static" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>

                        <div class="col-md-3">
                            <label class="form-control-label">SKU Code:<span style="color: red;">*</span></label>
                            <asp:TextBox ID="txtsku" ClientIDMode="Static" CssClass="form-control" runat="server" placeholder="Sku Code" autocomplete="off"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="aceIndentSku" runat="server"
                                BehaviorID="aceIndentSkuSearch"
                                TargetControlID="txtsku"
                                ServiceMethod="SKUSearch"
                                MinimumPrefixLength="3"
                                EnableCaching="false"
                                CompletionListCssClass="vmsAutoComplete"
                                CompletionListItemCssClass="vmsAutoCompleteItem"
                                CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight"
                                OnClientItemSelected="onIndentSkuSelected"
                                FirstRowSelected="true" />
                        </div>

                        <div class="col-md-3">
                            <label class="form-control-label">Remarks:</label>
                            <asp:TextBox ID="txtremarks" CssClass="form-control" runat="server" TextMode="MultiLine" placeholder="Remarks"></asp:TextBox>
                        </div>
                        <div class="col-md-12 justify-content-center align-content-center d-flex mt-3">
                            <asp:LinkButton ID="lnkadd" runat="server" Text="Add" CssClass="btn btn-info btn-sm" OnClick="lnkadd_Click">Add</asp:LinkButton>
                        </div>
                        <asp:UpdatePanel ID="updatemodalpopup" runat="server">
                            <ContentTemplate>
                                <asp:HiddenField ID="hdnskucodes" ClientIDMode="Static" runat="server" />
                                <asp:HiddenField ID="hdnskutext" ClientIDMode="Static" runat="server" />
                                <asp:HiddenField ID="hdnpo" ClientIDMode="Static" runat="server" />
                                <asp:HiddenField ID="hdnvendor" ClientIDMode="Static" runat="server" />
                                <asp:HiddenField ID="hdndepot" ClientIDMode="Static" runat="server" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <div class="col-md-12 text-center">
                            <asp:Label runat="server" ID="lblMsg" ClientIDMode="Static" Visible="true" Text=""></asp:Label>
                        </div>
                        <div class="col-md-12 mt-2" runat="server" id="skudetails" visible="false">
                            <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvskudtls" runat="server" AutoGenerateColumns="false" BorderWidth="1" CssClass="table table-hover upgradDataGrid m-0" EmptyDataText="No records found" OnRowCommand="gvskudtls_RowCommand" OnRowDataBound="gvskudtls_RowDataBound">
                                            <RowStyle CssClass="tlrowlight" />
                                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="headerGrid" />
                                            <FooterStyle CssClass="footerGrid" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Depot">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbldepotcode" runat="server" Text='<%# Eval("depotname") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="24%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Vendor">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblvendorcode" runat="server" Text='<%# Eval("vendorname") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="24%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Product">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblsku" runat="server" Text='<%# Eval("skuname") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="25%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Remarks">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblrmks" runat="server" Text='<%# Eval("remarks") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="25%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Delete" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkdelete" runat="server" Text="Delete" CommandName="itemdelete"><i class="fas fa-trash-alt text-danger text-center fa-lg"></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="2%" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                                <%--<Triggers>
                                            <asp:PostBackTrigger ControlID="gvskudtls" />
                                        </Triggers>--%>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
                <%-- </ContentTemplate>
                        </asp:UpdatePanel>--%>
                <div class="modal-footer">
                    <asp:Button ID="btnaddsku" runat="server" Text="Submit" CssClass="btn btn-success btn-sm" OnClick="btnaddsku_Click" Visible="false" />
                    <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function onIndentSkuSelected(sender, e) {
            document.getElementById('hdnskucodes').value = e.get_value();
            document.getElementById('txtsku').value = e.get_text();
        }

        function updateIndentSkuSearchContext() {
            var vendor = $('#ddlVendorUnit option:selected').val() || '';
            var depot = $('#ddlDepot option:selected').val() || '';
            var ace = $find('aceIndentSkuSearch');
            if (ace) {
                ace.set_contextKey(vendor + '|' + depot);
            }
        }

        function getModalDepotLabel() {
            return document.getElementById('lbldepot')
                || document.querySelector('#exampleModal span[id$="_lbldepot"]');
        }

        $(document).on('shown.bs.modal', '#exampleModal', function () {
            $('#hdnvendor').val($('#ddlvndor option:selected').val());
            $('#hdndepot').val($('#ddlDepot option:selected').val());
            var depot = $('#ddlDepot option:selected').text();
            var lblDepot = getModalDepotLabel();
            if (lblDepot) {
                lblDepot.innerHTML = depot;
            }
            updateIndentSkuSearchContext();
        });

        $(document).ready(function () {
            $("#btnadditional").click(function (e) {
                //e.preventDefault();
                //var vendor = $('#ddlVendorUnit option:selected').val();
                //var depot = $('#ddlDepot option:selected').val();
                //var product = $('#ddlVendorProduct option:selected').val();
                //if (vendor == "" || depot == "" || product == "") {
                //    $('#exampleModal').modal('hide')
                //    $("#lblErrorMsg").text("Please Select Vendor And Depot.");
                //    return false;
                //}
                //else {
                //    $("#lblErrorMsg").text("");
                //    $('#exampleModal').modal('show')
                //}
            });
            if ($('#exampleModal').hasClass('show')) {
                showmodal();
            }

            $("#btnaddsku").click(function () {
                if ($('#gvskudtls').length <= 0) {
                    $("#lblMsg").html("Add atleast one record").css("color", "red");
                    return false;
                }
                else {
                    if (confirm('Are you sure to submit?')) {
                    } else {
                        return false;
                    }
                }
            });

            $("#lnkadd").click(function () {
                firstErrorControl = "";
                errMsg = "";
                ValidateRequired("txtsku", "Please enter SKU.");

                if (!ValidateRequired("ddlvndor", "Select Vertical Name.")) {
                    var select = document.getElementById("ddlvndor");
                    if (select != null) {
                        select.style.border = "2px solid #ffe900";
                    }
                }
                else {
                    var select = document.getElementById("ddlvndor");
                    if (select != null) {
                        select.style.border = "2px solid #ffffff6b";
                    }
                }

                if (firstErrorControl != "") {
                    SetControlFocus(firstErrorControl);
                    errMsg = "<table>" + errMsg + "</table>";
                    document.getElementById("lblMsg").innerHTML = errMsg;
                    return false;
                }
            });
        });
    </script>
</asp:Content>
