<!--- 
	file:	Users.cfc
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	11-19-14
	update:	11-19-14
	note:	Component to match Oracle table in 'fee' datasource.  ORM is enabled in this application.
 --->
<cfcomponent entityname="USERS" displayname="Users" hint="Users table in the 'fee' database" persistent="true" table="USERS" output="false">
	<cfproperty name="id" column="id" fieldtype="id" elementtype="numeric" length="10" notnull="true" generator="sequence" sequence="fee_user.feeusers_seq" />
	<cfproperty name="empl_id" column="empl_id" datatype="string" length="10" notnull="true" />
	<cfproperty name="username" column="username" datatype="string" length="8" notnull="true" />
	<cfproperty name="first_last_name" column="first_last_name" datatype="string" length="64" notnull="true" />
	<cfproperty name="email" column="email" datatype="string" length="64" notnull="false" />
	<cfproperty name="phone" column="phone" datatype="string" length="16" notnull="false" />
	<cfproperty name="created_on" column="created_on" fieldtype="timestamp" source="db" notnull="true"/>
	<cfproperty name="description" column="description" datatype="string" length="64" notnull="false" />
	<cfproperty name="access_level" column="access_level" datatype="string" length="8" notnull="true" />
	
	<cffunction name="init" hint="Constructor" access="public" returntype="Users" output="false"> 
		<!---<cfargument name="id" hint="Internal ID used by CF ORM" type="numeric" required="no" />--->
		<cfargument name="empl_id" hint="the empl_id " type="string" required="false" default="" /> 
		<cfargument name="username" hint="the username " type="string" required="false" default="" /> 
		<cfargument name="first_last_name" hint="the name " type="string" required="false" default="" /> 
		<cfargument name="email" hint="the email " type="string" required="false" default="" /> 
		<cfargument name="phone" hint="the phone " type="string" required="false" default="" /> 
		<cfargument name="created_on" hint="the date and time the person was added to our system" required="false" default="" /> 
		<cfargument name="description" hint="the description " type="string" required="false" default="" /> 
		<cfargument name="access_level" hint="the user's access level" ormtype="string" required="false" default="guest" /> <!--- "guest" user_id does not exist in REF.RC_SEC_T --->
		<cfargument name="chart" hint="the user's campus" ormtype="string" required="false" /> 
		<cfscript> 
			setEmpl_ID(arguments.empl_id); 
			setUsername(arguments.username); 
			setFirst_Last_Name(arguments.first_last_name);
			setEmail(arguments.email);
			setPhone(arguments.phone);
			setCreated_On(arguments.created_on);
			setDescription(arguments.description);
			setAccess_level(arguments.access_level);
			return this; 
		</cfscript> 
	</cffunction>
</cfcomponent>
