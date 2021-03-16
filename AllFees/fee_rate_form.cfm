<!-- Begin fee rate form -->
	<cfoutput>
<!---		<div class="customBtn">
		    <button id="clearFilter" class="button">Clear All Filters</button>
		</div>--->
	 	<cfform action = "fee_rate_update.cfm" id = "AllFeesForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
	 		timeout = "1200" width = "800" wMode = "opaque" >
		
			<!---<input type="submit" name="feeRateSubmitBtn">--->
				<table id="allFeesTable" class="allFeesTable">
					<thead>
						<tr>
							<th><span class="sm-blue">All Fee ID</span><br>Unique ID</th>
							<th><span class="sm-blue">IU</span><br>Campus</th>
							<!---<th><span>RC</span><br>RC</th>--->
							<th><span class="sm-blue">Registrar</span><br>Fee Description</th>
							<th><span class="sm-blue">Official</span><br>Owner</th>
							<th><span class="sm-blue">SIS</span><br>Course</th>
							<th><span class="sm-blue">ADM, CLS, CRS, CMP, PRE</span><br>Fee Type</th>
							<th><span class="sm-blue">Chart of Accounts</span><br>Object Code</th>
							<th><span class="sm-blue">Annual, Semester, per unit</span><br>Unit Basis</th>
							<!---<th><span class="sm-blue">Approved</span><br>2018 rate</th>--->
							<th><span class="sm-blue">Approved</span><br>2019 rate</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#FeeData#">
					    		<tr>
					    			<td>
					    				<cfif FeeData.ALLFEE_MASTERID neq ''>
					    					<span class="sm-blue">MasterID: #FeeData.ALLFEE_MASTERID#</span><br>
					    				</cfif>
					    				#FeeData.ALLFEE_ID#
					    			</td>
									<td>#FeeData.INST_CD#</td>
									<!---<td>#FeeData.rcdesc#</td>--->
									<td>#FeeData.fee_desc_long#</td>
									<td>#FeeData.fee_owner#</td>
									<td>#FeeData.crs_nbr# - #FeeData.course_desc#</td>
									<td>#FeeData.fee_type#</td>
									<td>#FeeData.obj_cd#</td>
									<td>#FeeData.unit_basis#</td>
									<td>#FeeData.fee_current#</td>
					    		</tr>
			    		</cfloop> 
			    	</tbody>
				</table>
			<!--- Add a submit button --->
			<input id="SubmitBtn2" type="submit" name="Submit" value="Submit" disabled />
			<label for="SubmitBtn2">Submit your changes.</label>
		</cfform>
	</cfoutput>