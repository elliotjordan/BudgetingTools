<cfset limboFeeData = getAllLimboFees()>
<cfoutput>
		<h2>Outstanding Non-instructional Requests</h2>
		<p>Fees pending approval, denied increases, requests for more information</p>
	 	<cfform action = "fee_rate_update.cfm" id = "AllFeesPending" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque">
			<table id="pendingFeesTable" class="allFeesTable">
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
				<tbody>
				<cfif limboFeeData.recordcount lt 1>
		    		<tr>
				    	<td colspan="12">You currently have no requests for more information.  None of your fees are pending or denied approval.</td>
				    </tr>
				<cfelse>
					<cfloop query="#limboFeeData#">
				    		<tr>
				    			<td>#limboFeeData.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#limboFeeData.ALLFEE_ID#">Update</a></span></td>
								<td>#limboFeeData.INST_CD#</td>
								<td>#limboFeeData.FEE_DESC_BILLING#</td>
								<td>#limboFeeData.FEE_OWNER#  #application.rcNames[FEE_OWNER]#</td>
								<td>#limboFeeData.FEE_TYPE#</td>
								<td>#limboFeeData.ACCOUNT_NBR#</td>
								<td>#limboFeeData.OBJ_CD#</td>
								<td>#limboFeeData.UNIT_BASIS#</td>
								<td class="right-justify">#DollarFormat(limboFeeData.fee_current)#</td>
								<td class="right-justify">#DollarFormat(limboFeeData.fee_lowyear)#</td>
								<td class="right-justify">#DollarFormat(limboFeeData.fee_highyear)#</td>
								<td>#limboFeeData.FEE_STATUS#</td>
								<td>
									<input type="checkbox" id="cancel_ckbox" name="cancel_ckbox" onclick="showCancelButton('cancel_btn','#limboFeeData.ALLFEE_ID#')">
									<input id="cancel_btn" type="submit" name="cancel_btn" value="Cancel #limboFeeData.ALLFEE_ID#" disabled="disabled" feeid="#limboFeeData.ALLFEE_ID#" />
									<input type="hidden" id="cancel_AllFeeID" name="cancel_AllFeeID" value="#limboFeeData.ALLFEE_ID#">
									<input type="hidden" id="CURRENT_TERM" name="FEE_BEGIN_TERM" value="#limboFeeData.FEE_BEGIN_TERM#">
								</td>
				    		</tr>
		    		</cfloop> 
		    	</cfif>
		    	</tbody>
			</table>
		</cfform>	
</cfoutput>