<cfinclude template="../includes/header_footer/allfees_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />
<cfinclude template="loadUser.cfm" runonce="true">
<cfoutput>
<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<h2>#session.curr_proj_chart# Fiscal Officer Non-instructional Fee Approvals</h2>
	<p>Use this table to review and instantly approve or deny individual fee requests.</p>
	<cfinclude template="approval_form.cfm">
</div>  <!-- End DIV class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
