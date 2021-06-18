<cffunction name="getTuitionList">
	<cfquery name="tuiList" datasource="#application.datasource#">
		select allfee_id, fee_desc_billing from afm
		where fee_type IN ('TUI','PRO') and fiscal_year = '#application.fiscalyear#'
		order by allfee_id asc
	</cfquery>
	<cfreturn tuiList>
</cffunction>

<cffunction name="getFeeParamData">
	<cfargument name="givenInst" type="string" default="ALL" required="false" />
	<cfquery name="feeParamData" datasource="#application.datasource#" >
		select a.allfee_id, a.fiscal_year, a.inst_cd, a.fee_desc_billing, a.unit_basis, a.fee_current,
		  b.asso_desc, c.fn_name, c.param_desc
		from fee_user.afm a
		inner join afm_de_asso b on a.allfee_id = b.de_afid
		inner join afm_params c on b.param_id = c.param_id
		where a.fiscal_year  = '#application.fiscalyear#' and a.active = 'Y' and c.active = 'Y'
		<cfif givenInst neq 'ALL'>
			and a.inst_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenInst#">
		</cfif>
	</cfquery>
	<cfreturn feeParamData />
</cffunction>

<cffunction name="getAFM_DE_asso" >
	<cfquery name="afm_de_asso" datasource="#application.datasource#">
		select * from fee_user.afm_de_asso
	</cfquery>
	<cfreturn afm_de_asso />
</cffunction>

<cffunction name="getAFMparams" >
	<cfquery name="afm_params" datasource="#application.datasource#">
		select * from afm_params
	</cfquery>
	<cfreturn afm_params />
</cffunction>

<cffunction name="getDEchangeReport">
	<cfquery name="de_delta" datasource="#application.datasource#">
		select a.allfee_id as "DE_Rate", a.inst_cd, a.fee_desc_billing, a.unit_basis, a.fee_current,a.fee_lowyear,
		  CASE When a.fee_current <= 0 then 0 else
	      round((to_number(a.fee_lowyear)-to_number(a.fee_current))/to_number(a.fee_current),3)*100 END as delta_percent,
		  b.base_afid as "Base_Rate", b.param_id, b.asso_desc, c.fn_name, c.param_desc
		from fee_user.afm a
		inner join afm_de_asso b on a.allfee_id = b.de_afid
		inner join afm_params c on b.param_id = c.param_id
		where a.fiscal_year  = '#application.fiscalyear#' and a.active = 'Y' and c.active = 'Y'
	</cfquery>
	<cfreturn de_delta />
</cffunction>

<cffunction name="getUnassociatedDE">
	<cfquery name="unAssDE" datasource="#application.datasource#">
		select distinct a.allfee_id, a.fee_desc_billing , b.de_afid
		from fee_user.afm a
		left outer join afm_de_asso b on a.allfee_id = b.de_afid
		where a.fiscal_year  = '#application.fiscalyear#' and a.active = 'Y' and a.fee_type = '_DE' and b.de_afid IS NULL
		order by a.allfee_id ASC
	</cfquery>
	<cfreturn unAssDE />
</cffunction>

<cffunction name="getDEasso">
	<cfquery name="DEasso" datasource="#application.datasource#">
		select b.base_afid, b.de_afid, b.param_id, a.fee_desc_billing, c.fn_name
		from fee_user.afm_de_asso b 
		left outer join fee_user.afm a on b.de_afid = a.allfee_id
		left outer join afm_params c on b.param_id = c.param_id
		where a.fiscal_year  = '#application.fiscalyear#' and a.active = 'Y'
	</cfquery>
	<cfreturn DEasso />
</cffunction>

<cffunction name="insertNewAsso">
	<cfargument name="givenBASEafid" required="true" type="string" />
	<cfargument name="givenDEafid" required="true" type="string" />
	<cfargument name="givenRule" required="true" type="numeric" />
	<cfquery name="associateRule" datasource="#application.datasource#">
		INSERT INTO fee_user.afm_de_asso(base_afid, de_afid, param_id)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenBASEafid#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenDEafid#">, 
			<cfqueryparam cfsqltype="cf_sql_bigint" value="#givenRule#">
			)
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="saveNewFee">
	<cfargument name="givenForm" type="struct" required="true" />
	<cfargument name="givenCol" type="string" required="true" />
	<cfargument name="givenValue" type="any" requred = "true" />
	<cfargument name="givenAFID" type="string" required="true" />
	<cfset autoNote = 'Creation data - ' />
	<cfset autoNote = autoNote & #givenForm.fee_note# />
	<cfif StructKeyExists(givenForm,"allfee_id")>
		<cfquery name="setValues" datasource="#application.datasource#">
				UPDATE #application.allFeesTable#
				SET #givenCol# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenValue#" />
				<!---fee_note = '#autoNote#',
				  fee_owner = '#givenForm.fee_owner#',
				  account_nbr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenForm.account_nbr#">,
				  fee_desc_billing = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenForm.fee_desc_billing#">
				  fee_desc_long
				  fee_desc_web
				  fee_loweyar
				  fee-note
				  fee_owner
				  further_justify
				  need_for_fee
				  new_acct_input
				  obj_cd
				  unit_basis
				  wo_acct_nbr
		--->
				WHERE allfee_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAFID#" />
				and
				FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		</cfquery>
		<cfreturn true />
	<cfelse>
		<cfreturn false />
	</cfif>
</cffunction>

<cffunction name="getAcadOrgsFromTTT" output="true">  <!--- TTT: Todd's Terrible Two Tables --->
	<cfquery name="getOrgs" datasource="#application.datasource#">
		SELECT DISTINCT INST_CD,
                NVL(PPLSFT_ACAD_ORG_LVL_4_CD,
                NVL(PPLSFT_ACAD_ORG_LVL_3_CD,
                NVL(PPLSFT_ACAD_ORG_LVL_2_CD,
                PPLSFT_ACAD_ORG_LVL_1_CD)))
		FROM DSS_RDS.IR_CEN_CRS_SNPSHT_GT WHERE ACAD_TERM_CD = '4148'
		ORDER BY 1 ASC
	</cfquery>
	<cfif getOrgs.RecordCount gt 0>
		<cfreturn getOrgs>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getAllFees">
	<cfargument name="given_AllFeeID" required="false" type="string" default="">
	<cfargument name="given_feeStatus" required="false" type="string" default="Y">
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT allfee_id, allfee_masterid, allfee_groupid, local_id, local_masterid, fiscal_year, inst_cd, fee_type, fee_typ_desc, unit_basis, fee_desc_long, fee_desc_billing, fee_desc_web, fee_current, fee_lowyear, fee_highyear, yr1_est_vol, yr2_est_vol, xfactor, yfactor, fee_begin_term, dyn_org_ind, cost_desc_item1, cost_desc_item2, cost_amt_item1, cost_amt_item2, sis_itemtype, sis_type, account_nbr, sub_account_nbr, wo_account_nbr, rec_account_nbr, cy_est_vol, obj_cd, dept_id, fee_owner, replacement_fee, replacement_ind, fee_distance, meta, fee_note, approval_lvl, need_for_fee, further_justify, active, fee_status, cohort, fee_residency, fee_level, summer_ind, set_id
	FROM #application.allFeesTable#
		WHERE FISCAL_YEAR = '#application.fiscalyear#' AND ACTIVE = <cfqueryparam cfsqltype="cf_sql_char" value="#given_feeStatus#">
		<cfif LEN(given_AllFeeID)>
			AND ALLFEE_ID = '#given_AllFeeID#'
		</cfif>
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getMergedFees">
	<cfargument name="given_AllFeeID" required="false" type="string" default="ALL">
	<cfargument name="given_homeChart" required="false" type="string" default="IUALLA">
	<cfargument name="given_RC" required="false" type="string" default="ALL">
	<cfquery name="getMergedFees" datasource="#application.datasource#">
		SELECT allfee_id, allfee_masterid, allfee_groupid, local_id, local_masterid, fiscal_year, inst_cd, fee_type,
		fee_typ_desc, unit_basis, fee_desc_long, fee_desc_billing, fee_desc_web, fee_current, fee_lowyear, fee_highyear,
		yr1_est_vol, yr2_est_vol, xfactor, yfactor, fee_begin_term, dyn_org_ind, cost_desc_item1, cost_desc_item2,
		cost_amt_item1, cost_amt_item2, sis_itemtype, sis_type, account_nbr, sub_account_nbr, wo_account_nbr, rec_account_nbr,
		cy_est_vol, obj_cd, dept_id, fee_owner, replacement_fee, replacement_ind, fee_distance, meta,
		fee_note, approval_lvl, need_for_fee, further_justify, active, fee_status, cohort, fee_residency,
		fee_level, summer_ind, set_id
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		<cfif given_AllFeeID neq 'ALL'>
			AND ALLFEE_ID = '#given_AllFeeID#'
		</cfif>
		<cfif given_homeChart neq 'IUALLA'>
			AND inst_cd = '#given_homeChart#'
		</cfif>
		<cfif !FindNoCase('all', given_RC)>
			AND fee_owner = '#given_RC#'
		</cfif>
	</cfquery>
	<cfreturn getMergedFees>
</cffunction>

<cffunction name="getFeesForUser" >
	<!--- If this is a campus level user, give them all fees for their campus; otherwise, give them only the fees for their RC  --->
	<cfargument name="given_accessLevel" required="false" type="string" default="">
	<cfargument name="given_homeChart" required="false" type="string" default="">
	<cfargument name="given_homeRC" required="false" type="string" default="">

	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT ALLFEE_ID,
		  ALLFEE_MASTERID,
		  FEE_OWNER,
		  INST_CD,
		  FEE_DESC_LONG,
		  DEPT_ID,
		  SUBJECT_CD,
		  CRS_NBR,
		  SIS_COURSE_ID,
		  COURSE_DESC,
		  FEE_TYPE,
		  UNIT_BASIS,
		  FEE_TYP_DESC,
		  APPROVAL_LVL,
		  SIS_ITEMTYPE,
		  SIS_TYPE,
		  ACCOUNT_NBR,
		  OBJ_CD,
		  ACTIVE,
		  FEE_STATUS,
		  FY19_dollars AS "fee_current",
		  FEE_NOTE,
		  LOCAL_ID
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  AND FEE_TYPE NOT IN ('_DE', 'TUI', 'MAN', 'PRO')
		<cfif given_accessLevel eq "bduser">
			<cfif SUBSTR(given_accessLevel,1,2) eq given_homeChart>
				AND INST_CD = 'IU' & #given_homeChart# & "A"
			</cfif>
			<cfif LEN(given_homeChart)>
				AND FEE_OWNER = '#given_homeChart#'
			</cfif>
		</cfif>
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getUserFilter">
	<cfscript>
		 userFilter = StructNew();
		 userFilter.username = request.authUser;
		 userFilter.access_level = session.access_level;
		 userFilter.curr_proj_chart = session.curr_proj_chart;
		 userFilter.curr_proj_rc = session.curr_proj_rc;
	</cfscript>
	<cfreturn userFilter />
</cffunction>

<cffunction name="getRegionalApprovalList">
	<cfset regApprovalList = getAllV9Fees("regional")>
	<cfreturn regApprovalList>
</cffunction>

<cffunction name="createCrossTabList">
	<cfquery name="xTabInstCds" datasource="#application.datasource#">
		SELECT DISTINCT INST_CD FROM #application.allFeesTable# WHERE ACTIVE = 'Y' ORDER BY 1 ASC
	</cfquery>
	<cfset xTabList = arrayNew(1)>
	<cfset ArrayAppend(xTabList,"ALLFEE_MASTERID text")>
	<cfset ArrayAppend(xTabList,"FEE_DESC_LONG text")>
	<cfset ArrayAppend(xTabList,"ACTIVE text")>
	<cfloop query="xTabInstCds">
		<cfset thisUn = #INST_CD# & " text">
		<cfset ArrayAppend(xTabList,thisUn)>
	</cfloop>
	<cfreturn ArrayToList(xTabList)>
</cffunction>

<cffunction name="getRegionalGrid">
	<cfset rangeDef = createCrossTabList()>
	<!--- NOTE: The FEE_DESC_LONG JOIN below is to resolve conflicts in FEE_DESC_LONG in the crosstab.  Can't predict who wins the naming war.  See Nate for this mess --->
	<cfquery name="getRG" datasource="#application.datasource#">
		SELECT * FROM crosstab
		('SELECT v9.ALLFEE_MASTERID, v9b.FEE_DESC_LONG, v9.ACTIVE, v9.INST_CD, v9.fee_current
		 FROM #application.allFeesTable# v9
		 INNER JOIN (SELECT DISTINCT ALLFEE_MASTERID, MAX(FEE_DESC_LONG) AS FEE_DESC_LONG
		             FROM #application.allFeesTable#
		             WHERE fiscal_year = ''#application.fiscalyear#''
		             GROUP BY ALLFEE_MASTERID) v9b
		   ON v9.ALLFEE_MASTERID = v9b.ALLFEE_MASTERID
		 WHERE v9.FEE_TYPE IN (''ADM'',''CRS'') AND v9.ACTIVE = ''Y'' AND v9.ALLFEE_MASTERID IS NOT NULL AND LENGTH(v9.ALLFEE_MASTERID) = 11 and fiscal_year = ''#application.fiscalyear#''
		 ORDER BY v9b.FEE_DESC_LONG ASC',
		 'SELECT DISTINCT INST_CD FROM #application.allFeesTable# WHERE ACTIVE =''Y'' ORDER BY 1 ASC')
		AS
		(  #rangeDef#
		)
	</cfquery>
	<cfreturn getRG>
</cffunction>

<cffunction name="getAllV9Fees" >
	<cfargument name="pendingStatus" required="false" default="none">
	<cfargument name="givenFeeType" required="false" default="none">
	<cfset userFilter = getUserFilter() >
	<cfset curr_INST_CD = 'IU' & MID(userFilter.curr_proj_chart,1,2) & 'A'>
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT allfee_id, allfee_masterid, allfee_groupid, local_id, local_masterid, fiscal_year, inst_cd, fee_type, fee_typ_desc, unit_basis, fee_desc_long, fee_desc_billing, fee_desc_web, fee_current, fee_lowyear, fee_highyear, yr1_est_vol, yr2_est_vol, xfactor, yfactor, fee_begin_term, dyn_org_ind, cost_desc_item1, cost_desc_item2, cost_amt_item1, cost_amt_item2, sis_itemtype, sis_type, account_nbr, sub_account_nbr, wo_account_nbr, rec_account_nbr, cy_est_vol, obj_cd, dept_id, fee_owner, replacement_fee, replacement_ind, fee_distance, meta, fee_note, approval_lvl, need_for_fee, further_justify, active, fee_status, cohort, fee_residency, fee_level, summer_ind, set_id
	FROM #application.allFeesTable#
		WHERE FISCAL_YEAR = '#application.fiscalyear#' AND ACTIVE = 'Y'
		<cfif MID(session.ACCESS_LEVEL,1,2) neq 'ua'>
		  AND INST_CD = '#curr_INST_CD#'
		</cfif>
		<cfif MID(userFilter.access_level,3,2) neq "us">
			 AND FEE_OWNER = '#userFilter.curr_proj_rc#'
		</cfif>

		<cfif givenFeeType eq 'none'>
		  AND FEE_TYPE IN ('ADM', 'CRS')
		<cfelseif givenFeeType eq 'Campus'>
		  AND FEE_TYPE IN ('CMP')
		</cfif>


		<cfif pendingStatus eq "none">
			AND FEE_STATUS IN ('Approved FY19','CFO Approved')
		<cfelseif pendingStatus eq "all">

		<cfelseif pendingStatus eq "pending">
			AND FEE_STATUS = 'Pending'
		<cfelse>
			AND FEE_STATUS NOT IN ('Approved FY19','CFO Approved')
		</cfif>
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getFeeData_forExcel" >
	<cfargument name="pendingStatus" required="false" default="none">
	<cfset userFilter = getUserFilter() >
	<cfset curr_INST_CD = 'IU' & MID(userFilter.curr_proj_chart,1,2) & 'A'>
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT ALLFEE_ID "ID",
		  ALLFEE_MASTERID "MASTER ID",
		  FEE_OWNER "OWNER",
		  FISCAL_YEAR "FY",
		  INST_CD "Campus",
		  TO_NUMBER(fee_current) "FY19 Amount",
		  TO_NUMBER(fee_lowyear) "FY20 Amount",
		  TO_NUMBER(fee_highyear) "FY21 Amount",
		  FEE_DESC_BILLING "Fee Desc Billing",
		  FEE_TYPE "Type",
		  UNIT_BASIS "Unit",
		  APPROVAL_LVL "Approval Level",
		  SIS_ITEMTYPE "SIS Item Type",
		  SIS_TYPE "SIS Type",
		  ACCOUNT_NBR "Revenue Acct",
		  SUB_ACCOUNT_NBR "Sub Acct",
		  OBJ_CD "Object Code",
		  FEE_STATUS "Status",
		  WO_ACCOUNT_NBR "Bad Debt Acct",
		  LOCAL_ID "Local ID",
		  FEE_DESC_LONG "Fee Desc Long",
		  FEE_DESC_WEB "Fee Desc Web",
		  NEED_FOR_FEE "Need for Fee",
		  FURTHER_JUSTIFY "Addl Justification"
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  AND FEE_TYPE IN ('ADM', 'CRS','PUR')
			AND INST_CD = '#curr_INST_CD#'
		<cfif MID(userFilter.access_level,3,2) neq "us">
			 AND FEE_OWNER = '#userFilter.curr_proj_rc#'
		</cfif>
		<cfif pendingStatus neq "none">
			AND FEE_STATUS NOT IN ('Approved FY19')
		</cfif>
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getCampusFeeData_forExcel" >
	<!---<cfargument name="pendingStatus" required="false" default="none">--->
	<cfset userFilter = getUserFilter() >
	<cfset curr_INST_CD = 'IU' & MID(userFilter.curr_proj_chart,1,2) & 'A'>
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT ALLFEE_ID "ID",
		  ALLFEE_MASTERID "MASTER ID",
		  FEE_OWNER "OWNER",
		  FISCAL_YEAR "FY",
		  INST_CD "Campus",
		  TO_NUMBER(fee_current) "FY19 Amount",
		  TO_NUMBER(fee_lowyear) "FY20 Amount",
		  TO_NUMBER(fee_highyear) "FY21 Amount",
		  FEE_DESC_BILLING "Fee Desc Billing",
		  FEE_TYPE "Type",
		  UNIT_BASIS "Unit",
		  APPROVAL_LVL "Approval Level",
		  SIS_ITEMTYPE "SIS Item Type",
		  SIS_TYPE "SIS Type",
		  ACCOUNT_NBR "Revenue Acct",
		  SUB_ACCOUNT_NBR "Sub Acct",
		  OBJ_CD "Object Code",
		  FEE_STATUS "Status",
		  WO_ACCOUNT_NBR "Bad Debt Acct",
		  LOCAL_ID "Local ID",
		  FEE_DESC_LONG "Fee Desc Long",
		  FEE_DESC_WEB "Fee Desc Web",
		  NEED_FOR_FEE "Need for Fee",
		  FURTHER_JUSTIFY "Addl Justification"
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  AND FEE_TYPE = ('CMP')
			AND INST_CD = '#curr_INST_CD#'
		<cfif MID(userFilter.access_level,3,2) neq "us">
			 AND FEE_OWNER = '#userFilter.curr_proj_rc#'
		</cfif>
<!---		<cfif pendingStatus neq "none">
			AND FEE_STATUS NOT IN ('Approved FY19')
		</cfif>--->
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getAllFeeData_forExcel" >
	<cfset userFilter = getUserFilter() >
	<cfset curr_INST_CD = 'IU' & MID(userFilter.curr_proj_chart,1,2) & 'A'>
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT ALLFEE_ID "ID",
		  ALLFEE_MASTERID "MASTER ID",
		  FEE_OWNER "OWNER",
		  FISCAL_YEAR "FY",
		  INST_CD "Campus",
		  TO_NUMBER(fee_current) "FY19 Amount",
		  TO_NUMBER(fee_lowyear) "FY20 Amount",
		  TO_NUMBER(fee_highyear) "FY21 Amount",
		  FEE_DESC_BILLING "Fee Desc Billing",
		  CASE
		    WHEN LENGTH(COHORT) > 0 THEN COHORT || ' cohort'
		    ELSE COHORT
		  END as "Cohort",
		  FEE_TYPE "Type",
		  UNIT_BASIS "Unit",
		  APPROVAL_LVL "Approval Level",
		  SIS_ITEMTYPE "SIS Item Type",
		  SIS_TYPE "SIS Type",
		  ACCOUNT_NBR "Revenue Acct",
		  SUB_ACCOUNT_NBR "Sub Acct",
		  OBJ_CD "Object Code",
		  FEE_STATUS "Status",
		  WO_ACCOUNT_NBR "Bad Debt Acct",
		  LOCAL_ID "Local ID",
		  FEE_DESC_LONG "Fee Desc Long",
		  FEE_DESC_WEB "Fee Desc Web",
		  NEED_FOR_FEE "Need for Fee",
		  FURTHER_JUSTIFY "Addl Justification"
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  AND FEE_TYPE IN ('ADM', 'CRS','PUR', 'CMP')
			AND INST_CD = '#curr_INST_CD#'
		<cfif MID(userFilter.access_level,3,2) neq "us">
			 AND FEE_OWNER = '#userFilter.curr_proj_rc#'
		</cfif>
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getMasterList_forExcel" >
	<cfquery name="getFees" datasource="#application.datasource#">
		SELECT ALLFEE_ID "ID",
		  ALLFEE_MASTERID "MASTER ID",
		  FEE_OWNER "OWNER",
		  FISCAL_YEAR "FY",
		  INST_CD "Campus",
		  TO_NUMBER(FEE_CURRENT) "FY19 Amount",
		  TO_NUMBER(FEE_LOWYEAR) "FY20 Amount",
		  TO_NUMBER(FEE_HIGHYEAR) "FY21 Amount",
		  FEE_DESC_BILLING "Fee Desc Billing",
		  CASE
		    WHEN LENGTH(COHORT) > 0 THEN COHORT || ' cohort'
		    ELSE COHORT
		   END as "Cohort",
		  FEE_TYPE "Type",
		  UNIT_BASIS "Unit",
		  APPROVAL_LVL "Approval Level",
		  SIS_ITEMTYPE "SIS Item Type",
		  SIS_TYPE "SIS Type",
		  ACCOUNT_NBR "Revenue Acct",
		  SUB_ACCOUNT_NBR "Sub Acct",
		  OBJ_CD "Object Code",
		  FEE_STATUS "Status",
		  WO_ACCOUNT_NBR "Bad Debt Acct",
		  LOCAL_ID "Local ID",
		  FEE_DESC_LONG "Fee Desc Long",
		  FEE_DESC_WEB "Fee Desc Web",
		  NEED_FOR_FEE "Need for Fee",
		  FURTHER_JUSTIFY "Addl Justification"
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
	</cfquery>
	<cfreturn getFees>
</cffunction>

<cffunction name="getAllLimboFees">
	<cfargument name="pendingStatus" required="false" default="true">
	<cfset limboFees = getAllV9Fees(pendingStatus)>
	<cfreturn limboFees>
</cffunction>

<cffunction name="getCamPendFees">
	<cfargument name="pendingStatus" required="false" default="true">
	<cfargument name="givenRC" required="false" default="#session.curr_proj_rc#">
	<cfset camPendFees = getAllCampusFees(pendingStatus, givenRC)>
	<cfreturn camPendFees>
</cffunction>

<cffunction name="getAllCampusFees">
	<cfargument name="pendingStatus" required="false" default="true">
	<cfargument name="given_homeRC" required="false" type="string" default="">
	<cfset userFilter = getUserFilter() >
	<cfset curr_INST_CD = 'IU' & MID(userFilter.curr_proj_chart,1,2) & 'A'>
	<cfquery name="getCampusFeeInfo" datasource="#application.datasource#">
		SELECT ALLFEE_ID, ALLFEE_MASTERID, FEE_OWNER, FISCAL_YEAR, INST_CD, fee_current,
		  DEPT_ID, FEE_TYPE, UNIT_BASIS, FEE_TYP_DESC, APPROVAL_LVL, SIS_ITEMTYPE, SIS_TYPE, ACCOUNT_NBR, OBJ_CD, ACTIVE, FEE_STATUS,
		  FEE_NOTE, LOCAL_ID, META, SUB_ACCOUNT_NBR, WO_ACCOUNT_NBR, REC_ACCOUNT_NBR, CY_EST_VOL, REPLACEMENT_FEE, NEED_FOR_FEE,
		  FURTHER_JUSTIFY, fee_lowyear, fee_highyear, FEE_DESC_LONG, FEE_DESC_BILLING, FEE_DESC_WEB, YR1_EST_VOL, YR2_EST_VOL, FEE_BEGIN_TERM,
		  DYN_ORG_IND, COST_DESC_ITEM1, COST_DESC_ITEM2, COST_AMT_ITEM1, COST_AMT_ITEM2, REPLACEMENT_IND, FURTHER_JUSTIFY
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' and
		FEE_TYPE IN ('CMP','PUR') AND ACTIVE = 'Y'
		  AND INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#curr_INST_CD#">
		<cfif LEN(given_homeRC) AND given_homeRC neq 'us'>
			AND FEE_OWNER = <cfqueryparam cfsqltype="cf_sql_char" value="#given_homeRC#">
		</cfif>
		<cfif pendingStatus eq true>
			AND FEE_STATUS IN ('Approved FY19','Campus Approved')
		<cfelse>
			AND FEE_STATUS NOT IN ('Approved FY19','CFO Approved','Campus Approved')
		</cfif>
	</cfquery>
	<cfreturn getCampusFeeInfo>
</cffunction>

<cffunction name="setupFeeSheet" hint="Set up the main Approved fees sheet">
	<cfargument name="workbookName" required="true" type="string" hint="The main worksheet you want to which you want to append another sheet.">
	<cfargument name="feeSheetName" required="true" type="string" hint="Name you want to appear on the sheet name tab">
	<cfscript>
		SpreadSheetCreateSheet(workbookName, feeSheetName);
	</cfscript>
	<cfreturn true>
</cffunction>

<cffunction name="configureFeeWorksheet" hint="Add title and column headers to the given sheet">
	<cfargument name="givenSheet" required="true" type="any" hint="The sheet you want to configure">
	<cfargument name="sheetTitle" type="any" required="true" hint="Title appearing at the top of the sheet">
	<!--- Add Excel title row 1 --->
	<cfset SpreadsheetAddRow(givenSheet,sheetTitle)>
	<cfset SpreadsheetMergeCells(givenSheet,1,1,1,25)>
	<cfset SpreadsheetSetRowHeight(givenSheet,1,40)>
	<!--- Add Excel title row 2 --->
	<cfset SpreadsheetAddRow(givenSheet,"#application.latestApprovedFeeYear#")>
    <!--- Add column headers  --->
	<cfset SpreadsheetAddRow(givenSheet, "ID, MASTER ID, OWNER, FY, Campus, FY21 Amount, FY22 Amount, FY23 Amount, Fee Desc Billing, Cohort, Type, Unit, Approval Level, SIS Item Type, SIS Type, Revenue Acct, Sub Acct, Object Code, Status,  Bad Debt Acct,  Local ID, Fee Desc Long, Fee Desc Web, Need for Fee, Addl Justification")>
	<!---<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),3)>--->
	<cfset SpreadsheetSetRowHeight(givenSheet,1,30)>
	<!--- Set up columns - widths are determined manually by adjusting the column titles.  If you change the titles, then you may need to change the widths. --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,1,14)>   <!--- ALLFEE_ID --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,2,14)>   <!--- ALLFEE_MASTERID --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,3,10)>   <!--- FEE_OWNER --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,4,9)>   <!--- FISCAL_YEAR --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,5,9)>    <!--- INST_CD --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,6,16)>  <!--- fee_current --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,7,15)>  <!--- fee_lowyear  --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,8,15)>  <!--- fee_highyear  --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,9,24)>   <!--- FEE_DESC_BILLING --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,10,15)>   <!--- COHORT --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,11,9)>  <!--- FEE_TYPE --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,12,9)>  <!--- UNIT_BASIS --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,13,15)>  <!--- APPROVAL_LVL --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,14,12)>  <!--- SIS_ITEMTYPE --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,15,12)>  <!--- SIS_TYPE --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,16,16)>  <!--- REVENUE ACCOUNT_NBR --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,17,15)>  <!--- SUB ACCOUNT_NBR --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,18,12)>   <!--- OBJ_CD --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,19,12)>  <!--- FEE_STATUS --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,20,16)>  <!--- BAD DEBT ACCOUNT --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,21,12)>  <!--- LOCAL_ID --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,22,24)>  <!--- FEE_DESC_LONG  --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,23,24)>  <!--- FEE_DESC_WEB  --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,24,15)>  <!--- NEED_FOR_FEE  --->
	<cfset SpreadsheetSetColumnWidth(givenSheet,25,15)>  <!--- FURTHER_JUSTIFY  --->

	<!--- formatting columns --->
	<!---<cfset SpreadsheetFormatColumn(sObj, {dataformat="$00000.00"}, 4)>  example of formatting a column as currency --->
	<!---<cfset SpreadSheetSetColumnWidth(sObj, 14, 0)> example of hiding a column by setting the width = 0  --->
	<!--- <cfset spreadsheetFormatColumn(sheet, {dataformat='[Green]"Y";;[Red]"N"'}, "1-2")>   --->
	<cfreturn true>
</cffunction>

<cffunction name="setupAllFeesTemplate" hint="Setup details for All Fees Master List Excel template" >
	<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
	<cfset sheet = SpreadSheetNew("Non-instructional Fees","yes")>
	<cfscript>
		setupFeeSheet(sheet,"Campus Fees");
		setupFeeSheet(sheet,"All Fees");
		configureFeeWorksheet(sheet,"Indiana University Budget Office - Non-instructional Fees Master List");
		SpreadsheetSetActiveSheetNumber(sheet,2);
		configureFeeWorksheet(sheet,"Indiana University Budget Office - Campus Fees List");
		SpreadsheetSetActiveSheetNumber(sheet,3);
		configureFeeWorksheet(sheet,"Indiana University Budget Office - Master Fee List");
		SpreadsheetSetActiveSheetNumber(sheet,1);
	</cfscript>
	<cfreturn sheet />
</cffunction>

<cffunction name="setupMasterFeesTemplate" hint="Setup details for Excel" >
	<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
	<cfset sheet = SpreadSheetNew("Master Fee List","yes")>
	<cfscript>
		configureFeeWorksheet(sheet,"Indiana University Budget Office - Master Fee List");
		SpreadsheetSetActiveSheetNumber(sheet,1);
	</cfscript>
	<cfreturn sheet />
</cffunction>

<!--- ********* EDIT CHECKS FOR FEE RATES *********** --->
<cffunction name="getCheckDupes" output="true">
	<cfquery name="getDupes" datasource="#application.datasource#">
		SELECT ALLFEE_ID, COUNT(ALLFEE_ID)
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		GROUP BY ALLFEE_ID
		HAVING COUNT(ALLFEE_ID) > 1
	</cfquery>
	<cfif getDupes.RecordCount gt 0>
		<cfreturn getDupes>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getFeeTypeCounts" >
	<cfquery name="getCounts" datasource="#application.datasource#">
		SELECT DISTINCT INST_CD, FEE_TYPE, FEE_TYP_DESC, UNIT_BASIS, COUNT(ALLFEE_ID) AS "TOTAL_COUNT"
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		GROUP BY INST_CD, FEE_TYPE, FEE_TYP_DESC, UNIT_BASIS
		ORDER BY FEE_TYPE ASC
	</cfquery>
	<cfreturn getCounts>
</cffunction>

<cffunction name="getFeeInfoByAllfeeID">
	<cfargument name="givenAllFeeID" required="true" hint="AllFee_ID must be given in order to retrieve record.">
	<cfargument name="givenFeeType" required="false" hint="Given when requesting a New Fee" default="">
	<cfquery name="getFeeInfo" datasource="#application.datasource#">
		SELECT ALLFEE_ID,
		  ALLFEE_MASTERID,
		  FEE_OWNER,
		  FISCAL_YEAR,
		  INST_CD,
		  fee_current,
		  DEPT_ID,
		  FEE_TYPE,
		  UNIT_BASIS,
		  FEE_TYP_DESC,
		  APPROVAL_LVL,
		  SIS_ITEMTYPE,
		  SIS_TYPE,
		  ACCOUNT_NBR,
		  OBJ_CD,
		  ACTIVE,
		  FEE_STATUS,
		  FEE_NOTE,
		  LOCAL_ID,
		  META,
		  SUB_ACCOUNT_NBR,
		  WO_ACCOUNT_NBR,
		  REC_ACCOUNT_NBR,
		  CY_EST_VOL,
		  REPLACEMENT_FEE,
		  NEED_FOR_FEE,
		  FURTHER_JUSTIFY,
		  fee_lowyear,
		  fee_highyear,
		  FEE_DESC_LONG,
		  FEE_DESC_BILLING,
		  FEE_DESC_WEB,
		  YR1_EST_VOL,
		  YR2_EST_VOL,
  		  FEE_BEGIN_TERM,
  		  DYN_ORG_IND,
  		  COST_DESC_ITEM1,
  		  COST_DESC_ITEM2,
  		  COST_AMT_ITEM1,
  		  COST_AMT_ITEM2,
 		  REPLACEMENT_IND,
  		  FURTHER_JUSTIFY
		FROM #application.allFeesTable#
		WHERE ALLFEE_ID = <cfqueryparam cfsqltype="cf_sql_char" maxlength="11" value="#givenAllFeeID#">
		  AND FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
	</cfquery>
	<cfif getFeeInfo.recordCount lt 1>
		<cfset getFeeInfo = createBlankFeeInfo(givenAllFeeID,givenFeeType) >
	</cfif>
	<cfreturn getFeeInfo />
</cffunction>

<cffunction name="createBlankFeeInfo">
	<cfargument name="givenAllFeeID" required="true" hint="AllFee_ID must be given in order to retrieve record.">
	<cfargument name="givenFeeType" required="true" hint="Given when requesting a New Fee">
	<cfset curr_inst_cd = "IU" & #MID(SESSION.curr_proj_chart,1,2)# & "A">
	<cfquery name="getFeeInfo" datasource="#application.datasource#">
		SELECT
		'#givenAllFeeID#' ALLFEE_ID,
		  '' ALLFEE_MASTERID,
		  '#SESSION.curr_proj_rc#' FEE_OWNER,
		  '' FISCAL_YEAR,
		  '#curr_inst_cd#' INST_CD,
		  '0.00' fee_current,
		  '' DEPT_ID,
		  'CRS' FEE_TYPE,
		  '' UNIT_BASIS,
		  '' FEE_TYP_DESC,
		  '' APPROVAL_LVL,
		  '' SIS_ITEMTYPE,
		  '' SIS_TYPE,
		  '' ACCOUNT_NBR,
		  '' OBJ_CD,
		  '' ACTIVE,
		  '' FEE_STATUS,
		  '' FEE_NOTE,
		  '' LOCAL_ID,
		  '' META,
		  '' SUB_ACCOUNT_NBR,
		  '' WO_ACCOUNT_NBR,
		  '' REC_ACCOUNT_NBR,
		  '' CY_EST_VOL,
		  '' REPLACEMENT_FEE,
		  '' NEED_FOR_FEE,
		  '' FURTHER_JUSTIFY,
		  '0.00' fee_lowyear,
		  '0.00' fee_highyear,
		  '' FEE_DESC_LONG,
		  '' FEE_DESC_BILLING,
		  '' FEE_DESC_WEB,
		  '' YR1_EST_VOL,
		  '' YR2_EST_VOL
		FROM DUAL
	</cfquery>
	<cfreturn getFeeInfo>
</cffunction>

<cffunction name="getDistinctOwners">
	<cfargument name="givenCampus" required="false" type="string" default="none">
	<cfquery name="getDistinctOwners" datasource="#application.datasource#" >
		SELECT DISTINCT FEE_OWNER FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		ORDER BY FEE_OWNER ASC
	</cfquery>
	<cfreturn getDistinctOwners>
</cffunction>

<cffunction name="getDistinctFeeTypes">
	<cfargument name="givenCampus" required="false" type="string" default="none">
	<cfquery name="getDistinctFTypes" datasource="#application.datasource#" >
		SELECT DISTINCT FEE_TYPE FROM #application.allFeesTable#
		WHERE ACTIVE = 'Y'
		<cfif givenCampus neq 'none'>AND INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#"></cfif>
		ORDER BY FEE_TYPE ASC
	</cfquery>
	<cfreturn ValueList(getDistinctFTypes.fee_type)>
</cffunction>

<cffunction name="getDistinctFeeStatus">
	<cfscript>
		roleTypeStruct = StructNew();
		roleTypeStruct.bursar = "BursarOK,Bursar Returned";
		roleTypeStruct.campus = "CampusOK,Campus Returned,Campus Denied,Campus Approved,Pending";
		roleTypeStruct.cfo = "CFO Returned,CFO Approved,CFO Denied,Trustee Approved";
		roleTypeStruct.all = "Pending,Submitted New,Submitted Change";
		roleTypeStruct.regional = "RegionalOK,Regional Returned";
		roleTypeStruct.ubo = "UBO Returned,UBO Approved,UBO Denied,Pending";
	</cfscript>
	<cfreturn roleTypeStruct>
</cffunction>

<cffunction name="getPreparedTypeCategories">
	<!--- Group the distinct fee types into their fee solicitation categories --->
	<cfscript>
		var feeCatStruct = [
			'All' = '',
			'All Fees - My Campus' = getDistinctFeeTypes(),
			'Non-instructional' = 'CRS,ADM',
			'Tuition and Mandatory' = 'TUI,MAN',
			'Distance Ed' = '_DE',
			'Housing' = 'HOU',
			'Campus' = 'CMP',
			'Program' = 'PRO'
		];
	</cfscript>
	<cfreturn feeCatStruct />
</cffunction>

<cffunction name="getDistinctAccountNumbersByCampus" >
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfargument name="givenFeeOwner" required="false" type="string" default="none">
	<cfquery name="getDistinctAccounts" datasource="#application.datasource#" >
		SELECT DISTINCT ACCOUNT_NBR FROM #application.allFeesTable#
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		  <!---AND FEE_TYPE = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeType#">--->
		  <cfif givenFeeOwner neq "none">
		  	 AND FEE_OWNER = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeOwner#">
		  </cfif>
		  AND ACCOUNT_NBR IS NOT NULL and FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  ORDER BY ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn getDistinctAccounts>
</cffunction>

<cffunction name="getDistinctSubAccountNumbersByCampus">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfquery name="getDistinctSubAccounts" datasource="#application.datasource#" >
		SELECT DISTINCT SUB_ACCOUNT_NBR FROM #application.allFeesTable#
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		  AND FEE_TYPE = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeType#">
		  AND FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND SUB_ACCOUNT_NBR IS NOT NULL
		ORDER BY SUB_ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn getDistinctSubAccounts>
</cffunction>

<cffunction name="getDistinctWOAccountNumbersByCampus">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfquery name="getDistinctWOAccounts" datasource="#application.datasource#" >
		SELECT DISTINCT WO_ACCOUNT_NBR FROM #application.allFeesTable#
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		  AND FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND WO_ACCOUNT_NBR IS NOT NULL
		ORDER BY WO_ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn getDistinctWOAccounts>
</cffunction>

<cffunction name="getDistinctRecAccountNumbersByCampus">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfargument name="givenFeeOwner" required="false" type="string" default="none">
	<cfquery name="getDistinctRecAccounts" datasource="#application.datasource#" >
		SELECT DISTINCT REC_ACCOUNT_NBR FROM #application.allFeesTable#
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#"> and
		  FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  <cfif givenFeeOwner neq "none">
		  	 AND FEE_OWNER = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeOwner#">
		  </cfif>
		  AND REC_ACCOUNT_NBR IS NOT NULL
		ORDER BY REC_ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn getDistinctRecAccounts>
</cffunction>

<cffunction name="getDistinctObjectCodesByCampus" >
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfargument name="givenFeeOwner" required="false" type="string" default="none">
	<cfquery name="getDistinctObjCds" datasource="#application.datasource#" >
		SELECT DISTINCT OBJ_CD FROM #application.allFeesTable#
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		 <!--- AND FEE_TYPE = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeType#">--->
		  <cfif givenFeeOwner neq "none">
		  	 AND FEE_OWNER = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeOwner#">
		  </cfif>
		  AND FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND OBJ_CD IS NOT NULL
		ORDER BY OBJ_CD ASC
	</cfquery>
	<cfreturn getDistinctObjCds>
</cffunction>

<cffunction name="getDistinctUnitBasisByFeeType" >
	<cfargument name="givenFeeType" required="true" type="string">
	<cfquery name="getDistinctUnitsBasis" datasource="#application.datasource#" >
		SELECT DISTINCT UNIT_BASIS FROM #application.allFeesTable#
		WHERE FEE_TYPE = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFeeType#">
		  AND FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND UNIT_BASIS IS NOT NULL
		ORDER BY UNIT_BASIS ASC
	</cfquery>
	<cfreturn getDistinctUnitsBasis>
</cffunction>

<cffunction name="getDistinctBeginTerms">
	<cfquery name="getDistinctTerms" datasource="#application.datasource#" >
		SELECT 'A' FBT_ORDER, '4218' FEE_BEGIN_TERM, 'FY22 - Fall 2021' FEE_BEGIN_DESC FROM DUAL
		UNION SELECT 'B' FBT_ORDER, '4222' FEE_BEGIN_TERM, 'FY22 - Spring 2022' FEE_BEGIN_DESC FROM DUAL
		UNION SELECT 'C' FBT_ORDER, '4225' FEE_BEGIN_TERM, 'FY22 - Summer 2022' FEE_BEGIN_DESC FROM DUAL
		UNION SELECT 'D' FBT_ORDER, '4228' FEE_BEGIN_TERM, 'FY23 - Fall 2022' FEE_BEGIN_DESC FROM DUAL
		UNION SELECT 'E' FBT_ORDER, '4232' FEE_BEGIN_TERM, 'FY23 - Spring 2023' FEE_BEGIN_DESC FROM DUAL
		UNION SELECT 'F' FBT_ORDER, '4235' FEE_BEGIN_TERM, 'FY23 - Summer 2023' FEE_BEGIN_DESC FROM DUAL
		ORDER BY FBT_ORDER ASC
	</cfquery>
	<cfreturn getDistinctTerms>
</cffunction>

<cffunction name="fetchHighestCurrent_AllFeeID_Number" >
	<cfquery name="highestNumber" datasource="#application.datasource#">
		SELECT MAX(SUBSTR(ALLFEE_ID,6,6)) MAX_ID FROM #application.allFeesTable#
	</cfquery>
	<cfreturn highestNumber>
</cffunction>

<cffunction name="createNext_AllFeeID">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfargument name="givenRC" required="true" type="string">
	<cfset highestNumber = fetchHighestCurrent_AllFeeID_Number()>
	<cfset highestNumeric = LSParseNumber(highestNumber.MAX_ID)>
	<cfif highestNumeric lt 10000>
		<cfset leadZeroes = "00">
	<cfelseif highestNumeric lt 100000>
		<cfset leadZeroes = "0">
	<cfelse>
		<cfset leadZeroes = "">
	</cfif>
	<cfset nextAvailableNumber = "">
	<cfset newAllFeeID = givenCampus & givenFeeType & leadZeroes & (highestNumeric + 1)>

	<cfswitch expression="givenFeeType">
		<cfcase value="CRS"><cfset impliedFEE_TYP_DESC = "Course Fee"></cfcase>
		<cfcase value="CMP"><cfset impliedFEE_TYP_DESC = "Campus Fee"></cfcase>
		<cfcase value="ADM"><cfset impliedFEE_TYP_DESC = "Administrative Fee"></cfcase>
		<cfcase value="TUI"><cfset impliedFEE_TYP_DESC = "Tuition"></cfcase>
		<cfcase value="MAN"><cfset impliedFEE_TYP_DESC = "Mandatory Fee"></cfcase>
		<cfcase value="OTH"><cfset impliedFEE_TYP_DESC = "Other Mandatory Fee"></cfcase>
		<cfdefaultcase><cfset impliedFEE_TYP_DESC = "Error"></cfdefaultcase>
	</cfswitch>

	<cfset newFeeRecorded = reserveNewBlankFee(newAllFeeID,givenCampus,givenFeeType,givenRC)>
	<cfif newFeeRecorded.recordcount gt 0>
		<cfreturn newAllFeeID>
	<cfelse>
		<cfreturn newFeeRecorded.recordcount>
	</cfif>
</cffunction>

<cffunction name="reserveNewBlankFee">
	<cfargument name="givenAllFeeID" required="true" type="string">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="givenFeeType" required="true" type="string">
	<cfargument name="givenFeeOwner" required="true" type="string">
	<cfquery name="insertAllFeeID"  datasource="#application.datasource#" result="insertResult">
		INSERT INTO #application.allFeesTable#
  		( ALLFEE_ID, ALLFEE_MASTERID, FEE_OWNER, FISCAL_YEAR, INST_CD, fee_current, DEPT_ID,	FEE_TYPE, UNIT_BASIS, FEE_TYP_DESC, APPROVAL_LVL, SIS_ITEMTYPE, SIS_TYPE, ACCOUNT_NBR, OBJ_CD, ACTIVE, FEE_STATUS,FEE_NOTE, LOCAL_ID, META, SUB_ACCOUNT_NBR, WO_ACCOUNT_NBR, REC_ACCOUNT_NBR, CY_EST_VOL, REPLACEMENT_FEE, NEED_FOR_FEE, FURTHER_JUSTIFY,fee_lowyear, fee_highyear, FEE_DESC_LONG, FEE_DESC_BILLING, FEE_DESC_WEB,COST_DESC_ITEM1, COST_DESC_ITEM2, COST_AMT_ITEM1,COST_AMT_ITEM2, YR1_EST_VOL, YR2_EST_VOL, FEE_BEGIN_TERM)
  		VALUES
  		('#givenAllFeeID#', '', '#givenFeeOwner#','#application.latestApprovedFeeYear#', 'IU#givenCampus#A', '0.00','','#givenFeeType#', '','','','','','','','Y','Pending','#REQUEST.authUser# created this new fee.','','','','','','','','','','0.00','0.00','','New fee','','','','','','','','#application.default_begin_term#')
	</cfquery>
	<cfset updatedLevels = updatePendingApprovalLevels()>
	<cfset setFeeTypDesc()>
	<cfreturn insertResult>
</cffunction>

<cffunction name="updateFeeRate">
	<cfargument name="givenCol" required="true" type="string" />
	<cfargument name="givenValue" required="true" type="any" />
	<cfargument name="givenFeeID" required="true" type="string" />
		<!---<cftransaction action="begin">--->
			<cfquery name="updateFeeData" datasource="#application.datasource#">
				UPDATE #application.allFeesTable#
				SET #givenCol# =  <cfqueryparam value="#givenValue#" />
				WHERE allfee_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFeeID#">
				  AND fiscal_year = #application.fiscalyear#
			</cfquery>
		<!---</cftransaction>--->
	<cfreturn true />
</cffunction>

<cffunction name="updateEveryFieldYouCan">
	<cfargument name="submittedForm" type="struct" required="true">
	<cfset colnames = getAllFeesColumnNames()>
	<cfset counter = 1>
	<cfset queryString = "UPDATE " & #application.allFeesTable# & " SET ">
	<cfif NOT StructKeyExists(submittedForm,"DYN_ORG_IND")>
			<cfset queryString = queryString & " DYN_ORG_IND = '0'   ">
			<cfif counter gt 0><cfset queryString = queryString & ", "></cfif>
	</cfif>
	<cfloop array="#colnames#" index="i">
		<cfif ListFindNoCase(submittedForm.FIELDNAMES,i) AND i NEQ "ALLFEE_ID" AND COMPARE(submittedForm[i],"false")>
			<cfset formDetail = REReplace(submittedForm[i],"[^A-Za-z0-9+##\-_.:/ ]","","ALL")>
			<cfset queryString = queryString & " " & #i# & " = '" & #formDetail# & "' ">
			<cfif counter gt 0><cfset queryString = queryString & ", "></cfif>
			<cfset counter = counter + 1>
		</cfif>
	</cfloop>

	<cfif StructKeyExists(submittedForm,"CANCEL_BTN")>
		<cfset formDetail = REReplace(submittedForm.CANCEL_BTN,"[^A-Za-z0-9+##\-_.:/ ]","","ALL")>
		<!--- Existing fees will have a FEE_BEGIN_TERM value <= 4188  This is hard-coded as APPLICATION.current_term  --->
		<cfif submittedForm.keyExists("FEE_BEGIN_TERM") AND (submittedForm.FEE_BEGIN_TERM lte application.current_term)>  <!--- pre-existing fee  --->
			<cfset queryString = queryString & " FEE_STATUS = 'Approved FY19', fee_lowyear = '0', fee_highyear = '0'  ">  <!--- re-set it to zeroed values and original status  --->
		<cfelse>  <!--- must be a new fee if the current_term is null or greater than where we are in real time --->
			<cfset queryString = queryString & " ACTIVE = 'N'   ">  <!--- just inactivate it as-is  --->
		</cfif>
	</cfif>
	<cfset queryString = LEFT(queryString, LEN(queryString)-2)>  <!--- Strip off that last " AND " --->
	<cfset queryString = queryString & " WHERE ACTIVE = 'Y' AND ALLFEE_ID = '" & submittedForm.ALLFEE_ID & "'">
	<cfreturn queryString>
</cffunction>

<cffunction name="setStatusForFee">
	<cfargument name="givenStatus" required="true" type="string">
	<cfargument name="givenAllFeeID" required="true" type="string">
	<cfquery name="updateStatus" datasource="#application.datasource#">
		UPDATE #application.allFeesTable#
      	SET FEE_STATUS = <cfqueryparam cfsqltype="cf_sql_char" value="#givenStatus#">
        WHERE ALLFEE_ID = '#givenAllFeeID#' and fiscal_year = '#application.fiscalyear#'
    </cfquery>
</cffunction>

<cffunction name="setFeeTypDesc">
	<cfquery name="updateDesc" datasource="#application.datasource#">
		UPDATE #application.allFeesTable#
		SET FEE_TYP_DESC =
			CASE
		  		WHEN FEE_TYPE = 'CMP' THEN 'Campus Fee'
		  		WHEN FEE_TYPE = 'ADM' THEN 'Administrative Fee'
		  		WHEN FEE_TYPE = 'CRS' THEN 'Course Fee'
		  		ELSE FEE_TYP_DESC
		  	END
        WHERE FEE_TYPE IN ('CMP','ADM','CRS') AND (FEE_TYP_DESC IS NULL OR FEE_TYP_DESC = '')
    </cfquery>
</cffunction>

<cffunction name="getAllFeesColumnNames">
	<cfquery name="colNames"  datasource="#application.datasource#">
		SELECT column_name
		FROM information_schema.columns
		WHERE table_schema = 'fee_user' AND table_name   = <cfqueryparam cfsqltype="cf_sql_char" value="#application.allFeesTable#">
	</cfquery>
	<cfset listOfColumnValues = ValueList(colNames.COLUMN_NAME)>
	<cfset fullArray = ListToArray(listOfColumnValues)>
	<cfreturn fullArray>
</cffunction>

<cffunction name="compareUploadHeaders">
	<!--- take a list of column headers from a database table and make a list of exact matches to the column headers of an uploaded Excel file  --->
	<cfargument name="dbHeaders" required="true" type="any">
	<cfargument name="xlHeaders" required="true" type="any">
	<cfset matchList = StructNew()>
	<cfloop array="#dbHeaders#" index="i">
			<cfif ListFindNoCase(xlHeaders,i)>
				<cfset StructInsert(matchList,i,ListFindNoCase(xlHeaders,i))>
			</cfif>
	</cfloop>
	<cfreturn matchList>
</cffunction>

<cffunction name="getApprovalList">
	<cfargument name="givenRole" required="false" type="string" default="NONE">
	<cfargument name="givenCampus" required="true" type="string">
	<cfargument name="campusSplit" required="false" type="string" default="false">
	<cfquery name="approvalList" datasource="#application.datasource#">
		SELECT ALLFEE_ID, INST_CD, FEE_OWNER, FEE_DESC_BILLING, FEE_TYPE, FEE_TYP_DESC,FEE_STATUS,FEE_BEGIN_TERM,NEED_FOR_FEE,FURTHER_JUSTIFY,
			fee_current,
			TO_NUMBER(fee_current) AS "CY_NUM",
			fee_lowyear,
			TO_NUMBER(fee_lowyear) AS "LY_NUM",
			fee_highyear,
			TO_NUMBER(fee_highyear) AS "HY_NUM"
		FROM #application.allFeesTable#
		WHERE ACTIVE = 'Y'
		  and fiscal_year = '#application.fiscalyear#'
		  AND FEE_TYPE IN ('CRS','ADM') -- ('TUI','MAN','HOU')
		<cfif givenRole eq 'campus'>
	  		AND INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
			AND fee_type in ('CRS','ADM')
		<cfelseif givenRole eq 'regional'>
		  AND FEE_STATUS NOT IN ('Approved FY19','Pending','Campus Returned','Campus Denied','RegionalOK','Bursar Returned','CFO Returned','CFO Approved')
		  AND INST_CD IN ('IUEAA','IUKOA','IUNWA','IUSBA','IUSEA')
		<cfelseif givenRole eq 'bursar'>
		  AND FEE_STATUS IN ('CampusOK','RegionalOK')
		  AND FEE_BEGIN_TERM > <cfqueryparam cfsqltype="cf_sql_char" value="#application.current_term#">
		  AND INST_CD IN ('IUBLA', 'IUINA', 'IUEAA','IUKOA','IUNWA','IUSBA','IUSEA','IUUAA') <!--- TODO: dynamic preference setting  --->
		<cfelseif givenRole eq 'ubo'>
		  AND FEE_STATUS NOT IN ('Approved FY19','Pending','Denied')
		  AND INST_CD IN ('IUBLA', 'IUINA', 'IUEAA','IUKOA','IUNWA','IUSBA','IUSEA') <!--- TODO: dynamic preference setting  --->
		<cfelseif givenRole eq 'cfo'>
		  AND FEE_STATUS IN ('CampusOK','Campus Submitted','BursarOK','RegionalOK')
		  AND FEE_TYPE NOT IN ('CMP')
		  <!--- AND INST_CD IN ('IUBLA', 'IUINA','IUEAA','IUKOA','IUNWA','IUSBA','IUSEA')  TODO: dynamic preference setting  --->
		<cfelse>
			AND INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#givenCampus#">
		</cfif>
	</cfquery>

	<cfreturn approvalList>
</cffunction>

<cffunction name="updatePendingApprovalLevels">  <!--- Called by reserveNewBlankFee() above --->
	<cfargument name="givenApprovalLevel" type="string" default="Campus">
	<cfquery name="updateQuery" datasource="#application.datasource#">
	  UPDATE #application.allFeesTable#
      SET APPROVAL_LVL =
       CASE FEE_TYPE
	     WHEN 'CMP' THEN 'Campus'
         WHEN 'CRS' THEN 'CFO'
         WHEN 'ADM' THEN 'CFO'
         ELSE ''
       END
      WHERE FEE_STATUS != 'Approved FY19' AND APPROVAL_LVL IS NULL AND FEE_TYPE IS NOT NULL and FISCAL_YEAR =  '#application.fiscalyear#'
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="getApprovalSummary">
	<cfargument name="givenRole" default="ALL" required="false" type="string">
	<cfset instCdString = "">
	<cfswitch expression="#LCase(givenRole)#">
		<cfcase value="ubo"><cfset instCdString = 'IUUAA'></cfcase>
		<cfcase value="campus" delimiters=","><cfset instCdString = #givenRole# ></cfcase>
		<cfdefaultcase><cfset instCdString = "do not use this for REGIONAL see logic below"></cfdefaultcase>
	</cfswitch>
	<cfquery name="approvalSummary" datasource="#application.datasource#">
		SELECT DISTINCT INST_CD, FEE_TYP_DESC, FEE_STATUS, COUNT(*)
		FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		<cfif ListFindNoCase("ALL,CFO,BURSAR",givenRole)>
			AND INST_CD IN ('IUBLA','IUINA','IUEAA','IUKOA','IUNWA','IUSBA','IUSEA')
		<cfelseif givenRole eq 'regional'>
			AND INST_CD IN ('IUEAA','IUKOA','IUNWA','IUSBA','IUSEA')
		<cfelse>
			AND INST_CD = '#instCdString#'
		</cfif>
		  AND FEE_STATUS IN ('CampusOK','Campus Approved','RegionalOK','BursarOK')
		  AND FEE_TYPE IN ('CRS','ADM')
		  /*AND FEE_TYPE IN ('TUI','MAN','PRO','_DE','CRS','ADM','HOU') */
		GROUP BY INST_CD, FEE_STATUS, FEE_TYP_DESC
		ORDER BY INST_CD ASC, FEE_STATUS ASC
	</cfquery>
	<cfreturn approvalSummary>
</cffunction>

<cffunction name="setModalText">
	<cfargument name="NEED_FOR_FEE" type="string" required="false" default="No text">
	<cfargument name="FURTHER_JUSTIFY" required="false" default="No text">
	<cfargument name="givenID" type="string" required="true">
	<cfset barg = LEN(TRIM(NEED_FOR_FEE)) + LEN(TRIM(FURTHER_JUSTIFY)) />
	<cfset modalText = "">
	<cfif barg eq 0>
		<cfset modalText = "...">
	<cfelse>
		<cfif LEN(TRIM(NEED_FOR_FEE)) gt 0>
			<cfset modalText = "Need for fee: " & TRIM(NEED_FOR_FEE) & "<br>" />
		</cfif>
		<cfif LEN(TRIM(FURTHER_JUSTIFY)) gt 0>
			<cfset modalText = modalText & "Further justification: " & TRIM(FURTHER_JUSTIFY) & "<br>" />
		</cfif>
		<cfset modalText = modalText & "<br>" & "AllFeeID: " & givenID />
	</cfif>
	<cfreturn modalText>
</cffunction>

<cffunction name="cancelQuery">
	<cfargument name="givenAllFeeID" type="string" required="true">
	<cfquery name="updateActiveSetting" datasource="#application.datasource#">
		 UPDATE #application.allFeesTable#
		 SET ACTIVE = 'N'
		 WHERE ALLFEE_ID = <cfqueryparam cfsqltype="cf_sql_char" value="#givenAllFeeID#"> and
		 FISCAL_YEAR =  '#application.fiscalyear#'
	</cfquery>
	<cfif updateActiveSetting.recordCount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="cancelCommon" access="public" output="false">
    <cfargument name="arrList1" type="any" required="true" />
    <cfargument name="arrList2" type="any" required="true" />
    <cfset arrList1.retainAll(arrList2) />

	<cfloop array="arrList1" index="i">
		<cfset cancelQuery(i)>
	</cfloop>
</cffunction>

<cffunction name="getPreferences">
	<cfquery name="loadUserPrefs" datasource="#application.datasource#">
		SELECT USERNAME, PREF_NM, PREF_VALUE
		FROM PREFERENCES
		WHERE APP_NAME = 'FeePortal'
		ORDER BY USERNAME ASC
	</cfquery>
	<!--- Convert the prefs to a Struct so it is easier to use
	<cfscript>
	        var i = 0;
	        var queryData = StructNew(); var rowData = StructNew();
        	for (i = 1; i lte loadUserPrefs.recordCount; i = i + 1) {
            	rowData = QueryGetRow(loadUserPrefs, i);
            	queryData.rowData['PREF_NM'] = rowData.PREF_VALUE;
            }
	</cfscript>  --->
	<cfreturn loadUserPrefs>
</cffunction>

<cffunction name="addRCDescription">
	<cfargument name="givenRC">
	<cfset rcNameLookup = #application.rcNames[givenRC]#>
	<cfreturn rcNameLookup>
</cffunction>

<cffunction name="getHousingList" >
	<cfquery name="housingList" datasource="#application.datasource#">
		SELECT * FROM #application.allFeesTable#
		WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y' AND FEE_TYPE = 'HOU'
	</cfquery>
	<cfreturn housingList>
</cffunction>

<cffunction name="updateHousing">
	<cfargument name="givenAFID" type="string" required="true">
	<cfargument name="givenFY20" type="string" required="true">
	<cfargument name="givenFY21" type="string" required="true">
	<cftry>
	  <cfquery name="loadHousingUpdate" datasource="#application.datasource#">
			UPDATE #application.allFeesTable#
			SET fee_lowyear = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFY20#">,
			    fee_highyear = <cfqueryparam cfsqltype="cf_sql_char" value="#givenFY21#">
			WHERE ALLFEE_ID = <cfqueryparam cfsqltype="cf_sql_char" value="#givenAFID#"> and
			FISCAL_YEAR =  '#application.fiscalyear#'
	  </cfquery>
	  <cfcatch type="any">
		<cfreturn false>
	  </cfcatch>
	  <cffinally>
 	    <cfreturn true>
	  </cffinally>
	</cftry>
</cffunction>

<cffunction name="updateBursarView">
	<cftransaction>
	<!--- Count the number of existing records we will insert --->
	  	<cftry>
		  	<cfquery name="countSourceFeeRecords" datasource="#application.datasource#">
		  		SELECT count(*) as "sourceTotal" from #application.allFeesTable# where FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
		  	</cfquery>
	  	<cfcatch type="any">
			<cfreturn cfcatch>
	  	</cfcatch>
		</cftry>
	<!--- truncate the target table  --->
		<cftry>
	  		<cfquery name="truncateBursarTable" datasource="#application.datasource#">
	  			DELETE FROM #application.bursarFeesTable#
	  		</cfquery>
	  	<cfcatch type="any">
			<cfreturn cfcatch>
	  	</cfcatch>
		</cftry>
	<!--- insert the records  --->
	  	<cftry>
	  		<cfquery name="rebuildBursarRecords" datasource="#application.datasource#">
	  			INSERT INTO #application.bursarFeesTable# (SELECT * FROM #application.allFeesTable# where FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y')
	  		</cfquery>
	  	<cfcatch type="any">
			<cfreturn cfcatch>
	  	</cfcatch>
		</cftry>
	<!--- count the number of rows in the target table  --->
	  	<cftry>
	  		<cfquery name="countBursarRecords" datasource="#application.datasource#">
	  			SELECT count(*) as "bursarTotal" from #application.bursarFeesTable#
	  		</cfquery>
	  	<cfcatch type="any">
			<cfreturn cfcatch>
	  	</cfcatch>
		</cftry>
	<!--- if #rows does not match expected value, rollback, else commit is implied --->
	  <cfif countSourceFeeRecords.sourceTotal neq countBursarRecords.bursarTotal>
		<cftransaction action="rollback" />
		<cfset errorMsg = 'ERROR - ' & countSourceFeeRecords.sourceTotal & ' source records do not equal ' & countBursarRecords.bursarTotal />
		<cfreturn errorMsg />
	  </cfif>
	</cftransaction>
	<cfreturn countBursarRecords.bursarTotal>
</cffunction>
<!---  ******************************************************************************************** --->






