<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfoutput>
<!--- deprecated <cfset salObjects = convertQueryToStruct(getAllSalaryObjects('2021')) />--->
<cfset fymParams = convertQueryToStruct(getFYMparams()) />  <!---<cfdump var="#fymParams#"/>--->
<!---<cfset coreTest = getFYMparams() />  <cfdump var="#coreTest#"/>--->
<cfset currentUser = getFYMUser(REQUEST.authUser) />
<cfif ListFindNoCase(REQUEST.adminUsernames,currentUser.username)><cfset editor = "YES"><cfelse><cfset editor = "NO"></cfif>
<div class="full_content">
   <cfinclude template="prod_banner.cfm" runonce="true" />

<h2>5-Year Model Parameters for <!---#getDistinctChartDesc(currentUser.fym_inst)# --->FY#application.shortfiscalyear#</h2>
<p>Use this table to view and maintain model parameters</p>

<!---<cfloop collection="#salObjects#" item="key">
	<cfif key neq 'colList'>
		#salObjects[key]['ln1_desc']#	#salObjects[key]['ln2_desc']#	#salObjects[key]['cy_orig_budget_amt']#<br />
	</cfif>
</cfloop>--->
<!-- Begin 5YR Parameters form -->
	 	<form action = "params_submit.cfm" id = "paramsForm" method = "POST">
	 		<cfif editor>
				<input id="fymSubmit" type="submit" name="fymSubmit" value="Submit Updates" />
			</cfif>
			<table id="fymParamsTable" class="allFeesTable" border="1">
				<thead>
					<tr class="newFee">
						<!---<cfloop array="#fymParams.colList#" index="col">
							<cfif !ListfindnoCase("OID,ln1_cd,ln2_cd,ln_sort" ,col)>
							<th><span class="sm-blue">#col#</span></th>
							</cfif>
						</cfloop>--->
						<th>Chart</th>
						<th>Category</th>
						<th>Parameter</th>
						<th>FY#application.shortfiscalyear# Setting</th>
						<th>FY#application.shortfiscalyear + 1# Setting</th>
						<th>FY#application.shortfiscalyear + 2# Setting</th>
						<th>FY#application.shortfiscalyear + 3# Setting</th>
						<th>FY#application.shortfiscalyear + 4# Setting</th>
						<th>FY#application.shortfiscalyear + 5# Setting</th>
					</tr>
				</thead>
			<tbody>
				<cfloop collection="#fymParams#" item="key">
					<cfif key neq 'colList'>
					<tr>
					<cfloop array="#fymParams.colList#" index="col">
						<cfif !ListfindnoCase("OID,ln1_cd,ln2_cd,ln_sort,grp1_cd,grp2_cd" ,col)>
							<cfif FindNoCase('ln2_desc',LCase(col))>
								<cfif col eq "details_disp" and Len(details_disp) gt 0>
									<div class="tooltip2">
			  					<cfelse><div>
			  					</cfif>
			  				</cfif>
							<cfif findnocase('yr',LCase(col)) and editor> <!--- the editable fields are all named YRx_NEW --->
								<td><!---#key# - #col# - #fymParams[key]['ln1_cd']#<br>--->
									<input name="OID#fymParams[key]['OID']#~#col#" value="#fymParams[key][col]#" width="8" size="12" />
									<input type="hidden" id="OID#fymParams[key]['OID']#~#col#DELTA" name="OID#fymParams[key]['OID']#~#col#DELTA" value="false" />
							<cfelse><td>#fymParams[key][col]#</cfif>
							<!---<cfif LCase(col) eq 'cur_yr_new' and editor><br>--</cfif>--->
							</td>
						</cfif>
					</cfloop>
		    		</tr>
		    		</cfif>
		    	</cfloop>
			</tbody>
			</table>
			<input type="hidden" name="USERNAME" value="#REQUEST.authUser#">
			<input type="hidden" name="returnString" value="#cgi.SCRIPT_NAME#">
			<input id="fymSubmit" type="submit" name="fymSubmit" value="Submit Updates" />
		</form>
<!-- End 5YR Parameters form -->
</div> <!-- End class="full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />
