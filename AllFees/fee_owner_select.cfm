
<!---<cfset getCampus = getFeeOwners("IN") />
<cfoutput>
				<div class="controlBar">
					<div class="controlBinTL">
						<label for="FOdropdown">Select Fee Owner</label>
						<select id="FOdropdown" name="FOdropdown" size="1" onchange="setSelectedRC(FOdropdown.value)">
							<option value="">
								--Campus/RC--
							</option>
							<cfloop query="getCampus">  
								<cfif getCampus.rc_cd eq '52' and getCampus.fin_coa_cd eq 'IN'>  <!--- omg what a hack, please don't look at me like that --->
									<option value="IN - 46 - IUPU COLUMBUS" <cfif MID(session.curr_proj_chart,1,2) eq "IN" AND MID(session.access_level,3,2) eq "46">selected</cfif>>IN - 46 - IUPU COLUMBUS</option>
								</cfif>
									<option value="#dropdown#" <cfif "IN" eq Mid(dropdown,1,2) AND "80" eq Mid(dropdown,6,2)>selected</cfif>>#dropdown#</option>
							</cfloop>
						</select>
					</div>
					<!-- End div controlBinTL -->
				</div>
</cfoutput>	--->
			