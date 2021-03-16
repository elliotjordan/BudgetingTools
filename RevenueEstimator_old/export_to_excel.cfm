<!--- 
	file:	export_to_excel.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	11-14-17
	update:	
	note:	Delivers data as Excel worksheet. 
 --->
 	<!--- Using cfcontent to do a quick and dirty spreadsheet from the data content.  Modify the data content, not this output code, if you want a more restricted sheet. --->  
   		<cfsetting enablecfoutputonly="Yes"> 
   		<cfset projectorData = getProjectorData(#session.access_level#,#UrlCampus#,#UrlRC#) />
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
