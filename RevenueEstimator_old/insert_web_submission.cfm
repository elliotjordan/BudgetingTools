<cfinclude template="../includes/functions/revenue_functions.cfm" />
	<!--- Loop through Form - check for changes and perform updates --->
	<!--- Remember the form has a comma-delimited list of values which must align --->
	<!--- DEFAULT BEHAVIOR IS TO LOOP THROUGH THE FORM, FIND ANY PROJHOURS THAT ARE DIFFERENT, AND UPDATE THE DATABASE WITH THOSE NEW VALUES --->
<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>
<cfdump var="#form#" >
<cfoutput>
	<cfset line_count = 1>
	<h2>Form has #LISTLEN(form.feecode)# feecodes</h2>
	<cfloop list="#Form.FEECODE#" index="i">
		<!---<p>LINE #i#</p>--->  <!--- save this line for debugging  --->
		<cfset Fee_term = ListGetAt(Form.TERM,line_count)>
		<cfset Fee_projhrs_Yr1 = ListGetAt(Form.PROJHRS_YR1,line_count)>
		<cfset Fee_projhrs_Yr2 = ListGetAt(Form.PROJHRS_YR2,line_count)>
		<cfset currentFeeCode = ListGetAt(Form.FEECODE,line_count)>
		<cfset currentRC = Form["urlRC"]/>
		<cfset currentChart = Form["urlCAMPUS"] />
		<cfset currentOID = ListGetAt(Form.OID,line_count)>
		<cfset thisFee = getFeeInfo(currentOID)>
		
		<p>#line_count# - #Fee_term# #Fee_projhrs_Yr1# #Fee_projhrs_Yr2# #currentFeeCode# #currentRC# #currentChart# #currentOID# #thisFee.selgroup#</p>
		<hr>
		<!--- Save the changes so that when we query the database below, we provide them with the latest data as Excel.  --->
		<cfif application.budget_year eq 'YR1'>
			<!--- YR1 changes may only be made in the Long Year of a biennium  --->
			<cfif trim(thisFee.projhours_Yr1) neq trim(Fee_projhrs_Yr1)>
				<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
				<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated projhours_Yr1 FC #currentFeeCode# for term #fee_term# to #Fee_projhrs_Yr1# CrHrs") />
			</cfif>
		</cfif>
			<!--- YR2 changes may be made in both biennium years  --->
		<cfif trim(thisFee.projhours_Yr2) neq trim(Fee_projhrs_Yr2)>
			<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
			<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated projhours_Yr2 FC #currentFeeCode# for term #fee_term# to #Fee_projhrs_Yr2# CrHrs") />
		</cfif>
		<cfset line_count++ >		
	</cfloop>

	<!--- User has asked for the Excel download. --->
	<cfif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
		<cfset ExcelSelect = getExcelDownloadData(urlCampus, urlRC,"V1")>
	   		<cfif IsDefined("ExcelSelect") AND ExcelSelect.recordcount GT 0>
				<cfset sheet = setupRevenueTemplate() />	
				<cfset SpreadsheetAddRows(sheet, ExcelSelect, true)>
				<cfheader name="Content-Disposition" value="inline; filename=FY21_Credit_Hour_Revenue_Projection_Worksheet.xls">   
				<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
			<cfelse>
				<h3>We are sorry, but no records were returned.</h3>
	   		</cfif>
	
	<!--- User has asked for a V1 report. --->
	<cfelseif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
		<cfsetting enablecfoutputonly="Yes"> 
				<cfscript>
				V1_RC_Template = ExpandPath('templates\B325_StudentFeeRevenueTemplateFY20v1Campusv6distrib.xlsx');
				</cfscript>
		<cfset reportSelect = getB325_V1_Campus_data(urlCampus, urlRC, true)>
		<!---<cfdump var="#reportSelect#"><cfabort>--->
	   		<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
				<cfinclude template="generateV1.cfm" runonce="true">
			<cfelse>
				<h3>We are sorry, but no records were returned.</h3>
	   		</cfif>
	
	<cfelseif IsDefined("form") AND StructKeyExists(form,"vtype")>
		<cfset application.rateStatus = form.vtype >
	</cfif>
</cfoutput>
	<cfset returnString = "revenue_RC.cfm?Campus=" & #Form['urlCampus']# & "&RC=" & #Form['urlRc']# />
	<cflocation url= #returnString# addToken="false" />
