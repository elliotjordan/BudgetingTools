 	<!--- Using cfcontent to do a quick and dirty spreadsheet from the data content.  Modify the data content, not this output code, if you want a more restricted sheet. --->  
	<cfsetting enablecfoutputonly="Yes">
	<cfoutput> 
   		<cfif IsDefined("ExcelSelect") AND ExcelSelect.recordcount GT 0>
			<cfset sheet = setupRevenueTemplate() />	
			<cfset SpreadsheetAddRows(sheet, ExcelSelect)>
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfheader name="Content-Disposition" value="inline; filename=#application.secondyear#_Credit_Hour_Revenue_Projection_Worksheet.xls">   
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
	</cfoutput>