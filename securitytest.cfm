<cfinclude template="includes/header_footer/header.cfm" /> 
<cfinclude template="includes/header_footer/sidelink.cfm" />

<cfoutput>
   <h2>Welcome #GetAuthUser()#</h2>  
</cfoutput>

ALL Logged-in Users see this message.<br>
<br>
<p>Users in the ADMIN role see the word ADMIN here: <cfif IsUserInRole("admin")><h3>ADMIN</h3></cfif></p>
<p>Everyone in the USER role sees the word USER here: <cfif IsUserInRole("user")><h3>USER</h3></cfif></p>
<cfinclude template="includes/header_footer/footer.cfm" />