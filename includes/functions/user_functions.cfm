  <cffunction name="getFeeUser" output="true">
  	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT oid, id, empl_id, username, first_last_name, email, phone, created_on, description, access_level, 
  		  chart, active, projector_rc, allfees_rcs, proj_updt, fym_inst, role_code
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
  </cffunction>

  <cffunction name="getFYMUser" output="true">
  	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,ALLFEES_RCS, PHONE,ACTIVE,CREATED_ON, fym_inst,focus
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
  </cffunction>

  <cffunction name="handleUser">  <!--- username,first_last_name,email,phone,description,chart,access_level,projector_rc,active,new  --->
  	<cfargument name="givenUser" required="true">
  	<cfargument name="givenFLName" required="true">
  	<cfargument name="givenEmail" required="true">
  	<cfargument name="givenPhone" required="true">
  	<cfargument name="givenDesc" required="true">
  	<cfargument name="givenChart" required="true">
  	<cfargument name="givenAccess" required="true">
  	<cfargument name="givenDefaultRC" required="true">
	<cfargument name="givenActive" required="true">
	<cfargument name="givenNew" required="true">
	<cfargument name="givenAllFeesRCs" required="true">
	<cfquery name="updatedUser"  datasource="#application.datasource#">
		<cfif lcase(trim(givenNew)) eq 'update'>
			UPDATE fee_user.users
			SET first_last_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFLName#">,
			  email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenEmail#">,
			  phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenPhone#">,
			  description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenDesc#">,
			  access_level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAccess#">,
			  chart = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			  active = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenActive#">
			  projector_rc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenDefaultRC#">,
			  allfees_rcs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAllFeesRCs#">
			WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenUser#">
		<cfelseif lcase(trim(givenNew)) eq 'new'>   <!--- NOTE: ID is auto-created within the database  --->
			INSERT INTO fee_user.users(
	           username, first_last_name, email, phone, created_on, description, access_level, chart, active, projector_rc, allfees_rcs)
	        VALUES (
	           <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenUser#">,
	           <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFLName#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenEmail#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenPhone#">,
			   Now(),
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenDesc#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAccess#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenActive#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenDefaultRC#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAllFeesRCs#">
	        )
		</cfif>
	</cfquery>
  	<cfreturn true>
  </cffunction>

  <cffunction name="getUserRole" output="true">
  	<cfargument name="access_level" required="true" type="string">
	<cfswitch expression="#access_level#">
		<cfcase value="bluser,eauser,kouser,inuser,nwuser,sbuser,seuser"><cfset userRole = "campus"></cfcase>
		<cfcase value="reguser"><cfset userRole = "regional"></cfcase>
		<cfcase value="bursuser"><cfset userRole = "bursar"></cfcase>
		<cfcase value="cfouser"><cfset userRole = "cfo"></cfcase>
		<cfcase value="bduser"><cfset userRole = "ubo"></cfcase>
		<cfcase value="GUEST"><cfset userRole = "GUEST"></cfcase>
		<cfdefaultcase><cfset userRole = "campus"></cfdefaultcase>
	</cfswitch>
  	<cfreturn userRole>
  </cffunction>
<!---
<cfset role = '#session.role#'>
	<cfif REQUEST.authUser neq imposter AND FindNoCase("campus_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'campus'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("regional_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'regional'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("bursar_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'bursar'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("fee_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'ubo'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("cfo_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'cfo'>
	</cfif>
--->
 <cffunction name="emulateUser" output="true">
   <cfargument name="givenUsername" required="false" default="#REQUEST.authUser#">
   <cfswitch expression="#givenUsername#">
   	<cfcase value="BL"><cfset givenUsername = "aheeter"></cfcase>
   	<cfcase value="BA-ATHL"><cfset givenUsername = "mssimpso"></cfcase>
   	<cfcase value="IH"><cfset givenUsername = "garobe"></cfcase>
   	<cfcase value="MED"><cfset givenUsername = "garobe"></cfcase>
   	<cfcase value="EA"><cfset givenUsername = "lejulian"></cfcase>
   	<cfcase value="IN"><cfset givenUsername = "kcwalsh"></cfcase>
   	<cfcase value="KO"><cfset givenUsername = "jahayman"></cfcase>
   	<cfcase value="NW"><cfset givenUsername = "tschance"></cfcase>
   	<cfcase value="SB"><cfset givenUsername = "ltschler"></cfcase>
   	<cfcase value="SE"><cfset givenUsername = "dwavle"></cfcase>
   	<cfcase value="UA"><cfset givenUsername = "ubo"></cfcase>
   	<cfdefaultcase><cfset givenUsername = "#givenUsername#"></cfdefaultcase>
   </cfswitch>
   <cfquery datasource="#application.datasource#" name="emulatee">
   	 SELECT id, username, access_level, chart, projector_rc, allfees_rcs, fym_inst
   	 FROM #application.usersTable#
   	 WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenUsername#">
   </cfquery>
   <cfif emulatee.RecordCount eq 1>
	   <cfquery datasource="#application.datasource#" name="emulator">
	   	 UPDATE #application.usersTable# SET access_level = '#emulatee.access_level#', chart = '#emulatee.chart#',
	   	   projector_rc = '#emulatee.projector_rc#', allfees_rcs = '#emulatee.allfees_rcs#', fym_inst = '#emulatee.fym_inst#'
	   	 WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REQUEST.authUser#">
	   </cfquery>
   </cfif>
   <cfreturn givenUsername>
 </cffunction> 

<cffunction name="getFocus">
	<cfargument name="givenUser" type="string" required="true">
	<cfquery name="focusValue" datasource="#application.datasource#">
		Select username, focus from users where username =
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenUser#">
		and active = 'Y'
	</cfquery>
	<cfreturn focusValue>
</cffunction>

<cffunction name="setFocus">
	<cfargument name="givenChart" type="string" required="true">
	<cfquery datasource="#application.datasource#" name="emulator">
	   	 UPDATE fee_user.users SET focus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
	   	 WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REQUEST.authUser#">
	</cfquery>
	<cfreturn true />	
</cffunction>

<cffunction name="trackUserAction" output="false">
	<cfargument name="loginId" required="true" default="#REQUEST.AuthUser#" />
	<cfargument name="campusId" required="false" default="--" />
	<cfargument name="actionId" required="true" />
	<cfargument name="description" required="false" default="" />
	<cfquery datasource="#application.datasource#" name="makeMeta">
		INSERT INTO FEE_USER.METADATA
		(USER_ID,CAMPUS_ID,ACTION_ID,DESCRIPTION)
		VALUES
		('#loginId#','#campusId#','#actionId#','#description#')
	</cfquery>
</cffunction>
