<!--- 
	file:	projector_users.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	03-05-18
	update:	
	note:	users page for Fiscal Officers to maintain access privileges for their staff
 --->
<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/revenue_functions.cfm">

<cfset staffMessage = "Enter new users or edit existing users." />
<cfif IsDefined("url") AND StructKeyExists(url,"staffMessage")>
	<cfset staffMessage = url.staffMessage />
</cfif>

<cfif !IsDefined("REQUEST") or !FindNoCase(REQUEST.authuser,REQUEST.adminUsernames)>
	<cfset requestStuff = IsDefined("session") />
	<cfset isDev = FindNoCase(REQUEST.authuser,REQUEST.adminUsernames) />
	<cflocation url="#application.baseurl#?message=You were redirected from the users page for some reason - session:#requestStuff# - #isDev#" addtoken="false" />  
</cfif>

<!--- TODO: Set this up for Campus-level control --->
<!---<cfif NOT ListFindNoCase(REQUEST.campusFOusernames,REQUEST.authuser)>--->
<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authuser)>  <!--- For right now, though, just set it up for the UBO admins --->
	<cfset userList = getUsersByCampus() />
<cfelse>
	<cfset userList = getUser(REQUEST.authuser) />
</cfif>

<cfoutput>
		<h2>Credit Hour and Revenue Projector<br>Add New User</h2>
		<p>#staffMessage#</p>
		<cfform action = "includes/forms/update_users.cfm" format = "html"  
		    id = "HTML id" method = "POST" name = "userUpdateForm"
		    preloader = "no" preserveData = "yes" 
		    timeout = "1200" width = "800" wMode = "opaque" > 
		    
		    <table id="addUserTable" class="">	
		    	<thead>
					<tr>
						<th>Username</th>
						<th>Name</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Description</th>
						<th>Access Level</th>
						<th>Default Login RC</th>
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
						<cfinput size="12" name="new_accesslevel" maxlength="8" />
					</td>
					<td>
						<cfinput size="6" name="new_loginRC" maxlength="2" />
					</td>
    			</tr>
    			</tbody>
			</table>
			<p><cfinput type="submit" name="Submit" value="Add New User"  /></p>
		</cfform>	
		
		<!--- Intermission! Intermission! --->
		<h2>Current Users</h2>
		<p>These are the users who have access for your campus.  You can control who has access by changing these records. We never really "delete" anyone, we just make "active" equal "N".  Handle with care!</p>
		<cfform action = "includes/forms/insert_userUpdates.cfm" format = "html"  
		    id = "updateUser" method = "POST" name = "userUpdateForm" preloader = "no" preserveData = "yes" 
		    timeout = "1200" width = "800" wMode = "opaque" > 
	    
			<table id="usersTable" class="feeCodeTable">	
				<thead>
					<tr>
						<th>Username</th>
						<th>Name</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Description</th>
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
			  				<td>
								<cfinput size="12" name="Username" maxlength="8" value="#userList.USERNAME#" message="Username" />
							</td>
			  				<td>
								<cfinput size="32" name="FIRST_LAST_NAME" maxlength="64" value="#userList.FIRST_LAST_NAME#" message="Full name" />
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
			<p><cfinput type="submit" name="SubmitUserUpdates" value="Update Users" /></p>
		</cfform>
</cfoutput>

<cfinclude template="../includes/header_footer/footer.cfm">