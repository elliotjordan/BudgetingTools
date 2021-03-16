<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">

<cfif IsDefined("url") AND StructKeyExists(url,"chart") AND StructKeyExists(url,"RC")>
	<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#url.chart#,12,"#REQUEST.AuthUser# got the Hmmm page when attempting to save credit hour changes from #url.chart# RC #url.rc#.") />
</cfif>
<cfoutput>
	<div class="full_content">
		<h2>Hmmm.  Something Seems Off</h2>
		<p>Sorry about this, but we check the form submission to make sure everything is OK, and this time noticed a problem which meant we could not save your changes.</p>
		<p>If you got this message, try making one or two changes at a time and "Save Your Work" more often.  Please be sure to let us know if you get this page.</p>
		<p>Sorry for the trouble.</p>
	</div>  <!-- End of class full_content -->
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">
