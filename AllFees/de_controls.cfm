<cfset fee_params = getFeeParamData() />
<cfset afm_de_asso = getAFM_DE_asso() />
<cfset afm_params = getAFMparams() />
<cfset delta = getDEchangeReport() />
<cfoutput>
	<div class="full_content">
		<!---<cfdump var="#delta#" >--->

		<table class="feeCodeTable">
			<thead>
				<tr>
					<th>DE AllfeeID</th>
					<th>Fee</th>
					<th>Base AllFeeID</th>
					<th>Current YR</th>
					<th>1st YR</th>
					<th>%Change</th>
					<th>Association</th>
					<th>Notes</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="#delta#">
				<tr>
					<td>#DE_Rate#</td>
					<td>
						<span class="sm-blue">#inst_cd#</span><br>
						#fee_desc_billing#
					</td>
					<td>#Base_rate#</td>
					<td>#fee_current#</td>
					<td>#fee_lowyear#</td>
					<td>#delta_percent#</td>
					<td>
						<span class="sm-blue">#fn_name#</span><br>
						#asso_desc#
					</td>
					<td>#param_desc#</td>
				</tr>
				</cfloop>

			</tbody>
		</table>
	
		<hr>

		
		<h5>afm_params</h5>
		<cfdump var="#afm_params#" />
		
		<h5>afm_de_asso</h5>
		<cfdump var="#afm_de_asso#" />
		
		<h5>JOIN result</h5>	
		<cfdump var="#fee_params#" />
	</div>  <!-- End div class="full_content"  -->
</cfoutput>