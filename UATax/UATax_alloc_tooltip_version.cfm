	<a href="index.cfm">Home</a>

	<cfset distObjLevels = getDistinctObjLevels('2020') />
	<!---<cfdump var="#distObjLevels#" >--->
	<cfoutput>
	<div class="full_content">
	<!--- Base Items --->
		<h2>Allocated July 1 Budgets By UA Reporting Unit  FY2020</h2>
		<p>This chart is designed to expand the revenue subsidy column to show funding sources.</p>
		<table class="summaryTable">
			<thead>
				<tr>
					<th>RC</th>
					<th>RC Name</th>
					<th>Student Fee Revenue<br>(STFE)</th>
					<th>ICR Revenue<br>(IDIN)</th>
					<th>Other Revenue<br>(OTRE)</th>
					<th>REVENUE SUB-TOTAL</th>
					<th>Compensation<br>(CMPN)</th>
					<th>Capital Expense<br>(CPTL)</th>
					<th>General Expense<br>(GENX)</th>
					<th>ICR Expense<br>(IDEX)</th>
					<th>Financial Aid<br>Expense<br>(SCHL)</th>
					<th>Travel Expenses<br>(TRVL)</th>
					<th>Reserves<br>(RSRX)</th>
					<th>EXPENSE SUB-TOTAL</th>
					<th>UA Support</th>
					<th>% of Total Expense</th>
					<th>Rev / Exp Ratio</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfif UATax_alloc.recordCount eq 0>
						<tr>
							<td colspan="100%" style="border:1px solid black">No UA Assessment requests are pending at this time.</td>
						</tr
					</cfif>
					<!--- <cfdump var="#UATax_alloc#" ><cfabort> --->  
					<!--- Worth looking at this data source and the query behind it.  The ROLLUP function creates null rows with row sub-totals.  --->
					<!--- We leverage the nulls as a sort of side effect to format the table within the loops below. --->
					<cfloop query="#UATax_alloc#">
						<cfif LEN(RC_NM) gt 0>
							<tr>
								<td>#RC_CD#</td>
								<td>#RC_NM#</td>
								<td class="revenue_green">
									<div class="tooltip3">#NumberFormat(STFE_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'STFE'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'STFE' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div> 
								</td>
								<td class="revenue_green">
									<div class="tooltip3">#NumberFormat(IDIN_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'IDIN'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'IDIN' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div> 
								</td>
								<td class="revenue_green">
									<div class="tooltip3">#NumberFormat(OTRE_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'OTRE'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'OTRE' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td>#NumberFormat(TOTAL_REVENUE2)#</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(CMPN_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'CMPN'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'CMPN' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>												
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(CPTL_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'CPTL'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'CPTL' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(GENX_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'GENX'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'GENX' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(IDEX_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'IDEX'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'IDEX' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(SCHL_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'SCHL'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'SCHL' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(TRVL_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'TRVL'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'TRVL' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td class="expense_red">
									<div class="tooltip3">#NumberFormat(RSRX_SUM2)#
										<cfloop query="#distObjLevels#">
											<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq 'RSRX'> 
												<span class="tooltiptext">
													<cfscript>
														for (distObjLevel in distObjLevels) {
															if (UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevel.FIN_CONS_OBJ_CD eq 'RSRX' AND distObjLevel.OBJ_LVL_SUM neq '0') {
																writeOutput("#distObjLevels.FIN_OBJ_LEVEL_CD#  $#NumberFormat(OBJ_LVL_SUM)#");
																break;
															}
													    }
													</cfscript>
												</span>
											</cfif>
										</cfloop>
									</div>					
								</td>
								<td>#NumberFormat(TOTAL_EXPENSE2)#</td>
								<td class="support_blue">#NumberFormat(UA_SUPPORT2)#</td>
								<td class="percent_purple">#ROUND(UA_EXP_PCT2*1000)/10#%</td>
								<td class="percent_purple">#ROUND(UA_REV_PCT2*1000)/10#%</td>
							</tr>
						<cfelseif LEN(RC_CD) eq 0>
						    <tr class="subTotal_white">
								<td> - </td>
								<td class="editCheckIndent">TOTAL:</td>
								<td>#NumberFormat(STFE_SUM2)#</td>
								<td>#NumberFormat(IDIN_SUM2)#</td>
								<td class="">#NumberFormat(OTRE_SUM2)#</td>
								<td>#NumberFormat(TOTAL_REVENUE2)#</td>
								<td>#NumberFormat(CMPN_SUM2)#</td>
								<td>#NumberFormat(CPTL_SUM2)#</td>
								<td>#NumberFormat(GENX_SUM2)#</td>
								<td>#NumberFormat(IDEX_SUM2)#</td>
								<td>#NumberFormat(SCHL_SUM2)#</td>
								<td>#NumberFormat(TRVL_SUM2)#</td>
								<td>#NumberFormat(RSRX_SUM2)#</td>
								<td>#NumberFormat(TOTAL_EXPENSE2)#</td>
								<td>#NumberFormat(UA_SUPPORT2)#</td>
								<td></td>
								<td></td>
						    </tr>
						</cfif>
					</cfloop>
				</cfoutput>
			</tbody>
		</table>
	</DIV>   <!-- End div class full_content  -->
	</cfoutput>