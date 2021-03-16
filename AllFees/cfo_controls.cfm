<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<cfinclude template="approvals_summary.cfm">
	<h2>CFO Fee Approvals</h2>
	<p>Use this table to review and instantly Approve, Deny, or Return individual fee requests from each of the IU campuses.</p>
	<cfinclude template="cfo_approval_form.cfm">
</div>  <!-- End DIV class "full_content" -->

<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
