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

<cffunction name="getFYMRefreshHistory" >
	<cfquery name="refreshList" datasource="#application.datasource#">
		SELECT * FROM fee_user.metadata
		WHERE action_id = '33'
		ORDER BY created_on DESC limit 5;
	</cfquery>
	<cfreturn refreshList />
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
		select scenario_cd as oid, scenario_owner, scenario_nm, scenario_access, scenario_fis_yr from fym_scenario
		<cfif given_row neq 'ALL'>
			where scenario_cd = #given_row#
		</cfif>
		order by scenario_cd ASC
	</cfquery>
	<cfreturn getScens>
</cffunction>

<cffunction name="getCurrentScenario">
	<cfargument name="given_id" required="true">
	<cfquery name="getScens" datasource="#application.datasource#">
		select s.scenario_cd, s.scenario_owner, s.scenario_nm, s.scenario_access, s.scenario_fis_yr
		from fym_scenario s
		where s.scenario_cd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#given_id#">
	</cfquery>
	<cfreturn getScens>
</cffunction>

<cffunction name="getCurrentScenarioData">
	<cfargument name="givenscenario_cd" required="false" default=0>
	<cfargument name="givenfisyr" required="false" default=#application.fiscalyear#>
	<cfquery name="getScens" datasource="#application.datasource#">
		select d.oid, d.inst_cd, d.chart_cd, d.scenario_cd, d.scenario_owner, d.scenario_nm, d.scenario_access, d.scenario_fis_yr, 
			d.cur_fis_yr, d.grp1_cd, d.grp1_desc, d.grp2_desc, d.grp2_cd, 
			d.ln1_cd, d.ln1_desc, d.ln2_cd, d.ln2_desc, d.cur_yr_new, 
			d.yr1_new, d.yr2_new, d.yr3_new, d.yr4_new, d.yr5_new, 
			d.scenario_type_cd, d.scenario_type_nm
		from fee_user.fetch_fym_data_scenario(
			<cfqueryparam cfsqltype="numeric" value="#givenscenario_cd#">,
			<cfqueryparam cfsqltype="numeric" value="#givenfisyr#"> 
			) d
			ORDER BY d.chart_cd asc, d.grp1_cd asc, d.grp2_cd asc, ln1_cd asc
	</cfquery>
	<cfreturn getScens>
</cffunction>

<cffunction name="getNewScenarioDataRow" >
	<cfargument name="given_row" required="true">
	<cfquery name="getscenBaseData" datasource="#application.datasource#">
		select * from fee_user.rpt_fym_report_credit_hours()
		where oid = '#given_row#'
	</cfquery>
	<cfreturn getscenBaseData>
</cffunction>

<cffunction name="getScenarioCrHr" >
	<cfargument name="givenscenario_cd" required="false" default=0>
	<cfargument name="givenfisyr" required="false" default=#application.fiscalyear#>
	<cfquery name="getScenCrHr" datasource="#application.datasource#">
		select oid,scenario_cd, scenario_owner, scenario_nm, scenario_access, scenario_fis_yr, cur_fis_yr, inst_cd, chart_cd, acad_career, res, 
		cur_yr_hrs_new, yr1_hrs_new, yr2_hrs_new, yr3_hrs_new, yr4_hrs_new, yr5_hrs_new,
		scenario_type_cd, scenario_type_nm
		from fee_user.fetch_fym_crhr_scenario(
			<cfqueryparam cfsqltype="numeric" value="#givenscenario_cd#">,
			<cfqueryparam cfsqltype="numeric" value="#givenfisyr#"> 
		)
		ORDER BY chart_cd asc, acad_career asc, res asc
	</cfquery>
	<cfreturn getScenCrHr>
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
	<cfargument name="givenScenarioCd" required="false" default=0>
	<cfargument name="givenChart" required="false" default="ALL">
	<cfquery name="callFinalModel" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_final_model(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenarioCd#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
			)
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
	<cfargument name="givenScenario_cd" required="false" default="0">
	<cfargument name="givenChart" required="false" default="ALL">
		<cfquery name="aggregatedFymData" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_final_model(
			givenScenario_cd => <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenario_cd#">,
			givenChart => <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
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
	<cfargument name="givenScenario" required="false" default="ALL">
	<cfargument name="givenChart" required="false" default="ALL">
	<cfargument name="givenGrp1" required="false" default="ALL">
	<cfquery name="fymDataByFnd" datasource="#application.datasource#">
		SELECT * FROM fee_user.rpt_fym_report_final_model_byfnd(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenario#">,
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
	
<cffunction name="getFymSummary" >  <!--- used to calculate summary table  --->
	<cfargument name="givenScenario" required="true" />
	<cfargument name="givenChart" required="true" />
	<cfquery name="fymSummaryTable" datasource="#application.datasource#" >
		SELECT * from fee_user.calc_fym_data_sum(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenario#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
	</cfquery>
	<cfreturn fymSummaryTable />
</cffunction>
	
<cffunction name="getFymSums" >  <!--- used to calculate campus sub-totals  --->
	<cfargument name="givenScenario" required="false" type="numeric" default=0 />
	<cfargument name="givenChart" required="true" />
	<cfargument name="givenFundGrpCd" required="true" />
	<cfquery name="fymSums" datasource="#application.datasource#" >
		SELECT * from fee_user.calc_fym_subtotal_grp1(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenario#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFundGrpCd#">)
	</cfquery>
	<cfreturn fymSums />
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
	<cfargument name="givenScenarioCd" required="true" />
	<cfargument name="givenChart" required="true" />
	<cfargument name="givenGrp1Cd" required="true" />
	<cfargument name="givenGrp2Cd" required="true" />
	<cfquery name="fundGrpSubTotal" datasource="#application.datasource#">
		SELECT * from fee_user.calc_fym_subtotal_grp2(
		givenscenario_cd => <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenScenarioCd#">,
		givenchart => <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">,
		givengrp1cd => <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp1Cd#">,
		givengrp2cd => <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenGrp2Cd#">)
	</cfquery>
	<cfreturn fundGrpSubTotal />
</cffunction>

<cffunction name="getFYM_CrHrdata" >
	<cfargument name="givenScen_cd" required="false" default="ALL">
	<cfargument name="givenChart" required="false" default="ALL">
		<cfquery name="crHrData" datasource="#application.datasource#">
			select * from fee_user.rpt_fym_report_credit_hours(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenScen_cd#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">)
			ORDER BY sort ASC
	</cfquery>
	<cfreturn crHrData>
</cffunction>

<cffunction name="getCrHrSums"> 
	<cfargument name="givenScenario_cd" type="numeric" required="false" default=0>
	<cfargument name="givenChart" required="true">
	<cfquery name="crHrSums" datasource="#application.datasource#">
		SELECT sum_cd, sum_desc,
		  cur_yr_new_sum,
		  yr1_new_sum,
		  yr2_new_sum,
		  yr3_new_sum,
		  yr4_new_sum,
		  yr5_new_sum
		FROM calc_fym_crhr_sum(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenScenario_cd#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenChart#">
		)
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

<cffunction name="changeScenarioCrHrs">
	<cfargument name="givenOID" required="true" type="numeric">
	<cfargument name="givenColumn" required="true" type="string">
	<cfargument name="givenValue" required="true" type="numeric">
	<cfquery name="updateCrHrScenarioData" datasource="#application.datasource#">
		SELECT fee_user.change_crhr_rates(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#givenOID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenColumn#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#givenValue#">
		)
	</cfquery>
	<cfreturn updateCrHrScenarioData />
</cffunction>

<cffunction name="changeCrHrRates">     <!--- actually enters user data into a specific column and row in the fym_crhr table--->
	<cfargument name="givenColumn" required="true" type="string">
	<cfargument name="givenOID" required="true" type="numeric">
	<cfargument name="givenValue" required="true" type="numeric">
	<cfquery name="insertCrHrValue" datasource="#application.datasource#">
		SELECT fee_user.change_crhr_rates(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenColumn#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#givenOID#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#givenValue#">
		)
	</cfquery>
	<cfreturn insertCrHrValue />
</cffunction>

<!--- Does not actually enter new data into system, just sets off a chain event of UPDATES within the data set!! --->
<cffunction name="updateCrHrRates">  <!--- uses parameter settings to propagate the 1st year rate setting forward to later years in 5YM --->
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

<cffunction name="updateFYMdataScenario">
	<cfargument name="givenoid" required="true" type="any">
	<cfargument name="givencolumn" required="true" type="string">
	<cfargument name="givenvalue" required="true" type="numeric">
	<cfquery name="call_update_fym_data_scenario" datasource="#application.datasource#">
		SELECT fee_user.update_fym_data_scenario(
			givenoid => <cfqueryparam cfsqltype="cf_sql_integer" value="#givenoid#">,
			givencolumn => <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(givencolumn)#">,
			givenvalue => <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#givenvalue#">						
			)
	</cfquery>
	<cfreturn call_update_fym_data_scenario />
</cffunction>

<cffunction name="updateFYMCrHrScenario">
	<cfargument name="givenoid" required="true" type="any">
	<cfargument name="givencolumn" required="true" type="string">
	<cfargument name="givenvalue" required="true" type="numeric">
	<cfquery name="call_update_fym_data_scenario" datasource="#application.datasource#">
		SELECT fee_user.update_fym_crhr_scenario(
			givenoid => <cfqueryparam cfsqltype="cf_sql_integer" value="#givenoid#">,
			givencolumn => <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(givencolumn)#">,
			givenvalue => <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#givenvalue#">						
			)
	</cfquery>
	<cfreturn call_update_fym_data_scenario />
</cffunction>

<cffunction name="compareFYMscenario">
	<cfargument name="givenchart" required="false" type="string" default="ALL">
	<cfargument name="scenario_cd_0" required="true" type="numeric">
	<cfargument name="scenario_cd_1" required="true" type="numeric">
	<cfargument name="scenario_cd_2" required="true" type="numeric">
	<cfquery name="compare_scenario" datasource="#application.datasource#">
		SELECT * from fee_user.rpt_fym_report_final_model_data_scenario_compare_sum(
			givenchart => <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenchart#">,
			givenscenario_cd_0 => <cfqueryparam cfsqltype="cf_sql_numeric" value="#scenario_cd_0#">,
			givenscenario_cd_1 => <cfqueryparam cfsqltype="cf_sql_numeric" value="#scenario_cd_1#">,
			givenscenario_cd_2 => <cfqueryparam cfsqltype="cf_sql_numeric" value="#scenario_cd_2#">
			)
	</cfquery>
	<cfreturn compare_scenario />
</cffunction>