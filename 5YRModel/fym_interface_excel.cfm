<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<!---<cfset modelTotals = getModelExcelDownload(#current_inst#) />  --->
<cfset campusInfo = getFYMdataExcel() /> <!---<cfdump var="#campusInfo#" ><cfabort>--->
<cfset fymCommentList = getFYMcomments() />  <!---<cfdump var="#modelTotals#" ><cfabort>--->
<cfset aggregatedFymData = get_rpt_fym_report_final_model(#current_scenario#,#current_inst#) />

<!---<cfdump var="#campusInfo#" ><cfabort>--->
<!---
	Create and store the simple HTML data that you want
	to treat as an Excel file.
--->
<cfsavecontent variable="strExcelData">
	<style type="text/css">
		td {
			font-family: "times new roman", verdana ;
			font-size: 11pt ;
			}
		td.header {
			background-color: yellow ;
			border-bottom: 0.5pt solid black ;
			font-weight: bold ;
			}
	</style>
<cfoutput>
	<table>
		<tr>
			<!---<td>OIDs - fym - comment</td>--->
			<td class="header">Chart</td>
			<td class="header">Fund</td>
			<td class="header">Rev/Expense</td>
			<td class="header">Sub-fund</td>
			<td class="header">Description</td>
			<td class="header">FY#application.shortfiscalyear# Adj Base Budget</td>
			<td class="header">FY#application.shortfiscalyear#</td>
			<td class="header">FY#application.shortfiscalyear + 1#</td>
			<td class="header">FY#application.shortfiscalyear + 2#</td>
			<td class="header">FY#application.shortfiscalyear + 3#</td>
			<td class="header">FY#application.shortfiscalyear + 4#</td>
			<td class="header">FY#application.shortfiscalyear + 5#</td>
			<td class="header">Notes</td>
	  	</tr>
		</tr>
		<cfloop query="aggregatedFymData">
			<tr>
				<!---<td>#aggregatedFymData.oid#</td>--->
  				<td>#aggregatedFymData.chart_cd#</td>
  				<td>#aggregatedFymData.grp1_desc#</td>
   				<td>#aggregatedFymData.grp2_desc#</td>
				<td>#aggregatedFymData.ln1_desc#</td>
				<td>#aggregatedFymData.ln2_desc#</td>
				<td>#aggregatedFymData.cy_orig_budget_amt#</td>
				<td>#aggregatedFymData.cur_yr_new#</td>
				<td>#aggregatedFymData.yr1_new#</td>
				<td>#aggregatedFymData.yr2_new#</td>
				<td>#aggregatedFymData.yr3_new#</td>
				<td>#aggregatedFymData.yr4_new#</td>
				<td>#aggregatedFymData.yr5_new#</td>
				<td>#aggregatedFymData.fym_comment#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
</cfsavecontent>


<!---
	Check to see if we are previewing the excel data. This
	will output the HTML/XLS to the web browser without
	invoking the MS Excel applicaiton.
--->
<cfif StructKeyExists( URL, "preview" )>

	<!--- Output the excel data for preview. --->
	<html>
	<head>
		<title>Excel Data Preview</title>
	</head>
	<body>
		<cfset WriteOutput( strExcelData ) />
	</body>
	</html>

	<!---
		Exit out of template so that the attachment
		does not process.
	--->
	<cfexit />

</cfif>


<!---
	ASSERT: At this point, we are definately not previewing the
	data. We are planning on streaming it to the browser as
	an attached file.
--->


<!---
	Set the header so that the browser request the user
	to open/save the document. Give it an attachment behavior
	will do this. We are also suggesting that the browser
	use the name "phrases.xls" when prompting for save.
--->
<cfif current_scenario neq 0>
	<cfheader name="Content-Disposition" value="attachment; filename=5YRModel_fym_data_scenario#current_scenario#.xls" />
<cfelse>
	<cfheader name="Content-Disposition" value="attachment; filename=5YRModel_fym_data.xls" />
</cfif>

<!---
	There are several ways in which we can stream the file
	to the browser:

	- Binary variable stream
	- Binary file stream
	- Text stream

	Check the URL to see which of these we are going to end
	up using.
--->
<cfif StructKeyExists( URL, "text" )>

	<!---
		We are going to stream the excel data to the browser
		through the standard text output stream. The browser
		will then collect this data and execute it as if it
		were an attachment.

		Be careful to reset the content when streaming the
		text as you don't want white-space to be part of the
		streamed data.
	--->
	<cfcontent
		type="application/msexcel"
		reset="true"
	/>
	<!--- Write the output. --->
<cfset WriteOutput( strExcelData.Trim() )

	<!---
		Exit out of template to prevent unexpected data
		streaming to the browser (on request end??).
	--->
	/><cfexit />


<cfelseif StructKeyExists( URL, "file" )>

	<!---
		We are going to stream the excel data to the browser
		using a file stream from the server. To do this, we
		will have to save a temp file to the server.
	--->

	<!--- Get the temp file for streaming. --->
	<cfset strFilePath = GetTempFile(
		GetTempDirectory(),
		"excel_"
		) />

	<!--- Write the excel data to the file. --->
	<cffile
		action="WRITE"
		file="#strFilePath#"
		output="#strExcelData.Trim()#"
		/>

	<!---
		Stream the file to the browser. By doing this, the
		content buffer is automatically cleared and the file
		is streamed. We don't have to worry about anything
		after the file as no page content is taken into
		account any more.

		Additionally, we are requesting that the file be
		deleted after it is done streaming (deletefile). Now,
		we don't have to worry about cluttering up the server.
	--->
	<cfcontent
		type="application/msexcel"
		file="#strFilePath#"
		deletefile="true"
		/>


<cfelse>

	<!---
		Bey default, we are going to stream the text as a
		binary variable. By using the Variable attribute, the
		content of the page is automatically reset; we don't
		have to worry about clearing the buffer. In order to
		use this method, we have to convert the excel text
		data to base64 and then to binary.

		This method is available in ColdFusion MX 7 and later.
	--->
	<cfcontent
		type="application/msexcel"
		variable="#ToBinary( ToBase64( strExcelData.Trim() ) )#"
		/>

</cfif>