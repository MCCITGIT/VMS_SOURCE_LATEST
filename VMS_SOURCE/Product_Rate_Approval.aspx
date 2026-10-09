<%--<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Formulation.aspx.vb"%>--%>

<%@ Page Title="Product_Rate_Approval" Language="VB" MasterPageFile="~/MasterPage.master" %>

<%--<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/product-formulation.css" rel="stylesheet" />

    <style type="text/css">
        /* ---------- Product Raid Approval (scoped to .pra) ---------- */
        .pra {
            --pra-theme: #375973;
            --pra-theme-dark: #2b4659;
            --pra-theme-light: #eaf0f4;
            --pra-green: #28a745;
            --pra-green-dark: #218838;
            --pra-border: #d9dee3;
            color: #222;
            font-size: 13px;
        }
        .pra *, .pra *::before, .pra *::after { box-sizing: border-box; }

        /* One block per SKU */
        /*.pra-sku {
            background: #fafdff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 8px 10px;
            margin-bottom: 10px;
        }*/
        .pra-sku-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            flex-wrap: wrap;
            background: var(--pra-theme-light);
            border-left: 4px solid var(--pra-theme);
            border-radius: 4px;
            padding: 5px 10px;
            margin-bottom: 6px;
        }
        .pra-sku-title { font-weight: 700; color: var(--pra-theme); font-size: 13px; }
        .pra-sku-meta { font-size: 12px; color: #555; }
        .pra-sku-meta b { color: #222; font-weight: 600; }

        .pra-btn {
            height: 24px;
            padding: 0 12px;
            border: 1px solid var(--pra-green);
            border-radius: 4px;
            background: var(--pra-green);
            color: #fff;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }
        .pra-btn:hover { background: var(--pra-green-dark); border-color: var(--pra-green-dark); }

        /* ---------- Scroll container (horizontal scroll on small screens) ---------- */
        .pra-table-wrap {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border: 1px solid var(--pra-border);
            border-radius: 6px;
            background: #fff;
        }
        .pra-table-wrap::-webkit-scrollbar { height: 8px; }
        .pra-table-wrap::-webkit-scrollbar-thumb { background: #b9c6d0; border-radius: 4px; }
        .pra-table-wrap::-webkit-scrollbar-track { background: #f1f4f6; }

        /* ---------- Table ---------- */
        .pra-table {
            width: 100%;
            min-width: 900px;          /* below this width the wrapper scrolls */
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
        }
        .pra-table th, .pra-table td {
            padding: 4px 8px;
            border-bottom: 1px solid var(--pra-border);
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
            min-width: 70px;
            background: #fff;
        }
        .pra-table thead th {
            background: var(--pra-theme);
            color: #fff;
            font-size: 11.5px;
            font-weight: 600;
        }
        .pra-table thead tr:first-child th { border-bottom: 1px solid rgba(255, 255, 255, .25); }

        /* Item column stays fixed while the rounds scroll */
        .pra-table .pra-item {
            position: sticky;
            left: 0;
            z-index: 1;
            text-align: left;
            min-width: 140px;
            font-weight: 600;
            box-shadow: 2px 0 3px -1px rgba(0, 0, 0, .12);
        }
        .pra-table thead .pra-item { z-index: 2; background: var(--pra-theme); }

        /* Divider between rounds */
        .pra-table .pra-round-start { border-left: 2px solid var(--pra-border); }
        .pra-table thead .pra-round-start { border-left: 2px solid rgba(255, 255, 255, .45); }

        /* Group rows: Raw material / Packaging */
        .pra-table .pra-group td {
            background: var(--pra-theme-light);
            color: var(--pra-theme);
            font-weight: 700;
            font-size: 11.5px;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: .3px;
        }
        .pra-group-label { position: sticky; left: 8px; }   /* label stays visible while scrolling */

        .pra-table tbody tr:not(.pra-group):hover td { background: #f3f7fa; }
        .pra-table tbody tr:last-child td { border-bottom: none; }

        /* Cell states */
        .pra-table .pra-ho { font-weight: 600; color: var(--pra-theme); }
        .pra-table .pra-changed { color: #c0392b; font-weight: 700; }   /* HO revised vendor value */
        .pra-table .pra-empty { color: #aaa; }

        .pra-legend { font-size: 11px; color: #666; margin: 6px 0 0; }
        .pra-legend span { color: #c0392b; font-weight: 700; }

        @media (max-width: 768px) {
            .pra-table .pra-item { min-width: 100px; }
            .pra-table th, .pra-table td { padding: 4px 6px; min-width: 60px; }
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home">
                <i class="fas fa-home"></i>
            </a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Product Raid Approval</h3>
                <p class="pageSubTitle">Define the raw material formulation of a product</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="pra">

            <!-- ================= SKU block (repeat for every SKU) ================= -->
            <div class="pra-sku">
                <div class="pra-sku-head">
                    <div>
                        <span class="pra-sku-title">WeatherCoat</span>
                        <span class="pra-sku-meta">&nbsp;|&nbsp; Brand: <b>Happy Wall Putty</b> &nbsp;|&nbsp; Vendor: <b>ABC Vendor</b></span>
                    </div>
                    <button type="button" class="pra-btn">Approve</button>
                </div>

                <div class="pra-table-wrap">
                    <table class="pra-table">
                        <thead>
                            <tr>
                                <th rowspan="2" class="pra-item">Item</th>
                                <th colspan="2" class="pra-round-start">Round 1</th>
                                <th colspan="2" class="pra-round-start">Round 2</th>
                                <th colspan="2" class="pra-round-start">Round 3</th>
                                <th colspan="2" class="pra-round-start">Round 4</th>
                            </tr>
                            <tr>
                                <th class="pra-round-start">Vendor</th>
                                <th>HO</th>
                                <th class="pra-round-start">Vendor</th>
                                <th>HO</th>
                                <th class="pra-round-start">Vendor</th>
                                <th>HO</th>
                                <th class="pra-round-start">Vendor</th>
                                <th>HO</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Raw material -->
                            <tr class="pra-group"><td colspan="9"><span class="pra-group-label">Raw material</span></td></tr>
                            <tr>
                                <td class="pra-item">RM1</td>
                                <td class="pra-round-start">50</td>
                                <td class="pra-ho pra-changed">48</td>
                                <td class="pra-round-start">49</td>
                                <td class="pra-ho">49</td>
                                <td class="pra-round-start">49</td>
                                <td class="pra-ho">49</td>
                                <td class="pra-round-start">49</td>
                                <td class="pra-ho">49</td>
                            </tr>
                            <tr>
                                <td class="pra-item">RM2</td>
                                <td class="pra-round-start">50</td>
                                <td class="pra-ho">50</td>
                                <td class="pra-round-start">50</td>
                                <td class="pra-ho pra-empty">—</td>
                                <td class="pra-round-start">50</td>
                                <td class="pra-ho pra-changed">48</td>
                                <td class="pra-round-start">48</td>
                                <td class="pra-ho">48</td>
                            </tr>
                            <tr>
                                <td class="pra-item">RM3</td>
                                <td class="pra-round-start pra-empty">—</td>
                                <td class="pra-ho pra-empty">—</td>
                                <td class="pra-round-start pra-empty">—</td>
                                <td class="pra-ho pra-changed">46</td>
                                <td class="pra-round-start">46</td>
                                <td class="pra-ho">46</td>
                                <td class="pra-round-start">46</td>
                                <td class="pra-ho">46</td>
                            </tr>

                            <!-- Packaging (pack-size wise) -->
                            <tr class="pra-group"><td colspan="9"><span class="pra-group-label">Packaging — 1 ltr</span></td></tr>
                            <tr>
                                <td class="pra-item">PK1</td>
                                <td class="pra-round-start">1</td>
                                <td class="pra-ho">1</td>
                                <td class="pra-round-start">1</td>
                                <td class="pra-ho">1</td>
                                <td class="pra-round-start">1</td>
                                <td class="pra-ho">1</td>
                                <td class="pra-round-start">1</td>
                                <td class="pra-ho">1</td>
                            </tr>
                            <tr>
                                <td class="pra-item">PK2</td>
                                <td class="pra-round-start">2</td>
                                <td class="pra-ho">2</td>
                                <td class="pra-round-start">2</td>
                                <td class="pra-ho">2</td>
                                <td class="pra-round-start">2</td>
                                <td class="pra-ho">2</td>
                                <td class="pra-round-start">2</td>
                                <td class="pra-ho">2</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <p class="pra-legend"><span>Red</span> = HO revised the vendor's value.</p>
            </div>
            <!-- ================= /SKU block ================= -->

        </div>
    </div>
</asp:Content>
