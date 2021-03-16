<!--- 
    file:    revenue_RC.cfm
    author:    John Burgoon jburgoon
    ver.:    v0.2
    date:    08-29-17
    update:    10-17-17
    note:    Revenue Estimtor starting page
 --->
<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">

<cfoutput>
	<div class="full_content">
		<cfif isDefined("form") and StructKeyExists(form,"table_name") AND form.table_name eq "sandbox_table">
			<cfloop list="#form.fieldnames#" index="i">
				<cfif FindNoCase("PREF_",i) eq 1>
					#i#<br>
					-- #Mid( TRIM(i),6,Len(TRIM(i)) )#<br>
					-- #Form[i]#<br>
					<cfset updatePreferences(#Mid(TRIM(i),6,Len(TRIM(i)))#,#Form[i]#)>
				</cfif>
			</cfloop>
		<cfelse>
<!---		<cdelseif IsDefined("session") and StructKeyExists(session, "iscasvalidated") and session.iscasvalidated eq "yes">
--->			<cfset userPrefs = getUserPreferences(REQUEST.AuthUser)>	
			<!---<cfset userPrefs = EntityLoad("PREFERENCES",{username=REQUEST.AuthUser},true)>--->
			<h2>
				Preferences Sandbox for #REQUEST.AuthUser#</p>
			</h2>
			<cfform name="sandbox_form" action="sandbox.cfm" id="sandbox_form">
				<cfinput name="prefBtn" type="submit" id="prefBtn">
				<table class="feeCodeTable">
					<tr>
						<th>APP_NAME</th>
						<th>PREF_NAME</th>
						<th>PREF_VALUE</th>
					</tr>
					<cfloop query="#userPrefs#">
						<tr>
							<td><div class="sm-blue">#currentRow#</div><br>
								#APP_NAME#</td>
							<td>#PREF_NM#</td>
							<td><input type="text" id="pref_value" name="PREF_#PREF_NM#" value="#pref_value#"/></td>
						</tr>							
					</cfloop>
					<input type="hidden" name="table_name" value="sandbox_table">
					<input type="hidden" name="recordCount" value="#userPrefs.recordCount#">
				</table>
			</cfform>
<!---		<cfelse>
			<h3>Did not have session or casvalidation.  Dumping session and request scopes</h3>
			<cfdump var="#session#"/>
			<br>
			<cfdump var="#request#"/>--->
		</cfif>
	</div>
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">