<!--- 
	file:	logout_CAS.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	1-4-16
	update:	
	note:	CAS logout page.  
 --->
<!---<cfset session.isCasValidated = "no" /> --->
<!---<cflogout />--->
<!---<cfif IsDefined("session") AND StructKeyExists(session, "isCasValidated")>
--->	
	<!---<cfset session.isCasValidated = "no" />--->
	<cfset sessionInvalidate() />
	<cflogout />		<!--- This will set IsUserLoggedIn() = "no" --->
<!---</cfif>--->
<cflocation url="https://cas.iu.edu/cas/logout" addToken="false" />