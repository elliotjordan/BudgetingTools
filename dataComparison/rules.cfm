<cfinclude template="includes/rules_functions.cfm" />
<cfset getRules = fetchRules() />

<cfoutput>
<div class="navbar"><a href="index.cfm">Main page</a> <a href="datasources.cfm">Data Sources</a> </div>

<h2>Create Rules for Datasets</h2>
<p>The idea is to create a set of granular rules which can then be applied as attributes in the br_datasources table.</p>
<form id="rulesForm" action="updateRules.cfm" method="post" >
	<input id="ruleNm" name="ruleNm" type="text" placeholder="Rule name...">
	<input id="ruleDesc" name="ruleDesc" type="text" placeholder="Rule description...">
	<input id="ruleBtn" name="ruleBtn" type="submit" value="Create Rule" />
</form>

<table id="ruleTable" style="border:1px solid green">
	  <tr>
	  	<th>Rule ID</th>
		<th>Rule Name (unique)</th>
		<th>Rule Description</th>
	  </tr>
	  <cfloop query="getRules">
		  <tr>
		  	<td>#rule_id#</td>
		  	<td>#rule_nm#</td>
		  	<td>#rule_desc#</td>
		  </tr>
	  </cfloop>
</table>

</cfoutput>