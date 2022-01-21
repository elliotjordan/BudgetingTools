<cfoutput>
	<cfset currentScenario = getCurrentScenario(current_scenario) />
	<cfset currentScenarioData = getCurrentScenarioData(current_scenario) />
	<!---<cfdump var="#currentScenarioData#" >--->
	<h2>Model Scenario Overrides for #current_inst#: "#currentScenario.scenario_cd# - #currentScenario.scenario_nm#"</h2>
	<p>To switch campuses, use the selector in the header.</p>
	<input type="submit" name="scenModelBtn" value="Update Model Scenario" />
	<table id="scenModelTable" class="allFeesTable" border="1">
		<thead>
			<tr class="newFee">
				<th>Campus</th>
				<th>Chart / Fund</th>
				<th>Sub-fund</th>
				<th>Description</th>
				<th>Override type</th>
				<th>FY#application.shortfiscalyear#</th>
				<th>FY#application.shortfiscalyear + 1#</th>
				<th>FY#application.shortfiscalyear + 2#</th>
				<th>FY#application.shortfiscalyear + 3#</th>
				<th>FY#application.shortfiscalyear + 4#</th>
				<th>FY#application.shortfiscalyear + 5#</th>
			</tr>
		</thead>
		<tbody>
			<cfif currentScenario.recordCount gt 0>
				<cfloop query="#currentScenarioData#">
					<cfif currentScenarioData.scenario_cd eq scenario_cd and currentScenarioData.chart_cd eq current_inst>
						<tr>
							<td>#inst_cd#
							  <input type="hidden" value="#OID#" name="oid" />
							  <input type="hidden" value="#currentScenarioData.currentRow#" name="dataRow" />
							</td>
							<td>#chart_cd# / #grp1_desc# - #grp2_desc#
							</td>
							<td>#ln1_cd# - #ln1_desc#</td>
							<td>#ln2_cd# - #ln2_desc#</td>
							<td>#scenario_type_nm#</td>
							<td>
								<input name="cur_yr_newOID#OID#" value="#cur_yr_new#" />
								<input name="cur_yr_newOID#OID#DELTA" type="hidden" value="false">
							</td>
							<td><input name="yr1_newOID#OID#" value="#yr1_new#" /><input name="yr1_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr2_newOID#OID#" value="#yr2_new#" /><input name="yr2_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr3_newOID#OID#" value="#yr3_new#" /><input name="yr3_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr4_newOID#OID#" value="#yr4_new#" /><input name="yr4_newOID#OID#DELTA" type="hidden" value="false" /></td>
							<td><input name="yr5_newOID#OID#" value="#yr5_new#" /><input name="yr5_newOID#OID#DELTA" type="hidden" value="false" /></td>
						</tr>
					</cfif>
				</cfloop>
    		<cfelse>
    			<td colspan=11>No overrides found for this scenario.</td>
			</cfif>
		</tbody>
	</table>
</cfoutput>