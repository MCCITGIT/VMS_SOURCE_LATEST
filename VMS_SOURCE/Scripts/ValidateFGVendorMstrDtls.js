function getFgVendorControl(controlId) {
    return document.getElementById(controlId) || document.querySelector("[id$='" + controlId + "']");
}

function clearFieldValidation(controlId, labelId) {
    var control = getFgVendorControl(controlId);
    var label = labelId ? getFgVendorControl(labelId) : null;

    if (control) {
        control.classList.remove("field-invalid");
    }

    if (label) {
        label.innerHTML = "";
    }
}

function setFieldError(controlId, labelId, message) {
    var control = getFgVendorControl(controlId);
    var label = labelId ? getFgVendorControl(labelId) : null;

    if (control) {
        control.classList.add("field-invalid");
    }

    if (label) {
        label.innerHTML = message;
    }

    if (control && control.scrollIntoView) {
        control.scrollIntoView({ behavior: "smooth", block: "center" });
    }
}

function clearSiteValidation() {
    clearFieldValidation("ddlsiteid", "valSite");
}

function getFieldValue(controlId) {
    var control = getFgVendorControl(controlId);
    return control ? (control.value || "").trim() : "";
}

function validateFGVendorSubmit() {
    clearSiteValidation();

    var lblErrorMessage = getFgVendorControl("lblErrorMessage");
    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    if (getFieldValue("ddlsiteid") === "") {
        setFieldError("ddlsiteid", "valSite", "Please select site.");
        return false;
    }

    var btn = getFgVendorControl("btnSubmit");
    if (typeof rmConfirmAction === "function") {
        return rmConfirmAction(btn, "submit");
    }

    return true;
}

function wireFgVendorValidationClear() {
    var ddlSite = getFgVendorControl("ddlsiteid");
    if (!ddlSite) {
        return;
    }

    ddlSite.addEventListener("change", clearSiteValidation);

    if (window.jQuery) {
        jQuery(ddlSite).off("select2:select.selectSiteVal select2:clear.selectSiteVal");
        jQuery(ddlSite).on("select2:select.selectSiteVal select2:clear.selectSiteVal", clearSiteValidation);
    }
}

if (window.Sys && Sys.Application) {
    Sys.Application.add_load(wireFgVendorValidationClear);
} else {
    document.addEventListener("DOMContentLoaded", wireFgVendorValidationClear);
}
