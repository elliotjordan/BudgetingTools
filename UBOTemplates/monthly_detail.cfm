<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/UBO_template_functions.cfm">

<a href="index.cfm">Return to UBO Templates page</a><br>

<cfif StructKeyExists(form,"templateselect")>
	<cfswitch expression="#form.templateselect#">
		<cfcase value="1"></cfcase>
		<cfcase value="2"><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfcase>
		<cfcase value="3"><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfcase>
		<cfdefaultcase><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfdefaultcase>
	</cfswitch>
</cfif>

<!--- **************************  --->
<cfset objCdData = getObjCdTotals() /> 


	<cfset acctDetails = getAcctCOAdetails() />
	
	<cfdump var="#acctDetails#" >


<cfoutput>
	<div class="full_content">
        <h2>Monthly GL Detail Report</h2>
		<form action="generateMonthly.cfm" id="monthlyRequestForm" method="post">
			<table class="summaryTable">
				<thead>
					<tr>
						<th>Include</th>
						<th>Obj Cd</th>
						<th>Obj Cd Name</th>
						<th>Account</th>
						<th>Sum by Obj Cd</th>
						<th>Earliest Transaction Date Found</th>
						<th>Latest Transaction Date Found</th>
					</tr>
				</thead>
				<tbody>
					
						<cfif objCdData.recordCount eq 0>
							<tr>
								<td colspan="100%" style="border:1px solid black">No data were found for this report.</td>
							</tr
						</cfif>
						<cfloop query="#objCdData#">
								<tr>
									<td><input name="objCdChoice" type="checkbox" value="#FIN_OBJECT_CD#" /></td>
									<td>#FIN_OBJECT_CD#</td>
									<td>#FIN_OBJ_CD_SHRT_NM#</td>
									<td>#ACCOUNT_NBR# - #ACCOUNT_NM#
									<td>#TOTAL_BY_OBJ_CD#</td>
									<td>#DATETIMEFORMAT(EARLIEST_TRSXN_DT,"mmm d, yyyy h:mm TT")#</td>
									<td>#DATETIMEFORMAT(LATEST_TRSXN_DT,"mmm d, yyyy h:mm TT")#</td>
								</tr>
						</cfloop>
	
				</tbody>
			</table>
			<input name="monthlySubmitBtn" type="Submit" value="Get Monthly Report" />	
		</form>
	</div>    <!-- End class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">
