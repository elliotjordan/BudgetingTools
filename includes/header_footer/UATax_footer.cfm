<!--- Footer for UATax pages. --->
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
<script>
	$(document).ready(function(){
		/* Prevent RETURN/ENTER key from submitting form  */
		$(document).on("keypress", function(event) {
	    	if (event.keyCode == 13) {
	    		var form = event.target.form;
			    var index = Array.prototype.indexOf.call(form, event.target);
	    		form.elements[index + 1].focus();
	        	event.preventDefault();
	    		return false;
	    	}
	    });

		// from W3C example - When the user scrolls the page, execute myFunction
		window.onscroll = function() {myFunction()};
		// Get the header
		var header = document.getElementById("tableHeader");
		// Get the offset position of the navbar
		if (header != null) {
		var sticky = header.offsetTop;
		// Add the sticky class to the header when you reach its scroll position. Remove "sticky" when you leave the scroll position
		function myFunction() {
		  if (window.pageYOffset > sticky) {
		    header.classList.add("sticky");
			//Use jquery to set the header width equal to the table width
			$("th.wide").css("width","218px");
		  } else {
		    header.classList.remove("sticky");
		  }
		}
		} //end if

		var  currentPage = window.location.pathname;
		//console.log('Loaded');
		$('#jr1').click(function() {
			//console.log('justify1 clicked');
	    	$('#just_text_input').hide('fast');
	        $('#just_file_input').show('fast');
		});

		$('#jr2').click(function() {
			//console.log('justify2 clicked');
	    	$('#just_file_input').hide('fast');
	        $('#just_text_input').show('fast');
		});

/** uaTaxSummaryTable ********/
    if ($('#uaTaxSummaryTable').length > 0) {
	    var summTable = $('#uaTaxSummaryTable').DataTable( { ordering:false, fixedHeader: true, paging: false, bAutoWidth:false 	});
	}
/** end uaTaxSummaryTable **/

/* ******** uaTaxAdjBaseTable **/
	var adjBaseTable = $('#uaTaxAdjBaseTable').DataTable( { "order": [], "paging": false, bAutoWidth:false });
/* ***** end uaTaxAdjBaseTable **/
/* ***** uaAssSumTable **/
	var assummTable = $('#uaAssSumTable').DataTable( { "order": [], "paging": false, bAutoWidth:false });
/* ***** end uaAssSumTable **/
/** uaTaxDetailTable ********/
    if ($('#uaTaxDetailTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#uaTaxDetailTable thead tr').clone(true).appendTo( '#uaTaxDetailTable thead' );
	    $('#uaTaxDetailTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var detailTable = $('#uaTaxDetailTable').DataTable( { orderCellsTop: true, fixedHeader: true,  paging: false });
	}
/** end uaTaxDetailTable **/

/** incIncDataTable ********/
    if ($('#incIncDataTable').length > 0) {
		// Setup - add a search text input to each header cell
	    $('#incIncDataTable thead tr').clone(true).appendTo( '#uaTaxDetailTable thead' );
	    $('#incIncDataTable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var iiDataTable = $('#incIncDataTable').DataTable( { orderCellsTop: true, fixedHeader: true,  paging: false });
	}
/** end uaTaxDetailTable **/
	 });  //close document.ready() - don't erase me :^)
</script>
	</body>
</html>