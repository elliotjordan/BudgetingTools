<!--- Do new form submission stuff here then send them back to the main page  --->
<cfinclude template="../includes/functions/pm_functions.cfm">
<cfif LEN(FORM.proj_owner) gte 10>
	<cfset projOwner = FORM.proj_owner>
<cfelse>
	<cfset projOwner = getProjectOwnerData().staff_id>
</cfif>

<cfif LEN(FORM.proj_org) eq 4>
	<cfset projOrg = FORM.proj_org>
<cfelse>
	<cfset projOrg = "BUDU">
</cfif>

<cfif LEN(FORM.proj_name) gt 0>
	<cfset projName = FORM.proj_name>
<cfelse>
	<cfset projName = "NAME ME">
</cfif>

<cfif LEN(FORM.proj_area) gt 0>
	<cfset projArea = FORM.proj_area>
<cfelse>
	<cfset projArea = "PICK A PROJ AREA">
</cfif>

<cfif LEN(FORM.proj_desc) gt 0>
	<cfset projDesc = FORM.proj_desc>
<cfelse>
	<cfset projDesc = "PICK A PROJ DESCRIPTION">
</cfif>

<cfset createNewProject(projOwner,projOrg,projArea,projName,projDesc) />

<cflocation url="index.cfm" addtoken="false">