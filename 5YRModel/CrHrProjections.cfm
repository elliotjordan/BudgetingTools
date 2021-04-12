<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfset userDetails = getFeeUser(REQUEST.authUser) />
<cfset crHrInfo = getFYM_CrHrdata(current_inst) />
<cfset crHrSums = getCrHrSums_OLD(current_inst,'NO') />  <!--- CF logic, not a function in Postgres --->
<cfset campusStruct = convertQueryToStruct(crHrInfo) />
<cfset userDetails = getFeeUser(REQUEST.authUser) />
<cfset campusRateEditors = "aheeter,freemanr,kcwalsh,garobe,jbdimond" />
<cfoutput>
<div class="full_content">
<cfif ListFindNoCase('blork',current_inst) or REQUEST.authUser eq 'sbadams'>
	<cfset editcy = true /><cfset edityr1 = true /><cfset edityr2 = true /><cfset edityr3 = true /><cfset edityr4 = true /><cfset edityr5 = true />
<cfelse>
	<cfset editcy = false /><cfset edityr1 = false /><cfset edityr2 = false /><cfset edityr3 = false /><cfset edityr4 = false /><cfset edityr5 = false />
	<cfinclude template="prod_banner.cfm" runonce="true" />
</cfif>

<h2>#getDistinctChartDesc(current_inst)# Credit Hours - FY#application.shortfiscalyear#</h2>
<form id="fymCrHrBtn" name="fymCrHrBtn" action="CrHrDownload.cfm"><input type="submit" value="Donwload 5Yr Model Cr Hrs" /></form>
<h3>Summary</h3>
	<table class="summaryTable">
	  <tr>
		<th>Item</th>
		<th>FY#application.shortfiscalyear#</th>
		<th>FY#application.shortfiscalyear + 1#</th>
		<th>FY#application.shortfiscalyear + 2#</th>
		<th>FY#application.shortfiscalyear + 3#</th>
		<th>FY#application.shortfiscalyear + 4#</th>
		<th>FY#application.shortfiscalyear + 5#</th>
	  </tr>
	  <cfif crHrSums.recordcount gt 0>
	  <cfloop query="crHrSums">
	  	<tr>
	  		<td><span class="sm-blue">Total CrHrs</span><br>
	  			<span class="sm-green">Total Revenue</span></td>
	  		<td><span class="sm-blue">#NumberFormat(cy_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(cy_total_rev,'999,999,999')#</span></td>
	  		<td><span class="sm-blue">#NumberFormat(yr1_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(yr1_total_rev,'999,999,999')#</span></td>
	  		<td><span class="sm-blue">#NumberFormat(yr2_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(yr2_total_rev,'999,999,999')#</span></td>
	  		<td><span class="sm-blue">#NumberFormat(yr3_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(yr3_total_rev,'999,999,999')#</span></td>
	  		<td><span class="sm-blue">#NumberFormat(yr4_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(yr4_total_rev,'999,999,999')#</span></td>
	  		<td><span class="sm-blue">#NumberFormat(yr5_total_crhrs,'999,999,999.9')#</span><br>
	  			<span class="sm-green">$ #NumberFormat(yr5_total_rev,'999,999,999')#</span></td>
	  	</tr>
	  </cfloop>
	  <cfelse><tr><td colspan = '8'>Sorry, no records found for your campus.</td></tr></cfif>
	</table>
	<hr>
		<h3>Update #getDistinctChartDesc(currentUser.fym_inst)# Credit Hour Model</h3>
<form id='fymCrHrForm' action="fym_crHr_submit.cfm" method="post" >
  	<input name="fymCrHrSubmitBtn" type="submit" value="Update CrHr Model" />
  	<span class="change_warning">You have unsaved changes in one or more tables. Be sure to update before leaving the page.</span>
	<table class="allFeesTable">
	  <tr>
		<th>Acad career</th>
		<th>Residency</th>
		<th>FY#application.shortfiscalyear#</th>
		<th>FY#application.shortfiscalyear + 1#</th>
		<th>FY#application.shortfiscalyear + 2#</th>
		<th>FY#application.shortfiscalyear + 3#</th>
		<th>FY#application.shortfiscalyear + 4#</th>
		<th>FY#application.shortfiscalyear + 5#</th>
	  </tr>
  <cfif crHrSums.recordcount gt 0>
	  <cfloop query="#crHrInfo#">
	  	<tr>
	  		<td>#acad_career#<br>
	  			<input type="hidden" value="#OID#"></td>
	  		<td>#res#</td>
	  		<!--- *** --->
			<td class="math">
				<span id="orig_cy_hrs#OID#" class="sm-blue">Orig Current YR hrs: #NumberFormat(cur_yr_hrs,'999,999.9')#</span><br>
	<span class="sm-green">New hrs:
		<cfif editcy>
			<input id="cur_yr_hrs_newOID#OID#" name="cur_yr_hrs_newOID#OID#" type="text" size="10" value="#trim(NumberFormat(cur_yr_hrs_new,'999,999.9'))#" />
					 <br />
					 <input id="cur_yr_hrs_newOID#OID#DELTA" name="cur_yr_hrs_newOID#OID#DELTA" type="hidden" value="false">
		<cfelse><span id="#cur_yr_hrs_new#OID" name="#cur_yr_hrs_new#OID">#trim(NumberFormat(cur_yr_hrs_new,'999,999.9'))#</span>
		</cfif></span><br />
				<cfif editcy and (ListFindNoCase(campusRateEditors, REQUEST.authUser) or ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser))>
				<span class="sm-green">Current YR rate:
					$<input id="cur_yr_rtOID#OID#" name="cur_yr_rtOID#OID#" type="text" size="10" value="#trim(NumberFormat(cur_yr_rt,'999,999.99'))#" />
					<br>
					<input id="cur_yr_rtOID#OID#DELTA" name="cur_yr_rtOID#OID#DELTA" type="hidden" value="false">
				<cfelse>
				<span id="cur_yr_rt#OID#" name="cur_yr_rt#OID#" class="sm-green">Current YR rate: $#trim(NumberFormat(cur_yr_rt,'999,999.99'))#
				</cfif></span><br/>
			    <span id="cur_yr_tot#OID#" name="cur_yr_tot#OID#" class="sm-green">Total revenue: $#trim(NumberFormat(cur_yr_rev,'999,999'))#</span>
			</td>
            <!--- *** --->
			<td class="math">
				<span id="orig_yr1_hrs#OID#" class="sm-blue">Orig YR1 hrs: #NumberFormat(yr1_hrs,'999,999.9')#</span><br>
	<span class="sm-green">New hrs:
		<cfif edityr1><input id="yr1_hrs_newOID#OID#" name="yr1_hrs_newOID#OID#" type="text" size="10" value="#trim(NumberFormat(yr1_hrs_new,'999,999.9'))#" />
					  <br>
					  <input id="yr1_hrs_newOID#OID#DELTA" name="yr1_hrs_newOID#OID#DELTA" type="hidden" value="false">
		<cfelse><span id="yr1_hrs_new#OID#" name="yr1_hrs_new#OID#">#trim(NumberFormat(yr1_hrs_new,'999,999.9'))#</span>
		</cfif></span><br />
			  <span id="yr1_rt" name="yr1_rt" class="sm-green">YR1 rate: $#NumberFormat(yr1_rt,'999,999.99')#</span><br>
			  <span id="yr1_tot" name="yr1_tot" class="sm-green">Total revenue: $#trim(NumberFormat(yr1_rev,'999,999'))#</span>
			</td>
            <!--- *** --->
			<td class="math">
				<span id="orig_yr2_hrs#OID#" class="sm-blue">Orig YR2 hrs: #NumberFormat(yr2_hrs,'999,999.9')#</span><br>
	<span class="sm-green">New hrs:
	<cfif edityr2>
		<input id="yr2_hrs_newOID#OID#" name="yr2_hrs_newOID#OID#" type="text" size="10" value="#trim(NumberFormat(yr2_hrs_new,'999,999.9'))#" />
				  <input id="yr2_hrs_newOID#OID#DELTA" name="yr2_hrs_newOID#OID#DELTA" type="hidden" value="false">
	<cfelse><span id="yr2_hrs_new#OID#" name="yr2_hrs_new#OID#">#trim(NumberFormat(yr2_hrs_new,'999,999.9'))#</span>
	</cfif></span><br />
			 <span id="yr2_rt" name="yr2_rt" class="sm-green">YR2 rate: $#trim(NumberFormat(yr2_rt,'999,999.99'))#</span><br>
			 <span id="yr2_tot" name="yr2_tot" class="sm-green">Total revenue: $#trim(NumberFormat(yr2_rev,'999,999'))#</span>
			</td>
			<!--- *** --->
			<td class="math">
				<span id="orig_yr3_hrs#OID#" class="sm-blue">Orig YR3 hrs: #trim(NumberFormat(yr3_hrs,'999,999.9'))#</span><br>
	<span class="sm-green">New hrs:
	<cfif edityr3>
		<input id="yr3_hrs_newOID#OID#" name="yr3_hrs_newOID#OID#" type="text" size="10" value="#trim(NumberFormat(yr3_hrs_new,'999,999.9'))#" />
				  <br>
				  <input id="yr3_hrs_newOID#OID#DELTA" name="yr3_hrs_newOID#OID#DELTA" type="hidden" value="false">
	<cfelse><span id="yr3_hrs_new#OID#" name="yr3_hrs_new#OID#">#trim(NumberFormat(yr3_hrs_new,'999,999.9'))#</span>
	</cfif></span><br />
			 <span id="yr3_rt" name="yr3_rt" class="sm-green">YR3 rate: $#trim(NumberFormat(yr3_rt,'999,999.99'))#</span><br>
			 <span id="yr3_tot" name="yr3_tot" class="sm-green">Total revenue: $#trim(NumberFormat(yr3_rev,'999,999'))#</span>
			</td>
			<!--- *** --->
			<td class="math">
				<span id="orig_yr4_hrs#OID#" class="sm-blue">Orig YR4 hrs: #trim(NumberFormat(yr4_hrs,'999,999.9'))#</span><br>
	<span class="sm-green">New hrs:
	<cfif edityr4>
		<input id="yr4_hrs_newOID#OID#" name="yr4_hrs_newOID#OID#" type="text" size="10" value="#trim(NumberFormat(yr4_hrs_new,'999,999.9'))#" />
				  <input id="yr4_hrs_newOID#OID#DELTA" name="yr4_hrs_newOID#OID#DELTA" type="hidden" value="false">
	<cfelse><span id="yr4_hrs_new#OID#" name="yr4_hrs_new#OID#">#trim(NumberFormat(yr4_hrs_new,'999,999.9'))#</span>
	</cfif></span><br />
			 <span id="yr4_rt" name="yr4_rt" class="sm-green">YR4 rate: $#trim(NumberFormat(yr4_rt,'999,999.99'))#</span><br>
			 <span id="yr4_tot" name="yr4_tot" class="sm-green">Total revenue: $#trim(NumberFormat(yr4_rev,'999,999'))#</span>
			</td>
			<!--- *** --->
			<td class="math">
				<span id="orig_yr5_hrs#OID#" class="sm-blue">Current hrs: #trim(NumberFormat(yr5_hrs,'999,999.9'))#</span><br>
	<span class="sm-green">New hrs:
	<cfif edityr5><input id="yr5_hrs_newOID#OID#" name="yr5_hrs_newOID#OID#" type="text" size="10" value="#NumberFormat(yr5_hrs_new,'999,999.9')#" />
				  <input id="yr5_hrs_newOID#OID#DELTA" name="yr5_hrs_newOID#OID#DELTA" type="hidden" value="false">
	<cfelse><span id="yr5_hrs_new#OID#" name="yr5_hrs_new#OID#">#trim(NumberFormat(yr5_hrs_new,'999,999.9'))#</span>
	</cfif></span><br />
			 <span id="yr5_rt" name="yr5_rt" class="sm-green">YR5 rate: $#trim(NumberFormat(yr5_rt,'999,999.99'))#</span><br>
			 <span id="yr5_tot" name="yr5_tot" class="sm-green">Total revenue: $#trim(NumberFormat(yr5_rev,'999,999'))#</span>
			</td>
		</tr>
	  </cfloop>
	  <cfelse><tr><td colspan = '10'>Sorry, no records found for your campus.</td></tr></cfif>
	</table>
  	<input name="authUser" type="hidden" value="#REQUEST.authUser#" />
  	<input name="fymCrHrSubmitBtn" type="submit" value="Update CrHr Model" />
</form>
<hr />
</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
