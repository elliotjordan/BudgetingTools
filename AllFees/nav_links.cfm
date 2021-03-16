<!-- Begin nav links  -->
<!-- See ALLFEES_HEADER.CFM for the links appearing inside the branding bar -->
<cfoutput>
	<cfif StructKeyExists(session,"first_last_name") AND LEN(session.first_last_name) gt 2>
		<b>Welcome, #session.first_last_name#</b>
	<cfelse>
		<b>Welcome!</b>
	</cfif>
</cfoutput>
<cfif FindNoCase("rohan",application.baseurl) OR FindNoCase("localhost",application.baseurl)>
	<cfinclude template="test_banner.cfm">
</cfif>
<cfif FindNoCase("gondor",application.baseurl) <!---OR FindNoCase("localhost",application.baseurl)--->>
	<cfinclude template="prod_banner.cfm">
</cfif>
<!-- End nav links  -->