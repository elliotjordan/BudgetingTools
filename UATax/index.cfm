<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfset guidelineTotals = getGuidelines() />
<cfset guideline2021Totals = get2021Guidelines('FY2021') />
<!---<cfdump var="#guidelineTotals#" >--->
<cfoutput>
	<div class="full_content">

		<h2>2020-21 University Support - Campus Guidelines</h2>
<!--- begin dev area  --->

<cfset guideStruct = getGuidelineTotal("2019") />
<!---<cfif FindNoCase(REQUEST.authUser,REQUEST.developerUsernames)>
	<cfdump var="#guideStruct#" >
</cfif>--->
<!--- end dev area  --->
		<p>Here is the path to the source document:  \\bl-budu-haygate\usegrps\1920xls\B\University Tax\B7940sum_2021 FINAL.xlsx</p>

		<table id="guidelineTable" class="summaryTable">
			<thead>
				<tr>
					<th class="narrow"></th>
					<th class="petite" colspan="3">Accounting String</th>
					<th class="medium"></th>
					<th class="wider" colspan="9">Campus Distrubution</th>
					<th class="narrow"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td></td>
					<td>Account ##</b></td>
					<td>Object Code</b></td>
					<td>Sub Obj Code</b></td>
					<td>Description</b></td>
					<td>UA Aux</b></td>
					<td>Blgtn</b></td>
					<td>IUPUI</b></td>
					<td>IUSM</b></td>
					<td>East</b></td>
					<td>Kokomo</b></td>
					<td>Northwest</b></td>
					<td>South Bend</b></td>
					<td>Southeast</b></td>
					<td>Total</b></td>
				</tr>
<!--- begin 2021 --->
			<cfloop query="guideline2021Totals">
			<!--- FYEAR,,LINE_TYPE,,,,,,,,,,,,,SORT_ORDER --->
				<tr>
					<td>#LINE_ITEM#</b></td>
					<td>#ACCOUNT_NBR#</td>
					<td>#OBJ_CD#</td>
					<td>#SUB_OBJ#</td>
					<td class="narrow">
						<cfif FindNoCase('total',LINE_TYPE)>#LINE_TITLE#</b>
						<cfelse><a href="UATax_adjBase.cfm?fin_sub_obj_cd=#SUB_OBJ#">#LINE_TITLE#</a></cfif>
					</td>
					<td class="medium">#NumberFormat(UA_AUX)#</td>
					<td class="medium">#NumberFormat(IUBLA)#</td>
					<td class="medium">#NumberFormat(IUPUI)#</td>
					<td>#NumberFormat(IUSOM)#</td>
					<td>#NumberFormat(IUEAA)#</td>
					<td>#NumberFormat(IUKOA)#</td>
					<td>#NumberFormat(IUNWA)#</td>
					<td>#NumberFormat(IUSBA)#</td>
					<td>#NumberFormat(IUSEA)#</td>
					<td>#NumberFormat(LINE_TOTAL)#</td>
				</tr>
			</cfloop>

<!---					<cfif guidelineTotals.recordCount eq 0>
						<tr>
							<td style="border:1px solid black">No records available to review.</td><td></td><td></td><td></td><td></td><td></td><td></td>
						</tr
					<cfelse>
						<cfloop query="#guidelineTotals#">
							<tr>
								<td class="narrow">#FY#</td>
								<td class="wide">#ACCOUNT_NBR#</td>
								<td>#FIN_OBJECT_CD#</td>
								<td>#sub_obj_grouping_cd#</td>
								<td>#fin_subobj_group_nm#</td>
								<td>#NumberFormat(BB_SUM)#</td>
							</tr>
						</cfloop>
					</cfif>--->
			</tbody>
		</table>
	</div>  <!-- End div class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
