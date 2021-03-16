<cfinclude template="../includes/header_footer/allfees_header.cfm" />
<cfinclude template="../includes/functions/tuition_functions.cfm" />
<!--- Whenever the database is down for any reason, catch it here so the error is somewhat more informative --->
<cfoutput>
	<cftry>
		<cfquery name = "TestQuery" datasource="#application.datasource#">
			SELECT COUNT(*)
			FROM  #application.allFeesTable#
			WHERE fiscal_year = <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.fiscalyear#" />
		</cfquery>
		<cfcatch type="database" name="SQLexception">
			<h3>CF Threw a Database Error</h3>
			<cfoutput>
				<p>#SQLexception.message#</p>
				<p>Caught an exception, type = #SQLexception.TYPE#</p>
				<p>The contents of the tag stack are:</p>
				<cfdump var="#SQLexception#"><!--- #SQLexception.tagcontext#  --->
			</cfoutput>
		</cfcatch>
	</cftry>

<!---<cfset actionEntry = trackFeeAction(#REQUEST.AuthUser#,"UA",1,"index.cfm - #REQUEST.authUser# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />
---></cfoutput>
<cfinclude template= "all_fees.cfm" runonce="true" />

<cfinclude template="../includes/header_footer/allfees_footer.cfm" runonce="true" />

