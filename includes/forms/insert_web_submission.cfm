<!--- 
	file:	insert_web_submission.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	11-11-14
	update:	
	note:	Submission logic for updates 
	*** NOTE: This action occurs when the user "Submits" the form. Uploading Excel only updates the form, it does NOT submit the form or hit this code!
 --->
<cfinclude template="../functions/functions.cfm" />
<cfset feeValues = EntityLoad("FEE_CODES",{fiscal_year = '#application.fiscalyear#'}) />
<cfset codeArray = "#ORMExecuteQuery('SELECT DISTINCT fee_id FROM FEE_CODES WHERE fiscal_year = #application.fiscalyear#')#">
	<!---<cfdump var="#Form#" ><cfabort>--->
	<!--- Loop through Form and perform updates --->
	<cfloop index="i" list="#Form.Fieldnames#" delimiters=",">
		<cfset stripped = listGetAt(#i#,1,"_") />  	<!--- Strips off the _LOW/_HIGH/_DESC from the fieldname so we have the Fee_ID --->
		
		<!---<cfset percent_request = listGetAt(#i#)--->
		<cfset lowHigh = listLast(#i#,"_") />		<!--- Tells us whether we have the low or high value --->
		<cfif ArrayContains(codeArray, stripped)>	<!--- Only attempt this with actual fields in the database, ignore other form fields --->
			<!---<cfdump var="#Replace(Form[i],",","","All")#" ><cfabort>--->
			<cfset thisFee = EntityLoad("fee_codes",{fee_id = #stripped#, fiscal_year = #application.fiscalyear#}, true) />  <!--- Grab the particular record we want --->
					<!--- Check which field, look for changes, update the database --->
					<cfif #lowHigh# eq "LOW" AND thisFee.getFee_lowyear() NEQ #LSParseNumber(Form[i])#>
						<!--- UPDATE METADATA HERE --->
						<cfset thisFee.setFee_Lowyear(#Replace(Form[i],",","","All")#) />	
						<cfset actionEntry = trackAction(#session.user_id#,#session.fin_coa_cd#,7,"updated fee code: #stripped# low year using value #thisFee.getFee_lowyear()#") />
					<cfelseif #lowHigh# eq "HIGH" AND thisFee.getFee_highyear() NEQ #LSParseNumber(Form[i])#>
						<!--- UPDATE METADATA HERE --->
						<cfset thisFee.setFee_Highyear(#Replace(Form[i],",","","All")#) />
						<cfset actionEntry = trackAction(#session.user_id#,#session.fin_coa_cd#,7,"updated fee code: #stripped# high year using value #thisFee.getFee_highyear()#") />
					<cfelseif #lowHigh# eq "DESCR" AND thisFee.getFee_descr() NEQ #Form[i]#>
						<!--- UPDATE METADATA HERE --->
						<cfset thisFee.setFee_descr(#Form[i]#) />
						<cfset actionEntry = trackAction(#session.user_id#,#session.fin_coa_cd#,7,"updated fee description: #stripped# with value #Form[i]#") />
					</cfif>
					<cfset EntitySave(thisFee) />			<!--- This actually writes the setting to the DB for this record --->
															<!--- NOTE: CFIDE has a field "Maximum number of POST request parameters" that 
															must be set higher to accept 500+ fields from this table --->				
		</cfif>
	</cfloop> 
<cflocation url="../../index.cfm" addtoken="false" />
