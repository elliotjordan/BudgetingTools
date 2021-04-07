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
	
	<pre>
		select a.allfee_id as "DE_Rate", a.inst_cd, a.fee_desc_billing, a.unit_basis, a.fee_current,a.fee_lowyear,
	      round((to_number(a.fee_lowyear)-to_number(a.fee_current))/to_number(a.fee_current),3)*100 as delta_percent,
		  b.base_afid as "Base_Rate", b.asso_desc, b.fn_name, c.param_desc
		from fee_user.afm a
		inner join afm_de_asso b on a.allfee_id = b.de_afid
		inner join afm_params c on b.param_id = c.param_id
		where a.fiscal_year  = '2021' and a.active = 'Y' and c.active = 'Y'
	</pre>
		<hr>

		
		<h5>afm_params</h5>
		<cfdump var="#afm_params#" />
		
		<h5>afm_de_asso</h5>
		<cfdump var="#afm_de_asso#" />
		
	</div>  <!-- End div class="full_content"  -->
</cfoutput>