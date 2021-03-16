<!--- pull the user data from the system and set the salient details in session  --->
<cfinclude template="../includes/functions/user_functions.cfm" />
<cfset userData = getFeeUser(#request.authuser#) />  
<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="5">
	<cfset session.inst = 'IU'&#userData.chart#&'A' />
	<cfset session.curr_proj_chart = #userData.chart# & " Campus" />
	<cfset session.curr_proj_RC = #userData.projector_rc# />
	<cfset session.access_level = #userData.access_level# />
	<cfset session.user_id = #userData.username# />
	<cfset session.first_last_name = #userData.first_last_name# />
	<cfset session.activeLevel = "Y" />  <!--- so that this variable is available in case we want to see inactive fees  --->
	<cfset session.allfees_rcs = #userData.allfees_rcs#>
	<cfset session.role = #getUserRole(userData.access_level)#>
</CFLOCK>
