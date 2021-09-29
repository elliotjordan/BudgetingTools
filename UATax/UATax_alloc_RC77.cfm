<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
<cfset UATax_alloc = getUATax_allocByUnit('77') />
<cfset rc77details = getRC77details() />

<cfoutput>
<div class="full_content">
<!--- Base Items --->
	<h2>RC77 Transfers - FY2020</h2>

	<table id="uaTaxRC77detail" class="summaryTable">
		<colgroup>
			<col class="narrow"><col class="wide"><col class="medium"><col class="wide"><col class="medium"><col class="petite"><col class="wide"><col class="medium">
		</colgroup>
		<thead>
			<tr>
				<th class="narrow">RC</th>
				<th class="wide">RC Name</th>
				<th class="medium">Obj Lvl Cd</th>
				<th class="wide">Obj Lvl Name</th>
				<th class="medium">Obj Cd</th>
				<th class="wide">Account Name</th>
				<th class="petite">Account</th>
				<th class="medium">Total</th>
			</tr>
		</thead>
		<tbody>
				<cfif rc77details.recordCount eq 0>
					<tr>
						<td colspan="100%" style="border:1px solid black">No records found.</td>
					</tr
				</cfif>
				<cfloop query="#rc77details#">
					<tr>
						<td class="narrow">#RC_CD#</td>
						<td class="wide"><span class="tiny-black">#RC_NM#</span></td>
						<td class="expense_red medium">#FIN_OBJ_LEVEL_CD#</td>
						<td class="expense_red wide">#FIN_OBJ_LEVEL_NM#</td>
						<td class="expense_red medium">#FIN_OBJECT_CD#</td>
						<td class="expense_red petite">#ACCOUNT_NBR#</td>
						<td class="expense_red wide">#ACCOUNT_NM#</td>
						<td class="expense_red medium">#NumberFormat(SUM)#</td>
					</tr>
				</cfloop>
		</tbody>
	</table>
</div>   <!-- End div class full_content  -->
</cfoutput>
</cfif>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">