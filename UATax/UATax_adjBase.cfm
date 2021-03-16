<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfset filter = "NO" />
<cfif IsDefined("url") and StructKeyExists(url,"fin_sub_obj_cd")>
	<cfset adjBaseTotals = getAdjBase_supportingLines(url.fin_sub_obj_cd) />
	<cfset filter = url.fin_sub_obj_cd />
<cfelse>
	<cfset adjBaseTotals = getAdjBase_supportingLines() />
</cfif>
<cfoutput>
	<div class="full_content">
		<h2>Adjusted Base Lines <cfif filter neq 'NO'>from Sub Object #filter#</cfif></h2>
		<p>Source document:  \\bl-budu-haygate\usegrps\1920xls\B\University Tax\B7940sum_2021 FINAL.xlsx - base adj w rebase</p>
		<table id="uaTaxAdjBaseTable" class="summaryTable">
			<thead>
				<tr>
					<th class="medium">FY</th>
					<th class="wide">Description</th>
					<th class="medium">Sub Object</th>
					<th class="medium">UA<br>Aux</th>
					<th class="medium">Bloomington</th>
					<th class="medium">IUPUI</th>
					<th class="medium">IUSM</th>
					<th class="medium">East</th>
					<th class="medium">Kokomo</th>
					<th class="medium">Northwest</th>
					<th class="medium">South<br>Bend</th>
					<th class="medium">Southeast</th>
					<th class="wide">Note</th>
				</tr>
			</thead>
			<tbody>
					<cfif adjBaseTotals.recordCount eq 0>
						<tr>
							<td style="border:1px solid black" colspan="16">No records available to review.</td><td></td><td></td><td></td><td></td><td></td><td></td>
						</tr
					<cfelse>
						<cfloop query="#adjBaseTotals#">
							<tr>
								<!---<td class="narrow">#SRC_LINE_NBR#<br>
									<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
										<a href="UATax_historyEdit.cfm?ln=#src_line_nbr#">edit</a>
									</cfif>
								</td>

		fyear, line_item, line_type, sub_obj, line_title, ua_aux, iubla, iuina, iusom, iueaa, iukoa, iunwa, iusba, iusea, sort_order, allocation, line_notes
								--->
								<td class="medium">#fyear#</td>
								<td class="wide">#line_title#</td>
								<td class="narrow">#sub_obj#</td>
								<td>#NumberFormat(ua_aux)#</td>
								<td>#NumberFormat(iubla)#</td>
								<td>#NumberFormat(iuina)#</td>
								<td>#NumberFormat(iusom)#</td>
								<td>#NumberFormat(iueaa)#</td>
								<td>#NumberFormat(iukoa)#</td>
								<td>#NumberFormat(iunwa)#</td>
								<td>#NumberFormat(iusba)#</td>
								<td>#NumberFormat(iusea)#</td>
								<td>#line_notes#</td>
							</tr>
						</cfloop>
					</cfif>
			</tbody>
		</table>
	</div>  <!-- End div class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
