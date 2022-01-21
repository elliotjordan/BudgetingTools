<cfinclude template="../includes/header_footer/fym_header.cfm" >

<cfif StructKeyExists(form,"scenarios")>
	<cfset updateFYMscenarioFocus(form.scenarios,currentUser.username) />
</cfif>

<cflocation url="scenarios.cfm" addtoken="false" />