<cfinclude template="../includes/header_footer/pm_header.cfm" />
<cfinclude template="../includes/functions/pm_functions.cfm" />

<cfif isDefined("form") AND StructKeyExists(form,"projUpdate") AND form.projUpdate eq 'Update Project'>
	<cfset updateProject(form.projID,form.projArea,form.projName,form.projOwner,form.projDesc, form.projStatus) />
	<cflocation url="projects.cfm?message=Successfull update" addtoken="false" />
</cfif>

<cfif IsDefined("url") AND StructKeyExists(url, "pid")>
	<cfset currentProject = getAllProjects(url.pid) />
	<cfset milestone = getTargets(url.pid) />
</cfif>

<cfoutput>
<div class="full_content">
	<cfif currentProject.recordCount gt 0>
	<h2>Project #currentProject.proj_id# - #currentProject.proj_name#</h2>
	<p class="sm-blue">
		Project Year #currentProject.proj_yr#, Quarter #currentProject.proj_qtr#<br>
		Today is #DateFormat(Now(),"mmm-dd-yyyy")# <br>
		<cfif milestone.recordCount gt 0>
			The next target date for this project is #milestone.targ_date#
		<cfelse>
			This project has no target dates set.
		</cfif>
	</p>
	
	<form action="project_edit.cfm" method="post" name="projEditForm">
		<label for="projArea">Area</label><br>
		<input name="projArea" type="text" value="#currentProject.proj_area#" size="128" /> <br>
		<br>
		<label for="projName">Project Name</label><br>
		<input name="projName" type="text" value="#currentProject.proj_name#" size="32" /> <br>
		<br>
		<label for="projOwner">Owner</label><br>
		<input name="projOwner" type="text" value="#getTeamMember(currentProject.proj_owner).staff_first_last_name#" size="128" /> <br>
		<br>
		<label for="projDesc">Description</label><br>
		<input name="projDesc" type="text" value="#currentProject.proj_desc#" size="128" /> <br>
		<br>
		<label for="projStatus">Status</label><br>
		<input name="projStatus" type="text" value="#currentProject.proj_status#" size="16" /> <br>
		<br>
		<input name="projID" type="hidden" value="#LSParseNumber(currentProject.proj_id)#">
		<input type="submit" name="projUpdate" value="Update Project" />
	</form>
	<cfelse>
		You have selected a project which does not exist.
	</cfif>
</div>   <!-- End div full_cotennt  -->
</cfoutput>

<cfinclude template="../includes/header_footer/pm_footer.cfm" />