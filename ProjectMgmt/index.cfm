<cfinclude template="../includes/header_footer/pm_header.cfm" />

<!--- Whenever the database is down for any reason, catch it here so the error is somewhat more informative --->
<cftransaction action="BEGIN">
	<cftry>
		<cfquery name = "TestQuery" dataSource = "#application.datasource#" timeout="3"> 
			SELECT COUNT(*) FROM  pm_projects
		</cfquery> 
		<cfcatch type="database" name="SQLexception">
			<h3>CF Threw a Database Error</h3> 
			<cfoutput> 
				<p>#SQLexception.message#</p> 
				<p>Caught an exception, type = #SQLexception.TYPE#</p> 
				<p>The contents of the tag stack are:</p> 
				#SQLexception.tagcontext# 
			</cfoutput> 
		</cfcatch>
	</cftry>
</cftransaction>

<cfinclude template="projects.cfm" />

<cfinclude template="../includes/header_footer/pm_footer.cfm" />

