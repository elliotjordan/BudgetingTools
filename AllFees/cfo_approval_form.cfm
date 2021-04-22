<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>
<cfset setid = "IU" & MID(session.curr_proj_chart,1,2) & "A">
<cfset role = 'user'>
	<cfif REQUEST.authUser neq imposter AND FindNoCase("campus_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'campus'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("regional_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'regional'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("bursar_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'bursar'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("fee_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'ubo'>
	<cfelseif REQUEST.authUser neq imposter AND FindNoCase("cfo_controls",cgi.SCRIPT_NAME)>
		<cfset role = 'cfo'>
	</cfif>	

<cfset al = getApprovalList("cfo",setid) />
<cfoutput>
	<cfif REQUEST.authUser eq 'blork'>
		<h2>#REQUEST.authUser# - #imposter# - #ROLE# - #cgi.SCRIPT_NAME#</h2>
	</cfif>
	<cfif al.recordCount gt 1>
		<span class="cfofilterBox">
			<button id="newFeeBtn" class="filterBtn newFeeOff" onclick="newFeeBtn()">Show Only New Fees</button>
		</span>

		<!-- Begin approval form for rows with requests outside the guideline -->
		<h2>Fee Requests Exceeding the Guideline</h2>
	 	<cfform action = "approval_submit.cfm" id = "approvalForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque" >
			<table id="allFeesTableV9" class="approvalTable">
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
								<input type="checkbox" id="approve_all_cb" name="special_approve_all_cb" onchange="blanketApproval_over2pct()">
								<label for="approve_all_cb">Approve All</label>
							</span></th>
					</tr>
				</thead>
				<tbody>
					<cfif al.recordCount lt 1>
				    		<tr>
						    	<td colspan="12">You currently have no fee submissions to review.</td>
						    </tr>
					<cfelse>
						<cfloop query="#al#">
							<cfif al.CY_NUM neq 0>
								<cfset FY20_pct = NumberFormat( ((al.LY_NUM - al.CY_NUM)/al.CY_NUM)*100, "99.99")>
							<cfelse>
								<cfset FY20_pct = "--">
							</cfif>
							<cfif al.LY_NUM neq 0>
								<cfset FY21_pct = NumberFormat( ((al.HY_NUM - al.LY_NUM)/al.LY_NUM)*100, "99.99")>
							<cfelse>
								<cfset FY21_pct = "--">
							</cfif>
							<cfif FY20_pct gt 2.00 OR FY21_pct gt 2.00>	<cfset tr_string = '<tr name="overage"'>
							<cfif al.FEE_BEGIN_TERM gt application.current_term><cfset tr_string = tr_string & ' class="newFee">'> <cfelse> <cfset tr_string = tr_string & '>'> </cfif>
							#tr_string#
				    			<td>#al.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#al.ALLFEE_ID#&PRESERVE_STATUS=true">Update</a></span></td>
								<cfif role neq 'campus'>
									<td>#al.INST_CD#</td>
								</cfif>
								<td>#al.FEE_DESC_BILLING#</td>
								<td>#al.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
								<td>#al.FEE_TYPE#</td>
								<td>#DollarFormat(al.CY_NUM)#</td>
								<td>
									YR1: #DollarFormat(al.LY_NUM)# 
									<cfif FY20_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY20_pct# %)</span><br> 
									YR 2: #DollarFormat(al.HY_NUM)# 
									<cfif FY21_pct gt 2.00>
										<span class="overage pct_inc">
									<cfelse>
						    			<span class="pct_inc">
						    		</cfif>(#FY21_pct# %)</span></td>
								<td>#al.FEE_BEGIN_TERM#</td>
								<td>
									#al.FEE_STATUS#
									<cfset modalText = setModalText(al.NEED_FOR_FEE,al.FURTHER_JUSTIFY,al.ALLFEE_ID)>
									<img id="#al.ALLFEE_ID#Icon" src="../images/justification_icon.png" width="18" height="18" alt="Icon for justification documentation" onclick="justifyModal('#al.ALLFEE_ID#Modal','#al.ALLFEE_ID#Icon','#al.ALLFEE_ID#closeX')">#MID(modalText,1,16)#
									  <div id="#al.ALLFEE_ID#Modal" class="modal">
									  	<div class="modal-content">
									  		<span id="#al.ALLFEE_ID#closeX" class="closeX">&times;</span>
									  		<p>#modalText#</p>
									  	</div>
									  </div>
								</td>
								<td>
									<select id="approval_select" name="FEE_STATUS" class="special_FEE_STATUS" onchange="approvalButton()">
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
								<input type="hidden" name="ALLFEE_ID" value="#al.ALLFEE_ID#" />
				    		</tr>
				    	</cfif>
			    		</cfloop> 
					</cfif>
		    	</tbody>
			</table>
			<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
			<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
			<input id="SubmitBtn4" type="submit" name="Submit" value="Submit Approvals" disabled />

			<!--- EVERYTHING AT OR UNDER 2% --->
			<h2>Fee Requests At or Under the Guideline</h2>
			<cfset tr_string2 = '<tr name="feeRow"'>
			<cfif FY20_pct gt 2.00 OR FY21_pct gt 2.00>	<cfset tr_string = '<tr name="overage"'></cfif>			
			<table id="cfoApprovalTableUnder2Pct" class="approvalTable">
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
									<input type="checkbox" id="approve_all_cb" name="cfo_approve_all_cb" onchange="blanketApproval_under_2pct()">
									<label for="approve_all_cb">Approve All</label>
								</span></th>
						</tr>
					</thead>
					<tbody>
						<cfif al.recordCount lt 1>
					    		<tr>
							    	<td colspan="12">You currently have no fee submissions to review.</td>
							    </tr>
						<cfelse>
							<cfloop query="#al#">
								<cfif al.CY_NUM neq 0>
									<cfset FY20_pct = NumberFormat( ((al.LY_NUM - al.CY_NUM)/al.CY_NUM)*100, "99.99")>
								<cfelse>
									<cfset FY20_pct = "--">
								</cfif>
								<cfif al.LY_NUM neq 0>
									<cfset FY21_pct = NumberFormat( ((al.HY_NUM - al.LY_NUM)/al.LY_NUM)*100, "99.99")>
								<cfelse>
									<cfset FY21_pct = "--">
								</cfif>
								<cfif FY20_pct lte 2.00 AND FY21_pct lte 2.00>	<cfset tr_string = '<tr name="feeRow2"'>
								<cfif al.FEE_BEGIN_TERM gt application.current_term><cfset tr_string = tr_string & ' class="newFee">'> <cfelse> <cfset tr_string = tr_string & ' class="oldFee">'> </cfif>
								#tr_string#
					    			<td>#al.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#al.ALLFEE_ID#">Update</a></span></td>
									<cfif role neq 'campus'>
										<td>#al.INST_CD#</td>
									</cfif>
									<td>#al.FEE_DESC_BILLING#</td>
									<td>#al.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
									<td>#al.FEE_TYPE#</td>
									<td>#DollarFormat(al.CY_NUM)#</td>
									<td>
										YR1: #DollarFormat(al.LY_NUM)# 
										<cfif FY20_pct gt 2.00>
											<span class="overage pct_inc">
										<cfelse>
							    			<span class="pct_inc">
							    		</cfif>(#FY20_pct# %)</span><br> 
										YR 2: #DollarFormat(al.HY_NUM)# 
										<cfif FY21_pct gt 2.00>
											<span class="overage pct_inc">
										<cfelse>
							    			<span class="pct_inc">
							    		</cfif>(#FY21_pct# %)</span></td>
									<td>#al.FEE_BEGIN_TERM#</td>
									<td>#al.FEE_STATUS#</td>
									<td>
										<select id="approval_select" name="fee_status" class="under_FEE_STATUS" onchange="approvalButton()">
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
									<input type="hidden" name="ALLFEE_ID" value="#al.ALLFEE_ID#" />
					    		</tr>
					    	</cfif>
				    		</cfloop> 
						</cfif>
			    	</tbody>
				</table>
				<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
				<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
				<input id="SubmitBtn5" type="submit" name="Submit" value="Submit Approvals" />
			</cfform>
		<cfelse>
			<h2>No Approvals Remaining</h2>
			<p>The approvals list query returned no records requiring attention.
		</cfif>
</cfoutput>