  <cffunction name="getUser" output="true">
  	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,ALLFEES_RCS, PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
  </cffunction>

  <cffunction name="getUserActiveSetting" output="true">
  	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserActive">
  		SELECT ACTIVE
  		FROM FEE_USER.USERS
  		WHERE USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserActive.ACTIVE>
  </cffunction>

  <cffunction name="getUsersByCampus" output="true">
  	<cfargument name="givenUser" required="false" default="">
  	<cfquery datasource="#application.datasource#" name="getUserList">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,ALLFEES_RCS,PHONE,ACTIVE,CREATED_ON
  		FROM USERS
  		WHERE CHART = (
  			SELECT CHART
  			FROM USERS
  			WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#REQUEST.authuser#" cfsqltype="cf_sql_varchar">
  		   ) 
  		   AND ACCESS_LEVEL != 'GUEST'
  		<cfif LEN(givenUser) gt 0>
  			AND username = '#givenUser#'
  		</cfif>
  	</cfquery>
  	<cfreturn getUserList>
  </cffunction>
    
  <cffunction name="getDefaultPreferences" output="true">
  	<cfargument name="pref" required="true" />
	<cfquery name="getPrefs" datasource="#application.datasource#">
		SELECT PREF_VALUE 
		FROM PREFERENCES
		WHERE APP_NAME = <cfqueryparam value="RevenueProjector" cfsqltype="cf_sql_char">
		  AND USERNAME = <cfqueryparam value="default" cfsqltype="cf_sql_char">
	</cfquery>	
	<cfif getPrefs.RecordCount neq 0>
		<cfreturn getPrefs>
	<cfelse>
		<cfreturn false >
	</cfif>
  </cffunction>

<!--- TODO: Make getUserPreferences generic for application.applicationname and move function to common area --->
  <cffunction name="getUserPreferences" output="true">
	<cfquery name="getPrefs" datasource="#application.datasource#">
		SELECT APP_NAME, PREF_NM, PREF_VALUE 
		FROM PREFERENCES
		WHERE APP_NAME = <cfqueryparam value="RevenueEstimator" cfsqltype="cf_sql_char">  
		  AND USERNAME = <cfqueryparam value="REQUEST.authuser" cfsqltype="cf_sql_char">
	</cfquery>	
	<cfif getPrefs.RecordCount neq 0>
		<cfreturn getPrefs>
	<cfelse>
		<cfreturn false >
	</cfif>
  </cffunction>

<cffunction name="getUserLandingPage" >
	<cfset userLandingPage = "revenue_RC.cfm?message=We did not find you in the database">
	<cfquery name="userProjector_RC" datasource="#application.datasource#">
		SELECT PROJECTOR_RC
		FROM USERS 
		WHERE username = <cfqueryparam value="#REQUEST.authuser#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfquery name="userChart" datasource="#application.datasource#">
		SELECT chart
		FROM USERS 
		WHERE username = <cfqueryparam value="#REQUEST.authuser#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif userProjector_RC.PROJECTOR_RC eq "ALL">  <!--- Campus level Fiscal Officers --->
		<cfset userLandingPage = "revenue_Campus.cfm">
	<cfelseif userProjector_RC.PROJECTOR_RC eq "" OR IsNull(userProjector_RC.PROJECTOR_RC)>
		<cfset userLandingPage = "revenue_RC.cfm?Campus=BL&RC=75">
	<cfelseif userProjector_RC.PROJECTOR_RC neq false>
		<cfset user = getUser(REQUEST.authuser)>
		<cfset campus = user["CHART"][1]>
		<cfset userLandingPage = "revenue_RC.cfm?Campus="&userChart.chart&"&RC="&userProjector_RC.PROJECTOR_RC>
	</cfif>
	<cfreturn userLandingPage>
</cffunction>

<cffunction name="getUserAccessList">
	<cfquery name="userAllFees_RCs" datasource="#application.datasource#">
		SELECT PROJECTOR_RC, allfees_rcs
		FROM USERS 
		WHERE username = <cfqueryparam value="#REQUEST.authuser#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn userAllFees_RCs>	
</cffunction>

<!--- Take a pref name and value.  Find if it exists.  if so, update, if not, create a new row  --->
<cffunction name="updatePreferences">   <!--- updatePreferences(pref_name,pref_value)  --->
	<cfargument name="pref_name" required="true" type="string">
	<cfargument name="pref_value" required="true">
	<cfquery name="checkForPref" datasource="#application.datasource#">
		SELECT COUNT(*) FROM FEE_USER.PREFERENCES
		WHERE USERNAME = <cfqueryparam cfsqltype="cf_sql_char" value="#REQUEST.AuthUser#">
		  AND PREF_NM = <cfqueryparam cfsqltype="cf_sql_char" value="#pref_name#">
	</cfquery>
	<cfif checkForPref.recordCount gt 1>  		<!--- need to throw an error here.  We should not have two rows for any username/pref_nm combination  --->
		<cfset updatePreferencesResult = checkForPref>
	<cfelseif checkForPref.recordCount eq 1>   	<!--- Great, we have this preference for this user already. Just update it --->
		<cfquery datasource="#application.datasource#">
			UPDATE FEE_USER.PREFERENCES 
			SET PREF_VALUE = <cfqueryparam cfsqltype="cf_sql_char" value="#pref_value#">
			WHERE USERNAME = <cfqueryparam cfsqltype="cf_sql_char" value="#REQUEST.AuthUser#">
			  AND PREF_NM = <cfqueryparam cfsqltype="cf_sql_char" value="#pref_name#">
		</cfquery>
	<cfelse>									<!--- OK we need to create a new row for this username/preference combination --->
		<cfquery datasource="#application.datasource#">
			INSERT INTO FEE_USER.PREFERENCES 
			APP_NAME, PREF_VALUE, USERNAME, PREF_NM, PREF_VALUE
			VALUES
			('RevenueEstimator',
			 <cfqueryparam cfsqltype="cf_sql_char" value="#pref_value#">,
			 <cfqueryparam cfsqltype="cf_sql_char" value="#REQUEST.AuthUser#">
			 <cfqueryparam cfsqltype="cf_sql_char" value="#pref_name#">
		    )
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="getLandingPage" >
	<cfargument name="username" type="string" default="">
	<cfquery datasource="#application.datasource#" name="getLP" >
		SELECT PREF_VALUE 
		FROM PREFERENCES
		WHERE USERNAME = <cfqueryparam cfsqltype="cf_sql_char" value="#REQUEST.AuthUser#">
		  AND PREF_NM = <cfqueryparam cfsqltype="cf_sql_char" value="LANDING_PAGE">
	</cfquery>	
	<cfif getLP.RecordCount neq 0>
		<cfreturn getLP.PREF_VALUE>
	<cfelse>
		<cfreturn getDefaultPreferences["LANDING_PAGE"] >
	</cfif>
</cffunction>

<cffunction name="getCampusAndRC" output="true">
	<cfargument name="selectedCampus" type="string" default="BL">
	<cfset currentUserChart = getUsersByCampus(request.authUser).chart>
	<cfquery datasource="#application.datasource2#" name="GetCampus">
	  select distinct c.fin_coa_cd, c.fin_coa_desc, r.rc_cd, r.rc_shrt_nm,
	    CONCAT(c.fin_coa_cd, CONCAT( CONCAT(' - ', r.rc_cd), CONCAT(' - ', r.rc_shrt_nm) ) ) "dropdown" 
	  from #application.hours_to_project# h,		
	       ref.bc_rc_t r,							<!--- includes all RCs, names, and ACTIVE code --->
	       ref.rc_sec_t s,							<!--- security table --->
	       ref.bc_chart_t c   						<!--- "BL" "Bloomington"   --->
	  where s.schm_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="CH_USER">
	  <cfif currentUserChart neq 'UA'>
	    and c.fin_coa_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedCampus#">
	  </cfif>
	    and s.actv = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
	    and SUBSTR(h.inst,3,2) = c.fin_coa_cd
	    and h.rc = r.rc_cd
	  <cfif currentUserChart neq 'UA'>
	  	order by r.rc_cd asc
	  <cfelse>
	  	order by c.fin_coa_cd asc, r.rc_cd asc
	  </cfif>
	</cfquery>
	<cfif GetCampus.RecordCount gt 0>
		<cfreturn GetCampus>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="setSelectedRC" >
	<cfargument name="selectedRC" >
	<cfif IsDefined(selectedRC) AND IsNull(selectedRC)>
		return false
	<cfelse>
		<cfset selectedRC = selectedRC>
	</cfif>
</cffunction>

<cffunction name="getClearingRC" >
	<cfargument name="selectedCampus" type="string" default="" required="true">
	<cfscript>
	  clearingData = StructNew();
	  clearingData.BL = '81';
	  clearingData.IN = '52';
	  clearingData.EA = '77';
	  clearingData.KO = '77';
	  clearingData.NW = '77';
	  clearingData.SB = '77';
	  clearingData.SE = '77';
	</cfscript>
	<cfreturn clearingData[selectedCampus]>
</cffunction>

<cffunction name="getProjectinatorData" output="true">
	<cfargument name="selectedCampus" required="true">   
	<cfargument name="selectedRC" required="true">
	<cfset selectedCampus = 'IU'&#selectedCampus#&'A'>
	<cfquery datasource="#application.datasource2#" name="DataSelect">
	SELECT OID,INST, CHART, RC,
	    DECODE(SUBSTR(TERM,4,1),'8','Fall','2','Spring','5','Summer','--','--') TRMLABEL,
		SELGROUP, FEECODE, TRIM(ACAD_CAREER) ACAD_CAREER, TERM, SESN, 
	    DECODE(SUBSTR(TERM,1,4),'4188','FL','4192','SP','4175','SS2','4185','SS1','--','--') SESNLABEL,
	    ACCOUNT,
	    HEADCOUNT, HOURS,
	   CASE MACHINEHOURS_YR1
	     WHEN 0 THEN '0'
	     ELSE TO_CHAR(MACHINEHOURS_YR1,'9999999.9')
	   END AS MACHINEHOURS_YR1,
	   CASE MACHINEHOURS_YR2
	     WHEN 0 THEN '0'
	     ELSE TO_CHAR(MACHINEHOURS_YR2,'9999999.9')
	   END AS MACHINEHOURS_YR2,
	    PROJHOURS_YR1, PROJHOURS_YR2,
	    ACCOUNT_NM, OBJCD, FIN_OBJ_CD_NM, 
	    '--' AS FIN_OBJ_LEVEL_CD,FEE_ID,FEEDESCR,
	    FEEDESCR, '('||SELGROUP||', '||FEECODE||')' FEEKEY,
	    ADJ_RATE, ADJ_ESCL_RATE_YR1, ADJ_ESCL_RATE_YR2,
	    FEE_LOWYEAR, 
	    <cfif application.rateStatus eq 'Vc'>
		    ADJ_RATE * PROJHOURS_YR1 ESTREV_YR1,
		<cfelseif application.rateStatus eq 'V1'>
		    ADJ_ESCL_RATE_YR1 * PROJHOURS_YR1 ESTREV_YR1,		
	    </cfif>
	    <cfif application.rateStatus eq 'Vc'>
		    ADJ_RATE * PROJHOURS_YR2 ESTREV_YR2,
		<cfelseif application.rateStatus eq 'V1'>
		    ADJ_ESCL_RATE_YR2 * PROJHOURS_YR2 ESTREV_YR2,		
	    </cfif>
	    DECODE(RES,'1R','R','2NR','NR','3All','--') RESIDENCY,RES
	FROM #application.hours_to_project#
	WHERE INST = '#selectedCampus#'
	  AND RC = '#selectedRC#'
	  AND FEECODE NOT LIKE 'G901%$'
	  AND FEECODE NOT LIKE 'LWA%$'
	ORDER BY RC ASC, FEECODE ASC, TERM ASC
	</cfquery>
	<cfreturn DataSelect>
</cffunction>

<cffunction name="getExcelDownloadData" output="true">
	<cfargument name="selectedChart" default="NONE">   
	<cfargument name="selectedRC" default="NONE">
	<cfargument name="selectedVersion" required="true">
	<cfset derivedCampus = 'IU'&#selectedChart#&'A'>
	<cfquery datasource="#application.datasource2#" name="DataSelect">
	SELECT OID, INST, CHART, RC, TERM, SESN as "SESNLABEL", FEECODE, FEEDESCR, SELGROUP, TRIM(ACAD_CAREER) ACAD_CAREER,  
	    RES, ACCOUNT,ACCOUNT_NM,OBJCD, FIN_OBJ_CD_NM, 
			' ' as spacer1,
	    
			HEADCOUNT, 
			HOURS as "Actual Hours",

	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_RATE
		  END AS "FY19_ADJ_RATE (Vc)",
			MACHINEHOURS_YR1 as "ES Hours YR1",
			MACHINEHOURS_YR2 as "ES Hours YR2",
			' ' as spacer2,
	<cfif selectedVersion eq 'Vc'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_RATE
		  END AS "FY20_CONSTANT_RATE (Vc)", 	
	<cfelse>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_ESCL_RATE_YR1
		  END AS "FY20_ESC_RATE (V1)",   
	</cfif>
PROJHOURS_YR1,

	<cfif selectedVersion eq 'Vc'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_RATE * PROJHOURS_YR1
		  END AS "ESTREV_YR1",
	<cfelseif selectedVersion eq 'V1'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_ESCL_RATE_YR1 * PROJHOURS_YR1
		  END AS "ESTREV_YR1",
	</cfif>
		  ' ' as spacer3,
			
	<cfif selectedVersion eq 'Vc'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_RATE
		  END AS "FY21_CONSTANT_RATE (Vc)",  			
	<cfelseif selectedVersion eq 'V1'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_ESCL_RATE_YR2
		  END AS "FY21_ESC_RATE (V1)",  			
	</cfif>
PROJHOURS_YR2,		

	<cfif selectedVersion eq 'Vc'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_RATE * PROJHOURS_YR2
		  END AS "ESTREV_YR2"
	<cfelseif selectedVersion eq 'V1'>
	  CASE  
		  WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0
		  ELSE ADJ_ESCL_RATE_YR2 * PROJHOURS_YR2
		  END AS "ESTREV_YR2"
	</cfif>
	FROM #application.hours_to_project#
	WHERE 1 = 1
	  <cfif selectedChart neq 'NONE'>
	    AND INST = '#derivedCampus#'
	  </cfif>
	  <cfif selectedRC neq 'NONE'>
	  	AND RC = '#selectedRC#'
	  </cfif> 
	ORDER BY RC ASC, FEECODE ASC, TERM ASC
	</cfquery>
	<cfreturn DataSelect>
</cffunction>

<!--- WHEN FEECODE IN ('OVSTN$','OVSTR$','ACPR$','ACPNR$','G901N$','G901R$','LWARN$','LWARR$') THEN 0 --->
<!--- TODO: add argument to switch between Vc and V1 / escalated rates --->
<cffunction name="getAllRC_EstRev">
	<cfargument name="selectedCampus" type="string" default="">
	<cfquery datasource="#application.datasource2#" name="EstRevSelect">
		SELECT t.RC_CD, t.RC_NM, t.inst,
		  SUM(t.ESTREV_YR1) ESTREV_YR1, SUM(PROJHOURS_YR1) PROJHRS_TOTAL_YR1,
		  SUM(t.ESTREV_YR2) ESTREV_YR2, SUM(PROJHOURS_YR2) PROJHRS_TOTAL_YR2
		FROM
		  (SELECT htp.inst, htp.RC RC_CD, c.RC_NM,
		     htp.PROJHOURS_YR1, htp.ADJ_ESCL_RATE_YR1 * htp.PROJHOURS_YR1 ESTREV_YR1,
		     htp.PROJHOURS_YR2, htp.ADJ_ESCL_RATE_YR2 * htp.PROJHOURS_YR2 ESTREV_YR2
		   FROM #application.hours_to_project# htp
		   INNER JOIN CH_USER.CAMPUS_SETTINGS_T c
			 <!---ON htp.CHART = c.CHART AND htp.RC = c.RC_CD--->
			 ON htp.INST = c.INST_CD AND htp.RC = c.RC_CD
		   WHERE htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedCampus#">
			 AND FEECODE NOT LIKE 'G901%$'
			 AND FEECODE NOT LIKE 'LWA%$'
			 AND FEECODE NOT LIKE 'ACP%'
		<cfif selectedCampus neq 'IN'>
			 AND FEECODE NOT LIKE 'BAN%'
		</cfif>
			 ) t
		GROUP BY  t.inst, t.RC_CD, t.RC_NM
	</cfquery>
	<cfquery dbtype="query" name="EstRevSelect_sorted">
		SELECT RC_CD, RC_NM, ESTREV_YR1, ESTREV_YR2, PROJHRS_TOTAL_YR1, PROJHRS_TOTAL_YR2
		FROM EstRevSelect
		ORDER BY RC_CD ASC
	</cfquery>
	<cfreturn EstRevSelect_sorted>
</cffunction>

<cffunction name="getCampusGrandTotals" >
	<cfargument name="campus" default="" >
	<cfquery datasource="#application.datasource2#" name="GrandRevSelect">
		SELECT SUM(HOURS) ACTUAL, 
		  SUM(MACHINEHOURS_YR1) MACHINEHOURS_YR1, 
		  SUM(MACHINEHOURS_YR2) MACHINEHOURS_YR2, 
		  SUM(t.PROJHOURS_YR1) PROJHRS_GRAND_YR1, 
		  SUM(t.PROJHOURS_YR2) PROJHRS_GRAND_YR2, 
		  SUM(UBO_ESTREV_YR1) UBO_ESTREV_GRAND_YR1, 
		  SUM(UBO_ESTREV_YR2) UBO_ESTREV_GRAND_YR2, 
		  SUM(t.ESTREV_YR1) ESTREV_GRAND_YR1,
		  SUM(t.ESTREV_YR2) ESTREV_GRAND_YR2
		FROM
		  (SELECT htp.HOURS, 
		     htp.MACHINEHOURS_YR1, htp.MACHINEHOURS_YR2, 
		     htp.PROJHOURS_YR1, htp.PROJHOURS_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.MACHINEHOURS_YR1 UBO_ESTREV_YR1, 
		     htp.ADJ_ESCL_RATE_YR2 * htp.MACHINEHOURS_YR2 UBO_ESTREV_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.PROJHOURS_YR1 ESTREV_YR1,
		     htp.ADJ_ESCL_RATE_YR2 * htp.PROJHOURS_YR2 ESTREV_YR2
		   FROM #application.hours_to_project# htp
		   INNER JOIN CAMPUS_SETTINGS_T c
			 <!---ON htp.CHART = c.CHART AND htp.RC = c.RC_CD--->
			 ON htp.INST = c.INST_CD AND htp.RC = c.RC_CD
		   WHERE FEECODE NOT LIKE 'G901%$'
			 AND FEECODE NOT LIKE 'LWA%$'
			 AND FEECODE NOT LIKE 'ACP%'
		<cfif campus neq 'IN'>
			 AND FEECODE NOT LIKE 'BAN%'
		</cfif>
			 AND htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#campus#">) t
	</cfquery>
	<cfreturn GrandRevSelect>
</cffunction>

<cffunction name="getAllCampus_EstRev">
	<cfquery datasource="#application.datasource2#" name="EstRevSelect">
		SELECT t.CHART, SUM(HOURS) ACTUAL, 
		SUM(MACHINEHOURS_YR1) MACHINEHOURS_YR1, SUM(t.PROJHOURS_YR1) PROJHOURS_YR1, 
		SUM(MACHINEHOURS_YR2) MACHINEHOURS_YR2, SUM(t.PROJHOURS_YR2) PROJHOURS_YR2, 
		SUM(UBO_ESTREV_YR2) UBO_ESTREV_YR1, SUM(t.ESTREV_YR1) ESTREV_YR1,
		SUM(UBO_ESTREV_YR2) UBO_ESTREV_YR2, SUM(t.ESTREV_YR2) ESTREV_YR2
		FROM
		  (SELECT htp.CHART, htp.HOURS, 
		     htp.MACHINEHOURS_YR1, htp.MACHINEHOURS_YR2, 
		     htp.PROJHOURS_YR1, htp.PROJHOURS_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.MACHINEHOURS_YR1 UBO_ESTREV_YR1, 
		     htp.ADJ_ESCL_RATE_YR2 * htp.MACHINEHOURS_YR2 UBO_ESTREV_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.PROJHOURS_YR1 ESTREV_YR1, 
		     htp.ADJ_ESCL_RATE_YR2 * htp.PROJHOURS_YR2 ESTREV_YR2
		   FROM #application.hours_to_project# htp
		   INNER JOIN CAMPUS_SETTINGS_T c
			 <!---ON htp.CHART = c.CHART AND htp.RC = c.RC_CD--->
			 ON htp.INST = c.INST_CD AND htp.RC = c.RC_CD
		   WHERE FEECODE NOT LIKE 'G901%$'
			 AND FEECODE NOT LIKE 'LWA%$'
			 AND FEECODE NOT LIKE 'ACP%'
			 AND FEECODE NOT LIKE 'BAN%') t
		   GROUP BY  t.CHART
	</cfquery>
	<cfquery dbtype="query" name="EstRevSelect_sorted">
		SELECT CHART, ACTUAL, 
		  MACHINEHOURS_YR1, MACHINEHOURS_YR2, 
		  PROJHOURS_YR1, PROJHOURS_YR2, 
		  UBO_ESTREV_YR1, UBO_ESTREV_YR2, 
		  ESTREV_YR1, ESTREV_YR2
		FROM EstRevSelect
		ORDER BY CHART ASC
	</cfquery>
	<cfreturn EstRevSelect_sorted>
</cffunction>

<cffunction name="getAllCampus_EstRev_byRC">
	<cfquery datasource="#application.datasource2#" name="EstRevSelect">
		SELECT t.CHART, t.RC_CD, t.RC_NM, SUM(HOURS) ACTUAL, 
		SUM(MACHINEHOURS_YR1) MACHINEHOURS_YR1, 
		SUM(MACHINEHOURS_YR2) MACHINEHOURS_YR2, 
		SUM(t.PROJHOURS_YR1) PROJHOURS_YR1, 
		SUM(t.PROJHOURS_YR2) PROJHOURS_YR2, 
		SUM(UBO_ESTREV_YR1) UBO_ESTREV_YR1, 
		SUM(UBO_ESTREV_YR2) UBO_ESTREV_YR2, 
		SUM(t.ESTREV_YR1) ESTREV_YR1, 
		SUM(t.ESTREV_YR2) ESTREV_YR2
		FROM
		  (SELECT htp.CHART, htp.RC RC_CD, c.RC_NM, htp.HOURS, 
		     htp.MACHINEHOURS_YR1, htp.MACHINEHOURS_YR2, 
		     htp.PROJHOURS_YR1, htp.PROJHOURS_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.MACHINEHOURS_YR1 UBO_ESTREV_YR1, 
		     htp.ADJ_ESCL_RATE_YR2 * htp.MACHINEHOURS_YR2 UBO_ESTREV_YR2, 
		     htp.ADJ_ESCL_RATE_YR1 * htp.PROJHOURS_YR1 ESTREV_YR1,
		     htp.ADJ_ESCL_RATE_YR2 * htp.PROJHOURS_YR2 ESTREV_YR2
		   FROM #application.hours_to_project# htp
		   INNER JOIN CAMPUS_SETTINGS_T c
			 <!---ON htp.CHART = c.CHART AND htp.RC = c.RC_CD--->
			 ON htp.INST = c.INST_CD AND htp.RC = c.RC_CD
		   WHERE FEECODE NOT LIKE 'G901%$'
			 AND FEECODE NOT LIKE 'LWA%$'
			 AND FEECODE NOT LIKE 'ACP%'
			 AND FEECODE NOT LIKE 'BAN%') t
		   GROUP BY  t.CHART, t.RC_CD, t.RC_NM
	</cfquery>
	<cfquery dbtype="query" name="EstRevSelect_sorted">
		SELECT CHART, RC_CD, RC_NM, ACTUAL, MACHINEHOURS_YR1, MACHINEHOURS_YR2, 
		  PROJHOURS_YR1, PROJHOURS_YR2, UBO_ESTREV_YR1, UBO_ESTREV_YR2, ESTREV_YR1, ESTREV_YR2
		FROM EstRevSelect
		ORDER BY CHART ASC, RC_CD ASC
	</cfquery>
	<cfreturn EstRevSelect_sorted>
</cffunction>

<cffunction name="getAllCampusTargets" output="true">
	<cfargument name="selectedCampus" type="string" default="">
	<cfquery datasource="#application.datasource2#" name="GetAllCampusTargets">
	  SELECT RC_CD, RC_NM, RC_TARGET
	  FROM CH_USER.CAMPUS_SETTINGS_T
	  WHERE CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#"> 
	  ORDER BY RC_CD ASC 
	</cfquery>
	<cfreturn GetAllCampusTargets>
</cffunction>

<cffunction name="getFeeInfo" output="true">
	<cfargument name="currentOID" type="any" default="">
	<cfquery datasource="#application.datasource2#" name="getThisFee">
		SELECT h.* 
		FROM #application.hours_to_project# h
		WHERE OID = '#currentOID#'
	</cfquery>
	<cfreturn getThisFee>
</cffunction>

<cffunction name="updateFeeInfo" output="false">
	<cfargument name="thisOID" type="string" default="">
	<cfargument name="projhours_YR1" type="numeric">
	<cfargument name="projhours_YR2" type="numeric">
	<cftransaction>
		<cfquery datasource="#application.datasource2#" name="setFee">
			UPDATE #application.hours_to_project# 
			SET PROJHOURS_YR1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#projhours_YR1#" />,
			    PROJHOURS_YR2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#projhours_YR2#" />,
			    U_VERSION = U_VERSION + 1
			WHERE OID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisOID#">
		</cfquery>
	</cftransaction>
</cffunction>

<cffunction name="getProjCount" output="true">
	<cfquery datasource="#application.datasource2#" name="getCount">
		SELECT * FROM #application.hours_to_project#
	</cfquery>	
	<cfreturn getCount.RecordCount>
</cffunction>

<cffunction name="getQueryResultCount" output="true">
	<cfargument name="queryResult" required="true">
	<cfquery dbtype="query" name="queryOfResults">
		SELECT ACAD_CAREER, COUNT(*) AS HEADCOUNT
		FROM queryResult
		GROUP BY ACAD_CAREER
	</cfquery>
	<cfreturn queryOfResults />
</cffunction>

<cffunction name="getDefaultObjCdCount" output="true">
	<cfquery datasource="#application.datasource2#" name="getCount">
		SELECT * FROM CH_USER.CA_ACCT_OBJCD_T_2017 WHERE OBJ_CD_DEFAULT = '1'
	</cfquery> 
	<cfreturn getCount.RecordCount>
</cffunction>

<cffunction name="getClearing" output="true">
	<cfargument name="selectedCampus" default="NONE">   
	<cfargument name="clearingRC" default="NONE">   
	<cfquery datasource="#application.datasource2#" name="clearingSelect">
	SELECT clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.RC, clearingSummary.SELGROUP, clearingSummary.FEECODE, TRIM(clearingSummary.ACAD_CAREER) ACAD_CAREER, clearingSummary.TERM, clearingSummary.SESN, 
	    DECODE(SUBSTR(clearingSummary.TERM,1,4),'4168','FL','4172','SP','4165','SS2','4175','SS1','--','--') SESNLABEL,
	    clearingSummary.ACCOUNT,
	    clearingSummary.HEADCOUNT, clearingSummary.HOURS,
	    <!--- TO_CHAR(ROUND(clearingSummary.Hours/clearingSummary.HeadCount,2),'9999.99') PERHEAD, --->
	    TO_CHAR(clearingSummary.MACHINEHOURS_YR1,'9999999.9') MACHINEHOURS_YR1,
	    TO_CHAR(clearingSummary.MACHINEHOURS_YR2,'9999999.9') MACHINEHOURS_YR2,
	    clearingSummary.PROJHOURS_YR1,
	    clearingSummary.PROJHOURS_YR2,
	    clearingSummary.ACCOUNT_NM, clearingSummary.OBJCD, clearingSummary.FIN_OBJ_CD_NM, 
	    '--' AS FIN_OBJ_LEVEL_CD,
	    clearingSummary.FEEDESCR, '('||clearingSummary.SELGROUP||', '||clearingSummary.FEECODE||')' FEEKEY,
	    clearingSummary.ADJ_RATE, 
	    clearingSummary.ADJ_ESCL_RATE_YR1, clearingSummary.ADJ_ESCL_RATE_YR2,
	    clearingSummary.FEE_ID,clearingSummary.FEE_LOWYEAR, 
	    clearingSummary.ADJ_ESCL_RATE_YR1 * clearingSummary.PROJHOURS_YR1 ESTREV_YR1,
	    clearingSummary.ADJ_ESCL_RATE_YR2 * clearingSummary.PROJHOURS_YR2 ESTREV_YR2,
	    DECODE(clearingSummary.RES,'1R','R','2NR','NR','3All','--') RESIDENCY,
	    DECODE(SUBSTR(clearingSummary.TERM,4,1),'8','Fall','2','Spring','5','Summer','--','--') TRMLABEL,
	    aorc.AORC ENROLLMENTRC
	FROM #application.hours_to_project# clearingSummary
  INNER JOIN CH_USER.PROJ_AORC aorc
    ON clearingSummary.CHART = aorc.CHART AND clearingSummary.RC = aorc.RC AND clearingSummary.TERM = aorc.STRM AND clearingSummary.ACCOUNT = aorc.ACCOUNT AND clearingSummary.FEECODE = aorc.FEECODE 
	WHERE clearingSummary.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#">
	  AND clearingSummary.RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
	ORDER BY clearingSummary.RC ASC, clearingSummary.FEECODE ASC, clearingSummary.TERM ASC
	</cfquery>
	<cfreturn clearingSelect>
</cffunction>

<cffunction name="getClearingSummary" output="true">
	<cfargument name="selectedCampus" default="NONE">   
	<cfargument name="clearingRC" default="NONE">
	<cfquery datasource="#application.datasource2#" name="aggregatedEstRev">
		SELECT sub.OID, sub.INST, sub.CHART, sub.RC, sub.FEECODE, sub.TERM,  
		  sub.SESN SESNLABEL, sub.SELGROUP, sub.ACAD_CAREER,
		  sub.SESN,
		  sub.ACCOUNT,
		  SUM(sub.HEADCOUNT) HEADCOUNT, 
		  SUM(sub.HOURS) HOURS,
		  SUM(sub.MachineHours_YR1) MACHINEHOURS_YR1,
		  SUM(sub.MachineHours_YR2) MACHINEHOURS_YR2,
		  SUM(sub.PROJHOURS_YR1) PROJHOURS_YR1,
		  SUM(sub.PROJHOURS_YR2) PROJHOURS_YR2,
		  sub.ACCOUNT_NM, sub.OBJCD, sub.FIN_OBJ_CD_NM, 
		  sub.FEEDESCR,
		  sub.FEE_ID,
		  sub.ADJ_RATE,  
		  sub.FEE_LOWYEAR, 
		  SUM(sub.PROJHOURS_YR1) PROJHOURS_YR1, 
		  SUM(sub.PROJHOURS_YR2) PROJHOURS_YR2,
		<cfif application.rateStatus eq 'Vc'>
		  sub.ADJ_RATE * SUM(sub.PROJHOURS_YR1) ESTREV_YR1,
		  sub.ADJ_RATE * SUM(sub.PROJHOURS_YR2) ESTREV_YR2,
		<cfelseif application.rateStatus eq 'V1'>
		  sub.ADJ_ESCL_RATE_YR1 * SUM(sub.PROJHOURS_YR1) ESTREV_YR1,
		  sub.ADJ_ESCL_RATE_YR2 * SUM(sub.PROJHOURS_YR2) ESTREV_YR2,		
		</cfif>
		  sub.RES RESIDENCY, sub.RES,
		  DECODE(SUBSTR(sub.TERM,4,1),'8','Fall','2','Spring','5','Summer','--','--') TRMLABEL
		FROM #application.hours_to_project# sub
		WHERE sub.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#">
		  	AND sub.RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
		GROUP BY sub.OID, sub.INST, sub.CHART, sub.RC, sub.ACAD_CAREER, sub.FEECODE, sub.TERM, sub.ACCOUNT, sub.SESN,
			sub.ACCOUNT_NM, sub.OBJCD, sub.FIN_OBJ_CD_NM, sub.FEEDESCR, sub.RES,sub.SELGROUP,
			sub.FEE_ID, sub.FEE_LOWYEAR, sub.RES, sub.ADJ_RATE, sub.ADJ_ESCL_RATE_YR1, sub.ADJ_ESCL_RATE_YR2
	</cfquery> 
	
	<cfquery datasource="#application.datasource2#" name="clearingSummary">
		SELECT clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.RC, clearingSummary.FEECODE, clearingSummary.TERM,  
		  clearingSummary.SESN SESNLABEL, clearingSummary.SESN,
		  clearingSummary.ACCOUNT,clearingSummary.SELGROUP,
		  SUM(clearingSummary.HEADCOUNT) HEADCOUNT, 
		  SUM(clearingSummary.HOURS) HOURS,
		  SUM(clearingSummary.MachineHours_YR1) MACHINEHOURS_YR1,
		  SUM(clearingSummary.MachineHours_YR2) MACHINEHOURS_YR2,
		  SUM(clearingSummary.PROJHOURS_YR1) PROJHOURS_YR1,
		  SUM(clearingSummary.PROJHOURS_YR2) PROJHOURS_YR2,
		  clearingSummary.ACCOUNT_NM, clearingSummary.OBJCD, clearingSummary.FIN_OBJ_CD_NM, 
		  clearingSummary.FEEDESCR,
		  clearingSummary.FEE_ID,
		  clearingSummary.ADJ_RATE, clearingSummary.ADJ_ESCL_RATE_YR1,
		  clearingSummary.ADJ_ESCL_RATE_YR2,
		  clearingSummary.FEE_LOWYEAR,
		  clearingSummary.RES RESIDENCY, clearingSummary.RES,
		  clearingSummary.TERM TRMLABEL
		FROM #application.hours_to_project# clearingSummary
		WHERE clearingSummary.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#">
		  AND clearingSummary.RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
		GROUP BY clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.RC, clearingSummary.FEECODE, clearingSummary.TERM, clearingSummary.ACCOUNT, 
		clearingSummary.ACCOUNT_NM, clearingSummary.OBJCD, clearingSummary.FIN_OBJ_CD_NM, clearingSummary.FEEDESCR, clearingSummary.SESN,clearingSummary.SELGROUP,
		clearingSummary.FEE_ID, clearingSummary.FEE_LOWYEAR, clearingSummary.RES,clearingSummary.ADJ_RATE, clearingSummary.ADJ_ESCL_RATE_YR1,
		clearingSummary.ADJ_ESCL_RATE_YR2
	</cfquery>
	<cfquery dbtype="query" name="finalSummary">
		SELECT clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.RC, 
			clearingSummary.FEECODE, clearingSummary.TERM,clearingSummary.SESNLABEL,clearingSummary.SESN,
		  clearingSummary.ACCOUNT,clearingSummary.HEADCOUNT,clearingSummary.HOURS,clearingSummary.SELGROUP,
		  clearingSummary.MACHINEHOURS_YR1, clearingSummary.MACHINEHOURS_YR2,
		  clearingSummary.PROJHOURS_YR1, clearingSummary.PROJHOURS_YR2, 
		  clearingSummary.ACCOUNT_NM, clearingSummary.OBJCD, clearingSummary.FIN_OBJ_CD_NM,clearingSummary.FEEDESCR,
		  clearingSummary.FEE_ID,
		  clearingSummary.ADJ_RATE, clearingSummary.ADJ_ESCL_RATE_YR1,
		  clearingSummary.ADJ_ESCL_RATE_YR2,
		  clearingSummary.FEE_LOWYEAR,
		  aggregatedEstRev.ESTREV_YR1,aggregatedEstRev.ESTREV_YR2,clearingSummary.RES,
		  clearingSummary.RESIDENCY,clearingSummary.TRMLABEL,clearingSummary.TERM
		FROM clearingSummary,
		aggregatedEstRev
		WHERE clearingSummary.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#">
		  AND clearingSummary.RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
		  AND aggregatedEstRev.CHART = clearingSummary.CHART
		  <!---AND aggregatedEstRev.RC = clearingSummary.RC--->
		  AND aggregatedEstRev.FEECODE = clearingSummary.FEECODE
		  AND aggregatedEstRev.TERM = clearingSummary.TERM
	</cfquery>
	<!---<cfreturn finalSummary>--->
	<cfreturn aggregatedEstRev>
</cffunction>

<cffunction name="trackProjectinatorAction" output="false">
	<cfargument name="loginId" required="true" default="#REQUEST.AuthUser#" />
	<cfargument name="campusId" required="true" /> 
	<cfargument name="actionId" required="true" />
	<cfargument name="description" required="false" default="" />
	<cfargument name="parameterCd" required="false" default="" />
	<cfquery datasource="#application.datasource2#" name="makeMeta">
		INSERT INTO METADATA
		(USER_ID,CAMPUS_ID,ACTION_ID,DESCRIPTION)
		VALUES
		('#loginId#','#campusId#','#actionId#','#description#')
	</cfquery>

</cffunction>  

<!--- Generic Excel sheet without any data - this empty template is the only one we need for this application --->
<cffunction name="setupRevenueTemplate" hint="Setup details for Revenue Projector Excel template" >
	<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
	<cfset sheet = SpreadSheetNew("FY20-21 Cr Hr Rev Projection")>		
	<!--- Add Excel title row 1 --->
	<cfif application.rateStatus eq "Vc">
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY20-21 - Constant Effective Rate Estimated Revenue")>
	<cfelseif application.rateStatus eq "V1">
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY20-21 - Escalated Rate Estimated Revenue")>
	<cfelse>
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY20-21")>
	</cfif>



	<!---<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),1)>--->
	<cfset SpreadsheetMergeCells(sheet,1,1,1,29)>
	<cfset SpreadsheetSetRowHeight(sheet,1,40)>
	<!--- Add Excel title row 2 --->
	<cfset SpreadsheetAddRow(sheet,"Projecting Fiscal Year 2021 - this spreadsheet was downloaded #DateTimeFormat(Now())#")>
	<!---<cfset SpreadsheetFormatRow(sheet, setExcelSubTitleFormatting(),2)>--->
	<cfset SpreadsheetMergeCells(sheet,2,2,1,29)>
	<!--- Add Excel title row 3 --->
	<cfset SpreadsheetAddRow(sheet, "NOTE: To match the the University Fiscal Analysis remove these fee codes from the Fee Codes filter in column F: ACPR$ G901N$ G901R$ LWARN$ MUSX OTHER OVST OVSTN$ OVSTR$")>
	<cfset SpreadsheetMergeCells(sheet,3,3,1,29)>
	<cfset SpreadsheetAddRow(sheet, "ID,Campus,Chart,RC,Term,Semester,Fee Code,Fee Code Descr,Tuition Group,Academic Career,Residency,Account,Account Name,Object Code,Object Code Name,Spacer1,Fy19 Headcount,FY19 Actual Credit Hours,Current FY19 Rate,FY20 Enrollment Study Hours,FY21 Enrollment Study Hours,Spacer2,FY20 Escalated Rate, FY20 Campus Projected Hours, FY20 Estimated Revenue,Spacer3,FY21 Escalated Rate,FY21 Campus Projected Hours, FY21 Estimated Revenue")>
	<!---<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),3)>--->
	<cfset SpreadsheetSetRowHeight(sheet,1,30)>
	<!--- Set up columns - widths are determined manually by adjusting the column titles. Ratio in Excel is 7:1 (width "6" here shows as 42 pixels in Excel). --->
	<cfset SpreadsheetSetColumnWidth(sheet,1,10)>    <!--- A ID --->
	<cfset SpreadsheetFormatColumn(sheet,{hidden=true},1)>    <!--- A ID --->
	<cfset SpreadsheetSetColumnWidth(sheet,2,10)>    <!--- B INST --->
	<cfset SpreadsheetSetColumnWidth(sheet,3,10)>    <!--- B Chart --->
	<cfset SpreadsheetSetColumnWidth(sheet,4,10)>    <!--- C RC --->
	<cfset SpreadsheetSetColumnWidth(sheet,5,10)>   <!--- D Term --->
	<cfset SpreadsheetSetColumnWidth(sheet,6,12)>   <!--- E Semester --->
	<cfset SpreadsheetSetColumnWidth(sheet,7,12)>    <!--- F Fee Code --->
	<cfset SpreadsheetSetColumnWidth(sheet,8,36)>   <!--- G Fee Code Description --->
	<cfset SpreadsheetSetColumnWidth(sheet,9,16)>   <!--- H Tuition Group --->
	<cfset SpreadsheetSetColumnWidth(sheet,10,18)>   <!--- I Academic Career --->
	<cfset SpreadsheetSetColumnWidth(sheet,11,12)>    <!--- J Residency --->
	<cfset SpreadsheetSetColumnWidth(sheet,12,10)>   <!--- K Account --->
	<cfset SpreadsheetSetColumnWidth(sheet,13,30)>  <!--- L Account Name --->
	<cfset SpreadsheetSetColumnWidth(sheet,14,14)>  <!--- M Object Code --->
	<cfset SpreadsheetSetColumnWidth(sheet,15,33)>  <!--- N Obj Cd Name --->
	<cfset SpreadsheetSetColumnWidth(sheet,16,10)>   <!--- O spacer1 --->
	
	<cfset SpreadsheetSetColumnWidth(sheet,17,18)>  <!--- P FY19 Headcount --->
	<cfset SpreadsheetSetColumnWidth(sheet,18,25)>  <!--- Q FY19 Actual CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,19,20)>   <!--- R FY19 Current Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,20,30)>  <!--- S FY20 ES CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,21,30)>  <!--- T FY21 ES CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,22,10)>  <!--- U Spacer2 --->

	<cfset SpreadsheetSetColumnWidth(sheet,23,22)>  <!--- V FY20 Escalated Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,24,30)>  <!--- W FY20 Campus Projected Hours --->
	<cfset SpreadsheetSetColumnWidth(sheet,25,26)>  <!--- X FY20 Estimated Revenue --->
	<cfset SpreadsheetSetColumnWidth(sheet,26,10)>   <!--- Y Spacer3 --->
		
	<cfset SpreadsheetSetColumnWidth(sheet,27,22)>  <!--- Z FY21 Escalated Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,28,30)>  <!--- AA FY21 Campus Proj CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,29,26)>  <!--- BB FY21 Estimated Revenue --->
	
	<cfset SpreadSheetAddAutofilter(sheet, "A4:BB4")>
	<cfset SpreadSheetAddFreezePane(sheet,2,4)>
	<!--- formatting columns --->
	<!---<cfset SpreadsheetFormatColumn(sheet, {dataformat="($##,####0.00($##,####0.00)"}, 25)>--->  <!--- example of formatting a column as currency --->
	<!---<cfset SpreadSheetSetColumnWidth(sObj, 14, 0)> example of hiding a column by setting the width = 0  --->
	<!--- <cfset spreadsheetFormatColumn(sheet, {dataformat='[Green]"Y";;[Red]"N"'}, "1-2")>   --->
	<cfreturn sheet />
</cffunction>

<cffunction name="setCASuserAccess_level" output="false">
	<cfargument name="username" required="true">
 	<!--- Check our Users table for this person  --->
	<!---<cfset user_details = EntityLoad("Users",{"USERNAME":#username#},true) />--->
	<cfquery datasource="#application.datasource#" name="user_details">
		SELECT ACCESS_LEVEL
		FROM USERS
		WHERE USERNAME = <cfqueryparam cfsqltype="cf_sql_char" value="#username#">
	</cfquery>
	<cfif IsDefined("user_details") AND user_details.getAccess_level() neq "">
		<cfset session.access_level = user_details.getAccess_level() />
	<cfelse>
		<cfset session.access_level = "Guest" />
	</cfif>
</cffunction>

<cffunction name="setCASuserChart" output="false">
	<cfargument name="username" required="true">
 	<!--- Check our Users table for this person  --->
	<!---<cfset user_details = EntityLoad("Users",{"USERNAME":#username#},true) />--->
	<cfquery datasource="#application.datasource#" name="user_details">
		SELECT CHART
		FROM USERS
		WHERE USERNAME = <cfqueryparam cfsqltype="cf_sql_char" value="#username#">
	</cfquery>
	<cfif IsDefined("user_details") AND user_details.getAccess_level() neq "">
		<cfset session.chart = user_details.getChart() />
	<cfelse>
		<cfset session.chart = "--" />
	</cfif>
</cffunction>

<cffunction name="getB325_V1_Campus_data" output="true">
	<cfargument name="campus" type="string" default="">
	<cfargument name="fee_RC" type="string" default="">
	<cfargument name="RC_only" type="string">
	<cfargument name="university_user" type="string" default="N" required="false" >
	<cfquery datasource="#application.datasource2#" name="B325_V1_Campus_data">
SELECT 
h.INST as "Bus Unit",
h.CHART as "KFS Chart",
CASE
      WHEN h.INST = 'IUINA' AND RC = '10'
        THEN 'IM'
      WHEN h.INST = 'IUINA' AND RC <> '10'
        THEN 'IN'
      WHEN h.INST = 'IUBLA'
        THEN 'BL'
      WHEN h.INST = 'IUEAA'
        THEN 'EA'
      WHEN h.INST = 'IUKOA'
        THEN 'KO'
      WHEN h.INST = 'IUNWA'
        THEN 'NW'
      WHEN h.INST = 'IUSBA'
        THEN 'SB'
      WHEN h.INST = 'IUSEA'
        THEN 'SE'
      WHEN h.INST = 'IUUAA'
        THEN 'UA'
      ELSE 'n/a'
    END AS "Rptg Chrt",
h.RC as "RC Code",
rcb.RC_NM as "RC Name",
h.ACCOUNT as "Account Number",
h.ACCOUNT_NM as "Account Name",
rcb.RCB_EXCL as "RCB Excl",  
rcb.SCHOOL  as "School",
h.SELGROUP as "Tuition Group",
sg.DESCR as "Tuition Group Descr",
  CASE WHEN h.FEECODE IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER', 'RHSR$') 
  THEN 'Y'
  ELSE 'N'
  END as "TG Excl",
h.FEECODE as "Fee Code",
h.FEEDESCR as "Fee Code Descr",
h.FEE_DISTANCE as "Distance",                          
k.FEEID as "Fee ID",
ac.LEVEL_CD as "Career Categ",  
ac.SLEVEL as "Level",  
h.SESN as "Term Code",  
DECODE (h.SESN, 'FL', 'Fall',
              'SP', 'Spring',
              'SS1', 'Summer 1',
              'SS2', 'Summer 2',
              'WN', 'Winter',
              '') as "Acad Term", 
t.Expanded_Descr as "Term Long Descr", 
t.DESCRSHORT as "Term Shrt Descr",  
r.RES_GRP as "Residency Desc",
h.OBJCD as "Object Code",
ob.FIN_OBJ_CD_SHRT_NM as "Object Code Shrt Name",
pf.PROFORMA_CD as "ProForma Cd",
pf.PROFORMA_CD_NM as "ProForma Nm",
  CASE WHEN h.FEECODE IN ('ACPR$', 'ACPNR$', 'BCN$', 'BCR$', 'NTDLR$', 'RHSR$') 
  THEN 'DUAL'
  WHEN h.FEECODE IN ('OVSTR$', 'OVSTN$')
  THEN 'OVST'
  WHEN h.FEECODE IN ('OCCH$', 'OCCE$')
  THEN 'OCC'
  WHEN h.FEECODE IN ('BANR$', 'BANN$', 'OVST', 'OTHER', 'MUSX','OCCI$')
  THEN 'EXCL'
  ELSE 'REG'
  END as "UIRR Rpt Categ",
h.HEADCOUNT as "Heads",
h.HOURS as "Act CH", 
h.MACHINEHOURS_YR1 as "UBO Proj Hrs_Yr1",  
h.PROJHOURS_YR1 as "Camp Proj Hrs_Yr1", 
h.MACHINEHOURS_YR2 as "UBO Proj Hrs_Yr2",  
h.PROJHOURS_YR2 as "Camp Proj Hrs_Yr2", 
h.ADJ_RATE as "Const Eff Rt",  
h.ADJ_ESCL_RATE_YR1 as "Escltd Eff Rt_Yr1", 
h.ADJ_ESCL_RATE_YR2 as "Escltd Eff Rt_Yr2",  
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_RATE * h.MACHINEHOURS_YR1, 2) 
ELSE 0 END as "UBO Tuit Rev Vc_Yr1",  
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_RATE * h.MACHINEHOURS_YR2, 2) 
ELSE 0 END as "UBO Tuit Rev Vc_Yr2",  
ROUND(h.ADJ_ESCL_RATE_YR1 * h.MACHINEHOURS_YR1, 2) as "UBO Tuit Rev v1_Yr1", 
ROUND(h.ADJ_ESCL_RATE_YR2 * h.MACHINEHOURS_YR2, 2) as "UBO Tuit Rev v1_Yr2",
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_RATE * h.PROJHOURS_YR1, 2) 
ELSE 0 END as "Tuit Rev Vc_Yr1",  
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_RATE * h.PROJHOURS_YR2, 2) 
ELSE 0 END as "Tuit Rev Vc_Yr2",  
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_ESCL_RATE_YR1 * h.PROJHOURS_YR1, 2) 
ELSE 0 END as "Tuit Rev v1_Yr1",  
CASE
WHEN h.FEECODE NOT IN ('OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
THEN ROUND(h.ADJ_ESCL_RATE_YR2 * h.PROJHOURS_YR2, 2) 
ELSE 0 END as "Tuit Rev v1_Yr2",  
h.RC as "RC Code2",
rcb.RC_NM as "RC Name2",
h.ACCOUNT_NM as "Account Name2",
'' as "s1",	
'' as "s2"	
FROM #application.HOURS_TO_PROJECT# h
    LEFT OUTER JOIN CH_USER.BCN_PF_CODE_T pf
      ON h.OBJCD = pf.FIN_OBJECT_CD
    LEFT OUTER JOIN CH_USER.RCB_MATRIX rcb 
		  ON rcb.CHART = h.CHART AND rcb.RC_CD = h.RC AND rcb.ACCOUNT = h.ACCOUNT
		LEFT OUTER JOIN CH_USER.OBJ_MTRX ob   
		  ON ob.FIN_OBJECT_CD = h.OBJCD
		LEFT OUTER JOIN CH_USER.ACAD_CAREER ac   
		  ON ac.ACADEMIC_CAREER = h.ACAD_CAREER
		LEFT OUTER JOIN CH_USER.SEL_GRP sg   
		  ON sg.BUSINESS_UNIT = h.INST AND sg.SEL_GROUP = h.SELGROUP
		LEFT OUTER JOIN CH_USER.TERM t   
		  ON t.SESN = h.SESN and t.STRM = h.TERM
		LEFT OUTER JOIN CH_USER.RESIDENCY r   
		  ON r.RES = h.RES
		LEFT OUTER JOIN FEE_USER.FEECODETOFEEKEYMAP k
		  ON k.INST = h.INST
		  AND k.FEECODE = h.FEECODE
	  <cfif university_user eq 'N'>
		<!---WHERE H.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#campus#">--->
		WHERE SUBSTR(H.INST,3,2) = <cfqueryparam cfsqltype="cf_sql_char" value="#campus#">
		  <cfif RC_only eq true>
		  	AND H.RC = <cfqueryparam cfsqltype="cf_sql_char" value="#fee_RC#">
		  </cfif>
	  </cfif>
	</cfquery>
	<cfreturn B325_V1_Campus_data>
</cffunction>

<cffunction name="getUBO_TOOL_SETTINGS" output="true">
	<cfargument name="campus" type="string" default="">
	<cfargument name="fee_RC" type="string" default="">
	<cfset institution_code = "IU" & campus & "A">
	<cfquery datasource="#application.datasource2#" name="UBO_TOOL_SETTINGS_data">
		SELECT INST_CD, RC_CD, PRIMARY_TUIT_GRP
		FROM FEE_USER.UBO_TOOL_SETTINGS
		WHERE INST_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#institution_code#">
		  AND RC_CD = <cfqueryparam cfsqltype="cf_sql_char" value="#fee_RC#">
	</cfquery>
	<cfreturn UBO_TOOL_SETTINGS_data.PRIMARY_TUIT_GRP>
</cffunction>