var firstErrorControl;
var errMsg;

function allowOnlyIntegerKey(evt) {
    var charCode = evt.which ? evt.which : evt.keyCode;
    if (charCode === 8 || charCode === 9 || charCode === 13 || charCode === 37 || charCode === 39 || charCode === 46) {
        return true;
    }
    return charCode >= 48 && charCode <= 57;
}

function sanitizeIntegerInput(control) {
    control.value = (control.value || "").replace(/[^0-9]/g, "");
}

function allowOnlyTextKey(evt) {
    var charCode = evt.which ? evt.which : evt.keyCode;
    if (charCode === 8 || charCode === 9 || charCode === 13 || charCode === 32 || charCode === 37 || charCode === 39 || charCode === 46) {
        return true;
    }
    return (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122);
}

function sanitizeTextInput(control) {
    control.value = (control.value || "").replace(/[^a-zA-Z ]/g, "");
}

function updateConsumptionRatioTotal() {
    var grid = document.getElementById("gdShadedtls");
    var ratioInputs = [];
    if (grid) {
        ratioInputs = grid.querySelectorAll("input[id$='txtratio']");
    } else {
        ratioInputs = document.querySelectorAll("input[id$='txtratio']");
    }
    var total = 0;

    for (var i = 0; i < ratioInputs.length; i++) {
        var rawValue = ratioInputs[i].value || "";
        var numValue = parseInt(rawValue.toString().replace(/[^0-9]/g, ""), 10);

        if (!isNaN(numValue)) {
            total += numValue;
        }
    }

    var totalLabel = document.getElementById("lblRatioTotal");
    var statusLabel = document.getElementById("lblRatioStatus");
    if (!totalLabel || !statusLabel) return;

    totalLabel.innerHTML = total + "%";
    if (total <= 100) {
        statusLabel.innerHTML = "Within 100%";
        statusLabel.style.color = "#28a745";
    } else {
        statusLabel.innerHTML = "Exceeds 100%";
        statusLabel.style.color = "#dc3545";
    }
}

function validateInputs() {
    firstErrorControl = "";
    errMsg = "";

    ValidateDropDown1("ddlBrand", "Please Select Brand.");
    if (document.getElementById("ddlvendor")) {
        ValidateDropDown1("ddlvendor", "Please select Vendor.");
    }
    ValidateDropDown1("ddlRawMat", "Please Select Raw Material.");
    if (!document.getElementById("hdnProductCode") || (document.getElementById("hdnProductCode").value || "").trim() === "") {
        if (firstErrorControl == "") {
            firstErrorControl = "txtProductSearch";
        }
        errMsg += GetErrorRow("txtProductSearch", "Please Select Product.");
    }

    var ratioInputs = document.querySelectorAll("#gdShadedtls input[id$='txtratio']");
    var measurementInputs = document.querySelectorAll("#gdShadedtls input[id$='txtmeasurement']");
    var hasAtLeastOneRecord = false;
    var totalRatio = 0;

    for (var i = 0; i < ratioInputs.length; i++) {
        var ratioValue = (ratioInputs[i].value || "").trim();
        var measurementValue = "";

        if (measurementInputs.length > i) {
            measurementValue = (measurementInputs[i].value || "").trim();
        }

        if (ratioValue !== "" || measurementValue !== "") {
            hasAtLeastOneRecord = true;

            if (ratioValue === "") {
                if (firstErrorControl == "") {
                    firstErrorControl = ratioInputs[i].id;
                }
                errMsg += GetErrorRow(ratioInputs[i].id, "Please enter Consumption Ratio.");
            }

            if (measurementValue === "") {
                if (firstErrorControl == "") {
                    firstErrorControl = measurementInputs.length > i ? measurementInputs[i].id : "gdShadedtls";
                }
                errMsg += GetErrorRow(measurementInputs.length > i ? measurementInputs[i].id : "gdShadedtls", "Please enter Unit of Measurement.");
            }

            if (ratioValue !== "") {
                var numericRatio = parseInt(ratioValue, 10);
                if (!isNaN(numericRatio)) {
                    totalRatio += numericRatio;
                }
            }
        }
    }

    if (!hasAtLeastOneRecord) {
        if (firstErrorControl == "") {
            firstErrorControl = "gdShadedtls";
        }
        errMsg += GetErrorRow("gdShadedtls", "Please enter at least one record in the grid.");
    }

    if (hasAtLeastOneRecord && totalRatio > 100) {
        if (firstErrorControl == "") {
            firstErrorControl = "gdShadedtls";
        }
        errMsg += GetErrorRow("gdShadedtls", "Total Consumption Ratio should not be greater than 100%.");
    }

    if (firstErrorControl != "") {
        SetControlFocus(firstErrorControl);
        return rmFailValidation(errMsg);
    }
    else {
        document.getElementById("lblErrorMessage").innerHTML = '';
        return rmConfirmPostback("btnSubmit", "submit");
    }
}

function getVendorRawMatGridRatioTotal() {
    var grid = document.getElementById("gvVendorRawMat");
    var total = 0;

    if (!grid) {
        return total;
    }

    var ratioLabels = grid.querySelectorAll("tbody tr.tlrowlight span[id$='lblRatio']");

    for (var i = 0; i < ratioLabels.length; i++) {
        var rawValue = (ratioLabels[i].innerText || ratioLabels[i].textContent || "").trim();
        var numValue = parseFloat(rawValue.replace(/[^0-9.]/g, ""));

        if (!isNaN(numValue)) {
            total += numValue;
        }
    }

    return Math.round(total * 100) / 100;
}

function updateVendorRawMatRatioTotal() {
    var total = getVendorRawMatGridRatioTotal();

    var totalLabel = document.getElementById("lblRatioTotal");
    var statusLabel = document.getElementById("lblRatioStatus");
    if (!totalLabel || !statusLabel) {
        return;
    }

    totalLabel.innerHTML = total.toFixed(2) + "%";
    if (total > 100) {
        statusLabel.innerHTML = "Exceed 100%";
        statusLabel.style.color = "#dc3545";
    } else {
        statusLabel.innerHTML = "Within 100%";
        statusLabel.style.color = "#28a745";
    }
}

document.addEventListener("DOMContentLoaded", function () {
    updateConsumptionRatioTotal();
    updateVendorRawMatRatioTotal();
});
function validateAddRawMaterial() {
    var hasError = false;
    var ddlBrand = document.getElementById("ddlBrand");
    var ddlvendor = document.getElementById("ddlvendor");
    var hdnProductCode = document.getElementById("hdnProductCode");
    var txtrawmatid = document.getElementById("txtrawmatid");
    var txtSearchText = document.getElementById("txtSearchText");
    var txtRatio = document.getElementById("txtRatio");
    var ratio = NaN;
    var totalRatio = getVendorRawMatGridRatioTotal();
    var lblErrorMessage = document.getElementById("lblErrorMessage");

    clearFormulationValidation();

    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    if (!ddlBrand || ddlBrand.value === "" || ddlBrand.selectedIndex <= 0) {
        setFieldError("ddlBrand", "valBrand", "Please select Brand.", false);
        hasError = true;
    }

    if (vendorUnitMissing(ddlvendor)) {
        setFieldError("ddlvendor", "valVendor", "Please select Vendor.", false);
        hasError = true;
    }

    if (!hdnProductCode || (hdnProductCode.value || "").trim() === "") {
        setFieldError("txtProductSearch", "valProduct", "Please enter Product.", false);
        hasError = true;
    }

    if (!txtSearchText || (txtSearchText.value || "").trim() === "") {
        setFieldError("txtSearchText", "valSearchText", "Please enter Raw Material.", false);
        hasError = true;
    } else if (!txtrawmatid || (txtrawmatid.value || "").trim() === "") {
        setFieldError("txtSearchText", "valSearchText", "Please select Raw Material from the list.", false);
        hasError = true;
    }

    if (!txtRatio || (txtRatio.value || "").trim() === "") {
        setFieldError("txtRatio", "valRatio", "Please enter Consumption Ratio.", false);
        hasError = true;
    } else {
        ratio = parseFloat((txtRatio.value || "").trim());

        if (isNaN(ratio)) {
            setFieldError("txtRatio", "valRatio", "Please enter a valid Consumption Ratio.", false);
            hasError = true;
        } else if (ratio <= 0) {
            setFieldError("txtRatio", "valRatio", "Consumption Ratio must be greater than 0.", false);
            hasError = true;
        } else {
            totalRatio = Math.round((totalRatio + ratio) * 100) / 100;
            if (totalRatio > 100) {
                setFieldError("txtRatio", "valRatio", "Total Consumption Ratio should not be greater than 100%.", false);
                hasError = true;
            }
        }
    }

    if (hasError) {
        scrollToFirstInvalidField();
        return false;
    }

    return rmConfirmPostback("btnAdd", "add");
}

function validateFormulationSubmit() {
    var hasError = false;
    var ddlBrand = document.getElementById("ddlBrand");
    var ddlvendor = document.getElementById("ddlvendor");
    var hdnProductCode = document.getElementById("hdnProductCode");
    var totalRatio = getVendorRawMatGridRatioTotal();
    var grid = document.getElementById("gvVendorRawMat");
    var ratioLabels = grid ? grid.querySelectorAll("tbody tr.tlrowlight span[id$='lblRatio']") : [];
    var lblErrorMessage = document.getElementById("lblErrorMessage");

    clearFormulationValidation();

    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    if (!ddlBrand || ddlBrand.value === "" || ddlBrand.selectedIndex <= 0) {
        setFieldError("ddlBrand", "valBrand", "Please select Brand.", false);
        hasError = true;
    }

    if (vendorUnitMissing(ddlvendor)) {
        setFieldError("ddlvendor", "valVendor", "Please select Vendor.", false);
        hasError = true;
    }

    if (!hdnProductCode || (hdnProductCode.value || "").trim() === "") {
        setFieldError("txtProductSearch", "valProduct", "Please enter Product.", false);
        hasError = true;
    }

    if (!ratioLabels || ratioLabels.length === 0) {
        setGridFieldError("Please enter at least one record in the grid.");
        hasError = true;
    } else if (totalRatio !== 100) {
        setGridFieldError("Total Consumption Ratio should be equal 100%.");
        hasError = true;
    }

    if (hasError) {
        scrollToFirstInvalidField();
        return false;
    }

    return rmConfirmPostback("btnSubmit", "submit");
}

function clearFieldValidation(controlId, labelId) {
    var control = document.getElementById(controlId);
    var label = document.getElementById(labelId);

    if (control) {
        control.classList.remove("field-invalid");
    }

    if (label) {
        label.innerHTML = "";
    }
}

function setFieldError(controlId, labelId, message, scrollToField) {
    var control = document.getElementById(controlId);
    var label = document.getElementById(labelId);

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

function clearRawMaterialValidation() {
    clearFieldValidation("txtSearchText", "valSearchText");
}

function clearRatioValidation() {
    clearFieldValidation("txtRatio", "valRatio");
}

function clearBrandValidation() {
    clearFieldValidation("ddlBrand", "valBrand");
}

/* true when no vendor is chosen. A vendor (UNIT) login has no Vendor dropdown on the page; its own unit comes from the hidden field (currentVendorUnit on the page). */
function vendorUnitMissing(ddlvendor) {
    if (ddlvendor) { return ddlvendor.value === "" || ddlvendor.selectedIndex <= 0; }
    return typeof currentVendorUnit !== "function" || currentVendorUnit() === "";
}

function clearVendorValidation() {
    clearFieldValidation("ddlvendor", "valVendor");
}

function clearProductValidation() {
    clearFieldValidation("txtProductSearch", "valProduct");
}

function clearGridValidation() {
    var label = document.getElementById("valGrid");
    if (label) {
        label.innerHTML = "";
    }
}

function setGridFieldError(message) {
    var label = document.getElementById("valGrid");

    if (label) {
        label.innerHTML = message;
    }
}

function clearFormulationValidation() {
    clearBrandValidation();
    clearVendorValidation();
    clearProductValidation();
    clearRawMaterialValidation();
    clearRatioValidation();
    clearGridValidation();
}

function scrollToFirstInvalidField() {
    var fields = [
        { controlId: "ddlBrand" },
        { controlId: "ddlvendor" },
        { controlId: "txtProductSearch" },
        { controlId: "txtSearchText" },
        { controlId: "txtRatio" }
    ];

    for (var i = 0; i < fields.length; i++) {
        var control = document.getElementById(fields[i].controlId);
        if (control && control.classList.contains("field-invalid") && control.scrollIntoView) {
            control.scrollIntoView({ behavior: "smooth", block: "center" });
            return;
        }
    }

    var valGrid = document.getElementById("valGrid");
    if (valGrid && valGrid.innerHTML) {
        var grid = document.getElementById("gvVendorRawMat");
        if (grid && grid.scrollIntoView) {
            grid.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    }
}