<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset scenario_list = getUserScenarioList(currentUser.username) />
<cfset dataScenarioComparison = QueryNew("") />
<cfif isDefined("form") and StructKeyExists(form,"scenarioselector")>
	<!---<cfdump var="#form#" >--->
	<cfset arg_list = "" />
	<cfloop list="#form.scenarioselector#" index="s">
		<cfset arg_list = ListAppend(arg_list,s) />
	</cfloop>
	<!---<cfdump var="#arg_list#" >  <cfabort>--->
	<cfset dataScenarioComparison = compareFYMscenario(arg_list)>

	<!---<cfabort>--->
<cfelseif isDefined("form") and StructKeyExists(form,"modelExcelDownBtn")>
	<h2>modelExcelDown Button Results</h2>
	<cfdump var="#form#" ><cfabort>
<cfelseif isDefined("form") and StructKeyExists(form,"crHrExcelDownBtn")>
	<h2>crHrExcelDown Button Results</h2>
	<cfdump var="#form#" ><cfabort>
</cfif>

<cfoutput>
<div class="full_content">
<!---<h2>Comparisons for Scenario #current_scenario#</h2>--->
<h2>Model Comparisons</h2>

<form name="compDownload" action="fym_comparison.cfm" method="post">
	<h3>CTRL-CLICK to select up to 9 Scenarios</h3>
	<select id="scenarioSelector" name="scenarioSelector" multiple="multiple" size="#scenario_list.recordcount#">
		 <cfloop query="#scenario_list#">
		 	<option value="#scenario_cd#">Scenario #scenario_cd# - #scenario_nm# (#scenario_owner#)</option>
		 </cfloop>
	</select><br>
	<input name="compSelectorBtn" type="submit" value="Get Scenarios" />
	<br><br>
	<!---<input name="modelExcelDownBtn" type="submit" value="Download Model Comparisons to Excel" disabled />
	<input name="crHrExcelDownBtn" type="submit" value="Download CrHr Comparisons to Excel" disabled />--->
</form><br/>

<cfif dataScenarioComparison.recordcount gt 0>  
<cfsavecontent variable="strExcelData">
	<style type="text/css">
		td {
			font-family: "times new roman", verdana ;
			font-size: 11pt ;
			border: 0.5pt solid black;
			}
		td.header {
			background-color: ##96DED1;
			border-bottom: 0.5pt solid black ;
			font-weight: bold ;
			}
	</style>
<cfoutput>
<!---<cfdump var="#dataScenarioComparison#" ><cfabort>--->
<table id="fymSummaryTable" class="summaryTable">
	  <tr>
	  	<th class="header">Item</th>
	  	<th class="header">Campus</th>
	  	<th class="header">Chart</th>
	  	<th class="header">Scenario_Cd</th>
	  	<th class="header">Scenario_Nm</th>
		<th class="header">FY#application.shortfiscalyear# Adj Base Budget</th>
		<th class="header">FY#application.shortfiscalyear# Projection</th>
		<th class="header">FY#application.shortfiscalyear + 1# Projection</th>
		<th class="header">FY#application.shortfiscalyear + 2# Projection</th>
		<th class="header">FY#application.shortfiscalyear + 3# Projection</th>
		<th class="header">FY#application.shortfiscalyear + 4# Projection</th>
		<th class="header">FY#application.shortfiscalyear + 5# Projection</th>
	  </tr>
		<cfloop query="dataScenarioComparison">
			<tr>
				<td>#item#</td>
				<td>#inst_cd#</td>
				<td>#chart_cd#</td>
				<td>#scenario_cd#</td>
				<td>#scenario_nm#</td>
				<td>#pr_total#</td>
				<td>#cy_total#</td>
				<td>#yr1_total#</td>
				<td>#yr2_total#</td>
				<td>#yr3_total#</td>
				<td>#yr4_total#</td>
				<td>#yr5_total#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
</cfsavecontent>

<cfif StructKeyExists( URL, "preview" )>
	<html>
	<head>
		<title>Excel Data Preview</title>
	</head>
	<body>
		<cfset WriteOutput( strExcelData ) />
	</body>
	</html>
	<cfexit />
</cfif>

<cfheader
	name="Content-Disposition"
	value="attachment; filename=5YRModel_fym_data.xls"
	/>

<cfif StructKeyExists( URL, "text" )>
	<cfcontent type="application/msexcel" reset="true" />
	<cfset WriteOutput( strExcelData.Trim() ) />
<cfelseif StructKeyExists( URL, "file" )>
	<cfset strFilePath = GetTempFile(
		GetTempDirectory(),
		"excel_"
		) />
	<cffile
		action="WRITE"
		file="#strFilePath#"
		output="#strExcelData.Trim()#"
		/>

	<cfcontent
		type="application/msexcel"
		file="#strFilePath#"
		deletefile="true"
		/>
<cfelse>
	<cfcontent
		type="application/msexcel"
		variable="#ToBinary( ToBase64( strExcelData.Trim() ) )#"
		/>
</cfif>
	
<cfelse>
	<tr><td colspan="9"><b>Please CTRL-CLICK above to choose two or more scenarios for comparison.</b></td></tr>
</cfif>
	</table>  <!--- End of fymSummaryTable  --->

</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />