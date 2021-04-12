<cfoutput>
	<div class="full_content">
		<h3>V1 Creation Begins Here</h3> <!---<cfdump var="#reportSelect.recordCount#"><cfabort>--->
	<p>If you see this message, something has gone wrong.  If you would, please send us a screen capture and let us know right away.  Thank you!  Sorry for the trouble.</p>	
	<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"--",9,"#REQUEST.AuthUser# began V1 download") />
	<!--- <cfset VcTemplate = ExpandPath('templates\B325_Student_Fee_Revenue_Vc_template.xlsx') />	--->
	<cfset VcTemplate = ExpandPath('templates\B325_Student_Fee_Revenue_Vc_template.xlsx') />
	<cfset V1Template = ExpandPath('templates\B325_Student_Fee_Revenue_V1_template.xlsx') />	
		<h4>#application.rateStatus# PATH: 
		  <cfif application.rateStatus eq "Vc">
		  	#VcTemplate#
		  <cfelse>
		    #V1Template#
		  </cfif>
		</h4>
		reportSelect.recordCount is #reportSelect.recordCount#
		<!--- Uncomment the line below to see the error without the try catch --->
	<!---<cfspreadsheet action="read" src = "#V1Template#" headerrow="1" name="jwb"> --->
	<cfscript>
		try {
			if (application.rateStatus eq "Vc") {
				jwb = SpreadSheetRead(VcTemplate)
			} else {
				jwb = SpreadSheetRead(V1Template)
			}
		    SpreadSheetSetActiveSheet(jwb,"RawData");
		    SpreadsheetDeleteRows(jwb,"4-4000");
		    SpreadsheetAddRows(jwb, reportSelect,4,1,true);
		    SpreadSheetSetActiveSheet(jwb,"Title");
		} catch (any e) {
			dismantleError(e);
			abort;
		}
	</cfscript>
		<!--- header - Workbook name is set here, sheet name is set in function --->
		<cfif application.rateStatus eq "Vc">
			<cfset filenameString = "B325_StudentFeeRevenue_Vc" />
		<cfelse>
			<cfset filenameString = "B325_StudentFeeRevenue_V1" />
		</cfif>

		<cfif IsDefined("reportLevel")>
			<cfset filenameString = filenameString & reportLevel /> 
		</cfif>
		<cfset filenameString = filenameString & "_Report.xlsx" />
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"--",9,"#REQUEST.AuthUser#  downloaded #filenameString#") />
		<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
		<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(jwb)#">		
</cfoutput>