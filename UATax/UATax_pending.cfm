	<a href="index.cfm">Home</a>
		<!--- PENDING --->
		<h3>Pending Requests</h3>
		<cfif ListFindNoCase(REQUEST.Approver_list, REQUEST.authUser)>
			<cfset activeApprover = "true"><cfelse><cfset activeApprover = "false">
		</cfif>
		<table class="feeCodeTable">
			<thead>
				<tr>
					<th>Request ID</th>
					<th>RC</th>
					<th>RC Name</th>
					<th>Description</th>
					<th>Prior Requested Amount</th>
					<th>Prior Approved Base</th>
					<th>Prior Approved Cash</th>
					<th>New Request Amount</th>
					<th>Account Number</th>
					<th>Justification</th>
					<th>Request Status</th>
					<cfif activeApprover>
						<th>Approve/Deny</th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfdump var="#UATax_data.recordCount#" >
					<cfif UATax_data.recordCount eq 0>
						<tr>
							<td colspan="100%" style="border:1px solid black">No UA Assessment requests are pending at this time.</td>
						</tr
					</cfif>
					<cfloop query="#UATax_data#">
						<cfif #REQ_STATUS# eq 'PENDING'>
							<tr>
								<td>#RC_CD#</td>
								<td>#RC_NM#</td>
								<td>#SPECIAL_TITLE#</td>
								<td>#DollarFormat(PRIOR_REQ_AMT)#</td>
								<td>#DollarFormat(PRIOR_APPR_BASE)#</td>
								<td>#DollarFormat(PRIOR_APPR_CASH)#</td>
								<td>#DollarFormat(REQ_AMOUNT)#</td>
								<td>#ACCOUNT_NBR#</select>
								</td> 
								<td>#JUSTIFICATION#</td>
								<td>#REQ_STATUS#</td>
								<cfif ListFindNoCase(REQUEST.Approver_list, REQUEST.authUser)>
									<td>
										<select name="appr_select" size="1">
											<option value="PENDING">PENDING</option>
											<option value="APPROVED">APPROVED</option>
											<option value="DENIED">DENIED</option>
										</select>
									</td>
								<cfelse>
									<input type="hidden" value="PENDING" name="APPR_SELECT">
								</cfif>
							</tr>
						</cfif>
					</cfloop>
				</cfoutput>
			</tbody>
		</table>