<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">

<cfset staffMessage = "Enter new users or edit existing users." />
<cfif IsDefined("url") AND StructKeyExists(url,"staffMessage")>
	<cfset staffMessage = url.staffMessage />
</cfif>

<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authuser)>
	<cfset honorOfGrayskull = true />    <!--- If you are as cool as She-Ra, you get to see the whole list  --->
	<cfset userList = getUsersByCampus("She-Ra") />
<cfelse>
	<cfset honorOfGrayskull = false />
	<cfset userList = getUsersByCampus(REQUEST.authuser) />
</cfif>

<span>
	<a href="revenue_RC.cfm">RC Page</a><span> -- </span>
	<a href="revenue_Campus.cfm">Campus Page</a>
	<cfif honorOfGrayskull>
		<span> -- </span><a href="revenue_University.cfm">University Page</a>
	</cfif>	
</span>

<cfoutput>
		<h2>Credit Hour and Revenue Projector<br>Add or Activate Your Users</h2>
		<p>#staffMessage#</p>
		<cfform action = "update_users.cfm" format = "html" id = "HTML id" method = "POST" name = "userUpdateForm" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque" > 
		    <table id="addUserTable" class="">	
		    	<thead>
					<tr>
						<th>Username</th>
						<th>Name</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Description</th>
						<th>Campus</th>
						<th>Access Level</th>
						<th>Default<br>Login RC</th>
						<th>Active</th>
					</tr>
				</thead>
				<tbody>
				<!--- Create the input fields --->
    			<tr>
	  				<td>
						<cfinput size="12" name="new_Username" maxlength="8" />
					</td>
	  				<td>
						<cfinput size="32" name="new_Fullname" maxlength="64" />
					</td>
	  				<td>
						<cfinput size="32" name="new_Email" maxlength="64" />
					</td>
	  				<td>
						<cfinput size="16" name="new_Phone" maxlength="16" />
					</td>
	  				<td>
						<cfinput size="32" name="new_Description" maxlength="64" />
					</td>
					<td>
						<cfinput size="6" name="new_Campus" maxlength="2" />						
					</td>
					<td>
						<cfinput size="12" name="new_accesslevel" maxlength="8" />
					</td>
					<td>
						<cfinput size="6" name="new_loginRC" maxlength="2" />
					</td>
					<td>
						<cfinput size="6" name="new_active" value="Y" />
					</td>
    			</tr>
    			</tbody>
			</table>
			<p><cfinput type="submit" name="newUserBtn" value="Add New User"  /></p>
		</cfform>	
		
		<!--- Intermission! Intermission! --->
		<h2>Current Users</h2>
		<p>These are the users who have access for your campus.  You can control who has access by changing these records. We never really "delete" anyone, we just make "active" equal "N".  Handle with care!</p>
		<cfform action = "update_users.cfm" format = "html" id = "updateUser" method = "POST" name = "userUpdateForm" preloader = "no" preserveData = "yes" timeout = "1200" width = "800" wMode = "opaque" > 
			<p><cfinput type="submit" name="userUpdateBtn" value="Update Users"  /><span class="change_warning">You have unsaved changes!</span></p>
	    	<table id="usersTable" class="feeCodeTable">	
				<thead>
					<tr>
						<th>ID</th>
						<th>Username</th>
						<th>Name</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Description</th>
						<th>Campus</th>
						<th>Default Login RC</th>
						<th>Access Level</th>
						<th>Active</th>
						<th>Date Added</th>
					</tr>
				</thead>
				<tbody>
				<cfloop query="userList">
					<cfif NOT ListFindNoCase(REQUEST.adminUsernames, userList.USERNAME)>
			    		<tr>
			    			
							<td id="ID#userList.id#" name="ID#userList.id#">#userList.id#</td>
			  				<td>#userList.USERNAME#</td>
			  				<td>
								<cfif honorOfGrayskull>
									<cfinput id="FIRST_LAST_NAMEOID#userList.id#" name="FIRST_LAST_NAMEOID#userList.id#" maxlength="64" size="32" value="#userList.FIRST_LAST_NAME#" message="Full name" />
			  						<input id="FIRST_LAST_NAMEOID#userList.id#DELTA"name="FIRST_LAST_NAMEOID#userList.id#DELTA" type="hidden" value="false" />
								<cfelse>#userList.FIRST_LAST_NAME#</cfif>
							</td>
			  				<td>
								<cfinput id="EMAIL#userList.id#" size="32" name="EMAIL#userList.id#" maxlength="64" value="#userList.Email#" message="Email" />
								<input id="EMAIL#userList.id#DELTA"name="EMAIL#userList.id#DELTA" type="hidden" value="false" />
							</td>
							<td>
								<cfinput size="16" name="PHONE#userList.id#" maxlength="16" value="#userList.Phone#" message="Phone" />
								<input id="PHONE#userList.id#DELTA"name="PHONE#userList.id#DELTA" type="hidden" value="false" />
							</td>
			  				<td>
								<cfinput size="32" name="DESCRIPTION#userList.id#" maxlength="64" value="#userList.Description#" message="Description" />
								<input id="DESCRIPTION#userList.id#DELTA"name="DESCRIPTION#userList.id#DELTA" type="hidden" value="false" />
							</td>
							<td>
								<cfif honorOfGrayskull>
									<cfinput size="6" name="CHART#userlist.id#" maxlength="2" value="#userList.chart#" message="Chart" />
									<input id="CHART#userList.id#DELTA"name="CHART#userList.id#DELTA" type="hidden" value="false" />
								<cfelse>#userList.chart#</cfif>								
							</td>
							<td>
								<cfinput size="6" name="PROJECTOR_RC#userList.id#" maxlength="2" value="#PROJECTOR_RC#"/>
								<input id="PROJECTOR_RC#userList.id#DELTA"name="PROJECTOR_RC#userList.id#DELTA" type="hidden" value="false" />
							</td>
							<td>
								<cfinput size="12" name="ACCESS_LEVEL#userList.id#" maxlength="8" value="#userList.Access_level#" message="Access level" />
								<input id="ACCESS_LEVEL#userList.id#DELTA"name="ACCESS_LEVEL#userList.id#DELTA" type="hidden" value="false" />
							</td>
							<td>
								<cfinput size="12" name="ACTIVE#userList.id#" maxlength="8" value="#userList.ACTIVE#" message="Active" />
								<input id="ACTIVE#userList.id#DELTA"name="ACTIVE#userList.id#DELTA" type="hidden" value="false" />
							</td>
				        	<td>#DateTimeFormat(userList.Created_on, "EEE, d MMM yyyy HH:nn:ss Z")#</td>
			    		</tr>
		    		</cfif>
		    		</cfloop>
		    	</tbody>
			</table>
			<p><cfinput type="submit" name="userUpdateBtn" value="Update Users"  /></p>
		</cfform>
</cfoutput>

<cfinclude template="../includes/header_footer/footer.cfm">