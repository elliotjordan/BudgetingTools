<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>
<cfoutput>
<cfif IsDefined("form") AND StructKeyExists(form,'bursarUpdateBtn') and form.bursarUpdateBtn eq 'UPDATE'>
	<cfset resetReport = updateBursarView()>
	<h2>NOTE:</h2>
	<p>BURSAR TABLE UPDATED WITH #resetReport# rows</p>
</cfif>
<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<h2>Push Fees to Bursar View</h2>
	<cfinclude template="update_bursar.cfm" runonce="true" />
	
	<h2>Distance Ed Settings</h2>
	<h4>Prototype - what are we doing?</h4>
	<p>Associate distance ed fee with base fee -> apply rule to distance ed rate</p>
	<cfinclude template="de_controls.cfm" runonce="true" />
	
	<h2>UBO Fee Approvals</h2>
	<p>Use this table to review and instantly OK or return individual fee requests from each of the IU campuses.</p>
	<cfinclude template="approval_form.cfm" runonce="true" />
</div>  <!-- End DIV class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
