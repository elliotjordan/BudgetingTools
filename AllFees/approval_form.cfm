<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<cfset roleFeestatus = getDistinctFeeStatus() />
<cfset setid = "IU" & MID(session.curr_proj_chart,1,2) & "A">

	<cfscript>
		roleList = 'regional,bursar,ubo,cfo';
		role = 'NONE';
	</cfscript>
	
<cfset approvalList = getApprovalList(role,setid) />

<cfoutput>
	<cfif REQUEST.authUser eq 'blork'>
		<h2>#REQUEST.authUser# - #imposter# - #ROLE# - #cgi.SCRIPT_NAME#</h2>
	</cfif>
<!---	<cfif approvalList.recordCount gt 1>
		<span class="filterBox">
			<button id="twoPctBtn" class="filterBtn twopctOff" onclick="twoPctBtn()">Show Changed Rates</button>
			<button id="newFeeBtn" class="filterBtn newFeeOff" onclick="newFeeBtn("oldFee")">Show Only New Fees</button>
		</span>
	</cfif>--->
	<!-- Begin Fee Request form -->
	 	<form action = "approval_submit.cfm" id = "approvalForm" method = "POST" />
	 		<input id="approvalSubmit" type="submit" value="Update" />
			<table id="approvalTable" class="approvalTable">
				<thead>
					<tr class="newFee">
						<th><span class="sm-blue">Unique ID</span></th>
						<cfif role neq 'campus'>
							<th><span class="sm-blue">Campus</span></th>
						</cfif>
						<th><span class="sm-blue">Fee Description</span></th>
						<th><span class="sm-blue">Owner</span></th>
						<th><span class="sm-blue">Fee Type</span></th>
						<th><span class="sm-blue">Current #application.fiscalyear# Rate</span></th>
						<th><span class="sm-blue">Proposed<br>rates</span></th>
						<!---<th><span class="sm-blue">Fee Begin Term</span></th>--->
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
<!---
						<cfif (role eq 'campus' and approvalList.fee_type neq 'CMP') OR ListFindNoCase(roleList, role)> --->
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
				    			<td>#approvalList.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#approvalList.ALLFEE_ID#&PRESERVE_STATUS=true">Update</a></span></td>
								<cfif role neq 'campus'>
									<td>#approvalList.INST_CD#</td>
								</cfif>
								<td>#approvalList.FEE_DESC_BILLING#</td>
								<td>#approvalList.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
								<td>#approvalList.FEE_TYPE#</td>
								<td>#DollarFormat(approvalList.CY_NUM)#</td>
								<td>
									#application.firstyear#: <b>#DollarFormat(approvalList.LY_NUM)#</b><br>
									<cfif FY20_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY20_pct# %)</span><br>
									#application.secondyear#: <b>#DollarFormat(approvalList.HY_NUM)#</b><br>
									<cfif FY21_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY21_pct# %)</span></td>
								<!---<td>#approvalList.FEE_BEGIN_TERM#</td>--->
								<td>#approvalList.FEE_STATUS#</td>
								<td>
					<select id="approval_select" name="FEE_STATUS" class="approval_dropdown" onchange="approvalButton()">
				  		<cfloop list="#roleFeestatus[LCase(role)]#" index="fs">
				  			<option value="#fs#" <cfif LCase(approvalList.FEE_STATUS) eq LCase(fs)>selected</cfif>>#fs#</option>
				  		</cfloop>
					</select>
								</td>
								<input type="hidden" name="ALLFEE_ID" value="#approvalList.ALLFEE_ID#" />
				    		</tr>
			    		<!---</cfif>--->
			    		</cfloop>
					</cfif>
		    	</tbody>
			</table>
			<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
			<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
			<input id="SubmitBtn4" type="submit" name="Submit" value="Submit Approvals" disabled />
		</form>

<!---<cfif role eq 'campus'>
	<cfinclude template="list_campusApprovals.cfm">
</cfif>--->
</cfoutput>