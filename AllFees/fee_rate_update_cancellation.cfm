<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>
<cfinclude template="../includes/functions/fee_rate_functions.cfm" >

<cfif IsDefined("url") AND StructKeyExists(url,"fid")>
	<cfset fee_fields = getAllFees(url.fid)>
	<!---<cfdump var="#fee_fields#" >--->
</cfif>

<cfset x = #ListToArray(FORM.CANCEL_ALLFEEID)#>
<cfset y = #ListToArray(FORM.CANCEL_CKBOX)#>
<!---<cfdump var="#x#" >
<cfdump var="#y#" >--->

<cfif StructKeyExists(FORM, "CANCEL_BTN")>
	<cfset cancelCommon(ListToArray(#FORM.CANCEL_ALLFEEID#), ListToArray(#FORM.CANCEL_CKBOX#) )>	
</cfif>

<cfif StructKeyExists(FORM, "ALLFEE_ID")>
	<cfset submittedAllFeeID = FORM.ALLFEE_ID>
<cfelse>
	<!---<cfset submittedAllFeeID = createNext_AllFeeID(MID(FORM.INST_CD,3,2), MID(FORM.FEE_TYPE,3,3))>--->
</cfif>
<cfoutput>
<!---<cfdump var="#submittedAllFeeID#" >--->

<!---<cfset testColNames = getAllFeesColumnNames()>--->
<!---<cfdump var="#application.allFeesTable#" ><br>--->
<!---<cfdump var="#testColNames#" >--->

<!---
<cfif IsDefined("form") AND StructKeyExists(form,"SAVE_BTN") AND form.SAVE_BTN eq "Save">
	<p>SAVE BUTTON WAS PRESSED AND SUBMITTED ALLFEE_ID IS #FORM.ALLFEE_ID# - Processed into #submittedAllFeeID#</p>
<cfelseif IsDefined("form") AND StructKeyExists(form,"SUBMIT_BTN") AND form.SUBMIT_BTN eq "Submit">
	<p>SUBMIT BUTTON WAS PRESSED</p>
</cfif>
--->
<!---<div class="full_content">
	<h3>Fee Rate Updates</h3>
	<p>Fee rate updates were submitted.  This is where we land when that happens.</p>
	<cfdump var="#FORM#" />--->
	
	<!---<cfset freshAllFeeID = createNext_AllFeeID(MID(SESSION.curr_proj_chart,1,2), MID(FORM.FEE_TYPE,3,3))>--->

	
	<!---<cfinclude template="submit_fee_rate_changes.cfm" >--->
<!---</div>--->

<cfset example = updateEveryFieldYouCan(form)>
<!---<cfdump var="#example#" ><cfabort>--->
<cfsavecontent variable="strSQL" >
	#example#
</cfsavecontent>
<cfset sampleQ = queryExecute(example,[],{datasource='#application.datasource#'}) >

<!---<h2>Sorry</h2>
<p>The UBO gang are working on this page right now, so your "Save" did not actually go into the database.</p>
<p>When we finish this part, this message will disappear, and you will see your changes saved on the main page.  Sorry for any inconvenience.</p>
<cfdump var="#strSQL#" ><cfabort>--->

<!---<cfquery name="automaticUpdater" datasource="#application.datasource#">
	#PreserveSingleQuotes(strSQL)#
</cfquery>
<cfset myQuery = #QueryExecute(automaticUpdater)#>
<cfdump var="#example#" ><cfabort>--->


<!---<cfdump var="#example#" >--->

</cfoutput>
<!---<cfinclude template="../includes/header_footer/allfees_footer.cfm" />--->

<!---  USE THIS WHEN DEVELOPMENT COMPLETE  --->
<cfset returnString = "index.cfm" />
<cflocation url= #returnString# addToken="false" />



