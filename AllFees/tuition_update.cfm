<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>
<cfinclude template="../includes/functions/tuition_functions.cfm" >
<cfinclude template="../includes/header_footer/allfees_header.cfm"> 

<cfset debugTuition = updateTuitionChanges(form)>

<!---<cfdump var="#debugTuition#" ><cfabort>--->

<!--- USE THIS DURING DEVELOPMENT --->
<!---<cfoutput>
	<h2>Sorry</h2>
		<p>The UBO gang are working on this page right now, so your "Save" did not actually go into the database.</p>
		<p>When we finish this part, this message will disappear, and you will see your changes saved on the main page.  Sorry for any inconvenience.</p>
	<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
</cfoutput>
<cfabort>--->

<!---  USE THIS WHEN DEVELOPMENT COMPLETE  --->
<cfset returnString = "tuition.cfm" />
<cflocation url= #returnString# addToken="false" />
