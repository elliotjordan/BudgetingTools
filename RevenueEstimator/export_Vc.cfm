<!--- NOTE!!!!! This page is a partial to be included, but is not currently called anywhere in the code  --->

<cfinclude template="../../includes/report_functions.cfm" />
<cfif IsDefined("form.dwnldVcBtn")>  
		<cfset currentUser = getReportUser(REQUEST.AuthUser) />
   		<cfset VcData = getVcData(#currentUser.PROJECTOR_RC#) />
   		<cfif IsDefined("VcData") AND VcData.recordcount GT 0>
			<cfset sheet = setupUATaxExcelSheet() />	
			<cfset SpreadsheetAddRows(sheet, VcData)>
			<!--- header --->
			<cfheader name="Content-Disposition" value="attachment; filename='VcDataSS.xlsx'">   <!--- Workbook name is set here, sheet name is set in function --->
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
			<cfoutput> 
			    <table cols="5"> 
			    	<cfloop query="#VcData#">
						<tr> 
							<td>#VcData.INST#</td>
							<!---<td>#VcData.RC_CD#</td>
							<td>#VcData.RC_NM#</td>
							<td>#VcData.ACCOUNT_NBR#</td>
							<td>#VcData.PRIOR_REQ_AMT#</td>
							<td>#VcData.PRIOR_APPR_BASErrent#</td>
							<td>#VcData.PRIOR_APPR_CASH#</td>
							<td>#VcData.JUSTIFICATION#</td>
							<td>#VcData.REQ_STATUS#</td>
							<td>#VcData.SPECIAL_TITLE#</td>--->
							<td></td>
			            </tr>
					</cfloop>
			    </table> 
			</cfoutput>
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
   		</cfif>
		<cfabort />
</cfif>