	<a href="index.cfm">Home</a>
		<!--- NEW --->
		<h3>Create New Requests</h3>
		<table class="recentSettingsTable">
			<thead>
				<tr>
					<th>RC</th>
					<th>Request Title</th>
					<th>Request Amount</th>
					<th>Account Number</th>
					<th>Funding Source</th>
					<th>Justification</th>
					<th>Request Status</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
						<tr>
							<td>
								<select id="rc_select">
									<cfloop array="#sortedRCs#" index="i">
										<cfif application.RCnames[i] neq ''>
											<option value="#i#">#application.RCnames[i]# (RC #i#)</option>
										</cfif>
									</cfloop>
								</select>
							</td> 
							<td><input name="req_desc" type="text" maxlength="128" size="30" width="10" placeholder="Title as you want to see it in reporting..."></input></td>
							<td width="96"><input name="req_amount" type="text" placeholder="Whole dollars, please..." width="40"></input></td>
							<td><select name="acct_select" size="1">
									<cfloop query="currentAccounts">
										<option value="#ACCOUNT_NBR#">#ACCOUNT_NBR#</option>
									</cfloop> 
								</select>
							</td> 
							<td>
								<select name="fund_sel" size="1">
									<option value="base">BASE FUNDING</option>
									<option value="cash">CASH FUNDING</option>
									<option value="either">EITHER</option>
								</select>
								
							</td>
							<td><textarea rows="3" cols="40" placeholder="Please give a link to your original documents in Box..."></textarea></td>
							<td>PENDING</td>
						</tr>
				</cfoutput>
				<input type="hidden" name="REQ_STATUS" value="REQUEST">
			</tbody>
		</table>		
				<div>
					<input id="newRequestSubmitBtn" type="submit" name="newRequestSubmitBtn" class="formBtn" value="Submit Your Funding Request">
				</div>


