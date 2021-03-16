<cfinclude template="../includes/header_footer/allfees_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm" runonce="true" >
</cfif>
<cfset camPendFeeData = getCamPendFees('false', MID(session.access_level,3,2))>

<cfinclude template="campus_controls.cfm" runonce="true" />
<!---
<cfoutput>
	<div class="full_content">
		<cfinclude template="fees.cfm" runonce="true" />
		<h2>Outstanding Campus Requests</h2>
		<p>Campus fees pending approval, denied increases, requests for more information</p>
	 	<form action = "fee_rate_update.cfm" id = "CampusFeesPending" method = "POST">
				<table id="camPendApprovalTable" class="allFeesTable">
					<thead>
						<tr>
							<th>Unique ID</th>
							<th>Campus</th>
							<th>Fee Description</th>
							<th>Fee Owner</th>
							<th>Fee Type</th>
							<th>Revenue Account</th>
							<th>Object Code</th>
							<th>Unit Basis</th>
							<th>Current<br>FY19 rate</th>
							<th>FY20 Rate</th>
							<th>FY21 Rate</th>
							<th>Fee Status</th>
							<th>Cancel Request</th>
						</tr>
					</thead>
					<cfif camPendFeeData.recordcount lt 1>
						<tbody>
				    		<tr>
						    	<td colspan="13">None of your campus fees are pending or denied approval.</td>
						    </tr>
					<cfelse>
						<tbody>
							<cfloop query="#camPendFeeData#">
						    		<tr>
						    			<td>#camPendFeeData.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#camPendFeeData.ALLFEE_ID#">Update</a></span></td>
										<td>#camPendFeeData.INST_CD#</td>
										<td>#camPendFeeData.FEE_DESC_BILLING#</td>
										<td>#camPendFeeData.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
										<td>#camPendFeeData.FEE_TYP_DESC#</td>
										<td>#camPendFeeData.ACCOUNT_NBR#</td>
										<td>#camPendFeeData.OBJ_CD#</td>
										<td>#camPendFeeData.UNIT_BASIS#</td>
										<td class="right-justify">#DollarFormat(camPendFeeData.fee_current)#</td>
										<td class="right-justify">#DollarFormat(camPendFeeData.fee_lowyear)#</td>
										<td class="right-justify">#DollarFormat(camPendFeeData.fee_highyear)#</td>
										<td>#camPendFeeData.FEE_STATUS#</td>
										<td>
											<input type="checkbox" id="cancel_ckbox" name="cancel_ckbox" onclick="showCancelButton('cancel_btn','#camPendFeeData.ALLFEE_ID#')">
											<input id="cancel_btn" type="submit" name="cancel_btn" value="Cancel #camPendFeeData.ALLFEE_ID#" disabled="disabled" feeid="#camPendFeeData.ALLFEE_ID#" />
											<input type="hidden" id="cancel_AllFeeID" name="cancel_AllFeeID" value="#camPendFeeData.ALLFEE_ID#">
											<input type="hidden" id="CURRENT_TERM" name="FEE_BEGIN_TERM" value="#camPendFeeData.FEE_BEGIN_TERM#">
										</td>
						    		</tr>
				    		</cfloop>
				    	</tbody>
			    	</cfif>
				</table>
			</form>

</div>  <!-- End DIV class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" runonce="true" />
--->