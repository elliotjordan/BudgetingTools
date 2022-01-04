<cffunction name="trackFYMAction" output="false">
	<cfargument name="loginId" required="true" default="#REQUEST.AuthUser#" />
	<cfargument name="campusId" required="false" default="--" />
	<cfargument name="actionId" required="true" />
	<cfargument name="description" required="false" default="" />
	<cfquery datasource="#application.datasource#" name="makeMeta">
		INSERT INTO FEE_USER.METADATA
		(USER_ID,CAMPUS_ID,ACTION_ID,DESCRIPTION)
		VALUES
		('#loginId#','#campusId#','#actionId#','#description#')
	</cfquery>
</cffunction>

<cffunction name="compareFymCrHrs">
	<cfargument name="givenInst" type="string" required="true">
	<cfquery name="getComparison" datasource="#application.datasource#">
		SELECT * FROM ch_user.rpt_chp_vs_fym() 
		WHERE inst_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenInst#">
		ORDER BY 1, 2 DESC, 3 DESC
	</cfquery>
	<cfreturn getComparison>
</cffunction>

<cffunction name="getCompDetails">
	<cfargument name="givenChart" type="string" required="true">
	<cfquery name="compDetailList" datasource="#application.datasource#">
		select * from calc_fym_param_display_rows() where chart_cd = 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
	</cfquery>
	<cfreturn compDetailList>	
</cffunction>

<cffunction name="getFYMcomments" returntype="query">
	<cfargument name="givenOID" type="numeric" required="false" default= 0>
	<cfquery datasource="#application.datasource#" name="commentList">
		SELECT oid, comment from fym_comments
		<cfif givenOID neq 0>
			WHERE oid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenOID#">
		</cfif>
	</cfquery>
	<cfreturn commentList />
</cffunction>

<cffunction name="createFYMcomment" returntype="boolean">
	<cfargument name="givenOID" type="numeric" required="true">
	<cfargument name="givenComment" type="string" required="true">
		<cfquery datasource="#application.datasource#" name="commentList">
			INSERT INTO fee_user.fym_comments(oid, comment)
			VALUES (
				<cfqueryparam cfsqltype="numeric" value="#givenOID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenComment#">   
			)
		</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="updateFYMcomment">
	<cfargument name="givenOID" type="numeric" required="true">
	<cfargument name="givenComment" type="string" required="true">
	<cfset foundComment = getFYMcomments(givenOID) />
	<cfif foundComment.recordcount neq 0>

		<cfquery datasource="#application.datasource#" name="commentList">
			UPDATE fee_user.fym_comments
			SET comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenComment#">
			WHERE oid = <cfqueryparam cfsqltype="numeric" value="#givenOID#">
		</cfquery>
	<cfelse> 
		<cfset insertedComment = createFYMcomment(givenOID,givenComment) />
	</cfif>
</cffunction>

<cffunction name="getDistinctChartDesc">
	<cfargument name="givenChart" required="true" />
	<cfquery datasource="#application.datasource#" name="currentChartDesc">
		SELECT DISTINCT chart_desc FROM fee_user.fym_data
		WHERE lower(chart_cd) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(givenChart)#">
	</cfquery>
	<cfreturn currentChartDesc.chart_desc />
</cffunction>

<cffunction name="getFYMparams">
	<cfquery name="getParms" datasource="#application.datasource#">
	select OID, chart_cd, ln1_cd, ln2_cd, ln1_desc, ln2_desc, cur_yr_new, yr1_new,
		yr2_new, yr3_new, yr4_new, yr5_new , ln_sort
		from fym_data f 
		JOIN proj_parameter p
		ON F.cur_fis_yr = p.fiscal_year
		WHERE grp1_cd = 0 
		and p.project_cd = 'FYM'
		ORDER BY chart_cd ASC, grp1_cd ASC, grp2_cd ASC,ln_sort ASC
	</cfquery>
		
	<cfreturn getParms>
</cffunction>

<cffunction name="getScenarios">
	<cfargument name="given_row" required="false" default="ALL">
	<cfquery name="getScens" datasource="#application.datasource#">
		select scen_oid as oid, scen_user, scen_title from fym_scenarios
		<cfif given_row neq 'ALL'>
			where scen_oid = #given_row#
		</cfif>
	</cfquery>
	<cfreturn getScens>
</cffunction>

<cffunction name="getScenarioData">
	<cfargument name="given_row" required="false" default="ALL">
	<cfquery name="getScens" datasource="#application.datasource#">
		select *from fym_data_scenario
		<cfif given_row neq 'ALL'>
			where scenario_cd = #given_row#
		</cfif>
	</cfquery>
	<cfreturn getScens>
</cffunction>

<cffunction name="getNewScenarioDataRow" >
	<cfargument name="given_row" required="true">
	<cfquery name="getscenBaseData" datasource="#application.datasource#">
		select * from fym_data
		where oid = '#given_row#'
	</cfquery>
	<cfreturn getscenBaseData>
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
	<cfreturn true />
</cffunction>

<cffunction name="updateExp">
	<cfquery name="doAnotherThing" datasource="#application.datasource#" >
		select * from fee_user.update_exp_mod_values()
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="updateCrHrFromParams">
	<cfquery name="doCrHrThings" datasource="#application.datasource#" >
		select * from fee_user.update_crhr_rates()
	</cfquery>
	<cfreturn true />
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
		SELECT DISTINCT d.grp1_desc, d.grp1_cd FROM fee_user.fym_data  d
		JOIN fee_user.proj_parameter p
		ON d.cur_fis_yr = p.fiscal_year
		WHERE p.project_cd = 'FYM' 
		ORDER BY d.grp1_cd ASC;
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

<cffunction name="get_rpt_fym_report_final_model" >
	<cfargument name="givenChart" required="false" default="ALL">
		<cfquery name="aggregatedFymData" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_final_model(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
		)
	</cfquery>
	<cfreturn aggregatedFymData>
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

<cffunction name="getFYMdata">   <!--- stubbed function, not sure we need it yet  --->
	<cfargument name="givenChart" required="false" default="ALL">
	<cfquery name="fymData" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_change_model(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
		)
	</cfquery>
	<cfreturn fymData>
</cffunction>

<cffunction name="getFYMdataByFnd">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfargument name="givenGrp1" required="false" default="ALL">
	<cfquery name="fymDataByFnd" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_final_model_byfnd(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1#">
		)
	</cfquery>
	<cfreturn fymDataByFnd />
</cffunction>

<cffunction name="getFYMdataByGrps">
	<cfargument name="givenChart" required="true">
	<cfargument name="givenGrp1" required="true">
	<cfargument name="givenGrp2" required="true">
	<cfquery name="FYMdataByGrps" datasource="#application.datasource#">
		select * from fee_user.rpt_fym_report_change_model_bygrps(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp2#">
		)
	</cfquery>
	<cfreturn FYMdataByGrps />
</cffunction>
	
<cffunction name="getFymSums" >
	<cfargument name="givenChart" required="true" />
	<cfargument name="givenFundGrpCd" required="true" />
	<cfquery name="fymSums" datasource="#application.datasource#" >
		SELECT * from fee_user.calc_fym_subtotal_grp1(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFundGrpCd#">)
	</cfquery>
	<cfreturn fymSums />
</cffunction>

<cffunction name="getFymRevSums" >
	<cfargument name="givenChart" required="true" />
	<cfquery name="fymRevSums" datasource="#application.datasource#">
		SELECT pr_total, cy_old_sum, cy_total, yr1_old_sum, yr1_total, yr2_old_sum, yr2_total,
	yr3_old_sum, yr3_total, yr4_old_sum, yr4_total, yr5_old_sum, yr5_total
		FROM fee_user.calc_fym_subtotal_chart_rev_exp_tot('#givenChart#',1)
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
		SELECT pr_total, cy_old_sum, cy_total, yr1_old_sum, yr1_total, yr2_old_sum, yr2_total,
	yr3_old_sum, yr3_total, yr4_old_sum, yr4_total, yr5_old_sum, yr5_total
		FROM fee_user.calc_fym_subtotal_chart_rev_exp_tot('#givenChart#',2)
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
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenGrp1Cd#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenGrp2Cd#">)
	</cfquery>
	<cfreturn fundGrpSubTotal />
</cffunction>

<cffunction name="getFYM_CrHrdata" >
	<cfargument name="givenChart" required="false" default="ALL">
		<cfquery name="crHrData" datasource="#application.datasource#">
			<cfif givenChart eq 'ALL'>	
				select * from fee_user.rpt_fym_report_credit_hours()
		<cfelse>
			select * from fee_user.rpt_fym_report_credit_hours(<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
		</cfif>
		ORDER BY sort ASC
	</cfquery>
	<cfreturn crHrData>
</cffunction>

<cffunction name="getCrHrSums"> 
	<cfargument name="givenChart" required="true">
	<cfquery name="crHrSums" datasource="#application.datasource#">
		SELECT sum_cd, sum_desc,
		  cur_yr_new_sum,
		  yr1_new_sum,
		  yr2_new_sum,
		  yr3_new_sum,
		  yr4_new_sum,
		  yr5_new_sum
		FROM calc_fym_crhr_sum(<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
	</cfquery>
	<cfreturn crHrSums />
</cffunction>

<cffunction name="getModelExcelDownload">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfquery name="modelSums" datasource="#application.datasource#">
		SELECT oid,chart_cd,
			cy_orig_budget_amt,
			cur_yr_new,
			yr1_new,
			yr2_new,
			yr3_new,
			yr4_new,
			yr5_new 
		FROM fee_user.calc_fym_tuition_row
		<cfif givenChart neq 'ALL'>WHERE chart_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#"></cfif>
		ORDER BY chart_cd asc
	</cfquery>
	<cfreturn modelSums />
</cffunction>

<cffunction name="getSingleCampusSubmission" >
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
	<cfreturn callCrHrFunc />
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