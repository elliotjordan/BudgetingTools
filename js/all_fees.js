/*************************************************
 * Indiana University Budget Office
 *   Budgeting Tools - AllFees Master List page
 *   Version: 0.1  Aug 2018
 *   Author: John Burgoon 
 *   Author email: budujwb@iu.edu
 *   Created: October 6, 2017
 ************************************************/
function newAccountEntry() {
	if ( $('#account_select option:selected').val() === 'create' )  {
		if ( $('#new_acct_input').is(":hidden") ) {
				//console.log("Is.HIDDEN triggered");
				$('#new_acct_input').show();
			} else {
				//console.log("ELSE TRIGGERED");
				$('#account_select option[id="new_acct"]').text($('#new_acct_input').val());
				$('#account_select option[id="new_acct"]').prop('value', $('#new_acct_input').val());
				$('#account_select').val( $('#new_acct_input').val() );
				$('#undo_new_acct').show();
			}
		}	
	if ( $('#account_select option:selected').val() != 'create' ){
		$('#new_acct_input').hide();
	}
}

function undoNewAccountNumber() {  //I need to learn to simply append new requests to the SELECT tool instead of overwriting.  TODO!
	$('#account_select option[id="new_acct"]').text("-- Enter a new account --");
	$('#account_select option[id="new_acct"]').prop('value','create');
	$('#account_select').val('create');
	$('#new_acct_input').show();	
	$('#undo_new_acct').hide();
	//console.log("GARBAGE: " + $('#account_select option:selected').val() );
}

function twoPctBtn() {
	//console.log("twoPctBtn clicked\n");
	$("tr[name='feeRow']").toggle();
	$('#twoPctBtn').toggleClass("twopctOn twopctOff");
}

function newFeeBtn(age) {
	//console.log("newFeeBtn clicked\n");
	$("tr").not(".newFee").toggle();
	$('#newFeeBtn').toggleClass("newFeeOn newFeeOff");
}

function feeTypeToggle() {
	if ( $('#type_select option:selected').val() != 'false' ) {
	var current_case = $('#type_select option:selected').val();
		switch ( $('#type_select option:selected').val().split("_").shift() ) {
			case "1": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "2": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "3": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "4": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "5": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "6": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "7": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "8": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "9": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			case "10": 		
				console.log( $("#type_select option[value='10']").text() );
				break;
			case "11": 		
				console.log( $("#type_select option[value="+current_case+"]").text() );
				break;
			default: 
				console.log( "DEFAULT: " + $('#type_select option:selected').val().split("_").shift() );
			
		}
	}
}

function dynOrgToggle() {
	if ( $('#dynOrg_checkbox').is(":checked") ) {
		$('#dynOrg_checkbox').val("1");
		$('#acct_org_inputs').hide();
		$('#dynOrg_state_label').text("Yes");
	} else {
		$('#dynOrg_checkbox').val("0");
		$('#acct_org_inputs').show();
		$('#dynOrg_state_label').text("No");
	}
}

function replacementFeeToggle() {
	if ( $('#replacement_checkbox').is(":checked") ) {
		$('#fee_select_inputs').show();
		$('#replCkbox_state_label').text("Yes");
	} else {
		$('#fee_select_inputs').hide();
		$('#replCkbox_state_label').text("No");
	}
}

function newFeeButton() {
	if ( $('#type_select').val() != "false" ){
		$('#SubmitBtn1').prop('disabled', false);
	}
	if ( $('#type_select').val() == "false" ){
		$('#SubmitBtn1').prop('disabled', true);
	}	
}

function approvalButton() {
	var approvalSensor = 0;
	$('.approval_dropdown').each(function(i,j) {
		if ( j.value != "false" ){
			approvalSensor+= 1;
		}
	});
	
	if (approvalSensor > 0) {
		$('#SubmitBtn4').prop('disabled', false);
	} else {
		$('#SubmitBtn4').prop('disabled', true);
	}
}

function blanketApproval() {
	$('#approve_all_cb').each(function(i,j) {
		if ($('[name=approve_all_cb]').is(":checked")) {
			$('[name=FEE_STATUS]').val("Campus Approved");
		} else {
			$('[name=FEE_STATUS]').val("false");			
		}
	})
}

function blanketApproval_over2pct() {
	//console.log("special_approve_all_cb checked\n");
	$('#approve_all_cb').each(function(i,j) {
		if ($('[name=special_approve_all_cb]').is(":checked")) {
			$('.special_FEE_STATUS').val("CFO Approved");
		} else {
			$('.special_FEE_STATUS').val("false");			
		}
	})
}

function blanketApproval_under_2pct() {
	$('#approve_all_cb').each(function(i,j) {
		if ($('[name=cfo_approve_all_cb]').is(":checked")) {
			$('.under_FEE_STATUS').val("CFO Approved");
		} else {
			$('.under_FEE_STATUS').val("false");			
		}
	})
}
function setupPctIncrease() {
	// check to see if we are on the fee_change_request.cfm
	var page = window.location.pathname;
//	console.log("CURRENT PAGE: " + page);
	if (page == '/BudgetingTools/AllFees/fee_change_request.cfm') {
		var current_year = $('#current_amt').val();
		var YR1 = $('#YR1_amount_field').val();
		var YR2 = $('#YR2_amount_field').val();
		
		if (current_year == 0) {   //this can happen with new fee requests; YR1 therefore starts out OK no matter what value is entered
			aOK($("#fee_amt_pct_field_text1"),'ok');
			if (YR1 != 0) {
				var calcPct = ((YR2/YR1)-1*100);
				if (calcPct < 2.049) {aOK($("#fee_amt_pct_field_text2"),'ok');} else {aOK($("#fee_amt_pct_field_text2"),'warn');}
			}
		} else {
				var calcPct1 = ((YR1/current_year)-1)*100;
				if (calcPct1 < 2.049) {aOK($("#fee_amt_pct_field_text1"),'ok');} else {aOK($("#fee_amt_pct_field_text1"),'warn');}
				if (YR1 != 0) {
					var calcPct2 = ((YR2/YR1)-1)*100;
					if (calcPct2 < 2.049) {aOK($("#fee_amt_pct_field_text2"),'ok');} else {aOK($("#fee_amt_pct_field_text2"),'warn');}
				}
		}
		if (YR1 != 0) {$("#YR2_amount_field").prop('disabled', false)}
	//	console.log('  CURRENT_YEAR: ' + current_year + "  YR1: " + YR1 + "  YR2: " + YR2 +  "  calcPct1:" + calcPct1 +  "  calcPct2:" + calcPct2);
	}
}

function calcRequestPctIncrease(current_amt,element) {
	var req_amount = parseFloat( $("#"+element.id).val() );
	var guidelinePct = current_amt * 1.02;
	if (current_amt == 0) {
		var calcTotal = ( (req_amount/1) -1) * 100;		
	} else {
		var calcTotal = ( (req_amount/current_amt) -1) * 100;
		$("#fee_amt_pct_field_text1").text(' ' + calcTotal.toFixed(1) + ' %  - $' + guidelinePct.toFixed(2) + ' is the guideline maximum');
	}

	if (isNaN(calcTotal)) {
		$("#YR2_amount_field").prop('disabled',true);
		$("#YR2_amount_field").val('0');
		$("#fee_amt_pct_field_text1").text(' 0%  - $' + guidelinePct.toFixed(2) + ' is the guideline maximum');
	} else {
		$("#YR2_amount_field").prop('disabled',false);
		if ( !isNaN( $("#YR1_amount_field").val() ) ) {
			var wrappedObject = $('#YR2_amount_field');  //jQuery wraps the HTMLobject and makes it an Object object; just use the first element in the wrapper
			calcYR2RequestPctIncrease( wrappedObject[0] );
		}
	}

	if (current_amt != 0 && calcTotal.toFixed(3) > 2.049) {
		aOK($("#fee_amt_pct_field_text1"),'warn');
	} else {
		aOK($("#fee_amt_pct_field_text1"),'ok');
	}
	//	console.log("CURRENT_AMT: " + current_amt + "  calcTotal: " + calcTotal + "  guidelinePct: " + guidelinePct);

}

function aOK(e,status) {
	if(status == 'ok') {
		$(e).addClass('lg-green').removeClass('lg-red')
	} else if (status == 'warn') {
		$(e).addClass('lg-red').removeClass('lg-green')		
	}
}

function calcYR2RequestPctIncrease(element) {
	var current_amt = $("#YR1_amount_field").val();
	var req_amount = parseFloat( $("#"+element.id).val() );
	var calcTotal = ( (req_amount/current_amt) -1) * 100;
	var guidelinePct = current_amt * 1.02;
	if (isNaN(calcTotal)) {
		$("#fee_amt_pct_field_text2").text(' 0%  - $' + guidelinePct.toFixed(1) + ' is the guideline maximum');
	}
	else {
	//	if (req_amount != 0) {
			$("#fee_amt_pct_field_text2").text(' ' + calcTotal.toFixed(1) + ' %  - $' + guidelinePct.toFixed(2) + ' is the guideline maximum');
	//	}
	}
	if (current_amt != 0 && calcTotal.toFixed(3) > 2.049) {
		aOK($("#fee_amt_pct_field_text2"),'warn');
	} else {
		aOK($("#fee_amt_pct_field_text2"),'ok');
	}
}

function calcNewRequestRevenue() {
	var headcount = parseInt( $("#count_est_field").val() );
	var req_amount = parseInt( $("#amount_field").val() );
	var calcTotal = headcount * req_amount;
	$("#count_est_field_text").text('$ ' + calcTotal.toFixed(2) + ' per term');
}

function checkEachFieldForSelections() {
	var validationArray = [];
	//check each form element for selection; default has to be "false" for each element in order for this to work
	validationArray.push( $('#owner_select option:selected').val() );
	validationArray.push( $('#term_select option:selected').val() );
	//validationArray.push( $('#type_select option:selected').val() );
	//validationArray.push( $('#campus_select option:selected').val() );
	validationArray.push( $('#account_select option:selected').val() );
	validationArray.push( $('#objcd_select option:selected').val() );
	validationArray.push( $('#wo_account_select option:selected').val() );
	validationArray.push( $('#assess_select option:selected').val() );
	validationArray.push( $('#crs_assoc_select option:selected').val() );
	validationArray.push( $('#component_select option:selected').val() );
	validationArray.push( $('#fee_select option:selected').val() );
	if ( $('#billing_descr_field').val().length > 5) {
		validationArray.push( 'true' ); } else { validationArray.push( 'false' ); 
	}
	
	if ( $('#long_descr_field').val().length > 5) {
		validationArray.push( 'true' ); } else { validationArray.push( 'false' ); 
	}
	// someday we will require web descriptions, but not yet
	/*if ( $('#web_descr_field').val().length > 5) {
		validationArray.push( 'true' ); } else { validationArray.push( 'false' ); 
	}*/
	if ( !$('#dynOrg_checkbox').is(":checked") ) {
		validationArray.push( $('#account_select option:selected').val() );
		validationArray.push( $('#term_select option:selected').val() );
	}

	if ( $('#replacement_checkbox').is(":checked") ) {
		validationArray.push( $('#fee_select option:selected').val() );
	}
	if ( parseFloat( $('#YR1_amount_field').val() ) > 0) {
		validationArray.push( 'true' ); } else { validationArray.push( 'false' ); 
	}
	
//console.log("YR1 NUMBER: " + parseFloat($('#YR1_amount_field').val()) +"\n" + "VALIDATION ARRAY LENGTH: " + validationArray.length + " ARRAY: " + validationArray.toString());

	if ( validationArray.includes("false") ) {
		$('#new_submit_btn').prop('disabled', true);
		$('#new_submit_label').text("Sorry, the Submit button will only turn on once you fill in all the fields above.");
	} else {
		$('#new_submit_btn').prop('disabled', false);
		$('#new_submit_label').text("OK! Everything seems to be here.  Once you Submit, you cannot make further changes!");
	}

    $('button[type!=submit]').click(function(){    // code to cancel changes; prevents SAVE button from submitting form
    	//someFunctionToSaveChanges();
        return false;
    });
}

function addItemizationRows() {
   	$('#itemization_tbl tr:last').after('<tr> <td><select id="FYjust_select" name="FYjust_select" class="request"><option value="false" selected>-- Fiscal Year --</option><option value="FY20">FY20</option><option value="Fy21">FY21</option></select></td> <td></td> <td></td></tr>');
}

function showCancelButton(cancelid,givenFeeID) {
	$('[feeid="'+givenFeeID +'"]').prop("disabled", function(i,v) {return !v;});
}

function justifyModal(givenModalID,modalIconID,givenCloseX) {
	var givenModal = document.getElementById(givenModalID);
	var modalIcon = document.getElementById(modalIconID);
	var closeX = document.getElementById(givenCloseX);
	//console.log(givenModal);
	// When the user clicks on the button, open the modal 
//	modalIcon.onclick = function() {
    	givenModal.style.display = "block";
//	}
	// When the user clicks on <span> (x), close the modal
	closeX.onclick = function() {
		console.log("YOU CLICKED THE CLOSEX");
    	givenModal.style.display = "none";
	}
	// When the user clicks anywhere outside of the modal, close it
	window.onclick = function(event) {
    	if (event.target == givenModal) {
        	givenModal.style.display = "none";
    	}
	} 
}

