<cfinclude template="../includes/functions/bi_revenue_functions.cfm" />
<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>
<cfoutput>
	<!--- User has asked for the Excel download. --->
	<cfif IsDefined("form") AND StructKeyExists(form,"dwnldBtn")>
		<cfset ExcelSelect = getProjectinatorData(urlCampus, urlRC,application.rateStatus,"excel")>  
		<cfinclude template="export_to_excel.cfm" runonce="true" />
		<cfabort>
	
	<!--- User has asked for a Vc/V1 report. --->
	<cfelseif IsDefined("form") AND StructKeyExists(form,"reportBtn")>
		<cfsetting enablecfoutputonly="Yes">  
		<cfset reportLevel = "_" & urlCampus & "_RC" & form.urlrc />
		 <cfif application.rateStatus eq "Vc">
		  	<cfset reportSelect = getB325_Vc_Campus_data(urlCampus, urlRC, true)> 
		  <cfelse>
		    <cfset reportSelect = getB325_V1_Campus_data(urlCampus, urlRC, true)> 
		  </cfif>

	   	<cfif IsDefined("reportSelect") AND reportSelect.recordcount GT 0>
			<cfinclude template="V1_creation.cfm" runonce="true" />
		<cfelse>
			<h3>We are sorry, but no records were returned.</h3>
	   	</cfif>
	<cfelseif IsDefined("form") AND StructKeyExists(form,"vtype")>
		<cfset application.rateStatus = form.vtype >
	</cfif>	
	<!--- Prepend the projHours_yrX column name wiht the appropriate b1 or b2 value  --->
	<cfif application.budget_year eq 'YR1'>
		<cfset columnLeadValue = 'b1_'>
	<cfelse>
		<cfset columnLeadValue = 'b2_'>
	</cfif>
	
<h2>Projectinator Update</h2>
<cfif IsDefined("form") and StructKeyExists(form,"submitBtn")> 
	<cfloop index="i" list="#Form.FieldNames#" delimiters=",">
		<cfif Form[i] eq true>
			Form[i]: #Form[i]# <br />
			<cfset rootID = REPLACE(i,"DELTA","") />  
			rootID: #rootID#  <br />
   			<cfset cutParam = rootID.split("OID")  />
   			cutParam: #cutParam# <br/>
   			<cfset activeColumn = LCase(columnLeadValue & cutParam[1]) />
   			activeColumn: #activeColumn# <br /> 
			<cfset activeOID = cutParam[2] /> 
			activeOID: #activeOID# <br />   
  			<cfset scrubbedValue =  REREPLACE(Form[rootID],"[^0-9.\-]","","ALL") />  
  			REGULAR FIELD #rootId# Form[i] #form[i]# - activeColumn #activeColumn# - <b>scrubbedValue: #scrubbedValue#</b><br>    
  			<h2>NOTE: IF YOU SEE THIS ERROR PAGE!</h2>
  			<p>For each of your changes, on the line above, there is a reference to a "scrubbedValue". If your number is there, 
  			then we saved it. However, if there is no number there, it means you tried to save an empty space. 
  			We don't add in a zero by default because we worry that you accidentally deleted a real number. Hit the back button and re-enter your numbers, 
  			being careful not to submit or save any empty credit hour figures. Sorry for the trouble!</p>
			<cfset updateFeeInfo(activeOID,activeColumn,scrubbedValue) /> 
	   		<br>Updating metadata now...<br> 
			<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#url.Campus#,7,"#REQUEST.AuthUser# at #url.Campus# RC #url.RC# updated #activeColumn# OID #activeOID# to #scrubbedValue# CrHrs") />
	   </cfif>
	</cfloop> 
<cfelse>
	<p>Error. Please contact us and explain that you got the "Projectinator Update error". Sorry for the trouble! Thanks</p> <cfabort>
</cfif>
 
	<cfset returnString = "revenue_RC.cfm?Campus=" & #Form['urlCampus']# & "&RC=" & #Form['urlRc']# />
	<cflocation url= #returnString# addToken="false" />
</cfoutput>