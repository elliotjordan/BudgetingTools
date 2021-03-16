<!doctype html>
<head>
	<title>UBO Data Comparison Datasources</title>
	<meta charset='utf-8'>
</head>

<cfinclude template="includes/rules_functions.cfm" />
<cfset getSources = fetchDatasources() />

<cfoutput>
<div class="navbar"><a href="index.cfm">Main page</a> <a href="rules.cfm">Rules</a> </div>
	
<h2>Register Report Datasources</h2>
<p>Various reports are created from our data.  Here, a "datasource" is not limited to an object in PostgresQL db, per se.  The spirit of "datasource" here is more akin to that used by Tableau: a db table, an Excel file, or other form of report, inlcuding possibly IUIE output, AM360 tables, UIRR reports, and even publications such as PDFs.</p>
<form id="sourcesForm" action="updateSources.cfm" method="post">
	<input id="srcNm" name="srcNm" type="text" placeholder="Source name..." size="30">
	<input id="srcDesc" name="srcDesc" type="text" placeholder="Source description..." size="45">
	<input id="srcRules" name="srcRules" type="text" placeholder="Comma-separated rule IDs..." size="50">
	<input id="srcGrp" name="srcGrp" type="text" placeholder="Group..." size="30">
	<input id="srcBtn" name="srcBtn" type="submit" value="Create Source" />
</form>

<hr width="90%" />

<table id="srcTable" style="border:1px solid orange">
	  <tr>
	  	<th>ID</th>
		<th>Source Name (unique)</th>
		<th>Source Description</th>
		<th>Applicable Rules</th>
	  	<th>Group</th>
	  </tr>
	  <cfloop query="getSources">
		  <tr>
		  	<td>#ds_id#</td>
		  	<td>#ds_nm#</td>
		  	<td>#ds_desc#</td>
		  	<td>#ds_rules#</td>
		  	<td>#ds_group#</td>
		  </tr>
	  </cfloop>
</table>

</cfoutput>