<cffunction name="getReportUser" output="true">
	<cfargument name="username" required="true">
  	<cfquery datasource="#application.datasource#" name="authUserData">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,PHONE,ACTIVE,CREATED_ON
  		FROM FEE_USER.USERS
  		WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
  	</cfquery>
  	<cfreturn authUserData>
</cffunction>

<!--- TODO: Check that the TG Excl values match getB325_V1_Campus_data() in revenue_functions.cfm  --->
<!--- Called by export_Vc.cfm, a partial which is not yet included in the active code.  --->
<cffunction name="getVcData" output="true">
 	<cfargument name="userRC" required="true">
 	<cfquery datasource="#application.datasource#" name="VcData">
	 	SELECT h.INST as "Bus Unit", h.CHART as "KFS Chart", h.RC as "RC Code", rcb.RC_NM as "RC Name", h.ACCOUNT as "Account Number",
			h.ACCOUNT_NM as "Account Name", 
			rcb.RCB_EXCL as "RCB Excl",  -- Select value of 'Y' to capture Online Class Connect account hours
			rcb.SCHOOL  as "School", h.SELGROUP as "Tuition Group", sg.DESCR as "Tuition Group Descr", sg.SELGRP_EXCL as "TG Excl",
			h.FEECODE as "Fee Code", h.FEEDESCR as "Fee Code Descr", h.FEE_DISTANCE as "Distance", h.FEE_ID as "Fee ID",
			ac.LEVEL_CD as "Career Categ", ac.SLEVEL as "Level", h.SESN as "Term Code", 
			DECODE (h.SESN, 'FL', 'Fall', 'SP', 'Spring', 'SS1', 'Summer 1', 'SS2', 'Summer 2', 'WN', 'Winter', '') as "Acad Term",
			t.Expanded_Descr as "Term Long Descr", t.DESCRSHORT as "Term Shrt Descr", r.RES_GRP as "Residency Desc",
			h.OBJCD as "Object Code", ob.FIN_OBJ_CD_SHRT_NM as "Object Code Shrt Name", pf.PROFORMA_CD as "ProForma Cd",
			pf.PROFORMA_CD_NM as "ProForma Nm", h.HEADCOUNT as "Heads", h.HOURS as "Act CH", h.MACHINEHOURS_YR1 as "UBO Proj Hrs_Yr1",
			h.PROJHOURS_YR1 as "Camp Proj Hrs_Yr1", h.MACHINEHOURS_YR2 as "UBO Proj Hrs_Yr2", h.PROJHOURS_YR2 as "Camp Proj Hrs_Yr2",
			h.ADJ_RATE as "Const Eff Rt", h.ADJ_ESCL_RATE_YR1 as "Escltd Eff Rt_Yr1", h.ADJ_ESCL_RATE_YR2 as "Escltd Eff Rt_Yr2",
			CASE
			  WHEN h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')
			    THEN ROUND(h.ADJ_RATE * h.MACHINEHOURS_YR1, 2)
			  ELSE 0 
			END as "UBO Tuit Rev Vc_Yr1",
			CASE
			  WHEN h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER')
			    THEN ROUND(h.ADJ_RATE * h.MACHINEHOURS_YR2, 2) 
			  ELSE 0 
			END as "UBO Tuit Rev Vc_Yr2",
			ROUND(h.ADJ_ESCL_RATE_YR1 * h.MACHINEHOURS_YR1, 2) as "UBO Tuit Rev v1_Yr1",
			ROUND(h.ADJ_ESCL_RATE_YR2 * h.MACHINEHOURS_YR2, 2) as "UBO Tuit Rev v1_Yr2",
			CASE
			  WHEN h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
			    THEN ROUND(h.ADJ_RATE * h.PROJHOURS_YR1, 2) 
			  ELSE 0 
			END as "Tuit Rev Vc_Yr1",
			CASE
			  WHEN h.FEECODE NOT IN ('BANR$', 'BANN$', 'OVSTN$', 'OVSTR$', 'OVST', 'ACPR$', 'ACPNR$', 'G901N$', 'G901R$', 'LWARN$', 'LWARR$', 'MUSX', 'OTHER') 
			    THEN ROUND(h.ADJ_RATE * h.PROJHOURS_YR2, 2) 
			  ELSE 0 
			END as "Tuit Rev Vc_Yr2",  
			ROUND(h.ADJ_ESCL_RATE_YR1 * h.PROJHOURS_YR1, 2) as "Tuit Rev v1_Yr1",
			ROUND(h.ADJ_ESCL_RATE_YR2 * h.PROJHOURS_YR2, 2) as "Tuit Rev v1_Yr2",
			h.RC as "RC Code2", rcb.RC_NM as "RC Name2", h.ACCOUNT_NM as "Account Name2"
		FROM CH_USER.HOURS_TO_PROJECT h
	    LEFT OUTER JOIN CH_USER.BCN_PF_CODE_T pf ON h.OBJCD = pf.FIN_OBJECT_CD
	    LEFT OUTER JOIN CH_USER.RCB_MATRIX rcb ON rcb.CHART = h.CHART AND rcb.RC_CD = h.RC AND rcb.ACCOUNT = h.ACCOUNT
		LEFT OUTER JOIN CH_USER.OBJ_MTRX ob ON ob.FIN_OBJECT_CD = h.OBJCD
		LEFT OUTER JOIN CH_USER.ACAD_CAREER ac ON ac.ACADEMIC_CAREER = h.ACAD_CAREER
		LEFT OUTER JOIN CH_USER.SEL_GRP sg ON sg.BUSINESS_UNIT = h.INST AND sg.SEL_GROUP = h.SELGROUP
		LEFT OUTER JOIN CH_USER.TERM t ON t.STRM = h.TERM
		LEFT OUTER JOIN CH_USER.RESIDENCY r ON r.RES = h.RES
 	</cfquery>
 	<cfreturn VcData />
</cffunction>
