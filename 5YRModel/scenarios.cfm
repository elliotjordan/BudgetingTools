<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput>

<cfif listFindNoCase(REQUEST.adminUsernames, currentUser.username) OR ListFindNoCase(REQUEST.regionalUsernames, currentUser.username)>
	
	<cfset allScenarios = getScenarios() />  
	<cfset currentScenario = getScenarioData('2') />
	<!---<cfset coreTest = getFYMparams() />  <cfdump var="#coreTest#"/>--->
	<cfset currentUser = getFYMUser(REQUEST.authUser) />
	<cfif ListFindNoCase(REQUEST.adminUsernames,currentUser.username)><cfset editor = "YES"><cfelse><cfset editor = "NO"></cfif>
	<div class="full_content">
	    <cfinclude template="test_banner.cfm" runonce="true" />
	
	<h2>Scenario Details for <!---#getDistinctChartDesc(currentUser.fym_inst)# --->FY#application.shortfiscalyear#</h2>
	
	<p>her is where we can put the single base rowq of data for a scenario update form.</p>
	<cfif StructKeyExists(url,'row')>
		<cfset scenario_row = getNewScenarioDataRow(#url.row#) />
		<cfdump var="#scenario_row#" >
	</cfif>
	
	<!---<cfdump var="#allScenarios#" > <cfabort>--->
	<p>Use this table to view and maintain your scenarios</p>
	<!-- Begin 5YR Parameters form -->
		 	<form action = "scenario_submit.cfm" id = "scenarioForm" method = "POST">
		 		<cfif editor>
					<input id="scenSubmit" type="submit" name="scenSubmit" value="Submit Scenario Updates" />
				</cfif>
				<table id="scenTable" class="allFeesTable" border="1">
					<thead>
						<tr class="newFee">
							<th>Scen_OID</th>
							<th>Scen_title</th>
							<th>Scen_user</th>
						</tr>
					</thead>
					<tbody>
						
						<cfloop query="#allScenarios#">
						<tr>
							<td>
								<input name="OID#OID#" value="#OID#" width="8" size="12" />
								<input type="hidden" id="OID#OID#DELTA" name="OID#OID#DELTA" value="false" />
							</td>
							<td>#scen_title#</td>
							<td>#scen_user#</td>
						</tr>
						</cfloop>
			    		
					</tbody>
				</table>
				<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
				<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
				<input id="scenSubmit" type="submit" name="scenSubmit" value="Submit Scenario Updates" />
			</form>
	<!-- End 5YR Scenarios form -->
	<!---<cfdump var="#currentScenario#" >--->
	<h2>Current Scenario: "<b>#currentScenario.scenario_nm#</b>"</h2>
	<p>User selects a current scenario upon which to do work. This is our context</p>
				<table id="scenTable2" class="allFeesTable" border="1">
					<thead>
						<tr class="newFee">
							<th>Scen_Code</th>
							<th>Scen_name</th>
							<th>Scen_type_cd</th>
							<th>ln1_cd</th>
							<th>ln2_cd</th>
							<th>cur_yr_new</th>
							<th>yr1_new</th>
							<th>yr2_new</th>
							<th>yr3_new</th>
							<th>yr4_new</th>
							<th>yr5_new</th>
						</tr>
					</thead>
					<tbody>
						
						<cfloop query="#currentScenario#">
						<tr>
							<td>#scenario_cd#</td>
							<td>#scenario_nm#</td>
							<td>#scenario_type_cd#</td>
							<td>#ln1_cd#</td>
							<td>#ln2_cd#</td>
							<td>#cur_yr_new#</td>
							<td>#yr1_new#</td>
							<td>#yr2_new#</td>
							<td>#yr3_new#</td>
							<td>#yr4_new#</td>
							<td>#yr5_new#</td>
						</tr>
						</cfloop>
			    		
					</tbody>
				</table>
	</div> <!-- End class="full_content" -->
<cfelse>
	<h2>Hey Sam, May I Borrow the Car?</h2>
	<p>You do not currently have permission to view Scenarios. Please ask the Budget Director for access.</p>
</cfif>
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
