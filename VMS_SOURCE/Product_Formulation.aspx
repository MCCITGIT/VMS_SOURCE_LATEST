<%--<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Formulation.aspx.vb"%>--%>

<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" %>

<%--<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            font-size: 14px;
        }

            .pf *, .pf *::before, .pf *::after {
                box-sizing: border-box;
            }

        .pf-section {
            background: #fafdff;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 10px;
            margin-bottom: 16px;
        }

        .pf-section-title {
            font-weight: 600;
            font-size: 14px;
            margin: 0 0 12px;
        }

        /* ---------- Inputs / buttons ---------- */
        .pf input[type=text], .pf select {
            width: 100%;
            padding: 6px 8px;
            border: 1px solid #c4c4c4;
            border-radius: 4px;
            font-size: 13px;
            background: #fff;
            color: #222;
        }

            .pf input[type=text]:focus, .pf select:focus {
                outline: none;
                border-color: var(--pf-theme);
                box-shadow: 0 0 0 2px rgba(55, 89, 115, .18);
            }

        .pf .pf-num {
            text-align: right;
        }

        .pf-btn {
            height: 30px;
            padding: 0 14px;
            border: 1px solid #c4c4c4;
            border-radius: 6px;
            background: #fff;
            font-size: 13px;
            cursor: pointer;
            white-space: nowrap;
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
            border-radius: 8px;
            overflow: hidden;
            margin: 0;
        }

            .pf-table th, .pf-table td {
                padding: 7px 8px;
                border-bottom: 1px solid var(--pf-border);
                vertical-align: middle;
                text-align: left;
            }

            .pf-table thead th {
                background: var(--pf-theme);
                color: #fff;
                font-size: 12px;
                font-weight: 600;
                white-space: nowrap;
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
                width: 50px;
                text-align: center;
            }

            .pf-table .pf-col-amt {
                width: 160px;
            }

            .pf-table .pf-col-act {
                width: 70px;
                text-align: center;
            }

            .pf-table .pf-col-btn {
                width: 90px;
                text-align: center;
            }

            .pf-table .pf-right {
                text-align: right;
            }

        .pf-sku-table {
            min-width: 760px;
        }

        .pf-remove {
            border: none;
            background: none;
            color: #ffffff;
            font-size: 18px;
            background: #db3625;
            cursor: pointer;
            line-height: 1.1;
            padding: 2px 6px;
            border-radius: 30px;
        }

            .pf-remove:hover {
                background: #eb4533;
            }

        /* ---------- Packaging accordion (pure CSS, checkbox based) ---------- */
        .pf-pack {
            border: 1px solid var(--pf-border);
            border-radius: 8px;
            margin-bottom: 10px;
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
            grid-template-columns: 1fr 1fr 90px;
            align-items: center;
            padding: 10px;
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
            font-size: 13px;
        }

        .pf-pack-total {
            font-weight: 700;
            font-size: 13px;
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
        /* Save sits outside the label so clicking it doesn't toggle the accordion */
        .pf-pack-head .pf-btn-save {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            height: 25px;
        }

        /* Smooth slide: grid rows animate from 0fr (closed) to 1fr (open) */
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
            padding: 10px;
            transform: translateY(-6px);
            transition: transform .35s ease;
        }

        .pf-add-line {
            margin-top: 8px;
        }

        /* Open state */
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

        /* ---------- Footer ---------- */

        .pf-add-pack select {
            width: 200px;
        }

        .pf-hint {
            font-size: 11px;
            color: #666;
            margin: 10px 0 0;
        }

        @media (max-width: 768px) {
            .pf-pack-label {
                grid-template-columns: 1fr auto;
                padding-right: 90px;
                gap: 8px;
            }

            .pf-table .pf-col-amt {
                width: 110px;
            }
        }

        /* =================== Compact mode =================== */
        .pf {
            font-size: 13px;
        }

        .pf-section {
            padding: 8px 10px;
            margin-bottom: 10px;
            border-radius: 8px;
        }

        .pf-section-title {
            font-size: 13px;
            margin: 0 0 6px;
        }

        /* Inputs & buttons */
        .pf input[type=text], .pf select {
            height: 26px;
            padding: 2px 6px;
            font-size: 12px;
        }

        .pf-btn {
            height: 26px;
            padding: 0 10px;
            font-size: 12px;
            border-radius: 4px;
        }

        /* Tables */
        .pf-table {
            border-radius: 6px;
        }

            .pf-table th, .pf-table td {
                padding: 3px 6px;
            }

            .pf-table thead th {
                padding: 5px 6px;
                font-size: 11.5px;
            }

            .pf-table .pf-col-sn {
                width: 40px;
            }

            .pf-table .pf-col-amt {
                width: 120px;
            }

            .pf-table .pf-col-act {
                width: 55px;
            }

            .pf-table .pf-col-btn {
                width: 70px;
            }

        .pf-sku-table {
            min-width: 680px;
        }

        /* Remove (×) button – small round icon */
        .pf-remove {
            width: 20px;
            height: 20px;
            padding: 0;
            font-size: 14px;
            line-height: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        /* Accordion */
        .pf-pack {
            margin-bottom: 6px;
            border-radius: 6px;
        }

        .pf-pack-label {
            padding: 5px 10px;
        }

        .pf-pack-name, .pf-pack-total {
            font-size: 12.5px;
        }

        .pf-pack-head .pf-btn-save {
            height: 22px;
            padding: 0 10px;
            font-size: 11.5px;
            right: 2px;
        }

        .pf-pack-content {
            padding: 6px;
        }

        .pf .pf-add-line {
            margin-top: 6px !important;
            height: 24px;
        }

        /* Add pack row */
        .pf-add-pack select {
            width: 170px;
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home">
                <i class="fas fa-home"></i>
            </a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Product Formulation Master</h3>
                <p class="pageSubTitle">Define the raw material formulation of a product</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="pf">
            <!-- ================= 1. SKU formulation entry ================= -->
            <div class="pf-section">
                <h4 class="pf-section-title">SKU formulation entry</h4>
                <div class="pf-table-wrap">
                    <table class="pf-table pf-sku-table">
                        <thead>
                            <tr>
                                <th>Brand *</th>
                                <th>Vendor *</th>
                                <th>SKU / product *</th>
                                <th>Consumption ratio *</th>
                                <th>Price *</th>
                                <th class="pf-col-btn">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Happy Wall Putty</td>
                                <td>ABC Vendor</td>
                                <td>WeatherCoat </td>
                                <td>40</td>
                                <td>85 </td>
                                <td class="pf-col-btn">
                                    <button type="button" class="pf-remove" title="Remove">&times;</button>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="pfBrand">
                                        <option value="">-- Select --</option>
                                        <option selected="selected">Happy Wall Putty</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="pfVendor">
                                        <option value="">-- Select --</option>
                                        <option selected="selected">ABC Vendor</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" id="pfSku" value="WeatherCoat" /></td>
                                <td>
                                    <input type="text" id="pfRatio" class="pf-num" value="40.00" /></td>
                                <td>
                                    <input type="text" id="pfPrice" class="pf-num" value="85.50" /></td>
                                <td class="pf-col-btn">
                                    <button type="button" class="pf-btn pf-btn-primary">Add</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ================= 2. Packaging cost (tree) ================= -->
            <div class="pf-section">
                <h4 class="pf-section-title">Packaging cost (tree)</h4>

                <!-- ----- 1 ltr packaging ----- -->
                <div class="pf-pack">
                    <input type="checkbox" class="pf-toggle" id="pfPack1" />
                    <div class="pf-pack-head">
                        <label class="pf-pack-label" for="pfPack1">
                            <span class="pf-pack-name"><span class="pf-caret"></span>1 ltr packaging</span>
                            <span class="pf-pack-total">Total ₹ 1.80</span>
                            <span></span>
                        </label>
                        <button type="button" class="pf-btn pf-btn-save">Save</button>
                    </div>
                    <div class="pf-pack-body">
                        <div class="pf-pack-inner">
                            <div class="pf-pack-content">
                                <div class="pf-table-wrap">
                                    <table class="pf-table">
                                        <thead>
                                            <tr>
                                                <th class="pf-col-sn">S.No</th>
                                                <th>Cost name</th>
                                                <th>Cost Select</th>
                                                <th class="pf-col-amt pf-right">Amount (₹)</th>
                                                <th class="pf-col-amt pf-right">Amount (₹)</th>
                                                <th class="pf-col-act">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="pf-col-sn">1</td>
                                                <td>
                                                    <input type="text" value="Cap price" /></td>
                                                <td>
                                                    <select id="pfVendor1">
                                                        <option value="">-- Select --</option>
                                                        <option selected="selected">ABC Vendor</option>
                                                    </select>
                                                </td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.50" /></td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.50" /></td>
                                                <td class="pf-col-act">
                                                    <button type="button" class="pf-remove" title="Remove">&times;</button></td>
                                            </tr>
                                            <tr>
                                                <td class="pf-col-sn">2</td>
                                                <td>
                                                    <input type="text" value="Bottle price" /></td>
                                                <td>
                                                    <select id="pfVendor2">
                                                        <option value="">-- Select --</option>
                                                        <option selected="selected">ABC Vendor</option>
                                                    </select>
                                                </td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="1.00" /></td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="1.00" /></td>
                                                <td class="pf-col-act">
                                                    <button type="button" class="pf-remove" title="Remove">&times;</button></td>
                                            </tr>
                                            <tr>
                                                <td class="pf-col-sn">3</td>
                                                <td>
                                                    <input type="text" value="Label cost" /></td>
                                                <td>
                                                    <select id="">
                                                        <option value="">-- Select --</option>
                                                        <option selected="selected">ABC Vendor</option>
                                                    </select>
                                                </td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.30" /></td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.30" /></td>
                                                <td class="pf-col-act">
                                                    <button type="button" class="pf-remove" title="Remove">&times;</button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <button type="button" class="pf-btn pf-add-line" style="margin: 10px auto 0; width: fit-content; display: block;">+ Add cost line</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ----- 2 ltr packaging ----- -->
                <div class="pf-pack">
                    <input type="checkbox" class="pf-toggle" id="pfPack2" />
                    <div class="pf-pack-head">
                        <label class="pf-pack-label" for="pfPack2">
                            <span class="pf-pack-name"><span class="pf-caret"></span>2 ltr packaging</span>
                            <span class="pf-pack-total">Total ₹ 2.30</span>
                            <span></span>
                        </label>
                        <button type="button" class="pf-btn pf-btn-save">Save</button>
                    </div>
                    <div class="pf-pack-body">
                        <div class="pf-pack-inner">
                            <div class="pf-pack-content">
                                <div class="pf-table-wrap">
                                    <table class="pf-table">
                                        <thead>
                                            <tr>
                                                <th class="pf-col-sn">S.No</th>
                                                <th>Cost name</th>
                                                <th>Cost Select</th>
                                                <th class="pf-col-amt pf-right">Amount (₹)</th>
                                                <th class="pf-col-amt pf-right">Amount (₹)</th>
                                                <th class="pf-col-act">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="pf-col-sn">1</td>
                                                <td>
                                                    <input type="text" value="Cap price" /></td>
                                                <td>
                                                    <select id="">
                                                        <option value="">-- Select --</option>
                                                        <option selected="selected">ABC Vendor</option>
                                                    </select>
                                                </td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.50" /></td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="0.50" /></td>
                                                <td class="pf-col-act">
                                                    <button type="button" class="pf-remove" title="Remove">&times;</button></td>
                                            </tr>
                                            <tr>
                                                <td class="pf-col-sn">2</td>
                                                <td>
                                                    <input type="text" value="Bottle price" /></td>
                                                <td>
                                                    <select id="">
                                                        <option value="">-- Select --</option>
                                                        <option selected="selected">ABC Vendor</option>
                                                    </select>
                                                </td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="1.80" /></td>
                                                <td class="pf-col-amt">
                                                    <input type="text" class="pf-num" value="1.80" /></td>
                                                <td class="pf-col-act">
                                                    <button type="button" class="pf-remove" title="Remove">&times;</button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <button type="button" class="pf-btn pf-add-line" style="margin: 10px auto 0; width: fit-content; display: block;">
                                    + Add cost line</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ----- Add pack size (dropdown) ----- -->
                <div style="display: flex; column-gap: 10px;">
                    <div class="pf-add-pack">
                        <select id="pfPackSize">
                            <option value="">+ Add pack size</option>
                            <option value="500ml">500 ml packaging</option>
                            <option value="1ltr">1 ltr packaging</option>
                            <option value="2ltr">2 ltr packaging</option>
                            <option value="4ltr">4 ltr packaging</option>
                            <option value="10ltr">10 ltr packaging</option>
                            <option value="20ltr">20 ltr packaging</option>
                        </select>
                    </div>
                    <asp:Button Text="Add Pack" runat="server" class="btn btn-primary btn-sm" Style="font-size: 11px; padding: 2px 10px; height: 25px;" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
