<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allTargets = getTargets()>
<cfoutput>
<div class="full_content">
	<h2>Project Targets</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
<!-- Begin targets Table -->
		<table id="targetsTable" class="feeCodeTable">
			<thead>
				<tr>
					<th>Project Name</th>
					<th>Target</th>
					<th>Notes</th>
					<th>Next Target Date</th>
					<th>Status</th>
				</tr>
			</thead>
			<tbody>
				<cfif allTargets.recordCount gt 0>
				<cfloop query="allTargets">
					<tr>
						<td>#proj_name#<br>
							<span class="sm-blue">#getTeamMember(proj_owner).staff_first_last_name#</span>
						</td>
						<td>#targ_desc#</td>
						<td>#targ_date#</td>
						<td>#targ_notes#</td>
						<td>#targ_status#</td>
				</cfloop>
				<cfelse>
					<tr><td colspan="5">This project has no target dates set.</td></tr>
				</cfif>
			</tbody>
		</table>
<!-- End teams Table -->
	

</cfoutput>
<cfinclude template="../includes/header_footer/pm_footer.cfm" />