<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput> 
<h2>5YModel Main Form submission</h2>
<cfset current_fund = 1 />
<cfif StructKeyExists(url,"fund")><cfset current_fund = url.fund /></cfif>
<cfif IsDefined("form") and StructKeyExists(form,"fymSubmitBtn")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		
		<cfif Form[i] eq true>
			Form[i] #Form[i]# <br />
			<cfset rootID = REPLACE(i,"DELTA","") />  
			<!---<cfif RIGHT(rootId,1) eq 'C'><cfset rootId = LEFT(rootId, len(rootId)-1)></cfif> ---><!--- comments are encoded as %CDELTA  --->
   			<cfset cutParam = rootID.split("OID")  />
   			<cfset activeColumn = cutParam[1] />
   			<cfset activeOID = cutParam[2].split("_") />
  			<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  
  			REGULAR FIELD #rootId# Form[i] #form[i]# - activeColumn #activeColumn# - #scrubbedValue#<br>
	   		<cfset task = updateFymData(activeColumn, activeOID[1], scrubbedValue) />
	   		<cfset actionEntry = trackFYMAction(#REQUEST.AuthUser#,#current_inst#,21,"fym_submit - #activeColumn# OID#activeOID[1]# changed to #scrubbedValue# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
	   </cfif>
	   <cfif Form[i] eq 'COMMENT'>
			<cfset rootID = REPLACE(i,"CDELTA","") />  
			<cfset newComment = #Form[rootID]# />
   			<cfset cutParam = rootID.split("_")  />
   			<cfset activeOID = cutParam[2] />
	   	 COMMENT Looping through #i# - #Form[i]# - cutParam: #cutParam[1]# #cutParam[2]#<br />  
	   		<cfset task = updateFYMcomment(activeOID, newComment) />
	   		<cfset actionEntry2 = trackFYMAction(#REQUEST.AuthUser#,#current_inst#,22,"comment on row #activeOID# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
	   </cfif>
	</cfloop> 
<cfelseif IsDefined("form") and StructKeyExists(form,"fymExcelBtn")>
	<cflocation url="fym_interface_excel.cfm" addToken="false" />
	<cfset actionEntry2 = trackFYMAction(#REQUEST.AuthUser#,#current_inst#,23,"downloaded FYM Excel - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
<cfelseif isDefined("form") and StructKeyExists(form,"fymCrHrCompareBtn")>
	<cflocation url="fym_comparison_excel.cfm" addToken="false" />
<cfelseif isDefined("form") and StructKeyExists(form,"radSelBtn")>
	<cflocation url="index.cfm?fund=#form.fundRad#" addtoken="false" />
<cfelse>
	<p>Error. Please contact us and explain that you got the "5Yr Model Form submission error". Sorry for the trouble! Thanks</p> <cfabort>
</cfif>
<cfset updateStatus = updateCrHrRates(currentUser.fym_inst)>  <!---
<cflocation url="index.cfm?fund=#current_fund#" addtoken="false" />--->
</cfoutput>
