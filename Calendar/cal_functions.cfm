<cffunction name="getCalendarItems" >
	<cfquery name="calItems" datasource="#application.datasource#">
		SELECT id, cal_date, created_on, fiscal_year, 
		  cal_item, cal_sub_item, 
		  cal_responsible, cal_accountable, cal_consulted, cal_informed, 
		  cal_note, cal_meta, cal_sort
	FROM fee_user.pm_calendar;
	</cfquery>
	<cfreturn calItems />
</cffunction>