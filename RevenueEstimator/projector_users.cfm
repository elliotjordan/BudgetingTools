<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">

<cfset staffMessage = "Enter new users or edit existing users." />
<cfif IsDefined("url") AND StructKeyExists(url,"staffMessage")>
	<cfset staffMessage = url.staffMessage />
</cfif>

<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authuser)>
	<cfset honorOfGrayskull = true />    <!--- If you are as cool as She-Ra, you get to see the whole list  --->
	<!---<cfset userList = getUsersByCampus("She-Ra") />--->
	<cfset userList = getUsersByCampus("aheeter") />
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
			<p><cfinput type="submit" name="userUpdateBtn" value="Update Users"  /></p>
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
			    			<input name="username" type="hidden" value="#userList.USERNAME#" />
							<td>#id#</td>
			  				<td>
			  					<span class="anchor"></span><a id="anchor" name="#userList.id#"></a>#userList.USERNAME#   
							</td>
			  				<td>
								<cfif honorOfGrayskull><cfinput size="32" name="FIRST_LAST_NAME" maxlength="64" value="#userList.FIRST_LAST_NAME#" message="Full name" />
								<cfelse>#userList.FIRST_LAST_NAME#</cfif>
							</td>
			  				<td>
								<cfinput size="32" name="Email" maxlength="64" value="#userList.Email#" message="Email" />
							</td>
			  				<td>
								<cfinput size="16" name="Phone" maxlength="16" value="#userList.Phone#" message="Phone" />
							</td>
			  				<td>
								<cfinput size="32" name="Description" maxlength="64" value="#userList.Description#" message="Description" />
							</td>
							<td>
								<cfif honorOfGrayskull><cfinput size="6" name="Campus" maxlength="2" value="#userList.chart#" message="Campus" />
								<cfelse>#userList.chart#</cfif>								
							</td>
							<td>
								<cfinput size="6" name="PROJECTOR_RC" maxlength="2" value="#PROJECTOR_RC#"/>
							</td>
							<td>
								<cfinput size="12" name="Accesslevel" maxlength="8" value="#userList.Access_level#" message="Access level" />
							</td>
							<td>
								<cfinput size="12" name="ACTIVE" maxlength="8" value="#userList.ACTIVE#" message="Active" />
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