<cfoutput>
	
<cfif IsDefined("form") AND StructKeyExists(form,"de_btn")>
	<cfset insertAsso = false />
	<cfif IsDefined("form") AND StructKeyExists(form,"NEW_DE_AFID") and StructKeyExists(form,"NEW_DE_ASSO") AND form.new_de_asso neq 'NONE' AND form.NEW_DE_AFID neq 'NONE'>
		<cfset insertAsso = insertNewAsso(form.new_base_afid, form.new_de_afid, LSParseNumber(form.new_de_asso)) />
	</cfif>
	<cflocation url="fee_controls.cfm" addtoken="false" />
</cfif>

	<div class="full_content">
		<!---<cfdump var="#delta#" >--->
		<form id="de_form" name="de_form" action="fee_controls.cfm" method="post" >
			<input id="de_btn" name="de_btn" type="submit" value="Save DE Changes">
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
						<th>Rule Selector</th>
						<th>Notes</th>
					</tr>
				</thead>
				<tbody>
					<tr class="new_entry">
						<td colspan="3">
							<label for="new_allfee_ID"><i>Current tuition and program fees</i></label>
							<select id="new_base_ID" name="new_base_afid">
								<option value="NONE"><i>Select base fee</i></option>
								<option value="NO BASE FEE"><i>No Base Fee Associated</i></option>
								<cfloop query="tuitionList">
									<option value="#allfee_id#">#allfee_id# - #fee_desc_billing#</option>
								</cfloop>
							</select>
						</td>
						<td colspan="3">
							<label for="param_selector"><i>Un-associated DE fees</i></label>
							<select id="new_DE_ID" name="new_de_afid">
								<option value="NONE"><i>Select DE fee to associate</i></option>
								<cfloop query="unAssDE">
									<option value="#allfee_id#">#allfee_id# - #fee_desc_billing#</option>
								</cfloop>
							</select>
						</td>
						<td colspan="1">
							<label for="asso_selector"><i>Rule list</i></label>
							<select id="asso_selector" name="new_de_asso">
								<cfif unassDE.recordCount eq 0>
									<span id="noAssNeeded">No active DE fees remain to associate. All are defined below.</span>
								<cfelse>
									<option value="NONE"><i>Select Rule</i></option>
									<cfloop query="afm_params">
										<option value="#param_id#">#param_id# - #param_nm#</option>
									</cfloop>
								</cfif>
							</select>
						</td>
						<td colspan="2">
							<label for="new_DE_asso_note"><i>Reference notes</i></label><br>
							<input name="new_DE_asso_note" type="text" placeholder="Notes" width="100%" size="90"></input>
						</td>
					</tr>
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
						<td>
							<select id="param_selector" name="param_#delta.DE_Rate#">
								<cfloop query="afm_params">
									<cfif delta.param_id eq afm_params.param_id>
										<option value="#param_id#" name="de_param_option" selected="selected">#param_id# - #param_nm#</option>
									<cfelse>
										<option value="#param_id#" name="de_param_option">&##128139; #param_id# - #param_nm#</option>
									</cfif>
								</cfloop>
							</select>
						</td>
						<td>#param_desc#</td>
					</tr>
					</cfloop>
	
				</tbody>
			</table>
		</form>
	
	<hr>
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
		
	</div>  <!-- End div class="full_content"  -->
</cfoutput>