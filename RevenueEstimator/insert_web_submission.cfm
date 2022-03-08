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
			<cfdump var="#form#" >
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
  			REGULAR FIELD #rootId# Form[i] #form[i]# - activeColumn #activeColumn# - scrubbedValue #scrubbedValue#<br>    
			<cfset updateFeeInfo(activeOID,activeColumn,scrubbedValue) /> 
	   		<br>Updating metadata now...<br>
			<!---<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #Form['urlCampus']'# RC #Form['urlRC']# updated b2_projhrs_Yr2 FC #currentFeeCode# #currentSelgroup# OID #currentOID# for term #fee_term# sesn #currSESN# to #Fee_projhrs_Yr2# CrHrs") />
--->	   </cfif>
	</cfloop>  <cfabort>
<cfelse>
	<p>Error. Please contact us and explain that you got the "Projectinator Update error". Sorry for the trouble! Thanks</p> <cfabort>
</cfif>
 
	<cfset returnString = "revenue_RC.cfm?Campus=" & #Form['urlCampus']# & "&RC=" & #Form['urlRc']# />
	<cflocation url= #returnString# addToken="false" />
</cfoutput>