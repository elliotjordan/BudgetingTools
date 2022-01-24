<cfoutput>
	<cfset currentScenCrHr = getScenarioCrHr(current_scenario) />
	<h2>CrHr Scenario Overrides for #current_inst#: "#currentScenario.scenario_cd# - #currentScenario.scenario_nm#"</h2>
	<input type="submit" name="scenCrHrBtn" value="Update CrHr Scenario" />
	<table id="scenTable2" class="allFeesTable" border="1">
		<thead>
			<tr class="newFee">
				<th>Campus</th>
				<th>Academic<br>Career</th>
				<th>Residency</th>
				<th>Override Type</th>
				<th>>FY#application.shortfiscalyear#</th>
				<th>>FY#application.shortfiscalyear + 1#</th>
				<th>>FY#application.shortfiscalyear + 2#</th>
				<th>>FY#application.shortfiscalyear + 3#</th>
				<th>>FY#application.shortfiscalyear + 4#</th>
				<th>>FY#application.shortfiscalyear + 5#</th>
			</tr>
		</thead>
		<tbody>
			<cfif currentScenCrHr.recordCount gt 0>
				<cfloop query="#currentScenCrHr#">
					<cfif currentScenCrHr.scenario_cd eq scenario_cd and currentScenCrHr.chart_cd eq current_inst>
						<tr>
							<td>
								#inst_cd#
								<input type="hidden" value="#OID#" name="oid" />
							    <input type="hidden" value="#currentScenCrHr.currentRow#" name="dataRow" />
							</td>
							<td>#acad_career#</td>
							<td>#res#</td>
							<td>#scen_type_cd#</td>
							<td><input name="cur_yr_hrs_newOID#OID#" value="#cur_yr_hrs_new#" /><input name="cur_yr_hrs_newOID#OID#DELTA" type="hidden" value="false"></td>		
							<td><input name="yr1_hrs_newOID#OID#" value="#yr1_hrs_new#" /><input name="yr1_hrs_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr2_hrs_newOID#OID#" value="#yr2_hrs_new#" /><input name="yr2_hrs_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr3_hrs_newOID#OID#" value="#yr3_hrs_new#" /><input name="yr3_hrs_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr4_hrs_newOID#OID#" value="#yr4_hrs_new#" /><input name="yr4_hrs_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr5_hrs_newOID#OID#" value="#yr5_hrs_new#" /><input name="yr5_hrs_newOID#OID#DELTA" type="hidden" value="false" /></td>
						</tr>
					</cfif>
				</cfloop>
    		<cfelse>
    			<tr><td colspan=11>No overrides found for this scenario.</td></tr>
    		</cfif>
		</tbody>
	</table>
</cfoutput>