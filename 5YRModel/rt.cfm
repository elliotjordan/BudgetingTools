<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput>
<div class="full_content">
	<h2>Running Totals Sandbox</h2>
	<p>Testing...</p>
		<cfset compDetails = getCompDetails('BL') />
		<p>
			<cfdump var="#compDetails.ln2_cd#" >
		</p>
		<cfset fundTypes = getFundTypes() />  
		<cfloop query="fundTypes" >
			<cfif grp1_cd gt 0>
				<cfset campusInfo = getFYMdataByFnd(current_inst, grp1_cd) />
				  <!--- Expense main rows  --->
				  <cfloop query="#campusInfo#">
				  	<cfif grp1_desc neq 'PARAM' and grp2_cd eq 2>
						<cfloop query="#compDetails#">
							<cfif #compDetails.ln2_cd# eq #campusInfo.ln2_cd#>
								#campusInfo.OID# #compDetails.ln2_cd# - #compDetails.yr1_new#<br>
							<cfset rt1 = NumberFormat((LSParseNumber(compDetails.yr1_new) + LSParseNumber(campusInfo.yr1_new)),'999,999,999') />
								Running total: #rt1#<br>
								--<br>
							</cfif>
						</cfloop>
					</cfif>
				  </cfloop>
			</cfif>
		</cfloop>
		<cfset rt = StructNew() />
		
</div>
</cfoutput>

