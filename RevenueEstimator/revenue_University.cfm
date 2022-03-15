<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfset authUser = getUser(REQUEST.authuser)>
<cfoutput>
<!--- User has asked for a V1 report. --->
	<cfif application.rateStatus eq "Vc">
		<cfset reportSelect = getB325_Vc_Campus_data()> 
	<cfelse>
	    <!---<cfset reportSelect = getB325_V1_Campus_data()> --->
	    <cfset reportSelect = getProjectinatorData()> 
	 </cfif>
<cfif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset reportLevel = "_ALL_Campus" />
	<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
		<cfinclude template="V1_creation.cfm" runonce="true" />
	<cfelse>
		<h3>We are sorry, but no records were returned.</h3>
	</cfif>
<cfelseif IsDefined("form") AND StructKeyExists(form,"sqlBtn")>
	<cfset reportSelectSQL = reportSelect.getMetadata().getExtendedMetaData().sql />
	<p>#reportSelectSQL#</p>
<cfelseif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
	<cfset ExcelSelect = getProjectinatorData("NONE","NONE",application.rateStatus)>
	<cfinclude template="export_to_excel.cfm" runonce="true" />
</cfif>
	<div class="full_content">
		<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a>
			<span class="sm-blue"> 
				<i>Currently set to <b>
					<cfif application.rateStatus eq "Vc">constant effective rates.
					<cfelseif application.rateStatus eq "V1">adjusted escalated rates.
					</cfif></b>
				</i>
			</span>
		</h2>
		<span class="sm-blue"> <i>v3 - #application.budget_year# of the #application.biennium# Biennium</i></span><p>
		<a href="revenue_RC.cfm">RC Page</a><span> -- </span><a href="revenue_Campus.cfm">Campus Page</a>
		</p>
			<h3>University Summary</h3>
<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>
<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser) OR ListFindNoCase(REQUEST.regionalUsernames, REQUEST.authUser)>
		<cfform action="revenue_University.cfm">	
			<div class="controlBar">
				<div class="controlBinTC">
					<cfif application.rateStatus eq 'Vc'>
						<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate Vc Report" />
						<br>
						<input id="sqlBtn" type="submit" name="sqlBtn" class="sqlBtn" value="Show Vc Report SQL" /><br>
						<cfset vc_path = 'templates\B325_Student_Fee_Revenue_Vc_template.xlsx' />
						<a href="#vc_path#">Vc Template</a>
					<cfelse>
						<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate V1 Report" />
						<br>
						<input id="sqlBtn" type="submit" name="sqlBtn" class="sqlBtn" value="Show V1 Report SQL" /><br>
						<cfset v1_path = 'templates\B325_Student_Fee_Revenue_V1_template.xlsx' />
						<a href="#v1_path#">V1 Template</a>
					</cfif>
				</div>
				<!-- End div controlBinTR -->
			
				<div class="controlBinTLC">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel" disabled>
				</div>  <!-- End controlBinTLC -->
			</div>  <!-- End div controlBar -->
			<p>Running totals for each Campus.</p>
			<table id="CampusTotalTable" class="feeCodeTable">
				<thead>
					<tr>
						<th>Chart</th>
						<th>Total Actual Credit Hours</th>
						<th>Total UBO Projected Credit Hours YR1</th>
						<th>Total UBO Estimated Revenue YR1</th>
						<th>Total Campus Projected Credit Hours YR1</th>
						<th>Estimated Revenue YR1</th>
						<th>Total UBO Projected Credit Hours YR2</th>
						<th>Total UBO Estimated Revenue YR2</th>
						<th>Total Campus Projected Credit Hours YR2</th>
						<th>Estimated Revenue YR2</th>
					</tr>
				</thead>
			</table>

			<p>Running totals for each Campus broken out by RC.</p>
			<table id="CampusTotalByRCTable" class="feeCodeTable">
				<thead>
					<tr>
						<th>Chart</th>
						<th>RC Code</th>
						<th>RC Name</th>
						<th>Total Actual Credit Hours</th>
						<th>Total UBO Projected Credit Hours YR1</th>
						<th>Total UBO Estimated Revenue YR1</th>
						<th>Total Campus Projected Credit Hours YR1</th>
						<th>Estimated Revenue YR1</th>
						<th>Total UBO Projected Credit Hours YR2</th>
						<th>Total UBO Estimated Revenue YR2</th>
						<th>Total Campus Projected Credit Hours YR2</th>
						<th>Estimated Revenue YR2</th>
					</tr>
				</thead>
<!---				<tbody>
					<cfloop query="allCampusEstRevByRC">
						<tr>
							<td>#CHART#</td>
							<td>#RC_CD#</td>
							<td>#RC_NM#</td>
							<td>#NumberFormat(ACTUAL,'999,999,999')#</td>
							<td>#NumberFormat(MACHINEHOURS_YR1,'999,999,999')#</td>
							<td>#DollarFormat(UBO_ESTREV_YR1)#</td>
							<td>#NumberFormat(PROJHOURS_YR1,'999,999,999')#</td>
							<td>#DollarFormat(ESTREV_YR1)#</td>
							<td>#NumberFormat(MACHINEHOURS_YR2,'999,999,999')#</td>
							<td>#DollarFormat(UBO_ESTREV_YR2)#</td>
							<td>#NumberFormat(PROJHOURS_YR2,'999,999,999')#</td>
							<td>#DollarFormat(ESTREV_YR2)#</td>
						</tr>
					</cfloop>
				</tbody>--->
			</table>
		</cfform>
<cfelse>
	<p>We are sorry but you are not currently authorized to view the campus totals table.  Call UBO and we can add you to the approved user list.  Thank you!</p>
</cfif>
	</div>  <!-- End of div CONTENT -->
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">
