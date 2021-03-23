<!--- deprecated --->
<cflocation url="index.cfm" addtoken="false" />

<cfinclude template="../includes/header_footer/allfees_header.cfm"> 
<cfinclude template="../includes/functions/tuition_functions.cfm" />
<cfinclude template="loadUser.cfm">  
				<!---<cfdump var="#session#" >--->
<cfif IsDefined("session") and StructKeyExists(session,"user_id")>
<cfset actionEntry = trackFeeAction(#REQUEST.AuthUser#,"UA",1,"tuition.cfm - #REQUEST.authUser# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")#") />

	<cfif ListFindNoCase(REQUEST.adminUsernames,request.authUser)>
		<cfset tuitionData = getFeesByUserID(#session.access_level#)>
	<cfelse>
		<cfset tuitionData = getFeesByUserID(#session.access_level#) /> 
	</cfif>

	<cfoutput>
		<div class="full_content">
		    	<cfset showBanner = false />			
				<cfif IsDefined("session") and StructKeyExists(session,"user_id") and FindNoCase(session.user_id, REQUEST.developerUsernames) >
					<cfset showBanner = true />
				</cfif>
				<cfif showBanner>
					<p class="sm-gray headerRight">(index.cfm) You are logged in as #session.user_id# with session.role: #session.role#, session.curr_proj_chart: #session.curr_proj_chart#, session.access_level: #session.access_level#</p>
				</cfif>

				<cfinclude template="tuition_request_form.cfm" />

			<p class="sm-gray">If you have any questions about how to use the UBO Tuition Request Portal, please call us!</p>
	</cfoutput>	
</cfif>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" />
