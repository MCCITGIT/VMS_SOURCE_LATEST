
var firstErrorControl;
var errMsg;
function validateVendorPoDepotLink() {

    firstErrorControl = "";
    errMsg = "";
    ValidateDropDown1("ddlvendor", "Please Select Vendor.");
    ValidateDropDown1("ddlPoNo", "Please Select PO No.");
    ValidateCheckBoxList("chkbxListApplDepots", "select atleast one Depot.");

    if (firstErrorControl != "") {
        SetControlFocus(firstErrorControl);
        errMsg = "<table>" + errMsg + "</table>";
        document.getElementById("lblErrorMessage").innerHTML = errMsg;
        return false;
    }
    else {

        document.getElementById("lblErrorMessage").innerHTML = '';
        if (confirm("Are you sure to submit?")) {
            document.getElementById("btnSubmit").disabled = true;
            __doPostBack(document.getElementById("btnSubmit").name, '');
            return false;
        }
        else {
            return false;
        }
    }
}

function searchText() {
    clearSearch();
    var searchtxt = document.getElementById('searchInput').value;
    var checkboxList = document.getElementById('chkbxListApplDepots');
    if (checkboxList == null || searchtxt == "") {
        return;
    }
    var searchExp = new RegExp(escapeRegExp(searchtxt), 'i');

    var labels = checkboxList.getElementsByTagName('label');
    for (var i = 0; i < labels.length; i++) {
        var labelText = labels[i].textContent;
        if (searchExp.test(labelText)) {
            labels[i].innerHTML = labelText.replace(searchExp, '<span class="highlight">$&</span>');
            labels[i].scrollIntoView({ behavior: 'smooth', block: 'center' });
            break;
        }
    }
    var inputElement = document.getElementById('searchInput');
    inputElement.focus();
}

function clearSearch() {
    var content = document.getElementById('chkbxListApplDepots');
    if (content == null) {
        return;
    }
    var html = content.innerHTML;
    html = html.replace(/<span class="highlight">|<\/span>/gi, '');
    content.innerHTML = html;
}

function escapeRegExp(text) {
    return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
