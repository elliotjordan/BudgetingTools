<!---<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm" runonce="true" />
</cfif>
<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />--->

<!---<div class="full_content">
	<cfinclude template="nav_links.cfm">
	<h2>Non-instructional Fee Rates for Fiscal Years 2019-2020 and 2020-2021</h2>
	<cfset totalFeeData = getAllV9Fees('all','none')>--->
<!-- Begin fee rate form -->
		<h3>Request a Brand New Fee</h3>
		<cfform action = "fee_change_request.cfm" id = "AllFeesFormV9" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
	 		timeout = "1200" width = "800" wMode = "opaque">
			<p>
				<select id="type_select" name="FEE_TYPE" class="request" onchange="newFeeButton()">
					<option value="false">-- Please select a fee type --</option>
					<option value="1_ADM">Administrative Fee</option>
					<option value="2_CMP">Campus Fee</option>
					<option value="4_CRS">Course Fee</option>
			<!---   <option value="5__DE">Distance Ed Fee</option>
					<option value="6_INS">Instructional</option>
					<option value="7_MAN">Mandatory Program Fee</option>
					<option value="8_OTH">Other Fee</option>
					<option value="9_PRE">Pre-payment</option>
					<option value="10_PUR">Purchase/Rental</option>
					<option value="11_SVC">Service Fee</option>  --->
				</select>
			</p>
			<input id="SubmitBtn1" type="submit" name="SubmitBtn1" value="Request New Fee" disabled="disabled"  />			
		</cfform>
		<hr width="100%" /><!---
		<cfinclude template="list_main.cfm">
		<cfinclude template="list_outstanding.cfm">
		<br>
		<hr width="100%">		
		<cfinclude template="list_campusFees.cfm">
		<cfinclude template="list_campusOutstanding.cfm">	
</div> --->
