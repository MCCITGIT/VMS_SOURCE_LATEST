<%@ Page Title="Product_Rate_Approval_List" Language="VB" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/product-formulation.css" rel="stylesheet" />

    <style type="text/css">
        /* ---------- Product Raid Approval List (scoped to .pra) ---------- */
        .pra {
            --pra-theme: #375973;
            --pra-theme-dark: #2b4659;
            --pra-theme-light: #eaf0f4;
            --pra-border: #d9dee3;
            color: #222;
            font-size: 13px;
        }
        .pra *, .pra *::before, .pra *::after { box-sizing: border-box; }

        .pra-section {
            margin-bottom: 10px;
        }

        /* ---------- Filter bar ---------- */
        .pra-filter {
            display: flex;
            align-items: flex-end;
            gap: 10px;
            flex-wrap: wrap;
        }
        .pra-field { display: flex; flex-direction: column; gap: 3px; min-width: 180px; }
        .pra-field label { font-size: 11.5px; font-weight: 600; color: var(--pra-theme); margin: 0; }
        .pra select {
            height: 28px;
            padding: 2px 6px;
            border: 1px solid #c4c4c4;
            border-radius: 4px;
            font-size: 12.5px;
            background: #fff;
            color: #222;
        }
        .pra select:focus {
            outline: none;
            border-color: var(--pra-theme);
            box-shadow: 0 0 0 2px rgba(55, 89, 115, .18);
        }

        .pra-btn {
            height: 28px;
            padding: 0 14px;
            border: 1px solid var(--pra-theme);
            border-radius: 4px;
            background: var(--pra-theme);
            color: #fff;
            font-size: 12.5px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }
        .pra-btn:hover { background: var(--pra-theme-dark); border-color: var(--pra-theme-dark); }
        .pra-btn-outline { background: #fff; color: var(--pra-theme); }
        .pra-btn-outline:hover { background: var(--pra-theme-light); color: var(--pra-theme); }

        /* ---------- Table ---------- */
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

        .pra-table {
            width: 100%;
            min-width: 600px;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
        }
        .pra-table th, .pra-table td {
            padding: 6px 10px;
            border-bottom: 1px solid var(--pra-border);
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }
        .pra-table thead th {
            background: var(--pra-theme);
            color: #fff;
            font-size: 11.5px;
            font-weight: 600;
        }
        .pra-table tbody tr:nth-child(even) td { background: #f8fafb; }
        .pra-table tbody tr:hover td { background: var(--pra-theme-light); }
        .pra-table tbody tr:last-child td { border-bottom: none; }
        .pra-table .pra-col-sn { width: 55px; text-align: center; }
        .pra-table .pra-col-status { width: 140px; }
        .pra-table .pra-col-act { width: 90px; text-align: center; }
        .pra-formulation { font-weight: 600; color: var(--pra-theme); }
        .pra-sub { display: block; font-size: 11px; color: #777; font-weight: 400; }

        /* ---------- Status badges ---------- */
        .pra-badge {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            line-height: 1.6;
        }
        .pra-badge-pending     { background: #fff4e0; color: #b26a00; }
        .pra-badge-negotiation { background: #e6f0fa; color: #1f5fa8; }
        .pra-badge-approved    { background: #e3f5e8; color: #1e7b34; }
        .pra-badge-rejected    { background: #fdeaea; color: #c0392b; }

        .pra-view {
            display: inline-block;
            padding: 2px 12px;
            border: 1px solid var(--pra-theme);
            border-radius: 4px;
            color: var(--pra-theme);
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
        }
        .pra-view:hover { background: var(--pra-theme); color: #fff; text-decoration: none; }

        .pra-count { font-size: 11.5px; color: #666; margin: 6px 0 0; }

        @media (max-width: 576px) {
            .pra-field { min-width: 100%; }
            .pra-filter .pra-btn { flex: 1; }
        }
    </style>

    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home">
                <i class="fas fa-home"></i>
            </a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">Product Raid Approval List</h3>
                <p class="pageSubTitle">View formulation approvals by vendor and status</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="pra">

            <!-- ================= Filters ================= -->
            <div class="pra-section">
                <div class="pra-filter">
                    <div class="pra-field">
                        <label for="praStatus">Status</label>
                        <select id="praStatus">
                            <option value="">All status</option>
                            <option value="pending">Pending</option>
                            <option value="negotiation">In negotiation</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                    <div class="pra-field">
                        <label for="praVendor">Vendor</label>
                        <select id="praVendor">
                            <option value="">All vendors</option>
                            <option value="abc">ABC Vendor</option>
                            <option value="xyz">XYZ Traders</option>
                            <option value="shree">Shree Chemicals</option>
                        </select>
                    </div>
                    <button type="button" class="pra-btn">Search</button>
                    <button type="button" class="pra-btn pra-btn-outline">Reset</button>
                </div>
            </div>

            <!-- ================= Listing ================= -->
            <div class="pra-section">
                <div class="pra-table-wrap">
                    <table class="pra-table">
                        <thead>
                            <tr>
                                <th class="pra-col-sn">S.No</th>
                                <th>Vendor</th>
                                <th>Formulation</th>
                                <th class="pra-col-status">Status</th>
                                <th class="pra-col-act">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="pra-col-sn">1</td>
                                <td>ABC Vendor</td>
                                <td class="pra-formulation">WeatherCoat<span class="pra-sub">Happy Wall Putty</span></td>
                                <td class="pra-col-status"><span class="pra-badge pra-badge-negotiation">In negotiation</span></td>
                                <td class="pra-col-act"><a href="Product_Raid_Approval.aspx" class="pra-view">View</a></td>
                            </tr>
                            <tr>
                                <td class="pra-col-sn">2</td>
                                <td>ABC Vendor</td>
                                <td class="pra-formulation">SmoothFinish<span class="pra-sub">Happy Wall Putty</span></td>
                                <td class="pra-col-status"><span class="pra-badge pra-badge-approved">Approved</span></td>
                                <td class="pra-col-act"><a href="Product_Raid_Approval.aspx" class="pra-view">View</a></td>
                            </tr>
                            <tr>
                                <td class="pra-col-sn">3</td>
                                <td>XYZ Traders</td>
                                <td class="pra-formulation">AquaShield<span class="pra-sub">Happy Wall Putty</span></td>
                                <td class="pra-col-status"><span class="pra-badge pra-badge-pending">Pending</span></td>
                                <td class="pra-col-act"><a href="Product_Raid_Approval.aspx" class="pra-view">View</a></td>
                            </tr>
                            <tr>
                                <td class="pra-col-sn">4</td>
                                <td>Shree Chemicals</td>
                                <td class="pra-formulation">PrimeBase<span class="pra-sub">Happy Wall Putty</span></td>
                                <td class="pra-col-status"><span class="pra-badge pra-badge-rejected">Rejected</span></td>
                                <td class="pra-col-act"><a href="Product_Raid_Approval.aspx" class="pra-view">View</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <p class="pra-count">Showing 4 records</p>
            </div>

        </div>
    </div>
</asp:Content>
