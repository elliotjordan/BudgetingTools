<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allPermissions = getPermissions('143')>
<cfset orgID = "University Budget Office">  <!--- TODO: dynamic Orgs owning separate projects --->

<cfoutput>
<div class="full_content">
	<h2>#orgID# Project Permissions</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
<!-- Begin permissions Table --> 
		<table id="permissionsTable" class="feeCodeTable">
			<thead>
				<tr>
					<th>Username 
					<th>Team Member 
					<th>Project 
					<th>Access</th>
					<th>Notes</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allPermissions">
					<tr>
						<td>#username#</td>
						<td>#first_last_name#</td>
						<td>#proj_name#</td>
						<td>#access_level#</td>
						<td>Last updated on #last_updated_on#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
<!-- End teams Table -->
</cfoutput>

<cfinclude template="../includes/header_footer/pm_footer.cfm" />
