<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/UBO_template_functions.cfm">

<a href="index.cfm">Return to UBO Templates page</a><br>


<br>
<cfdump var="#form#" >
<br>


<cfif StructKeyExists(form,"templateselect")>
	<cfswitch expression="#form.templateselect#">
		<cfcase value="1"></cfcase>
		<cfcase value="2"><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfcase>
		<cfcase value="3"><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfcase>
		<cfdefaultcase><cflocation url="index.cfm?message=Sorry" addtoken="false"></cfdefaultcase>
	</cfswitch>
</cfif>

<!--- **************************  --->
<cfset objCdData = getObjCdTotals() /> 

<cfoutput>
	<div class="full_content">
        <h2>Generate Monthly GL Detail Report</h2>

	</div>    <!-- End class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">
