<!--- 
	file:	sidelink.cfm
	author:	John Burgoon jburgoon, modified from old UBO site code
	ver.:	v0.1
	date:	1-4-16
	update:	10-05-17
	note:	This cfm is an include of the Menu which is the main navigation across the top.
 --->
		<div class="sideLink">
<cfoutput>
<!---	<cfif IsDefined("session") AND StructKeyExists(session,"iscasvalidated") AND session.iscasvalidated IS "yes">
--->		<cfif IsDefined("session") AND StructKeyExists(session,"casuser") AND FindNoCase(REQUEST.AuthUser, request.developerUsernames)>
			<h3>All Users</h3>
		</cfif>		
		<p><a href="index.cfm" title="Landing page after logging in">Home</a></p>
		<p><a href="AllFees/fee_rates.cfm" title="All Fee Rates"><strong>All Fee Rates</strong></a></p>
		<p><a href="RevenueEstimator/revenue_RC.cfm" title="Revenue Estimator"><strong>Revenue Estimator</strong></a></p>
		<p><a href="EditChecks/edit_checks.cfm" title="Edit Checks"><strong>Edit Checks</strong></a></p>
		<p><a href="DataMap/datamap.cfm" title="Data Map"><strong>Data Map</strong></a></p> 
		<p><a href="logout.cfm?id=1" onclick="return confirm('Are you sure you want to log out?')" title="Logout from UBO Budgeting Tools"><strong>Local Logout</strong></a></p>
		<p><a href="logout_CAS.cfm" title="Log out of IU Central Authentication Service (CAS)"><strong>CAS logout</strong></a></p>	
		<p><a href="help.cfm" title="Go to UBO help pages"><strong>Help</strong></a></p>
		<cfif IsDefined("session") AND StructKeyExists(session,"casuser") AND FindNoCase(REQUEST.AuthUser, request.developerUsernames)>
			<br>
			<h3>Developer Tools</h3>
			<cfif StructKeyExists(session,"access_level") AND session.access_level neq "" AND 0 eq 1>
				session.access_level: #session.access_level#
			</cfif>
			<p><a href="developers_sandbox.cfm" title="Sandbox"><strong>Developers Sandbox</strong></a></p>
		</cfif>	
<!---	<cfelse>
		<p><a href="index.cfm" title="Log into University Budget Office Budgeting Tools"><strong>Login</strong></a></p>
	</cfif>--->
	<cfif structKeyExists(url,"message") AND trim(url.message) neq "">
	    	<div class="trouble">
	        	<h4>#url.message#</h4>
	        </div>
    </cfif>
</cfoutput>
		</div>