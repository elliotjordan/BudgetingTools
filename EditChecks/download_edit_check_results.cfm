<!--- partial for the edit check results generated in edit_checks.cfm --->

		<cfif IsDefined("POV_org_result") AND POV_org_result.recordcount GT 0>
			<cfset sheet = setup_Edit_Check_Excel() />	
			
			<!--- We dont' want to just add each row as it comes.  We want to do some indenting other data formatting. --->
			<!-- Loop through the result which is already sorted by Position number, then account number. -->
			<cfset pos_nbr_tracker = "">
			<cfloop query="POV_org_result">
				<!-- Set up a new row for our next line of data -->
					<cfset freshSubTotalRow = ' , , , , , , ,                    SUB-TOTAL:,$ XXX, , , , , '>
					<cfset subTotal = 0>
				<!-- check whether this is the first time we've seen this position number  -->
					<!-- If new Position number  -->
					<cfif pos_nbr_tracker neq #POSITION_NBR#>
						<!-- If we have a sub-total row from prior position number, put it in now -->
						<!---<cfif freshSubTotalRow neq ""><cfset SpreadsheetAddRow(sheet, freshRow)></cfif>--->
						<cfset pos_nbr_tracker = #POSITION_NBR#>
						<cfset subTotal = #subTotal# + #POS_FTE#>
						
						<!-- format the line to be white and the position number to be flush left -->
						<cfset positionRow = 'Posn: #POSITION_NBR#,#POS_FTE#, , , , , , , , , , , , '>
						<!-- display position number with its FTE in a row by itself  -->
							<cfset SpreadsheetAddRow(sheet, positionRow)>
						<!-- Now add the rest of the information in this data result line in a fresh row -->
						<cfset dataRow = '     #FIN_COA_CD# #ACCOUNT_NBR#, #APPT_RQST_FTE_QTY#, ,ID: #EMPLID#, #FIN_COA_CD#, #FIN_OBJECT_CD#, #FIN_SUB_OBJ_CD#, #PERSON_NM#,	#POS_FTE#, #RC_CD#, #RPTS_TO_FIN_COA_CD#, #RPTS_TO_ORG_CD#, #SUB_ACCT_NBR#'>
						<!-- Flush right, with account number instead of position number in column 1  -->
							<cfset SpreadsheetAddRow(sheet, dataRow)>							
					<!-- else  -->
					<cfelse>
						<cfset subTotal = #subTotal# + #POS_FTE#>
						<!-- format the line to be alternating gray and white from here on out until we get a new position number  -->
						<!-- Show a regular line with account number in column 1 instead of position number -->
						<cfset dataRow = '     #FIN_COA_CD# #ACCOUNT_NBR#, , ,ID: #EMPLID#, #FIN_COA_CD#, #FIN_OBJECT_CD#, #FIN_SUB_OBJ_CD#, #PERSON_NM#,	#POS_FTE#, #RC_CD#, #RPTS_TO_FIN_COA_CD#, #RPTS_TO_ORG_CD#, #SUB_ACCT_NBR#, #UNIV_FISCAL_YR#'>
						<cfset SpreadsheetAddRow(sheet, dataRow)>
						<!-- Update the sub-total row while we have the latest data row. -->
						<!-- create a fresh sub-total row for this new position number - don't show it yet.  Give it a pretty underline  -->
						
						<cfset SpreadsheetAddRow(sheet, freshSubTotalRow)>
					<!--  End if  -->
						</cfif>
			</cfloop>
			<!--- Below is a generic dump straight to the spreadsheet without any nice formatting like above  
			<cfset sheet2 = setup_Edit_Check_Excel() />
			<cfset SpreadsheetAddRows(sheet2, POV_org_result)> --->
			<!--- header --->
			<cfheader name="Content-Disposition" value="attachment; filename=Position_FTE_Less_Than_Funding_FTE_Sum_Across_Charts_(06)">   <!--- Workbook name is set here, sheet name is set in function --->
			<cfcontent type="application/vnd.ms-excel" variable="#SpreadSheetReadBinary(sheet)#">
		<cfelse>
			<h3>Lucky you! All your edit checks passed.</h3>
   		</cfif>
		<cfabort />