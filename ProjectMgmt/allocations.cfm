<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allAllocations = getAllocations()>
<cfset orgID = "University Budget Office">  <!--- TODO: dynamic Orgs owning separate projects --->

<cfoutput>
<div class="full_content">
	<h2>#orgID# Allocations</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
<!-- Begin allocations Table -->
		<table id="allocationsTable" class="feeCodeTable">
			<thead>
				<tr>
					<th class="tooltip2">Project Name 
					  <span class="tooltiptext">The unique project name assigned to each project</span></th>
					<th class="tooltip2">Team Member 
					  <span class="tooltiptext">The name of each team member who is on a specific project</span></th>
					<th class="tooltip2">Team Role 
					  <span class="tooltiptext">The unique role each team member has relative to each project entered (e.g., PM, Lead, Technical, etc.)</span></th>
					<th class="tooltip2">Allocation <span class="tooltiptext">The descriptor of a specific task/process/activity of a project</span></th>
					<th class="tooltip2">Hours <span class="tooltiptext">The amount of hours each Allocation element will consume</span></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allAllocations">
					<tr>
						<td>#proj_name#</td>
						<td><input type="hidden" value="#staff_id#">#staff_first_last_name#</td>
						<td>#team_role#</td>
						<td>#alloc_desc#</td>
						<td>#alloc_hours#</td>
				</cfloop>
			</tbody>
		</table>
<!-- End teams Table -->
</cfoutput>

<cfinclude template="../includes/header_footer/pm_footer.cfm" />
