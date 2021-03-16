<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" >
<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<cfif IsDefined("form") AND StructKeyExists(form,"submitExcel")>
	<cfsetting enablecfoutputonly="Yes">
	<cfset NonInstFeesSelect = getFeeData_forExcel()>
	<cfset CampusFeesSelect = getCampusFeeData_forExcel()>
	<cfset AllFeeSelect = getAllFeeData_forExcel()>

   		<cfif IsDefined("NonInstFeesSelect") AND NonInstFeesSelect.recordcount GT 0>
			<cfset sheet = setupAllFeesTemplate() />
			<cfset SpreadsheetAddRows(sheet, NonInstFeesSelect)>
			<cfset SpreadsheetSetActiveSheetNumber(sheet,2)>
			<cfset SpreadsheetAddRows(sheet, CampusFeesSelect)>
			<cfset SpreadsheetSetActiveSheetNumber(sheet,3)>
			<cfset SpreadsheetAddRows(sheet, AllFeeSelect)>
			<cfset SpreadsheetSetActiveSheetNumber(sheet,1)>
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfheader name="Content-Disposition" value="inline; filename=ALL_FEES_MASTER_V9.xlsx">
			<!---<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">--->
			<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
<cfelseif IsDefined("form") AND StructKeyExists(form,"submitMaster")>
		<cfset MasterFeesSelect = getMasterList_forExcel()>
   		<cfif IsDefined("MasterFeesSelect") AND MasterFeesSelect.recordcount GT 0>
			<cfset sheet = setupMasterFeesTemplate() />
			<cfset SpreadsheetAddRows(sheet, MasterFeesSelect)>
			<cfset SpreadsheetSetActiveSheetNumber(sheet,1)>
			<cfset SpreadSheetAddAutoFilter(sheet,"A3:X3")>
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfheader name="Content-Disposition" value="inline; filename=ALL_FEES_MASTER.xlsx">
			<!---<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">--->
			<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>We are sorry, but the Master List download is broken.  Please contact UBO and let them know.</h3>
   		</cfif>
<cfelse>
	<h2>Uh-oh</h2>
	<p>Something is really broken.  Contact John Burgoon jburgoon@indiana.edu and let him know this thing is wonky.  Thanks! </p>
</cfif>

