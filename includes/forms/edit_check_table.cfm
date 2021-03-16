<!--- partial to be included in the edit_checks page if desired  --->
	<table class="editCheckTable">
		<thead>
			<tr class="editCheckLabel">
				<th colspan="11">Position FTE less than Funding FTE sum across charts (06)</th>
			</tr>
			<tr>
				<th>Posn</th>
				<th>PsEff</th>
				<th></th>
				<th></th>
				<th></th>
				<th>Empl ID</th>
				<th></th>
				<th>Request FTE</th>
				<th>COA</th>
				<th>Org</th>
				<th>RC</th>
			</tr>
		</thead>
		<tbody>
			<cfset marker = "start">
			<cfoutput>
				<cfloop query="editCheck06">
					<cfif marker neq POSITION_NBR>
						<cfset rowCounter = 1>
						<tr class="positionMark">
					<cfelse>
						<cfif rowCounter % 2 eq 0>
							<tr class="editCheckGray">	
						</cfif>
					</cfif>
						<cfif marker neq POSITION_NBR>
							<td>#POSITION_NBR#</td>
							<td>#POS_FTE#</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						<cfelse>
							<td class="editCheckIndent">#FIN_COA_CD#</td>
							<td>#ACCOUNT_NBR#</td>
							<td>#SUB_ACCT_NBR#</td>
							<td>#FIN_OBJECT_CD#</td>
							<td>#FIN_SUB_OBJ_CD#</td>
							<td>#EMPLID#</td>
							<td>#PERSON_NM#</td>
							<td>#APPT_RQST_FTE_QTY#</td>
							<td>#RPTS_TO_FIN_COA_CD#</td>
							<td>#RPTS_TO_ORG_CD#</td>
							<td>#RC_CD#</td>
						</cfif>
					</tr>
					<cfset rowCounter += 1>
					<cfif #marker# neq #POSITION_NBR#>
						<cfset marker = POSITION_NBR>
					</cfif>
				</cfloop>
			</cfoutput>
		</tbody>
	</table>