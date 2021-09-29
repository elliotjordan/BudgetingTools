<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
	<!--- Rank by Org Code --->
	<cfoutput>
		<h3>Orgs Ranked by Total Adj Base Budget Amount</h3>
		<table class="allFeesTable" id="orgCodeTable">
			<thead>
				<tr>
					<th width="150">Org Code<br>
						<select name="orgSelect">
							<option value="NONE">-- Select to Filter --</option>
							<cfloop query="distinctOrgs">
								<option value="#org_cd#">#org_cd#</option>
							</cfloop>
						</select>
					</th>
					<th>Org Name<br>
						<select name="orgSelect">
							<option value="NONE">-- Select to Filter --</option>
							<cfloop query="distinctOrgs">
								<option value="#org_cd#">#org_nm#</option>
							</cfloop>
						</select>
					</th>
					<th>Account<br>
						<select name="acctSelect">
							<option value="NONE">-- Select to Filter --</option>
							<cfloop query="distinctAccts">
								<option value="#account_nbr#">#account_nbr#</option>
							</cfloop>
						</select>
					</th>
					<th>Acct Name</th>
					<th>Num. of Accts</th>
					<th>Total</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="#orgRanks#">
						<tr>
							<td>#org_cd#</td>
							<td>#org_nm#</td>
							<td>#account_nbr#</td>
							<td>#account_nm#</td>
							<td>#accounts#</td>
							<td>#DollarFormat(money)#</td> 
						</tr>
				</cfloop>
			</tbody>
		</table>		
	</cfoutput>
</cfif>