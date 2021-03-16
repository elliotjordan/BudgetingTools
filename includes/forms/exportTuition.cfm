<!--- Using cfcontent to do a quick and dirty spreadsheet from the data content.  Modify the data content, not this output code, if you want a more restricted sheet. --->  
<cfsetting enablecfoutputonly="Yes"> 

<cfif IsDefined("tuitionData") AND tuitionData.recordcount GT 0>
	<cfset sheet = setupTuitionTemplate() />	
	<cfset SpreadsheetAddRows(sheet, tuitionData)>
	<!--- header --->
	<cfheader name="Content-Disposition" value="attachment; filename=#application.excelTemplateName#">   <!--- Workbook name is set here, sheet name is set in function --->
	<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
	<cfoutput> 
	    <table cols="5"> 
	    	<cfloop query="#tuitionData#">
				<tr> 
					<td>#tuitionData.fee_inst#</td>
					<td>#tuitionData.fee_descr#</td>
					<td>#tuitionData.fee_type#</td>
					<cfif session.access_level eq 'bduser'>
						<td>#tuitionData.categ#</td>
						<td>#tuitionData.fee_setByCampusIndicator#</td>
					</cfif>
					<td>#tuitionData.fee_current#</td>
					<td>#tuitionData.fee_lowyear#</td>
					<td>#tuitionData.fee_highyear#</td>
	            </tr>
			</cfloop>
	    </table> 
	</cfoutput>
<cfelse>
	<h3>We are sorry, but no tuition records were returned.</h3>
</cfif>
<cfabort />
