<!--- Do new form submission stuff here then send them back to the main page  --->
<cfinclude template="../includes/functions/pm_functions.cfm">
<!---
<cfdump var="#form#" >

<cfscript>
	teamStruct = StructNew();
	for (i=1; i <= ListLen(form.team_member); i++) {
		teamStruct[ListGetAt(form.team_member,i)]=ListGetAt(form.team_role,i);
	}
	if (IsStruct(teamStruct)) {
		WriteOutput("Tested as a valid struct!");
		createNewTeam(teamStruct,form.proj_list);
	}
</cfscript>
	
<cfset getNewTeam = getTeams()>
<cfoutput>
	<p>Team Struct: <cfdump var="#teamStruct#" ></p>
	<p>Unusued ProjectID: #fetchUnusedProjectID()#</p>
	<cfdump var="#getNewTeam#">
</cfoutput>

<cfabort>
--->
<cflocation url="index.cfm" addtoken="false">