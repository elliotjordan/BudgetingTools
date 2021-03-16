<!--- 
	file:	no_access.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	12-2-14
	update:	8-09-16
	note:	No access page.
 --->
<cfinclude template="../includes/header_footer/header.cfm" />
<h2>Sorry</h2>
<p>Sorry, the site is now closed.  Please contact your campus fiscal officer.</p>

<cfif StructKeyExists(url,"message") AND Len(url.message) gt 0>
	<cfoutput>
		<h2>#url.message#</h2>
	</cfoutput>
</cfif>
<cfinclude template="../includes/header_footer/footer.cfm" />
