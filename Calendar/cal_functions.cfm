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

<cffunction name="insertNewCalItem">
	<cfargument name="givenForm" type="struct" required="true" />
	<!--- passing the entire form and then writing the update query is one way to do it --->
	<!--- another way to do this is to specify individual fields as args, which is what I usually do --->
	<!--- I tend to put the form validation logic in the submission page, then push clean individual values to a function for addition to the db --->
	<!--- Either way is valid, we can discuss in a code review/design session  --->
	<cfreturn true />
</cffunction>