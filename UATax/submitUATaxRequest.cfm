<cfinclude template="../includes/functions/UATax_functions.cfm" />
<!---<cfdump var="#FORM#" />--->
<!--- Submit Your Request  --->
<cfif IsDefined("form.submitbtn")>
	<cfif IsDefined("form.just_file_input") AND form.just_file_input neq "">
		<cffile action="UPLOAD" filefield="just_file_input" destination="#REQUEST.fileUploadPath#" nameconflict="MAKEUNIQUE">
		<!---<cfhttp url="#boxUploadPath#" method="POST" redirect="true"></cfhttp>--->
		<cfscript>
			insertRequest('92',FORM.ACCT_SELECT, FORM.REQ_DESC, FORM.REQ_AMOUNT, FORM.JUST_FILE_INPUT, FORM.APPR_SELECT);
		</cfscript>
		Request accepted, file #FORM.JUST_FILE_INPUT# uploaded.
	<cfelseif IsDefined("form.just_text_input") AND form.just_text_input neq "">
		<cfscript>
			insertRequest('92',FORM.ACCT_SELECT, FORM.REQ_DESC, FORM.REQ_AMOUNT, FORM.JUST_TEXT_INPUT, FORM.APPR_SELECT);
		</cfscript>
		Request accepted.
	<cfelse>
		<p>No justification provided.</p>
	</cfif>

<!--- Request the UA Tax Report  --->
<cfelseif IsDefined("form.reportBtn")> 
			<cfset s = spreadsheetNew()>
			<cfspreadsheet action="read" src = "../includes/forms/B0865UA_BaseBals_template.xls" sheet="1" headerrow="8" name="jwb">
<!---			<cfscript>
				SpreadSheetSetActiveSheet(jwb,"RawData");
				spreadsheetAddRows(jwb, reportSelect);
			</cfscript> --->  
			<cfset filenameString = "B0865UA_BaseBals">
			<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(jwb)#">
<!--- Download the data to Excel  --->
<cfelseif IsDefined("form.dwnldBtn")>
	<cfinclude template="UATax_to_excel.cfm" >
<cfelseif IsDefined("form.apprBtn")>
	<cfoutput>
		<cfset counter = 1>
		<cfloop list="#form.REQ_ID_LIST#" index="i">
			<!---<p>#i# - #ListGetAt(FORM.APPR_SELECT,counter)# - #counter#</p>--->
			<cfscript>
				approveRequest(i,ListGetAt(FORM.APPR_SELECT,counter));
			</cfscript>
			<cfset counter = counter + 1>
		</cfloop>
	</cfoutput>
<cfelseif IsDefined("form.revertBtn")>
	<cfoutput>
		<p>#form.revertBtn# - #LSParseNumber(REPLACE( form.revertBtn,'Undo ','') )#</p>
	</cfoutput>
	<script>
		revertRequest(form.revertBtn);
	</script>
<cfelse>
	<h2>No Request</h2>
	<p>Sorry, we do not recognize your request</p>
</cfif>
<cfabort />
<cflocation url="index.cfm" addtoken="false">

