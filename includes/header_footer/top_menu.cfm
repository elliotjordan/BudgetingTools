<!--- 
	file:	top_menu.cfm
	author:	John Burgoon jburgoon, modified from code by Doug Jessee
	ver.:	v0.1
	date:	11-14-14
	update:	11-14-14
	note:	This cfm is an include of the Menu which is the main navigation across the top.
 --->
		<div id="header-wrap-outer" role="banner">
			<div id="header-wrap-inner">
<!---				<div id="header">
					<h1>
						<a href="../index.cfm">IU Budget Office Budgeting Tools</a>
					</h1>
					<cfif IsDefined("session") and StructKeyExists(session,"user_id") and StructKeyExists(session, "user") and FindNoCase(session.user_id, REQUEST.developerUsernames) >
							<cfoutput>
								<p>You are logged in as #session.user_id#, #session.user[1].getDescription()# - Loginrole: #session.loginrole# - Server: #application.baseurl#</p>
							</cfoutput>
					</cfif>
				</div>--->
			</div>
		</div>
		