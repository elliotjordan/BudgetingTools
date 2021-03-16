<cfif !StructKeyExists(session,"curr_proj_rc")>
	<cfinclude template="loadUser.cfm">
</cfif>

<cfinclude template="../includes/header_footer/allfees_header.cfm" >
<cfinclude template="../includes/functions/fee_rate_functions.cfm" >
<cfset housingList = getHousingList()>
<cfoutput>
<div class="full_content">
	<h2>Housing</h2>
	<p>DRAFT page to handle housing fee details.</p>
	
<cfform action="housing_update.cfm" id="housing_update" format="html" method="POST" preloader="no" preserveData="yes" timeout="1200" width="800" wMode="opaque" >
	<table id="housingTable" class="allFeesTable">
		<thead>
			<tr>
				<th>Unique ID</th>
				<th>Campus</th>
				<th>Fee</th>
				<th>Housing Fee Type</th>
				<th>Current Rate <span class='sm-black'>per semester</span></th>
				<th>FY20 Rate <span class='sm-black'>per semester</span></th>
				<th>FY21 Rate <span class='sm-black'>per semester</span></th>
				<th>Notes</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="housingList">
				<tr>
					<td class="fit">#ALLFEE_ID#</td>
					<td>#INST_CD#</td>
					<td>#FEE_DESC_LONG#</td>
					<td>#META#</td>
					<td class="right-justify">#DollarFormat(NumberFormat(fee_current,'___.__'))#</td>
					<td>
						<input id="FY20" name="Fy20_input" class="right-justify" type="text" value="#fee_lowyear#" size="8" maxlength="8"></input>
					</td>
					<td>
						<input id="FY21" name="FY21_input" class="right-justify" type="text" value="#fee_highyear#" size="8" maxlength="8"></input>
					</td>
					<td>#FEE_NOTE#</td>
					<input id="ALLFEE_ID" name="ALLFEE_ID" type="hidden" value="#ALLFEE_ID#">
				</tr>
			</cfloop>
		</tbody>
	</table>
	<input type="submit" id="housingSubmit" name="housingBtn" value="Submit Housing Updates" />
</cfform>
</div>  <!-- End of class full_content -->
</cfoutput>
<cfinclude template="../includes/header_footer/allfees_footer.cfm" >