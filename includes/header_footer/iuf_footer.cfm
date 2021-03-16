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

/** AllFeesTable ********/
    if ($('#IUFtable').length > 0) {  //tables get a single row if there are no fees.  Hopefully users don't need to search tables with a single fee...
		// Setup - add a search text input to each header cell
	    $('#IUFtable thead tr').clone(true).appendTo( '#IUFtable thead' );
	    $('#IUFtable thead tr:eq(1) th').each( function (i) {
	        var title = $(this).text();
	        $(this).html( '<input type="text" placeholder="Search '+title+'" class="sm-blue" size="16" />' );
	        $( 'input', this ).on( 'keyup change', function () {
	            if ( table.column(i).search() !== this.value ) {
	                table.column(i).search( this.value ).draw();
	            }
	        } );
	    } );
	    var table = $('#IUFtable').DataTable( { orderCellsTop: true, fixedHeader: true, iDisplayLength: -1 });
	}

 });
</script>

	</body>
</html>
