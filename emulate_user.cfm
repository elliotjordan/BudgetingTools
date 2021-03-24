<cfinclude template="includes/functions/user_functions.cfm" />

<cfoutput>
<cfif StructKeyExists(form,"usernameinput") AND LEN(form.usernameinput) lte 8>
	<cfset StructClear(Session)>
	<cfset testUser = emulateUser(form.usernameinput)>
	<cfset actionEntry = trackUserAction(REQUEST.authUser,'EU',5,#cgi.HTTP_REFERER#) />
	<cflocation url="#cgi.HTTP_REFERER#" addtoken="false" />
	
<cfelseif StructKeyExists(url,"target") AND StructKeyExists(url,"url")>
	<cfset StructClear(Session)>
	<cfset testUser = setFocus(url.target)> 
	<cfset actionEntry = trackUserAction(REQUEST.authUser,'BS',5,#cgi.HTTP_REFERER#) />
	<!---<cflocation url="#url.url#" addtoken="false" />--->
	<cflocation url="index.cfm" addtoken="false" />
<cfelse>
	<!---<cfdump var="#form#">--->
	You are #REQUEST.authUser#. <br />
	That was not a valid username. Please try again.
</cfif>
</cfoutput>
