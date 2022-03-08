/*************************************************
 * Indiana University Budget Office
 *   Budgeting Tools - Credit Hour Projector
 *   Version: 0.3  Sep 2017
 *   Author: John Burgoon 
 *   Author email: budujwb@iu.edu
 * Last updated: September 21, 2017
 ************************************************/
var saveChoice = null;

function showUsers() {
	$('#usersBtn').click( function() {
      $('#prefs').toggle();
    } );
}

function setSelectedRC(choice) {
	_url = location.href;
	_url = _url.split('?')[0];
    _url += (_url.split('?')[1] ? '&':'?') + "Campus=" + choice.substring(0,2);
    _url += (_url.split('?')[1] ? '&':'?') + "RC=" + choice.substring(5,7);
    window.location.href = _url;
    saveRC(choice);
}

function saveRC(cookieValue) {
    var sel = document.getElementById('RCdropdown');
    saveChoice = saveChoice ? saveChoice : document.body.className;
    document.body.className = saveChoice + ' ' + sel.value;
    setRCCookie('CrHrRC', cookieValue, 30);
}

function setRCCookie(cookieName, cookieValue, nDays) {
    var today = new Date();
    var expire = new Date();
    if (!nDays) 
        nDays=1;
    expire.setTime(today.getTime() + 3600000*24*nDays);
    document.cookie = cookieName+"="+escape(cookieValue) + ";expires="+expire.toGMTString();
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1, c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
  }
  return null;
}

function formatDollars(amount, fixed) {
	amount = amount.toFixed(fixed).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");  //make it look like purty US dollars
	return amount;
}

function updateCampusGrands() {
	var ph = $('#ph_grand').val();
	var er = $('#er_grand').val();
	if (typeof ph === 'undefined' || typeof er === 'undefined') {
	} else {  
		$('#revGrand').text("$ "+ parseFloat(er, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString() );
		$('#crhrGrand').text( ph.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") );
	}
}

function calcRCTotal(revElement,totalElement,givenLabel) {
	//console.log("REV ELEMENT IS: " + revElement + "TOTAL ELEMENT IS: " + totalElement);
	// we are totaling here only what is currently showing in the FORM, not what is in the database.
	// obviously, on load, whatever is showing in the form just came from the database, so they match.
	// the rest of the time, though, we are totaling what the user has been entering BEFORE database submission.
    var arr = document.getElementsByName(revElement);  //formerly 'estRev'
    var estPennies = 0;
    var tot=0;
    for(var i=0;i<arr.length;i++){
    	estPennies = arr[i].innerHTML.replace(/\$|,/g, '').trim()*100;
   	//console.log("--" + arr[i].innerHTML.replace(/\$|,/g, '').trim() + "--" );
        if(parseInt( estPennies ))
            tot += parseInt( estPennies );
    }
    if ( typeof(document.getElementById(totalElement)) != "undefined" ) {
    	document.getElementById(totalElement).innerHTML = givenLabel + formatDollars(tot/100,0);  //formerly "rcTotal"
    //console.log("calcRCTotal says arrlength is: " + arr.length + " and tot is: " + tot);
    } else {console.log("BLORK")}
    return tot;
}

function calcVisibleSubTotal() {
	//console.log("calcVisibleSubTotal called... done.\n");
	var gradSumYr1 = 0;var gradSumYr2 = 0; var ugrdSumYr1 = 0;var ugrdSumYr2 = 0; var otherSumYr1 = 0; var otherSumYr2 = 0; var grandTotalYr1; var grandTotalYr2;
	$("[id^='gradFeeRevYr1']").each(function() {
		//calcEstRev(this.value, #feeAmount#,'#currentTarget#');
		//console.log("Added to gradSumYr1, total so far: " + gradSumYr1 + " for this ID: " + this.id + "\n");
		var gradValueYr1 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(gradValueYr1) && gradValueYr1.length != 0) {
			//console.log("OK: " + gradValueYr1 + "\n");
			gradSumYr1 += parseFloat(gradValueYr1);
			//console.log("Added to gradSumYr1, total so far: " + gradSumYr1 + " for this ID: " + this.id + "\n");
		} else {
			//console.log("Fail");
		}
	});
	$("[id^='gradFeeRevYr2']").each(function() {
		var gradValueYr2 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(gradValueYr2) && gradValueYr2.length != 0) {
			gradSumYr2 += parseFloat(gradValueYr2);
		}
	});
	$("[id^='ugrdFeeRevYr1']").each(function() {
		var ugrdValueYr1 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(ugrdValueYr1) && ugrdValueYr1.length != 0) {
			ugrdSumYr1 += parseFloat(ugrdValueYr1);
		}
	});
	$("[id^='ugrdFeeRevYr2']").each(function() {
		var ugrdValueYr2 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(ugrdValueYr2) && ugrdValueYr2.length != 0) {
			ugrdSumYr2 += parseFloat(ugrdValueYr2);
		}
	});
	$("[id^='otherFeeRevYr1']").each(function() {
		var otherValueYr1 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(otherValueYr1) && otherValueYr1.length != 0) {
			otherSumYr1 += parseFloat(otherValueYr1);
		}
	});
	$("[id^='otherFeeRevYr2']").each(function() {
		var otherValueYr2 = $(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(otherValueYr2) && otherValueYr2.length != 0) {
			otherSumYr2 += parseFloat(otherValueYr2);
		}
	});
	if (document.getElementById("gradSubTotalYr1") != null) {
    	document.getElementById("gradSubTotalYr1").innerHTML = "SUB-TOTAL YR1 (only what is showing): $" + formatDollars(gradSumYr1,0);
    }
	if (document.getElementById("gradSubTotalYr2") != null) {
    	document.getElementById("gradSubTotalYr2").innerHTML = "SUB-TOTAL YR2 (only what is showing): $" + formatDollars(gradSumYr2,0);
    }
	if (document.getElementById("ugrdSubTotalYr1") != null) {
    	document.getElementById("ugrdSubTotalYr1").innerHTML = "SUB-TOTAL YR1 (only what is showing): $" + formatDollars(ugrdSumYr1,0);
    }
	if (document.getElementById("ugrdSubTotalYr2") != null) {
    	document.getElementById("ugrdSubTotalYr2").innerHTML = "SUB-TOTAL YR2 (only what is showing): $" + formatDollars(ugrdSumYr2,0);
    }
	if (document.getElementById("otherSubTotalYr1") != null) {
    	document.getElementById("otherSubTotalYr1").innerHTML = "SUB-TOTAL YR1 (only what is showing): $" + formatDollars(otherSumYr1,0);
    }
	if (document.getElementById("otherSubTotalYr2") != null) {
    	document.getElementById("otherSubTotalYr2").innerHTML = "SUB-TOTAL YR2 (only what is showing): $" + formatDollars(otherSumYr2,0);
    }
    if (document.getElementById("campGrandYr1") != null) {
    	grandTotalYr1 = gradSumYr1 + ugrdSumyr1 + otherSumYr1;
    	document.getElementById("campGrandYr1").innerHTML = "$" + formatDollars(grandTotalYr1,0);
    }
    if (document.getElementById("campGrandYr2") != null) {
    	grandTotalYr2 = gradSumYr2 + ugrdSumyr2 + otherSumYr2;
    	document.getElementById("campGrandYr2").innerHTML = "$" + formatDollars(grandTotalYr2,0);
    }
}

function calcCrHrTotal() {
	//console.log('calcCrHrTotal... done.\n');
	var projCrHrSum = 0;
	$("[id^='projHrs']").each(function() {
		var projCrHrValue = this.value; //$(this).text().replace(/[^0-9\.]/g,'');
		if(!isNaN(projCrHrValue) && projCrHrValue.length != 0) {
			projCrHrSum += parseFloat(projCrHrValue);
		}
	});
    if (document.getElementById("crhrGrand") != null) {
    	projCrHrSum = projCrHrSum.toString();
    	projCrHrSum = projCrHrSum.replace(/\B(?=(\d{3})+(?!\d))/g, ","); 
    	document.getElementById("crhrGrand").innerHTML = projCrHrSum;
    }
}

function calcEstRev(newValue, fee,currentTarget) {
	console.log('calcEstRev OK: ' + newValue + ' - ' + fee + ' - ' + currentTarget + ' ... and done.\n');
	revenue = newValue*fee;
	var elementID = currentTarget; //.concat(row); 
	if ( isNaN(revenue) ){
		document.getElementById(elementID).innerHTML = "Please enter a valid number of projected credit hours";
	} else {
		document.getElementById(elementID).innerHTML = "$" + formatDollars(revenue, 2);
		calcRCTotal("gradEstRevYr1","gradSubTotalYr1","SUB-TOTAL YR1 (only what is showing): $");
		calcRCTotal("gradEstRevYr2","gradSubTotalYr2","SUB-TOTAL YR2 (only what is showing): $");
		calcRCTotal("ugrdEstRevYr1","ugrdSubTotalYr1","SUB-TOTAL YR1 (only what is showing): $");
		calcRCTotal("ugrdEstRevYr2","ugrdSubTotalYr2","SUB-TOTAL YR2 (only what is showing): $");
		calcRCTotal("otherEstRevYr1","otherSubTotalYr1","SUB-TOTAL YR1 (only what is showing): $");
		calcRCTotal("otherEstRevYr2","otherSubTotalYr2","SUB-TOTAL YR2 (only what is showing): $");
//		calcVisibleSubTotal();
		calcCrHrTotal();
		calcVisibleSubTotal();
	}
}

function date_lastmodified() {
  var lmd = document.lastModified;
  var s   = "Unknown";
  var d1;
  // check if we have a valid date before proceeding
  if(0 != (d1=Date.parse(lmd)))
  {
    s = "" + date_ddmmmyy(new Date(d1));
  }
  return s;
}

document.addEventListener('DOMContentLoaded', function() {
	var projHrsArray = document.getElementsByName("projHrs");
	var projHrsRates = document.getElementsByName("feeLY");
	if (typeof projHrsRates !== 'undefined') {
		for (var i=0; i<projHrsArray.length; i++) {
			//console.log("projHrsArray[" + i + "]: " + projHrsArray[i].value + " -  projHrsRates[" + i + "]:" + projHrsRates[i].innerHTML.replace(/\$|,/g, '').trim());
			//calcEstRev( i+1, projHrsArray[i].value, projHrsRates[i].innerHTML.replace(/\$|,/g, '').trim() );
		}
	}
});

document.addEventListener('DOMContentLoaded', function(){
	// Event listener for DataTables custom range filtering inputs (see footer.cfm)
	//console.log("Event listener for gradFeesTable fired.\n");
	var gradTable = $('#gradFeesTable').DataTable();
    $('#gradmin, #gradmax').keyup( function() {
        gradTable.draw();
    } );
});

document.addEventListener('DOMContentLoaded', function(){
	// Event listener for DataTables custom range filtering inputs (see footer.cfm)
	//console.log("Event listener for ugrdFeesTable fired.\n");
	var ugrdTable = $('#ugrdFeesTable').DataTable();
    $('#ugrdmin, #ugrdmax').keyup( function() {
        ugrdTable.draw();
    } );
});

document.addEventListener('DOMContentLoaded', function(){
	// Event listener for DataTables custom range filtering inputs (see footer.cfm)
	//console.log("Event listener for specialFeesTable fired.\n");
	var specialTable = $('#specialFeesTable').DataTable();
    $('#specialmin, #specialmax').keyup( function() {
       specialTable.draw();
    } );
});
