<cffunction name="getFYMcomments">
	<cfquery datasource="#application.datasource#" name="commentList">
		SELECT oid, comment from fym_comments
	</cfquery>
</cffunction>

<cffunction name="getDistinctChartDesc">
	<cfargument name="givenChart" required="true" />
	<cfquery datasource="#application.datasource#" name="currentChartDesc">
		SELECT DISTINCT chart_desc FROM fee_user.fym_data
		WHERE chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
	</cfquery>
	<cfreturn currentChartDesc.chart_desc />
</cffunction>

<cffunction name="getFYMparams">
	<cfquery name="getParms" datasource="#application.datasource#">
		select OID, chart_cd, ln1_cd, ln2_cd, ln1_desc, ln2_desc, cur_yr_new, yr1_new,
		yr2_new, yr3_new, yr4_new, yr5_new , ln_sort, grp1_cd, grp2_cd
		from fym_data WHERE grp1_cd = 0 ORDER BY chart_cd ASC, grp1_cd ASC, grp2_cd ASC,ln_sort ASC
	</cfquery>
	<cfreturn getParms>
</cffunction>

<cffunction name="getSpecificFYMparam">
	<cfargument name="givenChart" required="true" type="string" />
	<cfargument name="givenLn1Cd" required="true" type="string" />
	<cfargument name="givenLn2Cd" required="true" type="string" />
	<cfquery name="getParms" datasource="#application.datasource#">
		select OID, grp1_desc, ln1_desc, ln2_desc, cur_yr_old, cur_yr_new, yr1_new, yr2_new, yr3_new, yr4_new, yr5_new
		from fym_data
		where cur_fis_yr = '2021' and grp1_cd = 0
		and chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
		and ln1_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenLn1Cd#">
		and ln2_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenLn2Cd#">
	</cfquery>
	<cfreturn getParms>
</cffunction>

<cffunction name="updatenumParam">
	<cfquery name="doTheThing" datasource="#application.datasource#">
		select * from fee_user.update_num_param()
	</cfquery>
</cffunction>

<cffunction name="updateExp">
	<!---<cfargument name="given_chart" cfsqltype="cf_sql_varchar" required="yes">--->
	<cfquery name="doAnotherThing" datasource="#application.datasource#" type="string">
		select * from fee_user.update_exp_mod_values()
	</cfquery>
</cffunction>

<cffunction name="getAllSalaryObjects" >
	<cfargument name="givenFY" required="true" type="string" />
	<cfquery name="objList" datasource="#application.datasource#">
		select * from fym_data
		where grp1_cd <> 0 and ln2_cd in
		  (select distinct ln2_cd from fym_data where cur_fis_yr =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFY#">
		     and grp1_cd = 0 and ln1_cd = 'BENE')
	</cfquery>
	<cfreturn objList />
</cffunction>

<cffunction name="getAllCampusSubmissions">
	<cfquery name="getCampusData" datasource="#application.datasource#">
		SELECT OID, campus, fund_grp_cd, fund_grp_desc, line_desc, fyear, amount, data_source, ie_code
		FROM fee_user.fym_campus_input
	</cfquery>
	<cfreturn getCampusData>
</cffunction>

<cffunction name="getFundTypes">
	<cfquery name="fundList" datasource="#application.datasource#">
		SELECT DISTINCT grp1_desc, grp1_cd FROM fee_user.fym_data ORDER BY grp1_cd ASC;
	</cfquery>
	<cfreturn fundList />
</cffunction>

<cffunction name="getExcelDataDump">
	<cfquery name="fymAllData" datasource="#application.datasource#">
		SELECT * FROM fee_user.fym_data
	</cfquery>
	<cfreturn fymAllData />
</cffunction>

<cffunction name="getExcelfnDump">
	<cfquery name="callFinalModel" datasource="#application.datasource#">
		SELECT * FROM rpt_fym_report_final_model()
	</cfquery>
	<cfreturn callFinalModel />
</cffunction>

<cffunction name="getExcelParamDataDump">
	<cfquery name="fymAllData" datasource="#application.datasource#">
		SELECT * FROM fee_user.fym_params
	</cfquery>
	<cfreturn fymAllData />
</cffunction>

<cffunction name="getFYMdataExcel">
	<cfquery name="fymDataExcel" datasource="#application.datasource#">
		(SELECT * FROM fee_user.fetch_fym_data()
		UNION
		SELECT * FROM fee_user.calc_sum_fym_param_display_bene_rows()
		UNION
		SELECT * FROM fee_user.calc_sum_fym_param_display_rows()
		) ORDER BY chart_cd asc, grp1_cd asc, grp2_cd asc, ln_sort asc
	</cfquery>
	<cfreturn fymDataExcel>
</cffunction>

<cffunction name="getFYMdata">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfargument name="givenGrp1" required="false" default="ALL">
	<cfquery name="fymData" datasource="#application.datasource#">
		(SELECT * FROM fee_user.fetch_fym_data(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1#">
		)
		UNION
		SELECT * FROM fee_user.calc_sum_fym_param_display_bene_rows(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1#">
		)
		UNION
		SELECT * FROM fee_user.calc_sum_fym_param_display_rows(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1#">
		)
		) ORDER BY chart_cd asc, grp1_cd asc, grp2_cd asc, ln_sort asc
	</cfquery>
	<cfreturn fymData>
</cffunction>

<cffunction name="getFymSums" >
	<cfargument name="givenChart" required="true" />
	<cfargument name="givenFundGrpCd" required="true" />
	<cfquery name="fymSums" datasource="#application.datasource#" >
		SELECT * from fee_user.calc_fym_subtotal_grp1(
		<!---SELECT * FROM fee_user.calc_fym_subtotals(  --->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFundGrpCd#">)
	</cfquery>
	<cfreturn fymSums />
</cffunction>

<cffunction name="getFymRevSums" >
	<cfargument name="givenChart" required="true" />
	<cfquery name="fymRevSums" datasource="#application.datasource#">
		SELECT sum(cy_orig_budget_amt) as pr_total,
		  sum(cur_yr_old) as cy_old_sum,
		  sum(cur_yr_new) as cy_total,
		  sum(yr1_old) as yr1_old_sum,
		  sum(yr1_new) as yr1_total,
		  sum(yr2_old) as yr2_old_sum,
		  sum(yr2_new) as yr2_total,
		  sum(yr3_old) as yr3_old_sum,
		  sum(yr3_new) as yr3_total,
		  sum(yr4_old) as yr4_old_sum,
		  sum(yr4_new) as yr4_total,
		  sum(yr5_old) as yr5_old_sum,
		  sum(yr5_new) as yr5_total
		FROM fee_user.fym_data
		WHERE grp1_cd <> 0 and 	grp2_cd = 1 and
			chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
	</cfquery>
	<cfreturn fymRevSums />
</cffunction>

<cffunction name="getFymRevDelta">
	<cfargument name="givenChart" type="string" required="false" default="currentUser.fym_inst">
	<cfquery name="fymRevDelta"  datasource="#application.datasource#">
		SELECT * FROM fee_user.calc_fym_subtotals(
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#givenChart#" />)
	</cfquery>
	<cfreturn fymRevDelta />
</cffunction>

<cffunction name="getFymExpSums">
	<cfargument name="givenChart" type="string" required="false" default="currentUser.fym_inst">
	<cfquery name="fymExpSums" datasource="#application.datasource#">
		SELECT * FROM fee_user.calc_fym_exp_sums(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#"> )
	</cfquery>
	<cfreturn fymExpSums />
</cffunction>

<cffunction name="getFymExpDelta">
	<cfargument name="givenChart" type="string" required="false" default="currentUser.fym_inst">
	<cfquery name="fymExpDelta" datasource="#application.datasource#">
		SELECT * FROM fee_user.calc_fym_subtotals(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
	</cfquery>
	<cfreturn fymExpDelta />
</cffunction>

<cffunction name="getFymSurplus">
		<cfargument name="givenChart" type="string" required="false" default="currentUser.fym_inst">
	<cfquery name="fymSurplus" datasource="#application.datasource#">
		SELECT sum(cy_orig_budget_amt) as pr_total,
		  sum(cur_yr_old) as cy_old_sum,
		  sum(cur_yr_new) as cy_total,
		  sum(yr1_old) as yr1_old_sum,
		  sum(yr1_new) as yr1_total,
		  sum(yr2_old) as yr2_old_sum,
		  sum(yr2_new) as yr2_total,
		  sum(yr3_old) as yr3_old_sum,
		  sum(yr3_new) as yr3_total,
		  sum(yr4_old) as yr4_old_sum,
		  sum(yr4_new) as yr4_total,
		  sum(yr5_old) as yr5_old_sum,
		  sum(yr5_new) as yr5_total
		FROM fee_user.fym_data
		WHERE grp1_cd <> 0 and
			chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
	</cfquery>
	<cfreturn fymSurplus />
</cffunction>

<cffunction name="getFymSubTotals" >
	<cfargument name="givenChart" required="true" />
	<cfargument name="givenGrp1Cd" required="true" />
	<cfargument name="givenGrp2Cd" required="true" />
	<cfquery name="fundGrpSubTotal" datasource="#application.datasource#">
		SELECT * from fee_user.calc_fym_subtotal_grp2(
		<!---SELECT * FROM calc_fym_subtotals(--->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenGrp1Cd#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenGrp2Cd#">)
	</cfquery>
	<cfreturn fundGrpSubTotal />
</cffunction>

<cffunction name="getFYM_CrHrdata" >
	<cfargument name="givenChart" required="false" default="ALL">
	<cfquery name="crHrData" datasource="#application.datasource#">
		SELECT OID, cur_fis_yr, inst_cd, inst_desc, chart_cd, chart_desc, acad_career, res, sort, cur_yr_orig_hrs, cur_yr_orig_rt,cur_yr_orig_hrs*cur_yr_orig_rt as prv_yr_rev, cur_yr_hrs, cur_yr_hrs_new, cur_yr_rt, cur_yr_rt*cur_yr_hrs_new as cur_yr_rev, yr1_hrs, yr1_hrs_new, yr1_rt, yr1_rt*yr1_hrs_new as yr1_rev, yr2_hrs, yr2_hrs_new,yr2_rt, yr2_rt*yr2_hrs_new as yr2_rev, yr3_hrs, yr3_hrs_new, yr3_rt, yr3_rt*yr3_hrs_new as yr3_rev, yr4_hrs, yr4_hrs_new, yr4_rt,yr4_hrs_new*yr4_rt as yr4_rev, yr5_hrs, yr5_hrs_new, yr5_rt,yr5_hrs_new*yr5_rt as yr5_rev
	FROM fee_user.fym_crhr
	<cfif givenChart neq 'ALL'>WHERE chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#"></cfif>
	ORDER BY sort ASC
	</cfquery>
	<cfreturn crHrData>
</cffunction>

<cffunction name="getCrHrSums">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfquery name="crHrSums" datasource="#application.datasource#">
		SELECT chart_cd,details_disp,
		  cy_orig_budget_amt as pr_total_rev,
		  cur_yr_new as cy_total_rev,
		  yr1_new as yr1_total_rev,
		  yr2_new as yr2_total_rev,
		  yr3_new as yr3_total_rev,
		  yr4_new as yr4_total_rev,
		  yr5_new as yr5_total_rev
		<cfif givenChart eq 'ALL'>
			FROM calc_fym_tuition_row()
		<cfelse>
			FROM calc_fym_tuition_row(<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
		</cfif>
		ORDER BY chart_cd asc
	</cfquery>
	<cfreturn crHrSums />
</cffunction>


<cffunction name="getCrHrSums_OLD">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfargument name="givenDetail" required="false" default="NO">
	<cfquery name="crHrSums" datasource="#application.datasource#">
		SELECT chart_cd,
		   <cfif givenDetail neq 'NO'>res, acad_career,</cfif>
		  sum(cur_yr_orig_hrs) as pr_total_crhrs, sum(cur_yr_orig_hrs*cur_yr_orig_rt) as pr_total_rev,
		  sum(cur_yr_hrs_new) as cy_total_crhrs, sum(cur_yr_rt*cur_yr_hrs_new) as cy_total_rev,
		  sum(yr1_hrs_new) as yr1_total_crhrs, sum(yr1_rt*yr1_hrs_new) as yr1_total_rev,
		  sum(yr2_hrs_new) as yr2_total_crhrs, sum(yr2_rt*yr2_hrs_new) as yr2_total_rev,
		  sum(yr3_hrs_new) as yr3_total_crhrs, sum(yr3_rt*yr3_hrs_new) as yr3_total_rev,
		  sum(yr4_hrs_new) as yr4_total_crhrs, sum(yr4_rt*yr4_hrs_new) as yr4_total_rev,
		  sum(yr5_hrs_new) as yr5_total_crhrs, sum(yr5_rt*yr5_hrs_new) as yr5_total_rev
		FROM fee_user.fym_crhr
		<cfif givenChart neq 'ALL'>WHERE chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#"></cfif>
		<cfif givenDetail neq 'NO'>GROUP BY chart_cd, res, acad_career
		<cfelse>GROUP BY chart_cd</cfif>
		ORDER BY chart_cd asc
	</cfquery>
	<cfreturn crHrSums />
</cffunction>
<cffunction name="getSingleCampusSubmission" >
	<!--- select amount from fee_user.fym_campus_input WHERE campus = 'IUBLA' and line_cd = 'TF' and fyear = '2023' --->
	<cfargument name="givenCampus" type="string" required="true" />
	<cfargument name="givenLineCd" type="string" required="true" />
	<cfargument name="givenLineFyear" type="string" required="true" />
	<cfquery name="uniqueLine">

	</cfquery>
</cffunction>

<cffunction name="getCurYear">
	<cfquery name="maxYr" datasource="#application.datasource#">
		SELECT MAX(fym_data.cur_fis_yr) as cur_fis_yr FROM fee_user.fym_data
	</cfquery>
	<cfreturn maxYr />
</cffunction>

<cffunction name="convertQueryToStruct" >
	<!--- Take a query result containing OID and make a struct holding structs for each column/value pair --->
	<cfargument name="givenQuery" required="true">
	<cfset colList = givenQuery.getColumnList() />
	<cfif ArrayFind(colList,"OID") neq 0>
		<!---<cfscript>orderedStruct = structNew("ordered");</cfscript>--->
		<cfset newStruct = {"colList" = colList} />
		<cfloop query="givenQuery">
			<cfscript>
				paramSubStruct = StructNew();
				for (colName in colList) {
					structInsert(paramSubStruct,colName,givenQuery[colName][currentRow]);
				}
				structInsert(newStruct,OID,paramSubStruct);
			</cfscript>
		</cfloop>
	<cfelse>
		<cfset errorStruct = {"000000" = {"ERROR":"Your submitted query must contain an OID."}} />
		<cfreturn errorStruct />
	</cfif>
	<cfreturn newStruct />
</cffunction>

<cffunction name="updateFymData">
	<cfargument name="givenColumn" required="true" type="string">
	<cfargument name="givenOID" required="true" type="string">
	<cfargument name="givenValue" required="true" type="string">
	<cfquery name="messWithData" datasource="#application.datasource#">
		SELECT update_fym_data(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenColumn#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenOID#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenValue#">)
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="changeCrHrRates">
	<cfargument name="givenColumn" required="true" type="string">
	<cfargument name="givenOID" required="true" type="numeric">
	<cfargument name="givenValue" required="true" type="numeric">
	<cfquery name="doAllTheMath" datasource="#application.datasource#">
		SELECT fee_user.change_crhr_rates(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenColumn#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#givenOID#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#givenValue#">
		)
	</cfquery>
	<cfreturn doAllTheMath />
</cffunction>

<cffunction name="updateCrHrRates">
	<cfargument name="givenChart" required="true" type="string">
	<cfquery name="callCrHrFunc" datasource="#application.datasource#">
		SELECT fee_user.update_crhr_rates(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
			)
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="getTestQuery">
	<cfargument name="sockItToMe" required="false" default="NEVERMIND">
	<cfif sockItToMe eq 'NEVERMIND'>
		<cfquery name="hotAir" datasource="#application.datasource#">
			SELECT 'blork' as BLORK from dual
		</cfquery>
		<cfreturn hotAir />
	<cfelse>
		<cfquery name="smoke" datasource="#application.datasource#">
			SELECT '999999' as OID, '#sockItToMe#' as GIVEN_INPUT, 'blork' as BLORK, 'swampwater' as BILGE, 'tosh' as DRIVEL, '7' as YRS_TO_RETIRE
			from dual
		</cfquery>
		<cfreturn smoke />
	</cfif>
</cffunction>

<cffunction name="calculateFutureTuitionDollars">
	<cfargument name="givenInst" required="true" type="string" hint="inst_cd">
	<cfquery name="fetchCYRevenue">

	</cfquery>
</cffunction>