<!---<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>--->
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allProjects = getProjects()>
<cfset allStaffers = getStaff()>
<cfset orgID = "University Budget Office">  <!--- TODO: dynamic Orgs owning separate projects --->
<cfoutput>
<div class="full_content">
	<h2>#orgID# Projects</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
    <button id='showProjFormBtn' class="pm_submitBtn" onclick='toggleNewForm("newProjReqForm")'>Create New Project</button>

	<!-- Begin new project request form -->
	<span id="newProjReqForm" class="fieldset pm_form">
		<h3>Create a Brand New Project</h3>
		<form action = "project_request.cfm" id = "projectForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque">
			<span class="fielditem">
	 			<label for="proj_owner">Project Owner</label> <br>
				<select id="proj_owner" name="proj_owner" class="request">
					<option value="false">-- Please select a project owner --</option>
					<cfloop query="allStaffers">
						<option value="#staff_id#" <cfif #staff_username# eq #REQUEST.authUser#>selected</cfif> >#staff_first_last_name#</option>
					</cfloop>
				</select>
			</span>

			<span class="fielditem">
		 		<label for="proj_org">Project Org Code</label>	<br>
		 		<input type="text" id="proj_org" name="proj_org" placeholder="Select your org code using exactly four letters" width="30" size="24"><br>
			</span>
			
			<span class="fielditem">
		 		<label for="proj_area">Project Area</label><br>
		 		<select id="proj_area" name="proj_area">
		 			<option value="BudgetOps">Budget Operations</option>
		 			<option value="PlanAlysis">Planning & Analysis</option>
		 			<option value="ProjMgmt">Project Management</option>
		 			<option value="Technical">Technical</option>
		 		</select>	
			</span>

			<span class="fielditem">
		 		<label for="proj_name">Project Name</label>	<br>
		 		<input type="text" id="proj_name" name="proj_name" placeholder="Select a unique name that makes sense in a report" width="30" size="128"><br>
			</span>

			<span class="fielditem">
		 		<label for="proj_desc">Project Description</label>	<br>
		 		<input type="text" id="proj_desc" name="proj_desc" placeholder="Pick a description that makes sense in a report" width="30" size="128"><br>
			</span>
				
			<span class="fielditem">
				<input id="SubmitBtn1" type="submit" name="SubmitBtn1" value="Submit New Project" />	<br>	
			</span>
		</form>
</span>  <!-- End fieldset for new project request form -->	
		<hr width="100%" />
		<cfinclude template="project_list.cfm">
</div>
</cfoutput>