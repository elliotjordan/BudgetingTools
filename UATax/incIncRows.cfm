<cfinclude template="../includes/header_footer/UATax_header.cfm">
<cfinclude template="../includes/functions/UATax_functions.cfm">

<cfoutput>
	<cfset incInc_data = initIncIncRows() />
	
	<!---<cfdump var="#incInc_data#" >--->
	<!--- FIN_COA_CD, ACCOUNT_NBR, SUB_ACCT_NBR, FIN_OBJECT_CD, 
  FIN_SUB_OBJ_CD, ADJ_BASE_AMT, BDGT_PROJ_AMT, (ADJ_BASE_AMT - BDGT_PROJ_AMT) as "delta",
  Iu_Acct_Shr_Srvcs_Cd, Rc_Cd, Rc_Nm --->
	<!--- Completed Approvals --->
		<h3>IncInc Data (#incInc_data.recordCount# Rows)</h3>
		<table id="incIncDataTable" class="statusTable">
			<thead>
				<tr>		  
					<th>Campus</th>
					<th>Account</th>
					<th>Sub-account</th>
					<th>Object Code</th>
					<th>Sub-object Code</th>
					<th>Adj Base 2018</th>
					<th>Proj Amount</th>
					<th>Delta</th>
					<th>Shared Svc</th>
					<th>RC</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfloop query="#incInc_data#">
							<tr>
								<td>#FIN_COA_CD#</td>
								<td>#ACCOUNT_NBR#</td>
								<td>#SUB_ACCT_NBR#</td>
								<td>#FIN_OBJECT_CD#</td>
								<td>#FIN_SUB_OBJ_CD#</td>
								<td>#DollarFormat(ADJ_BASE_AMT)#</td> 
								<td>#DollarFormat(BDGT_PROJ_AMT)#</td>
								<td>#DollarFormat(delta)#</td>
								<td>#Iu_Acct_Shr_Srvcs_Cd#</td>
								<td>#RC_NM# - (#RC_CD#)</td>
							</tr>
					</cfloop>
				</cfoutput>
			</tbody>
		</table>		
</cfoutput>

<cfinclude template="../includes/header_footer/UATax_footer.cfm">
