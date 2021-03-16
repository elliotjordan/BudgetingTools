<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<cfinclude template="loadUser.cfm" runonce="true">

<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<h2>Bursar Fee Approvals</h2>
	<p>Use this table to review and instantly OK or return individual fee requests from each of the IU campuses.</p>
	<cfinclude template="approval_form.cfm">
</div>  <!-- End DIV class "full_content" -->

<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
