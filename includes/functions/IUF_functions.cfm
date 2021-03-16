<cffunction name="getIUF_user" output="true">
	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
</cffunction>
  
<cffunction name="getIUF_data" output="true">
 	<cfquery datasource="#application.datasource#" name="IUF_data_raw">
 		SELECT IUF_KEMID,IUF_KEMID_TITLE, FY, CHART, ACCOUNT_NBR, ACCOUNT_NM, OBJ, OBJ_NAME, 
 		  OBJ_TYPE, RESTATED_OBJ_TYP, FIN_OBJ_LEVEL_NM, FIN_SUB_OBJ_CD, FIN_BALANCE_TYP_CD, 
 		  ACTUAL, RESTATED_ACTUAL, BG, FIN_OBJ_LEVEL_CD, FIN_CONS_OBJ_CD, 
          FIN_CONS_OBJ_NM, END_BAL, 1 as "iuf_match", 1 as "gifts"
 		FROM FEE_USER.IUF_MATCH
 	</cfquery>
 	 <cfquery dbtype="query" name="IUF_data">
 		SELECT IUF_KEMID,IUF_KEMID_TITLE, FY, CHART, ACCOUNT_NBR, ACCOUNT_NM, OBJ, OBJ_NAME, 
 		  OBJ_TYPE, RESTATED_OBJ_TYP, FIN_OBJ_LEVEL_NM, FIN_SUB_OBJ_CD, FIN_BALANCE_TYP_CD, 
 		  ACTUAL, RESTATED_ACTUAL, BG, FIN_OBJ_LEVEL_CD, FIN_CONS_OBJ_CD, 
          FIN_CONS_OBJ_NM, END_BAL, IUF_MATCH, GIFTS 
        FROM IUF_data_raw ORDER BY ACCOUNT_NBR ASC
 	</cfquery>
 	<cfreturn IUF_data />
</cffunction>

<cffunction name="getIU_Accts" output="true">
	<cfquery datasource="#application.datasource#" name="IU_accounts">
		SELECT DISTINCT ACCOUNT_NBR FROM FEE_USER.IUF_MATCH
	</cfquery>
	<cfreturn IU_accounts>
</cffunction>  

<cffunction name="getIUF_KEMIDs" output="true">
	<cfquery datasource="#application.datasource#" name="KEMIDs">
		SELECT DISTINCT IUF_KEMID FROM FEE_USER.IUF_MATCH
	</cfquery>
	<cfreturn KEMIDs>
</cffunction>  

