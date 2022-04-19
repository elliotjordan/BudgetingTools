<cfinclude template="cal_header.cfm" runonce="true" />
<cfinclude template="cal_functions.cfm" runonce="true" />
<cfset calItems = getCalendarItems() />
<cfdump var="#calItems#" />
<cfoutput>
<div class="full_content">
<h2>Budget Calendar - FY#application.shortfiscalyear#</h2>
	<p>Calendar instructions go here</p>

	 <!--- Notice I avoid "cfform". The CF version of forms stinks --->
	<form name="calForm" action="cal_update.cfm" method="post">
		<table id="calItemTbl" class="feeCodeTable">
			<thead>
				<tr>
					<th>Calendar Date</th>
					<th>Item</th>
					<th>Responsible</th>
					<th>Notes</th>
					<th>Publish</th>
					<th>Update</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input name="newDateInput" type="date" id="newDateSelector" /></td>
					<td><input name="newCalItem" type="text" placeholder="New calendar item"</td>
					<td><input name="newResponsible" type="text" placeholder="Responsible party"></td>
					<td><input name="newCalNote" type="text" placeholder="Notes"></td>
					<td><input name="newPublishCkb" type="checkbox" value="false" /></td>
					<td><input name="newCalSubmit" type="submit" value="Save"></td>
				</tr>
				<cfloop query="#calItems#">
					<tr>
						<td>#deadline_date#</td>
						<td>#deadline_desc_main#<br>
							#deadline_desc_sub#
						</td>
						<td>#responsible#</td>
						<td>#note#</td>
						<td><input type="checkbox" name="calPublishCkb" value="false" /></td>
						<td>
							<input name="calEdit" type="button" value="Edit">
							<input type="hidden" name="calID" value="#cal_id#">
						</td>
					</tr>
					<!---</cfif>	--->
				</cfloop>
			</tbody>
		</table>
	</form>
</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="cal_footer.cfm" runonce="true" />