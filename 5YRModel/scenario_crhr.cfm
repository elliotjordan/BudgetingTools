<cfoutput>
	<cfset currentScenCrHr = getScenarioCrHr(current_scenario) />
	<h2>CrHr Scenario Overrides: "#currentScenario.scenario_cd# - #currentScenario.scenario_nm#"</h2>
	<input type="submit" name="scenCrHrBtn" value="Update CrHr Scenario" />
				<table id="scenTable2" class="allFeesTable" border="1">
					<thead>
						<tr class="newFee">
							<th>Scen_Code</th>
							<th>Scen_name</th>
							<th>Scen_type_cd</th>
							<th>Inst_cd</th>
							<th>Chart_cd</th>
							<th>acad_career</th>
							<th>res</th>
							<th>cur_yr_hrs_new</th>
							<th>yr1_hrs_new</th>
							<th>yr2_hrs_new</th>
							<th>yr3_hrs_new</th>
							<th>yr4_hrs_new</th>
							<th>yr5_hrs_new</th>
						</tr>
					</thead>
					<tbody>
						<cfif currentScenCrHr.recordCount gt 0>
							<cfloop query="#currentScenCrHr#">
							<tr>
								<td>#scenario_cd#</td>
								<td>#scenario_nm#</td>
								<td>#scenario_type_cd#</td>
								<td>#inst_cd#</td>
								<td>#chart_cd#</td>
								<td>#acad_career#</td>
								<td>#res#</td>
								<td>#cur_yr_hrs_new#</td>
								<td>#yr1_hrs_new#</td>
								<td>#yr2_hrs_new#</td>
								<td>#yr3_hrs_new#</td>
								<td>#yr4_hrs_new#</td>
								<td>#yr5_hrs_new#</td>
							</tr>
							</cfloop>
			    		<cfelse>
			    			<tr><td colspan=11>No overrides found for this scenario.</td></tr>
			    		</cfif>
			    		
					</tbody>
				</table>
</cfoutput>