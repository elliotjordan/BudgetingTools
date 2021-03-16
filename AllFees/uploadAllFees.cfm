<!---  This is bare bones now, it's just a tool so you can open an excel file from the filesystem into memory, 
then compare it by AllFeeID to the contents of the All Fee database table, mark rows for update, then update the table
based on whatever file you just approved for upload.  If the AllFeeID is not found, it can be marked for insertion.

The metadata table will record the details with an entry for every line updated this way. --->
<cfinclude template="../includes/functions/fee_rate_functions.cfm" />
<h2>All Fees Table Maintenance Page</h2>
<cfdump var="#form#">
<cfif IsDefined("form") and StructKeyExists(form,"XLSFILE")>
	<!---<cfdump var="#FORM#" >--->  <!---<cfabort>--->

	<!--- Use cfspreadsheet to open the XLSFILE and look for AllFeeIDs in the leftmost column --->  
<!--- Read all or part of the file into a spreadsheet object, CSV string, 
      HTML string, and query.  
	<cfspreadsheet action="read" src="#theFile#" sheetname="courses" name="spreadsheetData"> 
	<cfspreadsheet action="read" src="#theFile#" sheet=1 rows="3,4" format="csv" name="csvData"> 
	<cfspreadsheet action="read" src="#theFile#" format="html" rows="5-10" name="htmlData"> 
	<cfspreadsheet action="read" src="#theFile#" sheetname="centers" query="queryData"> 	
	
	--->
	<!-- Read  --> 
	<cfspreadsheet action="read" src="#form.XLSFILE#" headerrow="#form.headerLine#" sheet="1" query="slurpedFile"> 	
<cfoutput>	
	<h2>Valid Matches</h2>
	<p><i>db Header - Excel Column Header - Excel column number</i></p>
	<cfset feeColumnNames = getAllFeesColumnNames()>
	<cfset validColumns = compareUploadHeaders(feeColumnNames,slurpedFile.ColumnList)>
	<cfdump var="#validColumns#" >
	<!---<h2>All Columns</h2>--->
	<!---<cfdump var="#feeColumnNames#">--->
	<!---<h2>Excel Column Headers</h2>--->
	<!---<cfdump var="#slurpedFile#" >--->
	
	<cfloop query="#slurpedFile#" startrow="#form.headerLine#">
		<cfloop collection="#validColumns#" item="i">
			<p>#i# - #ListGetAt(slurpedFile.ColumnList,validColumns[i])# - #validColumns[i]# - #allfee_id#</p>
			<p>#i#</p>
		</cfloop>
	</cfloop>
	<cfabort>
</cfoutput>

</cfif>
