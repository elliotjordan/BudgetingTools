<!--- Footer for 5Yr Model pages. --->
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
<script language="javascript" type="text/javascript" src="../js/fym.js"></script>
<script>
$(document).ready(function(){
	//console.log('doc ready \n');
	$('input[name=table_preference]').on('change', function(){
    var n = $(this).val();
    //console.log('radio button: ' + n + ' \n');
    /*switch(n)
    {
            case 'model':
                  $('#scenModelTable').show();
                  $('#scenCrHrTable#').hide();
                  break;
            case 'crhr':
                  $('#scenModelTable').hide();
                  $('#scenCrHrTable#').show();
                  break;
        }  */
    });
	//console.log('HEY '+$('#rtc248').text().replace(/[^0-9\-.]/g,''));
	$(function() {
        // get the full URL at the address bar
        var url = window.location.href;
        // passes on every link_highlight "a" tag
        $(".link_hilight a").each(function() {
            // checks if its the same on the address bar
            if (this.id != 'choiceLink') {
	            //console.log('header link this.id: ' + url + ' - ' + this.id + ' - ' + this.href +'\n');
	            if (url == (this.href)) {
	                $(this).closest("span").addClass("active");
	            }
            }
        });
    }); 
	$('.pm_form').hide();  //pm submit forms start off hidden from view.  Button will show/hide the form as needed.
	$('.change_warning').hide();
	$("input[type='text']").click(function () {
		if(! $(this).is(':focus') ) {
   			$(this).select();
   		}
	});
	// Calculate all the running totals when the page loads
//	$(' input[id ^="cur_yr_newOID"]').not('input[id $="DELTA"]').each(  function() {$(this).rTotal(this)  }  );
//	$.fn.colTotal();
	/** 5YR Model dataTables ******* */
    if ($('#fymMainTable1').length > 0) {
	    var table1 = $('#fymMainTable1').DataTable( { "order": [], "paging": false });
	}

    if ($('#fymMainTable2').length > 0) {
	    var table2 = $('#fymMainTable2').DataTable( { "order": [], "paging": false });
	}

	if ($('#fymMainTable3').length > 0) {
	    var table3 = $('#fymMainTable3').DataTable( { "order": [], "paging": false });
	}

	if ($('#fymParamsTable').length > 0) {
	   // var tablep = $('#fymParamsTable').DataTable( { "order": [ [0,"asc"],[1,"asc"],[2,"asc"]], "paging": false });
	    var tablep = $('#fymParamsTable').DataTable( { "paging": false });
	    $('#LN1_DESC_search').on( 'keyup', function () {tablep.columns( 2 ).search( input[smart] ).draw();console.log('blorks')} );
	    $('#LN2_DESC_search').on( 'keyup', function () {tablep.columns( 3 ).search( this.value ).draw();console.log('blarks')} );
	}

 });
</script>
	</body>
</html>