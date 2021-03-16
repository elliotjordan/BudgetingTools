<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfset authUser = getUser(REQUEST.authuser)>
<cfparam name="getCampus" type="string" default="" >
<cfparam name="urlCampus" type="string" default="">
<cfparam name="UrlRC" type="string" default="">
<cfparam name="DataSelect" type="query" default="#QueryNew('ID','integer')#">
<cfset urlCampus = authUser['chart'][1]>
<cfset campusTargets = getAllCampusTargets(urlCampus) />
<cfset campusEstRev = getAllRC_EstRev(urlCampus) />
<cfset campusGrands = getCampusGrandTotals(urlCampus) />

<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>

<cfset urlRC = authUser['projector_RC'][1]>
<cfoutput>
<!--- User has asked for an Excel downoad --->
<cfif IsDefined("form") AND StructKeyExists(form,"usersBtn")>
	<cflocation url="projector_users.cfm" addtoken="false">
<cfelseif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset ExcelSelect = getProjectinatorData(urlCampus,"NONE",application.rateStatus)>
   		<cfif IsDefined("ExcelSelect") AND ExcelSelect.recordcount GT 0>
			<cfset sheet = setupRevenueTemplate() />	
			<cfset SpreadsheetAddRows(sheet, ExcelSelect)>
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfheader name="Content-Disposition" value="inline; filename=FY21_Credit_Hour_Revenue_Projection_Worksheet.xls">   
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
<!--- User has asked for a V1 report. --->
<cfelseif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset reportSelect = getB325_V1_Campus_data(urlCampus, urlRC, false)>
	<!---<cfdump var="#reportSelect#"><cfabort>--->
   		<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
			<!---<cfset s = SpreadsheetNew(true)>--->
			<cfscript>
				V1Template = ExpandPath('templates\B325_StudentFeeRevenueTemplateFY20v1Campusv6distrib.xlsx');
			</cfscript>
			<cfspreadsheet action="read" src = "#V1Template#" headerrow="1" name="jwb">
			<!---<cfspreadsheet action="read" src = "templates\sample.xlsx" sheet="2" headerrow="1" name="jwb">--->
			<cfscript>
				try {
				  SpreadSheetSetActiveSheet(jwb,"RawData");
				  SpreadsheetDeleteRows(jwb,"2-3000");
				  datatype_arr = ["NUMERIC:29-45; STRING:1-28,46-50;"];
				  SpreadsheetAddRows(jwb, reportSelect,2,1,false,datatype_arr);
				  SpreadSheetSetActiveSheet(jwb,"Title");  //this does not solve the "already data etc." error
				  // you must save the template with the focus in the data page or it will "group" the tabs
				//throw(message="Trying...", detail="xyzpdq");
				} catch (any e) {
					WriteOutput("Error generating V1 report: " & e.message);
					rethrow;
				} finally {
					//WriteOutput(" This message should appear no matter what else may happen.");
				}
			</cfscript>   
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfset filenameString = "B325_StudentFeeRevenue_V1_" & urlCampus & "_CampusReport.xlsx">
			<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
			<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(jwb)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
</cfif>

    <!--- Main page  --->
	<div class="full_content">
		<!---<div id="prefs">
			<cfinclude template="preferences.cfm" >
		</div>--->
		
		<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a> <span class="sm-blue"> <i>v3</i></span></h2>
		<p>
			<cfset RCpath = "revenue_RC.cfm?Campus="&authUser["CHART"][1]&"&RC="&authUser["PROJECTOR_RC"][1]>
			<a href="#RCpath#">RC Page</a><span> -- </span><a href="revenue_University.cfm">University Page</a>
		</p>
		<h3>#urlCampus# Campus Summary</h3>		
<!---		
        <div class="statusBar">
			<div class="statusBinTFL">
				<h3>Current Total Campus Projected<br>Credit Hours: <span id="crhrGrand">#NumberFormat(0,'999,999.9')#</span></h3>
			</div>  <!-- End of div statusBinTCL -->
	        
	        <div class="statusBinTCL">
				<h3>Current Total<br>Estimated Revenue: <span id="revGrand">#DollarFormat("0")#</span></h3>
			</div>	<!-- End of div statusBinTCR --> 
		</div>  <!-- End of div statusBar -->   --->
		

			<cfform action="revenue_Campus.cfm">
				<div class="controlBar">
					<div class="controlBinTL">
						<input id="usersBtn" type="submit" name="usersBtn" class="usersBtn" value="Update Users" onclick="showUsers()">
				    </div>
				    <!-- End controlBinTL -->
				    
					<div class="controlBinTLC">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel" disabled>
				    </div>
				    <!-- End controlBinTLC -->
					
					<div class="controlBinTC">
						<cfif application.reportBtnEnabled>
							<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate #application.rateStatus# Report" />
						<cfelse>
							<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate #application.rateStatus# Report" disabled />
						</cfif>
					</div>
					<!-- End div controlBinTC --> 

					<div class="controlBinTRC">
						<input id="uirrBtn" type="submit" name="uirrBtn" class="reportBtn" value="Credit Hours Used in Budget" disabled>
					</div>
					<!-- End div controlBinTRC --> 
				</div>
				<cfif ListFindNoCase(REQUEST.campusFOusernames,authUser.username) OR ListFindNoCase(REQUEST.adminUsernames, authUser.username)>
					<h3>The Campus Summary page and Excel download are temporarily unavailable</h3>
					<p>We are refactoring the data.  This table should be restored by mid-afternoon.  Sorry for the inconvenience.</p>
<!---					<p>Here are the running totals for each RC based on the credit hours they have entered so far (Banded rows not included if you elected to pass your banded rows out to the RCs).</p>
					<table class="feeCodeTable">
						<thead>
							<tr>
								<th>RC</th>
								<th>RC Name</th>
								<th>Session</th>
								<th>Total Campus Projected Credit Hours YR1</th>
								<th>FY20 Estimated Revenue</th>
								<th>Total Campus Projected Credit Hours YR2</th>
								<th>FY21 Estimated Revenue</th>
							</tr>
						</thead>
						<tbody>
							<cfset marker = "start">
							<cfloop query="campusEstRev">
								<tr>
									<td>#RC_CD#</td>
									<td>#RC_NM#</td>
									<td>#campusEstRev.SESN#</td>
									<td>#NumberFormat(PROJHRS_TOTAL_YR1,'999,999.9')#</td>
									<td>#DollarFormat(ESTREV_YR1)#</td>
									<td>#NumberFormat(PROJHRS_TOTAL_YR2,'999,999.9')#</td>
									<td>#DollarFormat(ESTREV_YR2)#</td>
								</tr>
							</cfloop>
							<cfloop query="campusGrands">
							<tr>
								<td></td>
								<td>CAMPUS<br>SESSION TOTAL:</b></td>
								<td>#campusGrands.SESN#</b></td>
								<td>#NumberFormat(campusGrands.PROJHRS_GRAND_YR1,'999,999.9')#</b></td>
								<td>#DollarFormat(campusGrands.ESTREV_GRAND_YR1)#</b></td>
								<td>#NumberFormat(campusGrands.PROJHRS_GRAND_YR2,'999,999.9')#</b></td>
								<td>#DollarFormat(campusGrands.ESTREV_GRAND_YR2)#</b></td>
							</tr>
							</cfloop>
							<input id="ph_grand_yr1" type="hidden" value="#campusGrands.PROJHRS_GRAND_YR1#">
							<input id="er_grand_yr1" type="hidden" value="#campusGrands.ESTREV_GRAND_YR1#">
							<input id="ph_grand_yr2" type="hidden" value="#campusGrands.PROJHRS_GRAND_YR2#">
							<input id="er_grand_yr2" type="hidden" value="#campusGrands.ESTREV_GRAND_YR2#">
						</tbody>
					</table>
--->

				<cfelse>
					<p>Please contact the Budget Office for permission to view this page.</p>
				</cfif>
			</cfform>
	</div>  <!-- End of div CONTENT -->
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">

