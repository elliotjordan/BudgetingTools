		<cfset IUF_data = getIUF_data() />
		<cfset currentIUAccts = getIU_Accts() />
		<cfset currentKEMids = getIUF_KEMIDs() />

		<!--- Matches --->
		<h3>IUF Accounts</h3>
		<table id="IUFtable" class="recentSettingsTable">
			<thead>
				<tr>
					<th>KEM_ID</th>
					<th>KEM_Title</th>
					<th>IU Acct</th>
					<th>IU Acct Name</th>
					<th>Consolidation</th>
					<th>Level</th>
					<th>Begin Bal</th>
					<th>Match</th>
					<th>IUF (Gifts)</th>
					<th>Expense</th>
					<th>End Balance</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfloop query="#IUF_data#">					
				<!---		,, FY, CHART, , , OBJ, , 
 		  OBJ_TYPE, RESTATED_OBJ_TYP, , FIN_SUB_OBJ_CD, FIN_BALANCE_TYP_CD, 
 		  ACTUAL, , , FIN_OBJ_LEVEL_CD, FIN_CONS_OBJ_CD, 
          FIN_CONS_OBJ_NM, 
                --->
						<tr>
							<td>#IUF_KEMID#</td>
							<td>#IUF_KEMID_TITLE#</td>
							<td>#ACCOUNT_NBR#</td>
							<td>#ACCOUNT_NM#</td>
							<td>#OBJ_NAME#</td>
							<td>#FIN_OBJ_LEVEL_NM#</td>
							<td>#DollarFormat(BG)#</td>
							<td>#DollarFormat(IUF_MATCH)#</td>
							<td>#DollarFormat(GIFTS)#</td>
							<td>#DollarFormat(RESTATED_ACTUAL)#</td>
							<td>#DollarFormat(END_BAL)#</td>
						</tr>
					</cfloop>
				</cfoutput>
			</tbody>
		</table>
