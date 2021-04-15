<cfinclude template="../includes/functions/fee_rate_functions.cfm" >
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<cfoutput>
<cfif IsDefined("form") and StructKeyExists(form,"save_btn") and StructKeyExists(form,"fieldnames")>
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			<cfset rootID = REPLACE(i,"DELTA","") />
   			<cfset cutParam = rootID.split("-")  />
	   		<cfset task = updateFeeRate(trim(cutParam[1]), trim(Form[trim(rootID)]), trim(cutParam[2]) ) />
	   		 <!---#rootID# -> #cutParam[1]# | #cutParam[2]# | #Form[rootID]#  RESULT: #task# <br />--->
	   </cfif>
	</cfloop>
<cfelseif IsDefined("form") and StructKeyExists(form,"new_submit_btn")>
	<cfset savedNewFee = saveNewFee(form) />
	<cflocation url="list_campusOutstanding.cfm" addToken="no" />
<cfelse>
	<h2>The Fee Portal Has Fleas</h2>
		<p>The form you tried to update did not contain any fieldnames element. We are sorry but your changes are not saved, something is broken.</p>
		<p>Please contact John Burgoon at UBO and say "hi". While you have him on the line, tell him the fee portal has a bug and it might be fleas.</p>
		<cfabort>
</cfif>

</cfoutput>
<cflocation url="index.cfm" addtoken="false" />
<!---
<cfif IsDefined("url") AND StructKeyExists(url,"fid")>
	<cfset fee_fields = getAllFees(url.fid)>
	<!---<cfdump var="#fee_fields#" >--->
</cfif>

<cfif StructKeyExists(FORM, "ALLFEE_ID")>
	<cfset submittedAllFeeID = FORM.ALLFEE_ID>
</cfif>

<cfif StructKeyExists(FORM,"SAVE_BTN") AND !StructKeyExists(form,"PRESERVE_STATUS")>
	<cfset setStatusForFee("Pending",#FORM.ALLFEE_ID#)>
</cfif>

<cfif StructKeyExists(FORM,"CANCEL_BTN")>
	<cfset FORM.ALLFEE_ID = MID(FORM.CANCEL_BTN,8,11)>
</cfif>

<cfif StructKeyExists(FORM, "NEW_SUBMIT_BTN")>
	<cfset setStatusForFee("Submitted New",#FORM.ALLFEE_ID#)>
</cfif>

<cfif StructKeyExists(FORM, "EDIT_SUBMIT_BTN")>
	<cfset setStatusForFee("Submitted Change",#FORM.ALLFEE_ID#)>
</cfif>

<cfoutput>
<!---<cfdump var="#FORM#" >--->
<cfset example = updateEveryFieldYouCan(form)>
<!---<cfdump var="#example#" ><cfabort>--->




<cfsavecontent variable="strSQL" >
	#example#
</cfsavecontent>
<cfset sampleQ = queryExecute(example,[],{datasource='#application.datasource#'}) >

<!---
<h2>Sorry</h2>
<p>The UBO gang are working on this page right now, so your "Save" did not actually go into the database.</p>
<p>When we finish this part, this message will disappear, and you will see your changes saved on the main page.  Sorry for any inconvenience.</p>
--->

</cfoutput>

<!---<cfdump var="#strSQL#" ><cfabort>--->


<!---  USE THIS WHEN DEVELOPMENT COMPLETE  --->
<cfset returnString = "index.cfm" />
<cflocation url= #returnString# addToken="false" />

--->

