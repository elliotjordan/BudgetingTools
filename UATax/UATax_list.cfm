	<!--- Base Items --->
		<h2>Adjusted Base Rows</h2>
		<p>This chart is designed to closely match the FY20 Add (Detail) tab from B7940sum_2020 V2.xlsx.</p>
		<table class="allFeesTable">
			<thead>
				<tr>
					<th>RC</th>
					<th>RC Name</th>
					<th>Org Code</th>
					<th>Org Name</th>
					<th>Account Number</th>
					<th>Account Name</th>
					<th>Object Code</th>
<!---
					<cfif ListFindNoCase(Approver_list, REQUEST.authUser)>
						<th>Revert</th>
					</cfif>
--->
					<th>Prior Approved Base</th>
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
						<cfif #REQ_STATUS# neq 'PENDING'>
							<tr>
								<td>#RC_CD#</td>
								<td>#RC_NM#</td>
								<td>#ORG_CD#</td>
								<td>#ORG_NM#</td>
								<td>#ACCOUNT_NBR#</td>
								<td>#ACCOUNT_NM#</td> 
								<th>#FIN_OBJECT_CD#</th>
								<td>#PRIOR_APPR_BASE#</td>
							</tr>
						</cfif>
					</cfloop>
				</cfoutput>
				<!---<input type="hidden" name="REQ_STATUS" value="REQUEST">--->
			</tbody>
		</table>		
		
