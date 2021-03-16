<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/UBO_template_functions.cfm">

<cfset currentUser = getUBOUser(REQUEST.authUser) />

<cfoutput>
	<div class="full_content">
		<h1>Budgeting Tools - UBO Templates</h1>
		<cfif Len(currentUser.username) gt 0 and ListFindNoCase(REQUEST.Approver_list,currentUser.username)>
			<h3>Welcome, #currentUser.FIRST_LAST_NAME#</h3>
			<p>Please select the report you would like to view.</p>
			<form id="selForm" action="monthly_detail.cfm" method="post">
				<select name="templateSelect" form="selForm">
					<option value="1" selected="selected">Monthly GL Detail Report</option>
					<option value="2">--</option>
					<option value="3">--</option>
				</select>
				<input type="submit" alt="Submit Choice of Report" value="Submit" />
			</form>

			<cfif StructKeyExists(url,"message")>
				<h3 class="warning">#url.message#</h3>
				<h4 class="warning">You have requested a report which is broken, missing, or sitting on the Group W bench.  Please contact John and ask him what in the world he is doing.</h4>
			</cfif>
        <cfelse>
			<h2>One of Those Days</h2>
			<p>Hello, #currentUser.FIRST_LAST_NAME#.  Welcome to the University Budget Office Template page.  You are not currently authorized to use these tools.</p> 
			<p>If you believe you should have access, please email us at <a href="mailto:budu@iu.edu">budu@iu.edu</a> and request it.</p>
			<p>If you are in a hurry, please call us instead.  We would love to hear from you anyway!  Our phone numbers are here in our <a href="https://budu.iu.edu/about/staff.php">staff listing</a>. Thank you.
			</p>
		</cfif>
	</div>  <!-- End class full_content   -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">
