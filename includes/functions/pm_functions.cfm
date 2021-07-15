<cffunction name="getAllProjects" output="true" returntype="Query">
	<cfargument name="givenProjectID" type="numeric" required="false" default="-1">
	<cfquery name="getAllProj" datasource="#application.datasource#">
		SELECT p.proj_id, p.proj_owner, p.proj_area, p.proj_name, p.proj_desc, p.proj_yr, p.proj_qtr, p.proj_status, p.created_on
	    FROM fee_user.pm_projects p
	    <cfif givenProjectID gt 0>WHERE proj_id = #givenProjectID#</cfif>
		ORDER BY p.proj_name ASC
	</cfquery>
	<cfreturn getAllProj>
</cffunction>

<cffunction name="getProjects" output="true">  
	<cfquery name="getProj" datasource="#application.datasource#">
		SELECT p.proj_id, p.proj_owner, s.staff_username, s.staff_first_last_name, p.proj_area, p.proj_name, p.proj_desc, p.proj_yr, p.proj_qtr, p.proj_status, p.created_on
	    FROM fee_user.pm_projects p, fee_user.pm_staff s
	    WHERE p.proj_owner = s.staff_id
		ORDER BY p.proj_name ASC
	</cfquery>
	<cfif getProj.RecordCount gt 0>
		<cfreturn getProj>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getProjectOwnerData" output="true">
	<cfargument name="givenPMID" default="0001759407">   <!--- TODO: Remove TMichael as hard-coded default PM --->
	<cfquery name="getPM" datasource="#application.datasource#">
		SELECT DISTINCT t.staff_id, s.staff_first_last_name
		FROM pm_teams t, pm_staff s
		WHERE s.staff_id = t.staff_id
		  AND s.staff_id = '<cfqueryparam cfsqltype="cf_sql_char" value="#givenPMID#">  
	</cfquery>
	<cfreturn getPM>
</cffunction>

<cffunction name="createNewProject">
	<cfargument name="projOwner" type="string" required="true">
	<cfargument name="projOrg" type="string" required="true">
	<cfargument name="projArea" type="string" required="true">
	<cfargument name="projName" type="string" required="true">
	<cfargument name="projPhase" type="string" required="true">
	<cfquery name="insertNewProject" datasource="#application.datasource#">
		INSERT INTO pm_projects
		(proj_owner, proj_org_cd, proj_area, proj_name, proj_desc, proj_yr, proj_qtr, proj_status, created_on)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projOwner,'[^0-9A-Za-z ]','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projOrg,'[^0-9A-Za-z ]','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projArea,'[^0-9A-Za-z ]','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projName,'[^0-9A-Za-z ]','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projDesc,'[^0-9A-Za-z ]','','all')#">,
			'2019',
			'1',
			'Current',
			Now()
		)
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="updateProject">
	<cfargument name="projID" type="numeric" required="true">
	<cfargument name="projArea" type="string" required="true">
	<cfargument name="projName" type="string" required="true">
	<cfargument name="projOwner" type="string" required="true">
	<cfargument name="projDesc" type="string" required="true">
	<cfargument name="projStatus" type="string" required="true">
	<cfquery name="projectUpdate" datasource="#application.datasource#">
		UPDATE fee_user.pm_projects
		SET  
	 		proj_area=<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projArea,'[^0-9A-Za-z ]','','all')#">,
	 		proj_name=<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projName,'[^0-9A-Za-z ]','','all')#">,
			proj_owner=<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projOwner,'[^0-9A-Za-z ]','','all')#">, 
	  		proj_desc=<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projDesc,'[^0-9A-Za-z ]','','all')#">,
	  		proj_status=<cfqueryparam cfsqltype="cf_sql_char" value="#ReReplace(projStatus,'[^0-9A-Za-z ]','','all')#">
		WHERE proj_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="projID"> 
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="addTeamMember">
	<cfargument name="projID" type="numeric" required="true">
	<cfargument name="staffID" type="string" required="true">
	<cfargument name="memberRole" type="string" required="true">
	<cfquery name="insertNewTeam" datasource="#application.datasource#">
		INSERT INTO pm_teams
		(proj_ID, staff_id, team_role, created_on)
		VALUES
		(
			<cfqueryparam cfsqltype="numeric" value="#projID#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#staffID#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#memberRole#">,
			Now()
		)
	</cfquery>
</cffunction>

<cffunction name="createNewTeam">
	<cfargument name="teamStruct" type="struct" required="true">
	<cfargument name="givenProjectID" type="any" required="false" default="newProjectRequest">
	<cfif givenProjectID eq 'newProjectRequest'>
		<cfset projectID = fetchUnusedProjectID()>
	<cfelse>
		<cfset projectID = NumberFormat(givenProjectID)>
	</cfif>
	<cftry>
		<cfloop collection="#teamStruct#" item="key">
			<cfset addTeamMember(projectID,key,teamStruct[key])>
		</cfloop>
		<cfcatch type="any"><cfoutput><p><strong>#cfcatch.Detail#</strong></p></cfoutput></cfcatch>
	</cftry>
</cffunction>

<cffunction name="fetchUnusedProjectID">
	<cfquery name="unusedProjectID" datasource="#application.datasource#">
		SELECT MAX(proj_id) as maxNum FROM pm_projects
	</cfquery> 
	<cfset newID = unusedProjectID.maxNum + 1>
	<cfreturn newID>
</cffunction>

<cffunction name="getStaff" >
	<cfargument name="orgCode" required="false" default="default">
	<cfquery name="getStaffers" datasource="#application.datasource#">
		SELECT DISTINCT s.staff_id, s.staff_username, s.staff_first_last_name 
		FROM pm_staff s, pm_projects p
		<cfif orgCode neq "default">
			WHERE p.proj_org_cd = <cfqueryparam cfsqltype="cf_sql_char" value="#orgCode#">
		</cfif>
		ORDER BY s.staff_first_last_name ASC
	</cfquery>
	<cfreturn getStaffers />
</cffunction>

<cffunction name="getTeamMember">
	<cfargument name="staffID" type="any" required="true">
	<cfquery name="getDude" datasource="#application.datasource#">
		SELECT staff_id, staff_username, staff_first_last_name 
		FROM pm_staff
		WHERE staff_id = <cfqueryparam cfsqltype="any" value="#staffID#">
	</cfquery>
	<cfreturn getDude>
</cffunction>

<cffunction name="getProjectOwner">
	<cfargument name="projectID" type="string" required="true">
	<cfquery name="getOwner" datasource="#application.datasource#">
		SELECT proj_owner FROM pm_projects
		WHERE proj_id = <cfqueryparam cfsqltype="string" value="#projectID#">
	</cfquery>
	<cfset projOwner = getTeamMember(getOwner.proj_owner)>
	<cfreturn projOwner>
</cffunction>

<cffunction name="getOwners" output="true">  
	<cfquery name="getOwn" datasource="#application.datasource#">
		SELECT DISTINCT p.proj_owner, s.staff_first_last_name
	    FROM fee_user.pm_projects p, fee_user.pm_staff s
	    WHERE proj_owner = s.staff_id
		ORDER BY s.staff_first_last_name ASC
	</cfquery>
	<cfif getOwn.RecordCount gt 0>
		<cfreturn getOwn>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getTeams" output="true">
	<cfargument name="givenActive" type="string" required="false" default="Y">
	<cfquery name="getTeam" datasource="#application.datasource#">
		SELECT t.proj_id, p.proj_name, t.staff_id, s.staff_first_last_name, t.team_role, t.created_on
		FROM pm_teams t
		INNER JOIN pm_projects p ON t.proj_id = p.proj_id
		INNER JOIN pm_staff s ON t.staff_id = s.staff_id
		WHERE t.active = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenActive#">
	</cfquery>
	<cfif getTeam.RecordCount gt 0>
		<cfreturn getTeam>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getRoles" output="true">  
	<cfquery name="getRole" datasource="#application.datasource#">
		SELECT id, role_code, description
		FROM roles
		WHERE role_code IN ('11','12','13','14','15')
		ORDER BY role_code ASC
	</cfquery>
	<cfif getRole.RecordCount gt 0>
		<cfreturn getRole>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getAllocations" output="true">  
	<cfquery name="getAlloc" datasource="#application.datasource#">
		SELECT t.team_role, s.staff_id, s.staff_first_last_name, p.proj_name, t.team_role, a.alloc_desc, a.alloc_hours
		FROM pm_staff s, pm_projects p, pm_teams t, pm_allocations a
		WHERE p.proj_id = t.proj_id
		  AND p.proj_id = a.proj_id
		  AND s.staff_id = t.staff_id
		  AND s.staff_id = a.staff_id
		ORDER BY t.team_role ASC
	</cfquery>
	<cfif getAlloc.RecordCount gt 0>
		<cfreturn getAlloc>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getReports" output="true">  
	<cfquery name="getRepts" datasource="#application.datasource#">
		SELECT r.rpt_id, r.rpt_name, r.rpt_desc, r.rpt_date, r.rpt_link, r.rpt_owner, s.staff_first_last_name
		FROM pm_staff s, pm_reports r
		WHERE s.staff_id = r.rpt_owner
	</cfquery>
	<cfif getRepts.RecordCount gt 0>
		<cfreturn getRepts>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getTargets">
	<cfargument name="givenID" type="numeric" required="false" default="0">
	<cfquery name="getTargs" datasource="#application.datasource#">
		SELECT t.proj_id, p.proj_name, p.proj_owner, t.targ_desc, t.targ_date, t.targ_status, t.targ_notes, t.created_on
		FROM pm_targets t
		INNER JOIN pm_projects p ON t.proj_id = p.proj_id
		<cfif givenID neq 0>
			WHERE t.proj_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenID#">
		</cfif>
		ORDER BY t.targ_date DESC
	</cfquery>
	<cfreturn getTargs>
</cffunction>

<cffunction name="getPermissions">
	<cfargument name="givenID" required="false" default="NONE">
	<cfquery name="getPerms" datasource="#application.datasource#">
		SELECT u.username, u.first_last_name, p.proj_name, al.access_level, al.last_updated_on    
		FROM fee_user.users_new u
		INNER JOIN fee_user.pm_projects p ON u.id = p.proj_owner
		LEFT OUTER JOIN fee_user.pm_access_level al ON u.id = al.user_id AND p.proj_id = al.proj_id
		<cfif givenID neq 'NONE'>
			WHERE u.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenID#"> and al.access_level IS NOT NULL
		</cfif>
	</cfquery>
	<cfreturn getPerms />
</cffunction>

