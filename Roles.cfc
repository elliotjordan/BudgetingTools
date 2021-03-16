<!--- 
	file:	Users.cfc
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	04-13-14
	update:	04-13-14
	note:	Component to match Oracle table in 'fee' datasource.  ORM is enabled in this application.
 --->
<cfcomponent displayname="Roles" hint="Object representation of the Roles table in the 'fee' database" persistent="true" output="false">
	<cfproperty name="id" column="id" datatype="integer" length="10" notnull="true" required="true" generated="always" />
	<cfproperty name="role_code" column="role_code" datatype="integer" length="8" notnull="true" required="true" />
	<cfproperty name="description" column="description" datatype="string" length="64" notnull="false" />
	
	<cffunction name="init" hint="Constructor" access="public" returntype="Roles" output="false"> 
		<cfargument name="id" hint="the id of the Role" type="numeric" required="false"  /> 
		<cfargument name="role_code" hint="the role_code of the Role, i.e., Admin = 1" type="string" required="false" default="" /> 
		<cfargument name="description" hint="the description of the person" type="string" required="false" default="" /> 
		<cfscript> 
 			setRole_code(arguments.role_code); 
			setDescription(arguments.description);
			return this; 
		</cfscript> 
	</cffunction>
</cfcomponent>