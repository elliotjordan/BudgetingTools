<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfset ass_list = getCampusAssessments() />

<cfoutput>
<div class="full_content">
<!--- Base Items --->
	<h2>Campus Assessment Summary</h2>
<!---   fyear, assmt_amt, assmt_delta, delta_pct, recipient, assmt_desc   --->
<table id="uaAssSumTable" class="summaryTable">
		<thead>
			<tr>
				<th class="narrow">FY</th>
				<th class="narrow">Assessment amount</th>
				<th class="medium">Recipient</th>
				<th class="wide">Description</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="ass_list">
			<tr>
				<td>#fyear#</td>
				<td>$#numberFormat(assmt_amt,'999,999,999')#</td>
				<td>
					<cfset targetString = "UATax_campus_assessments_detail.cfm?assmtID=#assmtID#" />
					<a href="#targetString#">#recipient#</a></td>
				<td>#assmt_desc#</td>
			</tr>
			</cfloop>

		</tbody>
	</table>
</div>  <!-- End div class="full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">