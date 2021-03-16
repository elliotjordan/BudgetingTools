<!--- 
	file:	login.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	1-4-16
	update:	
	note:	Login logic
	session.access_level
		1	Admin
		2	Manager
		3	All priveleges in Department
		4	Data entry in department
		5	Guest
 --->
<cfparam name="session.access_level" default="guest">
<cfparam name="REQUEST.AuthUser" default="casuser_error">
<cfoutput>
		<div class="content">

	<cfif structKeyExists(url,"message") AND trim(url.message) neq "">
    	<div class="trouble">
        	<h4>#url.message#</h4>
        </div>
	</cfif>
		<p>You are logged into CAS as #REQUEST.AuthUser#.  However we also require DUO authentication.</p>
</cfoutput>