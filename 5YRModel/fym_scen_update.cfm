<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfinclude template="../includes/functions/user_functions.cfm" runonce="true" />

<!---<cfdump var="#form#" >--->
	
<cfoutput>
<cfif IsDefined("form") and StructKeyExists(form,"scenModelBtn")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			<!---Form[i] #Form[i]# <br />--->
			<cfset rootID = REPLACE(i,"DELTA","") />  
   			<cfset cutParam = rootID.split("OID")  />
   			<cfset activeColumn = cutParam[1] />
   			<cfset activeOID = cutParam[2].split("_") />
  			<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  
  			<!---REGULAR FIELD #rootId# Form[i] #form[i]# - activeColumn #activeColumn# - #scrubbedValue#<br>--->
	   		<cfset task = updateFYMscenario(activeOID[1], activeColumn, scrubbedValue) />
	   		<!---<br>Updating metadata now...<br>--->
	   		<cfset actionEntry = trackFYMAction(#REQUEST.AuthUser#,#getFocus(REQUEST.AuthUser).focus#,30,"Updated Scenario model - #activeColumn# OID#activeOID[1]# changed to #scrubbedValue# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
	   </cfif>
	</cfloop> 
<cfelseif IsDefined("form") and StructKeyExists(form,"scenCrHrBtn")>
	<!--- Do crhr Updates to scenario  --->
	<cfset actionEntry2 = trackFYMAction(#REQUEST.AuthUser#,#getFocus(REQUEST.AuthUser).focus#,31,"update CrHr scenario - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
<cfelse>
	<p>Error. Please wave your arms in the air and yell at UBO. No, on second thought, please just call us. Thanks :)</p>
</cfif>
</cfoutput>

<cflocation url="scenarios.cfm" addtoken="false" />
