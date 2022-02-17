<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfinclude template="../includes/functions/refresh_functions.cfm">
<cfset refreshList = getCrHrDataRefreshHistory() />

<cfoutput>
<div class="full_content">
	<cfif IsDefined("form") AND StructKeyExists(form,"UBOflag")>
		<!--- User has requested status changes --->
		<cfif StructKeyExists(form,"UBOSwitchBtn") and form.UBOSwitchBtn eq "Make It So">
			<cfif application.budget_year neq form.biSwitchSel AND form.biSwitchSel eq "YR1">
				<cfset application.budget_year = "YR1">
			<cfelseif application.budget_year neq form.biSwitchSel AND form.biSwitchSel eq "YR2">
				<cfset application.budget_year = "YR2">			
			</cfif>
		
			<cfif application.rateStatus neq form.rateSwitchSel AND form.rateSwitchSel eq "Vc">
				<cfset application.rateStatus = "Vc">
			<cfelseif application.rateStatus neq form.rateSwitchSel AND form.rateSwitchSel eq "V1">
				<cfset application.rateStatus = "V1">			
			</cfif>
		</cfif>
	<cfelseif IsDefined("form") and StructKeyExists(form,"rolloverBtn") >
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"UA",2,"#REQUEST.AuthUser# restarted the #application.currentState# Projectinator from at #DateTimeFormat(Now(),'hh:nn tt mmm-dd-yyyy')#") />
		<cfset applicationStop() />
	<cfelseif IsDefined("form") and StructKeyExists(form,"fymBtn") >
		<cfset fym_updated = updateBudu001Fym() /><!---<cfdump var="#fym_updated.update_budu001_fym#" /><cfabort>--->
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"UA",33,"#fym_updated.update_budu001_fym# #REQUEST.AuthUser# refreshed the BUDU001 5YrModel tables at #DateTimeFormat(Now(),'hh:nn tt mmm-dd-yyyy')#") />
	<cfelseif IsDefined("form") and StructKeyExists(form,"refreshBtn") >
		<cfif FindNoCase("gondor",application.baseurl)>
			<cfset resetSource = 'PROD' />
		<cfelseif FindNoCase("rohan",application.baseurl)>
			<cfset resetSource = 'TEST' />
		<cfelseif FindNoCase("localhost",application.baseurl)>
			<cfset resetSource = 'DEV' />
		<cfelse>
			<cfset resetSource = 'the Ether' />
		</cfif>
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"UA",3,"#REQUEST.AuthUser# refreshed BUDU001 Projectinator data from #resetSource# at #DateTimeFormat(Now(),'hh:nn tt mmm-dd-yyyy')#",#application.currentState#) />
		<cfset successCount = projRefresh() />
	</cfif>

	<!--- Top of page  --->
	<span>
		<a href="revenue_RC.cfm">RC Page</a><span> -- </span>
		<a href="revenue_Campus.cfm">Campus Page</a><span> -- </span>
		<a href="revenue_University.cfm">University Page</a>	
	</span>
	<h2>UBO Controls</h2>
	<p>You are currently logged in as #request.authUser#</p>
	<form name="UBOcontrolsForm" action="UBO_controls.cfm" method="post" >
		<input name="UBOflag" type="hidden" value="UBO" />  <!--- Convenience field so we can always process the form no matter what button is selected  --->

		<h5>These changes will NOT be permanent - they will re-set overnight or on server re-start.  However, they can be used to change the site during the day to get us by without a server re-start until we can implement "sticky" settings.</h5>
		<label for="biSwitch">Switch BiEnnium Between Long (YR1) and Short Year (YR2) - </label>
		<input id="biSwitchSelector" name="biSwitchSel" type="radio" value="YR1" <cfif application.budget_year eq "YR1">checked</cfif>>YR1</input>
		<input id="biSwitchSelector" name="biSwitchSel" type="radio" value="YR2" <cfif application.budget_year eq "YR2">checked</cfif>>YR2</input>
		<br>
		<span>Current value: <b>#application.budget_year#</b></span>
		<br><br>	
		<label for="rateSwitch">Switch Rate Status Between Constant and Adjusted Escalated - </label>
		<input id="rateSwitchSelector" name="rateSwitchSel" type="radio" value="Vc" <cfif application.rateStatus eq "Vc">checked</cfif> >Vc</input>
		<input id="rateSwitchSelector" name="rateSwitchSel" type="radio" value="V1" <cfif application.rateStatus eq "V1">checked</cfif> >V1</input>
		<br>
		<span>Current value: <b>#application.rateStatus#</b></span>
		<p>Please don't play with this except in TEST.  <b><i>This really will change everything throughout the site</i></b> - the values displayed in YR1 and YR2, the revenue calculations, the values which are downloaded to the Excel exports, and the format and data for the Vc/V1 reports.</p>
		<p>In Production, this is meant to let anyone in our office update the settings for the day without having to restart the server.</p>
		<input id="UBOSwitch" name="UBOSwitchBtn" type="submit" value="Make It So" disabled />
	</form>
	
		<hr>
		<h2>5YM Refresh</h2>
		<form name="siteRollover" action="UBO_controls.cfm" method="post">
			<input id="fymBtn" name="fymBtn" type="submit" value="Refresh BUDU001 5YM Tables" />
			<label for="rolloverBtn">Refresh the Five-Year Model tables in BUDU001</label>		
		</form>
		
		<hr>
			
		<h2>Site Refresh</h2>
	<cfif IsDefined("form") and StructKeyExists(form,"rolloverBtn") >
		<span class="warning">Application Re-set<p>The Projectinator has stopped.  The next request from any place on the site will re-start it automatically.</p></span>
	</cfif>

		
		<p>This control calls applicationStop(), which causes the site to reload all its settings.  The very next request which comes in automatically re-starts the system, which means the new settings should take effect without having to completely blow the system away.</p>
	<form name="siteRollover" action="UBO_controls.cfm" method="post">
		<input id="rolloverBtn" name="rolloverBtn" type="submit" value="Kick Me" />
		<input id="disabledState" name="disabledState" value="#application.disabled#" type="hidden" />
		<label for="rolloverBtn">Restart the Credit Hour Projector</label>		
	</form>

		<hr>
	<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
		<h2>Projector Data Refresh</h2>
	<cfif IsDefined("form") and StructKeyExists(form,"refreshBtn") >
		<span class="warning">Projector Data Refresh<p>The Projectinator data in BUDU001 has been refreshed from ch_user.htp.  Total number of records: #successCount.totalRecords#.</p></span>
	</cfif>
		<p>This control copies the values from the Credit Hour and Revenue Projector database (ch_user.htp) directly into the BUDU001 version of the table (BUDU001.chp_htp_t).  The custom VIEW of that table is automatically refreshed as well.</p>
	<form name="dataRefresh" action="UBO_controls.cfm" method="post">
		<input id="refreshBtn" name="refreshBtn" type="submit" value="Refresh BUDU001 Projector Data" />
		<input id="disabledState" name="disabledState" value="#application.disabled#" type="hidden" />
		<label for="refreshBtn">Refresh BUDU001 with lastest Projector data</label>
		<cfloop query="#refreshList#">
			<p style="sm_blue">#parameter_cd# - #description#<p>
		</cfloop>
	</form>
	</cfif>
<!--- jwb sandbox  --->
	<cfif REQUEST.authUSer eq 'jburgoon'>
		<cfset queryString = "SELECT DISTINCT inst FROM htp" />
		<cfset callSQLProc = updateCrHrEst(queryString) />
		<h2>Stored Proc test</h2>
		<p> Query string is: <i>#queryString#</i>
		<p>The procedure returns the number of lines in the result:  #callSQLProc.upd_crhrest_pr#</p>
	</cfif>
<!--- end jwb sandbox --->
</cfoutput>
</div>  <!-- End div class full_content -->
<cfinclude template="../includes/header_footer/footer.cfm">