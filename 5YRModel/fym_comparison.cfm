<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset scenario_list = getUserScenarioList(currentUser.username) />
<!---<cfdump var="#scenario_list#" > <cfabort>--->
<cfset dataScenarioComparison = compareFYMscenario(20,21) />

<!---<cfdump var="#dataScenarioComparison#" >--->
<cfoutput>
<div class="full_content">
<!---<h2>Comparisons for Scenario #current_scenario#</h2>--->
<h2>Comparisons for Scenarios 20 and 21</h2>

<form name="compDownload" action="fym_comp_submit.cfm" method="post">
	<h3>CTRL-CLICK to select up to 9 Scenarios</h3>
	<select id="scenarioSelector" name="scenarioSelector" multiple="multiple" size="#scenario_list.recordcount#">
		 <cfloop query="#scenario_list#">
		 	<option value="#scenario_cd#">Scenario #scenario_cd# - #scenario_nm# (#scenario_owner#)</option>
		 </cfloop>
	</select><br>
	<input name="compSelectorBtn" type="submit" value="Get Scenarios" disabled /><i>Not quite ready yet...</i>
	<br><br>
	<input name="modelExcelDownBtn" type="submit" value="Download Model Comparisons to Excel" />
	<input name="crHrExcelDownBtn" type="submit" value="Download CrHr Comparisons to Excel" />
</form><br/>

<table id="fymSummaryTable" class="summaryTable">
	  <tr>
	  	<th>Item</th>
	  	<th>Scenario</th>
		<th>FY#application.shortfiscalyear# Adj Base Budget</th>
		<th>FY#application.shortfiscalyear# Projection</th>
		<th>FY#application.shortfiscalyear + 1# Projection</th>
		<th>FY#application.shortfiscalyear + 2# Projection</th>
		<th>FY#application.shortfiscalyear + 3# Projection</th>
		<th>FY#application.shortfiscalyear + 4# Projection</th>
		<th>FY#application.shortfiscalyear + 5# Projection</th>
	  </tr>
	<cfloop query="dataScenarioComparison">
	  	<tr>
	  		<td>#item#</td>
	  		<td><span class="sm-blue">#inst_cd# #chart_cd# #sort#</span><br>#scenario_cd# - #scenario_nm#</td>
	  		<td><span id="rs_pr">$ #NumberFormat(pr_total,'999,999,999')#</span></td>
	  		<td><span id="rs_cy">$ #NumberFormat(cy_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr1">$ #NumberFormat(yr1_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr2">$ #NumberFormat(yr2_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr3">$ #NumberFormat(yr3_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr4">$ #NumberFormat(yr4_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr5">$ #NumberFormat(yr5_total,'999,999,999')#</span></td>
	  	</tr>
	</cfloop>
	</table>  <!--- End of fymSummaryTable  --->
<!---<cfloop query="#dataScenarioComparison#">
	<cfif current_inst eq chart_cd>
	#oid# #scenario_cd# - #scenario_nm# #cur_fis_yr# #inst_cd# #inst_desc# #chart_cd# #chart_desc# #grp1_cd# #grp1_desc#
	#grp2_desc# #grp2_cd# #ln1_cd# #ln1_desc# #ln2_cd# #ln2_desc# #ln_sort# #cy_orig_budget_amt# #cur_yr_old# #cur_yr_new# #yr1_old#
	#yr1_new# #yr2_old# #yr2_new# #yr3_old# #yr3_new# #yr4_old# #yr4_new# #yr5_old# #yr5_new# #param_type_cd# #bus_logic# #details_disp# 
	#recalc_ind# #fym_comment#<br/><br/>
	</cfif>
</cfloop>--->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />