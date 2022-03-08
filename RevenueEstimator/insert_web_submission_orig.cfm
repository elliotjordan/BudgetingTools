<cfinclude template="../includes/functions/bi_revenue_functions.cfm" />
<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>
<cfoutput>
	<cfset line_count = 1>
	<!---<cfdump var="#form#" >    YR1: <cfdump var="#ListLen(form.projhrs_yr1)#" > YR2:  <cfdump var="#ListLen(form.projhrs_yr2)#" >--->
	<cfif (application.budget_year eq 'YR1' and (ListLen(Form.OID) neq ListLen(Form.PROJHRS_YR1)))
	   OR (application.budget_year eq 'YR2' and (ListLen(Form.OID) neq ListLen(Form.PROJHRS_YR2)))
	>
		<cflocation url="hmmm.cfm?chart=#Form['urlCAMPUS']#&rc=#Form['urlRC']#" addtoken="false" />
	</cfif>
	
	<!--- User has asked for the Excel download. --->
	<cfif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
		<cfset ExcelSelect = getProjectinatorData(urlCampus, urlRC,application.rateStatus,"excel")>  
		<cfinclude template="export_to_excel.cfm" runonce="true" />
		<cfabort>
	
	<!--- User has asked for a Vc/V1 report. --->
	<cfelseif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
		<cfsetting enablecfoutputonly="Yes">  
		<cfset reportLevel = "_" & urlCampus & "_RC" & form.urlrc />
		 <cfif application.rateStatus eq "Vc">
		  	<cfset reportSelect = getB325_Vc_Campus_data(urlCampus, urlRC, true)> 
		  <cfelse>
		    <cfset reportSelect = getB325_V1_Campus_data(urlCampus, urlRC, true)> 
		  </cfif>

	   	<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
			<cfinclude template="V1_creation.cfm" runonce="true" />
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
	   	</cfif>
	<cfelseif IsDefined("form") AND StructKeyExists(form,"vtype")>
		<cfset application.rateStatus = form.vtype >
	</cfif>	
	
	<cfloop list="#Form.FEECODE#" index="i">  
		<cfset Fee_term = ListGetAt(Form.TERM,line_count)>
		<cfset currSESN = ListGetAt(Form.SESN,line_count)>
		<cfset Fee_projhrs_Yr1 = ListGetAt(Form.PROJHRS_YR1,line_count)>
		<cfset Fee_projhrs_Yr2 = ListGetAt(Form.PROJHRS_YR2,line_count)>
		<cfset currentFeeCode = ListGetAt(Form.FEECODE,line_count)>
		<cfset currentRC = Form["urlRC"]/>
		<cfset currentChart = Form["urlCAMPUS"] />
		<cfset currentSelgroup = ListGetAt(Form.SELGROUP,line_count)>
		<cfset currentOID = ListGetAt(Form.OID,line_count)>
		<cfset thisFee = getFeeInfo(currentOID)>
		<cfif application.budget_year eq 'YR1'> 
			<cfif !IsNull(thisFee.b1_projhrs_yr1) and trim(thisFee.b1_projhrs_yr1) neq trim(Fee_projhrs_Yr1)>
				<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
				<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated b1_projhours_Yr1 FC #currentFeeCode# #currentSelgroup# for term #fee_term# to #Fee_projhrs_Yr1# CrHrs, b1_projhrs_Yr2 FC #currentFeeCode# OID #currentOID# for term #fee_term# sesn #currSESN# to #Fee_projhrs_Yr2# CrHrs") />
			</cfif>
		</cfif>
		<cfif !IsNull(thisFee.b1_projhrs_Yr2) and trim(thisFee.b1_projhrs_Yr2) neq trim(Fee_projhrs_Yr2)>
			<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
			<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated b2_projhrs_Yr2 FC #currentFeeCode# #currentSelgroup# OID #currentOID# for term #fee_term# sesn #currSESN# to #Fee_projhrs_Yr2# CrHrs") />
		</cfif>
		<!---<cfif trim(thisFee.b2_projhrs_Yr2) neq trim(Fee_projhrs_Yr2)>
			<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
			<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated b2_projhrs_Yr2 FC #currentFeeCode# #currentSelgroup# OID #currentOID# for term #fee_term# sesn #currSESN# to #Fee_projhrs_Yr2# CrHrs") />
		</cfif>--->
		<cfset line_count++ >		
	</cfloop>


</cfoutput>
	<cfset returnString = "revenue_RC.cfm?Campus=" & #Form['urlCampus']# & "&RC=" & #Form['urlRc']# />
	<cflocation url= #returnString# addToken="false" />
