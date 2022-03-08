<!--- Footer for all pages. --->
	<cfset CurrentDate=DateFormat(Now()) />
	<!-- BEGIN INDIANA UNIVERSITY FOOTER -->
    	<div id="footer" role="contentinfo">
        	<div class="wrapper">
                <p class="internal"><a href="#">Privacy Notice</a></p>
                <p class="copyright">
                    <a href="http://www.iu.edu/" class="block-iu"><img src="../_iu-brand/img/block-iu.png" height="26" width="22" alt="Block IU" /></a> 
                    <span class="line-break">
                        <a href="http://www.iu.edu/copyright/index.shtml">Copyright</a> &#169; <cfoutput>#Year(CurrentDate)#</cfoutput>
                    </span> 
                    <span class="line-break">The Trustees of <a href="http://www.iu.edu/">Indiana University</a>,</span> 
                    <span class="line-break"><a href="http://www.iu.edu/copyright/complaints.shtml">Copyright Complaints</a></span>
                </p>
            </div>
        </div>
        <!-- END INDIANA UNIVERSITY FOOTER -->
<!--- javascript --->
<!--- NOTE: The table headers will not appear unless they are included this way.  The HTML headers in the form are there in case javascript fails --->
<!--- NOTE SOME MORE: If the number of aoColumns defined does not match the number in the table, you will get an error --->
<script>

$(document).ready(function(){
	$('.change_warning').hide();
	
	$( "#gradClicker" ).click(function() { $("#gradFeesDiv").toggle(); });
	$( "#ugClicker" ).click(function() { $("#ugFeesDiv").toggle(); });
	$( "#occClicker" ).click(function() { $("#occFeesDiv").toggle(); });
	$( "#othClicker" ).click(function() { $("#othFeesDiv").toggle(); });
	$( "#bandClicker" ).click(function() { $("#bandFeesDiv").toggle(); });
	$( "#fcpClicker" ).click(function() { $("#fcpFeesDiv").toggle(); });
	
  //update the delta hidden element if the user changes a field in the params form
  // onchange() in any field, take the name of the field and change the <name>DELTA value to true
	$("form :input").change(function() {
		//console.log('form inpout changed for ' + this.name + '\n')
		var $handle = $(this);
		//console.log('Keypress has changed ' + this.name + '\n');
		if (this.name != 'fundRad' &&  $handle.is("input")) { 
	  		$(this).closest('form').data('changed', true);
	  		var change_element = this.name+'DELTA'; 
	  		//console.log('change_element: ' + change_element+'\n');
			$('[name="'+ change_element+ '"]' ).val('true');
			if (this.name != 'fundRad') {
				$('.change_warning').show();
			}
			//$.fn.colTotal();
		}
		if ($handle.is("textarea")) {
			//console.log('Textarea input changed\n');
	        
			//console.log('Changed comment field ' + this.name + '\n');
	  		$(this).closest('form').data('changed', true);
	  		var change_element = this.name+'CDELTA'; 
	  		//console.log('comment change_element: ' + change_element+'\n');
			$('[name="'+ change_element+ '"]' ).val('COMMENT');
			$('.change_warning').show();
		}
	});
//
//	calcVisibleSubTotal();
	//var stepCounter = 1;
	//console.log(" --- stepCounter: " + stepCounter + "\n");
	calcCrHrTotal();
	updateCampusGrands();
	calcVisibleSubTotal();
	// prevent RETURN/ENTER key from submitting form
    $(document).on("keypress", function(event) {
    	if (event.keyCode == 13) {
    		var form = event.target.form;
		    var index = Array.prototype.indexOf.call(form, event.target);
    		form.elements[index + 1].focus();
        	event.preventDefault();
    		return false;
    	}
    	calcVisibleSubTotal();
	});
	
	/* Custom filtering function which will search data in column between two values */
	$.fn.dataTable.ext.search.push(
	    function( settings, data, dataIndex ) {
	        var gradmin = parseInt( $('#gradmin').val(), 10 );
	        var gradmax = parseInt( $('#gradmax').val(), 10 );
	        var testParse = parseFloat(data[9]);
	        var materialAmt = parseFloat( data[9] ) || 0; // use UBO Projected Hours
	        if ( 
	          	( isNaN( gradmin ) && isNaN( gradmax ) ) ||
	            ( isNaN( gradmin ) && materialAmt <= gradmax ) ||
	            ( gradmin <= materialAmt   && isNaN( gradmax ) ) ||
	            ( gradmin <= materialAmt   && materialAmt <= gradmax )  //||
	           )  
	        {
	            return true;
	        }
	        return false;
	    }
	);	

	$.fn.dataTable.ext.search.push(
	    function( settings, data, dataIndex ) {
	        var ugrdmin = parseInt( $('#ugrdmin').val(), 10 );
	        var ugrdmax = parseInt( $('#ugrdmax').val(), 10 );
	        var testUgrdParse = parseFloat(data[9]);
	        var ugrdMaterialAmt = parseFloat( data[9] ) || 0; // use UBO Projected Hours
	       // console.log("min: " + ugrdmin + " - max: " + ugrdmax + " - \ntestParse:" + testUgrdParse + "\nmaterialAmt: " + ugrdMaterialAmt + " - data[9]: " + data[9]);	 
	        if ( 
	          	( isNaN( ugrdmin ) && isNaN( ugrdmax ) ) ||  
                ( isNaN( ugrdmin ) && ugrdMaterialAmt <= ugrdmax ) || 
	            ( ugrdmin <= ugrdMaterialAmt   && isNaN( ugrdmax ) ) || 
	            ( ugrdmin <= ugrdMaterialAmt   && ugrdMaterialAmt <= ugrdmax ) 
	           )  
	        {
	            return true;
	        }
	        return false;
	    }
	);	

    
	//manage the users table
	// NOTE: There must be an aoColumns row defined for each table column or you 
	//       will get a C is not defined error from dataTables.js
    if ($('#allFeesTable').length > 0) {
	    var allFees_table = $('#allFeesTable').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	        aoColumnDefs: [  
	        	{ "bSearchable": false, "sTitle":"Line No.", "sType":"string", "bSortable":false },
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	//{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Tuition Group", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Academic Career", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"string", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"string", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Constant Effective Rate", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"string", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	}  //,
	       // buttons: ['copy','print', {extend:'colvis', text: 'Show/Hide Columns', columns: ':not(.noVis)'}]
	    });
	    new $.fn.dataTable.FixedHeader( allFees_table );
	    }  
	    
	  if ($('#gradFeesTable').length > 0) {
	    var gradFees_table = $('#gradFeesTable').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	    	bAutoWidth: false,
	        aoColumnDefs: [  
	        	{ "bSearchable": false, "sTitle":"Line No.", "sType":"numeric", "bSortable":false },
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	//{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Tuition Group", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Academic Career", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"FY19 Effective Rate", "sType":"numeric", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"numeric", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	}//,
	        //buttons: ['copy','print', {extend:'colvis', text: 'Show/Hide Columns', columns: ':not(.noVis)'}]
	    });
	    new $.fn.dataTable.FixedHeader( gradFees_table );
	    }  

    if ($('#ugrdFeesTable').length > 0) {
	    var ugrdFees_table = $('#ugrdFeesTable').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	    	bAutoWidth: false,
	        aoColumnDefs: [  
	        	{ "bSearchable": false, "sTitle":"Line No.", "sType":"numeric", "bSortable":false },
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	//{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Tuition Group", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Academic Career", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"FY19 Effective Rate", "sType":"numeric", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"numeric", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	} //,
	        //buttons: ['copy','print', {extend:'colvis', text: 'Show/Hide Columns', columns: ':not(.noVis)'}]
	    });
	    new $.fn.dataTable.FixedHeader( ugrdFees_table );
	    }  
	    
    if ($('#otherFeesTable').length > 0) {
	    var otherFees_table = $('#otherFeesTable').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	    	bAutoWidth: false,
	        aoColumnDefs: [  
	        	{ "bSearchable": false, "sTitle":"Line No.", "sType":"numeric", "bSortable":false },
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Tuition Group", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Academic Career", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"FY19 Effective Rate", "sType":"numeric", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"numeric", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	}//,
	       // buttons: ['copy','print', {extend:'colvis', text: 'Show/Hide Columns', columns: ':not(.noVis)'}]
	    });
	    new $.fn.dataTable.FixedHeader( otherFees_table );
	    }  
	    
    if ($('#clearingSummaryTable').length > 0) {
	    var clearingSummaryTable = $('#clearingSummaryTable').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	    	bAutoWidth: false,
	        aoColumnDefs: [  
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"FY19 Effective Rate", "sType":"numeric", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"numeric", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	}//,
	        //buttons: ['copy','print', {extend:'colvis', text: 'Show/Hide Columns', columns: ':not(.noVis)'}]
	    });
	    new $.fn.dataTable.FixedHeader( clearingSummaryTable );
	    }  

    if ($('#csTable2').length > 0) {
	    var csTable2 = $('#csTable2').DataTable(
	    {
	    	dom: "Bfrtip",
	    	iDisplayLength:-1,
	    	bAutoWidth: false,
	        aoColumnDefs: [  
	        	{ "bSearchable": true, "sTitle":"Fee Code", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Fee Description", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Term", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": false, "sTitle":"Residency", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Object Code", "sType":"string", "bSortable":true }, 
	        	{ "bSearchable": true, "sTitle":"Account", "sType":"string", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Actual", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"UBO Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"Campus Projected Hours", "sType":"numeric", "bSortable":true},
	        	{ "bSearchable": true, "sTitle":"FY19 Effective Rate", "sType":"numeric", "bSortable":true },
	        	{ "bSearchable": true, "sTitle":"Estimated Revenue (CrHrs * Const Eff Rate)", "sType":"numeric", "bSortable":true }
	        ],
	        columnDefs: [{
	        	targets: 1,
	        	className: 'noVis'
	        }],
	        fixedColumns:   {
            	heightMatch: 'auto'
        	},
        	buttons: []
	    });
	    new $.fn.dataTable.FixedHeader( csTable2 );
	    }  

	$(".paginate_button").hide();
	//stepCounter = stepCounter + 1;
	//console.log("Added 1 to stepCounter: " + stepCounter + "\n");

 });

</script>

	</body>
</html>
