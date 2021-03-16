<cfinclude template="includes/header_footer/header.cfm" >

<cfoutput>
	<div class="content">
		<cfinclude template="includes/header_footer/sidelink.cfm" >
		<h2>Developer's Sandbox</h2>
		<p>This page is meant to be a simple CFM where you can drop notes, test code snippets, etc.</p>
		<p>The only people who should see the link in the sidebar are listed in <i>REQUEST.developerUsernames</i></p>
		<p>  Currently, there are: #REQUEST.developerUsernames#</p>
	
		<h5>Testing Server Awareness since 1996</h5>
		<cfif FindNoCase("rohan",application.baseurl)>
					<strong>rohan</strong> found in name
				<cfelse>
					<strong>rohan</strong> not found in name
				</cfif>
	
		<h5>Session</h5>
		<p><cfdump var="#session#" /></p>
		
		<h5>Application Scope settings</h5>
		<cfdump var="#application#" />
	</div>
</cfoutput>
<cfinclude template="includes/header_footer/footer.cfm" >
