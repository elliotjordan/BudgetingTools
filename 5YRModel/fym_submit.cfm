<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput> 
<h2>5YModel Main Form submission</h2>
<cfif IsDefined("form") and StructKeyExists(form,"fymSubmitBtn")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			<cfset rootID = REPLACE(i,"DELTA","") />  
   			<cfset cutParam = rootID.split("OID")  />
   			<cfset activeColumn = cutParam[1] />
   			<cfset activeOID = cutParam[2].split("_") />
  			<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  
	   		<cfset task = updateFymData(activeColumn, activeOID[1], scrubbedValue) />
	   </cfif>
	   <cfif Form[i] eq 'COMMENT'>
			<cfset rootID = REPLACE(i,"CDELTA","") />  
			<cfset newComment = #Form[rootID]# />
   			<cfset cutParam = rootID.split("_")  />
   			<cfset activeOID = cutParam[2] />
	   	<!--- Looping through #i# - #Form[i]# - cutParam: #cutParam[1]# #cutParam[2]#<br />  --->
	   		<cfset task = updateFYMcomment(activeOID, newComment) />
	   </cfif>
	</cfloop> 
<cfelseif IsDefined("form") and StructKeyExists(form,"fymExcelBtn")>
	<cflocation url="fym_interface_excel.cfm" addToken="false" />
<cfelseif isDefined("form") and StructKeyExists(form,"fymCrHrCompareBtn")>
	<cflocation url="fym_comparison_excel.cfm" addToken="false" />
<cfelse>
	<p>Error. Please contact us and explain that you got the "5Yr Model Form submission error". Sorry for the trouble! Thanks</p> <cfabort>
</cfif>
<cfset updateStatus = updateCrHrRates(currentUser.fym_inst)>  
<cflocation url="index.cfm" addtoken="false" />
</cfoutput>
