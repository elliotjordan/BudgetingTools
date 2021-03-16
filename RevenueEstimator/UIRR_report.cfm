<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfif IsDefined("url") and StructKeyExists(url,'Campus')>
	<cfset uirrData = getUIRRdata('#url.campus#') />
</cfif>

<cfif IsDefined("form") AND StructKeyExists(form,"E0175Btn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset reportLevel = "_" & url.campus />
	<!---<cfdump var="#reportSelect.recordcount#"><cfabort>--->
   	<cfif IsDefined("uirrData") AND uirrData.recordcount GT 0>
		<cfinclude template="E0175_creation.cfm" runonce="true" />
	<cfelse>
		<h3>We are sorry, but no records were returned.</h3>
   	</cfif>
</cfif>

<cfoutput>
	<!--- Top of page  --->
	<span>
		<a href="revenue_RC.cfm">RC Page</a><span> -- </span>
		<a href="revenue_Campus.cfm">Campus Page</a><span> -- </span>
		<a href="revenue_University.cfm">University Page</a>	
	</span>

  	<h2>Credit Hours Used in Budget Report for UIRR</h2>
	
	<!--- Button divs  --->
	<cfform action="UIRR_report.cfm?Campus=#url.campus#">
		<div class="controlBar">
			<div class="controlBinTL">
				<input id="E0175Btn" type="submit" name="E0175Btn" class="usersBtn" value="Download Report" />
		    </div>    <!-- End controlBinTL -->
		</div>    <!-- End controlBar -->
	</cfform>
	
	<table id="e0175Table" class="feeCodeTable">
		<thead>
			<tr>
				<th>Campus</th>
				<th>Acad Career</th>
				<th>Semester</th>
				<th>Fee Residency</th>
				<th>ACP Subset</th>
				<th>OCC Subset</th>
				<th>OVST Subset</th>
				<th>Dual Subset</th>
				<th>Total CrHrs</th>
				<th>Budgeted for FY</th>	
			</tr>
		</thead>
		<tbody>
		<cfif uirrData.recordCount gt 0>
			<cfloop query="#uirrData#">
				<tr>
					<td>#inst#</td>
					<td>#acad_career#</td>
					<td>#sem#</td>
					<td>#res#</td>
					<td>#NumberFormat(acp_count,"999,999")#</td>
					<td>#NumberFormat(occ_count,"999,999")#</td>
					<td>#NumberFormat(ovst_count,"999,999")#</td>
					<td>#NumberFormat(dual_count,"999,999")#</td>
					<td>#NumberFormat(total_count,"999,999")#</td>
					<td>#budgeted_for_fy#</td>
				</tr>
			</cfloop>
		<cfelse>
			<tr><td colspan="10">Sorry, no data yet available.</td>
		</cfif>
		</tbody>
	</table>
  </cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">
