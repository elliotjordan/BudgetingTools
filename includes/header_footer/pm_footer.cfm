<!--- Footer for project management pages. --->
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

<script>
$(document).ready(function(){
	$('.pm_form').hide();  //pm submit forms start off hidden from view.  Button will show/hide the form as needed.

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
 });
</script>
	</body>
</html>