<!--- adding the student --->
<cfhttp url="http://localhost:8500/rest/RestTest/studentService" method="post" result="res">
	<cfhttpparam type="formfield" name="name" value="Thomas" >
	<cfhttpparam type="formfield" name="age" value="25" >
</cfhttp>

<cfoutput>Student Added</cfoutput>
</br>
</br>

<!--- fetching the details --->
<cfhttp url="http://localhost:8500/rest/RestTest/studentService/Thomas-25" method="get" result="res">
</cfhttp>
<cfoutput>#xmlformat(res.filecontent)#</cfoutput>
</br>
</br>

<!--- updating the student details --->
<cfhttp url="http://localhost:8500/rest/RestTest/studentService/Thomas-25" method="put" result="res">
</cfhttp>
<cfoutput>Updated the student</cfoutput>
</br>
</br>

<!--- deleting the student --->
<cfhttp url="http://localhost:8500/rest/RestTest/studentService/Thomas-25" method="delete" result="res">
</cfhttp>
<cfoutput>Student Deleted</cfoutput>