<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm" runonce="true">
</cfif>
<cfinclude template="../includes/functions/fee_rate_functions.cfm" >
<cfoutput>
	<!---<cfdump var="#form#"><cfabort>--->
<cfif StructKeyExists(FORM, "ALLFEE_ID")>
	<cfset counter = 1>
	<cfloop index="id" list="#Form.ALLFEE_ID#" delimiters=",">
		<cfset approvalStatus = ListGetAt(FEE_STATUS,counter)>
    	<cfif approvalStatus neq "false">
    		<cfset setStatusForFee(approvalStatus,id)>
    	</cfif>
    	<cfset counter = counter + 1>
	</cfloop>
</cfif>
</cfoutput>

<cfset returnString = ListFirst(FORM.RETURNSTRING) />
<cfif returnString neq cgi.SCRIPT_NAME>
	<cflocation url= #returnString# addToken="false" />
</cfif>