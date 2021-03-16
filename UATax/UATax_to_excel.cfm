 	<!--- Using cfcontent to do a quick and dirty spreadsheet from the data content.  Modify the data content, not this output code, if you want a more restricted sheet. --->  
		<cfset currentUser = getUATaxUser(REQUEST.AuthUser) />
   		<cfset UATaxData = getUATax_data(#currentUser.PROJECTOR_RC#) />
   		<cfif IsDefined("UATaxData") AND UATaxData.recordcount GT 0>
			<cfset sheet = setupUATaxExcelSheet() />	
			<cfset SpreadsheetAddRows(sheet, UATaxData)>
			<!--- header --->
			<cfheader name="Content-Disposition" value="attachment; filename='UA_Tax_data'">   <!--- Workbook name is set here, sheet name is set in function --->
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
			<cfoutput> 
			    <table cols="5"> 
			    	<cfloop query="#UATaxData#">
						<tr> 
							<td>#UATaxData.REQ_ID#</td>
							<td>#UATaxData.RC_CD#</td>
							<td>#UATaxData.RC_NM#</td>
							<td>#UATaxData.ACCOUNT_NBR#</td>
							<td>#UATaxData.PRIOR_REQ_AMT#</td>
							<td>#UATaxData.PRIOR_APPR_BASErrent#</td>
							<td>#UATaxData.PRIOR_APPR_CASH#</td>
							<td>#UATaxData.JUSTIFICATION#</td>
							<td>#UATaxData.REQ_STATUS#</td>
							<td>#UATaxData.SPECIAL_TITLE#</td>
							<td></td>
			            </tr>
					</cfloop>
			    </table> 
			</cfoutput>
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
		<cfabort />
