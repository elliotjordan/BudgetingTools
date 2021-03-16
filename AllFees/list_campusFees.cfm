<cfif MID(session.access_level,3,2) neq "us">
	<cfset campusFeeData = getAllCampusFees('true', '#MID(session.access_level,3,2)#')>
<cfelse>
	<cfset campusFeeData = getAllCampusFees('true', '')>
</cfif>
<!---<cfset totalCampusCount = campusFeeData.recordCount + camPendFeeData.recordCount>--->
<cfoutput>
		<h2>Campus Fees</h2>
			<!---<p>You currently have a total of #totalCampusCount# campus fees.--->
			<p>Campus fees do not require CFO approval, but are offered here for convenience.  Your requests will appear on a Campus-level page for your Campus Fiscal Officer to view.</p>
	 	<cfform action = "fee_rate_update.cfm" id = "campusFeesForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
	 		timeout = "1200" width = "800" wMode = "opaque" >
				<table id="campusFeesTableV9" class="allFeesTable">
					<thead>
						<tr>
							<th>Unique VID</th>
							<th>Campus</th>
							<th>Fee Description</th>
							<th>Fee Owner</th>
							<th>Fee Type</th>
							<th>Revenue Account</th>
							<th>Object Code</th>
							<th>Unit Basis</th>
							<th>Current<br>FY19 rate</th>
							<th>FY20 Rate</th>
							<th>FY21 Rate</th>
							<th>Fee Status</th>
						</tr>
					</thead>
					<cfif campusFeeData.recordcount lt 1>
						<tbody>
				    		<tr>
						    	<td colspan="12">You currently own no Campus fees.</td>
						    </tr>
					<cfelse>
						<tbody>
							<cfloop query="#campusFeeData#">
						    		<tr>
						    			<td>#campusFeeData.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#campusFeeData.ALLFEE_ID#">Update</a></span></td>
										<td>#campusFeeData.INST_CD#</td>
										<td>#campusFeeData.FEE_DESC_long#</td>
										<td>#campusFeeData.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
										<td>#campusFeeData.FEE_TYP_DESC#</td>
										<td>#campusFeeData.ACCOUNT_NBR#</td>
										<td>#campusFeeData.OBJ_CD#</td>
										<td>#campusFeeData.UNIT_BASIS#</td>
										<td class="right-justify">#DollarFormat(campusFeeData.fee_current)#</td>
										<td class="right-justify">#DollarFormat(campusFeeData.fee_lowyear)#</td>
										<td class="right-justify">#DollarFormat(campusFeeData.fee_highyear)#</td>
										<td>#campusFeeData.FEE_STATUS#</td>
						    		</tr>
				    		</cfloop> 
				    	</tbody>
			    	</cfif>
				</table>
			</cfform>
</cfoutput>