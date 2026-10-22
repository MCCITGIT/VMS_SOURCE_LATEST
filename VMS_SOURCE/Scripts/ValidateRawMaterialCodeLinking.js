function clearRawMatValidation() {
    var control = document.getElementById("txtSearchText");
    var label = document.getElementById("valSearchText");

    if (control) {
        control.classList.remove("field-invalid");
    }

    if (label) {
        label.innerHTML = "";
    }
}

function clearCodeLinkGridFieldValidation(control) {
    if (control) {
        control.classList.remove("field-invalid");
    }

    var valGrid = document.getElementById("valGrid");
    if (valGrid) {
        valGrid.innerHTML = "";
    }
}

function validateRawMaterialCodeLinkingSearch() {
    clearRawMatValidation();

    var lblErrorMessage = document.getElementById("lblErrorMessage");
    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    return true;
}

function validateRawMaterialCodeLinkingSubmit() {
    var valGrid = document.getElementById("valGrid");
    if (valGrid) {
        valGrid.innerHTML = "";
    }

    var grid = document.getElementById("gvrawMatDetails");
    if (!grid) {
        if (valGrid) {
            valGrid.innerHTML = "No raw material records available to submit.";
        }
        return false;
    }

    var bergerInputs = grid.querySelectorAll("input[id*='txtBergerCode']");
    var hasValue = false;

    for (var i = 0; i < bergerInputs.length; i++) {
        bergerInputs[i].classList.remove("field-invalid");
        if (bergerInputs[i].value && bergerInputs[i].value.trim() !== "") {
            hasValue = true;
        }
    }

    if (!hasValue) {
        if (valGrid) {
            valGrid.innerHTML = "Please enter Berger code for at least one raw material.";
        }
        if (bergerInputs.length > 0) {
            bergerInputs[0].classList.add("field-invalid");
            bergerInputs[0].scrollIntoView({ behavior: "smooth", block: "center" });
        }
        return false;
    }

    return rmConfirmPostback("btnSubmit", "submit");
}
