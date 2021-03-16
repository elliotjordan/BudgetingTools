			<!---<cfset s = SpreadsheetNew(true)>--->
			<cfspreadsheet action="read" src = "#V1_RC_Template#" headerrow="1" name="jwb">
			<!---<cfspreadsheet action="read" src = "templates\sample.xlsx" sheet="2" headerrow="1" name="jwb">--->
			<cfscript>
				try {
				  SpreadSheetSetActiveSheet(jwb,"RawData");
				  SpreadsheetDeleteRows(jwb,"2-3000");
				  datatype_arr = ["NUMERIC:29-45; STRING:1-28,46-50;"];
				  SpreadsheetAddRows(jwb, reportSelect,2,1,false,datatype_arr);
				  SpreadSheetSetActiveSheet(jwb,"Title");  //this does not solve the "already data etc." error
				  // you must save the template with the focus in the data page or it will "group" the tabs
				//throw(message="Trying...", detail="xyzpdq");
				} catch (any e) {
					WriteOutput("Error generating V1 report: " & e.message);
					rethrow;
				} finally {
					//WriteOutput(" This message should appear no matter what else may happen.");
				}
			</cfscript>   
			<!--- header - Workbook name is set here, sheet name is set in function --->
			<cfset filenameString = "B325_StudentFeeRevenue_V1_" & urlCampus & "_RC" & urlRC & "Report.xlsx">
			<cfheader name="Content-Disposition" value="inline; filename=#filenameString#">   
			<cfcontent type="application/msexcel" variable="#SpreadSheetReadBinary(jwb)#">
