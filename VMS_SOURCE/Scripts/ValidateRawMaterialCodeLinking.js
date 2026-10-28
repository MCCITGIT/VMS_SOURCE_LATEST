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

function showCodeLinkPageLoader() {
    var progress = document.querySelector("[id$='updProgress']");
    if (progress) {
        progress.style.display = "block";
    }
}

function postBackCodeLinkWithLoader(button) {
    if (!button) {
        return false;
    }

    var target = button.name || "";
    if (!target) {
        var href = button.getAttribute("href") || "";
        var match = href.match(/__doPostBack\('([^']+)'/);
        target = match ? match[1] : "";
    }
    if (!target) {
        return false;
    }

    showCodeLinkPageLoader();
    window.setTimeout(function () {
        __doPostBack(target, "");
    }, 0);
    return false;
}

function searchCodeLinkWithLoader() {
    if (validateRawMaterialCodeLinkingSearch() === false) {
        return false;
    }

    return postBackCodeLinkWithLoader(document.getElementById("imgbtnSearch"));
}

function submitCodeLinkWithLoader() {
    if (validateRawMaterialCodeLinkingSubmit() === false) {
        return false;
    }

    return postBackCodeLinkWithLoader(document.getElementById("btnSubmit"));
}

function validateRawMaterialCodeLinkingSubmit() {
    var grid = document.getElementById("gvrawMatDetails");
    var valGrid = document.getElementById("valGrid");
    var rows = grid ? grid.querySelectorAll("tbody tr") : [];
    var hasValue = false;
    var firstOpen = null;

    for (var i = 0; i < rows.length; i++) {
        var chk = rows[i].querySelector("input[id*='chkBergerNotSold']");
        var ddl = rows[i].querySelector("select");
        if (ddl) {
            ddl.classList.remove("field-invalid");
        }
        if (chk && chk.checked) {
            hasValue = true;
            continue;
        }
        if (ddl && ddl.value && ddl.value.trim() !== "") {
            hasValue = true;
        } else if (!firstOpen && ddl) {
            firstOpen = ddl;
        }
    }

    if (!hasValue) {
        if (valGrid) {
            valGrid.innerHTML = "Please select Berger code for at least one raw material.";
        }
        if (firstOpen) {
            firstOpen.classList.add("field-invalid");
            firstOpen.scrollIntoView({ behavior: "smooth", block: "center" });
        }
        return false;
    }

    return true;
}
