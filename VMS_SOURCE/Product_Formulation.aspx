<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Formulation.aspx.vb" Inherits="Product_Formulation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        /* ---------- Scoped to .pf so it doesn't clash with MasterPage styles ---------- */
        .pf {
            --pf-theme: #375973;
            --pf-theme-dark: #2b4659;
            --pf-theme-light: #eaf0f4;
            --pf-green: #28a745;
            --pf-green-dark: #218838;
            --pf-border: #d9dee3;
            color: #222;
            font-size: 13px;
        }

            .pf *, .pf *::before, .pf *::after {
                box-sizing: border-box;
            }

        .pf-section {
            background: #fafdff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 8px 10px;
            margin-bottom: 10px;
        }

        .pf-section-title {
            font-weight: 600;
            font-size: 13px;
            margin: 0 0 6px;
        }

        .pf-section-sub {
            font-size: 11px;
            color: #666;
            margin: -4px 0 8px;
        }

        /* ---------- Inputs / buttons ---------- */
        .pf input[type=text], .pf select {
            width: 100%;
            height: 26px;
            padding: 2px 6px;
            border: 1px solid #c4c4c4;
            border-radius: 4px;
            font-size: 12px;
            background: #fff;
            color: #222;
        }

            .pf input[type=text]:focus, .pf select:focus {
                outline: none;
                border-color: var(--pf-theme);
                box-shadow: 0 0 0 2px rgba(55, 89, 115, .18);
            }

            .pf input[type=text][readonly], .pf input[type=text][disabled], .pf select[disabled] {
                background: #f1f3f5;
            }

        .pf .pf-num {
            text-align: right;
        }

        .pf .field-invalid {
            border: 1px solid #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12) !important;
        }

        .pf .select2-container .select2-selection--single {
            height: 26px;
        }

        .pf .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 24px;
            font-size: 12px;
        }

        .pf .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 24px;
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 11px;
            font-weight: 500;
            margin-top: 3px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .pf-btn {
            height: 26px;
            padding: 0 10px;
            border: 1px solid #c4c4c4;
            border-radius: 4px;
            background: #fff;
            font-size: 12px;
            cursor: pointer;
            white-space: nowrap;
            line-height: 24px;
            display: inline-block;
            text-decoration: none !important;
            color: #222;
        }

            .pf-btn:hover {
                background: #f4f4f4;
            }

        .pf .pf-btn-primary {
            background: var(--pf-theme);
            border-color: var(--pf-theme);
            color: #fff;
            font-weight: 600;
        }

            .pf .pf-btn-primary:hover {
                background: var(--pf-theme-dark);
                border-color: var(--pf-theme-dark);
            }

        .pf .pf-btn-save {
            background: var(--pf-green);
            border-color: var(--pf-green);
            color: #fff;
            font-weight: 600;
        }

            .pf .pf-btn-save:hover {
                background: var(--pf-green-dark);
                border-color: var(--pf-green-dark);
            }

        /* ---------- Header grid ---------- */
        .pf-head-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
            margin-bottom: 8px;
        }

        .pf-label {
            display: block;
            font-size: 11.5px;
            font-weight: 600;
            margin-bottom: 2px;
            color: #333;
        }

            .pf-label .mandatory {
                color: #dc3545;
            }

        .pf-input-group {
            display: flex;
        }

            .pf-input-group input[type=text] {
                border-top-right-radius: 0;
                border-bottom-right-radius: 0;
            }

            .pf-input-group .pf-btn {
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
                border-left: 0;
                padding: 0 8px;
            }

        /* ---------- Tables ---------- */
        .pf-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .pf-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid var(--pf-border);
            border-radius: 6px;
            overflow: hidden;
            margin: 0;
        }

            .pf-table th, .pf-table td {
                padding: 3px 6px;
                border-bottom: 1px solid var(--pf-border);
                vertical-align: middle;
                text-align: left;
            }

            .pf-table thead th, .pf-table tr.headerGrid th {
                background: var(--pf-theme);
                color: #fff;
                font-size: 11.5px;
                font-weight: 600;
                white-space: nowrap;
                padding: 5px 6px;
            }

            .pf-table tbody tr:nth-child(even) td {
                background: #f8fafb;
            }

            .pf-table tbody tr:hover td {
                background: var(--pf-theme-light);
            }

            .pf-table tbody tr:last-child td {
                border-bottom: none;
            }

            .pf-table tfoot td {
                background: var(--pf-theme-light);
                font-weight: 700;
                color: var(--pf-theme);
                border-top: 1px solid var(--pf-border);
                border-bottom: none;
            }

            .pf-table .pf-col-sn {
                width: 40px;
                text-align: center;
            }

            .pf-table .pf-col-amt {
                width: 120px;
            }

            .pf-table .pf-col-act {
                width: 55px;
                text-align: center;
            }

            .pf-table .pf-col-btn {
                width: 70px;
                text-align: center;
            }

            .pf-table .pf-right {
                text-align: right;
            }

            .pf-table .pf-center {
                text-align: center;
            }

        .pf-entry-row td {
            background: #fffbe8 !important;
        }

        /* compact entry controls - beat the rm-module / bootstrap heights (38px) and select2 defaults */
        .rm-module .pf input[type=text],
        .rm-module .pf .form-control,
        .rm-module .pf select,
        .rm-module .pf .select2-container--default .select2-selection--single {
            height: 26px !important;
            min-height: 26px !important;
            padding: 2px 6px !important;
            font-size: 12px !important;
            line-height: 20px !important;
            border: 1px solid #c4c4c4 !important;
            border-radius: 4px !important;
            box-shadow: none !important;
            background-color: #fff;
        }

            .rm-module .pf input[type=text]:focus,
            .rm-module .pf .form-control:focus {
                border-color: var(--pf-theme) !important;
                box-shadow: 0 0 0 2px rgba(55, 89, 115, .18) !important;
            }

        .rm-module .pf .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 20px !important;
            padding-left: 0 !important;
            padding-right: 16px !important;
            font-size: 12px !important;
            color: #222;
        }

        .rm-module .pf .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 24px !important;
            top: 0 !important;
            right: 2px !important;
        }

        .rm-module .pf .pf-input-group {
            display: flex;
            align-items: stretch;
        }

            .rm-module .pf .pf-input-group input[type=text] {
                flex: 1 1 auto;
                min-width: 0;
                border-top-right-radius: 0 !important;
                border-bottom-right-radius: 0 !important;
            }

            .rm-module .pf .pf-input-group .pf-btn {
                flex: 0 0 auto;
                height: 26px;
                line-height: 24px;
                padding: 0 7px;
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
                border-left: 0;
                color: #555;
            }

        .rm-module .pf .pf-entry-row td {
            padding: 4px 4px !important;
            vertical-align: top;
        }

        .rm-module .pf .pf-entry-row .pf-btn-primary {
            height: 26px;
            line-height: 24px;
        }

        .rm-module .pf .field-invalid,
        .rm-module .pf .field-invalid + .select2-container .select2-selection--single {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 2px rgba(220, 53, 69, 0.12) !important;
        }

        /* one entry line: grid and entry table share these column widths */
        .pf-sku-table {
            table-layout: fixed;
            min-width: 1000px;
        }

            .pf-sku-table .pf-c-sn { width: 40px; text-align: center; }
            .pf-sku-table .pf-c-brand { width: 13%; }
            .pf-sku-table .pf-c-vendor { width: 13%; }
            .pf-sku-table .pf-c-sku { width: 17%; }
            .pf-sku-table .pf-c-rm { width: auto; }
            .pf-sku-table .pf-c-ratio { width: 110px; }
            .pf-sku-table .pf-c-price { width: 110px; }
            .pf-sku-table .pf-c-act { width: 70px; }

            .pf-sku-table td {
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .pf-sku-table .select2-container {
                width: 100% !important;
            }

        .pf-remove {
            border: none;
            color: #ffffff;
            background: #db3625;
            cursor: pointer;
            border-radius: 30px;
            width: 20px;
            height: 20px;
            padding: 0;
            font-size: 14px;
            line-height: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
        }

            .pf-remove:hover {
                background: #eb4533;
                color: #fff;
            }

        .pf-status-ok {
            color: #28a745;
        }

        .pf-status-bad {
            color: #dc3545;
        }

        /* ---------- Packaging accordion (pure CSS, checkbox based) ---------- */
        .pf-pack {
            border: 1px solid var(--pf-border);
            border-radius: 6px;
            margin-bottom: 6px;
            overflow: hidden;
        }

        .pf-toggle {
            display: none;
        }

        .pf-pack-head {
            position: relative;
            background: var(--pf-theme-light);
            border-left: 4px solid var(--pf-theme);
        }

        .pf-pack-label {
            display: grid;
            grid-template-columns: 1fr 1fr 150px;
            align-items: center;
            padding: 5px 10px;
            margin: 0;
            cursor: pointer;
            user-select: none;
            color: var(--pf-theme);
            transition: background-color .2s ease;
        }

            .pf-pack-label:hover {
                background: #dde7ee;
            }

        .pf-pack-name {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 12.5px;
        }

        .pf-pack-total {
            font-weight: 700;
            font-size: 12.5px;
        }

        .pf-caret {
            display: inline-block;
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 6px solid var(--pf-theme);
            transform: rotate(-90deg);
            transition: transform .3s ease;
        }

        /* Save / remove sit outside the label so clicking them doesn't toggle the accordion */
        .pf-pack-actions {
            position: absolute;
            right: 6px;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            gap: 6px;
            align-items: center;
        }

            .pf-pack-actions .pf-btn {
                height: 22px;
                line-height: 20px;
                padding: 0 10px;
                font-size: 11.5px;
            }

        .pf-pack-body {
            display: grid;
            grid-template-rows: 0fr;
            opacity: 0;
            transition: grid-template-rows .35s ease, opacity .3s ease;
        }

        .pf-pack-inner {
            overflow: hidden;
            min-height: 0;
        }

        .pf-pack-content {
            padding: 6px;
            transform: translateY(-6px);
            transition: transform .35s ease;
        }

        .pf-toggle:checked + .pf-pack-head .pf-caret {
            transform: rotate(0);
        }

        .pf-toggle:checked ~ .pf-pack-body {
            grid-template-rows: 1fr;
            opacity: 1;
        }

            .pf-toggle:checked ~ .pf-pack-body .pf-pack-content {
                transform: translateY(0);
            }

        @media (prefers-reduced-motion: reduce) {
            .pf-pack-body, .pf-pack-content, .pf-caret, .pf-pack-label {
                transition: none;
            }
        }

        .pf-pack-table .pf-fixed-line td {
            background: #f3f6f8 !important;
        }

        .pf-pack-table tfoot tr.pf-sub td {
            font-weight: 500;
            background: #f8fafb;
            color: #444;
        }

        .pf-muted {
            font-weight: 400;
            font-size: 11px;
            color: #777;
        }

        .pf-fixed-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 8px;
            margin-top: 8px;
        }

        .pf-summary {
            display: flex;
            justify-content: flex-end;
            gap: 18px;
            margin-top: 8px;
            font-size: 12px;
            font-weight: 600;
            color: var(--pf-theme);
        }

        .pf-add-pack {
            display: flex;
            column-gap: 8px;
            align-items: center;
            margin-top: 8px;
        }

            .pf-add-pack input[type=text] {
                width: 200px;
            }

        .pf-hint {
            font-size: 11px;
            color: #666;
            margin: 6px 0 0;
        }

        .pf-actions {
            text-align: center;
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            .pf-head-grid, .pf-fixed-grid {
                grid-template-columns: 1fr;
            }

            .pf-pack-label {
                grid-template-columns: 1fr auto;
                padding-right: 150px;
                gap: 8px;
            }
        }
    </style>

    <div class="rm-module">
        <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
        <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
        <script type="text/javascript" src="Scripts/ValidateFormulationMstr.js?time=<%= DateTime.Now.ToString("yyyy.MM.dd-HH.mm.ss.fff") %>"></script>
        <script type="text/javascript">
            /* ---------- product / raw material autocomplete (same as pre-redesign page) ---------- */
            function setProductSearchState(isLocked) {
                var txtProduct = document.getElementById('txtProductSearch');
                var btnReset = document.getElementById('btnResetProduct');
                if (btnReset) { btnReset.disabled = !!isLocked; }
                if (txtProduct && isLocked) { txtProduct.setAttribute('readonly', 'readonly'); }
            }

            function onProductSelected(sender, e) {
                var value = e.get_value();
                var text = e.get_text();
                var values = value.split('|');            // productCode|sku_code
                document.getElementById('<%=hdnProductCode.ClientID%>').value = values[0];
                document.getElementById('<%=txtProductSearch.ClientID%>').value = text;
                document.getElementById('<%=hdnProductName.ClientID%>').value = text;
                document.getElementById('<%=hdnSkucode.ClientID%>').value = values.length > 1 ? values[1] : '';
                setProductSearchState(true);
                if (typeof clearProductValidation === 'function') { clearProductValidation(); }
                sender.get_element().value = text;
            }

            function clearProductSelection() {
                document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
                if (typeof clearProductValidation === 'function') { clearProductValidation(); }
            }

            function resetProductField() {
                var txtProduct = document.getElementById('txtProductSearch');
                if (txtProduct) { txtProduct.value = ''; txtProduct.disabled = false; txtProduct.removeAttribute('readonly'); }
                document.getElementById('<%=hdnProductCode.ClientID%>').value = '';
                document.getElementById('<%=hdnProductName.ClientID%>').value = '';
                document.getElementById('<%=hdnSkucode.ClientID%>').value = '';
                setProductSearchState(false);
                return false;
            }

            function syncProductResetButtonState() {
                var txtProduct = document.getElementById('txtProductSearch');
                var btnReset = document.getElementById('btnResetProduct');
                if (!txtProduct || !btnReset) { return; }
                btnReset.disabled = txtProduct.disabled || txtProduct.readOnly || txtProduct.getAttribute('readonly') === 'readonly';
            }

            function onRawMaterialSelected(sender, e) {
                document.getElementById('<%=txtrawmatid.ClientID%>').value = e.get_value();
                document.getElementById('<%=txtSearchText.ClientID%>').value = e.get_text();
                sender.get_element().value = e.get_text();
                if (typeof clearRawMaterialValidation === 'function') { clearRawMaterialValidation(); }
            }

            function clearRawMaterialSelection() {
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
                if (typeof clearRawMaterialValidation === 'function') { clearRawMaterialValidation(); }
            }

            function resetRawMaterialField() {
                document.getElementById('<%=txtSearchText.ClientID%>').value = '';
                document.getElementById('<%=txtrawmatid.ClientID%>').value = '';
                if (typeof clearRawMaterialValidation === 'function') { clearRawMaterialValidation(); }
                return false;
            }

            /* ---------- numeric helpers (same rules as FormulationMatrix rate box) ---------- */
            function allowRateTwoDecimal(evt, control) {
                var charCode = evt.which ? evt.which : evt.keyCode;
                if (charCode === 8 || charCode === 9 || charCode === 13 || charCode === 37 || charCode === 39 || charCode === 46) { return true; }
                var charValue = String.fromCharCode(charCode);
                if (!/[0-9.]/.test(charValue)) { return false; }
                var value = control.value || "";
                if (charValue === ".") { return value.indexOf(".") === -1; }
                var dotIndex = value.indexOf(".");
                if (dotIndex !== -1) {
                    var decimals = value.substring(dotIndex + 1);
                    var hasSelection = control.selectionStart !== control.selectionEnd;
                    if (!hasSelection && control.selectionStart > dotIndex && decimals.length >= 2) { return false; }
                }
                return true;
            }

            function sanitizeRateTwoDecimal(control) {
                var value = (control.value || "").replace(/[^0-9.]/g, "");
                if (value.indexOf(".") !== -1) { var parts = value.split("."); value = parts[0] + "." + parts.slice(1).join(""); }
                var dotIndex = value.indexOf(".");
                if (dotIndex !== -1) { value = value.substring(0, dotIndex) + "." + value.substring(dotIndex + 1, dotIndex + 3); }
                control.value = value;
            }

            function formatRateTwoDecimal(control) {
                var value = (control.value || "").trim();
                if (value === "") { return; }
                var numValue = parseFloat(value);
                control.value = isNaN(numValue) ? "" : numValue.toFixed(2);
            }

            /* ---------- section 1 validation (wraps ValidateFormulationMstr.js) ---------- */
            function validateAddRow() {
                var txtRate = document.getElementById('txtRate');
                var rate = parseFloat((txtRate.value || '').trim());
                if (typeof clearFieldValidation === 'function') { clearFieldValidation('txtRate', 'valRate'); }
                var ok = validateAddRawMaterial();          // returns false (shows confirm) or false on error
                if (document.querySelector('#valRatio:not(:empty), #valSearchText:not(:empty), #valBrand:not(:empty), #valVendor:not(:empty), #valProduct:not(:empty)')) {
                    return false;
                }
                if (isNaN(rate) || rate <= 0) {
                    setFieldError('txtRate', 'valRate', 'Please enter a valid Price greater than 0.', true);
                    return false;
                }
                return ok;
            }

            /* ---------- section 2: live totals ---------- */
            function pfNum(el) { var v = parseFloat((el && el.value ? el.value : '').toString().replace(/[^0-9.]/g, '')); return isNaN(v) ? 0 : v; }

            function pfRecalc(el) {
                var pack = el.closest ? el.closest('.pf-pack') : null;
                if (!pack) { return; }
                var skuPrice = parseFloat(document.getElementById('hdnSkuPrice').value) || 0;
                var material = 0;
                pack.querySelectorAll('input.pf-amt').forEach(function (i) { material += pfNum(i); });
                var proc = pfNum(pack.querySelector('input.pf-proc'));
                var lab = pfNum(pack.querySelector('input.pf-lab'));
                var pct = pfNum(pack.querySelector('input.pf-mar'));
                var base = skuPrice + material + proc + lab;
                var marginAmt = Math.round(base * pct) / 100;
                var total = Math.round((base + marginAmt) * 100) / 100;
                pack.querySelectorAll('.pf-material-amt').forEach(function (s) { s.innerText = material.toFixed(2); });
                pack.querySelectorAll('.pf-margin-amt').forEach(function (s) { s.innerText = marginAmt.toFixed(2); });
                pack.querySelectorAll('.pf-pack-total').forEach(function (s) { s.innerText = 'Total \u20B9 ' + total.toFixed(2); });
                pack.querySelectorAll('.pf-total-amt').forEach(function (s) { s.innerText = total.toFixed(2); });
            }

            function pfToggle(cb, key) {
                document.getElementById('hdnOpenPack').value = cb.checked ? key : '';
            }

            function validateAddPack() {
                var txt = document.getElementById('txtPackSize');
                var val = (txt.value || '').trim();
                clearFieldValidation('txtPackSize', 'valPackSize');
                if (val === '') { setFieldError('txtPackSize', 'valPackSize', 'Please enter Pack size.', true); return false; }
                var dup = false;
                document.querySelectorAll('.pf-pack').forEach(function (p) { if ((p.getAttribute('data-name') || '').toLowerCase() === val.toLowerCase()) { dup = true; } });
                if (dup) { setFieldError('txtPackSize', 'valPackSize', 'This Pack size is already added.', true); return false; }
                return true;
            }
    <link href="includes/product-formulation.css" rel="stylesheet" />

            /* every pack must have complete lines and a margin between 0 and 100; packs are saved with the formulation */
            function validateAllPacks() {
                var ok = true, firstBad = null;
                document.querySelectorAll('.pf-pack').forEach(function (pack) {
                    pack.querySelectorAll('.field-invalid').forEach(function (e) { e.classList.remove('field-invalid'); });
                    var bad = false;
                    pack.querySelectorAll('tr.pf-line').forEach(function (tr) {
                        var name = tr.querySelector('input.pf-name'), amt = tr.querySelector('input.pf-amt');
                        var nEmpty = (name.value || '').trim() === '', aEmpty = (amt.value || '').trim() === '' || isNaN(parseFloat(amt.value));
                        if (nEmpty && aEmpty) { return; }           // blank line is ignored on save
                        if (nEmpty) { name.classList.add('field-invalid'); bad = true; }
                        if (aEmpty) { amt.classList.add('field-invalid'); bad = true; }
                    });
                    var mar = pack.querySelector('input.pf-mar');
                    if (pfNum(mar) > 100) { mar.classList.add('field-invalid'); bad = true; }
                    if (bad) { ok = false; if (!firstBad) { firstBad = pack; } }
                });
                if (!ok) {
                    var cb = firstBad.querySelector('input.pf-toggle'); if (cb) { cb.checked = true; }
                    firstBad.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    rmFailValidation('Packaging cost: please fill Cost name and Amount for every line (Margin must be 0-100 %).');
                }
                return ok;
            }

            /* canonical text of the data - must stay in sync with BuildSnapshot() in the code-behind */
            function f2(v) { var n = parseFloat((v || '').toString().replace(/[^0-9.\-]/g, '')); return (isNaN(n) ? 0 : n).toFixed(2); }
            function buildSnapshot() {
                var s = '';
                document.querySelectorAll('#gvVendorRawMat tbody tr.tlrowlight').forEach(function (tr) {
                    var code = tr.querySelector("input[id$='hdnRawMatCode']"), ratio = tr.querySelector("span[id$='lblRatio']"), rate = tr.querySelector("span[id$='lblRate']");
                    if (code) { s += code.value.trim() + '|' + f2(ratio ? ratio.innerText : '') + '|' + f2(rate ? rate.innerText : '') + ';'; }
                });
                s += '#';
                document.querySelectorAll('.pf-pack').forEach(function (pack) {
                    s += (pack.getAttribute('data-name') || '').trim() + '|' + f2(pack.querySelector('input.pf-proc').value) + '|' + f2(pack.querySelector('input.pf-lab').value) + '|' + f2(pack.querySelector('input.pf-mar').value) + '{';
                    pack.querySelectorAll('tr.pf-line').forEach(function (tr) {
                        var n = (tr.querySelector('input.pf-name').value || '').trim(), a = (tr.querySelector('input.pf-amt').value || '').trim();
                        if (n === '' && a === '') { return; }
                        s += n + '|' + f2(a) + ',';
                    });
                    s += '};';
                });
                return s;
            }

            function validateSubmitAll() {
                if (document.querySelectorAll('.pf-pack').length === 0) {
                    rmFailValidation('Packaging cost is required: add at least one pack size before submitting.');
                    return false;
                }
                if (!validateAllPacks()) { return false; }
                var snap = document.getElementById('hdnSnapshot').value;
                if (snap !== '' && snap === buildSnapshot()) {
                    rmFailValidation('No changes to save - the current version already has this formulation and packaging cost.');
                    return false;
                }
                return validateFormulationSubmit();
            }

            document.addEventListener('DOMContentLoaded', function () {
                syncProductResetButtonState();
                document.querySelectorAll('.pf-pack').forEach(function (p) { var i = p.querySelector('input.pf-proc'); if (i) { pfRecalc(i); } });
            });
        </script>

        <div class="breadcrumbs">
            <div class="leftFung">
                <a href="Home.aspx" title="Home">
                    <i class="fas fa-home"></i>
                </a>
                <div class="diveider">/</div>
                <div class="pageTitleWrap">
                    <h3 class="pageTitle">Product Formulation Master</h3>
                    <p class="pageSubTitle">Define the raw material formulation and packaging cost of a product</p>
                </div>
            </div>
            <div class="rightFung"></div>
        </div>

        <div class="card">
            <div class="pf">
                <asp:HiddenField ID="hdnId" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hdnProductCode" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnProductName" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnSkucode" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="txtrawmatid" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnSkuPrice" ClientIDMode="Static" runat="server" Value="0" />
                <asp:HiddenField ID="hdnOpenPack" ClientIDMode="Static" runat="server" />

                <!-- ================= 1. SKU formulation entry ================= -->
                <div class="pf-section">
                    <h4 class="pf-section-title">SKU formulation entry</h4>
                    <p class="pf-section-sub">Add every raw material of the SKU in one line: Brand, Vendor and SKU are fixed after the first line. Total consumption ratio must be exactly 100 %.</p>

                    <div class="pf-table-wrap">
                        <asp:GridView ID="gvVendorRawMat" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="pf-table pf-sku-table"
                            GridLines="None" ShowFooter="true" ShowHeaderWhenEmpty="true" EmptyDataText="">
                            <RowStyle CssClass="tlrowlight" />
                            <HeaderStyle CssClass="headerGrid" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate><%# Container.DataItemIndex + 1 %>
                                        <asp:HiddenField ID="hdnBrandCode" runat="server" Value='<%# Bind("brand_code") %>' />
                                        <asp:HiddenField ID="hdnProductCode" runat="server" Value='<%# Bind("product_code") %>' />
                                        <asp:HiddenField ID="hdnRawMatCode" runat="server" Value='<%# Bind("rawmat_code") %>' />
                                        <asp:HiddenField ID="hdnVendorCode" runat="server" Value='<%# Bind("vendor_code") %>' />
                                        <asp:HiddenField ID="hdnMatrixId" runat="server" Value='<%# Bind("matrix_id") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="pf-c-sn" />
                                    <ItemStyle CssClass="pf-c-sn" />
                                    <FooterStyle CssClass="pf-c-sn" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Brand *">
                                    <ItemTemplate><asp:Label ID="lblBrandName" runat="server" Text='<%# Bind("brand_name") %>'></asp:Label></ItemTemplate>
                                    <HeaderStyle CssClass="pf-c-brand" />
                                    <ItemStyle CssClass="pf-c-brand" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor *">
                                    <ItemTemplate><asp:Label ID="lblVendorName" runat="server" Text='<%# Bind("vendor_name") %>'></asp:Label></ItemTemplate>
                                    <HeaderStyle CssClass="pf-c-vendor" />
                                    <ItemStyle CssClass="pf-c-vendor" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SKU / Product *">
                                    <ItemTemplate><asp:Label ID="lblProductName" runat="server" Text='<%# Bind("product_name") %>'></asp:Label></ItemTemplate>
                                    <HeaderStyle CssClass="pf-c-sku" />
                                    <ItemStyle CssClass="pf-c-sku" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Raw Material *">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRawMatName" runat="server" Text='<%# Bind("rawmat_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>Total</FooterTemplate>
                                    <HeaderStyle CssClass="pf-c-rm" />
                                    <ItemStyle CssClass="pf-c-rm" />
                                    <FooterStyle CssClass="pf-c-rm pf-right" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Consumption Ratio (%) *">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRatio" runat="server" Text='<%# Bind("ratio") %>'></asp:Label>
                                        <asp:Label ID="lblUnit" runat="server" Text='<%# Bind("unit") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblRatioTotal" runat="server" ClientIDMode="Static"></asp:Label>
                                        <br /><asp:Label ID="lblRatioStatus" runat="server" ClientIDMode="Static" Text="Within 100%" Style="font-size: 11px;"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="pf-c-ratio pf-center" />
                                    <ItemStyle CssClass="pf-c-ratio pf-center" />
                                    <FooterStyle CssClass="pf-c-ratio pf-center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Price (&#8377;) *">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRate" runat="server" Text='<%# Bind("rate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        SKU price<br />&#8377;
                                        <asp:Label ID="lblSkuPrice" runat="server" ClientIDMode="Static" Text="0.00"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="pf-c-price pf-right" />
                                    <ItemStyle CssClass="pf-c-price pf-right" />
                                    <FooterStyle CssClass="pf-c-price pf-right" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDeleteRow" runat="server" CommandName="DeleteRow" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false"
                                            CssClass="pf-remove" ToolTip="Remove" OnClientClick="return rmConfirmAction(this, 'delete');">&times;</asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="pf-c-act pf-center" />
                                    <ItemStyle CssClass="pf-c-act pf-center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                        <%-- entry line - same column widths as the grid above --%>
                        <table class="pf-table pf-sku-table" style="margin-top: -1px; border-top-left-radius: 0; border-top-right-radius: 0;">
                            <tbody>
                                <tr class="pf-entry-row">
                                    <td class="pf-c-sn pf-center"><i class="fas fa-plus"></i></td>
                                    <td class="pf-c-brand">
                                        <asp:DropDownList ID="ddlBrand" ClientIDMode="Static" CssClass="form-control select2" TabIndex="1" runat="server"
                                            onchange="if(typeof clearBrandValidation==='function')clearBrandValidation();">
                                        </asp:DropDownList>
                                        <asp:Label ID="valBrand" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-vendor">
                                        <asp:DropDownList ID="ddlvendor" ClientIDMode="Static" CssClass="form-control select2" TabIndex="2" runat="server"
                                            onchange="if(typeof clearVendorValidation==='function')clearVendorValidation();">
                                        </asp:DropDownList>
                                        <asp:Label ID="valVendor" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-sku">
                                        <div class="pf-input-group">
                                            <asp:TextBox ID="txtProductSearch" ClientIDMode="Static" CssClass="form-control" TabIndex="3" runat="server" AutoComplete="Off"
                                                Placeholder="Type 3+ letters" onkeyup="clearProductSelection();"></asp:TextBox>
                                            <button type="button" id="btnResetProduct" class="pf-btn" onclick="return resetProductField();" title="Reset Product"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                        <asp:AutoCompleteExtender ID="aceProductSearch" runat="server" TargetControlID="txtProductSearch" ServiceMethod="ProductSearch" CompletionInterval="200" EnableCaching="false" CompletionSetCount="20" FirstRowSelected="true" OnClientItemSelected="onProductSelected"
                                            CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem" CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                        </asp:AutoCompleteExtender>
                                        <asp:Label ID="valProduct" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-rm">
                                        <div class="pf-input-group">
                                            <asp:TextBox ID="txtSearchText" ClientIDMode="Static" CssClass="form-control" runat="server" AutoComplete="Off" onkeyup="clearRawMaterialSelection();"
                                                Placeholder="Type 3+ letters"></asp:TextBox>
                                            <button type="button" class="pf-btn" onclick="return resetRawMaterialField();" title="Reset Raw Material"><i class="fas fa-sync-alt fa-xs"></i></button>
                                        </div>
                                        <asp:AutoCompleteExtender ID="aceRawMaterialSearch" runat="server" TargetControlID="txtSearchText" ServiceMethod="RawMaterialSearch" CompletionInterval="200"
                                            EnableCaching="false" CompletionSetCount="20" FirstRowSelected="true" OnClientItemSelected="onRawMaterialSelected"
                                            CompletionListCssClass="vmsAutoComplete" CompletionListItemCssClass="vmsAutoCompleteItem" CompletionListHighlightedItemCssClass="vmsAutoCompleteItemHighlight">
                                        </asp:AutoCompleteExtender>
                                        <asp:Label ID="valSearchText" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-ratio">
                                        <asp:TextBox ID="txtRatio" ClientIDMode="Static" CssClass="form-control pf-num" runat="server" AutoComplete="Off" Placeholder="0.00"
                                            onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this); if(typeof clearRatioValidation==='function')clearRatioValidation();"></asp:TextBox>
                                        <asp:Label ID="valRatio" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-price">
                                        <asp:TextBox ID="txtRate" ClientIDMode="Static" CssClass="form-control pf-num" runat="server" AutoComplete="Off" Placeholder="0.00"
                                            onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this);" onblur="formatRateTwoDecimal(this);"></asp:TextBox>
                                        <asp:Label ID="valRate" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </td>
                                    <td class="pf-c-act pf-center">
                                        <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="pf-btn pf-btn-primary" ClientIDMode="Static" OnClick="btnAdd_Click" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <asp:HiddenField ID="hdnSnapshot" ClientIDMode="Static" runat="server" />
                    <div class="pf-head-grid" style="margin-top: 8px;">
                        <div>
                            <label class="pf-label">Version</label>
                            <div style="height: 26px; line-height: 26px; font-weight: 600; color: var(--pf-theme);"><asp:Label ID="lblVersionInfo" runat="server" Text="New (version 1 on submit)"></asp:Label></div>
                        </div>
                        <div style="grid-column: span 2;">
                            <label class="pf-label">Remarks / reason for change</label>
                            <asp:TextBox ID="txtRemarks" runat="server" MaxLength="500" AutoComplete="Off" Placeholder="Optional - stored with this version"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Label ID="valGrid" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                    <asp:Label ID="lblErrorMessage" ClientIDMode="Static" CssClass="errormsg" runat="server" Style="font-size: 11px; font-weight: bold;" Text=""></asp:Label>

                    <div class="pf-actions">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="pf-btn pf-btn-save" ClientIDMode="Static" Visible="false" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Back" CssClass="pf-btn" OnClick="btnCancel_Click1" />
                    </div>
                </div>

                <!-- ================= 2. Packaging cost (per pack size) ================= -->
                <div class="pf-section">
                    <h4 class="pf-section-title">Packaging cost</h4>
                    <p class="pf-section-sub">
                        Per pack size: packaging material lines + Processing fee + Labour charge. Margin % is applied on
                        (SKU price &#8377; <asp:Label ID="lblSkuPriceInfo" runat="server" Text="0.00"></asp:Label> + material + processing + labour) and added to that pack's total.
                        The SKU formulation and all packs are saved together with the Submit button above.
                    </p>

                <asp:Panel ID="pnlPackaging" runat="server">
                    <asp:Repeater ID="rptPack" runat="server" OnItemDataBound="rptPack_ItemDataBound" OnItemCommand="rptPack_ItemCommand">
                        <ItemTemplate>
                            <div class="pf-pack" data-name='<%# Eval("pack_size") %>'>
                                <asp:HiddenField ID="hdnPackKey" runat="server" Value='<%# Eval("pack_key") %>' />
                                <asp:HiddenField ID="hdnPchId" runat="server" Value='<%# Eval("pch_id") %>' />
                                <input type="checkbox" class="pf-toggle" id='pfPack<%# Eval("pack_key") %>' onchange='pfToggle(this, "<%# Eval("pack_key") %>")' <%# If(IsPackOpen(Eval("pack_key")), "checked='checked'", "") %> />
                                <div class="pf-pack-head">
                                    <label class="pf-pack-label" for='pfPack<%# Eval("pack_key") %>'>
                                        <span class="pf-pack-name"><span class="pf-caret"></span><%# Eval("pack_size") %> packaging</span>
                                        <span class="pf-pack-total">Total &#8377; 0.00</span>
                                        <span></span>
                                    </label>
                                    <div class="pf-pack-actions">
                                        <asp:LinkButton ID="btnRemovePack" runat="server" CssClass="pf-remove" CommandName="RemovePack" CommandArgument='<%# Eval("pack_key") %>'
                                            ToolTip="Remove pack" OnClientClick="return rmConfirmAction(this, 'delete');">&times;</asp:LinkButton>
                                    </div>
                                </div>
                                <div class="pf-pack-body">
                                    <div class="pf-pack-inner">
                                        <div class="pf-pack-content">
                                            <div class="pf-table-wrap">
                                                <table class="pf-table pf-pack-table">
                                                    <thead>
                                                        <tr>
                                                            <th class="pf-col-sn">S.No</th>
                                                            <th>Cost name</th>
                                                            <th class="pf-col-amt pf-right">Amount (&#8377;)</th>
                                                            <th class="pf-col-act">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <asp:Repeater ID="rptLines" runat="server" OnItemCommand="rptLines_ItemCommand">
                                                            <ItemTemplate>
                                                                <tr class="pf-line">
                                                                    <td class="pf-col-sn"><%# Container.ItemIndex + 1 %>
                                                                        <asp:HiddenField ID="hdnLineKey" runat="server" Value='<%# Eval("line_key") %>' />
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtCostName" runat="server" CssClass="pf-name" Text='<%# Eval("cost_name") %>' MaxLength="100" Placeholder="e.g. Cap, Bottle, Label" AutoComplete="Off"></asp:TextBox>
                                                                    </td>
                                                                    <td class="pf-col-amt">
                                                                        <asp:TextBox ID="txtAmount" runat="server" CssClass="pf-num pf-amt" Text='<%# Eval("amount") %>' Placeholder="0.00" AutoComplete="Off"
                                                                            onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this); pfRecalc(this);" onblur="formatRateTwoDecimal(this); pfRecalc(this);"></asp:TextBox>
                                                                    </td>
                                                                    <td class="pf-col-act">
                                                                        <asp:LinkButton ID="btnRemoveLine" runat="server" CssClass="pf-remove" CommandName="RemoveLine" CommandArgument='<%# Eval("line_key") %>' ToolTip="Remove">&times;</asp:LinkButton>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                        <%-- fixed lines of every pack: processing fee, labour charge, margin % --%>
                                                        <tr class="pf-fixed-line">
                                                            <td class="pf-col-sn"><i class="fas fa-cog" style="color: #888;"></i></td>
                                                            <td>Processing fee</td>
                                                            <td class="pf-col-amt">
                                                                <asp:TextBox ID="txtProcessing" runat="server" CssClass="pf-num pf-proc" Text='<%# Eval("processing_fee") %>' Placeholder="0.00" AutoComplete="Off"
                                                                    onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this); pfRecalc(this);" onblur="formatRateTwoDecimal(this); pfRecalc(this);"></asp:TextBox>
                                                            </td>
                                                            <td class="pf-col-act"></td>
                                                        </tr>
                                                        <tr class="pf-fixed-line">
                                                            <td class="pf-col-sn"><i class="fas fa-user-cog" style="color: #888;"></i></td>
                                                            <td>Labour charge</td>
                                                            <td class="pf-col-amt">
                                                                <asp:TextBox ID="txtLabour" runat="server" CssClass="pf-num pf-lab" Text='<%# Eval("labour_charge") %>' Placeholder="0.00" AutoComplete="Off"
                                                                    onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this); pfRecalc(this);" onblur="formatRateTwoDecimal(this); pfRecalc(this);"></asp:TextBox>
                                                            </td>
                                                            <td class="pf-col-act"></td>
                                                        </tr>
                                                        <tr class="pf-fixed-line">
                                                            <td class="pf-col-sn"><i class="fas fa-percent" style="color: #888;"></i></td>
                                                            <td>Margin (%) <span class="pf-muted">on SKU price &#8377; <%# SkuPriceText %> + material + processing + labour</span></td>
                                                            <td class="pf-col-amt">
                                                                <asp:TextBox ID="txtMarginPct" runat="server" CssClass="pf-num pf-mar" Text='<%# Eval("margin_pct") %>' Placeholder="0.00 %" AutoComplete="Off"
                                                                    onkeypress="return allowRateTwoDecimal(event, this);" oninput="sanitizeRateTwoDecimal(this); pfRecalc(this);" onblur="formatRateTwoDecimal(this); pfRecalc(this);"></asp:TextBox>
                                                            </td>
                                                            <td class="pf-col-act"></td>
                                                        </tr>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr class="pf-sub">
                                                            <td colspan="2" class="pf-right">SKU price</td>
                                                            <td class="pf-right">&#8377; <%# SkuPriceText %></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr class="pf-sub">
                                                            <td colspan="2" class="pf-right">Packaging material</td>
                                                            <td class="pf-right">&#8377; <span class="pf-material-amt">0.00</span></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr class="pf-sub">
                                                            <td colspan="2" class="pf-right">Margin amount</td>
                                                            <td class="pf-right">&#8377; <span class="pf-margin-amt">0.00</span></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="pf-right">Total</td>
                                                            <td class="pf-right">&#8377; <span class="pf-total-amt">0.00</span></td>
                                                            <td></td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                            <div style="text-align: center; margin-top: 6px;">
                                                <asp:LinkButton ID="btnAddLine" runat="server" CssClass="pf-btn" CommandName="AddLine" CommandArgument='<%# Eval("pack_key") %>' Text="+ Add cost line"></asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="pf-add-pack">
                        <div>
                            <asp:TextBox ID="txtPackSize" runat="server" ClientIDMode="Static" Placeholder="Pack size, e.g. 1 ltr" MaxLength="50" AutoComplete="Off"
                                oninput="if(typeof clearFieldValidation==='function')clearFieldValidation('txtPackSize','valPackSize');"></asp:TextBox>
                            <asp:Label ID="valPackSize" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>
                        <asp:Button ID="btnAddPack" runat="server" Text="+ Add pack size" CssClass="pf-btn pf-btn-primary" ClientIDMode="Static" OnClientClick="return validateAddPack();" OnClick="btnAddPack_Click" />
                    </div>
                    <p class="pf-hint">Pack size is free text for now; it will become a dropdown once the pack-size master is available.</p>
                    <asp:Label ID="valPack" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
