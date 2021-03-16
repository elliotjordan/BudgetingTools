<!--- 
	file:	UBO_template_functions.cfm
	author:	John Burgoon jburgoon
	ver.:	v1
	note:	This cfm is the include page for all UBO template functions.  The purpose is to have a single repository
	        for queries supporting specific Excel templates which are refreshed via "Magic Button" in the 
	        Budgeting Tools interface but which do NOT have dedicated interfaces. For example the V1 report is 
	        a feature of the Credit Hour and revenue Projector, so its supporting code is found in the 
	        revenue_functions.cfm.  First function included here is in support of a request by Theo Wu (ttwu)
	        in November 2019 to automate a monthly GL_BALANCE_GV report which he currently makes by hand.
 --->
<cffunction name="getUBOUser" output="true">
	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
</cffunction>
 
<cffunction name="getObjCdTotals" output="true">  
	<cfquery name="getObjCdSums" datasource="#application.datasource#">
		SELECT DISTINCT FIN_OBJECT_CD, FIN_OBJ_CD_SHRT_NM, ACCOUNT_NBR, account_nm, TO_CHAR(SUM(TRN_LDGR_ENTR_AMT),'$999,999,999.00') as TOTAL_BY_OBJ_CD,
		  MIN(TRANSACTION_DT) as EARLIEST_TRSXN_DT, MAX(TRANSACTION_DT) as LATEST_TRSXN_DT
		FROM DSS_KFS.GL_DETAIL_GV@dss_link
		WHERE UNIV_FISCAL_YR = '2020'
		  AND ACCOUNT_NBR LIKE '191%'
		  AND FIN_BALANCE_TYP_CD IN ('AC','BB')
		  AND FIN_OBJECT_CD IN ('1803','9900','9903','9918')
		  AND TRANSACTION_DT BETWEEN TO_DATE('2019/06/01','yyyy/mm/dd')
		        AND TO_DATE('2019/09/30','yyyy/mm/dd')
		GROUP BY FIN_OBJECT_CD, FIN_OBJ_CD_SHRT_NM, account_nbr, account_nm
		ORDER BY FIN_OBJECT_CD ASC
	</cfquery>
	<cfif getObjCdSums.RecordCount gt 0>
		<cfreturn getObjCdSums>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getAcctCOAdetails" output="true">
	<cfquery name="getAcctDetails" datasource="#application.datasource#">
		SELECT ACCOUNT_NBR, ACCOUNT_NM, ACCT_EXP_GDLN_TXT, ACCT_FSC_OFC_USER_ID, ACCT_FSC_OFC_PRSN_NM, ACCT_FSC_OFC_EMAIL_ADDR,
  		  ACCT_MGR_USER_ID, ACCT_MGR_PRSN_NM, ACCT_MGR_EMAIL_ADDR, ACCT_EXPIRATION_IND
		FROM DSS_KFS.CA_ACCTORG_GT@dss_link 
		WHERE ACCT_CLOSED_IND = 'N'
	      AND ACCOUNT_NBR LIKE '19%'
	      AND LOWER(ACCT_MGR_USER_ID) IN ('alirober','galter','ttwu')
		ORDER BY ACCOUNT_NBR ASC;
	</cfquery>
	<cfif getAcctDetails.RecordCount gt 0>
		<cfreturn getAcctDetails>
	<cfelse>
		<cfreturn false>
	</cfif>	
</cffunction>
