//Riddhi
//20/12/2011 
var check = false;
var GridTotalRate = 0;

// Modified-by MUKESH BHAGAT on 07-09-2026 : under the redesigned MasterPage server controls
// render with the ctl00_ContentPlaceHolder1_ prefix, so every bare getElementById in this
// file returned null. Resolves the bare id first (backward compatible), then the mangled one.
function vmsEl(id) {
    return document.getElementById(id) || document.querySelector('[id$="_' + id + '"]');
}

function ValidateSubmit() {
 firstErrorControl = "";
    errMsg = "";
   debugger
    if (ValidateRequired("txtChallanDt", "Please Enter Challan Date")) {
        if (CheckDateFormat("txtChallanDt", "Date Format dd/mm/yyyy")) {
            ValidateGThanSystemDate("txtChallanDt", "Challan Date Can not be Greater than today")
        }
    }
    //ValidateDropDown("ddlLocation", "Please Select Depot")
   // ValidateCheckBoxList('chkbxListLocation', "Please select depot");
    let selectedValues = $('#chkbxListLocation').val() || [];
    if (selectedValues == "" || selectedValues == []) {
        firstErrorControl = 'chkbxListLocation';

        errMsg += GetErrorRow('chkbxListLocation', "Please select depot");

        SetErrorColor('chkbxListLocation', false);
    }
   

  //  ValidateDropDown('chkbxListLocation', "Please select depot");
    ValidateDropDown("ddlDeliveryDepot", "Please Select Delivery Depot")
    ValidateDropDown("ddlPONo", "Please Select PO No")
    ValidateDropDown("ddlSite", "Please Select Site Name")
    ValidateRequired("txtTransporter", "Please Enter Transporter Name")
    ValidateRequired("txtTruckNo", "Please Enter Truck No")
    ValidateRequired("txtCenvatNo", "Please Enter Vendor Challan No.")
    //ValidateRequired("txtRoadPermitNo", "Please Enter Road Permit No.")
    //ValidateRequired("sch_fld1", "Please Select a Document.")
    if (ValidateRequired("txtCenvatDt", "Please Enter Vendor Challan Date")) {
         if (CheckDateFormat("txtCenvatDt", "Date Format dd/mm/yyyy")) {
             ValidateGThanSystemDate("txtCenvatDt", "Cenvat Date Can not be Greater than today")
         }
    }
    check = false;
    GridTotalRate = 0;
    validateGrid()
    if (ValidateRequired("txtFinalInvoiceValue", "Please Enter Final Invoice Value (After Tax).")) {
        //let InvoiceRate = document.getElementById("txtFinalInvoiceValue").value;
        //GridTotalRate = GridTotalRate.toFixed(2);
        //if (parseFloat(GridTotalRate) > parseFloat(InvoiceRate)) {
        //    firstErrorControl = "txtFinalInvoiceValue";
        //    errMsg += GetErrorRow("txtFinalInvoiceValue", "Total Rate (Ind. GST) can not be greater than Final Invoice Value.");
        //    SetErrorColor("txtFinalInvoiceValue", false);
        //}
    }
    if (check == false) {
        return false

    }
         if (firstErrorControl != "") {
          SetControlFocus(firstErrorControl);
          errMsg = "<table>" + errMsg + "</table>";
          //         document.getElementById("divErrorMessage").innerHTML = errMsg;
          //         document.getElementById("lblErrorMessage").innerHTML = "";CheckDateFormat 
          document.getElementById("lblErrorMessage").innerHTML = errMsg

          return false;
      }
      else {
          var n = vmsEl('btnSubmit').value;
          //         if ((document.getElementById("lblErrorMessage").innerHTML == '' ) {
          if (vmsEl('hdnNoMaster').value == 'Y') {
               alert("No Transit day found for this Depot .Please kindly intimate HO")
          }
          if (confirm('Are you sure to Submit?')) {
              vmsEl('btnSubmit').disabled = true;
              __doPostBack(vmsEl('btnSubmit').name, '');
              document.getElementById("lblErrorMessage").innerHTML = ''
          }
          else {
              return false;
          }
      } 

}


function validateGrid() {

   
    var Grid = vmsEl('gvSKUDetails');
    if (!Grid || !Grid.rows) { return true; }
    var rowcount = Grid.rows.length - 1;
  
    for (var rowno = 1; rowno < Grid.rows.length-1; rowno++) {
        var chk = Grid.rows[rowno].cells[1].children[0].id;
        var txt = Grid.rows[rowno].cells[10].children[0].id;
        var lbl = Grid.rows[rowno].cells[11].children[0].id;
        var txtLot = Grid.rows[rowno].cells[12].children[0].id;
        let hdnSkuRate = Grid.rows[rowno].cells[1].children[7].id;
        let hdnSkuGST = Grid.rows[rowno].cells[1].children[8].id;
            if (document.getElementById(chk).checked) {
                if (ValidateRequired(txt, "Please Enter This Despatch")) {

                    let qty = document.getElementById(txt).value;
                    let rate = document.getElementById(hdnSkuRate).value;
                    let gst = document.getElementById(hdnSkuGST).value;
                    let totalAmt = parseFloat(qty) * parseFloat(rate);
                   
                    GridTotalRate = parseFloat(GridTotalRate) + parseFloat(totalAmt + (totalAmt * (parseFloat(gst) / 100)))
                }
                ValidateRequired(txtLot, "Invalid LOT")
            check=true 
        }

    }
    if (check == false) {
        alert("Please Select atleast one SKU")
    }
}


function RowCheck(chk, txt, txtLotNo, hdnSkuRate, hdnSkuGST, lblTotalRate) {
    var checkBox = document.getElementById(chk);
    var textBox = document.getElementById(txt);
    if (checkBox.checked) {
        textBox.disabled = false
        textBox.focus()
             
         var txtDate;
         txtDate = vmsEl('txtChallanDt').value;
         var DD = txtDate.substring(0, 2);
         var MM = txtDate.substring(3, 5);
         var YYYY = txtDate.substring(6, 10);
         var UnitOracleId = vmsEl('hdnUnitOracleId').value;
         var PONo = vmsEl('ddlPONo').value;
         var lotNo = "IND-" + UnitOracleId + "-" + PONo + "-" + DD + "-" + MM + "-" + YYYY;

         document.getElementById(txtLotNo).value = lotNo;


         let qty = document.getElementById(txt).value;
         let rate = document.getElementById(hdnSkuRate).value;
         let gst = document.getElementById(hdnSkuGST).value;

         let totalAmt = parseFloat(qty) * parseFloat(rate)
         let totalAmtWithGST = totalAmt + (totalAmt * (parseFloat(gst) / 100))
         totalAmtWithGST = totalAmtWithGST.toFixed(2);
         document.getElementById(lblTotalRate).innerHTML = totalAmtWithGST;
    }
    else {
        textBox.disabled = true
        document.getElementById(txtLotNo).value = "";
        document.getElementById(lblTotalRate).innerHTML = "";
    }
    GridSummation();
}

function CheckMaxLimit(txt, lbl, hdnSkuRate, hdnSkuGST, lblTotalRate) {
    debugger
    var textBox = document.getElementById(txt);
    var label = document.getElementById(lbl);
    var pendingLoad = parseFloat(label.innerHTML);
    var enterdValue = parseFloat(textBox.value);
    var maxLimit = parseFloat(vmsEl('hdnMaxDespLimit').value);
    debugger;
    console.log('maxLimit:', maxLimit);
    var maxVal = parseFloat(pendingLoad + (pendingLoad * maxLimit / 100));


    let qty = document.getElementById(txt).value;
    let rate = document.getElementById(hdnSkuRate).value;
    let gst = document.getElementById(hdnSkuGST).value;

    let totalAmt = parseFloat(qty) * parseFloat(rate)
    let totalAmtWithGST = totalAmt + (totalAmt * (parseFloat(gst) / 100))
    totalAmtWithGST = totalAmtWithGST.toFixed(2);
    document.getElementById(lblTotalRate).innerHTML = totalAmtWithGST;
    if (pendingLoad==0) {
        alert('Pending Despatch NOP Value Is Zero');
        document.getElementById(txt).value = '';
        document.getElementById(lblTotalRate).innerHTML = '';
    }
    else if (enterdValue > maxVal && pendingLoad != 0) {
        alert('Despatch NOP Exceeds Maximum Limit');
        document.getElementById(txt).value = '';
        document.getElementById(lblTotalRate).innerHTML = '';
    }
    else if (enterdValue < 0) {
        alert('Despatch NOP Cannot Be Negative');
        document.getElementById(txt).value = '';
        document.getElementById(lblTotalRate).innerHTML = '';
    }
 
    GridSummation();
}

function GridSummation() {

    // Modified-by MUKESH BHAGAT on 07-09-2026 : under the redesigned MasterPage the grid
    // renders as ctl00_ContentPlaceHolder1_gvSKUDetails, so the bare id returned null and
    // this threw "Cannot read properties of null (reading 'rows')". Resolve either id, and
    // bail out quietly when the grid has no rows (GridView renders no table at all then).
    var Grid = vmsEl('gvSKUDetails');
    console.log('Grid:', Grid);
    if (!Grid || !Grid.rows) { return; }
    var rowcount = Grid.rows.length - 1;
    let totalAmtWithGST = 0;
    let totalQty = 0;
    for (var rowno = 1; rowno < Grid.rows.length; rowno++) {
        if (rowno <= Grid.rows.length - 2) {
            var chk = Grid.rows[rowno].cells[1].children[0].id;
            var txt = Grid.rows[rowno].cells[10].children[0].id;
            var lbl = Grid.rows[rowno].cells[11].children[0].id;
            var txtLot = Grid.rows[rowno].cells[12].children[0].id;
            let hdnSkuRate = Grid.rows[rowno].cells[1].children[7].id;
            let hdnSkuGST = Grid.rows[rowno].cells[1].children[8].id;
           
            if (document.getElementById(chk).checked) {

                let qty = document.getElementById(txt).value;
                let rate = document.getElementById(hdnSkuRate).value;
                let gst = document.getElementById(hdnSkuGST).value;

                let totalAmt = parseFloat(qty) * parseFloat(rate)
                totalQty = totalQty + parseInt(qty);
                totalAmtWithGST = totalAmtWithGST + (totalAmt + (totalAmt * (parseFloat(gst) / 100)))
                document.getElementById(lbl).innerHTML = (totalAmt + (totalAmt * (parseFloat(gst) / 100))).toFixed(2);
                
            }
        }
        else if (rowno = Grid.rows.length-1) {

            let Qtylbl = Grid.rows[rowno].cells[10].children[0].id;
            let Ratelbl = Grid.rows[rowno].cells[11].children[0].id;
            
            document.getElementById(Qtylbl).innerHTML = totalQty;
            document.getElementById(Ratelbl).innerHTML = totalAmtWithGST.toFixed(2);

        }
       

    }
   
}