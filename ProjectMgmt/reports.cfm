<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allReports = getReports()>
<cfset orgID = "University Budget Office">  <!--- TODO: dynamic Orgs owning separate projects --->

<cfoutput>
<div class="full_content">
	<h2>#orgID# Reports</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
<!-- Begin reportsTable -->
		<table id="reportsTable" class="feeCodeTable">
			<thead>
				<tr>
					<th class="tooltip2">Report Name 
					  <span class="tooltiptext">The specific name of a pre-defined report</span></th>
					<th class="tooltip2">Report Description 
					  <span class="tooltiptext">The descriptor of the format (e.g., Excel, pivot, Word, etc.) a report is displayed</span></th>
					<th class="tooltip2">Report Link 
					  <span class="tooltiptext">The URL link to launch to a selected report</span></th>
					<th class="tooltip2">Report Owner 
					  <span class="tooltiptext">The name of the person who owns and manages the project</span></th>
					<th class="tooltip2">Report Date 
					  <span class="tooltiptext">The date a specific report is created by the user</span></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allReports">
					<tr>
						<td>#rpt_name#</td>
						<td>#rpt_desc#</td>
						<td>#rpt_link#</td>
						<td><input type="hidden" value="#rpt_owner#">#staff_first_last_name#</td>
						<td>#rpt_date#</td>
				</cfloop>
			</tbody>
		</table>
<!-- End reports Table -->
</cfoutput>

<cfinclude template="../includes/header_footer/pm_footer.cfm" />

