<%@ Page Title="OC SPECIFICATION PARAMS LIST" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="OCSPrdPrmMaster.aspx.vb" Inherits="OCSPrdPrmMaster" %>


<%@ Register TagPrefix="uc1" TagName="Footer" Src="includes/Footer.ascx" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="Head1" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">.table-responsive { overscroll-behavior: auto; }</style>
    

    <%-- Modified-by MUKESH BHAGAT on 20-08-2026 : FunctionValidator.js is commented out in MasterPage; ValidateSubmit needs ValidateRequired/ValidateDropDown1/GetErrorRow/SetErrorColor/SetControlFocus --%>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script src="Scripts/ValidatePrdPrmMaster.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function disableBackButton() {
            window.history.forward(1);
        }
    </script>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">OC Specifivation Params List</h3>
                <p class="pageSubTitle">Maintain specification parameters per product</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-control-label">Product Name:</label>
                                <asp:DropDownList ID="ddlparam" CssClass="form-control select2" runat="server" AutoPostBack="True"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="card">
        <div class="mst-panel-header">
            <div class="mst-panel-header-left">
                <span class="mst-panel-icon"><i class="fas fa-list"></i></span>
                <div>
                    <h5 class="mst-panel-title">OC Specifivation Params List</h5>
                    <p class="mst-panel-subtitle">Browse and manage user profiles</p>
                </div>
            </div>
        </div>
        <div class="card-body">
            <span class="errormsg">*Note : Please enter drop down parameters with coma saparetor..!!</span>
            <div class="table-responsive">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnOcsHasData" runat="server" Value="0" />
                        <asp:HiddenField ID="hdnOcsPageSize" runat="server" Value="15" />
                        <asp:GridView ID="gvParamsList" runat="server" AutoGenerateColumns="False" EmptyDataText="No record(s) found."
                            EnableModelValidation="True" ShowFooter="true" AllowPaging="false" PageSize="15" BorderWidth="1" CssClass="table table-hover upgradDataGrid">
                            <RowStyle CssClass="tlrowlight" />
                            <PagerStyle CssClass="PagerGrid" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="headerGrid" />
                            <FooterStyle CssClass="footerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="Product Code" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPrdCode" runat="server" Text='<%# Bind("product_code") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox CssClass="form-control" ID="txtPrdCode" runat="server" Text='<%# Bind("product_code") %>'></asp:TextBox>
                                        <asp:TextBox CssClass="form-control" ID="txtfreqq" runat="server" Text='<%# Bind("frequencycode") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtPrdCode1" CssClass="form-control" runat="server"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductname" runat="server" Text='<%# Bind("product_name") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnId" runat="server" Value='<%# Bind("product_code") %>'></asp:HiddenField>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlprodname" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                        <asp:HiddenField ID="hdnprdid" runat="server" Value='<%# Bind("opph_id") %>'></asp:HiddenField>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlprdname" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Parameters Name" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParams" runat="server" Text='<%# Bind("params") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtparams" CssClass="form-control" runat="server" Text='<%# Bind("params") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtparam" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Frequency" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblfrequency" runat="server" Text='<%# Bind("frequency")%>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlfreq" runat="server" CssClass="form-control select2"></asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlfreqncy" runat="server" CssClass="form-control select2">
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# Bind("active") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlActive_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="NumericYN" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNumeric" runat="server" Text='<%# Bind("numericYN") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlNumeric" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlNumeric_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Min Value" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMinValue" runat="server" Text='<%# Bind("min_value") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtminValue" CssClass="form-control" runat="server" Text='<%# Bind("min_value") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtminValueft" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Max Value" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMaxValue" runat="server" Text='<%# Bind("max_value") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtmaxValue" CssClass="form-control" runat="server" Text='<%# Bind("max_value") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtmaxValueft" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="9%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="DropdownYN" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDropdown" runat="server" Text='<%# Bind("dropdownYN") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlDropdown" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:DropDownList ID="ddlDropdown_ftr" runat="server" CssClass="form-control select2">
                                            <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="N" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="3%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Drop Down Params" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDropDownParam" runat="server" Text='<%# Bind("DrpDwnParams") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtDropDownParam" CssClass="form-control" runat="server" Text='<%# Bind("DrpDwnParams") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <asp:TextBox ID="txtDropDownParam_ftr" runat="server" CssClass="form-control"></asp:TextBox>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%--<asp:Button ID="btnEdit" CommandName="Edit" Width="90%" CssClass="but1" runat="server" Text="Edit" />--%>

                                        <%--<asp:ImageButton ID="btnEdit" CommandName="Edit" runat="server" ImageUrl="~/Images/edit.jpg" />--%>
                                        <asp:LinkButton ID="btnEdit" CommandName="Edit" runat="server"><i class="fa fa-wrench"></i></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%-- <asp:Button ID="btnUpdate" CommandName="Update" Width="90%" CssClass="but1" runat="server" Text="Update" />
                                                     <asp:Button ID="btnCancel" CommandName="Cancel" Width="90%" CssClass="but1" runat="server" Text="Cancel" />--%>

                                        <%--<asp:ImageButton ID="btnUpdate" CommandName="Update" runat="server" ImageUrl="~/Images/b_save.gif" />
                                        <asp:ImageButton ID="btnCancel" CommandName="Cancel" runat="server" ImageUrl="~/Images/b_cancel.gif" />--%>
                                        <asp:LinkButton ID="btnUpdate" CommandName="Update" runat="server" title="Save"><i class="fa fa-check-circle" style="color:#00ff21"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" CommandName="Cancel" runat="server" title="Cancel"><i class="fa fa-times-circle" style="color:#ff6a00;"></i></asp:LinkButton>
                                    </EditItemTemplate>
                                    <FooterTemplate>
                                        <%-- <asp:Button ID="btnSubmit" CommandName="Submit" Width="90%" CssClass="but1" runat="server" Text="Submit" />--%>

                                        <%--<asp:ImageButton ID="btnSubmit" CommandName="Submit" runat="server" ImageUrl="~/Images/b_save.gif" />--%>
                                        <asp:LinkButton ID="btnSubmit" CommandName="Submit" runat="server"><i class="fa fa-check-circle" style="color:#00ff21"></i></asp:LinkButton>
                                    </FooterTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <asp:Label ID="lblErrorMessage" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
        </div>
    </div>
    <script type="text/javascript">
        (function () {
            var gridSel = '#<%= gvParamsList.ClientID %>';
            var pageIndex = 0, pageSize = 15, total = 0, loading = false, noMore = false, seq = 0, suppressUntil = 0;
            var productCode = '';
            var products = null, frequencies = null;

            function esc(v) {
                return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
                });
            }
            function dataRows() { return $(gridSel + ' tbody tr.tlrowlight').not('.ocs-skel'); }
            function scrollBox() { return $(gridSel).closest('.table-responsive'); }
            function capture() {
                productCode = $('#<%= ddlparam.ClientID %>').val() || '';
                var size = parseInt($('#<%= hdnOcsPageSize.ClientID %>').val(), 10);
                pageSize = size > 0 ? size : 15;
                total = 0;
            }
            function skel() {
                var widths = ['70%', '70%', '50%', '36px', '36px', '40px', '40px', '28px', '60%', '18px'];
                var cells = '';
                for (var i = 0; i < widths.length; i++) cells += '<td style="text-align:center"><span class="grid-skel-bar" style="width:' + widths[i] + '"></span></td>';
                return '<tr class="tlrowlight ocs-skel">' + cells + '</tr>';
            }
            function place(html) {
                var $rows = $('<table><tbody>' + html + '</tbody></table>').find('tr');
                var $footer = $(gridSel).find('tr.footerGrid').first();
                if ($footer.length) $footer.before($rows);
                else $(gridSel).find('tbody').append($rows);
            }
            function lovSelect(id, list, selected) {
                var html = '<select id="' + id + '" class="form-control select2">';
                for (var i = 0; i < list.length; i++) {
                    html += '<option value="' + esc(list[i].code) + '"' + (list[i].code === selected ? ' selected' : '') + '>' + esc(list[i].name) + '</option>';
                }
                return html + '</select>';
            }
            function ynSelect(id, selected) {
                return '<select id="' + id + '" class="form-control select2">'
                    + '<option value="Y"' + (selected === 'Y' ? ' selected' : '') + '>Yes</option>'
                    + '<option value="N"' + (selected !== 'Y' ? ' selected' : '') + '>No</option></select>';
            }
            function viewRow(r) {
                return '<tr class="tlrowlight ocs-more" data-id="' + esc(r.id) + '" data-product="' + esc(r.productCode) + '" data-productname="' + esc(r.productName) + '" data-params="' + esc(r.params) + '" data-freq="' + esc(r.frequencyCode) + '" data-freqname="' + esc(r.frequency) + '" data-active="' + esc(r.active) + '" data-numeric="' + esc(r.numericYn) + '" data-min="' + esc(r.minValue) + '" data-max="' + esc(r.maxValue) + '" data-dropdown="' + esc(r.dropdownYn) + '" data-dropparams="' + esc(r.dropParams) + '">'
                    + '<td style="text-align:center">' + esc(r.productName) + '</td>'
                    + '<td style="text-align:center">' + esc(r.params) + '</td>'
                    + '<td style="text-align:center">' + esc(r.frequency) + '</td>'
                    + '<td style="text-align:center">' + esc(r.active) + '</td>'
                    + '<td style="text-align:center">' + esc(r.numericYn) + '</td>'
                    + '<td style="text-align:center">' + esc(r.minValue) + '</td>'
                    + '<td style="text-align:center">' + esc(r.maxValue) + '</td>'
                    + '<td style="text-align:center">' + esc(r.dropdownYn) + '</td>'
                    + '<td style="text-align:center">' + esc(r.dropParams) + '</td>'
                    + '<td style="text-align:center"><a href="javascript:void(0)" class="ocs-edit" title="Edit"><i class="fa fa-wrench"></i></a></td></tr>';
            }
            function showMessage(ok) {
                var lbl = document.getElementById('<%= lblErrorMessage.ClientID %>');
                if (!lbl) return;
                lbl.style.color = ok ? 'green' : 'red';
                lbl.innerHTML = ok ? 'Updated Successfully.' : 'Some Error Occured.';
            }
            function loadNext() {
                if (loading || noMore) return;
                if ($('#<%= hdnOcsHasData.ClientID %>').val() !== '1') return;
                if (!dataRows().length) return;
                if (total && ((pageIndex + 1) * pageSize >= total || dataRows().length >= total)) { noMore = true; return; }
                loading = true;
                pageIndex++;
                var token = ++seq;
                place(skel());
                var box = scrollBox();
                if (box.length && box[0].scrollHeight > box[0].clientHeight) {
                    suppressUntil = Date.now() + 200;
                    box.scrollTop(box[0].scrollHeight);
                }
                PageMethods.GetMoreOcsParams(pageIndex, pageSize, productCode, function (res) {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ocs-skel').remove();
                    loading = false;
                    if (!res || !res.rows) { noMore = true; return; }
                    total = res.total || 0;
                    if (res.products && res.products.length) products = res.products;
                    if (res.frequencies && res.frequencies.length) frequencies = res.frequencies;
                    if (!res.rows.length || res.rows.length < pageSize || (pageIndex + 1) * pageSize >= total) noMore = true;
                    var html = '';
                    for (var i = 0; i < res.rows.length; i++) html += viewRow(res.rows[i]);
                    if (html) place(html);
                    var live = scrollBox();
                    if (!noMore && live.length && live[0].scrollHeight <= live[0].clientHeight + 2) loadNext();
                }, function () {
                    if (token !== seq) return;
                    $(gridSel + ' tr.ocs-skel').remove();
                    loading = false;
                    pageIndex--;
                });
            }
            function onScroll() {
                if (Date.now() < suppressUntil) return;
                if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) loadNext();
            }
            function bind() {
                pageIndex = 0; noMore = false; loading = false; seq++;
                products = null; frequencies = null;
                capture();
                var box = scrollBox();
                box.off('scroll.ocs').on('scroll.ocs', onScroll);
                if ($('#<%= hdnOcsHasData.ClientID %>').val() === '1' && box.length && box[0].scrollHeight <= box[0].clientHeight + 2) loadNext();
            }
            $(document).on('click', '.ocs-edit', function (ev) {
                ev.preventDefault();
                if (!products || !frequencies) return;
                var tr = $(this).closest('tr');
                var id = tr.attr('data-id');
                tr.html(
                    '<td>' + lovSelect('ocsPrd' + id, products, tr.attr('data-product')) + '</td>'
                    + '<td><input type="text" id="ocsParam' + id + '" class="form-control" value="' + esc(tr.attr('data-params')) + '" /></td>'
                    + '<td>' + lovSelect('ocsFreq' + id, frequencies, tr.attr('data-freq')) + '</td>'
                    + '<td>' + ynSelect('ocsActive' + id, tr.attr('data-active')) + '</td>'
                    + '<td>' + ynSelect('ocsNum' + id, tr.attr('data-numeric')) + '</td>'
                    + '<td><input type="text" id="ocsMin' + id + '" class="form-control ocs-decimal" value="' + esc(tr.attr('data-min')) + '" /></td>'
                    + '<td><input type="text" id="ocsMax' + id + '" class="form-control ocs-decimal" value="' + esc(tr.attr('data-max')) + '" /></td>'
                    + '<td>' + ynSelect('ocsDrop' + id, tr.attr('data-dropdown')) + '</td>'
                    + '<td><input type="text" id="ocsDropParam' + id + '" class="form-control" value="' + esc(tr.attr('data-dropparams')) + '" /></td>'
                    + '<td style="text-align:center"><a href="javascript:void(0)" id="ocsSave' + id + '" class="ocs-save" title="Save"><i class="fa fa-check-circle" style="color:#00ff21"></i></a> <a href="javascript:void(0)" class="ocs-cancel" title="Cancel"><i class="fa fa-times-circle" style="color:#ff6a00;"></i></a></td>'
                );
                if (window.jQuery && jQuery.fn.select2) tr.find('select.select2').select2();
            });
            $(document).on('click', '.ocs-cancel', function (ev) {
                ev.preventDefault();
                var tr = $(this).closest('tr');
                tr.replaceWith(viewRow({
                    id: tr.attr('data-id'), productCode: tr.attr('data-product'), productName: tr.attr('data-productname'),
                    params: tr.attr('data-params'), frequencyCode: tr.attr('data-freq'), frequency: tr.attr('data-freqname'),
                    active: tr.attr('data-active'), numericYn: tr.attr('data-numeric'), minValue: tr.attr('data-min'),
                    maxValue: tr.attr('data-max'), dropdownYn: tr.attr('data-dropdown'), dropParams: tr.attr('data-dropparams')
                }));
            });
            $(document).on('keypress', '.ocs-decimal', function (ev) { return isDecimalNumber(this, ev); });
            $(document).on('click', '.ocs-save', function (ev) {
                ev.preventDefault();
                var tr = $(this).closest('tr');
                var id = tr.attr('data-id');
                if (!ValidateSubmit('ocsPrd' + id, 'ocsParam' + id, 'ocsFreq' + id, 'ocsNum' + id, 'ocsDrop' + id, 'ocsDropParam' + id, 'ocsMin' + id, 'ocsMax' + id, 'ocsSave' + id, '<%= lblErrorMessage.ClientID %>')) return false;
                PageMethods.SaveOcsParam(id, $('#ocsPrd' + id).val(), $('#ocsParam' + id).val(), $('#ocsFreq' + id).val(), $('#ocsActive' + id).val(), $('#ocsNum' + id).val(), $('#ocsDrop' + id).val(), $('#ocsDropParam' + id).val(), $('#ocsMin' + id).val(), $('#ocsMax' + id).val(), function (msg) {
                    if (msg === 'ok') {
                        showMessage(true);
                        tr.replaceWith(viewRow({
                            id: id,
                            productCode: $('#ocsPrd' + id).val(),
                            productName: $('#ocsPrd' + id + ' option:selected').text(),
                            params: $('#ocsParam' + id).val(),
                            frequencyCode: $('#ocsFreq' + id).val(),
                            frequency: $('#ocsFreq' + id + ' option:selected').text(),
                            active: $('#ocsActive' + id).val(),
                            numericYn: $('#ocsNum' + id).val(),
                            minValue: $('#ocsMin' + id).val(),
                            maxValue: $('#ocsMax' + id).val(),
                            dropdownYn: $('#ocsDrop' + id).val(),
                            dropParams: $('#ocsDropParam' + id).val()
                        }));
                    } else {
                        showMessage(false);
                    }
                }, function () { showMessage(false); });
                return false;
            });
            $(bind);
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                    var panels = args.get_panelsUpdated();
                    for (var i = 0; i < panels.length; i++) {
                        if ($(panels[i]).find(gridSel).length) { bind(); break; }
                    }
                });
            }
        })();
    </script>
</asp:Content>
