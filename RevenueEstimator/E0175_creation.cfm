	<h1>E0175 Creation Begins Here</h1>	
	<cfset E0175Template = ExpandPath('templates\E0175_template.xlsx') />			
	<cfspreadsheet action="read" src = "#E0175Template#" headerrow="1" name="e0175"> 
	<cfscript>
		try {
		  SpreadSheetSetActiveSheet(e0175,"SummaryData");
		  SpreadsheetDeleteRows(e0175,"2-4000");
		  // controls datatypes so Excel behaves nicely 
		  //datatype_arr = ["STRING:1-28,30,42-43;NUMERIC:29,31-41;"];
		  //SpreadsheetAddRows(e0175, uirrData,2,1,false,datatype_arr);
		  SpreadsheetAddRows(e0175, uirrData,2,1,false);
		  SpreadSheetSetActiveSheet(e0175,"Title");  //this does not solve the "already data etc." error
		  // you must save the template with the focus in the data page or it will "group" the tabs
		//throw(message="Trying...", detail="xyzpdq");
		} catch (any e) {
			WriteOutput("Error generating E0175 report: " & e.message);
			rethrow;
		}
	</cfscript>
		<!--- header - Workbook name is set here, sheet name is set in function --->
		<cfset filenameString = "UIRR_CreditHoursUsedInBudget" />
		<cfif IsDefined("reportLevel")>
			<cfset filenameString = filenameString & reportLevel /> 
		</cfif>
		<cfset filenameString = filenameString & "_Report.xlsx" />
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,"--",10,"#REQUEST.AuthUser#  downloaded #filenameString#") />
		<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
		<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(e0175)#">		
			
		 
		
