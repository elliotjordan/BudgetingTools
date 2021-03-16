<cfoutput>
			<table id="uaTaxHistoryTable" class="summaryTable">
				<!---<thead class="header" id="tableHeader">--->   <!--- Sticky  header, still under development  --->
				<thead>
					<tr>
						<th class="narrow">Line Nbr</th>
						<th class="medium">Item Cat</th>
						<th class="medium">Sub Cat</th>
						<th id="wide" class="wide">Unit</th>
						<th class="medium">FY</th>
						<th id="wide" class="wide">Item Desc</th>
						<th class="medium">UA Svc Charge</th>
						<th class="medium">UA Aux</th>
						<th class="medium">BL</th>
						<th class="medium">IN GA</th>
						<th class="medium">IN SOM</th>
						<th class="medium">EA</th>
						<th class="medium">KO</th>
						<th class="medium">NW</th>
						<th class="medium">SB</th>
						<th class="medium">SE</th>
						<th class="medium">Total</th>
						<th id="wide" class="wide">Note</th>
					</tr>
				</thead>
				<tbody>
						<cfif UATax_history.recordCount eq 0>
							<tr>
								<td style="border:1px solid black">No records available to review.</td><td></td><td></td><td></td><td></td><td></td><td></td>
							</tr
						<cfelse>				
							<cfloop query="#UATax_history#">
								<cfif StructKeyExists(url,"ln") and LEN(url.ln) gt 0 and (url.ln) eq src_line_nbr>
									<tr class="highlight">
								<cfelse>
									<tr>
								</cfif>
									<td class="petite">
										<cfset offset = #src_line_nbr# + 5>
										<cfset anchor = 'line' & #offset#><a id="anchor" name="#anchor#"></a>#SRC_LINE_NBR#<br>
										<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
											<a href="UATax_historyEdit.cfm?ln=#src_line_nbr#">edit</a>
										</cfif>
									</td>
									<td>#ITEM_CAT#</td>
									<td>#SUB_CAT#</td>
									<td>#UNIT#</td>
									<td>#FY#</td>
									<td>#ITEM_DESC#</td>
									<td>#NumberFormat(UA_SVC_CHARGE)#</td>
									<td>#NumberFormat(UA_AUX)#</td>
									<td>#NumberFormat(BLOOMINGTON)#</td>
									<td>#NumberFormat(IUPUI_GA)#</td>
									<td>#NumberFormat(IUPUI_SOM)#</td>
									<td>#NumberFormat(EAST)#</td>
									<td>#NumberFormat(KOKOMO)#</td>
									<td>#NumberFormat(NORTHWEST)#</td>
									<td>#NumberFormat(SOUTH_BEND)#</td>
									<td>#NumberFormat(SOUTHEAST)#</td>
									<td>#NumberFormat(TOTAL)#</td>
									<td>#NOTE#</td>
								</tr>
							</cfloop>
						</cfif>
				</tbody>
			</table>
</cfoutput>