// jburgoon 2016
// All validation code working in the browser must be placed here.  Otherwise it will be harder to maintain.

	//This is the main function to be called by the HTML onchange()/ONBLUR() and other javascript functions.  
	//Most other functions just need to be included here so that they fire in the proper order.
	function checkValues(element_id, column, currentRow){
		//make sure these are cleared each time we call this function
		clearValidationSelectors(column,currentRow);
		var goodSelector = column + "GoodResult" + currentRow;
		var badSelector = column + "BadResult" + currentRow;

		var whole_element = document.getElementById(element_id)
		var original_value = Number(whole_element.value.replace(/\,/g,''));
		var value = Math.round(original_value * 100)			//convert to cents for all math
		var modulo_value = value % 3;

		var nextHigherPenny = nextHigherDivisibleByThree(value);
		var nextLowerPenny = nextLowerDivisibleByThree(value);
		var nextHigherDollar = nextHigherDollarDivisibleByThree(value);
		var nextLowerDollar = nextLowerDollarDivisibleByThree(value);
		
		if ( !/^[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{3})?$/.test(value)) {
	    	$("#" + badSelector).text("Invalid input, please enter a number") 
		    //console.log("Input validator ")
	    	return false
	  	}
	  	
	  	if (value > 100000000000) {
	    	// modulo of large numbers is sometimes incorrect since the internal representation switches to floats
			// e.g. 28286547982133925 % 3 returns 2, but 28286547982133925 = 9428849327377975 * 3
	    	$("#" + badSelector).text("Sorry, your input is too large")
	    	//console.log("Oversize amount validator")
	    	return false
	  	}
  		
  		//old logic that included divisibility rule
 /* 		if ( modulo_value != 0) {
  			 if (value/100 != original_value) {
    	     	$("#" + badSelector).text( original_value + " rounds to " + value/100 + " - not a multiple of 3" )
    	     } else {
    	     	$("#" + badSelector).text( value/100 + " Your value must be divisible by 3. Next lower valid penny amount: " + nextLowerPenny + " Next higher valid penny amount: " + nextHigherPenny)
    	     	// + " Next higher valid dollar amount: " + nextHigherDollar + " Next lower valid dollar amount: " + nextLowerDollar
    	     }
    	  
    	  return false
    	} else {
    		// Say nothing.  This is good input.
    		 $("#" + goodSelector).addClass('goodResult')
    		 if (value/100 != original_value) {
    	     	$("#" + goodSelector).text( original_value + " rounds to " + value/100 + " - even pennies." )
    	     } else {
    	     	$("#" + goodSelector).text( value/100 + " - valid amount." )
    	     }
    	     return true
    	}
*/

	// just let us know if you did any rounding
		$("#" + badSelector).addClass('badResult')
		if (value/100 != original_value) {
	    	$("#" + badSelector).text( "The percentage change amount entered resulted in an invalid fee rate amount of " + original_value +". Please round the fee rate amount up or down to nearest cents." );
	    	//console.log("Rounding validator - BAD")
	    	return false
	    } else {
	    	$("#" + goodSelector).text( "Value is: " + value/100 + " and original value is: " + original_value);
	    	//console.log("Rounding validator - GOOD")
	    	//return true
	    }
		//everything looks OK, so enable the SUBMIT buttons
		//console.log("Everything looks OK")
		//console.log("Top SUBMIT button: " + $('#SubmitBtn')[0]).prop('disabled')
		//console.log("Bottom SUBMIT button: " + $('#SubmitBtn2')[0]).prop('disabled')
		$("#SubmitBtn").prop('disabled', false);
		$("SubmitBtn2").prop('disabled', false);
		//checkThreshholds(column,currentRow);
	    return true
	}

	function checkThreshholds(column,currentRow) {
		var threshholdCheck = 0;
		var badSelector = column + "BadResult" + currentRow;
		// As we loop through the fees, base_numbers will hold an attribute we added called "percentLowThreshhold" - empty or has numeric value, i.e., 6
		// Same thing is true for percentHighThreshhold
		var base_numbers = grabCurrentValues(currentRow,allfee_id);
		// Loop through all the current values in the row
			// Check each threshhold setting for true.  If all are OK, set threshholdCheck to TRUE, else FALSE
		// end loop
		$("#" + badSelector).text( "You have entered a percent change or fee rate amount which exceeds the guidelines set by senior management. Please adjust the percent change or amount not to exceed the rate ceilings")
		return threshholdCheck;	
	}

	//These are the two "note" divs which appear and contain any error messages or information when the user enters data.
	function clearValidationSelectors(column,currentRow) {
		var goodSelector = column + "GoodResult" + currentRow;
		var badSelector = column + "BadResult" + currentRow;
		$("#" + goodSelector).text("");
		$("#" + badSelector).text("");
	}
	
    function nextHigherDivisibleByThree(amount) {
    	var base = (amount + (3 - (amount % 3)))/100;
    	return base.toFixed(2);				
    }
    
	function nextLowerDivisibleByThree(amount) {
		var base = (amount - (amount % 3))/100;
		return base.toFixed(2);
	} 
	
	function nextHigherDollarDivisibleByThree(amount) {
		return nextHigherDivisibleByThree(Math.ceil(amount/1000));
	}
	
	function nextLowerDollarDivisibleByThree(amount) {
		return nextLowerDivisibleByThree(Math.round(amount/1000));
	}
	
	function updateByPercent(element_id,HiLo,currentRow,allfee_id) {
		//make sure these are cleared each time we call this function
		clearValidationSelectors(HiLo.toLowerCase(),currentRow);
		// set the new amount for the dollars based on the percent increase amount entered
		var base_numbers = grabCurrentValues(currentRow,allfee_id);		//gets the various DOM objects and their values for the row we are currently changing
		if (HiLo === "Low"){
			var real_dollars = (Math.round( (base_numbers.low_percentage/100 * base_numbers.curr_rate + base_numbers.curr_rate)*1000 )/1000 );	
			var extended_dollars = (Math.round( (base_numbers.high_percentage/100 * base_numbers.low_bucks + base_numbers.low_bucks)*1000 )/1000 );	
			base_numbers.dollars_low.val( numberWithCommas(real_dollars.toFixed(2)) );	
			base_numbers.low_bucks = Number(base_numbers.dollars_low.val());
			base_numbers.dollars_high.val( numberWithCommas( extended_dollars.toFixed(2)) );
			//adviseUser(real_dollars, base_numbers.dollars_low.val(), HiLo.toLowerCase(), currentRow);
			enableTarget(base_numbers);
		} else if (HiLo === "High"){
			var extended_dollars = (Math.round( (base_numbers.high_percentage/100 * base_numbers.low_bucks + base_numbers.low_bucks)*1000 )/1000 ).toFixed(2);	
			//base_numbers.dollars_high.val( (Math.round( (base_numbers.high_percentage/100 * base_numbers.low_bucks + base_numbers.low_bucks)*1000 )/1000 ).toFixed(2) );				
			base_numbers.dollars_high.val( numberWithCommas( extended_dollars ) );				
		} else {  //should never see this case!
			//console.log("updateByPercent found a case where HiLo is neither Low nor High:" + HiLo);
		}
//		checkValues(element_id, HiLo, currentRow);
		//checkThreshholds(HiLo,currentRow);
	}
	
	//TODO this is not hitting the correct DOM target.  Break this out to a "find object" function and this adviseUser() function 
	function adviseUser(real_dollars, rounded_dollars, HiLo, currentRow) {
		var goodSelector = HiLo + "GoodResult" + currentRow;
		$("#" + goodSelector).addClass('goodResult')
		if (real_dollars != rounded_dollars) {
	    	$("#" + goodSelector).text( "The percentage change amount entered resulted in an invalid fee rate amount of " + real_dollars +". Please round the fee rate amount up or down to nearest cents.")
	    } 
	}
	
	function setZeroRatesToDefault(obj) {
		if (base_numbers.curr_rate === 0) {
			obj.val("100");
		}
	}
	function updateByDollars(elementID,HiLo,currentRow,allfee_id) {					//current Row is the row of the CF query as we loop through it; used for naming DOM objects
		//make sure these are cleared each time we call this function
		clearValidationSelectors(HiLo.toLowerCase(),currentRow);

		var base_numbers = grabCurrentValues(currentRow,allfee_id);		//gets the various DOM objects and their values for the row we are currently changing
		// set the new amount for the percent increase based on the dollar amount entered
		if (HiLo === "Low"){
			if (base_numbers.curr_rate === 0) {
				base_numbers.percent_low.val("100");
			} else {
				base_numbers.percent_low.val( Math.round( ((base_numbers.low_bucks / base_numbers.curr_rate )-1)*100000)/1000 );	
			}
			base_numbers.low_bucks = Number(base_numbers.dollars_low.val().replace(/,/g, ''));
			base_numbers.dollars_high.val( numberWithCommas(Math.round( (base_numbers.high_percentage/100 * base_numbers.low_bucks + base_numbers.low_bucks)*1000 )/1000 ));
			enableTarget(base_numbers);  //enableTarget(base_numbers && base_numbers.curr_rate != 0);
			//checkValues(base_numbers.dollarHighID, HiLo, currentRow);
		} else if (HiLo === "High"){
			base_numbers.percent_high.val( Math.round( ((base_numbers.high_bucks / base_numbers.low_bucks )-1)*10000 )/100 );				
		} else {  
			//console.log("updateByDollars found a case where HiLo is neither Low nor High:" + HiLo);
		}
		//checkThreshholds(HiLo,currentRow);
	}

	//snapshot of the state of the form.  Calculates values which rely on current state amounts, without losing the base data.
	function grabCurrentValues(currentRow,allfee_id) {
		var currRateName = "currRate" + currentRow + "_"+allfee_id;									// DOM name of current Rate TD 
		var incPctLowName = "incPctLow" + currentRow + "_"+allfee_id;							// DOM names of percentage input boxes
		//console.log('incPctLowName: ' + incPctLowName + '\n');
		var incPctHighName = "incPctHigh" + currentRow + "_"+allfee_id;
		var dollarLowName = allfee_id + "_FEE_LOWYEAR";								// DOM names of related dollars input boxes
		var dollarHighName = allfee_id + "_FEE_HIGHYEAR";	;	
		 
		var curr_rate_obj = $('td[name=' + currRateName + ']');						// get the jQuery object for the current Rate column 
		var percent_low = $('input[name=' + incPctLowName + ']');					// get the jQuery object for the 1st year percentage input box
		var percent_high = $('input[name=' + incPctHighName + ']');					// get the jQuery object for the 2nd year percentage input box
		var dollars_low = $('input[name=' + dollarLowName + ']');                   // get the jQuery object for the 1st year dollars input box
		var dollars_high = $('input[name=' + dollarHighName + ']');                 // get the jQuery object for the 1st year dollars input box

		var dollarLowID = dollars_low.attr('id'); 
		var dollarHighID = dollars_high.attr('id'); 

		var percentLowThreshhold = percent_low.attr('threshhold');
		var percentHighThreshhold = percent_high.attr('threshhold');
var atest1 = percent_low.val();
var atest2 = percent_low.val().replace(/[^\d*\.?{1}\d*]/g, '');

		var curr_rate = Number(curr_rate_obj.text().replace(/[^\d.-]/g, ''));
		var low_percentage = Number(percent_low.val().replace(/[^\d.-]/g, ''));		// convert the values to numbers, since they are technically text in the web form
		var low_bucks = Number(dollars_low.val().replace(/[^\d.-]/g, ''));			//.replace(/,/g, ''));
		var high_percentage = Number(percent_high.val().replace(/[^\d.-]/g, ''));
		var high_bucks = Number(dollars_high.val().replace(/[^\d.-]/g, ''));		//replace(/,/g, ''));
				
		var base_numbers = {"currRateName":currRateName, 							// stuff all our object into a structure using the DOM names as keys 
							"incPctLowName":incPctLowName,
							"incPctHighName":incPctHighName,
							"dollarLowName":dollarLowName,
							"dollarHighName":dollarHighName,
							"dollarLowID":dollarLowID,
							"dollarHighID":dollarHighID,
							"curr_rate":curr_rate,
							"percent_low":percent_low,
							"percent_high":percent_high,
							"percentLowThreshhold":percentLowThreshhold,
							"percentHighThreshhold":percentHighThreshhold,
							"dollars_low":dollars_low,
							"dollars_high":dollars_high,
							"low_percentage":low_percentage,
							"low_bucks":low_bucks,
							"high_percentage":high_percentage,
							"high_bucks":high_bucks
		}
		return base_numbers;
	}	
	
	function numberWithCommas(x) {
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function roundToFour(num) {    
		var mathResult = +(Math.round(num + "e+4")  + "e-4");
		//console.log("function roundToFour returns " + mathResult);
	    return mathResult;
	}
	
	function enableTarget(base_numbers) { 
		base_numbers.percent_high.prop('disabled', false);
		base_numbers.dollars_high.prop('disabled', false);
	}
	
	function checkHiddenRows(id) {
	    vc = getItem('ViewControl');
	    itm = document.getElementById(id);
	    if (vc.checked == true) {
	        itm.style.display = 'none';
	    } 
	}
	
	function progressBar() {
		var button, parent;
		button = document.querySelector("button");
		parent = button.parentElement;
		button.addEventListener("click", function() {
			parent.classList.add("clicked");
		  	return setTimeout((function() {
		    return parent.classList.add("success");
		  }), 2600);
		});
	}
	