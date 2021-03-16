<cfset approvalList = getRegionalApprovalList() />
<cfoutput>
	<!-- Begin Regional Approval form -->
	 	<cfform action = "approval_submit.cfm" id = "approvalForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque" >
			<table id="regionalFeesTable" class="approvalTable">
				<thead>
					<tr>
						<th><span class="sm-blue">Unique ID</span></th>
						<th><span class="sm-blue">Campus</span></th>
						<th><span class="sm-blue">Fee Description</span></th>
						<th><span class="sm-blue">Owner</span></th>
						<th><span class="sm-blue">Replacing?</span></th>
						<th><span class="sm-blue">Fee Type</span></th>
						<th><span class="sm-blue">Object Code</span></th>
						<th><span class="sm-blue">Unit Basis</span></th>
						<th><span class="sm-blue">Account Details</span></th>
						<th><span class="sm-blue">Proposed<br>rates</span></th>
						<th><span class="sm-blue">Need for Fee</span></th>
						<th><span class="sm-blue">Est. volume</span></th>
						<th><span class="sm-blue">Fee Begin Term</span></th>
						<th><span class="sm-blue">Current Status</span></th>
						<th><span class="sm-blue">Approve / OK / Return / Deny<br>
								<input type="checkbox" id="approve_all_cb" name="approve_all_cb" onchange="blanketApproval()">
								<label for="approve_all_cb">Approve All</label>
							</span></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="#approvalList#">
				    		<tr>
				    			<td>#approvalList.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#approvalList.ALLFEE_ID#">Update</a></span></td>
								<td>#approvalList.INST_CD#</td>
								<td>#approvalList.FEE_DESC_long#</td>
								<td>#approvalList.FEE_OWNER#</td>
								<td>#approvalList.REPLACEMENT_FEE#</td>
								<td>#approvalList.FEE_TYP_DESC#</td>
								<td>#approvalList.OBJ_CD#</td>
								<td>#approvalList.UNIT_BASIS#</td>
								<td>#approvalList.ACCOUNT_NBR#</td>
								<td>YR1: #approvalList.fee_lowyear# - YR 2: #approvalList.fee_highyear#</td>
								<td>#approvalList.NEED_FOR_FEE#</td>
								<td>#YR1_EST_VOL# - YR2: #YR2_EST_VOL#</td>
								<td>#approvalList.FEE_BEGIN_TERM#</td>
								<td>#approvalList.FEE_STATUS#</td>
								<td>
									<select id="approval_select" name="FEE_STATUS" class="approval_dropdown" onchange="approvalButton()">
										<option value="false">-- Approve/OK/Return/Deny --</option>
										<option value="Approved">Approve</option>
										<option value="CampusOK">Campus OK</option>
										<option value="Campus Returned">Campus Return</option>
										<option value="Campus Denied">Campus Deny</option>
										<option value="RegionalOK">Regional OK</option>
										<option value="Regional Returned">Regional Return</option>
										<option value="Regional Denied">Regional Deny</option>
									</select>	
								</td>
				    		</tr>
	    					<input type="hidden" name="ALLFEE_ID" value="#approvalList.ALLFEE_ID#">
		    		</cfloop> 
		    	</tbody>
			</table>
			<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
			<!--- Add save and submit buttons --->
			<input id="SubmitBtn5" type="submit" name="Submit" value="Submit Approvals" disabled />
		</cfform>
</cfoutput>