
<cffunction name="getTableDetails" description="returns a DESCRIBE of the table name given in the parameters">
	<cfargument name="tableName" default="DUAL">
	<cfquery name="tableDetails" datasource="#application.datasource#">
		SELECT *
		FROM <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#">
		WHERE FISCAL_YEAR = '2018'
	</cfquery>
	<cfreturn tableDetails>
</cffunction>