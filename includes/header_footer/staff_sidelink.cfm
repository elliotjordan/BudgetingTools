<!--- 
	file:	staff_sidelink.cfm
	author:	John Burgoon jburgoon, modified from old UBO site code
	ver.:	v0.1
	date:	12-2-14
	update:	12-2-14
	note:	This cfm is an include of the Menu which is the main navigation across the top.
 --->
		<div class="sideLink">
<cfoutput>
	<cfif StructKeyExists(session,"casuser") AND REQUEST.AuthUser neq "">
		<p><a href="../index.cfm" title="Landing page after logging in to UBO Budgeting Tools">Home</a></p>
		<p><a href="../manage.cfm" title="Manage my UBO Budgeting Tools account"><strong>Manage my settings: </strong> #encodeForHTML(session.user_id)#</a></p>
		<cfif StructKeyExists(session,"access_level") AND session.access_level eq "bduser">
				<p><a href="staff.cfm?users=true" title="Current users table"><strong>Current users</strong></a></p>
				<p><a href="staff.cfm?activity=true" title="Access requests page"><strong>Access requests</strong></a></p>
				<p><a href="permissions.cfm" title="Permissions control table"><strong>Permission control</strong></a></p>
				<p><a href="forensics.cfm" title="Metadata table"><strong>Forensics</strong></a></p>
				<p><a href="../staff/utilities.cfm" title="Data sorting table"><strong>Utilities</strong></a></p>
		</cfif>
		<p><a href="sandbox.cfm">Sandbox</a></p>
		<p><a href="../logout.cfm" title="Logout of the UBO Budgeting Tools"><strong>Logout</strong></a></p>
		<p><a href="../logout_CAS.cfm" title="Log out of IU Central Authentication Service (CAS)"><strong>CAS logout</strong></a></p>
	<cfelse>
			<p><a href="../login.cfm" title="Log into University Budget Office Budgeting Tools"><strong>Login</strong></a></p>
			<p><a href="../requests.cfm" title="Request access"><strong>Request access</strong></a></p>
	</cfif>
			<p><a href="../help.cfm" target="_blank" title="Go to UBO help pages"><strong>Help</strong></a></p>
	<cfif structKeyExists(url,"message") AND trim(url.message) neq "">
	    	<div class="trouble">
	        	<h4>#url.message#</h4>
	        </div>
    </cfif>
</cfoutput>
		</div>