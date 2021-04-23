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
	$(function(){
	 	$('input[name="feetypechoice"]').on('change', function(){
    		var el = this.value;
     		var targetUrl = "all_fees.cfm?fee_type=".concat(el);
     		window.location.href = targetUrl;
     		//console.log("You were just relocated to "+targetUrl);
      	});
	});
	dynOrgToggle();
	setupPctIncrease();
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


/** AllFeesTable ********/
    if ($('#approvalTable').length > 0) {
	    var table = $('#approvalTable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1,paging:false, info:true });
	    $("#masterTable_info").detach().prependTo('#masterTable_wrapper');
	    $("#masterTable_paginate").detach().prependTo('#masterTable_wrapper');
	}

/** masterTable ********/
    if ($('#masterTable').length > 0) {  //tables get a single row if there are no fees.  Hopefully users don't need to search tables with a single fee...
		// Setup - add a search text input to each header cell
	    $('#masterTable thead tr').clone(true).appendTo( '#masterTable thead' );
	    $('#masterTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input id="blork" type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var table = $('#masterTable').DataTable( { retrieve:true, orderCellsTop: true, fixedHeader: true, paging:false });
	}

/** Tuition/Mandatory table **/
    if ($('#tuitionTable').length > 0) {  //tables get a single row if there are no fees.  Hopefully users don't need to search tables with a single fee...
		// Setup - add a search text input to each header cell
	    $('#tuitionTable thead tr').clone(true).appendTo( '#tuitionTable thead' );
	    $('#tuitionTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var table = $('#tuitionTable').DataTable( {
	    	orderCellsTop: true,
	    	fixedHeader: true,
	    	iDisplayLength: 100,
 			"initComplete": function() {
 				$('#ViewControl').click (function() {
 					if ( !$('#ViewControl').prop("checked") )
            			$('.non_edit_row').fadeIn('slow');
        			else
            			$('.non_edit_row').fadeOut('slow');
 				});
 			}
	    });
	}


/** summaryTable ********/
    if ($('#summaryTable').length > 0) {  //tables get a single row if there are no fees.  Hopefully users don't need to search tables with a single fee...
		// Setup - add a search text input to each header cell
	    $('#summaryTable thead tr').clone(true).appendTo( '#summaryTable thead' );
	    $('#summaryTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var table = $('#summaryTable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1,
	      	"bPaginate": false,
    		"bLengthChange": false,
    		"bFilter": true,
    		"bInfo": true,
    		"bAutoWidth": false });
	}

/** pendingFeesTable ********/
//console.log("campusFeesTableV9 TABLE LENGTH: " + $('#campusFeesTableV9').length );
    if ($('#pendingFeesTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#pendingFeesTable thead tr').clone(true).appendTo( '#pendingFeesTable thead' );
	    $('#pendingFeesTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( ptable.column(i).search() !== this.value ) {
	                 ptable.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var ptable = $('#pendingFeesTable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1 });
	}

/** campusFeesTableV9 ********/
    if ($('#campusFeesTableV9').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#campusFeesTableV9 thead tr').clone(true).appendTo( '#campusFeesTableV9 thead' );
	    $('#campusFeesTableV9 thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( ctable.column(i).search() !== this.value ) {
	                 ctable.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var ctable = $('#campusFeesTableV9').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1 });
	}

/** camPendApprovalTable ********/
    if ($('#camPendApprovalTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#camPendApprovalTable thead tr').clone(true).appendTo( '#camPendApprovalTable thead' );
	    $('#camPendApprovalTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( cptable.column(i).search() !== this.value ) {
	                 cptable.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var cptable = $('#camPendApprovalTable').DataTable( { orderCellsTop: true, fixedHeader: true, paging: false });
	}

/** campusSplitTable ********/
    if ($('#campusSplitTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#campusSplitTable thead tr').clone(true).appendTo( '#campusSplitTable thead' );
	    $('#campusSplitTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        if (title.trim() != "") {
		        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
		        $( 'input', this ).on( 'keyup change', function () {
		            if ( csplittable.column(i).search() !== this.value ) {
		                 csplittable.column(i).search( this.value ).draw();
		            }
		        } );
	        }
	    } );
	    var csplittable = $('#campusSplitTable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1 });
	}

/** regionalGridTable ********/
    if ($('#regionalGridTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#regionalGridTable thead tr').clone(true).appendTo( '#regionalGridTable thead' );
	    $('#regionalGridTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        if (title.trim() != "") {
		        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
		        $( 'input', this ).on( 'keyup change', function () {
		            if ( rptable.column(i).search() !== this.value ) {
		                 rptable.column(i).search( this.value ).draw();
		            }
		        } );
	        }
	    } );
	    var rptable = $('#regionalGridTable').DataTable( { orderCellsTop: true, fixedHeader: true, "pageLength": -1 });
	}

/** cfoApprovalTableUnder2Pct ********/
    if ($('#cfoApprovalTableUnder2Pct').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#cfoApprovalTableUnder2Pct thead tr').clone(true).appendTo( '#cfoApprovalTableUnder2Pct thead' );
	    $('#cfoApprovalTableUnder2Pct thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        if (title.trim() != "") {
		        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
		        $( 'input', this ).on( 'keyup change', function () {
		            if ( cfoUtable.column(i).search() !== this.value ) {
		                 cfoUtable.column(i).search( this.value ).draw();
		            }
		        } );
	        }
	    } );
	    var cfoUtable = $('#cfoApprovalTableUnder2Pct').DataTable( { orderCellsTop: true, fixedHeader: true, "info":true,  "pageLength": -1});
	}


 /** housingTable ********/
    if ($('#housingTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#housingTable thead tr').clone(true).appendTo( '#housingTable thead' );
	    $('#housingTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        if (title.trim() != "") {
		        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
		        $( 'input', this ).on( 'keyup change', function () {
		            if ( cfoUtable.column(i).search() !== this.value ) {
		                 cfoUtable.column(i).search( this.value ).draw();
		            }
		        } );
	        }
	    } );
	    var cfoUtable = $('#housingTable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1 });
	}

	//update the delta hidden element if the user changes a field in the params form
	// onchange() in any field, take the name of the field and change the <name>DELTA value to true
	//$("form :input:not(#blork)").change(function() {
	$("form :input.right-justify").keyup(function() {
		//console.log('Keypress has changed ' + this.name + '\n');
  		$(this).closest('form').data('changed', true);
  		var change_element = this.name+'DELTA';
  		//console.log('change_element: ' + change_element+'\n');
		$('#'+ change_element ).val('true');
		console.log( 'change_element val: ' + $('#'+change_element).val() );
		$('.change_warning').show();
	});
	$( ".target" ).change(function() {
  		//console.log( "Handler for .change() called." );
  		$(this).closest('form').data('changed', true);
  		var change_element = this.name+'DELTA';
  		//console.log('change_element: ' + change_element+'\n');
		$('#'+ change_element ).val('true');
		$('.change_warning').show();
	});

 });
</script>

	</body>
</html>
