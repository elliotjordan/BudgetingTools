<cffunction name="getCalendarItems">
	<cfquery name="getCalItems" datasource="#application.datasource#">
		SELECT * FROM fee_user.pm_calendar 
	</cfquery>
	<cfreturn getCalItems>
</cffunction>

<cffunction name="getTestQuery">
	<cfargument name="sockItToMe" required="false" default="NEVERMIND">
	<cfif sockItToMe eq 'NEVERMIND'>
		<cfquery name="hotAir" datasource="#application.datasource#">
			SELECT 'blork' as BLORK from dual
		</cfquery>
		<cfreturn hotAir />
	<cfelse>
		<cfquery name="smoke" datasource="#application.datasource#">
			SELECT '999999' as OID, '#sockItToMe#' as GIVEN_INPUT, 'blork' as BLORK, 'swampwater' as BILGE, 'tosh' as DRIVEL, '7' as YRS_TO_RETIRE
			from dual
		</cfquery>
		<cfreturn smoke />
	</cfif>
</cffunction>
