<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset fundTypes = getFundTypes() />  
<!--- These values apparently never change re: scenarios? TODO ask Nate  --->
<cfset fymSurplus = getFymSurplus(current_inst) />
<cfset compDetails = getCompDetails(current_inst) />
<!--- Campus Submission (Scenario 0) is always available as an object  --->
<cfset fymSummaryTable = getFymSummary(0,current_inst) />   
<cfset crHrTotals = getCrHrSums(0,current_inst) />
<cfset commentBucket = convertQueryToStruct(getFYMcomments()) />  
<cfdump var="#fymSummaryTable#" />
<cfoutput>
<cffunction name="QueryAppend2" access="public" returntype="void" output="false"
	hint="This takes two queries and appends the second one to the first one. This actually updates the first query and does not return anything.">

	<!--- Define arguments. --->
	<cfargument name="QueryOne" type="query" required="true" />
	<cfargument name="QueryTwo" type="query" required="true" />

	<!--- Define the local scope. --->
	<cfset var LOCAL = StructNew() />

	<!--- Get the column list (as an array for faster access. --->
	<cfset LOCAL.Columns = ListToArray( ARGUMENTS.QueryTwo.ColumnList ) />


	<!--- Loop over the second query. --->
	<cfloop query="ARGUMENTS.QueryTwo">

		<!--- Add a row to the first query. --->
		<cfset QueryAddRow( ARGUMENTS.QueryOne ) />

		<!--- Loop over the columns. --->
		<cfloop index="LOCAL.Column" from="1" to="#ArrayLen( LOCAL.Columns )#" step="1">

			<!--- Get the column name for easy access. --->
			<cfset LOCAL.ColumnName = LOCAL.Columns[ LOCAL.Column ] />

			<!--- Set the column value in the newly created row. --->
			<cfset rowNumber = ARGUMENTS.QueryOne.RecordCount + ARGUMENTS.QueryTwo.CurrentRow />
			<cfset ARGUMENTS.QueryOne[ LOCAL.ColumnName ][ RowNumber] = ARGUMENTS.QueryTwo[ LOCAL.ColumnName ][ ARGUMENTS.QueryTwo.CurrentRow ] />

		</cfloop>

	</cfloop>

	<!--- Return out. --->
	<cfreturn  />
</cffunction>
<cfset fstLong = "fstLong operating..." />

<cfif current_scenario neq 0>
	<cfset fymSummaryTable2 = getFymSummary(current_scenario,current_inst) />  
	<!---<cfdump var="#fymSummaryTable2#" > --->
	<cfset crHrTotals2 = getCrHrSums(current_scenario,current_inst) />
	<cfset fstLong = QueryAppend2(fymSummaryTable,fymSummaryTable2) />
	<cfscript>
		/*fymSummaryTableSorted = QuerySort(fstLong, function(s1,s2) {
			return compare(s1.OID, s2.OID);
		});
		chtLong = QueryAppend(crHrTotals,crHrTotals2);
		*/
	</cfscript>
	
</cfif>
<cfdump var="#fymSummaryTable#" ><cfabort>

<div class="full_content">
<cfif FindNoCase("rohan",application.baseurl) OR FindNoCase("8443",application.baseurl)>
	<cfinclude template="test_banner.cfm">
</cfif>
<cfif openModel and current_scenario eq 0> 
	<cfset editcy = true /><cfset edityr1 = true /><cfset edityr2 = true /><cfset edityr3 = true /><cfset edityr4 = true /><cfset edityr5 = true />
<cfelse>
	<cfset editcy = false /><cfset edityr1 = false /><cfset edityr2 = false /><cfset edityr3 = false /><cfset edityr4 = false /><cfset edityr5 = false />
</cfif>
<cfinclude template="prod_banner.cfm" runonce="true" />
<h2>5-Year Model for #getDistinctChartDesc(current_inst)# FY#application.shortfiscalyear# <cfif showScenarios>- Scenario: #scenario_details.scenario_nm#</cfif></h2>
<form id="fymForm" action="fym_submit.cfm" method="post" >
<!---<input name="fymCrHrCompareBtn" type="submit" value="Compare to CrHr Projector" />--->
<cfif fymSummaryTable.recordCount neq 0>
	<h3>Summary</h3>
	<!--- Begin summary table  --->
	  <cfinclude template="5yrmodel_summary_rows.cfm" runonce="true" />
    <!--- End summary table  --->
<cfelse>
	<h3>Summary</h3>
	<p>We're sorry, but no summary records exist. Please contact us.</p>
</cfif>
<!--- ************************************************ --->
<hr />

<cfloop query="fundTypes" >
	<cfif grp1_cd gt 0>
	<cfset ci = getFYMdataByFnd(current_scenario, current_inst, grp1_cd) />
	<cfset campusSubTotal = getFymSums(current_scenario,current_inst, grp1_cd) /> 
	<cfset revSubTotals = getFymSubTotals(current_scenario,current_inst,grp1_cd,1) />
	<cfset expSubTotals = getFymSubTotals(current_scenario,current_inst,grp1_cd,2) />
	<h3>#grp1_desc#</h3>
  	<input name="fymExcelBtn" type="submit" value="Export to Excel" />
  	<input name="fymSubmitBtn" type="submit" value="Update 5YR Model" />
  	
  	<span class="change_warning">You have unsaved changes in one or more tables. Be sure to update before leaving the page.</span>
  	<!---  table header  --->
	<table id="fymMainTable#grp1_cd#" class="allFeesTable">
		<thead>
		  <tr>
			<th>Fund Group<br>Revenue/Expense</th>
			<th>FY#application.shortfiscalyear# Adj Base Budget<br><span class="sm-blue"><i>as of Oct 4, 2021</i></span></th>
			<th>FY#application.shortfiscalyear# Projection</th>
			<th>FY#application.shortfiscalyear + 1# Projection</th>
			<th>FY#application.shortfiscalyear + 2# Projection</th>
			<th>FY#application.shortfiscalyear + 3# Projection</th>
			<th>FY#application.shortfiscalyear + 4# Projection</th>
			<th>FY#application.shortfiscalyear + 5# Projection</th>
			<th>Comments</th>
		  </tr>
	    </thead>
	    <tbody>
	 <!--- Dynamic content --->
	  <cfset group_counter = 0>
	  <cfloop query="#ci#">
	  	<cfif grp1_desc neq 'PARAM' and grp2_cd eq 1>
			<cfinclude template="5yrmodel_table_rows.cfm" runonce="false" />
		</cfif>
	  </cfloop>
	  <!--- Revenue sub-totals  --->
	  <cfloop query="#revSubTotals#">
	  	<tr>
	  		<td id="rtst_label" class="subTotal_bold">
	  			Revenue Sub-totals
	  		</td>
	  		<td id="rtblst_pr" class="subTotal_bold">$ #NumberFormat(pr_total,'999,999,999')#</td>
	  		<td id="rtblst_cy" class="subTotal_bold">$ #NumberFormat(cy_total,'999,999,999')#</td>
	  		<td id="rtblst_yr1" class="subTotal_bold">$ #NumberFormat(yr1_total,'999,999,999')#</td>
	  		<td id="rtblst_yr2" class="subTotal_bold">$ #NumberFormat(yr2_total,'999,999,999')#</td>
	  		<td id="rtblst_yr3" class="subTotal_bold">$ #NumberFormat(yr3_total,'999,999,999')#</td>
	  		<td id="rtblst_yr4" class="subTotal_bold">$ #NumberFormat(yr4_total,'999,999,999')#</td>
	  		<td id="rtblst_yr5" class="subTotal_bold">$ #NumberFormat(yr5_total,'999,999,999')#</td>
	  		<td id="rtblst_comm" class="subTotal_bold"></td>
	  	</tr>
	  </cfloop>
	  <!--- Expense main rows  --->
	  <cfloop query="#ci#">
	  	<cfif grp1_desc neq 'PARAM' and grp2_cd eq 2>
			<cfinclude template="5yrmodel_table_rows.cfm" runonce="false" />
		</cfif>
	  </cfloop>
	  <!--- Expense sub-totals  --->
	  <cfloop query="#expSubTotals#">
	  	<tr>
	  		<td id="exstbl_label" class="subTotal_bold">Expense Sub-totals</b></td>
	  		<td id="exstbl_pr" class="subTotal_bold">$ #NumberFormat(pr_total,'999,999,999')#</b></td>
	  		<td id="exstbl_cy" class="subTotal_bold">$ #NumberFormat(cy_total,'999,999,999')#</b></td>
	  		<td id="exstbl_yr1" class="subTotal_bold">$ #NumberFormat(yr1_total,'999,999,999')#</b></td>
	  		<td id="exstbl_yr2" class="subTotal_bold">$ #NumberFormat(yr2_total,'999,999,999')#</b></td>
	  		<td id="exstbl_yr3" class="subTotal_bold">$ #NumberFormat(yr3_total,'999,999,999')#</b></td>
	  		<td id="exstbl_yr4" class="subTotal_bold">$ #NumberFormat(yr4_total,'999,999,999')#</b></td>
	  		<td id="exstbl_yr5" class="subTotal_bold">$ #NumberFormat(yr5_total,'999,999,999')#</b></td>
	  		<td id="exstbl_comm" class="subTotal_bold"></td>
	  	</tr>
	  </cfloop>
	  <!--- Hard-coded row to show campus sub-total at bottom of each fund group table  --->
	  	  	<cfif campusSubTotal.recordCount eq 1>
	  			<tr>
	  				<td id="sdstbl_label" class="subTotal_gray">Surplus/Deficit</td>
					<td id="sdstbl_pr" class="subTotal_gray">$ #NumberFormat(campusSubTotal.pr_total,'999,999,999')#</td>
					<td id="sdstbl_cy" class="subTotal_gray">$ #NumberFormat(campusSubTotal.cy_total,'999,999,999')#</td>
					<td id="sdstbl_yr1" class="subTotal_gray">$ #NumberFormat(campusSubTotal.yr1_total,'999,999,999')#</td>
					<td id="sdstbl_yr2" class="subTotal_gray">$ #NumberFormat(campusSubTotal.yr2_total,'999,999,999')#</td>
					<td id="sdstbl_yr3" class="subTotal_gray">$ #NumberFormat(campusSubTotal.yr3_total,'999,999,999')#</td>
					<td id="sdstbl_yr4" class="subTotal_gray">$ #NumberFormat(campusSubTotal.yr4_total,'999,999,999')#</td>
					<td id="sdstbl_yr5" class="subTotal_gray">$ #NumberFormat(campusSubTotal.yr5_total,'999,999,999')#</td>
					<td id="sdstbl_comm" class="subTotal_gray"></td>
	  			</tr>
	  		</cfif>
	  	</tbody>
	</table>
  	<input name="authUser" type="hidden" value="#REQUEST.authUser#" />
  	<input name="fymSubmitBtn" type="submit" value="Update 5YR Model" />
  </cfif>
  </cfloop>
</form>
<hr />
</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
