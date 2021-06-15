<!-- Chrome sucks -->
<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<cfset fee_params = getFeeParamData() />
<cfset afm_de_asso = getAFM_DE_asso() />
<cfset afm_params = getAFMparams() />
<cfset delta = getDEchangeReport() />
<cfset unAssDE = getUnassociatedDE() />
<cfset tuitionList = getTuitionList() />

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
<!---	<h2>Push Fees to Bursar View</h2>
	<cfinclude template="update_bursar.cfm" runonce="true" />
	--->
	<h2>Distance Ed Settings</h2>
	<cfinclude template="de_controls.cfm" runonce="true" />
	
<!---	<h2>UBO Fee Approvals</h2>
	<p>Use this table to review and instantly OK or return individual fee requests from each of the IU campuses.</p>
	<p><i>Table temporarily hidden</i></p>--->
	<!---<cfinclude template="approval_form.cfm" runonce="true" />--->
</div>  <!-- End DIV class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" runonce="true" />
