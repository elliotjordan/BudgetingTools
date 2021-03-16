<!---<cfdump var="#form#" />--->
<cfinclude template="includes/rules_functions.cfm" />

<cfset registerDatasource(form.srcnm,form.srcGrp,form.srcDesc,srcRules) />

<cflocation url="datasources.cfm" addtoken="false" />