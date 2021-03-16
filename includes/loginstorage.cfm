<!--- 
	file:	loginstorage.cfm
	author:	John Burgoon jburgoon - lifted straight from the Adobe docs and tweaked
	ver.:	v0.1
	date:	1-4-15
	update:	
	note:	loginstorage function to be included with Application.cfc
 --->
<cffunction name="loginstorage">
    <cfargument name = "request" required="true"/> 
    <cfif IsDefined("Form.logout")> 
        <cflogout> 
    </cfif> 
 
    <cflogin> 
        <cfif NOT IsDefined("cflogin")> 
            <cfinclude template="sandbox.cfm"> 
            <cfabort> 
        <cfelse> 
            <cfif cflogin.name IS "" OR cflogin.password IS ""> 
                <cfoutput> 
                    <h2>You must enter text in both the User Name and Password fields. 
                    </h2> 
                </cfoutput> 
                <cfinclude template="loginform.cfm"> 
                <cfabort> 
            <cfelse> 
                <cfquery name="loginQuery" dataSource="cfdocexamples"> 
                SELECT UserID, Roles 
                FROM LoginInfo 
                WHERE 
                    UserID = '#cflogin.name#' 
                    AND Password = '#cflogin.password#' 
                </cfquery> 
                <cfif loginQuery.Roles NEQ ""> 
                    <cfloginuser name="#cflogin.name#" Password = "#cflogin.password#" 
                        roles="#loginQuery.Roles#"> 
                <cfelse> 
                    <cfoutput> 
                        <H2>Your login information is not valid.<br> 
                        Please Try again</H2> 
                    </cfoutput>     
                    <cfinclude template="loginform.cfm"> 
                    <cfabort> 
                </cfif> 
            </cfif>     
        </cfif> 
    </cflogin> 
 
    <cfif GetAuthUser() NEQ ""> 
        <cfoutput> 
                <form action="securitytest.cfm" method="Post"> 
                <input type="submit" Name="Logout" value="Logout"> 
            </form> 
        </cfoutput> 
    </cfif> 
</cffunction> 
