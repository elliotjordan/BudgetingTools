<cfcomponent displayname="Student" hint="Student object component">

	<cfproperty name="name" type="string"/>
	<cfproperty name="age" type="numeric"/>

	<!--- Getting the student detail. --->
	<cffunction name="getStudent" access="remote" returntype="String" httpmethod="GET" produces="text/xml">
		<!--- Retrieve the Student from the DB. --->
		<!--- get student from db where name and age matches --->
		<cfset st.name = "Thomas">
		<cfset st.age = "25">
		<cfset st.surname = "Paul">
		<cfset str = "<student><name>" & st.name & "</name><age>" & st.age & "</age><surname>" & st.surname & "</surname></student>">
		<cfreturn str>
	</cffunction>

	<!--- Updating the student detail. --->
	<cffunction name="updateStudent" access="remote" returntype="void" httpmethod="PUT">
		<!--- Retrieve the Student from the DB. --->
		<!--- Update the student in DB. --->
		<cfset st.name = name>
		<cfset st.age = age>
	</cffunction>

	<!--- Deleting the student. --->
	<cffunction name="deleteStudent" access="remote" returntype="String" httpmethod="DELETE">
		<!--- Delete the Student from the DB. --->
		<!---<cfset st = deleteStudentFromDB(name)>--->
		<cfreturn "Student deleted">
	</cffunction>
</cfcomponent>