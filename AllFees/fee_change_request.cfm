<cfinclude template="../includes/header_footer/allfees_header.cfm"  runonce="true" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<cfset ALLFEE_LIST = getAllV9Fees()>
<cfif StructKeyExists(url,"ALLFEE_ID")>
	<cfset ALLFEE_INFO = getFeeInfoByAllfeeID(url.ALLFEE_ID)>
<cfelseif IsDefined("FORM") AND StructKeyExists(form,"SubmitBtn1") AND StructKeyExists(session,"curr_proj_chart")>
	<cfset new_ALLFEE_ID = createNext_AllFeeID( MID(SESSION.curr_proj_chart,1,2), MID(FORM.FEE_TYPE,3,3), SESSION.curr_proj_RC )>
	<cfset ALLFEE_INFO = getFeeInfoByAllfeeID(new_ALLFEE_ID)>
	<cfset ALLFEE_INFO.FEE_NOTE = "New fee request submission">
	<cfset ALLFEE_INFO.FEE_DESC_LONG = "Missing" />
</cfif>
<cfset DISTINCT_OWNERS = getDistinctOwners(ALLFEE_INFO.INST_CD)>
<cfset DISTINCT_ACCOUNTS = getDistinctAccountNumbersByCampus(ALLFEE_INFO.INST_CD, ALLFEE_INFO.FEE_TYPE,"none")>
<cfset DISTINCT_SUB_ACCOUNTS = getDistinctSubAccountNumbersByCampus(ALLFEE_INFO.INST_CD, "none")>
<cfset DISTINCT_WO_ACCOUNTS = getDistinctWOAccountNumbersByCampus(ALLFEE_INFO.INST_CD, "none")>
<cfset DISTINCT_REC_ACCOUNTS = getDistinctRecAccountNumbersByCampus(ALLFEE_INFO.INST_CD, ALLFEE_INFO.FEE_TYPE, "none")>
<cfset DISTINCT_OBJCDS = getDistinctObjectCodesByCampus(ALLFEE_INFO.INST_CD, ALLFEE_INFO.FEE_TYPE, "none")>
<cfset DISTINCT_UNIT_BASIS = getDistinctUnitBasisByFeeType(ALLFEE_INFO.FEE_TYPE)>
<cfset DISTINCT_BEGIN_TERMS = getDistinctBeginTerms()>

<cfoutput> <!---<cfdump var="#session#" >--->
<div class="full_content">
<cfinclude template="nav_links.cfm" runonce="true">
<cfset newFeeInd = false> 
<cfif ALLFEE_INFO.FEE_BEGIN_TERM gte application.current_term>  <!--- BEGIN MAIN IF STATEMENT --->
	<cfset newFeeInd = true>
	<h2>New Fee ID: #ALLFEE_INFO.ALLFEE_ID#</h2>
	<p>Note: Your new AllFee_ID has been reserved for you. You may "save" it as many times as you like. When you are satisfied, you may "Check Everything" at the bottom of this form and "Submit" the fee for approval. As always, you can call us at UBO for help if you need us. We're always happy to hear from you!</p>  
		<cfinclude template="fee_form.cfm" runonce="true" />
<cfelseif StructKeyExists(url,"ALLFEE_ID") AND ALLFEE_INFO.recordcount LT 1>
	<h2>Oops, Sorry!</h2>
	<p>We are sorry, but we did not find your information.  Please contact John Burgoon (jburgoon@indiana.edu) at the Budget Office and include the ALLFEE_ID you are trying to find.  Thank you.</p>
	
<cfelseif StructKeyExists(url,"ALLFEE_ID") AND ALLFEE_INFO.recordcount EQ 1>
	<!--- OK we have an ALLFEE_ID so let's populate the form with our data  --->
	<h2>Fee Change Request Form for #url.ALLFEE_ID#</h2> 
	<cfinclude template="fee_form.cfm" runonce="true" />	 	
<cfelse>
	<h2>Oops, Sorry!</h2>
	<p>We are sorry, but something has gone wrong with our All Fees website.  Please contact John Burgoon (jburgoon@indiana.edu) at the Budget Office and tell him you got this message.  Thank you.</p>
</cfif>  <!--- END MAIN IF STATEMENT --->

</div>  <!-- End div class full_content -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" runonce="true" />

