<cfoutput>
	<cfset approvalSummary = getApprovalSummary()>
	<h2>Approvals Summary</h2>
	<table id="summaryTable" class="feeCodeTable">
		<thead>
			<tr>
				<th>Campus</th>
				<th>Fee Type</th>
				<th>Fee Status</th>
				<th>Total Remaining</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query='#approvalSummary#'>
			<tr>
				<td>#INST_CD#</td>
				<td>#FEE_TYP_DESC#</td>
				<td>#FEE_STATUS#</td>
				<td>#COUNT#</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	<hr width="90%"/>
</cfoutput>