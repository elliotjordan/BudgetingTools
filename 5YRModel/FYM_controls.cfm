<cfinclude template="../includes/header_footer/fym_header.cfm">
<cfinclude template="../includes/functions/refresh_functions.cfm">
<cfset fymRefreshList = getFYMRefreshHistory() />
<cfset fym_updated = QueryNew("test")>  

<cfoutput>
<div class="full_content">
	<cfif IsDefined("form") and StructKeyExists(form,"fymBtn") >
		<cfset fym_updated = updateBudu001Fym() />
		<cfset actionEntry = trackFYMAction(#REQUEST.AuthUser#,"UA",33,"#fym_updated.update_budu001_fym# #REQUEST.AuthUser# refreshed the BUDU001 5YrModel tables at #DateTimeFormat(Now(),'hh:nn tt mmm-dd-yyyy')#") />
	</cfif>

	<!--- Top of page  --->
	<h2>UBO Controls</h2>
		<p>You are currently logged in as #request.authUser#</p>
		<h2>5YM Refresh</h2>
		<form name="fymRefresher" action="FYM_controls.cfm" method="post">
			<input id="fymBtn" name="fymBtn" type="submit" value="Refresh BUDU001 5YM Tables" />
			<label for="rolloverBtn">Refresh the Five-Year Model tables in BUDU001</label>
			<cfif StructKeyExists(fym_updated,"update_budu001_fym") and fym_updated.update_budu001_fym>
				<p class="sm-red"> You have successfully refreshed BUDU001 5YrModel tables</p>
			</cfif>
			<cfif fymRefreshList.recordCount gt 0>
				<h3>Recent BUDU001 5YM Refresh History</h3>
				<cfloop query="#fymRefreshList#">
					<p style="sm_blue">#parameter_cd# - #description#<p>
				</cfloop>
			</cfif>
		</form>
</div>  <!-- End div class full_content -->

</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm">