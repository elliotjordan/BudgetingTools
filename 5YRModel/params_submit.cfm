<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput>
<h2>5YModel Parameter Form submission</h2>

<cfif IsDefined("form") and StructKeyExists(form,"fymSubmit")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			 <!---DEBUGGING DISPLAY--->
			<cfset rootID = REPLACE(i,"DELTA","") />
	   		<!---i: #i# - Form[i]: #Form[i]# -- rootID: #rootID# Form[rootID]: #Form[rootID]#<br />--->
	   		<cfset rootID = REPLACE(i,"DELTA","") />
   			<cfset cutParam = ListToArray(REPLACE(rootID,"OID",""),"~",false,true)  />
   			<!---OID:#cutParam[1]# |column:#cutParam[2]# | form value to use for updating the column:#Form[rootID]#<br />-----<br>--->
	   		<!---<cfset task = updateFymData(cutParam[2], cutParam[1], Form[rootID] ) />--->
	   </cfif>
	</cfloop>
	<!---<cfdump var="#Form#" />--->
	<!---<cfscript>
		updateNumParam();
		updateExp();
		updateCrHrFromParams();
	</cfscript>--->
</cfif>
</cfoutput>

<cfset updateStatus1 = updateNumParam()>
<cfset updateStatus2 = updateExp()>
<cfset updateStatus3 = updateCrHrFromParams()>

<!---<cfdump var="#form#">--->
<cflocation url="params.cfm" addtoken="false" />

