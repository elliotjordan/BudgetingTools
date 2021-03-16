<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset fundTypes = getFundTypes() />  

<!--- if user has more than one fym-inst, offer a selector  --->
<!---<cfset current_inst = ListFirst(currentUser.fym_inst) />--->
<!---<cfset current_inst = getFocus(currentUser.username).focus /> --->

<cfset fymRevSums = getFymRevSums(current_inst) />
<cfset fymRevDelta = getFymRevDelta(current_inst) />
<cfset fymExpSums = getFymExpSums(current_inst) />
<cfset fymExpDelta = getFymExpDelta(current_inst) />
<cfset fymSurplus = getFymSurplus(current_inst) />
<cfset crHrTotals = getCrHrSums(current_inst) />
<cfset compDetails = getCompDetails(current_inst) />
<cfset commentBucket = convertQueryToStruct(getFYMcomments()) />
<!---<cfdump var="#compDetails.columnList#" >--->
<cfset editcy = true /><cfset edityr1 = true /><cfset edityr2 = true /><cfset edityr3 = true /><cfset edityr4 = true /><cfset edityr5 = true />
<cfoutput>
<div class="full_content">
<!---<h2>5-Year Model for #getDistinctChartDesc(currentUser.fym_inst)# FY#application.shortfiscalyear#</h2>--->
<h2>5-Year Model for #getDistinctChartDesc(current_inst)# FY#application.shortfiscalyear#</h2>

<cfif fymRevSums.recordCount neq 0>
	<h3>Summary</h3>
	<!--- Begin summary table  --->
		<table id="fymSummaryTable" class="summaryTable">
		  <tr>
		  	<th>Item</th>
			<th>FY#application.shortfiscalyear# Adj Base Budget</th>
			<th>FY#application.shortfiscalyear# Projection</th>
			<th>FY#application.shortfiscalyear + 1# Projection</th>
			<th>FY#application.shortfiscalyear + 2# Projection</th>
			<th>FY#application.shortfiscalyear + 3# Projection</th>
			<th>FY#application.shortfiscalyear + 4# Projection</th>
			<th>FY#application.shortfiscalyear + 5# Projection</th>
		  </tr>
		  <cfinclude template="5yrmodel_summary_rows.cfm" runonce="true" />
		</table>  <!--- End summary table  --->
</cfif>
<!--- ************************************************ --->
<hr />
<form id="fymForm" action="fym_submit.cfm" method="post" >
<cfloop query="fundTypes" >
	<cfif grp1_cd gt 0>
	<!---<cfset ci = getFYMdataByFnd(currentUser.fym_inst, grp1_cd) />--->
	<cfset ci = getFYMdataByFnd(current_inst, grp1_cd) />
	<!---<cfset campusSubTotal = getFymSums(currentUser.fym_inst, grp1_cd) />--->	<!---  fee_user.calc_fym_subtotal_grp1  --->
	<cfset campusSubTotal = getFymSums(current_inst, grp1_cd) />
	<!---<cfset revSubTotals = getFymSubTotals(currentUser.fym_inst,grp1_cd,1) />--->  <!--- fee_user.calc_fym_subtotal_grp2 --->
	<cfset revSubTotals = getFymSubTotals(current_inst,grp1_cd,1) />
	<!---<cfset expSubTotals = getFymSubTotals(currentUser.fym_inst,grp1_cd,2) />--->  <!--- fee_user.calc_fym_subtotal_grp2 --->
	<cfset expSubTotals = getFymSubTotals(current_inst,grp1_cd,2) />
	<h3>#grp1_desc#</h3>
  	<input name="fymExcelBtn" type="submit" value="Export to Excel" />
  	<input name="fymSubmitBtn" type="submit" value="Update 5YR Model" />
  	<span class="change_warning">You have unsaved changes in one or more tables. Be sure to update before leaving the page.</span>
  	<!---  table header  --->
	<table id="fymMainTable#grp1_cd#" class="allFeesTable">
		<thead>
		  <tr>
			<th>Fund Group<br>Revenue/Expense</th>
			<th>FY#application.shortfiscalyear# Adj Base Budget<br><span class="sm-blue"><i>as of Jan 21</i></span></th>
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
	  <cfset group_counter = 0><!--- <cfdump var="#compDetails#" />---> <!--- <cfdump var="#fundTypes#" />--->
	  <cfloop query="#ci#">  <!--- <cfset revExpTotals = getFYMdata(currentUser.fym_inst, grp1_cd,grp2_cd) />  --->
	  	<cfif grp1_desc neq 'PARAM' and grp2_cd eq 1>
			<cfinclude template="5yrmodel_table_rows.cfm" runonce="false" />
		</cfif>
	  </cfloop>
	  <!--- Revenue sub-totals  --->
	  <cfloop query="#revSubTotals#">
	  	<tr>
	  		<td id="rtst_label" class="subTotal_bold">
	  			<!---<span class="sm-blue">#grp1_desc#</span>--->
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
	  		<td id="exstbl_label" class="subTotal_bold"><!---#grp1_desc#<br/>--->Expense Sub-totals</b></td>
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
	  				<td id="sdstbl_label" class="subTotal_gray"><!---#grp1_desc#<br/>--->Surplus/Deficit</td>
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
<!---<cfdump var="#campusStruct#" >--->

</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
