


<cfinclude template="includes/functions/data_mapping_functions.cfm">

<cfif isDefined("url") AND StructKeyExists(url,"table")>
	
	<cfset tableDetails = getTableDetails(url.table)>
	
	<cfoutput>
		<h2>
			#url.table#
		</h2>
		<cfdump var="#tableDetails#" >
	</cfoutput>

<cfelse>
	<h2>Woops.</h2>
	<p>We're sorry.  Something is wrong with this service.  Please advise John Burgoon at the University Budget Office.
</cfif>
