<cfinclude template="../includes/header_footer/allfees_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />

<cfif session.inst eq 'IUBLA'>
	<cfset closedList = 'CRS,ADM,CMP' />
<cfelse>
	<cfset closedList = 'CRS,ADM' />
</cfif>
<cfif IsDefined("url") and StructKeyExists(url,"fee_type")>
	<cfset currentlyActive = url.fee_type />
<cfelse>
	<!---<cfset currentlyActive = application.allFeeStatus />--->
	<cfset currentlyActive = 'Tuition and Mandatory' />
</cfif>
<!---<cfif REQUEST.authUser eq 'jopadams' or currentlyActive != 'Non-instructional' AND (ListFindNoCase(REQUEST.campusFOusernames, REQUEST.authUser) OR ListFindNoCase(REQUEST.Approver_list, REQUEST.authUser) OR ListFindNoCase(REQUEST.regionalUsernames,REQUEST.authUser) OR REQUEST.authUser eq "coback" OR REQUEST.authUser eq "atronc01")>
--->
<cfif !ListFindNoCase(currentlyActive,'Non-instructional')>
	<cfset editingEnabled = true />
<cfelse><cfset editingEnabled = false /></cfif>
<cfset feeTypeList = getPreparedTypeCategories() />
<cfset role = getUserRole(session.access_level) />
<cfset roleFeestatus = getDistinctFeeStatus() />
<cfoutput>

<div class="full_content">
	<cfif currentlyActive eq 'All' and ListFindNoCase('campus,regional,ubo,bursar,cfo',role)>
		<cfset AllFeeData = getMergedFees()>
		<cfset editingEnabled = false />
	<cfelse>
		<cfset AllFeeData = getMergedFees('ALL',#session.inst#,#session.allfees_rcs#)>
	</cfif>
	
	<cfinclude template="nav_links.cfm" runonce="true" >
	<!---<cfinclude template="approvals_summary.cfm">--->
	<!---<cfinclude template="tuition_request_panel.cfm">--->

	<h3>Master List of All Fees</h3>  
	<p>Big searchable table of ALL "active" fees in the merged database (latest version as of October 1, 2020).  The Excel download includes more columns not shown here.</p>
	 	<form action = "downloadExcel.cfm" id = "excelForm" format = "html" method = "POST" >
	 		<input type="submit" id="submitExcel" name="submitMaster" value="Excel Download">
	 	</form>
	 	<hr width="100%">
 		<h3>Fee List <cfif currentlyActive neq 'All'> for #AllFeeData.INST_CD#</cfif></h3>
	 	<form action = "fee_rate_update.cfm" id = "AllFeesFormV9" method = "POST" >
	 		<cfloop list="#StructKeyList(feeTypeList)#" index="i">
	 			<cfif (i eq 'All' and role eq 'campus') or i neq 'All'>
		 		<input type="radio" id="radioBtn#i#" name="feetypechoice" value="#i#" <cfif LCase(i) eq LCase(currentlyActive)>checked="checked"</cfif>> <label for="radioBtn#i#">#i#</label>
		 		</cfif>
 			</cfloop><br>
 			<input id="save_btn" type="submit" name="save_btn" value="Save"></input>
	 		<span class="change_warning">You have unsaved changes. Be sure to "Save" your work!</span>
				<table id="masterTable" class="allFeesTable">
					<thead>
						<tr>
							<th>Unique ID</th>
							<th>Fee Description</th>
							<th>Current<br>FY21 rate</th>
							<th>FY22 Rate</th>
							<th>FY23 Rate</th>
							<th>Fee Status</th>
							<th>Fee Owner</th>
							<th>Revenue Account/Obj Cd</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#AllFeeData#">
							<cfif ListFindNoCase(feeTypeList[currentlyActive],fee_type) OR currentlyActive eq 'All'>
					    		<tr>
					    			<td>#AllFeeData.ALLFEE_ID#<br>
										<span class="sm-blue">
	<!---<a href="fee_change_request.cfm?ALLFEE_ID=#AllFeeData.ALLFEE_ID#">Update</a><br>---> #AllFeeData.FEE_TYP_DESC# 
										</span>
					    		</td>
									<td>
										#AllFeeData.FEE_DESC_LONG#<br>
										<span class="sm-blue">(#AllFeeData.UNIT_BASIS#)
											<cfif Len(cohort) gt 0> - #cohort# cohort</cfif>
										</span>
									</td>
									<td class="right-justify">#DollarFormat(AllFeeData.fee_current)#</td>
									<td><cfif editingEnabled and !ListFindNoCase(closedList, fee_type)>
										<input id="fee_lowyear-#AllFeeData.ALLFEE_ID#"
										   name="fee_lowyear-#AllFeeData.ALLFEE_ID#"
										   class="right-justify" value="#AllFeeData.fee_lowyear#" />
										<input id="fee_lowyear-#AllFeeData.ALLFEE_ID#DELTA"
										     name="fee_lowyear-#AllFeeData.ALLFEE_ID#DELTA"
										     type="hidden" value="NO" />
										<cfelse>
										   #AllFeeData.fee_lowyear#
										</cfif>
									</td>
									<td><cfif editingEnabled and !ListFindNoCase(closedList, fee_type)>
										<input id="fee_highyear-#AllFeeData.ALLFEE_ID#"
										   name="fee_highyear-#AllFeeData.ALLFEE_ID#"
										   class="right-justify" value="#AllFeeData.fee_highyear#" />
										<input id="fee_highyear-#AllFeeData.ALLFEE_ID#DELTA"
										     name="fee_highyear-#AllFeeData.ALLFEE_ID#DELTA"
										     type="hidden" value="NO" />
										<cfelse>
										   #AllFeeData.fee_highyear#
										</cfif>
									</td>
									<td>
		<cfif editingEnabled and !ListFindNoCase(closedList, fee_type)>
			<select id="fee_status-#AllFeeData.ALLFEE_ID#" name="fee_status-#AllFeeData.ALLFEE_ID#" class="approval_dropdown target">
		 		<cfloop list="#roleFeestatus[LCase(role)]#" index="fs">
		 			<cfif LCase(AllFeeData.FEE_STATUS) eq LCase(fs)><cfset option_sel = "selected" /><cfelse><cfset option_sel = "" /></cfif>
		  			<option value="#fs#" selected="#option_sel#">#fs#</option>
			  	</cfloop>
			</select>
			<input id="fee_status-#AllFeeData.ALLFEE_ID#DELTA" name="fee_status-#AllFeeData.ALLFEE_ID#DELTA" type="hidden" value="NO" />
		<cfelse>#AllFeeData.fee_status#</cfif>
									</td>
									<td>#AllFeeData.FEE_OWNER#
									<cfif StructKeyExists(application.rcNames,FEE_OWNER)>#application.rcNames[FEE_OWNER]#</cfif></td>
									<td>
										#AllFeeData.ACCOUNT_NBR#<br><span class="sm-blue">#AllFeeData.OBJ_CD#</span>
									</td>
					    		</tr>
					    		<!---<input type="hidden" name="ALLFEE_ID" value="#AllFeeData.ALLFEE_ID#" />--->
		</cfif>
			    	</cfloop>  <!--- End of main query loop --->
			    	</tbody>
				</table>
				<input id="save_btn" type="submit" name="save_btn" value="Save"></input>
	 			<span class="change_warning">You have unsaved changes. Be sure to "Save" your work!</span>
		</form>
</cfoutput>

</div>  <!-- End DIV class "full_content" -->
<cfinclude template="../includes/header_footer/allfees_footer.cfm" runonce="true" />
