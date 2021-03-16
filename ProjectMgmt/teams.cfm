<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />
<cfset allTeams = getTeams()>
<cfset allStaffers = getStaff()>
<cfset allRoles = getRoles()>
<cfset proj_list = getAllProjects()>
<cfset orgID = "University Budget Office">  <!--- TODO: dynamic Orgs owning separate projects --->

<cfoutput>
<div class="full_content">
	<h2>#orgID# Teams</h2>
	<p class="sm-blue">Today is #DateFormat(Now(),"mmm-dd-yyyy")#</p>
    <button id='showTeamFormBtn' class='pm_submitBtn' onclick='toggleNewForm("newTeamReqForm")'>Create New Team</button>
	
	<!-- Begin new project request form -->
	<span id="newTeamReqForm" class="fieldset pm_form">
		<h3>Create a Brand New Team</h3>
		<form action = "team_request.cfm" id="teamForm" format="html" method="POST" preloader="no" preserveData="yes" timeout="1200" width="800" wMode="opaque">
			<span id="addMember" class="alignedDropdowns fielditem">
				<select id="team_member" name="team_member" class="request">
					<option value="false">-- Please select a Team Member --</option>
					<cfloop query="allStaffers">
						<option value="#staff_id#">#staff_first_last_name#</option>
					</cfloop>
				</select>
				
				<select id="team_role" name="team_role" class="request" style="display:inline-block !important">
					<option value="false">-- Please select a Role for them --</option>
					<cfloop query="allRoles">
						<option value="#role_code#">#description#</option>
					</cfloop>
				</select>
				<img id="plusSign" src="../images/plus_icon.png" alt="Plus sign to add row" class="add" onclick="addRow('addMember')">
				<img id="minusSign" src="../images/minus_icon.png" alt="Minus sign to remove row" class="add" onclick="removeBottomRow('addMember')">
			</span>

			<span class="fielditem">
		 		<label for="proj_list">Project</label><br>
		 		<select id="proj_list" name="proj_list">
		 			<option value="newProjectRequest">-- Create a brand new project --</option>
			 			<cfloop query="proj_list">
			 				<option value="#proj_id#">#proj_desc# - #getProjectOwner(proj_id).staff_first_last_name#</option>
			 			</cfloop>
		 			</option>
		 		</select>
			</span>
				
			<span class="fielditem">
				<input id="SubmitBtn1" type="submit" name="SubmitBtn1" value="Submit New Project" />	<br>	
			</span>
		</form>
	</span>  <!-- End fieldset for new project request form -->	
	
<cfinclude template="team_list.cfm" runonce="true">	

</cfoutput>

<cfinclude template="../includes/header_footer/pm_footer.cfm" />
