<cfset FeeData = getAllV9Fees()>
<cfoutput>
		<h2>Approved Non-instructional Fees</h2>
	 	<cfform action = "downloadExcel.cfm" id = "excelForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque">
	 		<input type="submit" id="submitExcel" name="submitExcel" value="Excel Download">
	 	</cfform>
	<cfset FeeData = getAllV9Fees()>
	 	<cfform action = "fee_rate_update.cfm" id = "AllFeesFormV9" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
	 		timeout = "1200" width = "800" wMode = "opaque">
				<table id="allFeesTableV9" class="allFeesTable">
					<thead>
						<tr>
							<th>Unique ID</th>
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
					<tbody>
						<cfloop query="#FeeData#">
					    		<tr>
					    			<td>#FeeData.ALLFEE_ID# <span><a href="fee_change_request.cfm?ALLFEE_ID=#FeeData.ALLFEE_ID#">Update</a></span></td>
									<td>#FeeData.INST_CD#</td>
									<td>#FeeData.FEE_DESC_BILLING#</td>
									<td>#FeeData.FEE_OWNER# #application.rcNames[FEE_OWNER]#</td>
									<td>#FeeData.FEE_TYP_DESC#</td>
									<td>#FeeData.ACCOUNT_NBR#</td>
									<td>#FeeData.OBJ_CD#</td>
									<td>#FeeData.UNIT_BASIS#</td>
									<td class="right-justify">#DollarFormat(FeeData.fee_current)#</td>
									<td class="right-justify">#DollarFormat(FeeData.fee_lowyear)#</td>
									<td class="right-justify">#DollarFormat(FeeData.fee_highyear)#</td>
									<td>#FeeData.FEE_STATUS#</td>
					    		</tr>
					    		<input type="hidden" name="ALLFEE_ID" value="#FeeData.ALLFEE_ID#">
			    		</cfloop> 
			    	</tbody>
				</table>
		</cfform>
</cfoutput>
