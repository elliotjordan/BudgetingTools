<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset currentUser = getFYMUser(REQUEST.authUser) />
<cfoutput>
<cfset focus_selection = '' />
<cfif listFindNoCase(REQUEST.adminUsernames, currentUser.username) OR ListFindNoCase(REQUEST.regionalUsernames, currentUser.username)>
	<cfset allScenarios = getScenarios() />  
	<cfif ListFindNoCase(REQUEST.adminUsernames,currentUser.username)><cfset editor = "YES"><cfelse><cfset editor = "NO"></cfif>
	<div class="full_content">
	    <cfinclude template="test_banner.cfm" runonce="true" />
	<h2>Scenario Details for Scenario #scenario_details.scenario_nm# - FY#application.shortfiscalyear#</h2>
	<form name="fymFocusForm" action="fym_focus.cfm" method="post">
		<label for="scenarios">Choose a scenario:</label>
		<select name="scenarios">
			<cfloop query="#allScenarios#">
				<cfif current_scenario eq oid><cfset focus_selection = 'selected' /><cfelse><cfset focus_selection = '' /></cfif>
				<option value="#oid#" #focus_selection#>Scenario #oid# - #scenario_owner# - #scenario_nm#</option>
			</cfloop>
		</select>
		<input type="submit" name="fymSubmitBtn" value="View Table">
	</form>
	<cfif StructKeyExists(url,'row')>
		<cfset scenario_row = getNewScenarioDataRow(#url.row#) />
		<cfdump var="#scenario_row#" >
	</cfif>
		<!-- Begin Scenarios form -->
	<form name="fymScenUpdateForm" action="fym_scen_update.cfm" method="post">
		<cfinclude template="scenario_data.cfm" runonce="true" />
		<cfinclude template="scenario_crhr.cfm" runonce="true" />
	</form>
		<!-- End 5YR Scenarios form -->
	</div> <!-- End class="full_content" -->
<cfelse>
	<h2>Hey Sam, May I Borrow the Car?</h2>
	<p>You do not currently have permission to view Scenarios and no, you may not borrow the car. 
	   Please ask the Budget Director for access, after you clean your room and take out the trash.</p>
</cfif>
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
