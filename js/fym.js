$.fn.colTotal = function (e) {
	//loop through each table with name like "fymMainTable"
	//loop through each row and add running totals to column sums
	//update sub-totals and grand total for table
	var tableList = ['fymMainTable1','fymMainTable2','fymMainTable3'];
	var stRevDict = {"orig":0, "cur_yr_new": 0, "yr1_new":0, "yr2_new":0, "yr3_new":0, "yr4_new":0, "yr5_new":0};
	var stExpDict = {"orig":0, "cur_yr_new": 0, "yr1_new":0, "yr2_new":0, "yr3_new":0, "yr4_new":0, "yr5_new":0};
	$.each(tableList, function(index, value) {
		//console.log('**** Starting in on ' +$('#'+value).attr('id')+ ' table\n');
		var colTotalRevDict = {"orig":0, "cur_yr_new": 0, "yr1_new":0, "yr2_new":0, "yr3_new":0, "yr4_new":0, "yr5_new":0};
		var colTotalExpDict = {"orig":0, "cur_yr_new": 0, "yr1_new":0, "yr2_new":0, "yr3_new":0, "yr4_new":0, "yr5_new":0};
		$('#'+value).find('[id ^="yr1_new"]').not('[name $="DELTA"]').each(function(){
			//console.log('colTotal sending '+$(this).attr("id")+'\n');
			var rowDictResult = $.fn.rTotal(this); 
				for (var z in rowDictResult) {
					if (z.split("OID")[0] == "cur_yr_new"){
						//console.log(" rowDictResult key is " +z+ ' and rowDictResult value is ' + rowDictResult[z] +'\n');
					}
				}
			//rTotal updates running totals on the page and also returns the amounts for each row in a dictionary keyed by column names
			for(var k in rowDictResult) { 
				var sumKey = k.split("OID")[0];                        //console.log('key '+k+'  value '+rowDictResult[k]+'  sumKey: ' + sumKey + '\n');
				var reLabel = $('#'+k).attr('name').split('_').pop();  //console.log('  popped value: ' + reLabel + '\n');
					if ( typeof reLabel != 'undefined' & reLabel == 1) {
						colTotalRevDict[sumKey] += rowDictResult[k];   //console.log('REV REV REV - '  + colTotalRevDict[sumKey] + '\n');
						stRevDict[sumKey] += rowDictResult[k];
					} else if( typeof reLabel != 'undefined' & reLabel == 2) {
						colTotalExpDict[sumKey] += rowDictResult[k];   //console.log('EXP EXP EXP - '  + colTotalRevDict[sumKey] + '\n');
						stExpDict[sumKey] += rowDictResult[k];
					} else {console.log('    element named ' +$(this).attr('name')+ ' is unknown type.\n');}
			};
			//now update each of the sub-total elements with formatted dollar amounts
			$('#'+value).find('[id ="rtst_cy"]').each(function(){ $(this).text('$ '+ colTotalRevDict["cur_yr_new"].toLocaleString() ); });
			$('#'+value).find('[id ="rtst_yr1"]').each(function(){ $(this).text('$ '+ colTotalRevDict["yr1_new"].toLocaleString() ); });
			$('#'+value).find('[id ="rtst_yr2"]').each(function(){ $(this).text('$ '+ colTotalRevDict["yr2_new"].toLocaleString() ); });
			$('#'+value).find('[id ="rtst_yr3"]').each(function(){ $(this).text('$ '+ colTotalRevDict["yr3_new"].toLocaleString() ); });
			$('#'+value).find('[id ="rtst_yr4"]').each(function(){ $(this).text('$ '+ colTotalRevDict["yr4_new"].toLocaleString() ); });
			$('#'+value).find('[id ="rtst_yr5"]').each(function(){ $(this).text('$ '+ colTotalRevDict["yr5_new"].toLocaleString() ); });
			
			$('#'+value).find('[id ="exst_cy"]').each(function(){ $(this).text('$ '+ colTotalExpDict["cur_yr_new"].toLocaleString() ); });
			$('#'+value).find('[id ="exst_yr1"]').each(function(){ $(this).text('$ '+ colTotalExpDict["yr1_new"].toLocaleString() ); });
			$('#'+value).find('[id ="exst_yr2"]').each(function(){ $(this).text('$ '+ colTotalExpDict["yr2_new"].toLocaleString() ); });
			$('#'+value).find('[id ="exst_yr3"]').each(function(){ $(this).text('$ '+ colTotalExpDict["yr3_new"].toLocaleString() ); });
			$('#'+value).find('[id ="exst_yr4"]').each(function(){ $(this).text('$ '+ colTotalExpDict["yr4_new"].toLocaleString() ); });
			$('#'+value).find('[id ="exst_yr5"]').each(function(){ $(this).text('$ '+ colTotalExpDict["yr5_new"].toLocaleString() ); });

	$('#'+value).find('[id ="sdst_cy"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["cur_yr_new"] - colTotalExpDict["cur_yr_new"]).toLocaleString() ); });
	$('#'+value).find('[id ="sdst_yr1"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["yr1_new"] - colTotalExpDict["yr1_new"]).toLocaleString() ); });
	$('#'+value).find('[id ="sdst_yr2"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["yr2_new"] - colTotalExpDict["yr2_new"]).toLocaleString() ); });
	$('#'+value).find('[id ="sdst_yr3"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["yr3_new"] - colTotalExpDict["yr3_new"]).toLocaleString() ); });
	$('#'+value).find('[id ="sdst_yr4"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["yr4_new"] - colTotalExpDict["yr4_new"]).toLocaleString() ); });
	$('#'+value).find('[id ="sdst_yr5"]').each(function(){ $(this).text('$ '+ (colTotalRevDict["yr5_new"] - colTotalExpDict["yr5_new"]).toLocaleString() ); });
		}); //end of find().each()
	}) //end of tableList .each()	
	//THE SMOKE CLEARS
	//revenue totals go into summary table as well , but these are totals from all 3 fund group codes combined 
	$('#rs_pr').text('$ '+ stRevDict["orig"].toLocaleString() ); 
	$('#rs_cy').text('$ '+ stRevDict["cur_yr_new"].toLocaleString() ); 
	$('#rs_yr1').text('$ '+ stRevDict["yr1_new"].toLocaleString() );
	$('#rs_yr2').text('$ '+ stRevDict["yr2_new"].toLocaleString() );
	$('#rs_yr3').text('$ '+ stRevDict["yr3_new"].toLocaleString() );
	$('#rs_yr4').text('$ '+ stRevDict["yr4_new"].toLocaleString() );
	$('#rs_yr5').text('$ '+ stRevDict["yr5_new"].toLocaleString() ); 	
	
	$('#rs_cydelta').text('$ '+ (stRevDict["cur_yr_new"]-stRevDict["orig"]).toLocaleString() );
	$('#rs_yr1delta').text('$ '+ (stRevDict["yr1_new"]-stRevDict["cur_yr_new"]).toLocaleString() );
	$('#rs_yr2delta').text('$ '+ (stRevDict["yr2_new"]-stRevDict["yr1_new"]).toLocaleString() );
	$('#rs_yr3delta').text('$ '+ (stRevDict["yr3_new"]-stRevDict["yr2_new"]).toLocaleString() );
	$('#rs_yr4delta').text('$ '+ (stRevDict["yr4_new"]-stRevDict["yr3_new"]).toLocaleString() );
	$('#rs_yr5delta').text('$ '+ (stRevDict["yr5_new"]-stRevDict["yr4_new"]).toLocaleString() ); 	
	
	//expense totals go into summary table as well , but these are totals from all 3 fund group codes combined 
	$('#xs_pr').text('$ '+ stExpDict["orig"].toLocaleString() ); 
	$('#xs_cy').text('$ '+ stExpDict["cur_yr_new"].toLocaleString() ); 
	$('#xs_yr1').text('$ '+ stExpDict["yr1_new"].toLocaleString() );
	$('#xs_yr2').text('$ '+ stExpDict["yr2_new"].toLocaleString() );
	$('#xs_yr3').text('$ '+ stExpDict["yr3_new"].toLocaleString() );
	$('#xs_yr4').text('$ '+ stExpDict["yr4_new"].toLocaleString() );
	$('#xs_yr5').text('$ '+ stExpDict["yr5_new"].toLocaleString() ); 	
	
	$('#xs_cydelta').text('$ '+ (stExpDict["cur_yr_new"]-stExpDict["orig"]).toLocaleString() );  
	$('#xs_yr1delta').text('$ '+ (stExpDict["yr1_new"]-stExpDict["cur_yr_new"]).toLocaleString() );
	$('#xs_yr2delta').text('$ '+ (stExpDict["yr2_new"]-stExpDict["yr1_new"]).toLocaleString() );
	$('#xs_yr3delta').text('$ '+ (stExpDict["yr3_new"]-stExpDict["yr2_new"]).toLocaleString() );
	$('#xs_yr4delta').text('$ '+ (stExpDict["yr4_new"]-stExpDict["yr3_new"]).toLocaleString() );
	$('#xs_yr5delta').text('$ '+ (stExpDict["yr5_new"]-stExpDict["yr4_new"]).toLocaleString() ); 	
	
	//surplus-deficit updates
	$('#tsd_pr').text('$ '+ (stRevDict["orig"]-stExpDict["orig"]).toLocaleString() ); 
	$('#tsd_cy').text('$ '+ (stRevDict["cur_yr_new"]-stExpDict["cur_yr_new"]).toLocaleString() ); 
	$('#tsd_yr1').text('$ '+ (stRevDict["yr1_new"]-stExpDict["yr1_new"]).toLocaleString() );
	$('#tsd_yr2').text('$ '+ (stRevDict["yr2_new"]-stExpDict["yr2_new"]).toLocaleString() );
	$('#tsd_yr3').text('$ '+ (stRevDict["yr3_new"]-stExpDict["yr3_new"]).toLocaleString() );
	$('#tsd_yr4').text('$ '+ (stRevDict["yr4_new"]-stExpDict["yr4_new"]).toLocaleString() );
	$('#tsd_yr5').text('$ '+ (stRevDict["yr5_new"]-stExpDict["yr5_new"]).toLocaleString() ); 			
/*		for (var j in stExpDict) {
			if(j == "yr1_new"){
				console.log(" stExpDict key is " +j+ ' and stExpDict value is ' + stExpDict[j] +'\n');
			}
		}
		for (var k in colTotalExpDict) {
			console.log(" colTotalExpDict key is " +k+ ' and colTotalRevDict value is ' + colTotalExpDict[k] +'\n');
		}
		console.log('End of work for ' + value+ '\n');
*/

} //end of colTotal

$.fn.rTotal = function (e) {
	//console.log('rTotal firing off');
	// first, given a particular element, identify all the other elements in the same row using the OID scheme
	var targetArray = [];
	var currentID = $(e).attr('id').split('OID')[1];
	//console.log('rTotal is processing ' + currentID+ '\n');
	var targetOrig = 'origOID'+currentID;
	targetArray.push(targetOrig);
	//console.log('TargetOrig type:' + $('#'+targetOrig).prop('nodeName') + '\n');

	
	var targetNew = 'cur_yr_newOID'+currentID;
	//console.log('targetNew type:' + $('#'+targetNew).prop('nodeName') + '\n');
	targetArray.push(targetNew);
	var target1 = 'yr1_newOID'+currentID;
	//console.log('target1 '+target1+' type:' + $('#'+target1).prop('nodeName') + '\n');
	targetArray.push(target1);
	var target2 = 'yr2_newOID'+currentID;
	//console.log('target2 type:' + $('#'+target2).prop('nodeName') + '\n');
	targetArray.push(target2);
	var target3 = 'yr3_newOID'+currentID;
	//console.log('target3 type:' + $('#'+target3).prop('nodeName') + '\n');
	targetArray.push(target3);
	var target4 = 'yr4_newOID'+currentID;
	//console.log('target4 type:' + $('#'+target4).prop('nodeName') + '\n');
	targetArray.push(target4);
	var target5 = 'yr5_newOID'+currentID;
	//console.log('target5 type:' + $('#'+target5).prop('nodeName') + '\n');
	targetArray.push(target5);
	// OK, good, we have found each element in our target row and added its ID to our targetArray
	
	//now, make a dictionary of running totals for each row element by ID
	var rowSum = 0;
	var rowDict = {};
	var colDict = {};
	$.each(targetArray, function(index,value) {
		// inputs hold val() but spans hold text() - this adjusts for editability of each element in the form
/*		if (value.split("OID")[0] == "rtc"){
			//for( var i = 0; i < targetArray.length; i++){ if ( targetArray[i].split("OID")[0] === "cur_yr_new") { targetArray.splice(i, 1); }}  
			rowSum += parseInt( $('#'+value).text().replace(/[^0-9\-.]/g,'') )
			rowDict[value] = rowSum;
			colDict[value] = parseInt( $('#'+value).text().replace(/[^0-9\-.]/g,'') );;			
		}
		else */ if ( $('#'+value).prop('nodeName').toLowerCase() == 'input' ) { 
			// check for running total and use it instead

			rowSum += parseInt( $('#'+value).val().replace(/[^0-9\-.]/g,'') );
			rowDict[value] = rowSum;
			if (value.split("OID")[0] == "cur_yr_new"){
				$('#rtc'+currentID).text('Running total: $ '+rowDict[targetNew].toLocaleString());
				//console.log('FOUND '+value+' - RTC ' +$('#rtc'+value.split("OID")[1]).attr("id")+ ' value is '+$('#rtc'+value.split("OID")[1]).text().replace(/[^0-9\-.]/g,'')+' -- \n')
				colDict[value] = parseInt( $('#rtc'+value.split("OID")[1]).text().replace(/[^0-9\-.]/g,'') );
			} else {
				colDict[value] = parseInt( $('#'+value).val().replace(/[^0-9\-.]/g,'') );
			}
		} else {
			rowSum += parseInt( $('#'+value).text().replace(/[^0-9\-.]/g,'') )
			rowDict[value] = rowSum;
			colDict[value] = parseInt( $('#'+value).text().replace(/[^0-9\-.]/g,'') );;
		}
		//console.log('  element index: ' +index+ '  value: ' +value+ ' rowSum: ' +rowSum+ '\n');
		/* console.log('   rowSum so far: ' +rowSum+ '\n');
		for(var dictEntry in rowDict) {
			console.log('  ' +dictEntry+ '-- ' +rowDict[dictEntry]+ '\n');
		} */
		// nice, now we have a dictionary of row elements with their running totals
	});
		$('#rtc'+currentID).text('Running total: $ '+rowDict[targetNew].toLocaleString());
		$('#rt1'+currentID).text('Running total: $ '+rowDict[target1].toLocaleString());
		$('#rt2'+currentID).text('Running total: $ '+rowDict[target2].toLocaleString());
		$('#rt3'+currentID).text('Running total: $ '+rowDict[target3].toLocaleString());
		$('#rt4'+currentID).text('Running total: $ '+rowDict[target4].toLocaleString());
		$('#rt5'+currentID).text('Running total: $ '+rowDict[target5].toLocaleString());
	return colDict;
	//	console.log('rTotal finished for OID ' +currentID+ '\n');
} // end function
	
	//update the delta hidden element if the user changes a field in the params form
	// onchange() in any field, take the name of the field and change the <name>DELTA value to true
	$("form :input").change(function() {
		//console.log('Keypress has changed ' + this.name + '\n');
  		$(this).closest('form').data('changed', true);
  		var change_element = this.name+'DELTA'; 
  		//console.log('change_element: ' + change_element+'\n');
		$('[name="'+ change_element+ '"]' ).val('true');
		$('.change_warning').show();
		//if ($('#fymForm') == "") {
			$.fn.colTotal();
		//}
	});

	//update the CDELTA hidden element if the user changes a COMMENT field in the params form
	// onchange() in any COMMENT field, take the name of the field and change the <name>DELTA value to COMMENT
	$("form :input[id^='comm_']").change(function() {
		console.log('Keypress has changed ' + this.name + '\n');
  		$(this).closest('form').data('changed', true);
  		var change_element = this.name+'CDELTA'; 
  		console.log('change_element: ' + change_element+'\n');
		$('[name="'+ change_element+ '"]' ).val('COMMENT');
		$('.change_warning').show();
		//if ($('#fymForm') == "") {
			$.fn.colTotal();
		//}
	});		
	// prevent RETURN/ENTER key from submitting form
    $(document).on("keypress", function(event) {
    	if (event.keyCode == 13) {
    		var form = event.target.form;
		    var index = Array.prototype.indexOf.call(form, event.target);
    		form.elements[index + 1].focus();
        	event.preventDefault();
    		return false;
    	}
	});	