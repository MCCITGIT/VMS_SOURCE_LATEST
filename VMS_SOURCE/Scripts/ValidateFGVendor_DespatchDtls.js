var firstErrorControl;
var errMsg;
var DISPATCH_MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024;

var dispatchValidationFields = [
    { key: "ddlDelType", controlId: "ddlDelType", labelId: "valDelType" },
    { key: "txtCouNo", controlId: "txtCouNo", labelId: "valCouNo" },
    { key: "txtTranName", controlId: "txtTranName", labelId: "valTranName" },
    { key: "txtLRNo", controlId: "txtLRNo", labelId: "valLRNo" },
    { key: "txtLRDate", controlId: "txtLRDate", labelId: "valLRDate" },
    { key: "txtVehNo", controlId: "txtVehNo", labelId: "valVehNo" },
    { key: "fuLrDoc", controlId: "fuLrDoc", labelId: "valLrDoc", uploadBoxId: "divLrDocUpload" },
    { key: "txtInvNo", controlId: "txtInvNo", labelId: "valInvNo" },
    { key: "txtInvDate", controlId: "txtInvDate", labelId: "valInvDate" },
    { key: "fuInv", controlId: "fuInv", labelId: "valInvDoc", uploadBoxId: "divInvUpload" }
];

function getDispatchControl(controlId) {
    return document.getElementById(controlId) || document.querySelector("[id$='" + controlId + "']");
}

function validateDispatchUploadFile(inputId, displayName, isRequired) {
    var input = getDispatchControl(inputId);

    if (!input) {
        return null;
    }

    if (!input.files || input.files.length === 0) {
        if (isRequired) {
            return displayName + " is required.";
        }
        return null;
    }

    var file = input.files[0];

    if (!/\.pdf$/i.test(file.name)) {
        return displayName + " must be a PDF file.";
    }

    if (file.size > DISPATCH_MAX_FILE_SIZE_BYTES) {
        return displayName + " must not exceed 5 MB.";
    }

    return null;
}

function clearDispatchUploadValidation(fieldKey) {
    setDispatchFieldError(fieldKey, "");
}

function clearDispatchValidation() {
    var i;

    for (i = 0; i < dispatchValidationFields.length; i++) {
        var field = dispatchValidationFields[i];
        var control = getDispatchControl(field.controlId);
        var label = getDispatchControl(field.labelId);
        var uploadBox = field.uploadBoxId ? getDispatchControl(field.uploadBoxId) : null;

        if (control) {
            control.classList.remove("field-invalid");
            control.style.backgroundColor = "";
        }

        if (uploadBox) {
            uploadBox.classList.remove("field-invalid");
        }

        if (label) {
            label.innerHTML = "";
        }
    }

    var gridWrapper = getDispatchControl("divMaterialsGrid");
    var gridLabel = getDispatchControl("valGridQty");

    if (gridWrapper) {
        gridWrapper.classList.remove("field-invalid");
    }

    if (gridLabel) {
        gridLabel.innerHTML = "";
    }
}

function setDispatchFieldError(fieldKey, message) {
    var i;

    for (i = 0; i < dispatchValidationFields.length; i++) {
        if (dispatchValidationFields[i].key !== fieldKey) {
            continue;
        }

        var field = dispatchValidationFields[i];
        var control = getDispatchControl(field.controlId);
        var label = getDispatchControl(field.labelId);
        var uploadBox = field.uploadBoxId ? getDispatchControl(field.uploadBoxId) : null;

        if (message) {
            if (control) {
                control.classList.add("field-invalid");
            }
            if (uploadBox) {
                uploadBox.classList.add("field-invalid");
            }
        } else {
            if (control) {
                control.classList.remove("field-invalid");
            }
            if (uploadBox) {
                uploadBox.classList.remove("field-invalid");
            }
        }

        if (label) {
            label.innerHTML = message;
        }

        return;
    }
}

function setDispatchGridError(message) {
    var gridWrapper = getDispatchControl("divMaterialsGrid");
    var gridLabel = getDispatchControl("valGridQty");

    if (gridWrapper) {
        if (message) {
            gridWrapper.classList.add("field-invalid");
        } else {
            gridWrapper.classList.remove("field-invalid");
        }
    }

    if (gridLabel) {
        gridLabel.innerHTML = message;
    }
}

function getDispatchValidationElement(fieldKey) {
    var i;

    for (i = 0; i < dispatchValidationFields.length; i++) {
        if (dispatchValidationFields[i].key !== fieldKey) {
            continue;
        }

        var field = dispatchValidationFields[i];

        if (field.uploadBoxId) {
            return getDispatchControl(field.uploadBoxId);
        }

        return getDispatchControl(field.controlId);
    }

    if (fieldKey === "gvMaterials") {
        return getDispatchControl("divMaterialsGrid");
    }

    return null;
}

function showDispatchValidation(fieldErrors, gridErrors) {
    var fieldKey;
    var firstInvalid = null;

    clearDispatchValidation();

    for (fieldKey in fieldErrors) {
        if (!fieldErrors.hasOwnProperty(fieldKey)) {
            continue;
        }

        setDispatchFieldError(fieldKey, fieldErrors[fieldKey].join(" "));

        if (!firstInvalid) {
            firstInvalid = getDispatchValidationElement(fieldKey);
        }
    }

    if (gridErrors.length > 0) {
        setDispatchGridError(gridErrors.join(" "));

        if (!firstInvalid) {
            firstInvalid = getDispatchControl("divMaterialsGrid");
        }
    }

    if (firstInvalid && firstInvalid.scrollIntoView) {
        firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
    }

    return false;
}

function isValidDispatchDate(value) {
    if (!value) {
        return false;
    }

    var match = value.match(/^(\d{2})[-\/](\d{2})[-\/](\d{4})$/);

    if (!match) {
        return false;
    }

    var day = parseInt(match[1], 10);
    var month = parseInt(match[2], 10);
    var year = parseInt(match[3], 10);
    var date = new Date(year, month - 1, day);

    return date.getFullYear() === year &&
        date.getMonth() === month - 1 &&
        date.getDate() === day;
}

function deliveryFieldMessage(selectedDeliveryText, courierMessage, transportMessage, fallbackMessage) {
    if (selectedDeliveryText.indexOf("courier") !== -1) {
        return courierMessage;
    }

    if (selectedDeliveryText.indexOf("transport") !== -1) {
        return transportMessage;
    }

    return fallbackMessage;
}

function validateDispatchForm() {
    var fieldErrors = {};
    var gridErrors = [];
    var selectedDeliveryText = "";
    var pageMessage = getDispatchControl("lblErrorMessage");

    if (pageMessage) {
        pageMessage.innerHTML = "";
    }

    function addFieldError(fieldKey, message) {
        if (!fieldErrors[fieldKey]) {
            fieldErrors[fieldKey] = [];
        }
        fieldErrors[fieldKey].push(message);
    }

    function addGridError(message) {
        gridErrors.push(message);
    }

    var deliveryType = getDispatchControl("ddlDelType");

    if (!deliveryType || deliveryType.value.trim() === "") {
        addFieldError("ddlDelType", "Delivery Type is required.");
    } else {
        selectedDeliveryText = deliveryType.options[deliveryType.selectedIndex].text.trim().toLowerCase();

        var courierNo = getDispatchControl("txtCouNo");
        if (!courierNo || courierNo.value.trim() === "") {
            addFieldError("txtCouNo", deliveryFieldMessage(selectedDeliveryText, "POD No is required.", "Transport No is required.", "Courier / Transport No is required."));
        }

        var transporterName = getDispatchControl("txtTranName");
        if (!transporterName || transporterName.value.trim() === "") {
            addFieldError("txtTranName", deliveryFieldMessage(selectedDeliveryText, "Courier Name is required.", "Transporter Name is required.", "Courier / Transporter Name is required."));
        }

        if (selectedDeliveryText.indexOf("transport") !== -1) {
            var lrNo = getDispatchControl("txtLRNo");
            if (!lrNo || lrNo.value.trim() === "") {
                addFieldError("txtLRNo", "LR / Consignment No is required.");
            }
        }

        var lrDate = getDispatchControl("txtLRDate");
        if (!lrDate || lrDate.value.trim() === "") {
            addFieldError("txtLRDate", deliveryFieldMessage(selectedDeliveryText, "Courier Date is required.", "LR Date is required.", "Delivery Date is required."));
        } else if (!isValidDispatchDate(lrDate.value.trim())) {
            addFieldError("txtLRDate", deliveryFieldMessage(selectedDeliveryText, "Please enter a valid Courier Date.", "Please enter a valid LR Date.", "Please enter a valid Delivery Date."));
        }

        if (selectedDeliveryText.indexOf("transport") !== -1) {
            var vehicleNo = getDispatchControl("txtVehNo");
            if (!vehicleNo || vehicleNo.value.trim() === "") {
                addFieldError("txtVehNo", "Vehicle No is required.");
            }
        }
    }

    var lrDocError = validateDispatchUploadFile("fuLrDoc", "LR Document", false);
    if (lrDocError) {
        addFieldError("fuLrDoc", lrDocError);
    }

    var invoiceNo = getDispatchControl("txtInvNo");
    if (!invoiceNo || invoiceNo.value.trim() === "") {
        addFieldError("txtInvNo", "Invoice No is required.");
    }

    var invoiceDate = getDispatchControl("txtInvDate");
    if (!invoiceDate || invoiceDate.value.trim() === "") {
        addFieldError("txtInvDate", "Invoice Date is required.");
    } else if (!isValidDispatchDate(invoiceDate.value.trim())) {
        addFieldError("txtInvDate", "Please enter a valid Invoice Date.");
    }

    var invDocError = validateDispatchUploadFile("fuInv", "Invoice Document", true);
    if (invDocError) {
        addFieldError("fuInv", invDocError);
    }

    var qtyBoxes = document.querySelectorAll(".qtyDispatchBox");
    var hasDispatchQty = false;
    var i;

    for (i = 0; i < qtyBoxes.length; i++) {
        var qtyBox = qtyBoxes[i];
        var qtyText = qtyBox.value.trim();
        if (qtyText === "") {
            qtyText = "0";
        }

        var qty = parseFloat(qtyText);

        if (isNaN(qty)) {
            addGridError("Please enter a valid dispatch quantity at row " + (i + 1) + ".");
            continue;
        }

        if (qty < 0) {
            addGridError("Dispatch quantity cannot be negative at row " + (i + 1) + ".");
            continue;
        }

        if (qty > 0) {
            hasDispatchQty = true;

            var row = qtyBox.closest("tr");
            if (row) {
                var pendingLabel = row.querySelector(".pending-qty");
                if (pendingLabel) {
                    var pendingText = pendingLabel.innerText || pendingLabel.textContent || "0";
                    var pendingQty = parseFloat(pendingText);

                    if (!isNaN(pendingQty) && qty > pendingQty) {
                        addGridError("Dispatch quantity cannot exceed pending quantity at row " + (i + 1) + ".");
                    }
                }
            }
        }
    }

    if (!hasDispatchQty) {
        addGridError("Please enter quantity to dispatch for at least one material.");
    }

    if (Object.keys(fieldErrors).length > 0 || gridErrors.length > 0) {
        return showDispatchValidation(fieldErrors, gridErrors);
    }

    clearDispatchValidation();

    if (confirm("Are you sure to submit?")) {
        var submitButton = getDispatchControl("btnSubmit");
        if (submitButton) {
            submitButton.disabled = true;
            __doPostBack(submitButton.name, "");
        }
        return true;
    }

    return false;
}
