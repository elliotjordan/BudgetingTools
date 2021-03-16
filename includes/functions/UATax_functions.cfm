<cffunction name="getUATaxUser" output="true">
	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
</cffunction>

<cffunction name="getUATax_data">
 	<cfargument name="givenRC" required="true" default="88">
 	<cfargument name="givenConsObjCd" required="true" default="STFE">
 	<cfargument name="statusScope" required="false" default="Legacy">
 	<cfquery datasource="#application.datasource#" name="UATax_data_raw">
 		SELECT uatax_id, uatax_bin, RC_CD, RC_NM, ORG_CD, ACCOUNT_NBR,ACCOUNT_NM,FIN_OBJECT_CD,
 		0 PRIOR_APPR_BASE, 0 PRIOR_APPR_CASH, 0 REQ_AMOUNT,
 		ADJBASE_AMT,BB_AMT,
 		JUSTIFICATION,REQ_STATUS,SPECIAL_TITLE, ORG_NM
 		FROM fee_user.INTB_UA_TAX
 		WHERE RC_CD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenRC#">
 		  AND FIN_CONS_OBJ_CD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenConsObjCd#">
 		  <cfif statusScope neq false>and lower(req_status) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#statusScope#"></cfif>
 	</cfquery>
 	<cfreturn UATax_data_raw />
</cffunction>

<cffunction name="getUATax_allocByUnit">
	<cfargument name="givenUnit" type="string" required="false" default="NONE">
 	<cfquery datasource="#application.datasource#" name="UATax_alloc_raw">
		SELECT ROW_NUMBER() OVER(ORDER BY RC_CD ASC) AS RowID,
		  RC_CD, RC_NM,
		  SUM(CMPN_SUM) as CMPN_SUM2, SUM(CPTL_SUM) as CPTL_SUM2, SUM(GENX_SUM) as GENX_SUM2,
		  SUM(IDEX_SUM) as IDEX_SUM2, SUM(SCHL_SUM) as SCHL_SUM2, SUM(TRVL_SUM) as TRVL_SUM2,
		  SUM(RSRX_SUM) as RSRX_SUM2,
		  SUM(TOTAL_EXPENSE) as TOTAL_EXPENSE2,
		  SUM(IDIN_SUM) as IDIN_SUM2, SUM(STFE_SUM) as STFE_SUM2, SUM(OTRE_SUM) as OTRE_SUM2,
		  SUM(TOTAL_REVENUE) as TOTAL_REVENUE2,
		  SUM(UA_SUPPORT) as UA_SUPPORT2, SUM(UA_EXP_PCT) as UA_EXP_PCT2, SUM(UA_REV_PCT) as UA_REV_PCT2
		FROM
			(
			 SELECT  RC_CD, RC_NM, CMPN_SUM, CPTL_SUM, GENX_SUM, IDEX_SUM, SCHL_SUM, TRVL_SUM, RSRX_SUM,
			  SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD) as TOTAL_EXPENSE,
			  IDIN_SUM, STFE_SUM, OTRE_SUM,
			  SUM(IDIN_SUM + STFE_SUM + OTRE_SUM) OVER (PARTITION BY RC_CD) as TOTAL_REVENUE,
			  SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD) - SUM(IDIN_SUM + STFE_SUM + OTRE_SUM) OVER (PARTITION BY RC_CD) as UA_SUPPORT,
			  CASE WHEN ( SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD) = 0 ) THEN 1.00
			       ELSE ( SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD) - SUM(IDIN_SUM + STFE_SUM + OTRE_SUM) OVER (PARTITION BY RC_CD) )
			                / SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD)
			  END as UA_EXP_PCT,
			  CASE WHEN ( SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD) = 0 ) THEN 1.00
			       ELSE ( SUM(IDIN_SUM + STFE_SUM + OTRE_SUM) OVER (PARTITION BY RC_CD) )
			                / SUM(CMPN_SUM + CPTL_SUM + GENX_SUM + IDEX_SUM + SCHL_SUM + TRVL_SUM + RSRX_SUM) OVER (PARTITION BY RC_CD)
			  END as UA_REV_PCT
			FROM
			(
				SELECT RC_CD, RC_NM, SUM(CMPN_SUB) as CMPN_SUM, SUM(CPTL_SUB) as CPTL_SUM, SUM(GENX_SUB) as GENX_SUM, SUM(IDEX_SUB) as IDEX_SUM, SUM(RSRX_SUB) as RSRX_SUM, 				SUM(IDIN_SUB) as IDIN_SUM, SUM(OTRE_SUB) as OTRE_SUM, SUM(SCHL_SUB) as SCHL_SUM, SUM(STFE_SUB) as STFE_SUM, SUM(TRSF_SUB) as TRSF_SUM, SUM(TRVL_SUB) as TRVL_SUM,
				  SUM(BB_AMT) as BB_SUM
				FROM (
					SELECT RC_CD, RC_NM,
					  CASE WHEN FIN_CONS_OBJ_CD = 'CMPN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CMPN_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'CPTL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CPTL_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'GENX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as GENX_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'IDEX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDEX_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'IDIN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDIN_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'OTRE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as OTRE_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'RSRX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as RSRX_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'SCHL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as SCHL_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'STFE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as STFE_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'TRSF' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRSF_SUB,
					  CASE WHEN FIN_CONS_OBJ_CD = 'TRVL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRVL_SUB,
					  SUM(FIN_BEG_BAL_LN_AMT) as BB_AMT
					FROM DSS_KFS.GL_BALANCE_V@dss_link
					WHERE FUND_GRP_CD = 'GF'
					  AND (FIN_BALANCE_TYP_CD = 'AC'
					       OR FIN_BALANCE_TYP_CD = 'BB')
					  AND (ACCT_CLOSED_IND = 'N')
					  AND UNIV_FISCAL_YR IN ('2020')
					  AND (ACCOUNT_NBR LIKE '19%')
					  AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
					  <cfif givenUnit eq 'NONE'>AND RC_CD NOT IN ('01','77')<cfelse>AND RC_CD = '77'</cfif>
					GROUP BY RC_CD, RC_NM, FIN_CONS_OBJ_CD
				)
				GROUP BY RC_CD, RC_NM
			)
		)
		GROUP BY ROLLUP(RC_CD,RC_NM)
		ORDER BY RC_CD ASC
 	</cfquery>
 	<cfreturn UATax_alloc_raw />
</cffunction>

<cffunction name="getCampusAssessments" >
	<cfquery name="campAss" datasource="#application.datasource#">
		SELECT fyear, assmt_amt, assmt_delta, delta_pct, recipient, assmt_desc,assmtid
	FROM fee_user.intb_assessments
	</cfquery>
	<cfreturn campAss />
</cffunction>


<cffunction name="getCampusAssmtDetails" >
	<cfargument name="givenAssmtID" type="numeric" required="false" default="ALL">
	<cfquery name="campAssDet" datasource="#application.datasource#">
		SELECT detail_id, assmt_id, assessment_detail, fyear, iubla, iueaa, iuina, iukoa, iunwa, iusba, iusea, iusom, detail_note
	FROM fee_user.intb_assmt_details
	<cfif givenAssmtID neq 'ALL'>
		WHERE assmt_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#givenAssmtID#" >
	</cfif>
	</cfquery>
	<cfreturn campAssDet />
</cffunction>

<cffunction name="getRC77details">
	<cfquery name="rc77details" datasource="#application.datasource#">
		SELECT DISTINCT RC_CD, RC_NM, FIN_CONS_OBJ_CD, FIN_OBJ_LEVEL_CD, FIN_OBJ_LEVEL_NM, FIN_OBJECT_CD, FIN_OBJ_CD_NM, ACCOUNT_NBR, ACCOUNT_NM, SUM(FIN_BEG_BAL_LN_AMT)
		FROM DSS_KFS.GL_BALANCE_V@dss_link
		WHERE FUND_GRP_CD = 'GF'
		  AND (FIN_BALANCE_TYP_CD = 'AC'
		       OR FIN_BALANCE_TYP_CD = 'BB')
		  AND (ACCT_CLOSED_IND = 'N')
		  AND UNIV_FISCAL_YR IN ('2020')
		  AND RC_CD = '77'
		  AND (ACCOUNT_NBR LIKE '19%')
		  AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
		  AND FIN_CONS_OBJ_CD = 'TRSF'
		GROUP BY RC_CD, RC_NM, FIN_CONS_OBJ_CD, FIN_OBJ_LEVEL_CD, FIN_OBJ_LEVEL_NM, FIN_OBJECT_CD, FIN_OBJ_CD_NM,ACCOUNT_NBR, ACCOUNT_NM
		ORDER BY FIN_CONS_OBJ_CD ASC, FIN_OBJ_LEVEL_CD ASC, FIN_OBJECT_CD ASC, ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn rc77details>
</cffunction>

<cffunction name="getDistinctObjLevels" output="true">
	<cfargument name="givenFY" type="string" required="true">
 	<cfquery datasource="#application.datasource#" name="distinctObjLevels">
		SELECT DISTINCT RC_CD, RC_NM, FIN_CONS_OBJ_CD, FIN_OBJ_LEVEL_CD, FIN_OBJ_LEVEL_NM, SUM(FIN_BEG_BAL_LN_AMT) as OBJ_LVL_SUM
		FROM DSS_KFS.GL_BALANCE_V@dss_link
		WHERE FUND_GRP_CD = 'GF'
		  AND (FIN_BALANCE_TYP_CD = 'AC'
		       OR FIN_BALANCE_TYP_CD = 'BB')
		  AND (ACCT_CLOSED_IND = 'N')
		  AND UNIV_FISCAL_YR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFY#">
		  AND (ACCOUNT_NBR LIKE '19%')
		  AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
		GROUP BY RC_CD, RC_NM, FIN_CONS_OBJ_CD, FIN_OBJ_LEVEL_CD, FIN_OBJ_LEVEL_NM
		ORDER BY RC_CD ASC, FIN_CONS_OBJ_CD ASC, FIN_OBJ_LEVEL_CD ASC
 	</cfquery>
 	<cfreturn distinctObjLevels />
</cffunction>

<cffunction name="getAccountNumbers" output="true">
	<cfargument name="currentRC" required="true" type="string">
	<cfquery datasource="#application.datasource#" name="RC_accounts">
		SELECT DISTINCT ACCOUNT_NBR FROM INTB_UA_TAX WHERE RC_CD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currentRC#">
	</cfquery>
	<cfreturn RC_accounts>
</cffunction>

<cffunction name="insertRequest" output="false" returntype="any">
	<cfargument name="rc_cd" required="true" type="string">
	<cfargument name="selectedAcct" required="true" type="string">
	<cfargument name="specialTitle" required="true" type="string">
	<cfargument name="requestedAmt" required="true" type="numeric">
	<cfargument name="justificationDoc" required="true" type="string">
	<cfquery datasource="#application.datasource#" name="insert_funding_request">
		INSERT INTO #application.UATaxTable#
		(UNIV_FISCAL_YR, RC_CD, ACCOUNT_NBR, SPECIAL_TITLE, REQ_AMOUNT, JUSTIFICATION, REQ_FUNDING_CATEGORY, CREATED_BY,CREATED_ON, REQ_STATUS)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#application.latestApprovedFeeYear#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc_cd#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedAcct#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#specialTitle#">,
		 <cfqueryparam cfsqltype="cf_sql_numeric" value="#requestedAmt#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#justificationDoc#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="BASE">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#REQUEST.authUser#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		 		 <cfqueryparam cfsqltype="cf_sql_varchar" value="PENDING">
		 )
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="setupUATaxExcelSheet">
	<cfset sheet = SpreadSheetNew("UA Tax Data")>
	<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - UA Tax Raw Data")>
	<cfset SpreadsheetMergeCells(sheet,1,1,1,18)>
	<cfset SpreadsheetSetRowHeight(sheet,1,40)>
	<cfset SpreadsheetAddRow(sheet, "Request ID, RC Code, RC Name, Account, Prior Request Amount, Prior Approved Base Amount, Prior Approved Cash Amount, Requested Amount, Justification, Request Status, Special Title")>
	<cfset SpreadsheetSetRowHeight(sheet,1,30)>
	<!--- Set up columns - widths are determined manually by adjusting the column titles.  If you change the titles, then you may need to change the widths. --->
	<cfset SpreadsheetSetColumnWidth(sheet,1,10)>   <!--- Request ID --->
	<cfset SpreadsheetSetColumnWidth(sheet,2,10)>   <!--- RC --->
	<cfset SpreadsheetSetColumnWidth(sheet,3,18)>   <!--- RC Name --->
	<cfset SpreadsheetSetColumnWidth(sheet,4,10)>   <!--- Account --->
	<cfset SpreadsheetSetColumnWidth(sheet,5,20)>   <!--- Prior Request Amount --->
	<cfset SpreadsheetSetColumnWidth(sheet,6,28)>   <!--- Prior Approved Base Amount --->
	<cfset SpreadsheetSetColumnWidth(sheet,7,28)>   <!--- Prior Approved Cash Amount --->
	<cfset SpreadsheetSetColumnWidth(sheet,8,20)>   <!--- Request Amount --->
	<cfset SpreadsheetSetColumnWidth(sheet,9,64)>   <!--- Justification --->
	<cfset SpreadsheetSetColumnWidth(sheet,10,18)>  <!--- Request Status --->
	<cfset SpreadsheetSetColumnWidth(sheet,11,64)>  <!--- Special Title --->
	<cfreturn sheet />
</cffunction>

<cffunction name="approveRequest">
	<cfargument name="req_id" required="true" type="numeric" />
	<cfargument name="appr_status" required="true" type="string" />
	<cfquery datasource="#application.datasource#">
		UPDATE #application.UATaxTable#
		SET REQ_STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#appr_status#">
		WHERE REQ_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#req_id#">
		  AND REQ_STATUS != <cfqueryparam cfsqltype="cf_sql_varchar" value="#appr_status#">
	</cfquery>
</cffunction>

<cffunction name="revertRequest">
	<cfargument name="rvrt_string" required="true" type="string" />
	<cfset rvrt_ID = LSParseNumber(REPLACE( rvrt_string,'Undo ','') ) />
	<cfquery datasource="#application.datasource#">
		UPDATE #application.UATaxTable#
		SET REQ_STATUS = 'PENDING'
		WHERE REQ_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rvrt_ID#">
	</cfquery>
</cffunction>

<cffunction name="initIncIncRows">
	<cfquery name="init_II" datasource="#application.datasource#">  <!--- TODO need Shared Services Code from somewhere --->
		SELECT DISTINCT D.FIN_COA_CD, D.ACCOUNT_NBR, D.SUB_ACCT_NBR, D.FIN_OBJECT_CD,
  D.FIN_SUB_OBJ_CD, D.ADJ_BASE_AMT, D.BDGT_PROJ_AMT, (D.ADJ_BASE_AMT - D.BDGT_PROJ_AMT) as "delta",
  s.Iu_Acct_Shr_Srvcs_Cd, s.Rc_Cd, s.Rc_Nm
FROM ii_user.ii_detail_t D
LEFT JOIN (
  SELECT DISTINCT d1.account_nbr, D1.Iu_Acct_Shr_Srvcs_Cd, D1.rc_cd AS RC_cd, D2.Rc_Nm
  FROM ref.bc_acctgrp_t D1 LEFT OUTER JOIN ref.bc_rc_t D2 on D1.Rc_Cd = D2.Rc_Cd
) s ON D.ACCOUNT_NBR = s.Account_nbr
WHERE D.FIN_COA_CD = 'UA'
ORDER BY D.FIN_COA_CD, D.ACCOUNT_NBR, D.SUB_ACCT_NBR, D.FIN_OBJECT_CD, D.FIN_SUB_OBJ_CD, D.ADJ_BASE_AMT, D.BDGT_PROJ_AMT,
s.Iu_Acct_Shr_Srvcs_Cd
	</cfquery>
	<cfreturn init_II>
</cffunction>

<cffunction name="getDistinctOrgs">
    <cfquery name="distinctOrgs" datasource="#application.datasource#">
    	SELECT DISTINCT org_cd, org_nm
		FROM intb_ua_tax
		WHERE univ_fiscal_yr = '2020'
    </cfquery>
    <cfquery name="distinctOrgs_ordered" dbtype="query">
    	SELECT org_cd, org_nm
		FROM distinctOrgs
		ORDER BY org_nm ASC
    </cfquery>
    <cfreturn distinctOrgs_ordered>
</cffunction>

<cffunction name="getOrgRankings">
	<cfargument name="orgCode" required="false" default="NONE">
	<cfquery name="orgRank" datasource="#application.datasource#">
		SELECT DISTINCT org_cd, org_nm, account_nbr, account_nm, count(account_nm) accounts, sum(bb_amt) as money
		FROM intb_ua_tax
		WHERE univ_fiscal_yr = '2020'
		<cfif orgCode neq 'NONE'>
		  and org_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#orgCode#">
		</cfif>
		GROUP BY org_cd, org_nm, account_nbr, account_nm
		HAVING count(account_nm) <> 1
		ORDER BY sum(bb_amt) desc, count(account_nm) desc, org_cd asc, account_nbr asc
	</cfquery>
	<cfreturn orgRank>
</cffunction>

<cffunction name="getDistinctAccts">
    <cfquery name="distinctAccts" datasource="#application.datasource#">
    	SELECT DISTINCT account_nbr, account_nm
		FROM intb_ua_tax
		WHERE univ_fiscal_yr = '2020'
    </cfquery>
    <cfquery name="distinctAccts_ordered" dbtype="query">
    	SELECT account_nbr, account_nm
		FROM distinctAccts
		ORDER BY account_nm ASC
    </cfquery>
    <cfreturn distinctAccts_ordered>
</cffunction>

<cffunction name="getDistinctRCs">
	<cfargument name="exclude77" type="string" required="false" default="true">
	<cfquery name="distinctRCs" datasource="#application.datasource#">
		SELECT DISTINCT rc_cd, rc_nm
		FROM intb_ua_tax
		WHERE univ_fiscal_yr = '2020'
		<cfif exclude77 eq 'true'>
		  AND rc_cd NOT IN ('01','77')
		<cfelse>
		  AND rc_cd != '01'
		</cfif>
		ORDER BY rc_cd ASC
	</cfquery>
	<cfreturn distinctRCs>
</cffunction>

<cffunction name="getDistinctObjConCds">
	<cfquery name="distinctObjCons" datasource="#application.datasource#">
		SELECT DISTINCT fin_cons_obj_cd, fin_cons_obj_nm
		FROM intb_ua_tax
		WHERE univ_fiscal_yr = '2020'
		ORDER BY fin_cons_obj_cd ASC
	</cfquery>
	<cfreturn distinctObjCons>
</cffunction>

<cffunction name="getB7940">
	<cfquery name="historyLines" datasource="#application.datasource#">
		SELECT *
		FROM fee_user.b7940sum_2020v2_adjbasetab
		ORDER BY src_line_nbr ASC
	</cfquery>
	<cfreturn historyLines>
</cffunction>

<cffunction name="getItemCatList">
	<cfquery name="catList" datasource="#application.datasource#">
		SELECT DISTINCT ITEM_CAT
		FROM fee_user.b7940sum_2020v2_adjbasetab
		ORDER BY ITEM_CAT ASC
	</cfquery>
	<cfquery name="orderedCatList" dbtype="query">
		SELECT item_cat
		FROM catList
		WHERE item_cat != '' AND item_cat IS NOT NULL
		ORDER BY item_cat ASC
	</cfquery>
	<cfreturn orderedCatList />
</cffunction>

<cffunction name="getItemSubCatList">
	<cfquery name="subCatList" datasource="#application.datasource#">
		SELECT DISTINCT SUB_CAT
		FROM fee_user.b7940sum_2020v2_adjbasetab
		ORDER BY ITEM_CAT ASC
	</cfquery>
	<cfquery name="orderedSubCatList" dbtype="query">
		SELECT sub_cat
		FROM subCatList
		WHERE sub_cat != '' AND sub_cat IS NOT NULL
		ORDER BY sub_cat ASC
	</cfquery>
	<cfreturn orderedSubCatList />
</cffunction>

<cffunction name="getSpecificItem">
	<cfargument name="givenLineNbr" required="true" type="numeric">
	<cfquery name="B7940item" datasource="#application.datasource#">
		SELECT *
		FROM fee_user.b7940sum_2020v2_adjbasetab
		WHERE src_line_nbr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#givenLineNbr#">
	</cfquery>
	<cfreturn B7940item>
</cffunction>

<cffunction name="updateUATax">
	<cfargument name="givenColumn" type="string" required="true">
	<cfargument name="givenLineNbr" type="string" required="true">
	<cfargument name="givenData" type="string" required="true">
	<cfset dataStamp = dateTimeFormat(Now(),'short') />
	<cfquery name="updateB7940" datasource="#application.datasource#">
		<cfif givenColumn eq "meta">
			UPDATE fee_user.b7940sum_2020v2_adjbasetab
			SET meta = '#givenData# updated line #TRIM(givenLineNbr)# on #dataStamp#'
			WHERE src_line_nbr = '#givenLineNbr#'
		<cfelse>
			UPDATE fee_user.b7940sum_2020v2_adjbasetab
			SET #TRIM(givenColumn)# = '#givenData#'
			WHERE src_line_nbr = '#givenLineNbr#'
		</cfif>
	</cfquery>
</cffunction>

<cffunction name="getAdjBaseTotals">
	<cfargument name="givenSubObjCd" required="false" default="ALL" />
	<cfquery name="fetchAdjBase" datasource="#application.datasource#">
		SELECT src_line_nbr, flag, flag_note, item_cat, sub_cat,
		  meta, unit, fy, item_desc, ua_svc_charge,
		  ua_aux, bloomington, iupui_ga, iupui_som, east,
		  kokomo, northwest, south_bend, southeast, total,
		  note
		FROM fee_user.b7940sum_2020v2_adjbasetab
		WHERE item_cat  = 'CALCULATION' and sub_cat = 'ADJBASE'
		ORDER BY fy asc
	</cfquery>
	<cfreturn fetchAdjBase>
</cffunction>

<cffunction name="getAdjBase_supportingLines">
	<cfargument name="givenSubObjCd" required="false" default="ALL" />
<!---	<cfquery name="fetchAdjBaseSupport" datasource="#application.datasource#">
		SELECT fy, sub_obj_cd, description, ua_svc_chg,
		  ua_aux, iubla, iupui, iusom, iueaa, iukoa, iunwa, iusba, iusea,
		  total, total_w_svc_chg, line_comments
		FROM fee_user.b7940_sum_adjbase_detail
		WHERE 1=1
		  <cfif givenSubObjCd neq 'ALL'>AND sub_obj_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSubObjCd#"></cfif>
		ORDER BY fy asc
	</cfquery>--->
	<cfquery name="fetchAdjBaseSupport" datasource="#application.datasource#">
		SELECT fyear, line_item, line_type, sub_obj, line_title, ua_aux, iubla, iuina, iusom, iueaa, iukoa, iunwa, iusba, iusea, sort_order, allocation, line_notes
		FROM fee_user.intb_b7940_detail
		WHERE 1=1
		  <cfif givenSubObjCd neq 'ALL'>AND sub_obj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSubObjCd#"></cfif>
		ORDER BY fyear desc, sort_order asc
	</cfquery>
	<cfreturn fetchAdjBaseSupport>
</cffunction>

<cffunction name="getGuidelines">
	<cfquery name="fetchAdjBase" datasource="#application.datasource#">
SELECT t.fy, t.account_nbr, t.fin_object_cd,t. FIN_CONS_OBJ_CD, t.fin_sub_obj_cd, t.sub_obj_grouping_cd, t.fin_subobj_group_nm, SUM(t.BB_SUM) as BB_SUM
FROM (
SELECT DISTINCT univ_fiscal_yr as fy, fin_coa_cd, account_nbr, FIN_CONS_OBJ_CD, fin_object_cd, fin_sub_obj_cd,
    CASE
      WHEN fin_sub_obj_cd LIKE '%T' THEN 'xxxT'
      WHEN fin_sub_obj_cd LIKE '%D' THEN 'xxxD'
      WHEN fin_sub_obj_cd = 'IBS' THEN 'IBS' -- do this first so IBS falls out and is not counted in general 'xxxS' total
      WHEN fin_sub_obj_cd LIKE '%S' THEN 'xxxS'
      WHEN fin_sub_obj_cd LIKE 'V%' THEN 'Vxxx'
      WHEN fin_sub_obj_cd = 'UAA' THEN 'UAA'
      ELSE '----'
    END as sub_obj_grouping_cd,
    CASE
      WHEN fin_sub_obj_cd LIKE '%T' THEN 'New Programs and Re-org'
      WHEN fin_sub_obj_cd LIKE '%D' THEN 'Direct Services'
      WHEN fin_sub_obj_cd = 'IBS' THEN 'IUPUI Telecom'
      WHEN fin_sub_obj_cd LIKE '%S' THEN 'Compensation'
      WHEN fin_sub_obj_cd LIKE 'V%' THEN 'IT-SS Compensation'
      WHEN fin_sub_obj_cd = 'UAA' THEN 'UAA Auxiliary'
      ELSE '----'
    END as fin_subobj_group_nm,
    SUM(FIN_BEG_BAL_LN_AMT) as BB_SUM
FROM DSS_KFS.GL_BALANCE_V@dss_link
		WHERE ACCT_CLOSED_IND = 'N'
      AND fin_object_cd LIKE ('99%') --'9912'
      AND (FIN_SUB_OBJ_CD LIKE ('%T') or FIN_SUB_OBJ_CD LIKE ('%S') or FIN_SUB_OBJ_CD LIKE ('%D')
           or FIN_SUB_OBJ_CD LIKE ('V%') or FIN_SUB_OBJ_CD = 'IBS' or FIN_SUB_OBJ_CD = 'UAA')
		  AND FIN_BALANCE_TYP_CD IN ('AC','BB')
      AND FUND_GRP_CD = 'GF'
		  AND UNIV_FISCAL_YR IN ('2019','2020')
		  AND ACCOUNT_NBR IN ('1917001','1917004')
		  AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
		GROUP BY fin_coa_cd, univ_fiscal_yr, account_nbr, FIN_CONS_OBJ_CD, fin_object_cd, fin_sub_obj_cd, fin_subobj_shrt_nm
) t
GROUP BY t.fy, t.account_nbr, t.fin_object_cd, t.account_nbr, t.fin_sub_obj_cd, t.sub_obj_grouping_cd, t.fin_subobj_group_nm, t.FIN_CONS_OBJ_CD
ORDER BY fy asc, account_nbr asc, fin_object_cd asc, sub_obj_grouping_cd asc
	</cfquery>
	<cfreturn fetchAdjBase />
</cffunction>


<cffunction name="getGuidelineTotal">
	<!---<cfargument name="givenCampus" type="string" required="true" />--->
	<cfargument name="givenFY" type="string" required="true" />
	<cfquery name="calcGuideTot" datasource="#application.datasource#">
		SELECT RC_CD, RC_NM,
		  CASE WHEN FIN_CONS_OBJ_CD = 'CMPN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CMPN_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'CPTL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CPTL_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'GENX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as GENX_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'IDEX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDEX_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'IDIN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDIN_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'OTRE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as OTRE_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'RSRX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as RSRX_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'SCHL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as SCHL_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'STFE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as STFE_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'TRSF' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRSF_SUB,
		  CASE WHEN FIN_CONS_OBJ_CD = 'TRVL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRVL_SUB,
		  SUM(FIN_BEG_BAL_LN_AMT) as BB_AMT
		FROM DSS_KFS.GL_BALANCE_V@dss_link
		WHERE FUND_GRP_CD = 'GF'
		  AND (FIN_BALANCE_TYP_CD = 'AC' OR FIN_BALANCE_TYP_CD = 'BB')
		  AND ACCT_CLOSED_IND = 'N'
		  <!---AND FIN_COA_CD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#" />--->
		  AND UNIV_FISCAL_YR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFY#" />
		  AND ACCOUNT_NBR IN ('1917001','1917004')
		  AND (FIN_SUB_OBJ_CD LIKE ('%S') OR FIN_SUB_OBJ_CD LIKE ('%T') OR FIN_SUB_OBJ_CD LIKE ('%D ')OR FIN_SUB_OBJ_CD LIKE ('V%') )
		  AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
		GROUP BY RC_CD, RC_NM, FIN_CONS_OBJ_CD
	</cfquery>
	<cfreturn calcGuideTot />
</cffunction>

<cffunction name="createGuidelineStruct">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset sesnRevs = structNew() />
	<cfif application.budget_year eq "YR1">
		<cfset sesnRevs = {
			xxS = getSesnEstRev(givenCampus,'FL').ESTREV_YR1
		} />
	<cfelse>
		<cfset sesnRevs = {
			FL = getSesnEstRev(givenCampus,'FL').ESTREV_YR2,
			SP = getSesnEstRev(givenCampus,'SP').ESTREV_YR2,
			SS1 = getSesnEstRev(givenCampus,'SS1').ESTREV_YR2,
			SS2 = getSesnEstRev(givenCampus,'SS2').ESTREV_YR2,
			WN = getSesnEstRev(givenCampus,'WN').ESTREV_YR2,
			CAMPTOT = getSesnEstRev(givenCampus).ESTREV_YR2
		} />
	</cfif>
	<cfreturn sesnRevs />
</cffunction>

<cffunction name="getAssessments">
	<cfquery name="assList" datasource="#application.datasource#">
		SELECT * FROM fee_user.intb_allocations
	</cfquery>
	<cfreturn assList />
</cffunction>

<cffunction name="getUATaxScenarios" >
	<cfquery name="scenarioList" datasource="#application.datasource#">
		SELECT * FROM intb_scenarios
	</cfquery>
	<cfreturn scenarioList />
</cffunction>

<cffunction name="getUATaxSummary">
	<cfargument name="givenChart" type="string" required="false" default="UA">
	<cfquery name="sumByRC" datasource="#application.datasource#">
		SELECT SUM(CMPN_SUB) as CMPN_SUM, SUM(CPTL_SUB) as CPTL_SUM, SUM(GENX_SUB) as GENX_SUM, SUM(IDEX_SUB) as IDEX_SUM, SUM(RSRX_SUB) as RSRX_SUM, SUM(IDIN_SUB) as IDIN_SUM, SUM(OTRE_SUB) as OTRE_SUM, SUM(SCHL_SUB) as SCHL_SUM, SUM(STFE_SUB) as STFE_SUM, SUM(TRSF_SUB) as TRSF_SUM, SUM(TRVL_SUB) as TRVL_SUM, SUM(BB_AMT) as BB_SUM
		FROM (SELECT RC_CD, RC_NM,
				  CASE WHEN FIN_CONS_OBJ_CD = 'CMPN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CMPN_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'CPTL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as CPTL_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'GENX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as GENX_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'IDEX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDEX_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'IDIN' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as IDIN_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'OTRE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as OTRE_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'RSRX' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as RSRX_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'SCHL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as SCHL_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'STFE' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as STFE_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'TRSF' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRSF_SUB,
				  CASE WHEN FIN_CONS_OBJ_CD = 'TRVL' THEN SUM(FIN_BEG_BAL_LN_AMT) ELSE 0 END as TRVL_SUB,
				  SUM(FIN_BEG_BAL_LN_AMT) as BB_AMT
			  FROM DSS_KFS.GL_BALANCE_V@dss_link
			  WHERE FUND_GRP_CD = 'GF'
					AND (FIN_BALANCE_TYP_CD = 'AC' OR FIN_BALANCE_TYP_CD = 'BB')
					AND (ACCT_CLOSED_IND = 'N')
					AND UNIV_FISCAL_YR IN ('2020')
					AND (ACCOUNT_NBR LIKE '19%')
					AND FIN_OBJ_TYP_CD IN ('EE','ES','EX','IC','IN','TE','TI')
					AND RC_CD NOT IN ('01','77')
					<cfif givenChart neq "UA">
						AND CAMPUS_CD = <cfqueryparam cfsqltype="cf_sql_varchar" value="givenChart">
					</cfif>
			  GROUP BY RC_CD, RC_NM, FIN_CONS_OBJ_CD)
		 <!--- GROUP BY RC_CD, RC_NM
		ORDER BY RC_CD ASC--->
	</cfquery>
	<cfreturn sumByRC />
</cffunction>

<cffunction name="getUATaxCharges">
	<cfquery name="chargeList" datasource="#application.datasource#">
		SELECT i.source, i.acct_nbr, i.obj_cd, c.fin_obj_cd_shrt_nm, i.sub_obj_cd, i.item_desc, i.ua_aux, i.iubla, i.east, i.kokomo,
		  i.iupui_ga, i.iupui_som, i.northwest, i.south_bend, i.southeast, i.total
		FROM fee_user.intb_charges i
		LEFT OUTER JOIN fee_user.coa_2020 c
		  ON i.obj_cd = c.fin_object_cd
		WHERE c.fin_coa_cd = 'BL'
		ORDER BY source ASC, acct_nbr asc, obj_cd asc, sub_obj_cd asc
	</cfquery>
	<cfreturn chargeList />
</cffunction>

<cffunction name="get2021Guidelines">
	<cfargument name="givenFyear" default="FY2021" >
	<cfargument name="givenLineItem" default="ALL">
	<cfquery name="getData" datasource="#application.datasource#">
		select fyear, line_item, line_type, account_nbr, obj_cd, sub_obj, line_title, ua_aux, iubla, iupui, iusom, iueaa, iukoa, iunwa, iusba, iusea, line_total, sort_order
		FROM fee_user.intb_uatax_2021
		WHERE fyear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFyear#">
		<cfif givenlineItem neq 'ALL'>
		  AND line_item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenLineItem#">
		</cfif>
		order by sort_order asc, sub_obj asc
	</cfquery>
	<cfreturn getData>
</cffunction>

<cffunction name="getLineItems" >

	<cfquery name="lineItemList" datasource="#application.datasource#">
		SELECT * FROM intb_b0865ua WHERE fin_object_cd = '9912' and account_nbr = '1917001' and fin_sub_obj_cd = 'INT'
	</cfquery>
	<cfreturn lineItemList>
</cffunction>
