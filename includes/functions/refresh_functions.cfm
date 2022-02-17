<cffunction name="updateBudu001Fym" >
	<cfquery name="doTheFYMupdate" datasource="#application.datasource#">
		select * from fee_user.update_budu001_fym()
	</cfquery>
	<cfreturn doTheFYMupdate>
</cffunction>

<cffunction name="getFYMDataRefreshHistory" >
	<cfquery name="refreshList" datasource="#application.datasource#">
		SELECT * FROM fee_user.metadata
		WHERE action_id = '33'
		ORDER BY created_on DESC limit 5;
	</cfquery>
	<cfreturn refreshList />
</cffunction>