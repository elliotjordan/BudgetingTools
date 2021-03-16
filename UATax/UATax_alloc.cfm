<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
		<cfscript>
			try{
				UATax_alloc = getUATax_allocByUnit();
				distObjLevels = getDistinctObjLevels('2020');
			} catch (any e) {
				WriteOutput("UATax-bug-o-matic: " & e.message);
			}
		</cfscript>
<cfset revConsObjCdList = "STFE,IDIN,OTRE">
<cfset expConsObjCdList = "CMPN,CPTL,GENX,IDEX,SCHL,TRVL,RSRX">
<cfset distObjLevels = getDistinctObjLevels('2020') />

<cfoutput>
<a href="index.cfm">Home</a><br>
<div class="full_content">
<!--- Base Items --->
	<h2>Allocated July 1 Budgets By UA Reporting Unit  FY2020</h2>
	<p>This chart is designed to expand the revenue subsidy column to show funding sources.</p>
	<div class="code_group">
		Show/Hide columns: 
		<a class="toggle_vis rc_bgcolor" data-column="0">RC</a>
		<a class="toggle_vis rc_bgcolor" data-column="1">NAME</a>
		<a class="toggle_vis revenue_green" data-column="2">STFE</a>
		<a class="toggle_vis revenue_green" data-column="3">IDIN</a>
		<a class="toggle_vis revenue_green" data-column="4">OTRE</a>
		<a class="toggle_vis subTotal_white" data-column="5">REV SUB-TOTAL</a>
		<a class="toggle_vis expense_red" data-column="6">CMPN</a>
		<a class="toggle_vis expense_red" data-column="7">CPTL</a>
		<a class="toggle_vis expense_red" data-column="8">GENX</a>
		<a class="toggle_vis expense_red" data-column="9">IDEX</a>
		<a class="toggle_vis expense_red" data-column="10">SCHL</a>
		<a class="toggle_vis expense_red" data-column="11">TRVL</a>
		<a class="toggle_vis expense_red" data-column="12">RSRX</a>
		<a class="toggle_vis subTotal_white" data-column="13">EXP SUB-TOTAL</a>
		<a class="toggle_vis support_blue" data-column="14">UA SUPPORT</a>
		<a class="toggle_vis percent_purple" data-column="15">% TOTAL EXP</a>
		<a class="toggle_vis percent_purple" data-column="16">RATIO</a>
	</div>
	<table id="uaTaxSummaryTable" class="summaryTable">
		<colgroup>
			<col class="narrow"><col class="wide"><col><col><col><col class="medium"><col><col><col><col><col><col><col><col class="medium"><col class="medium"><col class="medium"><col class="medium">
		</colgroup>
		<thead>
			<tr>
				<th class="narrow">RC</th>
				<th class="wide">RC<br>Name</th>
				<th class="medium">Fee<br>Revenue<br>(STFE)</th>
				<th class="medium">ICR<br>Revenue<br>(IDIN)</th>
				<th class="medium">Other<br>Revenue<br>(OTRE)</th>
				<th class="medium">REVENUE<br>SUB-TOTAL</th>
				<th class="medium">Compensation<br>(CMPN)</th>
				<th class="medium">Capital<br>Expense<br>(CPTL)</th>
				<th class="medium">General<br>Expense<br>(GENX)</th>
				<th class="medium">ICR<br>Expense<br>(IDEX)</th>
				<th class="medium">Financial<br>Aid<br>(SCHL)</th>
				<th class="medium">Travel<br>Expenses<br>(TRVL)</th>
				<th class="medium">Reserves<br>(RSRX)</th>
				<th class="medium">EXPENSE<br>SUB-TOTAL</th>
				<th class="medium">UA Support</th>
				<th class="petite">% of<br>Total Expense</th>
				<th class="petite">Rev / Exp<br> Ratio</th>
			</tr>
		</thead>
		<tbody>
				<cfif UATax_alloc.recordCount eq 0>
					<tr>
						<td colspan="100%" style="border:1px solid black">No UA Assessment requests are pending at this time.</td>
					</tr
				</cfif>
<!---				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
--->	
			<!--- Worth looking at this data source and the query behind it.  The ROLLUP function creates null rows with row sub-totals.  --->
				<!--- We leverage the nulls as a sort of side effect to format the table within the loops below. --->
				<cfloop query="#UATax_alloc#">
					<cfif LEN(RC_NM) gt 0>
						<cfif rc_cd eq '86'><cfset rc_relabel = 'VP DIVERSITY, EQUITY & MULTICULTURAL AFFAIRS'><cfelse><cfset rc_relabel = rc_nm></cfif>
						<tr>
							<td class="narrow">#RC_CD#</td>
							<td class="wide"><span class="tiny-black">#rc_relabel#</span></td>
						 	<cfloop list="#revConsObjCdList#" index="i">
								<cfset desiredColumn = i & "_SUM2">     <!--- "_SUM2" naming convention used in getUATax_allocByUnit() query  --->
								<cfloop array = "#UATax_alloc.getColumnList()#" index = "columnName">
								  	<cfif desiredColumn eq columnName>
										<td class="revenue_green medium">
											<!---<b>#desiredColumn#</b>--->    <!--- Leave this for debugging  --->
											<cfif UATax_alloc[columnName][currentRow] gt 0>
												<cfset btnID = "myBtn" & #UATax_alloc.rowID#>
							<a href="UATax_detail.cfm?uatRC=#RC_CD#&uatObjCon=#i#">
								<input id="#btnID#" type="button" value="#NumberFormat(UATax_alloc[columnName][currentRow])#" />
								<!---<span id="#btnID#">#NumberFormat(UATax_alloc[columnName][currentRow])#</span>--->
							</a>
							<!---<cfinclude template="UATax_alloc_modal.cfm">--->  <!--- Removed as too cluttered, save line for reference  --->
											<cfelse>
												#NumberFormat(UATax_alloc[columnName][currentRow])#
											</cfif>
										</td>
									</cfif>
								</cfloop>
						  	</cfloop>
							<td class="medium">#NumberFormat(TOTAL_REVENUE2)#</td>

						 	<cfloop list="#expConsObjCdList#" index="j">
								<cfset desiredColumn = j & "_SUM2">     <!--- "_SUM2" naming convention used in getUATax_allocByUnit() query  --->
								<cfloop array = "#UATax_alloc.getColumnList()#" index = "columnName">
								  	<cfif desiredColumn eq columnName>
										<td class="expense_red medium">
											<!---<b>#desiredColumn#</b>--->    <!--- Leave this for debugging  --->
											<cfif UATax_alloc[columnName][currentRow] gt 0>
												<cfset btnID = "myBtn" & #UATax_alloc.rowID#>
							<a href="UATax_detail.cfm?uatRC=#RC_CD#&uatObjCon=#j#">
								<input id="#btnID#" type="button" value="#NumberFormat(UATax_alloc[columnName][currentRow])#" />
								<!---<span id="#btnID#">#NumberFormat(UATax_alloc[columnName][currentRow])#</span>--->
							</a>
							<!---<cfinclude template="UATax_alloc_modal.cfm">--->  <!--- Removed as too cluttered, save line for reference  --->
											<cfelse>
												#NumberFormat(UATax_alloc[columnName][currentRow])#
											</cfif>
										</td>
									</cfif>
								</cfloop>
						  	</cfloop>
							<td class="medium">#NumberFormat(TOTAL_EXPENSE2)#</td>
							<td class="support_blue medium">#NumberFormat(UA_SUPPORT2)#</td>
							<td class="percent_purple petite"> #ROUND(UA_EXP_PCT2*1000)/10#%</td>
							<td class="percent_purple petite"> #ROUND(UA_REV_PCT2*1000)/10#%</td>
						</tr>
					<cfelseif LEN(RC_CD) eq 0>
					    <tr class="subTotal_white medium">
							<td class="narrow"> - </td>
							<td class="editCheckIndent wide">TOTAL:</td>
							<td class="medium">#NumberFormat(STFE_SUM2)#</td>
							<td class="medium">#NumberFormat(IDIN_SUM2)#</td>
							<td class="medium">#NumberFormat(OTRE_SUM2)#</td>
							<td class="medium">#NumberFormat(TOTAL_REVENUE2)#</td>
							<td class="medium">#NumberFormat(CMPN_SUM2)#</td>
							<td class="medium">#NumberFormat(CPTL_SUM2)#</td>
							<td class="medium">#NumberFormat(GENX_SUM2)#</td>
							<td class="medium">#NumberFormat(IDEX_SUM2)#</td>
							<td class="medium">#NumberFormat(SCHL_SUM2)#</td>
							<td class="medium">#NumberFormat(TRVL_SUM2)#</td>
							<td class="medium">#NumberFormat(RSRX_SUM2)#</td>
							<td class="medium">#NumberFormat(TOTAL_EXPENSE2)#</td>
							<td class="medium">#NumberFormat(UA_SUPPORT2)#</td>
							<td class="petite">--</td>
							<td class="petite">--</td>
					    </tr>
					</cfif>
				</cfloop>
		</tbody>
	</table>
</div>   <!-- End div class full_content  -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">