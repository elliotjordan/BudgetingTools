<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput>
<h2>5YModel CrHr Form submission</h2>
<cfif IsDefined("form") and StructKeyExists(form,"fymCrHrSubmitBtn")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			<cfset rootID = REPLACE(i,"DELTA","") />  
   			<cfset cutParam = rootID.split("OID")  />
   			<cfset activeColumn = cutParam[1] />
   			<cfset activeOID = cutParam[2] /> 
   			<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  
	   		<cfset task = changeCrHrRates(activeColumn, activeOID, scrubbedValue ) />
	   </cfif>
	</cfloop>
<cfelse>
	<p>The form did not contain an fymCrHrSubmitBtn element.</p>
</cfif>
<cfset updateStatus = updateCrHrRates(currentUser.chart)>
<cflocation url="CrHrProjections.cfm" addtoken="false" />
</cfoutput>
