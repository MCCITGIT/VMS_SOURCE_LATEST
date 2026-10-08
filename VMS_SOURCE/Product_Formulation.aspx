<%--<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Product_Formulation.aspx.vb"%>--%>

<%@ Page Title="Product Formulation" Language="VB" MasterPageFile="~/MasterPage.master" %>

<%--<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/product-formulation.css" rel="stylesheet" />

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
