<%@ Page Title="Request Details" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FGVendor_DispatchDtlsaspx.aspx.vb" Inherits="FGVendor_DispatchDtlsaspx" ResponseEncoding="utf-8" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="includes/rm-procurement.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .fg-dispatch-dtls.rm-module #lblErrorMessage {
            display: block !important;
            text-align: left;
            font-size: 13px;
            font-weight: bold;
            margin: 0 0 12px 0;
        }

        .rm-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            background: #ffffff;
            border: 1px solid #eee8de;
            border-radius: 18px;
            padding: 18px 22px;
            margin-bottom: 16px;
            box-shadow: 0 8px 22px rgba(80, 60, 30, 0.05);
        }

        .rm-page-header-left {
            display: flex;
            align-items: center;
            min-width: 0;
        }

        .rm-header-icon {
            width: 44px;
            height: 44px;
            min-width: 44px;
            margin-right: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #e8f0ff;
            border-radius: 12px;
            color: #2f6fed;
            font-size: 18px;
        }

        .rm-page-title {
            margin: 0 0 3px 0;
            color: #111827;
            font-size: 22px;
            line-height: 1.2;
            font-weight: 800;
        }

        .rm-page-subtitle {
            margin: 0;
            color: #8a93a3;
            font-size: 13px;
            font-weight: 400;
        }

        .rm-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            transition: background-color 0.2s ease, color 0.2s ease, box-shadow 0.2s ease;
        }

            .rm-status-badge:before {
                content: "";
                width: 7px;
                height: 7px;
                border-radius: 50%;
                background: currentColor;
            }

            .rm-status-badge.is-pending {
                background: #fff4e5;
                color: #d9822b;
            }

            .rm-status-badge.is-complete {
                background: #e8f8ee;
                color: #1f9d57;
            }

        .rm-meta-bar {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            background: #ffffff;
            border: 1px solid #eee8de;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 16px;
            box-shadow: 0 8px 22px rgba(80, 60, 30, 0.05);
        }

        .rm-meta-item {
            min-width: 0;
            padding: 16px 18px;
            border-right: 1px solid #f0ece4;
        }

            .rm-meta-item.is-row-end {
                border-right: 0;
            }

            .rm-meta-item.is-vendor-code,
            .rm-meta-item.is-vendor {
                border-top: 1px solid #f0ece4;
            }

            .rm-meta-item.is-vendor {
                grid-column: span 3;
                border-right: 0;
                background: #eef4ff;
            }

        .rm-meta-label {
            display: block;
            margin-bottom: 6px;
            color: #9aa3b2;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .rm-meta-value,
        .rm-meta-item .detail-value {
            color: #111827;
            font-size: 18px;
            font-weight: 800;
            line-height: 1.2;
        }

        .rm-meta-value-id {
            color: #2f6fed !important;
        }

        .rm-vendor-name {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #111827;
            font-size: 18px;
            font-weight: 800;
        }

            .rm-vendor-name i {
                color: #2f6fed;
                font-size: 14px;
            }

        .rm-two-col {
            margin-left: -8px;
            margin-right: -8px;
            margin-bottom: 8px;
        }

            .rm-two-col > [class*="col-"] {
                padding-left: 8px;
                padding-right: 8px;
            }

        .rm-card {
            background: #ffffff;
            border: 1px solid #eee8de;
            border-radius: 18px;
            box-shadow: 0 8px 22px rgba(80, 60, 30, 0.05);
            padding: 20px 22px 22px;
            margin-bottom: 16px;
            height: 100%;
            transition: box-shadow 0.22s ease, border-color 0.22s ease;
        }

        .rm-card-head {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
        }

        .rm-card-head-left {
            display: flex;
            align-items: center;
            min-width: 0;
        }

        .rm-card-icon {
            width: 36px;
            height: 36px;
            min-width: 36px;
            margin-right: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #e8f0ff;
            border-radius: 10px;
            color: #2f6fed;
            font-size: 15px;
        }

        .rm-card-title {
            margin: 0 0 2px 0;
            color: #111827;
            font-size: 16px;
            font-weight: 800;
        }

        .rm-card-subtitle {
            margin: 0;
            color: #8a93a3;
            font-size: 12px;
        }

        .rm-count-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            background: #e8f0ff;
            border-radius: 999px;
            color: #2f6fed;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-control-label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px !important;
            font-weight: 600;
        }

        .req-star {
            color: #e11d48;
            font-weight: 700;
        }

        .form-control,
        select.form-control {
            min-height: 42px;
            height: 42px;
            padding: 8px 12px;
            background: #f7f8fa;
            border: 1px solid #e4e7ec;
            border-radius: 10px;
            color: #111827;
            font-size: 14px !important;
            box-shadow: none !important;
            transition: background-color 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease, color 0.2s ease;
        }

            .form-control:focus {
                background: #ffffff;
                border-color: #8fb0ea;
                box-shadow: 0 0 0 3px rgba(47, 111, 237, 0.12) !important;
            }

        .field-hint {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 8px;
            color: #2f6fed;
            font-size: 12px;
        }

        .rm-subhead {
            margin: 6px 0 12px;
            color: #111827;
            font-size: 14px;
            font-weight: 800;
        }

        .rm-courier-block {
            margin-top: 4px;
        }

        .rm-upload-box {
            position: relative;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            background: #f7f9fc;
            border: 1px dashed #cfd8e6;
            border-radius: 12px;
            min-height: 72px;
            transition: background-color 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .rm-upload-icon {
            width: 36px;
            height: 36px;
            min-width: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 18px;
        }

        .rm-upload-title {
            margin: 0;
            color: #111827;
            font-size: 13px;
            font-weight: 700;
        }

        .rm-upload-hint {
            margin: 2px 0 0;
            color: #8a93a3;
            font-size: 11px;
        }

        .rm-upload-name {
            display: block;
            margin-top: 3px;
            color: #2f6fed;
            font-size: 11px;
            font-weight: 600;
            word-break: break-all;
        }

        .rm-choose-btn {
            margin-left: auto;
            height: 34px;
            padding: 0 14px;
            background: #ffffff;
            border: 1px solid #d7dde6;
            border-radius: 8px;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            position: relative;
            z-index: 1;
            pointer-events: none;
        }

        .rm-file-input {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
            z-index: 2;
        }

            .rm-file-input:disabled {
                pointer-events: none;
                cursor: default;
            }

        .rm-extract-btn,
        .btn-primary {
            background: #2f6fed !important;
            border-color: #2f6fed !important;
            color: #ffffff !important;
            border-radius: 10px !important;
            padding: 8px 16px !important;
            font-size: 13px !important;
            font-weight: 700 !important;
            cursor: pointer;
            transition: background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease, box-shadow 0.18s ease, transform 0.18s ease;
        }

        .rm-extract-btn {
            margin-top: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

            .btn-primary:hover,
            .btn-primary:focus,
            .rm-extract-btn:hover,
            .rm-extract-btn:focus {
                background: #1f5bd6 !important;
                border-color: #1f5bd6 !important;
                color: #ffffff !important;
                transform: translateY(-1px);
                box-shadow: 0 8px 18px rgba(47, 111, 237, 0.28) !important;
            }

        .rm-metric-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .rm-metric-card {
            background: #ffffff;
            border: 1px solid #eef1f5;
            border-radius: 14px;
            padding: 14px 16px;
            transition: box-shadow 0.22s ease, border-color 0.22s ease, transform 0.22s ease;
        }

        .rm-metric-icon {
            margin-bottom: 8px;
            font-size: 16px;
        }

            .rm-metric-icon.is-blue {
                color: #2f6fed;
            }

            .rm-metric-icon.is-green {
                color: #22a35a;
            }

            .rm-metric-icon.is-orange {
                color: #e7a23a;
            }

        .rm-metric-label {
            margin: 0 0 4px;
            color: #9aa3b2;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .rm-metric-value {
            margin: 0;
            color: #111827;
            font-size: 22px;
            font-weight: 800;
            line-height: 1;
        }

            .rm-metric-value.is-green {
                color: #22a35a;
            }

            .rm-metric-value.is-orange {
                color: #e7a23a;
            }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .upgradDataGrid {
            width: 100% !important;
            margin-bottom: 0 !important;
            border-collapse: collapse !important;
            border: 0 !important;
            background: transparent;
            color: #1f2937;
            font-size: 13px !important;
        }

            .upgradDataGrid th {
                padding: 12px 10px !important;
                background: transparent !important;
                color: #9aa3b2 !important;
                border: 0 !important;
                border-bottom: 1px solid #eef1f5 !important;
                font-size: 11px !important;
                font-weight: 700 !important;
                letter-spacing: 0.06em;
                text-transform: uppercase !important;
                vertical-align: middle !important;
                white-space: normal;
            }

            .upgradDataGrid td {
                padding: 12px 10px !important;
                background: transparent;
                color: #1f2937;
                border: 0 !important;
                border-bottom: 1px solid #f1f4f8 !important;
                font-size: 13px !important;
                line-height: 1.35;
                font-weight: 500;
                vertical-align: middle !important;
            }

            .upgradDataGrid tr:hover td {
                background: #fafbfd !important;
            }

        .materialGrid th,
        .materialGrid td {
            vertical-align: middle !important;
            text-align: center;
            word-wrap: break-word;
        }

        .sr-pill {
            width: 28px;
            height: 28px;
            margin: 0 auto;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #eef1f5;
            border-radius: 50%;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
        }

        .rm-code-cell {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #111827;
            font-weight: 800;
        }

            .rm-code-cell i {
                color: #2f6fed;
            }

        .qty-value {
            color: #111827;
            font-weight: 800;
        }

        .dispatch-pill,
        .pending-qty {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 54px;
            padding: 4px 10px;
            border-radius: 999px;
            font-weight: 800;
        }

        .dispatch-pill {
            background: #e8f8ee;
            color: #22a35a;
        }

        .pending-qty {
            background: #fff4e5;
            color: #d9822b;
        }

        .qtyDispatchBox {
            width: 88px !important;
            height: 36px !important;
            min-height: 36px !important;
            margin: 0 auto;
            text-align: center;
            padding: 5px 7px;
            font-weight: 700;
            background: #ffffff !important;
            border: 1px solid #d7dde6 !important;
            border-radius: 10px !important;
        }

        .no-spinner::-webkit-outer-spin-button,
        .no-spinner::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .no-spinner {
            -moz-appearance: textfield;
        }

        .rm-footer-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-top: 16px;
            padding: 14px 16px;
            background: #f7f8fa;
            border-radius: 14px;
        }

        .rm-footer-hint {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            color: #64748b;
            font-size: 13px;
        }

            .rm-footer-hint i {
                margin-top: 3px;
                color: #2f6fed;
            }

            .rm-footer-hint strong {
                color: #111827;
            }

        .rm-footer-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .btn-back,
        .btn-secondary {
            background: #ffffff !important;
            border: 1px solid #d7dde6 !important;
            color: #334155 !important;
            border-radius: 999px !important;
            padding: 8px 16px !important;
            font-size: 13px !important;
            font-weight: 700 !important;
            cursor: pointer;
            transition: background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease, box-shadow 0.18s ease, transform 0.18s ease;
        }

            .btn-back::before {
                content: "\f060";
                font-family: "Font Awesome 5 Free";
                font-weight: 900;
                margin-right: 6px;
            }

            .btn-back:hover,
            .btn-back:focus,
            .btn-secondary:hover,
            .btn-secondary:focus {
                background: #eef4ff !important;
                border-color: #2f6fed !important;
                color: #1f5bd6 !important;
                transform: translateY(-1px);
                box-shadow: 0 8px 18px rgba(47, 111, 237, 0.14) !important;
            }

        .btn-submit-dispatch {
            background: #2f6fed !important;
            border: 1px solid #2f6fed !important;
            color: #ffffff !important;
            border-radius: 999px !important;
            padding: 8px 18px !important;
            font-size: 13px !important;
            font-weight: 700 !important;
            cursor: pointer;
            transition: background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease, box-shadow 0.18s ease, transform 0.18s ease;
        }

            .btn-submit-dispatch::after {
                content: "\f061";
                font-family: "Font Awesome 5 Free";
                font-weight: 900;
                margin-left: 6px;
            }

            .btn-submit-dispatch:hover,
            .btn-submit-dispatch:focus {
                background: #1f5bd6 !important;
                border-color: #1f5bd6 !important;
                color: #ffffff !important;
                transform: translateY(-1px);
                box-shadow: 0 8px 18px rgba(47, 111, 237, 0.28) !important;
            }

        .message-box {
            margin-bottom: 14px;
        }

            .message-box .alert {
                margin-bottom: 0;
                border-radius: 12px;
                font-size: 14px;
            }

        #divMessage {
            font-size: 13px;
            font-weight: 600;
            margin-top: 8px;
        }

        .form-control.field-invalid,
        select.field-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12);
        }

        .rm-upload-box.field-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.12);
        }

        .table-responsive.field-invalid {
            border: 1px solid #dc3545;
            border-radius: 10px;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.08);
        }

        .dispatch-field-error {
            display: block;
            color: #dc3545;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
            line-height: 1.35;
        }

            .dispatch-field-error:empty {
                display: none;
            }

        .modalBackground {
            background-color: #000;
            opacity: 0.6;
            filter: alpha(opacity=60);
        }

        .success-popup {
            background-color: #fff;
            padding: 0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 8px 28px rgba(0,0,0,0.28);
            animation: rm-fade-in-up 0.28s ease;
            width: 360px;
            max-width: 90%;
        }

        .success-popup .success-popup-header {
            background-color: #22a35a;
            color: #fff;
            padding: 13px 18px;
        }

            .success-popup .success-popup-header h5 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
            }

        .success-popup .success-popup-body {
            padding: 22px 18px;
            text-align: center;
            font-size: 14px;
        }

        .success-popup .success-popup-footer {
            padding: 12px 18px;
            text-align: center;
            border-top: 1px solid #eee;
        }

        @media (max-width: 991px) {
            .rm-meta-bar,
            .rm-metric-row {
                grid-template-columns: 1fr 1fr;
            }

            .rm-meta-item.is-row-end {
                border-right: 1px solid #f0ece4;
            }

            .rm-meta-item.is-vendor-code,
            .rm-meta-item.is-vendor {
                border-top: 0;
            }

            .rm-meta-item.is-vendor {
                grid-column: auto;
            }

            .rm-footer-bar {
                flex-direction: column;
                align-items: stretch;
            }
        }

        @media (max-width: 767px) {
            .standalone-breadcrumbs,
            .rm-meta-bar,
            .rm-metric-row {
                display: block;
            }

                .standalone-breadcrumbs .pageTitle {
                    font-size: 13px !important;
                }

            .rm-meta-item {
                border-right: 0;
                border-bottom: 1px solid #f0ece4;
            }

            .rm-footer-actions .btn,
            .rm-footer-actions input {
                width: 100%;
                margin-bottom: 6px;
            }
        }
    </style>
    <div class="fg-dispatch-dtls rm-module">
            <div class="breadcrumbs standalone-breadcrumbs">
                <div class="leftFung">
                    <div class="pageTitleWrap">
                        <h3 class="pageTitle">Request Details</h3>
                        <p class="pageSubTitle">Review request information and create dispatch details</p>
                    </div>
                </div>
                <div class="rightFung">
                    <asp:Label ID="lblDispatchStatusBadge" runat="server" CssClass="rm-status-badge is-pending" Text="Pending Dispatch"></asp:Label>
                </div>
            </div>

            <asp:Label ID="lblErrorMessage" runat="server" ClientIDMode="Static" CssClass="errormsg" Text=""></asp:Label>
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="message-box">
                <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger d-block"></asp:Label>
            </asp:Panel>
            <asp:Button ID="btnPopupTarget" runat="server" Style="display: none;" />
            <asp:ModalPopupExtender ID="mpeSuccess" runat="server" TargetControlID="btnPopupTarget" PopupControlID="pnlSuccessPopup" BackgroundCssClass="modalBackground" OkControlID="btnPopupOk"></asp:ModalPopupExtender>
            <asp:Panel
                ID="pnlSuccessPopup"
                runat="server"
                CssClass="success-popup"
                Style="display: none;">

                <div class="success-popup-header">
                    <h5>Success</h5>
                </div>

                <div class="success-popup-body">
                    <p>Dispatch submitted successfully.</p>
                </div>

                <div class="success-popup-footer">
                    <asp:Button
                        ID="btnPopupOk"
                        runat="server"
                        Text="OK"
                        CssClass="btn btn-primary btn-sm"
                        OnClientClick="window.location.href='<%= GetDispatchListUrl() %>'; return false;" />
                </div>

            </asp:Panel>

            <div class="rm-meta-bar" id="divMetaBar" runat="server">
                <div class="rm-meta-item">
                    <span class="rm-meta-label">Request ID</span>
                    <asp:Label ID="lblRequestID" runat="server" CssClass="rm-meta-value rm-meta-value-id"></asp:Label>
                    <asp:HiddenField ID="hdnRawMaterialVendorCode" runat="server" />
                </div>
                <div class="rm-meta-item">
                    <span class="rm-meta-label">Request Date</span>
                    <asp:Label ID="lblRequestDate" runat="server" CssClass="rm-meta-value"></asp:Label>
                </div>
                <div class="rm-meta-item" id="divDispatchId" runat="server">
                    <span class="rm-meta-label">Despatch ID</span>
                    <asp:Label ID="lblDispatchID" runat="server" CssClass="rm-meta-value rm-meta-value-id"></asp:Label>
                </div>
                <div class="rm-meta-item is-row-end" id="divDispatchDate" runat="server">
                    <span class="rm-meta-label">Despatch Date</span>
                    <asp:Label ID="lblDispatchDate" runat="server" CssClass="rm-meta-value"></asp:Label>
                </div>
                <div class="rm-meta-item is-vendor-code">
                    <span class="rm-meta-label">Vendor Code</span>
                    <asp:Label ID="lblVendorCode" runat="server" CssClass="rm-meta-value"></asp:Label>
                </div>
                <div class="rm-meta-item is-vendor">
                    <span class="rm-meta-label">Vendor Name</span>
                    <span class="rm-vendor-name">
                        <i class="fas fa-building"></i>
                        <asp:Label ID="lblVendorName" runat="server"></asp:Label>
                    </span>
                </div>
            </div>

            <div class="row rm-two-col">
                <div class="col-lg-6">
                    <div class="rm-card">
                        <div class="rm-card-head">
                            <div class="rm-card-head-left">
                                <span class="rm-card-icon">
                                    <i class="fas fa-truck"></i>
                                </span>
                                <div>
                                    <h5 class="rm-card-title">Delivery Information</h5>
                                    <p class="rm-card-subtitle">Select how this order will be delivered</p>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-control-label">
                                Delivery Type <span class="req-star">*</span>
                            </label>
                            <asp:DropDownList
                                ID="ddlDelType"
                                runat="server"
                                ClientIDMode="Static"
                                CssClass="form-control"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlDelType_SelectedIndexChanged">
                            </asp:DropDownList>
                            <asp:Label ID="valDelType" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                            <div class="field-hint">
                                <i class="fas fa-info-circle"></i>
                                Select the applicable delivery method
                            </div>
                        </div>

                        <asp:Panel ID="pnlCourierCard" runat="server" CssClass="rm-courier-block" Visible="false">
                            <h6 class="rm-subhead">
                                <asp:Label ID="lblCourierCardHeader" runat="server" Text="Courier Information"></asp:Label>
                            </h6>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">
                                            <asp:Label ID="lblCourierNoLabel" runat="server" Text="POD No:"></asp:Label>
                                        </label>
                                        <asp:TextBox
                                            ID="txtCouNo"
                                            runat="server"
                                            ClientIDMode="Static"
                                            CssClass="form-control"
                                            placeholder="Enter POD No."
                                            AutoComplete="Off">
                                        </asp:TextBox>
                                        <asp:Label ID="valCouNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">
                                            <asp:Label ID="lblTranNameLabel" runat="server" Text="Courier Name:"></asp:Label>
                                        </label>
                                        <asp:TextBox
                                            ID="txtTranName"
                                            runat="server"
                                            ClientIDMode="Static"
                                            CssClass="form-control"
                                            placeholder="Enter Courier Name."
                                            AutoComplete="Off">
                                        </asp:TextBox>
                                        <asp:Label ID="valTranName" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                                <div id="divLrNo" class="col-md-6" runat="server">
                                    <div class="form-group">
                                        <label class="form-control-label">LR/Consignment No:</label>
                                        <asp:TextBox
                                            ID="txtLRNo"
                                            runat="server"
                                            ClientIDMode="Static"
                                            CssClass="form-control"
                                            placeholder="Enter LR/Consignment No."
                                            AutoComplete="Off">
                                        </asp:TextBox>
                                        <asp:Label ID="valLRNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">
                                            <asp:Label ID="lblLrDate" runat="server" Text="Courier Date:"></asp:Label>
                                        </label>
                                        <asp:TextBox
                                            ID="txtLRDate"
                                            runat="server"
                                            ClientIDMode="Static"
                                            CssClass="form-control"
                                            autocomplete="off"
                                            placeholder="Select Courier Date."
                                            onkeydown="return handleDateKeyDown(event, this);"
                                            onpaste="return true;"
                                            ondrop="return true;">
                                        </asp:TextBox>
                                        <asp:CalendarExtender
                                            ID="calLRDate"
                                            runat="server"
                                            TargetControlID="txtLRDate"
                                            Format="dd-MM-yyyy">
                                        </asp:CalendarExtender>
                                        <asp:Label ID="valLRDate" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                                <div id="divVehNo" class="col-md-6" runat="server">
                                    <div class="form-group">
                                        <label class="form-control-label">Vehicle No:</label>
                                        <asp:TextBox
                                            ID="txtVehNo"
                                            runat="server"
                                            ClientIDMode="Static"
                                            CssClass="form-control"
                                            placeholder="Enter Vehicle No."
                                            AutoComplete="Off">
                                        </asp:TextBox>
                                        <asp:Label ID="valVehNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="form-control-label">LR Doc:</label>
                                        <div class="rm-upload-box" id="divLrDocUpload" runat="server" clientidmode="Static">
                                            <span class="rm-upload-icon"><i class="fas fa-file-pdf"></i></span>
                                            <div>
                                                <p class="rm-upload-title">Upload LR Document</p>
                                                <p class="rm-upload-hint">PDF file only &bull; Max 5 MB</p>
                                                <span id="lrFileName" class="rm-upload-name"></span>
                                            </div>
                                            <button type="button" class="rm-choose-btn" onclick="document.getElementById('fuLrDoc').click(); return false;">Choose File</button>
                                            <asp:FileUpload
                                                ID="fuLrDoc"
                                                runat="server"
                                                ClientIDMode="Static"
                                                accept=".pdf,application/pdf"
                                                CssClass="rm-file-input" />
                                        </div>
                                        <asp:Label ID="valLrDoc" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="rm-card">
                        <div class="rm-card-head">
                            <div class="rm-card-head-left">
                                <span class="rm-card-icon">
                                    <i class="fas fa-file-invoice"></i>
                                </span>
                                <div>
                                    <h5 class="rm-card-title">Invoice Information</h5>
                                    <p class="rm-card-subtitle">Enter or extract invoice details</p>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-control-label">Invoice Document <span class="req-star">*</span></label>
                            <div class="rm-upload-box" id="divInvUpload" runat="server" clientidmode="Static">
                                <span class="rm-upload-icon"><i class="fas fa-file-alt"></i></span>
                                <div>
                                    <p class="rm-upload-title">Upload Invoice</p>
                                    <p class="rm-upload-hint">PDF file only &bull; Max 5 MB</p>
                                    <span id="invoiceFileName" class="rm-upload-name"></span>
                                </div>
                                <button type="button" class="rm-choose-btn" onclick="document.getElementById('fuInv').click(); return false;">Choose File</button>
                                <asp:FileUpload
                                    ID="fuInv"
                                    runat="server"
                                    ClientIDMode="Static"
                                    accept=".pdf,application/pdf"
                                    CssClass="rm-file-input" />
                            </div>
                            <asp:Label ID="valInvDoc" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                        </div>

                        <button style="margin-bottom: 14px; margin-top: 5px" type="button" id="btnUploadInvoice" clientidmode="Static" class="btn btn-primary rm-extract-btn" runat="server" onclick="triggerInvoiceOcrUpload(); return false;">
                            <i class="fas fa-magic"></i>
                            Upload &amp; Extract
                        </button>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-control-label">Invoice No. <span class="req-star">*</span></label>
                                    <asp:TextBox
                                        ID="txtInvNo"
                                        runat="server"
                                        ClientIDMode="Static"
                                        CssClass="form-control"
                                        placeholder="Enter invoice no.">
                                    </asp:TextBox>
                                    <asp:Label ID="valInvNo" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-control-label">Invoice Date <span class="req-star">*</span></label>
                                    <asp:TextBox
                                        ID="txtInvDate"
                                        runat="server"
                                        ClientIDMode="Static"
                                        CssClass="form-control"
                                        autocomplete="off"
                                        placeholder="dd-mm-yyyy"
                                        onkeydown="return handleDateKeyDown(event, this);"
                                        onpaste="return false;"
                                        ondrop="return false;">
                                    </asp:TextBox>
                                    <asp:CalendarExtender
                                        ID="calInvDate"
                                        runat="server"
                                        TargetControlID="txtInvDate"
                                        Format="dd-MM-yyyy">
                                    </asp:CalendarExtender>
                                    <asp:Label ID="valInvDate" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>
                                </div>
                            </div>
                        </div>


                        <div id="divMessage"></div>
                    </div>
                </div>
            </div>

            <div class="rm-card">
                <div class="rm-card-head">
                    <div class="rm-card-head-left">
                        <span class="rm-card-icon">
                            <i class="fas fa-cube"></i>
                        </span>
                        <div>
                            <h5 class="rm-card-title">Material Request Details</h5>
                            <p class="rm-card-subtitle">Enter quantity against materials being dispatched</p>
                        </div>
                    </div>
                    <asp:Label ID="lblMaterialCountBadge" runat="server" CssClass="rm-count-badge" Text="0 Materials"></asp:Label>
                </div>

                <div class="rm-metric-row">
                    <div class="rm-metric-card">
                        <div class="rm-metric-icon is-blue"><i class="fas fa-cube"></i></div>
                        <p class="rm-metric-label">Total Requested</p>
                        <p class="rm-metric-value">
                            <asp:Label ID="lblTotalRequested" runat="server" Text="0.00"></asp:Label>
                        </p>
                    </div>
                    <div class="rm-metric-card">
                        <div class="rm-metric-icon is-green"><i class="fas fa-check-circle"></i></div>
                        <p class="rm-metric-label">Total Dispatched</p>
                        <p class="rm-metric-value is-green">
                            <asp:Label ID="lblTotalDispatched" runat="server" Text="0.00"></asp:Label>
                        </p>
                    </div>
                    <div class="rm-metric-card">
                        <div class="rm-metric-icon is-orange"><i class="far fa-clock"></i></div>
                        <p class="rm-metric-label">Total Pending</p>
                        <p class="rm-metric-value is-orange">
                            <asp:Label ID="lblTotalPending" runat="server" Text="0.00"></asp:Label>
                        </p>
                    </div>
                    <div class="rm-metric-card">
                        <div class="rm-metric-icon is-blue"><i class="fas fa-box"></i></div>
                        <p class="rm-metric-label">Items</p>
                        <p class="rm-metric-value">
                            <asp:Label ID="lblItemCount" runat="server" Text="0"></asp:Label>
                        </p>
                    </div>
                </div>

                <div class="table-responsive" id="divMaterialsGrid" runat="server" clientidmode="Static">
                    <asp:GridView
                        ID="gvMaterials"
                        runat="server"
                        AutoGenerateColumns="false"
                        BorderWidth="0"
                        CssClass="table table-hover upgradDataGrid materialGrid"
                        EmptyDataText="No request details found.">

                        <RowStyle CssClass="tlrowlight" />
                        <HeaderStyle CssClass="headerGrid" />
                        <FooterStyle CssClass="footerGrid" />

                        <Columns>
                            <asp:TemplateField HeaderText="SR NO.">
                                <ItemTemplate>
                                    <span class="sr-pill">
                                        <asp:Label ID="lblSrl" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                    </span>
                                    <asp:HiddenField ID="hdnOrdID" runat="server" Value='<%# Eval("ord_id") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="6%" />
                                <ItemStyle HorizontalAlign="Center" Width="6%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="RAW MATERIAL NAME">
                                <ItemTemplate>
                                    <span class="rm-code-cell">
                                        <i class="fas fa-cube"></i>
                                        <asp:Label ID="lblRmCode" runat="server" Text='<%# Eval("rmm_material_name") %>'></asp:Label>
                                        <asp:HiddenField runat="server" ID="hdnRmCode" Value='<%# Bind("ord_rawmaterial_code") %>' />
                                    </span>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="18%" />
                                <ItemStyle HorizontalAlign="Center" Width="18%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="REQUIRED DELIVERY DATE">
                                <ItemTemplate>
                                    <asp:Label ID="lblDeliveryDate" runat="server" Text='<%# Eval("ord_req_delivery_date", "{0:dd-MM-yyyy}") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="16%" />
                                <ItemStyle HorizontalAlign="Center" Width="16%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="REQUESTED QUANTITY">
                                <ItemTemplate>
                                    <asp:Label ID="lblRequestedQty" runat="server" CssClass="qty-value" Text='<%# Eval("ord_qty") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="14%" />
                                <ItemStyle HorizontalAlign="Center" Width="14%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TOTAL DISPATCHED QUANTITY">
                                <ItemTemplate>
                                    <asp:Label ID="lblDispatchQty" runat="server" CssClass="dispatch-pill" Text='<%# Eval("dispatch_qty") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="15%" />
                                <ItemStyle HorizontalAlign="Center" Width="15%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="PENDING QUANTITY">
                                <ItemTemplate>
                                    <asp:Label ID="lblPendingQty" runat="server" CssClass="pending-qty" Text='<%# Eval("pending_qty") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="13%" />
                                <ItemStyle HorizontalAlign="Center" Width="13%" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="QUANTITY TO DISPATCH">
                                <ItemTemplate>
                                    <asp:TextBox
                                        ID="txtQtyToDispatch"
                                        runat="server"
                                        CssClass="form-control qtyDispatchBox no-spinner"
                                        Text="0"
                                        MaxLength="10"
                                        inputmode="decimal"
                                        onkeypress="return allowDecimal(this, event);"
                                        oninput="validateDecimal(this);">
                                    </asp:TextBox>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Center" Width="18%" />
                                <ItemStyle HorizontalAlign="Center" Width="18%" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Label ID="valGridQty" runat="server" ClientIDMode="Static" CssClass="dispatch-field-error"></asp:Label>

                <div class="rm-footer-bar">
                    <div class="rm-footer-hint">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>Ready to submit?</strong>
                            Verify invoice and dispatch quantities before submitting.
                        </div>
                    </div>
                    <div class="rm-footer-actions">
                        <asp:Button
                            ID="btnBack"
                            runat="server"
                            OnClick="btnBack_Click"
                            Text="Back"
                            CssClass="btn btn-secondary btn-sm btn-back"
                            CausesValidation="false" />
                        <asp:Button
                            ID="btnSubmit"
                            runat="server"
                            ClientIDMode="Static"
                            Text="Submit Dispatch"
                            OnClick="btnSubmit_Click"
                            OnClientClick="return validateDispatchForm();"
                            CssClass="btn btn-primary btn-sm btn-submit-dispatch"
                            CausesValidation="false" />
                    </div>
                </div>
            </div>
    </div>
    <script type="text/javascript" src="Scripts/FunctionValidator.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript" src="Scripts/rm-status-confirm.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript" src="Scripts/ValidateFGVendor_DespatchDtls.js?v=<%= DateTime.Now.Ticks %>"></script>
    <script type="text/javascript">

        function allowDecimal(control, evt) {

            var charCode = evt.which ? evt.which : evt.keyCode;

            // Allow Backspace, Tab, Delete and Arrow keys
            if (
                charCode === 8 ||
                charCode === 9 ||
                charCode === 37 ||
                charCode === 39 ||
                charCode === 46
            ) {
                // 46 can also represent decimal point
                if (charCode === 46) {
                    if (control.value.indexOf('.') !== -1) {
                        return false;
                    }
                }

                return true;
            }

            // Allow digits 0-9
            if (charCode >= 48 && charCode <= 57) {
                return true;
            }

            return false;
        }


        function validateDecimal(control) {

            // Remove everything except numbers and decimal point
            control.value = control.value.replace(/[^0-9.]/g, '');

            // Allow only one decimal point
            var parts = control.value.split('.');

            if (parts.length > 2) {
                control.value = parts[0] + '.' + parts.slice(1).join('');
            }

        }

    </script>
    <script type="text/javascript">

        // Bound on native DOMContentLoaded so it doesn't depend on any
        // jQuery ready() callback elsewhere on the page.
        document.addEventListener('DOMContentLoaded', function () {
            bindInvoiceUploadExtract();
        });

        function bindInvoiceUploadExtract() {
            var btn = document.getElementById('<%= btnUploadInvoice.ClientID %>');
            if (btn) {
                btn.onclick = function () {
                    triggerInvoiceOcrUpload();
                    return false;
                };
            }
        }

        function triggerInvoiceOcrUpload() {

            var fileUpload = document.getElementById('fuInv');
            var msgDiv = document.getElementById('divMessage');
            var btn = document.getElementById('<%= btnUploadInvoice.ClientID %>');

            clearDispatchUploadValidation('fuInv');

            if (!fileUpload || !fileUpload.files || fileUpload.files.length === 0) {
                setDispatchFieldError('fuInv', 'Invoice Document is required.');
                showInvoiceMessage(msgDiv, '', 'info');
                return;
            }

            var file = fileUpload.files[0];

            if (!/\.pdf$/i.test(file.name)) {
                setDispatchFieldError('fuInv', 'Invoice Document must be a PDF file.');
                showInvoiceMessage(msgDiv, '', 'info');
                fileUpload.value = '';
                return;
            }

            if (file.size > (5 * 1024 * 1024)) {
                setDispatchFieldError('fuInv', 'Invoice Document must not exceed 5 MB.');
                showInvoiceMessage(msgDiv, '', 'info');
                fileUpload.value = '';
                return;
            }

            clearDispatchUploadValidation('fuInv');

            var formData = new FormData();
            formData.append('file', file, file.name);

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'InvoiceOcrExtract.ashx', true);

            btn.disabled = true;
            showInvoiceMessage(msgDiv, 'Uploading and extracting invoice details...', 'info');

            xhr.onload = function () {

                btn.disabled = false;

                var result;
                try {
                    result = JSON.parse(xhr.responseText);
                } catch (e) {
                    showInvoiceMessage(msgDiv, 'Invoice OCR request failed.', 'danger');
                    fileUpload.value = '';
                    return;
                }

                if (xhr.status === 200 && result && result.success) {

                    if (result.invoice_no) {
                        document.getElementById('txtInvNo').value = result.invoice_no;
                    }

                    //if (result.invoice_date) {
                    //    document.getElementById('txtInvDate').value = result.invoice_date.replace(/-/g, '/');
                    //}
                    if (result.invoice_date) {

                        console.log("Invoice Date from API:", result.invoice_date);

                        var invoiceDate = result.invoice_date.trim();
                        invoiceDate = invoiceDate.replace(/\//g, '-');

                        var parts = invoiceDate.split('-');

                        if (parts.length === 3) {

                            var day;
                            var month;
                            var year;

                            if (parts[0].length === 4) {
                                // yyyy-MM-dd
                                year = parts[0];
                                month = parts[1];
                                day = parts[2];
                            } else {
                                // dd-MM-yyyy
                                day = parts[0];
                                month = parts[1];
                                year = parts[2];
                            }

                            document.getElementById('txtInvDate').value =
                                day.padStart(2, '0') + '-' +
                                month.padStart(2, '0') + '-' +
                                year;
                        }
                    }

                    showInvoiceMessage(msgDiv, 'Invoice details extracted successfully.', 'success');

                } else {
                    showInvoiceMessage(msgDiv, (result && result.message) || 'Unable to extract invoice details from the uploaded PDF.', 'danger');
                    fileUpload.value = '';
                }
            };

            xhr.onerror = function () {
                btn.disabled = false;
                showInvoiceMessage(msgDiv, 'Invoice OCR request failed.', 'danger');
                fileUpload.value = '';
            };

            xhr.send(formData);
        }

        function showInvoiceMessage(msgDiv, text, type) {

            if (!msgDiv) {
                return;
            }

            var cssClass = 'text-muted';

            if (type === 'danger') {
                cssClass = 'text-danger';
            } else if (type === 'success') {
                cssClass = 'text-success';
            }

            msgDiv.innerHTML = '<span class="' + cssClass + '">' + text + '</span>';
        }

    </script>
    <script>
        function allowDecimal(input, event) {

            var charCode = event.which ? event.which : event.keyCode;
            var value = input.value;

            // Allow backspace, delete, tab, arrows
            if (
                charCode == 8 ||
                charCode == 46 ||
                charCode == 9 ||
                charCode == 37 ||
                charCode == 39
            ) {
                return true;
            }

            // Allow only numbers and decimal
            if (
                (charCode >= 48 && charCode <= 57) ||
                charCode == 46
            ) {

                // Prevent multiple decimal points
                if (charCode == 46 && value.includes('.')) {
                    return false;
                }

                // Restrict 2 digits after decimal
                if (value.includes('.')) {
                    var decimalPart = value.split('.')[1];

                    if (decimalPart.length >= 2) {
                        return false;
                    }
                }

                return true;
            }

            return false;
        }


        function validateDecimal(input) {

            var value = input.value;

            // Remove invalid characters
            value = value.replace(/[^0-9.]/g, '');

            // Allow only one decimal point
            var parts = value.split('.');

            if (parts.length > 2) {
                value = parts[0] + '.' + parts[1];
            }

            // Restrict decimal places to 2
            if (value.includes('.')) {
                var decimal = value.split('.');

                if (decimal[1].length > 2) {
                    value = decimal[0] + '.' + decimal[1].substring(0, 2);
                }
            }

            input.value = value;
        }
    </script>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var vendorName = document.getElementById('<%= lblVendorName.ClientID %>');
            var welcomeVendorName = document.getElementById('welcomeVendorName');

            if (vendorName && welcomeVendorName) {
                welcomeVendorName.textContent =
                    (vendorName.innerText || vendorName.textContent || '').trim();
            }

            bindFileNameDisplay('fuInv', 'invoiceFileName');
            bindFileNameDisplay('fuLrDoc', 'lrFileName');
        });

        function bindFileNameDisplay(inputId, labelId) {
            var input = document.getElementById(inputId);
            var label = document.getElementById(labelId);
            if (!input || !label) {
                return;
            }

            input.addEventListener('change', function () {
                label.textContent = (input.files && input.files.length) ? input.files[0].name : '';

                if (inputId === 'fuInv') {
                    clearDispatchUploadValidation('fuInv');
                } else if (inputId === 'fuLrDoc') {
                    clearDispatchUploadValidation('fuLrDoc');
                }
            });
        }
    </script>

    <script type="text/javascript">
        function handleDateKeyDown(event, textbox) {

            // Allow Tab for navigation
            if (event.key === "Tab") {
                return true;
            }

            // Backspace / Delete clears the complete date
            if (event.key === "Backspace" || event.key === "Delete") {
                textbox.value = "";
                return false;
            }

            // Block all other keyboard input
            return false;
        }
    </script>
</asp:Content>