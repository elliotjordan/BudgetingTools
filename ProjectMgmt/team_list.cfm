<!--- this page is a "partial" to be included on teams.cfm  --->
<!-- Begin projectsTable -->
<cfoutput>
	<h2>Active Teams</h2>
	<table id="teamsTable" class="feeCodeTable">
		<thead>
			<tr>
				<th class="tooltip2">Project Name 
				  <span class="tooltiptext">The unique project name assigned to each project</span></th>
				<th class="tooltip2">Role 
				  <span class="tooltiptext">The unique role title each team member has relative to each project entered (e.g., PM, Lead, Technical, etc.)</span></th>
				<th class="tooltip2">Team Lead
				  <span class="tooltiptext">The name of each team member who is on a specific project</span></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="allTeams">
				<tr>
					<!---<td>#getAllProjects(proj_id).proj_name#</td>--->
					<td>#proj_id# #proj_name#</td>
					<td>#team_role#</td>
					<td><input type="hidden" value="#staff_id#">#staff_first_last_name#</td>
			</cfloop>
		</tbody>
	</table>
</cfoutput>
<!-- End teams Table -->