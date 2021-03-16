<!--- 
	file:	logout.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	1-4-16
	update:	
	note:	Local logout page. 
	NOTE: Clears the session for the user.  Since we use CAS authentication to determine login status, there is not really any "logout" occuring unless the user performs a CAS logout.  Messes up Duo login status, though, which is useful.
 --->
<!---<cfif IsDefined("session") AND StructKeyExists(session, "isCasValidated")>
--->	
	<!---<cfset session.isCasValidated = "no" />--->
	<cfset sessionInvalidate() />
	<cflogout />		<!--- This will set IsUserLoggedIn() = "no" --->
	<cfinclude template="includes/header_footer/header.cfm" />
	<cfinclude template="includes/header_footer/sidelink.cfm" />
				<h2>Thank you for using our Budgeting Tools.</h2>
                <p>You are logged out.</p>
	<cfinclude template="includes/header_footer/footer.cfm" />
<!---</cfif>--->