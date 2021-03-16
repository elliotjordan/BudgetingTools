<!--- example report  --->

<!--- 
   For simplicity, we are going to create a basic Excel file which sits on the server called report.xlsx.
   That report.xlsx will contain a simple table with two columns, named "FEECODE" and "FC_RATE".
   
   IMPORTANT NOTE: If you create a new template, remember to right click your pivot table(s) and choose
		pivotTable Options->Data-> Refresh Data when opening File
		This property will propagate forward from the template when this process creates the updated file.
		
   On a separate tab, the report_tempalte.xlsx will have a simple pivot table showing FEECODE in rows and RATES in columns.
   We start with five values - UGRDR, UGRDNR, GRADR, GRADNR, and INFOR.
   The rates for these five will be set at $0 in the template.
   CF will open the file, read from HOURS_TO_PROJECT, update those rates to the correct values, then write a new file.
   Current state of the data page will be displayed in the interface.
   The test is to see a) whether we can do that and b) whether the pivot tables are automatically updated.
   Further tests will be developed, such as adding a sixth line and seeing whether the pivot table range is updated, etc.
--->

<cfinclude template="../includes/header_footer/header.cfm">
<cfoutput>
	<h2>Report Test Page</h2>
	<p>Simple example of ColdFusion Excel file manipulation.</p>

<!--- Ben Nadel code example  --->
<!---  POI docs are at https://poi.apache.org/spreadsheet/quick-guide.html  --->
<!---
	Create an array to hold data that we are going to use to populate the existing Excel sheet. 
	This array will be an array of arrays representing rows of columns.
--->
<cfset arrData = ArrayNew( 1 ) />

<!---
	Populate the data array. To do this, we will just convert
	several lists to arrays. Each of these lists will represent
	the columns within a given row.
--->
<cfset arrData[ 1 ] = ListToArray(
	"FEECODE,RATE"
	) />

<cfset arrData[ 2 ] = ListToArray(
	"UGRDR,100"
	) />

<cfset arrData[ 3 ] = ListToArray(
	"UGRDNR,200"
	) />

<cfset arrData[ 4 ] = ListToArray(
	"GRADR,300"
	) />

<cfset arrData[ 5 ] = ListToArray(
	"GRADNR, 400"
	) />

<cfset arrData[ 6 ] = ListToArray(
	"INFOR,500"
	) />


<!---
	Now that our data arary is populated we can go about creating the Excel workbook. When we create this Workbook,
	we are going to read in an existing Excel sheet that already has set formatting. Read in the Excel file using
	a File Input Stream.
--->
<cfset objWorkBook = CreateObject(
	"java",
	"org.apache.poi.hssf.usermodel.HSSFWorkbook"
	).Init(

	<!--- Create the file input stream. --->
	CreateObject(
		"java",
		"java.io.FileInputStream"
		).Init(

		<!--- Create the file object. --->
		CreateObject(
			"java",
			"java.io.File"
			).Init(

			ExpandPath( "./report_template.xls" )

			)
		)
	) />


<!---
	Now that we have read the existing Excel file into the WorkBook, let's get the first sheet. This is the sheet
	to which we will be writing data, but mainting the current format.
--->
<cfset objSheet = objWorkBook.GetSheetAt(
	JavaCast( "int", 0 )
	) />


<!---
	Loop over the rows in the data array to start populating the Excel file with data.
--->
<cfloop
	index="intRow"
	from="1"
	to="#ArrayLen( arrData )#"
	step="1">

	<!---
		Get a pointer to the current row. This will make referencing it easier as we make are way through
		the data. Remember that our ColdFusion array is one-based, but the rows index is Java and zero-based.
	--->
	<cfset objRow = objSheet.GetRow(
		JavaCast( "int", (intRow - 1) )
		) />

	<!---
		Loop through the "column" values in our data array (for this row index).
	--->
	<cfloop
		index="intColumn"
		from="1"
		to="#ArrayLen( arrData[ intRow ] )#"
		step="1">

		<!---
			Get the cell object whose value we want to set.  Remember that while ColdFusion is one-based, the index of the cell is zero-based.
		--->
		<cfset objCell = objRow.GetCell(
			JavaCast( "int", (intColumn - 1) )
			) />


		<!---
			For this example, we know that one of the columns is numeric. We could have just set the value based 
			on the column index, but I have chosen to go with a simple numeric check.
		--->
		<cfif IsNumeric( arrData[ intRow ][ intColumn ] )>

			<!---
				Set the numeric value. We are setting it as a float, but the API and the existing Excel
				formatting will take care of the display.
			--->
			<cfset objCell.SetCellValue(
				JavaCast(
					"float",
					arrData[ intRow ][ intColumn ]
					)
				) />

		<cfelse>

			<!--- Set the string value. --->
			<cfset objCell.SetCellValue(
				JavaCast(
					"string",
					arrData[ intRow ][ intColumn ]
					)
				) />

		</cfif>

	</cfloop>

</cfloop>


<!---
	Now that we have populated our existing Excel file with data, let's write the updated Excel data to a new data
	file. We do NOT want to overwrite the pre-formatted file as we want to be able to use that again to created
	pre-formatted Excel sheets.
--->
<cfset objWorkBook.Write(

	<!--- Create the output stream. --->
	CreateObject(
		"java",
		"java.io.FileOutputStream"
		).Init(

		<!--- Create the file object. --->
		CreateObject(
			"java",
			"java.io.File"
			).Init(

			ExpandPath( "./report_exampleResult.xls" )

			)
		)
	) />

<p>The file "report_example.xls" has been written.  Note that we are not doing ANY error checking, and I am not sure how to "close" the file.  Also, 
we probably want to offer the file for download and NOT write it to the server.  TODO!</p>

<cfif IsDefined("FORM") AND StructKeyExists(FORM,"request") >
	<!---<cfdump var="#FORM#">--->
	<cfheader name="Content-Disposition" value="attachment; filename=report_template.xls"> 
	<cfcontent type="application/csv" > 
<cfelseif IsDefined("FORM") AND StructKeyExists(FORM,"request2")>
	<!---<cfdump var="#FORM#">--->
	<cfheader name="Content-Disposition" value="attachment; filename=report_exampleResult.xls"> 
	<cfcontent type="application/csv" > 
</cfif>
<cfform name="download">
	<cfinput type="submit" name="request" value="Download Example Template" >
	<cfinput type="submit" name="request2" value="Download Example Result" >
</cfform>
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">