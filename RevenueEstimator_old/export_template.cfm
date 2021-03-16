<!--- 
	file:	export_template.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	11-14-17
	update:	
	note:	Template downloads deliver a standard B7815-style Excel worksheet. 
 --->
 	<!--- Using cfcontent to do a quick and dirty spreadsheet from the data content.  Modify the data content, not this output code, if you want a more restricted sheet. --->  
	<!--- TODO: Change this section to deliver the appropriate B7815 submission template from the filesystem. --->	
   		<cfsetting enablecfoutputonly="Yes"> 
   		<cfset resortedFeeCodes = getFeesByUserID(#session.access_level#) />
   		<cfif IsDefined("resortedFeeCodes") AND resortedFeeCodes.recordcount GT 0>
			<cfset sheet = setupExcelTemplate() />	
			<cfset SpreadsheetAddRows(sheet, resortedFeeCodes)>
			<!--- header --->
			<cfheader name="Content-Disposition" value="attachment; filename=#application.excelTemplateName#">   <!--- Workbook name is set here, sheet name is set in function --->
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
			<cfoutput> 
			    <table cols="5"> 
			    	<cfloop query="#resortedFeeCodes#">
						<tr> 
							<td>#resortedFeeCodes.fee_inst#</td>
							<td>#resortedFeeCodes.fee_descr#</td>
							<td>#resortedFeeCodes.fee_type#</td>
							<cfif session.access_level eq 'bduser'>
								<td>#resortedFeeCodes.categ#</td>
								<td>#resortedFeeCodes.fee_setByCampusIndicator#</td>
							</cfif>
							<td>#resortedFeeCodes.fee_current#</td>
							<td>#resortedFeeCodes.fee_lowyear#</td>
							<td>#resortedFeeCodes.fee_highyear#</td>
			            </tr>
					</cfloop>
			    </table> 
			</cfoutput>
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
		<cfabort />
