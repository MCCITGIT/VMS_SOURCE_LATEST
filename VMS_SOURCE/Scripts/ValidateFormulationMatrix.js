function clearProductValidation() {
    var control = document.getElementById("txtProductSearch");
    var label = document.getElementById("valProductSearch");

    if (control) {
        control.classList.remove("field-invalid");
    }

    if (label) {
        label.innerHTML = "";
    }
}

function setProductFieldError(message) {
    var control = document.getElementById("txtProductSearch");
    var label = document.getElementById("valProductSearch");

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

function clearGridValidation() {
    var label = document.getElementById("valGrid");
    var grid = document.getElementById("gvFormulationMatrix");

    if (label) {
        label.innerHTML = "";
    }

    if (grid) {
        var rateInputs = grid.querySelectorAll("input[id$='txtRate']");
        for (var i = 0; i < rateInputs.length; i++) {
            rateInputs[i].classList.remove("field-invalid");
        }
    }
}

function setGridFieldError(message, rateInput) {
    var label = document.getElementById("valGrid");
    var grid = document.getElementById("gvFormulationMatrix");

    clearGridValidation();

    if (label) {
        label.innerHTML = message;
    }

    if (rateInput) {
        rateInput.classList.add("field-invalid");
        if (rateInput.scrollIntoView) {
            rateInput.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    } else if (grid && grid.scrollIntoView) {
        grid.scrollIntoView({ behavior: "smooth", block: "center" });
    }
}

function clearFormulationMatrixValidation() {
    clearProductValidation();
    clearGridValidation();
}

function validateProductSearch() {
    var txtProductSearch = document.getElementById("txtProductSearch");
    var hdnProductCode = document.getElementById("hdnProductCode");
    var hdnSkucode = document.getElementById("hdnSkucode");

    clearFormulationMatrixValidation();

    if (!txtProductSearch || txtProductSearch.value.trim() === "") {
        setProductFieldError("Please enter Product name.");
        return false;
    }

    var productCode = hdnProductCode ? (hdnProductCode.value || "").trim() : "";
    var skuCode = hdnSkucode ? (hdnSkucode.value || "").trim() : "";

    if (productCode === "" && skuCode === "") {
        setProductFieldError("Please select Product from the list.");
        return false;
    }

    var lblErrorMessage = document.getElementById("lblErrorMessage");
    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    return true;
}

function validateFormulationMatrixSubmit() {
    var hdnProductCode = document.getElementById("hdnProductCode");
    var hdnSkucode = document.getElementById("hdnSkucode");
    var grid = document.getElementById("gvFormulationMatrix");
    var rateInputs = grid ? grid.querySelectorAll("input[id$='txtRate']") : [];
    var submitBtn = document.getElementById("btnSubmit");
    var txtProductSearch = document.getElementById("txtProductSearch");

    clearFormulationMatrixValidation();

    if (!txtProductSearch || txtProductSearch.value.trim() === "") {
        setProductFieldError("Please enter Product name.");
        return false;
    }

    var productCode = hdnProductCode ? (hdnProductCode.value || "").trim() : "";
    var skuCode = hdnSkucode ? (hdnSkucode.value || "").trim() : "";

    if (productCode === "" && skuCode === "") {
        setProductFieldError("Please select Product from the list.");
        return false;
    }

    if (!rateInputs || rateInputs.length === 0) {
        setGridFieldError("No formulation details found for the selected product.");
        return false;
    }

    for (var i = 0; i < rateInputs.length; i++) {
        var rateValue = (rateInputs[i].value || "").trim();

        if (rateValue === "") {
            setGridFieldError("Please enter Rate for all raw materials.", rateInputs[i]);
            return false;
        }

        var numericRate = parseFloat(rateValue);
        if (isNaN(numericRate) || numericRate <= 0) {
            setGridFieldError("Please enter a valid Rate greater than 0.", rateInputs[i]);
            return false;
        }
    }

    var lblErrorMessage = document.getElementById("lblErrorMessage");
    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    var buttonText = submitBtn ? ((submitBtn.value || "") + "").toLowerCase() : "submit";
    return rmConfirmAction(submitBtn, buttonText.indexOf("update") >= 0 ? "update" : "submit");
}

function validateFormulationMatrixUpdate(el) {
    var source = el || (window.event ? window.event.srcElement : null);
    if (source && source.closest) {
        source = source.closest("a") || source;
    }

    var row = source ? source.closest("tr") : null;
    var rateInput = row ? row.querySelector("input[id$='txtRate']") : null;
    var rateValue = rateInput ? (rateInput.value || "").trim() : "";

    clearGridValidation();

    if (rateValue === "") {
        setGridFieldError("Please enter Rate.", rateInput);
        return false;
    }

    var numericRate = parseFloat(rateValue);
    if (isNaN(numericRate) || numericRate <= 0) {
        setGridFieldError("Please enter a valid Rate greater than 0.", rateInput);
        return false;
    }

    var hdnId = row ? row.querySelector("input[id$='hdnId']") : null;
    var matrixId = hdnId ? parseInt(hdnId.value || "0", 10) : 0;
    return rmConfirmAction(source, matrixId > 0 ? "update" : "submit");
}
