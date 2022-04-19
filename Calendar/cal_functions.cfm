<!--- CRUD unctions for calendar  --->
<!---  CREATE  --->
<cffunction name="createCalendarItem" >
	<cfquery name="createCalItem">
		select * from fee_user.insert_into_pm_calendar(
			givenfiscal_year character varying, 
			givenstart_desc_main character varying, 
			givenstart_desc_sub character varying, 
			givendeadline_date timestamp without time zone, 
			givendeadline_desc_main character varying, 
			givendeadline_desc_sub character varying,
			givenresponsible character varying, 
			givenhyperlink character varying,
			givennote character varying, 
			givencompleted_flag character varying,
			givencal_layer character varying, 
			givenpublish_flag character varying, 
			givenusername character varying, 
			giventag character varying)
               <!---  This gives all the non-auto columns. Arrow operators (=>) very much required here.  ---> 
	</cfquery>
</cffunction>

<!--- READ  --->
<cffunction name="getCalendarItems">
	<cfquery name="getCalItems" datasource="#application.datasource#">
		SELECT * FROM fee_user.pm_calendar where fiscal_year = '#application.fiscalyear#'
	</cfquery>
	<cfreturn getCalItems>
</cffunction>


<!---  UPDATE  --->
<cffunction name="updateCalendarItem" >
	<cfquery name="updateCalitem" datasource="#application.datasource#">
		select * from fee_user.update_pm_calendar(
			givencalid integer, 
			givencolumn character varying, 
			givenvalue character varying
		)
	</cfquery>
</cffunction>

<!---  DELETE  --->
<cffunction name="deleteCalendarItem" >
	<cfquery name="deleteCalitem" datasource="#application.datasource#">
		select * from fee_user.delete_from_pm_calendar(
			givencalid integer
		)
	</cfquery>
</cffunction>