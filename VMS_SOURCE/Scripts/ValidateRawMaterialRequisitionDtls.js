function allowRateTwoDecimal(evt, control) {
    var charCode = evt.which ? evt.which : evt.keyCode;

    if (charCode === 8 || charCode === 9 || charCode === 13 || charCode === 37 || charCode === 39 || charCode === 46) {
        return true;
    }

    var charValue = String.fromCharCode(charCode);
    if (!/[0-9.]/.test(charValue)) {
        return false;
    }

    var value = control.value || "";
    if (charValue === ".") {
        return value.indexOf(".") === -1;
    }

    var dotIndex = value.indexOf(".");
    if (dotIndex !== -1) {
        var decimals = value.substring(dotIndex + 1);
        var hasSelection = control.selectionStart !== control.selectionEnd;
        if (!hasSelection && control.selectionStart > dotIndex && decimals.length >= 2) {
            return false;
        }
    }

    return true;
}

function sanitizeRateTwoDecimal(control) {
    var value = control.value || "";
    value = value.replace(/[^0-9.]/g, "");

    if (value.indexOf(".") !== -1) {
        var parts = value.split(".");
        value = parts[0] + "." + parts.slice(1).join("");
    }

    var dotIndex = value.indexOf(".");
    if (dotIndex !== -1) {
        var intPart = value.substring(0, dotIndex);
        var decPart = value.substring(dotIndex + 1, dotIndex + 3);
        value = intPart + "." + decPart;
    }

    control.value = value;
}

function formatRateTwoDecimal(control) {
    var value = (control.value || "").trim();
    if (value === "") {
        return;
    }

    var numValue = parseFloat(value);
    if (isNaN(numValue)) {
        control.value = "";
        return;
    }

    control.value = numValue.toFixed(2);
}

function getRmControl(controlId) {
    return document.getElementById(controlId) || document.querySelector("[id$='" + controlId + "']");
}

function clearFieldValidation(controlId, labelId) {
    var control = getRmControl(controlId);
    var label = labelId ? getRmControl(labelId) : null;

    if (control) {
        control.classList.remove("field-invalid");
    }

    if (label) {
        label.innerHTML = "";
    }
}

function setFieldError(controlId, labelId, message, scrollToField) {
    var control = getRmControl(controlId);
    var label = labelId ? getRmControl(labelId) : null;

    if (control) {
        control.classList.add("field-invalid");
    }

    if (label) {
        label.innerHTML = message;
    }

    if (scrollToField && control && control.scrollIntoView) {
        control.scrollIntoView({ behavior: "smooth", block: "center" });
    }
}

function isDropDownSelected(control) {
    if (!control) {
        return false;
    }

    var value = (control.value || "").trim();
    if (value === "" || value.toLowerCase() === "select" || value === "0") {
        return false;
    }

    return control.selectedIndex > 0;
}

function clearUnitValidation() {
    clearFieldValidation("ddlUnit", "valUnit");
}

function clearVendorValidation() {
    clearFieldValidation("ddlVendor", "valVendor");
}

function clearGridValidation() {
    var label = getRmControl("valGrid");
    var grid = getRmControl("gvVendorRawMat");

    if (label) {
        label.innerHTML = "";
    }

    if (grid) {
        var inputs = grid.querySelectorAll("input[id$='txtQuantity'], input[id$='txtReqDate']");
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].classList.remove("field-invalid");
        }
    }
}

function clearRequisitionSearchValidation() {
    clearUnitValidation();
    clearVendorValidation();
}

function clearRequisitionSubmitValidation() {
    clearVendorValidation();
    clearGridValidation();
}

function clearRequisitionGridFieldValidation(control) {
    if (control) {
        control.classList.remove("field-invalid");
    }

    var valGrid = getRmControl("valGrid");
    if (!valGrid) {
        return;
    }

    var grid = getRmControl("gvVendorRawMat");
    if (!grid) {
        valGrid.innerHTML = "";
        return;
    }

    var invalidInputs = grid.querySelectorAll("input[id$='txtQuantity'].field-invalid, input[id$='txtReqDate'].field-invalid");
    if (!invalidInputs || invalidInputs.length === 0) {
        valGrid.innerHTML = "";
    }
}

function scrollToFirstInvalidRequisitionField() {
    var dropdownIds = ["ddlUnit", "ddlVendor"];

    for (var i = 0; i < dropdownIds.length; i++) {
        var dropdown = getRmControl(dropdownIds[i]);
        if (dropdown && dropdown.classList.contains("field-invalid") && dropdown.scrollIntoView) {
            dropdown.scrollIntoView({ behavior: "smooth", block: "center" });
            return;
        }
    }

    var grid = getRmControl("gvVendorRawMat");
    if (grid) {
        var invalidInput = grid.querySelector("input[id$='txtQuantity'].field-invalid, input[id$='txtReqDate'].field-invalid");
        if (invalidInput && invalidInput.scrollIntoView) {
            invalidInput.scrollIntoView({ behavior: "smooth", block: "center" });
            return;
        }

        var valGrid = getRmControl("valGrid");
        if (valGrid && (valGrid.innerHTML || "").trim() !== "" && grid.scrollIntoView) {
            grid.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    }
}

function validateRawMaterialRequisitionSearch() {
    var hasError = false;

    clearRequisitionSearchValidation();

    if (!isDropDownSelected(getRmControl("ddlUnit"))) {
        setFieldError("ddlUnit", "valUnit", "Please select Vendor Name.", false);
        hasError = true;
    }

    if (!isDropDownSelected(getRmControl("ddlVendor"))) {
        setFieldError("ddlVendor", "valVendor", "Please select RM Vendor.", false);
        hasError = true;
    }

    if (hasError) {
        scrollToFirstInvalidRequisitionField();
        return false;
    }

    var lblError = getRmControl("lblErrorMessage");
    if (lblError) {
        lblError.innerHTML = "";
    }

    return true;
}

function validateRawMaterialRequisitionSubmit() {
    var hasError = false;
    var hasValidRow = false;
    var hasPartialRowError = false;
    var hasMissingDateError = false;
    var hasMissingQtyError = false;
    var grid = getRmControl("gvVendorRawMat");
    var valGrid = getRmControl("valGrid");

    clearRequisitionSubmitValidation();

    if (!isDropDownSelected(getRmControl("ddlVendor"))) {
        setFieldError("ddlVendor", "valVendor", "Please select RM Vendor.", false);
        hasError = true;
    }

    var dataRows = grid ? grid.querySelectorAll("tbody tr.tlrowlight") : [];
    var hasDataRow = dataRows && dataRows.length > 0;

    if (!hasDataRow) {
        if (valGrid) {
            valGrid.innerHTML = "Please search and load Raw Material details.";
        }
        hasError = true;
    } else {
        for (var i = 0; i < dataRows.length; i++) {
            var row = dataRows[i];
            var qtyControl = row.querySelector("input[id$='txtQuantity']");
            var dateControl = row.querySelector("input[id$='txtReqDate']");

            if (!qtyControl || !dateControl) {
                continue;
            }

            formatRateTwoDecimal(qtyControl);

            var qtyValue = (qtyControl.value || "").trim();
            var dateValue = (dateControl.value || "").trim();
            var qtyNumber = parseFloat(qtyValue);
            var hasQty = qtyValue !== "" && !isNaN(qtyNumber) && qtyNumber > 0;
            var hasDate = dateValue !== "";

            if (!hasQty && !hasDate) {
                continue;
            }

            if (hasQty && hasDate) {
                hasValidRow = true;
            } else if (hasQty && !hasDate) {
                dateControl.classList.add("field-invalid");
                hasPartialRowError = true;
                hasMissingDateError = true;
                hasError = true;
            } else if (hasDate && !hasQty) {
                qtyControl.classList.add("field-invalid");
                hasPartialRowError = true;
                hasMissingQtyError = true;
                hasError = true;
            }
        }

        if (!hasValidRow && !hasPartialRowError) {
            if (valGrid) {
                valGrid.innerHTML = "Please enter Quantity and Requisition Date for at least one Raw Material.";
            }
            hasError = true;
        } else if (hasPartialRowError && valGrid) {
            if (hasMissingDateError && hasMissingQtyError) {
                valGrid.innerHTML = "Please enter Quantity and Requisition Date for each selected Raw Material.";
            } else if (hasMissingDateError) {
                valGrid.innerHTML = "Please enter Requisition Date.";
            } else if (hasMissingQtyError) {
                valGrid.innerHTML = "Please enter Quantity.";
            }
        }
    }

    if (hasError) {
        scrollToFirstInvalidRequisitionField();
        return false;
    }

    var lblError = getRmControl("lblErrorMessage");
    if (lblError) {
        lblError.innerHTML = "";
    }

    var submitBtn = getRmControl("btnSubmit");
    var buttonText = submitBtn ? ((submitBtn.value || "") + "").toLowerCase() : "submit";
    return rmConfirmPostback("btnSubmit", buttonText.indexOf("update") >= 0 ? "update" : "submit");
}

function validateRawMaterialRequisitionApprove() {
    try {
        var grid = getRmControl("gvRequisition");
        var hasSelected = false;

        if (grid) {
            var checkboxes = grid.querySelectorAll("input[type='checkbox'][id$='chkSelect']");
            for (var i = 0; i < checkboxes.length; i++) {
                if (!checkboxes[i].disabled && checkboxes[i].checked) {
                    hasSelected = true;
                    break;
                }
            }
        }

        var lblError = getRmControl("lblErrorMessage");

        if (!hasSelected) {
            if (typeof rmFailValidation === "function") {
                return rmFailValidation("Please select at least one pending requisition to approve.");
            }
            alert("Please select at least one pending requisition to approve.");
            return false;
        }

        if (lblError) {
            lblError.innerHTML = "";
        }

        return rmConfirmPostback("btnApprove", "approve");
    } catch (ex) {
        return rmConfirmPostback("btnApprove", "approve");
    }
}
