<cfinclude template="../includes/header_footer/header.cfm"><cfdump var="#form#" ><cfabort>
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfinclude template="../includes/functions/user_functions.cfm">
<cfoutput>	
<cfif IsDefined("form") and StructKeyExists(form,'newUserBtn')>
	<!--- username,first_last_name,email,phone,description,chart,access_level,projector_rc,active  --->
  <cfscript>
	foundUser = getUsersByCampus(form.new_username,form.new_username);
	if (foundUser.recordCount gt 0) {
		handleUser(form.new_username,form.new_fullname,form.new_email,form.new_phone,form.new_description,form.new_campus,form.new_accesslevel,form.new_loginrc,"Y");    
	}
  </cfscript>
  <cfoutput>
  	<h2><cfdump var="#foundUser#"> was processed.</h2>
  </cfoutput>
<cfelseif IsDefined("form") and StructKeyExists(form,'userUpdateBtn')>
    <cfset current_inst = "IU"&getFeeUser(REQUEST.authUser).chart&"A" />
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			Form[i] #Form[i]# <br />
			<cfset rootID = REPLACE(i,"DELTA","") />  
			<!---<cfif RIGHT(rootId,1) eq 'C'><cfset rootId = LEFT(rootId, len(rootId)-1)></cfif> ---><!--- comments are encoded as %CDELTA  --->
   			<cfset cutParam = rootID.split("OID")  />
   			<cfset activeColumn = cutParam[1] />
   			<cfset activeOID = cutParam[2].split("_") />
  			<!---<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  --->
  			REGULAR FIELD #rootId# () - Form[i] #form[i]# - activeColumn #activeColumn# - #Form[rootID]#<br>
	   		<cfset task = updateUser(activeColumn, activeOID[1], Form[rootID]) />
	   		<br>Updating metadata now...<br>
	   		<cfset actionEntry = trackUserAction(#REQUEST.AuthUser#,#current_inst#,6,"USER update by #REQUEST.authUser# - #activeColumn# OID#activeOID[1]# changed to #Form[rootID]# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
	   </cfif>
	</cfloop> 
<cfelse>
	<h2>No changes or updates were detected</h2>
	<p>Click your back button and try again. Thanks!</p>
	<cfabort>
</cfif>
</cfoutput>
<cflocation url="projector_users.cfm" addtoken="false" />