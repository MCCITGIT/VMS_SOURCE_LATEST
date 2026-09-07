//'**************************************************
//'Copyright	: Berger, MCC, KOLKATA
//'Source	    : Scripts/ValidationAddUpdateIndentEntry.js
//'Created Date	: 21-Dec-2011
//'Created By	: Rohan Mazumdar
//'Version	    : R02.00.00
//'Description	: 

//'Modified By       Modified On       Version         Reason

//'*************************************************************


// JScript File
var errMsg = "";
function validateSKUList()
{

    var theGridView = document.getElementById('gvIndentSKUList');

    var flag = 0;
    firstErrorControl = "";

    var txtNewLoad_id = null;

    document.getElementById("lblErrorMessage").innerHTML = "";

    errMsg = "";

    ValidateDropDown("ddlDepot", "Please Select a Depot.");
    ValidateDropDown("ddlVendorUnit", "Please Select Vendor Unit.");
    ValidateDropDown("ddlVendorProduct", "Please Select Product.")
    
    if (theGridView != null) 
    {

        for (var rowCount = 1; rowCount < theGridView.rows.length; rowCount++)
        {
            theGridView.rows(rowCount).cells(9).children(0).style.backgroundColor = "#ffffff";
        }
    
        for (var rowCount = 1; rowCount < theGridView.rows.length; rowCount++) {
            txtNewLoad_id = theGridView.rows(rowCount).cells(8).children(0).id;

            if (lTrim(document.getElementById(txtNewLoad_id).value, " ") != "0") {
                flag = 1;
                break;
            }
        }
    }
    if (flag == 0 || errMsg != "")
    {
        //document.getElementById("lblErrorMessage").innerHTML = "Atleast one entry should be non zero.";
        if (flag == 0) {
            firstErrorControl = theGridView;
            errMsg += "Atleast one entry should be non zero.";
        }
        document.getElementById("lblErrorMessage").innerHTML = "<table style='width:100%;'>" + errMsg + "</table>";
        return false;
    }
    else
    {
        var txtLoad_id = null;
        var justification = null;

        var flag1 = 0;
        
        for (var rowCount = 1; rowCount < theGridView.rows.length; rowCount++)
        {
            txtLoad_id = theGridView.rows(rowCount).cells(8).children(0).id;

            if (lTrim(document.getElementById(txtLoad_id).value, " ") != "0")
            {
                justification = theGridView.rows(rowCount).cells(9).children(0).id;
                if (ValidateRequired(justification, "Enter justification for additional load.")==false)
                {
                    flag1 = 1;
                }
            }
        }

        if (flag1 == 0)
        {
            if (confirm('Are you sure to submit?')) 
            {
                document.getElementById('btnSubmit').disabled = true;
                __doPostBack(document.getElementById('btnSubmit').name, '');

            }
            else 
            {
                return false;
            }
        }
        else
        {
            document.getElementById("lblErrorMessage").innerHTML = "<table>" + errMsg + "</table>";
            return false;
        }
    }

}

function lTrim(source, target) {
    var Count = 0;
    var strTrim;
    var retVal;

    if (source.length < 2) {
        return (source);
    } else if (target.length > 1) {
        return (target);
    } else if (left(source, 1) != target) {
        return (source);
    }

    // Trim the left side of string
    while (source.substring(Count, Count + 1) == target || Count == source.length) {
        Count = Count + 1
    }

    return (source.substring(Count, source.length));
}

function left(source, len) {
    var strImage;

    if (isNaN(len)) {
        strImage = source;
    } else {
        strImage = source.substring(0, len);
    }

    return (strImage);
}


function calculatePercentage(tsl, depot_indent_nop, percent_label, indent_nop) 
{
   var percent = 0;

   if (parseInt(tsl) != 0)
   {
       if (document.getElementById(indent_nop).value != "") 
       {
           percent = Math.round(((parseInt(depot_indent_nop) + parseInt(document.getElementById(indent_nop).value))) * 100 / tsl);

           if (percent > 70)
           {
               //alert("Invalid Entry. Indent to Estimate % exceeded 70%.");
               //document.getElementById(indent_nop).style.backgroundColor = "yellow";
               //document.getElementById(indent_nop).focus();
               document.getElementById(percent_label).innerHTML = percent.toString() + " %";
               document.getElementById(indent_nop).style.backgroundColor = "";
               AddTotalLtrKg()
               return true;
               //return false;
           }
           else
           {
               document.getElementById(percent_label).innerHTML = percent.toString() + " %";
               document.getElementById(indent_nop).style.backgroundColor = "";
               AddTotalLtrKg()
               return true;
           }           
       }
       else 
       {
           document.getElementById(indent_nop).value = "0";
           percent = Math.round(((parseInt(depot_indent_nop) + 0)) * 100 / tsl);
           document.getElementById(percent_label).innerHTML = percent.toString() + " %";

           if (percent > 70)
           {
//               alert("Invalid Entry. Indent to Estimate % exceeded 70%.");
//               document.getElementById(indent_nop).style.backgroundColor = "yellow";
//               document.getElementById(indent_nop).focus();
               //               return false;

               document.getElementById(percent_label).innerHTML = percent.toString() + " %";
               document.getElementById(indent_nop).style.backgroundColor = "";
               AddTotalLtrKg()
               return true;
           }
           else
           {
               document.getElementById(percent_label).innerHTML = percent.toString() + " %";
               document.getElementById(indent_nop).style.backgroundColor = "";
               AddTotalLtrKg()
               return true;
           }
       }
   }

   AddTotalLtrKg()
}


function AddTotalLtrKg() {
    var Grid = document.getElementById('gvIndentSKUList');
    var rowcount = Grid.rows.length - 1;
    var txt, hdnUom, hdnPackSize;
    
    var totValLtr = 0;
    var totValKg = 0;
    
    for (var rowno = 1; rowno < Grid.rows.length; rowno++) {
        try {
            txt = Grid.rows[rowno].cells[8].children[0].children[1].id;
            hdnUom = Grid.rows[rowno].cells[1].children[0].children[2].id;
            hdnPackSize = Grid.rows[rowno].cells[1].children[0].children[3].id;
        }
        catch (e) {
            txt = Grid.rows[rowno].cells[8].children[0].id;
            hdnUom = Grid.rows[rowno].cells[1].children[2].id;
            hdnPackSize = Grid.rows[rowno].cells[1].children[3].id;
        }
        var uom = document.getElementById(hdnUom).value;
        var packSize = parseFloat(document.getElementById(hdnPackSize).value);
        var enteredVal;
        
        try {
            enteredVal = parseFloat(document.getElementById(txt).value);
        }
        catch (e) {
            enteredVal = 0;
        }
        if (uom == "K") {
            totValKg = totValKg + (enteredVal * packSize);
        }
        if (uom == "L") {
            totValLtr = totValLtr + (enteredVal * packSize);
        }
    }
             document.getElementById('lblTotKg').innerHTML = totValKg;
            document.getElementById('lblTotLtr').innerHTML = totValLtr;

   
}
function validateSKUList_vr1() {
    debugger;
    // ddlDepot / ddlVendorUnit use ClientIDMode="Static" on AddUpdateIndentEntry_HO.aspx
    var ddlDepotId = "ddlDepot";
    var ddlVendorUnitId = "ddlVendorUnit";
    var theGridView = document.getElementById('ctl00_ContentPlaceHolder1_gvIndentSKUList')
        || document.getElementById('gvIndentSKUList');
    var lblErrorMessage = document.getElementById("ctl00_ContentPlaceHolder1_lblErrorMessage")
        || document.getElementById("lblErrorMessage");
    var flag = 0;
    var flag1 = 0;
    firstErrorControl = "";
    var txtNewLoad_id = null;
    if (lblErrorMessage) {
        lblErrorMessage.innerHTML = "";
    }

    errMsg = "";
    var allowedExtensions = [".xls", ".xlsx", ".pdf", ".jpg", ".jpeg", ".png", ".gif", ".eml", ".msg"];

    
    if (ValidateRequired(ddlDepotId, "Please Select a Depot.<br/>")) {
        var select = document.querySelector("#" + ddlDepotId + "+ .select2-container .selection .select2-selection");
        if (select != null) {
            select.style.backgroundColor = "white";
        }
    }
    else {
        firstErrorControl = ddlDepotId;
        var select = document.querySelector("#" + ddlDepotId + "+ .select2-container .selection .select2-selection");
        if (select != null) {
            select.style.backgroundColor = "yellow";
        }
    }
    if (ValidateRequired(ddlVendorUnitId, "Please Select Vendor Unit.<br/>")) {
        var select = document.querySelector("#" + ddlVendorUnitId + "+ .select2-container .selection .select2-selection");
        if (select != null) {
            select.style.backgroundColor = "white";
        }
    }
    else {
        firstErrorControl = ddlVendorUnitId;
        var select = document.querySelector("#" + ddlVendorUnitId + "+ .select2-container .selection .select2-selection");
        if (select != null) {
            select.style.backgroundColor = "yellow";
        }
    }


    if (theGridView != null) {
        // Loop through GridView rows (skip header row)
        for (var rowCount = 1; rowCount < theGridView.rows.length; rowCount++) {
            var row = theGridView.rows[rowCount];
            if (!row || row.cells.length < 10) continue;

            var txtCell = row.cells[8]; // column with quantity textbox
            var reasonCell = row.cells[9]; // column with dropdown + fileupload
            if (!txtCell || txtCell.children.length === 0) continue;

            var txtLoadCtrl = txtCell.children[0];
            if (!txtLoadCtrl) continue;

            var txtValue = lTrim(txtLoadCtrl.value, " ");

            // Check only if quantity is non-zero
            if (txtValue !== "0" && txtValue !== "") {
                flag = 1;

                // --- Find dropdown (Reason) safely ---
                var ddl = reasonCell ? reasonCell.querySelector("select") : null;
                var selectedValue = ddl ? ddl.options[ddl.selectedIndex].value : "";

                // --- Find FileUpload safely ---
                var fileUpload = reasonCell ? reasonCell.querySelector("input[type='file']") : null;
                //debugger;
                var fileName = fileUpload ? fileUpload.value : "";

                // --- Validate dropdown ---
                if (ddl) {
                    if (ValidateRequired(ddl.id, "Please Select Reason.") === false) {
                        flag1 = 1;
                        if (firstErrorControl === "") firstErrorControl = ddl.id;
                    }
                }

                // --- File required only for AsPerPlan ---
                if (selectedValue === "AsPerPlan") {
                    if (!fileUpload || fileName.trim() === "") {
                        errMsg += "Attachment is mandatory for AsPerPlanner Decision/Load Distribution.<br/>";
                        flag1 = 1;
                        if (firstErrorControl === "" && ddl) firstErrorControl = ddl.id;
                    } else {
                        // --- Validate file extension ---
                        var lowerFileName = fileName.toLowerCase();
                        var isValidExtension = allowedExtensions.some(ext => lowerFileName.endsWith(ext));

                        if (!isValidExtension) {
                            errMsg += "Invalid file type. Allowed types are: XLS, XLSX, PDF, JPG, JPEG, PNG,DOC,GIF.<br/>";
                            flag1 = 1;
                            if (firstErrorControl === "" && fileUpload) firstErrorControl = fileUpload.id;
                        }
                    }
                }
            }
        }
    }

    // --- Final validation summary ---
    if (flag === 0) {
        errMsg += "Please enter at least one Quantity greater than 0.<br/>";
    }
    if (flag1 === 1 || flag === 0 || errMsg != "") {
        if (lblErrorMessage) {
            lblErrorMessage.innerHTML = errMsg;
        }
        if (firstErrorControl !== "" && document.getElementById(firstErrorControl)) {
            document.getElementById(firstErrorControl).focus();
        }
        return false;
    }
    var confirmSave = confirm("Are you sure you want to save this record?");
    if (!confirmSave) {
        return false; // cancel submission
    }

    return true; // proceed with submission
}