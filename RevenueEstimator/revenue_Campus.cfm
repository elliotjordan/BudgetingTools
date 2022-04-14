<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfset authUser = getUser(REQUEST.authuser)>
<cfparam name="getCampus" type="string" default="" >
<cfparam name="urlCampus" type="string" default="">
<cfparam name="UrlRC" type="string" default="">
<cfparam name="DataSelect" type="query" default="#QueryNew('ID','integer')#">
<cfset urlCampus = authUser['chart'][1]>
<cfset distinctRCs = getDistinctRCs(urlCampus) />
<cfset subTots = createSubTotalsStruct('#urlCampus#') />
<cfset sesnTots = createSesnTotalsStruct('#urlCampus#') />
<cfset rcRevTots = createRCRevenueStruct('#urlCampus#') />
<cfset sesnRevTots = createSesnRevenueStruct('#urlCampus#') />
<cfset dssIsOpen = checkDSSavailability() />

<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>

<cfset urlRC = authUser['projector_RC'][1]>
<cfoutput> 
<!--- User has asked for an Excel downoad --->
<cfif IsDefined("form") AND StructKeyExists(form,"usersBtn")>
	<cflocation url="projector_users.cfm" addtoken="false">
<cfelseif IsDefined("form") AND StructKeyExists(form,"subAcctBtn")>
	<cflocation url="campus_controls.cfm" addtoken="false">
<cfelseif IsDefined("form") AND StructKeyExists(form,"uirrBtn")>
	<cfset userCampus = "IU" & authUser.chart & "A" />
	<cflocation url="UIRR_report.cfm?Campus=#userCampus#" addtoken="false">
<cfelseif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
	<cfset ExcelSelect = getProjectinatorData(urlCampus,"NONE",application.rateStatus,"excel")>
	<cfinclude template="export_to_excel.cfm" runonce="true" />
<!--- User has asked for a V1 report. --->
<cfelseif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset reportLevel = "_" & urlCampus & "_Campus" />  
		<cfif application.rateStatus eq "Vc">
			<cfset reportSelect = getB325_Vc_Campus_data(urlCampus, 'ALL', true)> 
		<cfelse>
		    <cfset reportSelect = getProjectinatorDataV1('IU'&urlCampus&'A')> 
		 </cfif>
   	<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
		<cfinclude template="V1_creation.cfm" runonce="true" />
	<cfelse>
		<h3>We are sorry, but no records were returned.</h3>
   	</cfif>
</cfif>

    <!--- Main page  --->
	<div class="full_content">
		<cfinclude template="prod_banner.cfm" runonce="true" />
		<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a> 
			<span class="sm-blue"> 
				<i>Currently set to <b>
					<cfif application.rateStatus eq "Vc">constant effective rates.
					<cfelseif application.rateStatus eq "V1">adjusted escalated rates.
					</cfif></b>
				</i>
			</span>
		</h2>
		<span class="sm-blue"> <i>v3 - #application.budget_year# of the #application.biennium# Biennium</i></span>
		<p>
			<cfset RCpath = "revenue_RC.cfm?Campus="&authUser["CHART"][1]&"&RC="&authUser["PROJECTOR_RC"][1]>
			<a href="#RCpath#">RC Page</a><span> -- </span>
			<a href="revenue_University.cfm">University Page</a>
		</p>
		<h3>#urlCampus# Campus Summary</h3>		

			<cfform action="revenue_Campus.cfm">
				<div class="controlBar">
					<div class="controlBinTL">
						<input id="usersBtn" type="submit" name="usersBtn" class="usersBtn" value="Update Users" onclick="showUsers()">
						<input id="subAcctBtn" type="submit" name="subAcctBtn" class="usersBtn" value="Update Sub Accounts">
				    </div>
				    <!-- End controlBinTL -->
				    
					<div class="controlBinTLC">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel">
				    </div>
				    <!-- End controlBinTLC -->
					
					<div class="controlBinTC">
						<cfif application.reportBtnEnabled>
							<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate #application.rateStatus# Report" <cfif !dssIsOpen >disabled</cfif> /> 
							<!---<br><span class="sm-blue"><i>Available only when IUIE is open</i></span>--->
						<cfelse>
							<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate #application.rateStatus# Report" />
						</cfif>
					</div>
					<!-- End div controlBinTC --> 

					<div class="controlBinTRC">
						<input id="uirrBtn" type="submit" name="uirrBtn" class="reportBtn" value="Credit Hours Used in Budget"> <br><a href="CH_Projector_Crosswalk.xlsx">Credit Hour Projector Crosswalk</a>
					</div>
					<!-- End div controlBinTRC --> 
				</div>
				<cfif ListFindNoCase(REQUEST.campusFOusernames,authUser.username) OR ListFindNoCase(REQUEST.adminUsernames, authUser.username)>
					<p>Here are the running totals for each RC based on the credit hours they have entered so far. ACP, G901, and Banded hours are excluded. Revenue totals are rounded to the nearest dollar.</p>
					<table class="feeCodeTable">
						<thead>
							<tr>
								<th>RC</th>
								<th>RC Name</th>
								<th>FL CrHrs</th>
							<cfif urlCampus eq "BL" or urlCampus eq "IN">
								<th>WN CrHrs</th>
							</cfif>
								<th>SP CrHrs</th>
								<th>SS1 CrHrs</th>
								<th>SS2 CrHrs</th>
								<th>Total RC Projected Credit Hours #application.secondyear#</th>
								<th>Total #application.secondyear# Estimated Revenue</th>
							</tr>
						</thead>
						<tbody>
							<cfset marker = "start">
							<cfloop query="distinctRCs">
								<tr>
									<td>#ACTIVE_RC#</td>
									<td>#RC_NM#</td>
									<td>#NumberFormat(subTots[active_rc].FL,'999,999.9')#</td>
									<cfif urlCampus eq "BL" or urlCampus eq "IN">
										<td>#NumberFormat(subTots[active_rc].WN,'999,999.9')#</td>
									</cfif>
									<td>#NumberFormat(subTots[active_rc].SP,'999,999.9')#</td>
									<td>#NumberFormat(subTots[active_rc].SS1,'999,999.9')#</td>
									<td>#NumberFormat(subTots[active_rc].SS2,'999,999.9')#</td>
									<td>#NumberFormat(subTots[active_rc].RCSUBTOT,'999,999.9')#</td>

									<td>
										<cfif application.budget_year eq 'YR1'>
											$ #NumberFormat(rcRevTots[active_rc].ESTREV_YR1)#
										<cfelse>
											$ #NumberFormat(rcRevTots[active_rc].ESTREV_YR2)#
										</cfif>
									</td>
								</tr>
							</cfloop>
							<tr>
								<td></td>
								<td>CAMPUS<br>SESSION CRHR TOTALS</b></td>
								<td>#NumberFormat(sesnTots.FL,'999,999.9')#</b></td>
							<cfif urlCampus eq "BL" or urlCampus eq "IN">
								<td>#NumberFormat(sesnTots.WN,'999,999.9')#</b></td>
							</cfif>
								<td>#NumberFormat(sesnTots.SP,'999,999.9')#</b></td>
								<td>#NumberFormat(sesnTots.SS1,'999,999.9')#</b></td>
								<td>#NumberFormat(sesnTots.SS2,'999,999.9')#</b></td>
								<td>#NumberFormat(sesnTots.CAMPTOT,'999,999.9')#</b></td>
								<td></b></td>
							</tr>
							<tr>
								<td></td>
								<td>CAMPUS<br>SESSION REVENUE TOTALS</b></td>	
								<td>#DollarFormat(ROUND(sesnRevTots.FL))#</b></td>
							<cfif urlCampus eq "BL" or urlCampus eq "IN">
								<td>$ #NumberFormat(sesnRevTots.WN)#</b></td>
							</cfif>
								<td>$ #NumberFormat(sesnRevTots.SP)#</b></td>
								<td>$ #NumberFormat(sesnRevTots.SS1)#</b></td>
								<td>$ #NumberFormat(sesnRevTots.SS2)#</b></td>
								<td></td>
								<td>$ #NumberFormat(sesnRevTots.CAMPTOT)#</b></td>
							</tr>
						</tbody>
					</table>
				<cfelse>
					<p>Please contact the Budget Office for permission to view this page.</p>
				</cfif>
			</cfform>
	</div>  <!-- End of div CONTENT -->
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">

