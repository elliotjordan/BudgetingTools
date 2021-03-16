<cfoutput>
	<cfif approvalList.recordCount gt 1>
		<span class="filterBox">
			<button id="twoPctBtn" class="filterBtn twopctOff" onclick="twoPctBtn()">Show Only Over 2%</button>
			<button id="newFeeBtn" class="filterBtn newFeeOff" onclick="newFeeBtn()">Show Only New Fees</button>
		</span>
	</cfif>
	<!-- Begin Fee Request form -->
		<hr width="100%"/>
		<h2>Campus Fee Request Approvals</h2>
	 	<cfform action = "approval_submit.cfm" id = "approvalForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque" >
			<table id="campusSplitTable" class="approvalTable">
				<thead>
					<tr class="newFee">
						<th><span class="sm-blue">Unique ID</span></th>
						<cfif role neq 'campus'>
							<th><span class="sm-blue">Campus</span></th>
						</cfif>
						<th><span class="sm-blue">Fee Description</span></th>
						<th><span class="sm-blue">Owner</span></th>
						<th><span class="sm-blue">Fee Type</span></th>
						<th><span class="sm-blue">Current Rate</span></th>
						<th><span class="sm-blue">Proposed<br>rates</span></th>
						<th><span class="sm-blue">Fee Begin Term</span></th>
						<th><span class="sm-blue">Current Status</span></th>
						<th><span class="sm-blue">Approve / OK / Return / Deny<br>
								<input type="checkbox" id="approve_all_cb" name="approve_all_cb" onchange="blanketApproval()">
								<label for="approve_all_cb">Approve All</label>
							</span></th>
					</tr>
				</thead>
				<tbody>
					<cfif approvalList.recordCount lt 1>
				    		<tr>
						    	<td colspan="12">You currently have no fee submissions to review.</td>
						    </tr>
					<cfelse>
						<cfloop query="#approvalList#">
						<cfif approvalList.FEE_TYPE eq 'CMP'>
							<cfif approvalList.CY_NUM neq 0>
								<cfset FY20_pct = NumberFormat( ((approvalList.LY_NUM - approvalList.CY_NUM)/approvalList.CY_NUM)*100, "99.99")>
							<cfelse>
								<cfset FY20_pct = "--">
							</cfif>
							<cfif approvalList.LY_NUM neq 0>
								<cfset FY21_pct = NumberFormat( ((approvalList.HY_NUM - approvalList.LY_NUM)/approvalList.LY_NUM)*100, "99.99")>
							<cfelse>
								<cfset FY21_pct = "--">
							</cfif>
							<cfset tr_string = '<tr name="feeRow"'>
							<cfif FY20_pct gt 2.00 OR FY21_pct gt 2.00>	<cfset tr_string = '<tr name="overage"'></cfif>
							<cfif approvalList.FEE_BEGIN_TERM gt application.current_term><cfset tr_string = tr_string & ' class="newFee">'> <cfelse> <cfset tr_string = tr_string & '>'> </cfif>
							#tr_string#
				    			<td>#approvalList.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#approvalList.ALLFEE_ID#">Update</a></span></td>
								<cfif role neq 'campus'>
									<td>#approvalList.INST_CD#</td>
								</cfif>
								<td>#approvalList.FEE_DESC_BILLING#</td>
								<td>#approvalList.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
								<td>#approvalList.FEE_TYPE#</td>
								<td>#DollarFormat(approvalList.CY_NUM)#</td>
								<td>
									YR1: #DollarFormat(approvalList.LY_NUM)# 
									<cfif FY20_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY20_pct# %)</span><br> 
									YR 2: #DollarFormat(approvalList.HY_NUM)# 
									<cfif FY21_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY21_pct# %)</span></td>
								<td>#approvalList.FEE_BEGIN_TERM#</td>
								<td>#approvalList.FEE_STATUS#</td>
								<td>
									<select id="approval_select" name="FEE_STATUS" class="approval_dropdown" onchange="approvalButton()">
										<option value="false">-- Approve/OK/Return/Deny --</option>
										<cfif role eq 'campus'>
											<option value="Campus Approved">Campus Approve</option>
											<option value="CampusOK">Campus OK</option>
											<option value="Campus Returned">Campus Return</option>
											<option value="Campus Denied">Campus Deny</option>
										<cfelseif role eq 'regional'>
											<option value="RegionalOK">Regional OK</option>
											<option value="Regional Returned">Regional Return</option>
										<cfelseif role eq 'bursar'>
											<option value="BursarOK">Bursar OK</option>
											<option value="Bursar Returned">Bursar Return</option>
										<cfelseif role eq 'ubo'>
											<option value="UBO Approved">UBO Approve</option>
											<option value="UBO Returned">UBO Return</option>
											<option value="UBO Denied">UBO Deny</option>										
										<cfelseif role eq 'cfo'>
											<option value="CFO Approved">CFO Approve</option>
											<option value="CFO Returned">CFO Return</option>
											<option value="CFO Denied">CFO Deny</option>										
										<cfelse>
										
										</cfif>
									</select>	
								</td>
								<input type="hidden" name="ALLFEE_ID" value="#approvalList.ALLFEE_ID#" />
				    		</tr>
						</cfif>
			    		</cfloop> 
					</cfif>
		    	</tbody>
			</table>
			<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
			<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
			<input id="SubmitBtn4" type="submit" name="Submit" value="Submit Approvals" disabled />
		</cfform>
</cfoutput>