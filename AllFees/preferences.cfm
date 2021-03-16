<cfinclude template="../includes/header_footer/allfees_header.cfm" />

<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />

<cfset prefs = getPreferences()>
<!---<cfdump var="#prefs#" >--->
<cfoutput>
<div class="full_content">
	<cfinclude template="nav_links.cfm">
		<h2>Preferences</h2>
	 	<cfform action = "preferences_update.cfm" id = "PrefUpdateForm" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
	 		timeout = "1200" width = "800" wMode = "opaque" >
				<table id="prefsTable" class="allFeesTable">
					<thead>
						<tr>
							<th>USERNAME</th>
							<th>PREF_NM</th>
							<th>PREF_VALUE</th>
						</tr>
					</thead>
					<cfif prefs.recordcount lt 1>
						<tbody>
				    		<tr>
						    	<td colspan="12">You currently have no preference settings available to you.</td>
						    </tr>
					<cfelse>
						<tbody>
							<cfloop query="#prefs#">
								<cfif REQUEST.authUser eq prefs.USERNAME>
						    		<tr>
						    			<td>#USERNAME#</td>
										<td>#PREF_NM#</td>
										<td>#PREF_VALUE#</td>
									</tr>
								</cfif>
				    		</cfloop> 
				    	</tbody>
			    	</cfif>
				</table>
			</cfform>
			





	</cfoutput>
</div>

<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
