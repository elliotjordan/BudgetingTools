<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/revenue_functions.cfm">
<cfset authUser = getUser(REQUEST.authuser)>
<cfparam name="DataSelect" type="query" default="#QueryNew('ID','integer')#">
<cfset allCampusEstRev = getAllCampus_EstRev() />
<cfset allCampusEstRevByRC = getAllCampus_EstRev_byRC() />
<!---<cfdump var="#authUser.username#">--->
<cfoutput>
<!--- User has asked for a V1 report. --->
<cfif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset reportSelect = getB325_V1_Campus_data("ALL","99",false,"Y")>
   		<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
			<!---<cfset s = spreadsheetNew()>--->	
			<cfspreadsheet action="read" src = "templates\B325_StudentFeeRevenueTemplateFY20v1Campusv6distrib.xlsx" headerrow="1" name="jwb">
			<cfscript>
				SpreadSheetSetActiveSheet(jwb,"RawData");  
				SpreadsheetDeleteRows(jwb,"2-3000");
				datatype_arr = ["NUMERIC:29-45; STRING:1-28,46-50;"];
				SpreadsheetAddRows(jwb, reportSelect,2,1,false,datatype_arr);
				SpreadSheetSetActiveSheet(jwb,"Title"); 
			</cfscript>   
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfset filenameString = "B325_Student_Fee_Revenue_V1_ALL_Campus_Report.xlsx">
			<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
			<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(jwb)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
<cfelseif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>  
	<cfsetting enablecfoutputonly="Yes"> 
	<cfset ExcelSelect = getExcelDownloadData("NONE","NONE","V1") >
   		<cfif IsDefined("ExcelSelect") AND ExcelSelect.recordcount GT 0>
			<cfset sheet = setupRevenueTemplate() />	
			<cfset SpreadsheetAddRows(sheet, ExcelSelect)>
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfheader name="Content-Disposition" value="inline; filename=FY19_Credit_Hour_Revenue_Projection_Worksheet.xlsx">   
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
</cfif>
	<div class="full_content">
		<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a><span class="sm-blue"> <i>v2</i></span></h2>
		<p>
			<a href="revenue_RC.cfm">RC Page</a><span> -- </span><a href="revenue_Campus.cfm">Campus Page</a>
		</p>
			<h3>University Summary</h3>
<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>
<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
		<cfform action="revenue_University.cfm">	
			<div class="controlBar">
				<div class="controlBinTC">
					<input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate V1 Report">
				</div>
				<!-- End div controlBinTR -->
			
				<div class="controlBinTLC">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel">
				</div>
				<!-- End controlBinTLC -->
			</div>
			<p>Here are the running totals for each Campus based on the credit hours they have entered so far.</p>
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
				<tbody>
					<cfloop query="allCampusEstRev">
						<tr>
							<td>#CHART#</td>
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
				</tbody>
			</table>

			<p>Here are the running totals for each Campus broken out by RC.</p>
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
				<tbody>
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
				</tbody>
			</table>
		</cfform>
<cfelse>
	<p>We are sorry but you are not currently authorized to view the campus totals table.  Call UBO and we can add you to the approved user list.  Thank you!</p>
</cfif>
	</div>  <!-- End of div CONTENT -->
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">
