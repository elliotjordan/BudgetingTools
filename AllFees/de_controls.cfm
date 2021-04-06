<cfset fee_params = getFeeParamData() />
<cfset afm_de_asso = getAFM_DE_asso() />
<cfset afm_params = getAFMparams() />

<cfoutput>
	<pre>
		select a.allfee_id, a.fiscal_year, a.inst_cd, a.fee_desc_billing, a.unit_basis, a.fee_current,
		  b.asso_desc, b.fn_name, c.param_desc
		from fee_user.afm a
		inner join afm_de_asso b on a.allfee_id = b.de_afid
		inner join afm_params c on b.param_id = c.param_id
		where a.fiscal_year  = '2021' and a.active = 'Y' and c.active = 'Y'
	</pre>
	
	<h5>afm_de_asso</h5>
	<cfdump var="#afm_de_asso#" />
	
	<h5>afm_params</h5>
	<cfdump var="#afm_params#" />
	
	<h5>JOIN result</h5>	
	<cfdump var="#fee_params#" />
</cfoutput>