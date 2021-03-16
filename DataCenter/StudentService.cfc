<cfcomponent rest="true" restpath="/studentService" displayname="StudentService" hint="RESTful component for student data">

	<cffunction name="addStudent" access="remote" returntype="void" httpmethod="POST">
		<cfargument name="name" type="string" required="yes" restargsource="Form"/>
		<cfargument name="age" type="numeric" required="yes" restargsource="Form"/>
		<!--- Adding the student to data base. --->
	</cffunction>

	<cffunction name="getStudent" access="remote" returntype="student" restpath="{name}-{age}">
		<cfargument name="name" type="string" required="yes" restargsource="Path"/>
		<cfargument name="age" type="string" required="yes" restargsource="Path"/>
		<!--- Create a student object and return the object. This object will handle the request now. --->
		<cfset var myobj = createObject("component", "student")>
		<cfset myobj.name = name>
		<cfset myobj.age = age>
		<cfreturn myobj>
	</cffunction>
</cfcomponent>