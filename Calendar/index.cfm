<cfinclude template="cal_header.cfm" runonce="true" />
<cfinclude template="cal_functions.cfm" runonce="true" />
<cfset calItems = getCalendarItems() />

<cfoutput>
<div class="full_content">
<h2>Budget Calendar - FY#application.shortfiscalyear#</h2>
	<p>Calendar stuff goes here</p>
	<p>We have a few goals here:
		<ul>
			<li>Put budget calender items in a database table</li>
			<li>Centalize editing, printing, and publishing to PDF</li>
			<li>Provide infrastructure for simple task management</li>
			<li>Allow for fast UPDATE notifications</li>
			<li>Enable email list mgmt so that updates auto-notify users with an active link to new changes</li>
		</ul>
	</p>
	
	<form name="calForm" action="cal_update.cfm" method="post"> <!--- Notice I avoid "cfform". The CF version of forms stinks --->
		<table id="calItemTbl" class="feeCodeTable">
			<thead>
				<tr>
					<th>Calendar Date</th>
					<th>Item</th>
					<th>Responsible</th>
					<th>Notes</th>
					<th>Update</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<select name="dateSelect">
							<option>-- Date --</option>
						</select>
					</td>
					<td><input name="newCalItem" type="text" placeholder="New calendar item"
					</td>
					<td><input name="newResponsible" type="text" placeholder="Responsible party"></td>
					<td><input name="newCalNote" type="text" placeholder="Notes"></td>
					<td>
						<input name="newCalSubmit" type="submit" value="Save">
					</td>
				</tr>
				<cfloop query="#calItems#">
					<cfif cal_sub_item eq 0>
					<tr>
						<td>#cal_date#</td>
						<td>
							#id# - #cal_item#
							<cfset current_CI = id />
							<br>
							<cfloop query="#calItems#">
								<cfif cal_sub_item eq current_CI> -- #cal_item#<br></cfif>
							</cfloop>
						</td>
						<td>#cal_responsible#</td>
						<td>#cal_note#</td>
						<td><input name="calEdit" type="button" value="Edit"></td>
					</tr>
					</cfif>	
				</cfloop>
			</tbody>
			</tbody>
			
		</table>
	</form>
</div>  <!-- End div class full-content -->
</cfoutput>

<cfinclude template="cal_footer.cfm" runonce="true" />