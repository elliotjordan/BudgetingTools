<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfinclude template="../includes/functions/user_functions.cfm">
<cfoutput>	<cfdump var="#form#" >
<cfif IsDefined("form") and StructKeyExists(form,'newUserBtn')>
	<!--- username,first_last_name,email,phone,description,chart,access_level,projector_rc,active  --->
  <cfscript>
	foundUser = getUsersByCampus(form.new_username,form.new_username);
	if (foundUser.recordCount gt 0) {
		handleUser(form.new_username,form.new_fullname,form.new_email,form.new_phone,form.new_description,form.new_campus,form.new_accesslevel,form.new_loginrc,"Y");    
	}
  </cfscript>
  <cfoutput>
  	<h2><cfdump var="#foundUser#"> was processed.</h2>
  </cfoutput>
<cfelseif IsDefined("form") and StructKeyExists(form,'userUpdateBtn')>
<!--- These lists must all be the same length, otherwise we cannot align the data points properly  --->
	#ListLen(Form.username)# #ListLen(Form.accesslevel)#  #ListLen(Form.active)#  #ListLen(Form.campus)#  #ListLen(Form.projector_rc)#

		<cfset line_count = 1>
		<cfloop list="#Form.username#" index="i">
			<cfset thisUser = ListGetAt(Form.username,line_count)>#thisUser# <br>
	<!---		<cfset Fee_projhrs_Yr1 = ListGetAt(Form.PROJHRS_YR1,line_count)>
			<cfset Fee_projhrs_Yr2 = ListGetAt(Form.PROJHRS_YR2,line_count)>
			<cfset currentFeeCode = ListGetAt(Form.FEECODE,line_count)>
			<cfset currentRC = Form["urlRC"]/>
			<cfset currentChart = Form["urlCAMPUS"] />
			<cfset currentOID = ListGetAt(Form.OID,line_count)>
			<cfset thisFee = getFeeInfo(currentOID)>
			<cfif application.budget_year eq 'YR1'> 
				<cfif trim(thisFee.b1_projhrs_yr1) neq trim(Fee_projhrs_Yr1)>
					<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
					<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated b1_projhours_Yr1 FC #currentFeeCode# for term #fee_term# to #Fee_projhrs_Yr1# CrHrs, b1_projhrs_Yr2 FC #currentFeeCode# for term #fee_term# to #Fee_projhrs_Yr2# CrHrs") />
				</cfif>
			</cfif>
			<cfif trim(thisFee.b2_projhrs_Yr2) neq trim(Fee_projhrs_Yr2)>
				<cfset updateFeeInfo(currentOID,Fee_projhrs_Yr1,Fee_projhrs_Yr2) /> 
				<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#currentChart#,7,"#REQUEST.AuthUser# at #currentChart# RC #currentRC# updated b2_projhrs_Yr2 FC #currentFeeCode# for term #fee_term# to #Fee_projhrs_Yr2# CrHrs") />
			</cfif>--->
			
			<cfset line_count++ >		
		</cfloop>

</cfif>
</cfoutput>