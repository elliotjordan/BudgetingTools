<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<!---<cfdump var="#createCrossTabList()#"><cfabort>--->
<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<h2>Regional Rate Comparison</h2>
	<p>This table shows the rates per each regional campus as a grid.</p>
	<cfinclude template="regional_grid.cfm" >
	<!---
	<hr width="100%">
	<h2>Regional Fee Approvals</h2>
	<p>Use this table to review and instantly OK or return individual fee requests from each of the regional campuses.</p>
	<cfinclude template="approval_form.cfm">  --->
</div>  <!-- End DIV class "full_content" -->
<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
