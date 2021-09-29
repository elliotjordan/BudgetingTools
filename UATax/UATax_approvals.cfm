<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
	<!--- Completed Approvals --->
		<h3>Adjusted Base Rows</h3>
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
								<td width="96">#ACCOUNT_NBR#</td>
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
		
</cfif>