<!---<cfdump var="#form#" />--->
<cfinclude template="includes/rules_functions.cfm" />

<cfset createRule(form.rulenm,form.ruleDesc) />

<cflocation url="rules.cfm" addtoken="false" />