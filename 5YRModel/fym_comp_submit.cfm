<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput> 
<h2>5YModel Comparison Form submission</h2>
<p>John is still working on this...</p>
<cfif isDefined("form") and StructKeyExists(form,"compSelectorBtn")>
	<h2>compSelector Button Results</h2>
	<cfdump var="#form#" >
	<cfset arg_list = '' />
	<cfloop list="#form.scenarioselector#" index="s">
		<cfset ListAppend(arg_list,s) />
	</cfloop>
	<cfdump var="#arg_list#" >  
	<cfset scen_comparison_result = compareFYMscenario(arg_list)>
	<cfdump var="#scen_comparison_result#" />
	
	<cfabort>
<cfelseif isDefined("form") and StructKeyExists(form,"modelExcelDownBtn")>
	<h2>modelExcelDown Button Results</h2>
	<cfdump var="#form#" ><cfabort>
<cfelseif isDefined("form") and StructKeyExists(form,"crHrExcelDownBtn")>
	<h2>crHrExcelDown Button Results</h2>
	<cfdump var="#form#" ><cfabort>
<cfelse>
	<p>Error. Please contact us and explain that you got the "5Yr Model Comparison error". Sorry for the trouble! Thanks</p> <cfabort>
</cfif>

</cfoutput>
