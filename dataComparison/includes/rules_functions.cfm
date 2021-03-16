<cffunction name="createRule">
	<cfargument name="given_ruleNm" type="string" required="true" />
	<cfargument name="given_ruleDesc" type="string" required="true" />
	<cfquery datasource="#application.datasource#" name="ruleMaker">
		INSERT INTO br_rules (rule_nm,rule_desc)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_ruleNm)#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_ruleDesc)#" />
		)
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="fetchRules">
	<cfargument name="ruleGroup" required="false" default="all">
	<cfquery datasource="#application.datasource#" name="ruleList">
		SELECT rule_id, rule_nm, rule_desc
		FROM fee_user.br_rules
		<cfif ruleGroup neq "all">
			WHERE rule_grp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ruleGroup#">
		</cfif>
		ORDER BY rule_id asc 
	</cfquery>
	<cfreturn ruleList>
</cffunction>

<cffunction name="registerDatasource">
	<cfargument name="given_dsNm" type="string" required="true" />
	<cfargument name="given_dsGrp" type="string" required="true" />
	<cfargument name="given_dsDesc" type="string" required="true" />
	<cfargument name="given_dsRules" type="any" required="false" default="">
	<cfquery datasource="#application.datasource#" name="ruleMaker">
		INSERT INTO br_datasources (ds_nm,ds_group,ds_desc,ds_rules)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_dsNm)#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_dsGrp)#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_dsDesc)#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(given_dsRules)#" />
		)
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="fetchDataSources">
	<cfargument name="srcGroup" required="false" default="all">
	<cfquery datasource="#application.datasource#" name="srcList">
		SELECT ds_id, ds_group, ds_nm, ds_desc, ds_rules
		FROM fee_user.br_datasources
		<cfif srcGroup neq "all">
			WHERE ds_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#srcGroup#">
		</cfif>
		ORDER BY ds_id asc 
	</cfquery>
	<cfreturn srcList>
</cffunction>
