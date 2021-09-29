<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
<cfset assessmentList = getAssessments() />
<!---<cfdump var="#assessmentList#" >--->
<cfset adjBaseTotals = getAdjBaseTotals() />
<cfoutput>
	<div class="full_content">
		<h2>Assessment Methods</h2>
		<p>Below are the various allocation methods used over the years.  We have given them "names" for convenience in discussing them.</p>
		<table id="uaTaxAssessmentTable" class="summaryTable">
			<thead>
				<tr>
					<th class="narrow">ID</th>
					<th class="medium">ALLOC TITLE</th>
					<th class="wide">ALLOC UNIT</th>
					<th class="medium">DIST AMT</th>
					<th class="medium">DIST SUBOBJ CD<br>GA</th>
					<th class="medium">CATEGORY</th>
					<th class="medium">B0865_UA ID</th>
				</tr>
			</thead>
			<tbody>
					<cfif adjBaseTotals.recordCount eq 0>
						<tr>
							<td style="border:1px solid black">No records available to review.</td><td></td><td></td><td></td><td></td><td></td><td></td>
						</tr
					<cfelse>
						<cfloop query="#assessmentList#">
							<tr>
								<td class="narrow">#ID#</td>
								<td class="medium">#ALLOC_TITLE#</td>
								<td class="wide">#ALLOC_UNIT#</td>
								<td>#DISTRIBUTION_AMT#</td>
								<td>#DIST_SUB_OBJ_CD#</td>
								<td>#TAX_INC_CATEGORY#</td>
								<td>#B0865UA_ID#</td>
							</tr>
						</cfloop>
					</cfif>
			</tbody>
		</table>
	</div>  <!-- End div class "full_content" -->
</cfoutput>
</cfif>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
