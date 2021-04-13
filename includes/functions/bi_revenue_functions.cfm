  <cffunction name="getNoFCPRows">
  	<cfargument name="selectedCampus" required="true" />
	<cfargument name="clearingRC" />
	<cfquery name="noFCProws" datasource="#application.datasource#">
		SELECT h.OID,h.INST, h.CHART,
		<cfif application.budget_year eq "YR1">
			h.b1_RC, h.b1_TERM as TERM,h.SESN as TRMLABEL,
			h.FEECODE, h.FEEDESCR, h.note, h.SELGROUP, TRIM(h.ACAD_CAREER) as ACAD_CAREER, h.RES, h.ACCOUNT, h.ACCOUNT_NM,
			h.b1_OBJCD as OBJCD, h.b1_FIN_OBJ_CD_NM as FIN_OBJ_CD_NM, '' as spacer1, h.b1_headcount as HEADCOUNT, h.b1_hours as HOURS, h.b1_adj_rate as ADJ_RATE,
			CASE h.b1_MACHHRS_YR1
	    		WHEN 0 THEN '0'
	    		ELSE TO_CHAR(h.b1_MACHHRS_YR1,'9999999.9')
	   		END AS MACHHRS_YR1,
			CASE h.b1_MACHHRS_YR2
	     		WHEN 0 THEN '0'
	     		ELSE TO_CHAR(h.b1_MACHHRS_YR2,'9999999.9')
	   		END AS MACHHRS_YR2,
	   		'' as spacer2, h.b1_ADJ_RATE, h.b1_PROJHRS_YR1 as PROJHOURS_YR1,
	   		<cfif application.rateStatus eq 'Vc'>
		    	h.b1_ADJ_RATE * h.b1_PROJHRS_YR1 ESTREV_YR1,
			<cfelseif application.rateStatus eq 'V1'>
		    	h.b1_ADJ_ESCL_RATE_YR1 *h.b1_PROJHRS_YR1 ESTREV_YR1,
	    	</cfif>
	   		'' as spacer3, h.b2_adj_rate, h.b1_projhrs_yr2 as PROJHOURS_YR2,
	   		<cfif application.rateStatus eq 'Vc'>
    	    	h.b1_ADJ_RATE * h.b1_PROJHRS_YR2 ESTREV_YR2,
			<cfelseif application.rateStatus eq 'V1'>
		    	h.b1_ADJ_ESCL_RATE_YR2 * h.b1_PROJHRS_YR2 ESTREV_YR2,
	    	</cfif>
		<cfelse>
			h.b2_RC, h.b2_TERM as TERM,
			h.SESN as TRMLABEL,
	    	h.FEECODE, h.FEEDESCR, h.note, h.SELGROUP, TRIM(h.ACAD_CAREER) as ACAD_CAREER, h.RES, h.ACCOUNT, h.ACCOUNT_NM,
			h.b2_OBJCD as OBJCD, h.b2_FIN_OBJ_CD_NM as FIN_OBJ_CD_NM, '' as spacer1, h.b2_headcount as HEADCOUNT, h.b2_hours as HOURS, h.b1_adj_escl_rate_yr1 as ADJ_RATE,
			CASE h.b1_MACHHRS_YR1
	    		WHEN 0 THEN '0'
	    		ELSE TO_CHAR(h.b1_MACHHRS_YR1,'9999999.9')
	   		END AS MACHHRS_YR1,
		    CASE h.b2_MACHHRS_YR2
		    	WHEN 0 THEN '0'
		    	ELSE TO_CHAR(h.b2_MACHHRS_YR2,'9999999.9')
		   	END AS MACHHRS_YR2,
		   	'' as spacer2, h.b1_ADJ_RATE, h.b1_PROJHRS_YR1 as PROJHOURS_YR1,
		   	h.b1_ADJ_ESCL_RATE_YR1 * h.b1_PROJHRS_YR1 ESTREV_YR1,
		   	<!--- unchanged from before when it ended using adj escl rate --->
		   	'' as spacer3, h.b2_adj_escl_rate_yr2, h.b2_projhrs_yr2 as PROJHOURS_YR2,
    	    h.b2_ADJ_ESCL_RATE_YR2 * h.b2_PROJHRS_YR2 ESTREV_YR2,
    	    <!--- unchanged escalated rate, 2nd-year projhrs - how we left it end of YR1 --->
		</cfif>
		 h.SESN, '('||h.SELGROUP||', '||h.FEECODE||')' FEEKEY,
	    <cfif application.budget_year eq "YR1">
	    	h.b1_fee_id as FEE_ID
	    <cfelse>  <!--- YR2 is the only other possibility --->
	    	h.b2_fee_id as FEE_ID
	    </cfif>
	 	    , h.b1_ADJ_ESCL_RATE_YR1, h.b1_ADJ_ESCL_RATE_YR2, h.b1_fee_residency, h.b1_ADJ_RATE,
		    h.b2_fee_id, h.b2_objcd, h.b2_fin_obj_cd_nm, h.b2_projhrs_yr2, h.b2_hours, h.b2_adj_rate, h.b2_adj_escl_rate_yr2,
		    h.fee_current, h.fee_lowyear, h.fee_highyear, h.RES, h.b1_projhrs_yr2, h.b1_RC, s.gl_sub_acct_cd
	FROM #application.hours_to_project# h LEFT JOIN ch_user.htp_subaccount s
    ON h.inst = s.bursar_bsns_unit_cd and h.b2_term = s.sf_trm_cd and h.feecode = s.sf_trm_fee_cd and h.selgroup = s.sf_tuit_grp_ind and h.account = s.gl_acct_nbr 
		where selgroup = 'NO FCP'
		  and inst = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedCampus#" />
		  <cfif application.budget_year eq 'YR1'>AND h.b1_RC
		  <cfelse>AND h.b2_RC
		  </cfif> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#clearingRC#" />
	</cfquery>
  	<cfreturn noFCProws />
  </cffunction>
  
  <cffunction name="dismantleError">
  	<cfargument name="e" type="any" required="true">
  	<cfscript>
  		//unwrap the InvocationTargetException so we can see what's inside: put in struct & list the keys
			errorAsData = {};
			structAppend( errorAsData, e );
			keyArray = StructKeyList(errorAsData);
			WriteOutput(" <br>Error key list:</b> " & keyArray );
			for (i in keyArray) {
				if (isValid("array", errorAsData[i])) {
					WriteOutput(" <br>" & i & " key/value list:</b>");

					for (d in errorAsData[i]) { 	//loop the array
		  				for (key in d) { 					// loop the struct
		     				WriteOutput("<br> <b> -- key:</b> " & key & ": <b>value:</b> " & d[key]);
		  				}
					}

					//dismantleError(errorAsData[i]);
				} else {
					writeOutput("<br> <b>index:</b> " & i & " <b>key:</b> " & errorAsData[i]);
				}
			}
  	</cfscript>
  </cffunction>

  <cffunction name="getUser" output="true">
  	<cfargument name="username" required="true" type="string">
  	<cfargument name="userActive" required="false" type="string" default="Y">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,ALLFEES_RCS, PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  		<cfif userActive neq "ANY">
  			AND ACTIVE = <cfqueryparam value="#userActive#" cfsqltype="cf_sql_varchar">
  		</cfif>
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
  	<cfargument name="givenUser" required="false" default="#REQUEST.authuser#">
  	<cfargument name="literal" required="false" default="ID10T">
  	<cfquery datasource="#application.datasource#" name="getUserList">
  		SELECT ID, USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,
  		PROJECTOR_RC,ALLFEES_RCS,PHONE,ACTIVE,CREATED_ON, ROW_NUMBER() OVER (ORDER BY username) as num
  		FROM fee_user.USERS
  		WHERE ACCESS_LEVEL != 'GUEST'
  		<cfif literal neq "ID10T">
  			AND username = <cfqueryparam value="#literal#" cfsqltype="cf_sql_varchar">
  		</cfif>
  		<cfif givenUser neq "She-Ra" and literal eq 'ID10T'>
	  		and CHART = (
	  			SELECT CHART
	  			FROM fee_user.USERS
	  			WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#givenUser#" cfsqltype="cf_sql_varchar">
	  		   )
			and access_level NOT IN ('bduser','TREAS')
  		</cfif>
  		ORDER BY username ASC
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

<cffunction name="getDistinctRCs">
	<cfargument name="givenCampus" type="string" required="false" default="NONE">
	<cfargument name="givenBudgetYear" type="string" required="false" default="#application.budget_year#">
		<cfif givenBudgetYear eq 'YR1'><cfset activeYrRC = "b1_rc"><cfelse><cfset activeYrRC = "b2_rc"></cfif>
	<cfquery name="distinctRCs" datasource="#application.datasource#" >
		SELECT DISTINCT #activeYrRC# as ACTIVE_RC, rc_nm
		FROM #application.hours_to_project#
		WHERE biennium = '#application.biennium#'
        <cfif givenCampus neq 'NONE'>AND chart = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#"></cfif>
		  AND #activeYrRC# IS NOT NULL
		  AND FEECODE NOT LIKE ('BAN%')
		ORDER BY #activeYrRC# ASC
	</cfquery>
	<cfreturn distinctRCs>
</cffunction>

<cffunction name="getDistinctSesns">
	<cfargument name="givenCampus" type="string" required="true">
	<cfargument name="givenBudgetYear" type="string" required="false" default="#application.budget_year#">
	<cfquery name="distinctSesns" datasource="#application.datasource#" >
		SELECT DISTINCT sesn as SESN
		FROM #application.hours_to_project#
		WHERE biennium = '#application.biennium#'
          AND chart = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">
		ORDER BY sesn ASC
	</cfquery>
	<cfreturn distinctSesns>
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
	    <cfif application.budget_year eq 'YR1'>and h.b1_rc = r.rc_cd<cfelse>and h.b2_rc = r.rc_cd</cfif>
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
	<cfargument name="selectedRC" default="NONE">
	<cfargument name="selectedVersion" required="true">
	<cfargument name="queryPurpose" required="false" default="interface">
	<cfset selectedCampus = 'IU'&#selectedCampus#&'A'>
	<cfquery datasource="#application.datasource2#" name="DataSelect">
		SELECT h.OID,h.INST, h.CHART,
		<cfif application.budget_year eq "YR1">
			h.b1_RC, h.b1_TERM as TERM,h.SESN as TRMLABEL,
			h.FEECODE, h.FEEDESCR, h.note, 
			CASE 
			  WHEN h.SELGROUP IS NULL THEN '--n'
			  WHEN h.SELGROUP = '' THEN '--e'
			  WHEN h.SELGROUP = ' ' THEN '--s'
			  ELSE h.SELGROUP END,
			TRIM(h.ACAD_CAREER) as ACAD_CAREER, h.RES, h.ACCOUNT, h.ACCOUNT_NM,
			h.b1_OBJCD as OBJCD, h.b1_FIN_OBJ_CD_NM as FIN_OBJ_CD_NM, '' as spacer1, h.b1_headcount as HEADCOUNT, h.b1_hours as HOURS, h.b1_adj_rate as ADJ_RATE,
			CASE h.b1_MACHHRS_YR1
	    		WHEN 0 THEN '0'
	    		ELSE TO_CHAR(h.b1_MACHHRS_YR1,'9999999.9')
	   		END AS MACHHRS_YR1,
			CASE h.b1_MACHHRS_YR2
	     		WHEN 0 THEN '0'
	     		ELSE TO_CHAR(h.b1_MACHHRS_YR2,'9999999.9')
	   		END AS MACHHRS_YR2,
	   		'' as spacer2, 
	   		<cfif application.rateStatus eq 'Vc'>
	   			h.b1_adj_rate, 
	   		<cfelseif application.rateStatus eq 'V1'>
	   			h.b1_ADJ_ESCL_RATE_YR1,
	   		</cfif>
	   		 h.b1_PROJHRS_YR1 as PROJHOURS_YR1,
	   		<cfif application.rateStatus eq 'Vc'>
		    	h.b1_ADJ_RATE * h.b1_PROJHRS_YR1 ESTREV_YR1,
			<cfelseif application.rateStatus eq 'V1'>
		    	h.b1_ADJ_ESCL_RATE_YR1 *h.b1_PROJHRS_YR1 ESTREV_YR1,
	    	</cfif>  
	   		'' as spacer3, 
	   		<cfif application.rateStatus eq 'Vc'>
	   			h.b1_adj_rate, 
	   		<cfelseif application.rateStatus eq 'V1'>
	   			h.b1_ADJ_ESCL_RATE_YR2,
	   		</cfif>
	   		h.b1_projhrs_yr2 as PROJHOURS_YR2,
	   		<cfif application.rateStatus eq 'Vc'>
    	    	h.b1_ADJ_RATE * h.b1_PROJHRS_YR2 ESTREV_YR2,
			<cfelseif application.rateStatus eq 'V1'>
		    	h.b1_ADJ_ESCL_RATE_YR2 * h.b1_PROJHRS_YR2 ESTREV_YR2,
	    	</cfif>
		<cfelse>
			h.b2_RC, h.b2_TERM as TERM,
			h.SESN as TRMLABEL,
	    	h.FEECODE, h.FEEDESCR, h.note, h.SELGROUP, TRIM(h.ACAD_CAREER) as ACAD_CAREER, h.RES, h.ACCOUNT, h.ACCOUNT_NM,
			h.b2_OBJCD as OBJCD, h.b2_FIN_OBJ_CD_NM as FIN_OBJ_CD_NM, '' as spacer1, h.b2_headcount as HEADCOUNT, h.b2_hours as HOURS, h.b1_adj_escl_rate_yr1 as ADJ_RATE,
			CASE h.b1_MACHHRS_YR1
	    		WHEN 0 THEN '0'
	    		ELSE TO_CHAR(h.b1_MACHHRS_YR1,'9999999.9')
	   		END AS MACHHRS_YR1,
		    CASE h.b2_MACHHRS_YR2
		    	WHEN 0 THEN '0'
		    	ELSE TO_CHAR(h.b2_MACHHRS_YR2,'9999999.9')
		   	END AS MACHHRS_YR2,
		   	'' as spacer2, h.b1_ADJ_RATE, h.b1_PROJHRS_YR1 as PROJHOURS_YR1,
		   	h.b1_ADJ_ESCL_RATE_YR1 * h.b1_PROJHRS_YR1 ESTREV_YR1,
		   	<!--- unchanged from before when it ended using adj escl rate --->
		   	'' as spacer3, h.b2_adj_escl_rate_yr2, h.b2_projhrs_yr2 as PROJHOURS_YR2,
    	    h.b2_ADJ_ESCL_RATE_YR2 * h.b2_PROJHRS_YR2 ESTREV_YR2,
    	    <!--- unchanged escalated rate, 2nd-year projhrs - how we left it end of YR1 --->
		</cfif>
		 h.SESN, '('||h.SELGROUP||', '||h.FEECODE||')' FEEKEY,
	    <cfif application.budget_year eq "YR1">
	    	h.b1_fee_id as FEE_ID
	    <cfelse>  <!--- YR2 is the only other possibility --->
	    	h.b2_fee_id as FEE_ID
	    </cfif>
	    <cfif queryPurpose eq "interface">
	 	    , h.b1_ADJ_ESCL_RATE_YR1, h.b1_ADJ_ESCL_RATE_YR2, h.b1_fee_residency, h.b1_ADJ_RATE,
		    h.b2_fee_id, h.b2_objcd, h.b2_fin_obj_cd_nm, h.b2_projhrs_yr2, h.b2_hours, h.b2_adj_rate, h.b2_adj_escl_rate_yr2,
		    h.fee_current, h.fee_lowyear, h.fee_highyear, h.RES, h.b1_projhrs_yr2, h.b1_RC, s.gl_sub_acct_cd
	    </cfif>
	FROM #application.hours_to_project# h LEFT JOIN ch_user.htp_subaccount s
    ON h.inst = s.bursar_bsns_unit_cd and h.b2_term = s.sf_trm_cd and h.feecode = s.sf_trm_fee_cd and h.selgroup = s.sf_tuit_grp_ind and h.account = s.gl_acct_nbr
	WHERE h.biennium = '#application.biennium#'
	  AND h.INST = '#selectedCampus#'
	  <cfif selectedRC neq "NONE">
		  <cfif application.budget_year eq 'YR1'>AND h.b1_RC = '#selectedRC#'
		  <cfelse>AND h.b2_RC = '#selectedRC#'
		  </cfif>
	  </cfif>
	  AND h.FEECODE NOT LIKE 'G901%$'
	  AND h.FEECODE NOT LIKE 'LWA%$' 
	  ---AND h.FEECODE NOT LIKE 'BAN%'
	  and h.selgroup != 'NO FCP'
	ORDER BY h.b1_RC ASC, h.FEECODE ASC, h.b1_TERM ASC
	</cfquery>
	<cfreturn DataSelect>
</cffunction>

<cffunction name="getAllRC_EstRev">
	<cfargument name="selectedCampus" type="string" default="">
	<cfquery datasource="#application.datasource2#" name="EstRevSelect">
		SELECT mid.inst, mid.rc_cd, mid.rc_nm,
		   SUM(FL_SUM_YR1) as FL_TOTAL_YR1, SUM(FL_CRHR_YR1) as FL_TOTAL_CRHR_YR1,
		   SUM(FL_SUM_YR2) as FL_TOTAL_YR2, SUM(FL_CRHR_YR2) as FL_TOTAL_CRHR_YR2,
		   SUM(SP_SUM_YR1) as SP_TOTAL_YR1, SUM(SP_CRHR_YR1) as SP_TOTAL_CRHR_YR1,
		   SUM(SP_SUM_YR2) as SP_TOTAL_YR2, SUM(SP_CRHR_YR2) as SP_TOTAL_CRHR_YR2,
		   SUM(S1_SUM_YR1) as S1_TOTAL_YR1, SUM(S1_CRHR_YR1) as S1_TOTAL_CRHR_YR1,
		   SUM(S1_SUM_YR2) as S1_TOTAL_YR2, SUM(S1_CRHR_YR2) as S1_TOTAL_CRHR_YR2,
		   SUM(S2_SUM_YR1) as S2_TOTAL_YR1, SUM(S2_CRHR_YR1) as S2_TOTAL_CRHR_YR1,
		   SUM(S2_SUM_YR2) as S2_TOTAL_YR2, SUM(S2_CRHR_YR2) as S2_TOTAL_CRHR_YR2,
		   SUM(WN_SUM_YR1) as WN_TOTAL_YR1, SUM(WN_CRHR_YR1) as WN_TOTAL_CRHR_YR1,
		   SUM(WN_SUM_YR2) as WN_TOTAL_YR2, SUM(WN_CRHR_YR2) as WN_TOTAL_CRHR_YR2,
	       (SUM(FL_CRHR_YR1) + SUM(SP_CRHR_YR1) + SUM(S1_CRHR_YR1) + SUM(S2_CRHR_YR1) + SUM(WN_CRHR_YR1)) as TOTAL_RC_CRHRS_YR1,
   		   SUM(FL_CRHR_YR2 + SP_CRHR_YR2 + S1_CRHR_YR2 + S2_CRHR_YR2 + WN_CRHR_YR2) as TOTAL_RC_CRHRS_YR2,
		   SUM(FL_SUM_YR1) + SUM(SP_SUM_YR1) + SUM(S1_SUM_YR1) + SUM(S2_SUM_YR1) + SUM(WN_SUM_YR1) as TOTAL_SUM_YR1,
		   SUM(FL_SUM_YR2) + SUM(SP_SUM_YR2) + SUM(S1_SUM_YR2) + SUM(S2_SUM_YR2) + SUM(WN_SUM_YR2) as TOTAL_SUM_YR2
		FROM
		(SELECT t.inst, t.RC_CD, t.rc_nm,
		    CASE WHEN t.SESN = 'FL' THEN SUM(t.ESTREV_YR1) END as FL_SUM_YR1,
		    CASE WHEN t.SESN = 'FL' THEN SUM(t.PROJHRS_TOTAL_YR1) END as FL_CRHR_YR1,
		    CASE WHEN t.SESN = 'FL' THEN SUM(t.ESTREV_YR2) END as FL_SUM_YR2,
		    CASE WHEN t.SESN = 'FL' THEN SUM(t.PROJHRS_TOTAL_YR2) END as FL_CRHR_YR2,
		    CASE WHEN t.SESN = 'SP' THEN SUM(t.ESTREV_YR1) END as SP_SUM_YR1,
		    CASE WHEN t.SESN = 'SP' THEN SUM(t.PROJHRS_TOTAL_YR1) END as SP_CRHR_YR1,
		    CASE WHEN t.SESN = 'SP' THEN SUM(t.ESTREV_YR2) END as SP_SUM_YR2,
		    CASE WHEN t.SESN = 'SP' THEN SUM(t.PROJHRS_TOTAL_YR2) END as SP_CRHR_YR2,
		    CASE WHEN t.SESN = 'SS1' THEN SUM(t.ESTREV_YR1) END as S1_SUM_YR1,
		    CASE WHEN t.SESN = 'SS1' THEN SUM(t.PROJHRS_TOTAL_YR1) END as S1_CRHR_YR1,
		    CASE WHEN t.SESN = 'SS1' THEN SUM(t.ESTREV_YR2) END as S1_SUM_YR2,
		    CASE WHEN t.SESN = 'SS1' THEN SUM(t.PROJHRS_TOTAL_YR2) END as S1_CRHR_YR2,
		    CASE WHEN t.SESN = 'SS2' THEN SUM(t.ESTREV_YR1) END as S2_SUM_YR1,
		    CASE WHEN t.SESN = 'SS2' THEN SUM(t.PROJHRS_TOTAL_YR1) END as S2_CRHR_YR1,
		    CASE WHEN t.SESN = 'SS2' THEN SUM(t.ESTREV_YR2) END as S2_SUM_YR2,
		    CASE WHEN t.SESN = 'SS2' THEN SUM(t.PROJHRS_TOTAL_YR2) END as S2_CRHR_YR2,
		    CASE WHEN t.SESN = 'WN' THEN SUM(t.ESTREV_YR1) END as WN_SUM_YR1,
		    CASE WHEN t.SESN = 'WN' THEN SUM(t.PROJHRS_TOTAL_YR1) END as WN_CRHR_YR1,
		    CASE WHEN t.SESN = 'WN' THEN SUM(t.ESTREV_YR2) END as WN_SUM_YR2,
		    CASE WHEN t.SESN = 'WN' THEN SUM(t.PROJHRS_TOTAL_YR2) END as WN_CRHR_YR2
				FROM
				(SELECT htp.inst, htp.sesn,
				  <cfif application.budget_year eq "YR1">
				  	htp.b1_RC as RC_CD,
				  	SUM(htp.b1_projhrs_yr1) as PROJHRS_TOTAL_YR1,
				  	SUM(htp.b1_projhrs_yr2) as PROJHRS_TOTAL_YR2,
			        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
			        SUM(htp.b1_ADJ_ESCL_RATE_YR2 * htp.b1_PROJHRS_YR2) ESTREV_YR2,
				  <cfelse>
				  	htp.b2_rc RC_CD,
				  	SUM(htp.b1_projhrs_yr1) as PROJHRS_TOTAL_YR1,
				  	SUM(htp.b2_projhrs_yr2) as PROJHRS_TOTAL_YR2,
			        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
			        SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) ESTREV_YR2,
				  </cfif>
				  htp.rc_nm
				   FROM #application.hours_to_project# htp
				   WHERE htp.biennium = '#application.biennium#'
				     AND htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedCampus#">
					 AND htp.FEECODE NOT LIKE 'G901%$'
					 AND htp.FEECODE NOT LIKE 'LWA%$'
					 AND htp.FEECODE NOT LIKE 'ACP%'
					 <!---AND htp.FEECODE NOT LIKE 'BAN%'--->
				<cfif application.budget_year eq "YR1">
					GROUP BY htp.inst, htp.sesn, htp.b1_RC, htp.RC_NM
				<cfelse>
					GROUP BY htp.inst, htp.sesn, htp.b2_RC, htp.RC_NM
				</cfif>
				) t
			GROUP BY  t.inst, t.RC_CD, t.RC_NM, t.sesn) mid
		GROUP BY mid.inst, mid.rc_cd, mid.rc_nm
	</cfquery>
	<cfquery dbtype="query" name="EstRevSelect_sorted">
		SELECT *
		FROM EstRevSelect
		ORDER BY RC_CD ASC
	</cfquery>
	<cfreturn EstRevSelect_sorted>
</cffunction>

<cffunction name="getCampusGrandTotals2" >
	<cfargument name="campus" default="" >
	<cfquery datasource="#application.datasource2#" name="campusGrandSelect">
		SELECT
	   SUM(t.FL_PH_TOT_YR1) as FL_PH_TOT_YR1, SUM(t.FL_PH_TOT_YR2) as FL_PH_TOT_YR2, SUM(t.FL_ESTREV_YR1) as FL_ESTREV_YR1, SUM(t.FL_ESTREV_YR2) as FL_ESTREV_YR2,
       SUM(t.SP_PH_TOT_YR1) as SP_PH_TOT_YR1, SUM(t.SP_PH_TOT_YR2) as SP_PH_TOT_YR2, SUM(t.SP_ESTREV_YR1) as SP_ESTREV_YR1, SUM(t.SP_ESTREV_YR2) as SP_ESTREV_YR2,
       SUM(t.S1_PH_TOT_YR1) as S1_PH_TOT_YR1, SUM(t.S1_PH_TOT_YR2) as S1_PH_TOT_YR2, SUM(t.S1_ESTREV_YR1) as S1_ESTREV_YR1, SUM(t.S1_ESTREV_YR2) as S1_ESTREV_YR2,
       SUM(t.S2_PH_TOT_YR1) as S2_PH_TOT_YR1, SUM(t.S2_PH_TOT_YR2) as S2_PH_TOT_YR2, SUM(t.S2_ESTREV_YR1) as S2_ESTREV_YR1, SUM(t.S2_ESTREV_YR2) as S2_ESTREV_YR2,
       SUM(t.WN_PH_TOT_YR1) as WN_PH_TOT_YR1, SUM(t.WN_PH_TOT_YR2) as WN_PH_TOT_YR2, SUM(t.WN_ESTREV_YR1) as WN_ESTREV_YR1, SUM(t.WN_ESTREV_YR2) as WN_ESTREV_YR2,
       SUM(t.PH_GRAND_YR1) as PH_GRAND_YR1, SUM(t.PH_GRAND_YR2) as PH_GRAND_YR2,
       SUM(t.REV_GRAND_YR1) as REV_GRAND_YR1, SUM(t.REV_GRAND_YR2) as REV_GRAND_YR2
FROM
(SELECT htp.sesn,
  CASE WHEN SESN = 'FL' THEN SUM(htp.b1_projhrs_yr1) END as FL_PH_TOT_YR1,
  CASE WHEN SESN = 'FL' THEN SUM(htp.b2_projhrs_yr2) END as FL_PH_TOT_YR2,
  CASE WHEN SESN = 'FL' THEN SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) END as FL_ESTREV_YR1,
  CASE WHEN SESN = 'FL' THEN SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) END as FL_ESTREV_YR2,
  CASE WHEN SESN = 'SP' THEN SUM(htp.b1_projhrs_yr1) END as SP_PH_TOT_YR1,
  CASE WHEN SESN = 'SP' THEN SUM(htp.b2_projhrs_yr2) END as SP_PH_TOT_YR2,
  CASE WHEN SESN = 'SP' THEN SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) END as SP_ESTREV_YR1,
  CASE WHEN SESN = 'SP' THEN SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) END as SP_ESTREV_YR2,
  CASE WHEN SESN = 'SS1' THEN SUM(htp.b1_projhrs_yr1) END as S1_PH_TOT_YR1,
  CASE WHEN SESN = 'SS1' THEN SUM(htp.b2_projhrs_yr2) END as S1_PH_TOT_YR2,
  CASE WHEN SESN = 'SS1' THEN SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) END as S1_ESTREV_YR1,
  CASE WHEN SESN = 'SS1' THEN SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) END as S1_ESTREV_YR2,
  CASE WHEN SESN = 'SS2' THEN SUM(htp.b1_projhrs_yr1) END as S2_PH_TOT_YR1,
  CASE WHEN SESN = 'SS2' THEN SUM(htp.b2_projhrs_yr2) END as S2_PH_TOT_YR2,
  CASE WHEN SESN = 'SS2' THEN SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) END as S2_ESTREV_YR1,
  CASE WHEN SESN = 'SS2' THEN SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) END as S2_ESTREV_YR2,
  CASE WHEN SESN = 'WN' THEN SUM(htp.b1_projhrs_yr1) END as WN_PH_TOT_YR1,
  CASE WHEN SESN = 'WN' THEN SUM(htp.b2_projhrs_yr2) END as WN_PH_TOT_YR2,
  CASE WHEN SESN = 'WN' THEN SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) END as WN_ESTREV_YR1,
  CASE WHEN SESN = 'WN' THEN SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) END as WN_ESTREV_YR2,
  SUM(htp.b1_projhrs_yr1) as PH_GRAND_YR1, SUM(htp.b2_projhrs_yr2) as PH_GRAND_YR2,
  SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) as REV_GRAND_YR1,
  SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) as REV_GRAND_YR2
FROM #application.hours_to_project# htp
WHERE htp.biennium = '#application.biennium#'
  AND htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#campus#">
  AND htp.FEECODE NOT LIKE 'G901%$'
	AND htp.FEECODE NOT LIKE 'LWA%$'
	AND htp.FEECODE NOT LIKE 'ACP%'
	AND htp.FEECODE NOT LIKE 'BAN%'
GROUP BY sesn) t
	</cfquery>
	<cfreturn campusGrandSelect />
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

<cffunction name="getFeeInfo" output="true">  <!--- RETAIN THIS! --->
	<cfargument name="currentOID" type="any" default="">
	<cfquery datasource="#application.datasource2#" name="getThisFee">
		SELECT biennium, inst, chart, b1_rc, selgroup, feecode, feedescr, acad_career, b1_term, sesn,
		  account, account_nm, b1_headcount, res,
		  b1_hours, b1_machhrs_yr1, b1_projhrs_yr1, b1_machhrs_yr2, b1_projhrs_yr2, b1_u_version, b1_objcd, b1_fin_obj_cd_nm,
		  b1_adj_rate, b1_adj_escl_rate_yr1, b1_adj_escl_rate_yr2, b1_fee_id, b1_fee_distance, b1_fee_residency,
		  fee_current, fee_lowyear, fee_highyear,
		  b2_rc, b2_term, b2_headcount, b2_hours, b2_machhrs_yr2, b2_projhrs_yr2, b2_u_version, b2_objcd, b2_fin_obj_cd_nm,
		  b2_adj_rate, b2_adj_escl_rate_yr2, b2_fee_id, b2_fee_distance, b2_fee_residency
		FROM #application.hours_to_project#
		WHERE biennium = '#application.biennium#' and OID = '#currentOID#'
	</cfquery>
	<cfreturn getThisFee>
</cffunction>

<cffunction name="updateFeeInfo" output="false">
	<cfargument name="thisOID" type="string" default="">
	<cfargument name="PROJHRS_YR1" type="numeric">
	<cfargument name="PROJHRS_YR2" type="numeric">
	<cftransaction>
		<cfquery datasource="#application.datasource2#" name="setFee">
			UPDATE #application.hours_to_project#
			<cfif application.budget_year eq 'YR1'>
				SET B1_PROJHRS_YR1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PROJHRS_YR1#" />,
			    B1_PROJHRS_YR2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PROJHRS_YR2#" />,
			    b1_U_VERSION = b1_U_VERSION + 1
			<cfelse>
				SET b2_PROJHRS_YR2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PROJHRS_YR2#" />,
			    b2_U_VERSION = b2_U_VERSION + 1
			</cfif>
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

<cffunction name="getClearingSummary" output="true">
	<cfargument name="selectedCampus" default="NONE">
	<cfargument name="clearingRC" default="NONE">
	<cfset aggregatedEstRev = getProjectinatorData(selectedCampus,clearingRC,application.rateStatus) />
	<cfquery datasource="#application.datasource2#" name="clearingSummary">
		SELECT clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART,
		<cfif application.budget_year eq "YR1">
		  clearingSummary.b1_RC as RC, clearingSummary.b1_TERM as TERM, clearingSummary.SESN TRMLABEL,
		  clearingSummary.FEECODE, clearingSummary.FEEDESCR, clearingSummary.SELGROUP,
		  clearingSummary.RES, clearingSummary.ACCOUNT, clearingSummary.ACCOUNT_NM,
		  clearingSummary.SESN SESNLABEL, clearingSummary.SESN, SUM(clearingSummary.b1_HEADCOUNT) HEADCOUNT,
		  SUM(clearingSummary.b1_HOURS) HOURS,
		  SUM(clearingSummary.b1_MACHHRS_YR1) MACHHRS_YR1,
		  SUM(clearingSummary.b1_MACHHRS_YR2) MACHHRS_YR2,
		  SUM(clearingSummary.b1_PROJHRS_YR1) PROJHRS_YR1,
		  SUM(clearingSummary.b1_PROJHRS_YR2) PROJHRS_YR2,
		  clearingSummary.b1_objcd as OBJCD, clearingSummary.b1_fin_obj_cd_nm as FIN_OBJ_CD_NM,
		  clearingSummary.b1_fee_id as FEE_ID,
		  clearingSummary.b1_adj_rate as ADJ_RATE, clearingSummary.b1_ADJ_ESCL_RATE_YR1 as ADJ_ESCL_RATE_YR1,
		  clearingSummary.b1_ADJ_ESCL_RATE_YR2 as ADJ_ESCL_RATE_YR2,
	    <cfelse>
		  clearingSummary.b2_RC as RC, clearingSummary.b2_TERM as TERM, clearingSummary.SESN TRMLABEL,
		  clearingSummary.FEECODE, clearingSummary.FEEDESCR, clearingSummary.SELGROUP,
		  clearingSummary.RES, clearingSummary.ACCOUNT, clearingSummary.ACCOUNT_NM,
		  clearingSummary.SESN SESNLABEL, clearingSummary.SESN, SUM(clearingSummary.b2_HEADCOUNT) HEADCOUNT,
		  SUM(clearingSummary.b2_HOURS) HOURS,
		  SUM(clearingSummary.b1_MACHHRS_YR1) MACHHRS_YR1,
		  SUM(clearingSummary.b2_MACHHRS_YR2) MACHHRS_YR2,
		  SUM(clearingSummary.b1_PROJHRS_YR1) PROJHRS_YR1,
		  SUM(clearingSummary.b2_PROJHRS_YR2) PROJHRS_YR2,
		  clearingSummary.b2_objcd as OBJCD, clearingSummary.b2_fin_obj_cd_nm as FIN_OBJ_CD_NM,
		  clearingSummary.b2_fee_id as FEE_ID,
		  clearingSummary.b2_adj_rate as ADJ_RATE, clearingSummary.b1_ADJ_ESCL_RATE_YR1 as ADJ_ESCL_RATE_YR1,
		  clearingSummary.b2_ADJ_ESCL_RATE_YR2 as ADJ_ESCL_RATE_YR2,
		</cfif>
		  clearingSummary.FEE_LOWYEAR, clearingSummary.ACAD_CAREER,
		  clearingSummary.RES as RESIDENCY
		FROM #application.hours_to_project# clearingSummary
		WHERE clearingSummary.CHART = <cfqueryparam cfsqltype="cf_sql_char" value="#selectedCampus#">
		<cfif application.budget_year eq "YR1">
		  AND clearingSummary.b1_RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
		GROUP BY clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.b1_RC, clearingSummary.FEECODE, clearingSummary.b1_TERM, clearingSummary.ACCOUNT, clearingSummary.ACCOUNT_NM, clearingSummary.b1_OBJCD, clearingSummary.b1_FIN_OBJ_CD_NM, clearingSummary.FEEDESCR, clearingSummary.SESN,clearingSummary.SELGROUP, clearingSummary.b1_FEE_ID, clearingSummary.FEE_LOWYEAR, clearingSummary.RES,clearingSummary.b1_ADJ_RATE, clearingSummary.b1_ADJ_ESCL_RATE_YR1, clearingSummary.b1_ADJ_ESCL_RATE_YR2,clearingSummary.ACAD_CAREER
		<cfelse>
		  AND clearingSummary.b2_RC = <cfqueryparam cfsqltype="cf_sql_char" value="#clearingRC#">
		  GROUP BY clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.b2_RC, clearingSummary.FEECODE, clearingSummary.b2_TERM, clearingSummary.ACCOUNT, clearingSummary.ACCOUNT_NM, clearingSummary.b2_OBJCD, clearingSummary.b2_FIN_OBJ_CD_NM, clearingSummary.FEEDESCR, clearingSummary.SESN,clearingSummary.SELGROUP, clearingSummary.b2_FEE_ID, clearingSummary.FEE_LOWYEAR, clearingSummary.RES,clearingSummary.b2_ADJ_RATE, clearingSummary.b1_ADJ_ESCL_RATE_YR1, clearingSummary.b2_ADJ_ESCL_RATE_YR2,clearingSummary.ACAD_CAREER
		</cfif>
	</cfquery>
	<!---  Now query the queries  --->
	<cfquery dbtype="query" name="finalSummary">
		SELECT clearingSummary.OID, clearingSummary.INST, clearingSummary.CHART, clearingSummary.RC,
			clearingSummary.FEECODE, clearingSummary.TERM,clearingSummary.SESNLABEL,clearingSummary.SESN,
		  clearingSummary.ACCOUNT,clearingSummary.HEADCOUNT,clearingSummary.HOURS,clearingSummary.SELGROUP,
		  clearingSummary.MACHHRS_YR1 as MACHINEHOURS_YR1, clearingSummary.MACHHRS_YR2 as MACHINEHOURS_YR2,
		  clearingSummary.PROJHRS_YR1 as PROJHOURS_YR1, clearingSummary.PROJHRS_YR2 as PROJHOURS_YR2,
		  clearingSummary.ACCOUNT_NM, clearingSummary.OBJCD, clearingSummary.FIN_OBJ_CD_NM,clearingSummary.FEEDESCR,
		  clearingSummary.FEE_ID,clearingSummary.ACAD_CAREER,
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
		  <cfif application.budget_year eq "YR1">
		  	AND aggregatedEstRev.b1_RC = clearingSummary.RC
		  <cfelse>
		    AND aggregatedEstRev.b2_RC = clearingSummary.RC
		  </cfif>
		  AND aggregatedEstRev.FEECODE = clearingSummary.FEECODE
		  AND aggregatedEstRev.TERM = clearingSummary.TERM
		  AND aggregatedEstRev.acad_career = clearingSummary.acad_career
		  AND aggregatedEstRev.res = clearingSummary.res
		  AND aggregatedEstRev.SELGROUP = clearingSummary.SELGROUP
	</cfquery>
	<cfreturn aggregatedEstRev>
</cffunction>

<cffunction name="trackProjectinatorAction" output="false">
	<cfargument name="loginId" required="true" default="#REQUEST.AuthUser#" />
	<cfargument name="campusId" required="true" />
	<cfargument name="actionId" required="true" />
	<cfargument name="description" required="false" default="--" />
	<cfargument name="parameterCd" required="false" default="--" />
	<cfquery datasource="#application.datasource2#" name="makeMeta">
		INSERT INTO ch_user.METADATA
		(USER_ID,CAMPUS_ID,ACTION_ID,DESCRIPTION,PARAMETER_CD)
		VALUES
		('#loginId#','#campusId#','#actionId#','#description#','#parameterCd#')
	</cfquery>

</cffunction>

<!--- Generic Excel sheet without any data - this empty template is the only one we need for this application --->
<cffunction name="setupRevenueTemplate" hint="Setup details for Revenue Projector Excel template" >
	<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
	<cfset sheet = SpreadSheetNew("FY21 Cr Hr Rev Projection")>
	<!--- Add Excel title row 1 --->
	<cfif application.rateStatus eq "Vc">
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY21 - Constant Effective Rate Estimated Revenue")>
	<cfelseif application.rateStatus eq "V1">
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY21 - Escalated Rate Estimated Revenue")>
	<cfelse>
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Credit Hour Revenue Projector FY21")>
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
	<cfif application.rateStatus eq "Vc">
		<cfset SpreadsheetAddRow(sheet, "ID,Campus,Chart,RC,Term,Semester,Fee Code,Fee Code Descr,Note,Tuition Group,Academic Career,Residency,Account,Account Name,Object Code,Object Code Name,Spacer1,Headcount,Actual Credit Hours,Current Rate,#application.firstyear# Enrollment Study Hours,#application.secondyear# Enrollment Study Hours,Spacer2,#application.firstyear# Effective Rate, #application.firstyear# Campus Projected Hours, #application.firstyear# Estimated Revenue,Spacer3,#application.secondyear# Effective Rate,#application.secondyear# Campus Projected Hours, #application.secondyear# Estimated Revenue, SESN,FEEKEY, FEE_ID, b1_ADJ_ESCL_RATE_YR1, b1_ADJ_ESCL_RATE_YR2, b1_fee_residency, b1_ADJ_RATE, b2_fee_id, b2_objcd, b2_fin_obj_cd_nm, b2_projhrs_yr2, b2_hours, b2_adj_rate, b2_adj_escl_rate_yr2, fee_current, fee_lowyear, fee_highyear, RES,b1_projhrs_yr2,b1_rc")>
	<cfelse>  <!--- V1 version --->
		<cfset SpreadsheetAddRow(sheet, "ID,Campus,Chart,RC,Term,Semester,Fee Code,Fee Code Descr,Note,Tuition Group,Academic Career,Residency,Account,Account Name,Object Code,Object Code Name,Spacer1,#application.firstyear# Headcount,#application.firstyear# Actual Credit Hours,Current #application.firstyear# Rate,#application.firstyear# Enrollment Study Hours,#application.secondyear# Enrollment Study Hours,Spacer2,#application.firstyear# Escalated Rate, #application.firstyear# Campus Projected Hours, #application.firstyear# Estimated Revenue,Spacer3,#application.secondyear# Escalated Rate,#application.secondyear# Campus Projected Hours, #application.secondyear# Estimated Revenue, SESN,FEEKEY, FEE_ID, b1_ADJ_ESCL_RATE_YR1, b1_ADJ_ESCL_RATE_YR2, b1_fee_residency, b1_ADJ_RATE, b2_fee_id, b2_objcd, b2_fin_obj_cd_nm, b2_projhrs_yr2, b2_hours, b2_adj_rate, b2_adj_escl_rate_yr2, fee_current, fee_lowyear, fee_highyear, RES,b1_projhrs_yr2,b1_rc")>
	</cfif>
	<!---<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),3)>--->
	<cfset SpreadsheetSetRowHeight(sheet,1,30)>
	<!--- Set up columns - widths are determined manually by adjusting the column titles. Ratio in Excel is 7:1 (width "6" here shows as 42 pixels in Excel). --->
	<cfset SpreadsheetSetColumnWidth(sheet,1,10)>   <!--- A ID --->
	<cfset SpreadsheetFormatColumn(sheet,{hidden=true},1)>    <!--- A ID --->
	<cfset SpreadsheetSetColumnWidth(sheet,2,10)>   <!--- B INST --->
	<cfset SpreadsheetSetColumnWidth(sheet,3,10)>   <!--- C Chart --->
	<cfset SpreadsheetSetColumnWidth(sheet,4,10)>   <!--- D RC --->
	<cfset SpreadsheetSetColumnWidth(sheet,5,10)>   <!--- E Term --->
	<cfset SpreadsheetSetColumnWidth(sheet,6,12)>   <!--- F Semester --->
	<cfset SpreadsheetSetColumnWidth(sheet,7,12)>   <!--- G Fee Code --->
	<cfset SpreadsheetSetColumnWidth(sheet,8,36)>   <!--- H Fee Code Description --->
	<cfset SpreadsheetSetColumnWidth(sheet,9,22)>   <!--- I Note --->
	<cfset SpreadsheetSetColumnWidth(sheet,10,16)>  <!--- J Tuition Group --->
	<cfset SpreadsheetSetColumnWidth(sheet,11,18)>  <!--- K Academic Career --->
	<cfset SpreadsheetSetColumnWidth(sheet,12,12)>  <!--- L Residency --->
	<cfset SpreadsheetSetColumnWidth(sheet,13,10)>  <!--- M Account --->
	<cfset SpreadsheetSetColumnWidth(sheet,14,30)>  <!--- N Account Name --->
	<cfset SpreadsheetSetColumnWidth(sheet,15,14)>  <!--- O Object Code --->
	<cfset SpreadsheetSetColumnWidth(sheet,16,33)>  <!--- P Obj Cd Name --->
	<cfset SpreadsheetSetColumnWidth(sheet,17,10)>  <!--- Q spacer1 --->

	<cfset SpreadsheetSetColumnWidth(sheet,18,18)>  <!--- R firstyear Headcount --->
	<cfset SpreadsheetSetColumnWidth(sheet,19,25)>  <!--- S firstyear Actual CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,20,20)>  <!--- T firstyear Current Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,21,30)>  <!--- U firstyear ES CrHrs --->
	<cfif application.budget_year eq "YR2">
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},21)>    <!--- HIDE FIRSTYEAR MACHHRS IN 2ND YR, NO ONE CARES --->
	</cfif>
	<cfset SpreadsheetSetColumnWidth(sheet,22,30)>  <!--- V FY21 ES CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,23,10)>  <!--- W Spacer2 --->
	<cfset SpreadsheetSetColumnWidth(sheet,24,22)>  <!--- X FY20 Escalated Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,25,30)>  <!--- Y FY20 Campus Projected Hours --->
	<cfset SpreadsheetSetColumnWidth(sheet,26,26)>  <!--- Z FY20 Estimated Revenue --->
	<cfset SpreadsheetSetColumnWidth(sheet,27,10)>  <!--- AA Spacer3 --->
	<cfif application.budget_year eq "YR2">
		<cfset SpreadsheetFormatColumns(sheet,{hidden=true},24)>    <!--- HIDE FIRSTYEAR DETAILS IN 2ND YR, NO ONE CARES --->
		<cfset SpreadsheetFormatColumns(sheet,{hidden=true},25)>
		<cfset SpreadsheetFormatColumns(sheet,{hidden=true},26)>
		<cfset SpreadsheetFormatColumns(sheet,{hidden=true},27)>
	</cfif>

	<cfset SpreadsheetSetColumnWidth(sheet,28,22)>  <!--- AB FY21 Rate --->
	<cfset SpreadsheetSetColumnWidth(sheet,29,30)>  <!--- AC FY21 Campus Proj CrHrs --->
	<cfset SpreadsheetSetColumnWidth(sheet,30,26)>  <!--- AD FY21 Estimated Revenue --->
    <!--- Past this point, all is hidden from the download --->
   	<cfset SpreadsheetSetColumnWidth(sheet,31,10)>  <!--- AE SESN --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},31)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,32,10)>  <!--- AF FEEKEY --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},32)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,33,10)>  <!--- AG FEEID --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},33)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,34,10)>  <!--- AH b1_ADJ_ESCL_RATE_YR1 --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},34)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,35,10)>  <!--- AI b1_ADJ_ESCL_RATE_YR2 --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},35)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,36,10)>  <!--- AJ b1_fee_residency --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},36)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,37,10)>  <!--- AK b1_ADJ_RATE, --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},37)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,38,10)>  <!--- AL b2_fee_id --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},38)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,39,10)>  <!--- AM b2_objcd --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},39)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,40,10)>  <!--- AN b2_fin_obj_cd_nm --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},40)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,41,10)>  <!--- AO b2_projhrs_yr2 --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},41)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,42,10)>  <!--- AP b2_hours --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},42)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,43,10)>  <!--- AQ b2_adj_rate --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},43)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,44,10)>  <!--- AR b2_adj_escl_rate_yr2 --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},44)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,45,10)>  <!--- AS fee_current --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},45)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,46,10)>  <!--- AT fee_lowyear --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},46)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,47,10)>  <!--- AU fee_highyear --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},47)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,48,10)>  <!--- AV res --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},48)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,49,10)>  <!--- AW b1_projhrs_yr2 --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},49)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->
   	<cfset SpreadsheetSetColumnWidth(sheet,49,10)>  <!--- AX b1_rc --->
		<cfset SpreadsheetFormatColumn(sheet,{hidden=true},50)>    <!--- HIDE BUDGET OFFICE INFO, NO ONE CARES --->

	<cfset SpreadSheetAddAutofilter(sheet, "A4:AV4")>
	<cfset SpreadSheetAddFreezePane(sheet,2,4)>
	<!--- formatting columns --->
	<!---<cfset SpreadsheetFormatColumn(sheet, {dataformat="($##,####0.00($##,####0.00)"}, 25)>--->  <!--- example of formatting a column as currency --->
	<!---<cfset SpreadSheetSetColumnWidth(sObj, 14, 0)> example of hiding a column by setting the width = 0  --->
	<!--- <cfset spreadsheetFormatColumn(sheet, {color="red",font="Courier New"}, 12)>   --->
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


<cffunction name="getB325_Vc_Campus_data" output="true">
	<cfargument name="givenCampus" type="string" required="false" default="ALL" />
	<cfargument name="givenRC" type="string" required="false" default="ALL" />
	<cfargument name="givenBoolean" type="boolean" required="false" default="true">
	<cfset givenCampus = "IU"&#givenCampus#&"A">
	<cfquery name="rpt_chp_report" datasource="#application.datasource#">
		<cfif givenCampus neq 'IUALLA' and givenRC eq 'ALL'>
			select * from ch_user.rpt_chp_report_vc('#givenCampus#')
		<cfelseif givenCampus neq 'IUALLA' and givenRC neq 'ALL'>
			select * from ch_user.rpt_chp_report_vc('#givenCampus#','#givenRC#')
		<cfelse>
			select * from ch_user.rpt_chp_report_vc()
		</cfif>
	</cfquery>
	<cfreturn rpt_chp_report />
</cffunction>

<cffunction name="getB325_V1_Campus_data" output="true">
	<cfargument name="givenCampus" type="string" required="false" default="ALL" />
	<cfargument name="givenRC" type="string" required="false" default="ALL" />
	<cfargument name="givenBoolean" type="boolean" required="false" default="true">	
		<cfset givenCampus = "IU"&#givenCampus#&"A">  <!--- This is dumb but it makes me laugh --->
	<cfquery name="rpt_chp_report" datasource="#application.datasource#">
		<cfif givenCampus neq 'IUALLA' and givenRC eq 'ALL'>
			select * from ch_user.rpt_chp_report_v1('#givenCampus#')
		<cfelseif givenCampus neq 'IUALLA' and givenRC neq 'ALL'>
			select * from ch_user.rpt_chp_report_v1('#givenCampus#','#givenRC#')
		<cfelse>
			select * from ch_user.rpt_chp_report_v1()
		</cfif>
	</cfquery>
	<cfreturn rpt_chp_report />
</cffunction>

<cffunction name="getB325_V1_Campus_data_old" output="true">
	<cfargument name="campus" type="string" default="">
	<cfargument name="fee_RC" type="string" default="">
	<cfargument name="RC_only" type="string">
	<cfargument name="university_user" type="string" default="N" required="false" >
	<cfquery datasource="#application.datasource2#" name="B325_V1_Campus_data">
SELECT h.BIENNIUM as "Biennium", h.INST as "Bus Unit", h.CHART as "KFS Chart",
    CAST(CASE
      WHEN h.INST = 'IUINA' AND h.b1_rc = '10' THEN 'IM'
      WHEN h.INST = 'IUINA' AND h.b1_rc <> '10' THEN 'IN'
      WHEN h.INST = 'IUBLA' THEN 'BL'
      WHEN h.INST = 'IUEAA' THEN 'EA'
      WHEN h.INST = 'IUKOA' THEN 'KO'
      WHEN h.INST = 'IUNWA' THEN 'NW'
      WHEN h.INST = 'IUSBA' THEN 'SB'
      WHEN h.INST = 'IUSEA' THEN 'SE'
      WHEN h.INST = 'IUUAA' THEN 'UA'
      ELSE 'n/a'
    END as character varying(3)) AS "Rptg Chrt",
h.B1_RC as "RC Code",
CAST(CASE WHEN rcb.RC_NM IS NULL THEN ' ' ELSE rcb.RC_NM END as character varying(64)) as "RC Name",
h.ACCOUNT as "Account Number", h.ACCOUNT_NM as "Account Name",
CAST(CASE WHEN rcb.RCB_EXCL IS NULL THEN 'N' ELSE rcb.RCB_EXCL END as character varying(26)) as "RCB Excl",
CAST(CASE WHEN rcb.SCHOOL IS NULL THEN ' ' ELSE rcb.SCHOOL END as character varying(64)) as "School",
h.SELGROUP as "Tuition Group",
CAST(CASE WHEN sg.DESCR IS NULL THEN ' ' ELSE sg.DESCR END as character varying(64)) as "Tuition Group Descr",
CAST(CASE WHEN (h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')) THEN 'N'
		  WHEN h.FEECODE IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER', 'RHSR$') 
		  THEN 'Y' ELSE 'N'
  	 END as character varying(1)) as "TG Excl",
h.FEECODE as "Fee Code", h.FEEDESCR as "Fee Code Descr", 
CAST(CASE WHEN h.B1_FEE_DISTANCE IS NULL THEN ' ' ELSE h.B1_FEE_DISTANCE END as character varying(1)) as "Distance",
ac.LEVEL_CD as "Career Categ", ac.SLEVEL as "Level",
h.SESN as "Term Code",
DECODE (h.SESN, 'FL', 'Fall',
              'SP', 'Spring',
              'SS1', 'Summer 1',
              'SS2', 'Summer 2',
              'WN', 'Winter',
              '') as "Acad Term",
CAST(CASE WHEN t.Expanded_Descr IS NULL THEN ' ' ELSE t.Expanded_Descr END as character varying(128)) as "Term Long Descr",
CAST(CASE WHEN t.DESCRSHORT IS NULL THEN ' ' ELSE t.DESCRSHORT END as character varying(26)) as "Term Shrt Descr", 
h.res as "Projector Residency",
r.res_grp as "Resdcy Desc",
h.b1_objcd as "Object Code",
ob.FIN_OBJ_CD_SHRT_NM as "Object Code Shrt Name",
CAST(CASE WHEN h.b1_objcd IN ('0701','0801','0901','1001') THEN '09de'
		  WHEN h.b1_objcd IN ('0808','0908','0802','0803','0902','0903') THEN '10ms'
		  ELSE pf.PROFORMA_CD
	 END as character varying(4)) as "ProForma Cd",
CASE WHEN h.b1_objcd IN ('0701','0801','0901','1001') THEN 'Undifferentiated Dist Ed'
	WHEN h.b1_objcd IN ('0808','0908','0802','0803','0902','0903') THEN 'Campus Mkt Share'
	ELSE pf.PROFORMA_NAME
END as "ProForma Nm",
CAST(CASE WHEN h.FEECODE IN ('ACPR$', 'ACPNR$', 'BCN$', 'BCR$', 'NTDLR$', 'RHSR$') THEN 'DUAL'
  		  WHEN h.FEECODE IN ('OVSTR$', 'OVSTN$') THEN 'OVST'
  		  WHEN h.FEECODE IN ('OCCH$', 'OCCE$') THEN 'OCC'
  		  WHEN h.FEECODE IN ('BANR$', 'BANN$', 'OVST', 'OTHER', 'MUSX', 'OCCI$') THEN 'EXCL'
  		  ELSE 'REG'
  	 END as character varying(4)) as "UIRR Rpt Categ",
h.b1_projhrs_yr2 as "Camp Proj Hrs_Yr2 Orig", h.b1_adj_escl_rate_yr2 as "Escltd Eff Rt_Yr2 Orig",
CASE WHEN ( h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')
			  OR
			h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')) 
			  THEN ROUND(h.b1_adj_escl_rate_yr2 * h.b1_projhrs_yr2, 2)
	 ELSE 0
END as "Tuit Rev Yr2 Orig",
h.B1_HEADCOUNT as "Heads Yr1", h.B1_HOURS as "Act CH Yr1", 
h.b1_machhrs_yr2 as "UBO Proj Hrs_Yr2 Revsd", h.b1_projhrs_yr2 as "Camp Proj Hrs_Yr2 Revsd", 
h.b1_adj_rate as "Const Eff Rt Yr2 Revsd", h.b1_adj_escl_rate_yr2 as "Escltd Eff Rt_Yr2 Revsd",
CASE WHEN (h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')
  		    OR
  		   h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')) 
  		     THEN ROUND(h.b1_adj_escl_rate_yr2 * h.b1_machhrs_yr2, 2)
	 ELSE 0
END as "UBO Tuit Rev Yr2",
CASE WHEN (h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')
			 OR
		   h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')) 
		     THEN ROUND(h.b1_adj_rate * h.b1_projhrs_yr2, 2)
	 ELSE 0
END as "Const Tuit Rev Yr2 Revised",
CASE WHEN (h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')
			 OR
		   h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')) 
		     THEN ROUND(h.b1_adj_escl_rate_yr2 * h.b1_projhrs_yr2, 2)
	 ELSE 0
END as "Tuit Rev Yr2 Revisd",
CASE WHEN (h.CHART IN ('FT', 'IN') AND h.FEECODE IN ('BANR$', 'BANN$')
			 OR
		   h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')) 
		     THEN ROUND( (h.b1_adj_escl_rate_yr2 * h.b1_projhrs_yr2) - h.b1_projhrs_yr2, 2)
	 ELSE 0
END as "YR2_REV_CHG",
h.B1_RC as "RC Code2",
CAST(CASE WHEN rcb.RC_NM IS NULL THEN ' ' ELSE rcb.RC_NM END as character varying(64)) as "RC Name",
h.ACCOUNT_NM as "Account Name2"
FROM #application.hours_to_project# h
    LEFT OUTER JOIN BUDU001.BCN_OBJ_CD_ROLLUP_GV@dss_link pf ON pf.FIN_OBJECT_CD = h.b1_objcd
    <!---LEFT OUTER JOIN BUDU001.BCN_OBJ_CD_ROLLUP_GV@dss_link pf2 ON pf2.FIN_OBJECT_CD = h.b2_objcd--->
    LEFT OUTER JOIN BUDU001.CHP_RCB_MATRIX_T@dss_link rcb ON rcb.CHART = h.CHART AND rcb.RC_CD = h.b1_rc AND rcb.ACCOUNT = h.ACCOUNT
    <!---LEFT OUTER JOIN BUDU001.CHP_RCB_MATRIX_T@dss_link rcb2 ON rcb2.CHART = h.CHART AND rcb.RC_CD = h.b2_rc AND rcb.ACCOUNT = h.ACCOUNT--->
    LEFT OUTER JOIN BUDU001.CHP_OBJ_MTRX_T@dss_link ob ON ob.FIN_OBJECT_CD = h.b1_objcd
    <!---LEFT OUTER JOIN BUDU001.CHP_OBJ_MTRX_T@dss_link ob2 ON ob2.FIN_OBJECT_CD = h.b2_objcd--->
    LEFT OUTER JOIN BUDU001.CHP_ACAD_CAREER_T@dss_link ac ON ac.ACADEMIC_CAREER = h.ACAD_CAREER
    LEFT OUTER JOIN BUDU001.CHP_SEL_GRP_T@dss_link sg ON sg.BUSINESS_UNIT = h.INST AND sg.SEL_GROUP = h.SELGROUP
    LEFT OUTER JOIN BUDU001.CHP_TERM_T@dss_link t ON t.SESN = h.SESN AND t.STRM = h.b1_term
    <!---LEFT OUTER JOIN BUDU001.CHP_TERM_T@dss_link  t2 ON t2.SESN = h.SESN AND t2.STRM = h.b2_term--->
    LEFT OUTER JOIN BUDU001.CHP_RESIDENCY_T@dss_link r ON r.res = h.res
    WHERE h.biennium = '#application.biennium#'
	  <cfif university_user eq 'N'>
		AND SUBSTR(H.INST,3,2) = <cfqueryparam cfsqltype="cf_sql_char" value="#campus#">
		  <cfif RC_only eq true>
		  	AND H.b1_RC = <cfqueryparam cfsqltype="cf_sql_char" value="#fee_RC#">
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

<cffunction name="getUBOcontrolValues">
	<cfargument name="givenApp" type="string" required="true">
	<cfargument name="givenName" type="string" required="true">
	<cfquery name="UBOcontrolVals" datasource="#application.datasource#">
		SELECT *
		FROM ubo_control_settings
		WHERE var_application = '#givenApp#'
		  AND var_name = '#givenName#'
	</cfquery>
	<cfreturn UBOcontrolVals />
</cffunction>

<cffunction name="clearBUDU001_ProjTable">
	<cfargument name="localCall" required="false" default="false">
    <cftransaction isolation="serializable" action="begin">
		<cfquery name="clearTable" datasource="#application.datasource#">
			DELETE FROM BUDU001.chp_htp_t@dss_link
		</cfquery>
		<cftransaction action = "commit" />
	</cftransaction>
	<cfif localCall eq true>
		<cftransaction isolation="serializable" action="begin">
			<cfquery name="countResult" datasource="#application.datasource#">
				SELECT COUNT(*) as TotalRecords FROM BUDU001.chp_htp_t@dss_link
			</cfquery>
			<cftransaction action = "commit" />
	    </cftransaction>
		<cfreturn countResult>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="projRefresh">
	<cfset clearBUDU001_ProjTable() />
	<cftransaction isolation="serializable" action="begin">
		<cfquery name="refillTable" datasource="#application.datasource#">
			INSERT INTO BUDU001.chp_htp_t@dss_link
			SELECT * FROM #application.hours_to_project# WHERE biennium = '#application.biennium#'
		</cfquery>
		<cftransaction action = "commit" />
	</cftransaction>
	<cftransaction isolation="serializable" action="begin">
		<cfquery name="countResult" datasource="#application.datasource#">
			SELECT COUNT(*) as TotalRecords FROM BUDU001.chp_htp_t@dss_link
		</cfquery>
		<cftransaction action = "commit" />
	</cftransaction>
	<cfreturn countResult>
</cffunction>

<cffunction name="getRCCrHrTotal" >
	<cfargument name="givenCampus" type="string" required="true">
	<cfargument name="givenRC" type="string" required="true" />
	<cfargument name="givenSesn" type="string" required="false" default="ABSENT" />
	<cfargument name="givenBudgetYear" type="string" required="false" default="#application.budget_year#">
	<cfquery name="fetchRcTotCrHrs" datasource="#application.datasource#">
		SELECT
		  <cfif givenBudgetYear eq 'YR1'>
		  	SUM(htp.b1_projhrs_yr1)
		  <cfelse>
		  	SUM(htp.b2_projhrs_yr2)
		  </cfif> as CrHrs
		FROM #application.hours_to_project#
		WHERE biennium = '#application.biennium#'
		  AND chart = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">
		  AND <cfif givenBudgetYear eq 'YR1'>b1_rc<cfelse>b2_rc</cfif> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenRC#">
		  <cfif givenSesn neq 'ABSENT'>
		  	AND sesn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSesn#">
		  </cfif>
  		  AND FEECODE NOT LIKE 'G901%$'
		  AND FEECODE NOT LIKE 'LWA%$'
		  AND FEECODE NOT LIKE 'ACP%'
		  AND FEECODE NOT LIKE 'BAN%'
	</cfquery>
	<cfreturn fetchRcTotCrHrs />
</cffunction>

<cffunction name="createSubTotalsStruct">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset rclist = getDistinctRCs(givenCampus) />
	<cfset blork = structNew() />
	<cfloop query="rclist">
			<cfset blork[active_rc] = {
			FL = getRCCrHrTotal(givenCampus,active_rc,'FL').crhrs,
			SP = getRCCrHrTotal(givenCampus,active_rc,'SP').crhrs,
			SS1 = getRCCrHrTotal(givenCampus,active_rc,'SS1').crhrs,
			SS2 = getRCCrHrTotal(givenCampus,active_rc,'SS2').crhrs,
			WN = getRCCrHrTotal(givenCampus,active_rc,'WN').crhrs,
			RCSUBTOT = getRCCrHrTotal(givenCampus,active_rc).crhrs
		} />
	</cfloop>
	<cfreturn blork />
</cffunction>

<cffunction name="getSesnCrHrTotal" >
	<cfargument name="givenCampus" type="string" required="true">
	<cfargument name="givenSesn" type="string" required="false" default="ABSENT" />
	<cfargument name="givenBudgetYear" type="string" required="false" default="#application.budget_year#">
	<cfquery name="fetchSesnCrHrTotal" datasource="#application.datasource#">
		SELECT
		  <cfif givenBudgetYear eq 'YR1'>
		  	SUM(htp.b1_projhrs_yr1)
		  <cfelse>
		  	SUM(htp.b2_projhrs_yr2)
		  </cfif> as CrHrs
		FROM #application.hours_to_project#
		WHERE biennium = '#application.biennium#'
		  AND chart = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">
		  <cfif givenSesn neq 'ABSENT'>
		  	AND sesn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSesn#">
		  </cfif>
  		  AND FEECODE NOT LIKE 'G901%$'
		  AND FEECODE NOT LIKE 'LWA%$'
		  AND FEECODE NOT LIKE 'ACP%'
		  AND FEECODE NOT LIKE 'BAN%'
	</cfquery>
	<cfreturn fetchSesnCrHrTotal />
</cffunction>

<cffunction name="createSesnTotalsStruct">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset glarp = structNew() />
			<cfset glarp = {
			FL = getSesnCrHrTotal(givenCampus,'FL').crhrs,
			SP = getSesnCrHrTotal(givenCampus,'SP').crhrs,
			SS1 = getSesnCrHrTotal(givenCampus,'SS1').crhrs,
			SS2 = getSesnCrHrTotal(givenCampus,'SS2').crhrs,
			WN = getSesnCrHrTotal(givenCampus,'WN').crhrs,
			CAMPTOT = getSesnCrHrTotal(givenCampus).crhrs
		} />
	<cfreturn glarp />
</cffunction>

<cffunction name="getRCEstRev">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfargument name="givenRC" type="string" required="false" default="NONE" />
	<cfquery name="calcRev" datasource="#application.datasource#">
		SELECT htp.inst,
			<cfif application.budget_year eq 'YR1'>
			    htp.b1_RC,
			<cfelse>
			    htp.b2_RC,
			</cfif>
		  <cfif application.budget_year eq "YR1">
	        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
	        SUM(htp.b1_ADJ_ESCL_RATE_YR2 * htp.b1_PROJHRS_YR2) ESTREV_YR2,
		  <cfelse>
	        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
	        SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) ESTREV_YR2,
		  </cfif>
		  htp.rc_nm
		FROM #application.hours_to_project# htp
		WHERE htp.biennium = '#application.biennium#'
		  AND htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">
		  <cfif givenRC neq 'NONE'>
			  <cfif application.budget_year eq 'YR1'>
			     AND htp.b1_RC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenRC#">
			  <cfelse>
			    AND htp.b2_RC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenRC#">
			  </cfif>
		  </cfif>
		  AND htp.FEECODE NOT LIKE 'G901%$'
		  AND htp.FEECODE NOT LIKE 'LWA%$'
		  AND htp.FEECODE NOT LIKE 'ACP%'
		  AND htp.FEECODE NOT LIKE 'BAN%'
		<cfif application.budget_year eq "YR1">
			GROUP BY htp.inst, htp.b1_RC, htp.RC_NM
		<cfelse>
			GROUP BY htp.inst, htp.b2_RC, htp.RC_NM
		</cfif>
	</cfquery>
	<cfreturn calcRev />
</cffunction>

<cffunction name="createRCRevenueStruct">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset rclist = getDistinctRCs(givenCampus) />
	<cfset voteBlue = structNew() />
	<cfloop query="rclist">
			<cfset voteBlue[active_rc] = {
			ESTREV_YR1 = getRCEstRev(givenCampus,active_rc).ESTREV_YR1,
			ESTREV_YR2 = getRCEstRev(givenCampus,active_rc).ESTREV_YR2
			} />
	</cfloop>
	<cfset voteBlue["CAMPREV_YR1"] = getRCEstRev(givenCampus).ESTREV_YR1 />
	<cfset voteBlue["CAMPREV_YR2"] = getRCEstRev(givenCampus).ESTREV_YR2 />
	<cfreturn voteBlue />
</cffunction>

<cffunction name="getSesnEstRev">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfargument name="givenSesn" type="string" required="false" default="NONE" />
	<cfquery name="calcRev" datasource="#application.datasource#">
		SELECT chart,
		  <cfif application.budget_year eq "YR1">
	        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
	        SUM(htp.b1_ADJ_ESCL_RATE_YR2 * htp.b1_PROJHRS_YR2) ESTREV_YR2
		  <cfelse>
	        SUM(htp.b1_ADJ_ESCL_RATE_YR1 * htp.b1_PROJHRS_YR1) ESTREV_YR1,
	        SUM(htp.b2_ADJ_ESCL_RATE_YR2 * htp.b2_PROJHRS_YR2) ESTREV_YR2
		  </cfif>
		FROM #application.hours_to_project# htp
		WHERE htp.biennium = '#application.biennium#'
		  AND htp.CHART = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">
		  <cfif givenSesn neq 'NONE'>
		    AND htp.sesn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSesn#">
		  </cfif>
		  AND htp.FEECODE NOT LIKE 'G901%$'
		  AND htp.FEECODE NOT LIKE 'LWA%$'
		  AND htp.FEECODE NOT LIKE 'ACP%'
		  AND htp.FEECODE NOT LIKE 'BAN%'
			GROUP BY htp.chart
	</cfquery>
	<cfreturn calcRev />
</cffunction>

<cffunction name="createSesnRevenueStruct">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset sesnRevs = structNew() />
	<cfif application.budget_year eq "YR1">
		<cfset sesnRevs = {
			FL = getSesnEstRev(givenCampus,'FL').ESTREV_YR1,
			SP = getSesnEstRev(givenCampus,'SP').ESTREV_YR1,
			SS1 = getSesnEstRev(givenCampus,'SS1').ESTREV_YR1,
			SS2 = getSesnEstRev(givenCampus,'SS2').ESTREV_YR1,
			WN = getSesnEstRev(givenCampus,'WN').ESTREV_YR1,
			CAMPTOT = getSesnEstRev(givenCampus).ESTREV_YR1
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

<cffunction name="getSubAccountsByCampus">
	<cfargument name="givenCampus" type="string" required="true" />
	<cfset inst = "IU"&givenCampus&"A" />
	<cfquery name="fetchSubAccounts" datasource="#application.datasource#" >
		SELECT oid, bursar_bsns_unit_cd, sf_trm_cd, sf_trm_fee_cd, sf_tuit_grp_ind, gl_acct_nbr, gl_sub_acct_cd
	    FROM ch_user.htp_subaccount
	    WHERE bursar_bsns_unit_cd = '#inst#'
	    ORDER BY sf_trm_cd asc, sf_trm_fee_cd asc, gl_acct_nbr asc, gl_sub_acct_cd asc
	</cfquery>
	<cfreturn fetchSubAccounts />
</cffunction>

<cffunction name="getSubAccountByOID">
	<cfargument name="givenOID" type="string" required="true" />
	<cfquery name="subAccountRow" datasource="#application.datasource#" >
		SELECT oid, bursar_bsns_unit_cd, sf_trm_cd, sf_trm_fee_cd, sf_tuit_grp_ind, gl_acct_nbr, gl_sub_acct_cd
	    FROM ch_user.htp_subaccount
	    WHERE oid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenOID#">
	</cfquery>
	<cfreturn subAccountRow />
</cffunction>

<cffunction name="updateSubAccts">
	<!--- call using updateSubAccts(givenOID,givenCampus,givenTuiGrp,givenFC,givenAcct,givenSubAcct)   --->
	<cfargument name="givenOID" type="string" required="true" />
	<cfargument name="givenCampus" type="string" required="true" />
	<cfargument name="givenTuiGrp" type="string" required="true" />
	<cfargument name="givenFC" type="string" required="true" />
	<cfargument name="givenAcct" type="string" required="true" />
	<cfargument name="givenSubAcct" type="string" required="true" />
	<cfquery name="updateInfo" datasource="#application.datasource#">
		UPDATE ch_user.htp_subaccount
		SET sf_tuit_grp_ind = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenTuiGrp#">,
		  sf_trm_fee_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFC#">,
		  gl_acct_nbr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAcct#">,
		  gl_sub_acct_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSubAcct#">
		WHERE oid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenOID#">
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="addSubAccts">
	<!--- call using addSubAccts(givenCampus,givenTerm,givenFC,givenTuiGrpgivenAcct,givenSubAcct)   --->
	<cfargument name="givenCampus" type="string" required="true" />
	<cfargument name="givenTerm" type="string" required="true" />
	<cfargument name="givenFC" type="string" required="true" />
	<cfargument name="givenTuiGrp" type="string" required="true" />
	<cfargument name="givenAcct" type="string" required="true" />
	<cfargument name="givenSubAcct" type="string" required="true" />
	<cfquery name="updateInfo" datasource="#application.datasource#">
		INSERT INTO ch_user.htp_subaccount(
			bursar_bsns_unit_cd, sf_trm_cd, sf_trm_fee_cd, sf_tuit_grp_ind, gl_acct_nbr, gl_sub_acct_cd)
		VALUES (
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenCampus#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenTerm#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenFC#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenTuiGrp#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenAcct#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" value="#givenSubAcct#">)
	</cfquery>
	<cfreturn true />
</cffunction>

<cffunction name="getDataRefreshHistory" >
	<cfquery name="refreshList" datasource="#application.datasource#">
		SELECT * FROM ch_user.metadata
		WHERE action_id = '3'
		ORDER BY created_on DESC limit 5;
	</cfquery>
	<cfreturn refreshList />
</cffunction>

<cffunction name="getUIRRdata">
	<cfargument name="givenInst" type="string" required="true" hint="Institution name in the IUxxA format" />
	<!---<cfquery name="e0175data" datasource="#application.datasource#">
		SELECT inst, acad_career, sem, res, acp_count, occ_count, ovst_count, dual_count, total_count, budgeted_for_fy
		FROM ch_user.getE0175data_fn(<cfqueryparam cfsqltype="cf_sql_varchar" value="#givenInst#">)
	</cfquery>--->
	<cfquery name="e0175data" datasource="#application.datasource#">
		select * from ch_user.rpt_hours_used_in_budget('#givenInst#')
	</cfquery>
	<cfreturn e0175data />
</cffunction>

<cffunction name="getSpecialAccessList">
	<cfquery name="saList" datasource="#application.datasource#">
		SELECT username FROM fee_user.users WHERE proj_updt = 'Y'
	</cfquery>
	<cfreturn saList />
</cffunction>

<cffunction name="checkDSSavailability" output="true" >
	<cfset DSSavailable = false />
	<cfset currentDay = DateFormat(Now(),'ddd') />
	<cfif currentDay eq "Sat" AND (TimeFormat(Now(),"HH") gte 7 OR  TimeFormat(Now(),"HH") lt 22)>
		<cfset DSSavailable = true />
	<cfelseif currentDay eq "Sun" AND (TimeFormat(Now(),"HH") gte 10 OR  TimeFormat(Now(),"HH") lt 22)>
		<cfset DSSavailable = true />
	<cfelse>
		<cfif (TimeFormat(Now(),"HH") gte 5 OR  TimeFormat(Now(),"HH") lt 22)>
			<cfset DSSavailable = true />
		</cfif>
	</cfif>
	<cfreturn DSSavailable>
</cffunction>
