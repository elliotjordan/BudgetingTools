<!--- this page is a "partial" to be included on projects.cfm  --->
<!-- Begin projectsTable -->
<cfoutput>
		<table id="projectsTable" class="feeCodeTable">
			<thead>
				<tr>
					<th>Owner</th>
					<th>Area</th>
					<th>Project Name</th>
					<th>Project Description</th>
					<th>Status</th>
					<th>Created On</th>
				</tr>
			</thead>
			<tbody>  
				<cfif allProjects.recordCount gt 0>
					<cfloop query="allProjects">
						<tr>
							<td>
								<select id="proj_owner2" name="proj_owner2" class="request">
									<cfloop query="#allStaffers#">
										<cfif COMPARENOCASE( allProjects.staff_username, allStaffers.staff_username ) eq 0><cfset s="YES"><cfelse><cfset s="NO"></cfif>
										<option value="#allProjects.proj_owner#" <cfif s eq "YES">selected</cfif> >#staff_first_last_name#</option>
									</cfloop>
								</select>								
							</td>
							<td>#proj_area#</td>
							<td>#proj_name#<br>
								<span class="sm-blue"><a href="project_edit.cfm?pid=#proj_id#">edit</a></span>
							</td>
							<td>#proj_desc#</td>
							<td>#proj_status#</td>
							<td>#DateTimeFormat(created_on,"mmm-dd-yyyy")#</td>
						</tr>
					</cfloop>
				<cfelse>
					<p>No projects were found.</p>
				</cfif>
					
			</tbody>
		</table>
</cfoutput>
<!-- End projects Table -->