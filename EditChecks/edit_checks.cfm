<cfinclude template="../includes/functions/edit_check_functions.cfm">
<div class="full_content">
	<cfif IsDefined("form") AND StructKeyExists(form,"CAMP_SELECT")>
		<cfif ListGetAt(form.camp_select,2) eq 'IN'>
			<cfset POV_org_result = getCheck06_byCampus(ListGetAt(form.camp_select,2))>			
		<cfelse>
			<cfset POV_org_result = getCheck06_byOrg(ListGetAt(form.camp_select,2))>
		</cfif>
		<!---<cfdump var="#POV_org_result#" >--->
		<cfinclude template="download_edit_check_results.cfm">
	<cfelse>
		<cfset editCheck06 = getCheck06() />
		<h2>Edit Checks</h2>
		<p>Select your point of view, please.</p>
		<form name="POV_form" method="post" action="edit_checks.cfm">
			<label for="camp_select">Campus</label>
			<select size="1" name="camp_select">
				<option>--Please select a point of view --</option>
				<option label="Campus" value="IN,IN">IN - IN</option>
				<option label="Campus" value="IN,SURG">IN - SURG</option>	
				<option label="Campus" value="IN,BOGUS">IN - ALL OK</option>
			</select>
			<input type="submit" id="POV_btn" name="POV_btn" value="Go">Download Excel</button>
		</form>
		
	</cfif>
	<!--- hidden for now until we know more
	<hr width="80%">
	<h3>Edit Checks Table</h3>
	<cfinclude template="includes/forms/edit_check_table.cfm" >
	--->
	
</div>  <!-- End of Content Div -->
