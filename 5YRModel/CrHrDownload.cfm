<cfinclude template="../includes/functions/fym_functions.cfm" runonce="true" />
<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />

<cfset crHrsDown = getFYM_CrHrdata(current_scenario, current_inst) />

<cfdump var="#crHrsDown.columnList#" />

<!---
	Create and store the simple HTML data that you want
	to treat as an Excel file.
--->
<cfsavecontent variable="strExcelData">
	<style type="text/css">
		td {
			font-family: "times new roman", verdana ;
			font-size: 11pt ;
			border: 0.5pt solid black;
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
				<td class="header">OID</td>
				<td class="header">Fiscal Year</td>
				<td class="header">Inst Cd</td>
				<td class="header">Inst Desc</td>
				<td class="header">Chart Cd</td>
				<td class="header">Chart Desc</td>
				<td class="header">Acad Career</td>
				<td class="header">Residency</td>
				<td class="header">Sort</td>
				<td class="header">FY#application.shortfiscalyear# Original Hrs</td>
				<td class="header">FY#application.shortfiscalyear# Original Rate</td>
				<td class="header">FY#application.shortfiscalyear# Original Revenue</td>
				<td class="header">FY#application.shortfiscalyear# Hours</td>
				<td class="header">FY#application.shortfiscalyear# New</td>
				<td class="header">FY#application.shortfiscalyear# Rate</td>
				<td class="header">FY#application.shortfiscalyear# Revenue</td>
				<td class="header">FY#application.shortfiscalyear + 1# Hrs</td>
				<td class="header">FY#application.shortfiscalyear + 1# New</td>
				<td class="header">FY#application.shortfiscalyear + 1# Rate</td>
				<td class="header">FY#application.shortfiscalyear + 1# Revenue</td>
				<td class="header">FY#application.shortfiscalyear + 2# Hrs</td>
				<td class="header">FY#application.shortfiscalyear + 2# New</td>
				<td class="header">FY#application.shortfiscalyear + 2# Rate</td>
				<td class="header">FY#application.shortfiscalyear + 2# Revenue</td>
				<td class="header">FY#application.shortfiscalyear + 3# Hrs</td>
				<td class="header">FY#application.shortfiscalyear + 3# New</td>
				<td class="header">FY#application.shortfiscalyear + 3# Rate</td>
				<td class="header">FY#application.shortfiscalyear + 3# Revenue</td>
				<td class="header">FY#application.shortfiscalyear + 4# Hrs</td>
				<td class="header">FY#application.shortfiscalyear + 4# New</td>
				<td class="header">FY#application.shortfiscalyear + 4# Rate</td>
				<td class="header">FY#application.shortfiscalyear + 4# Revenue</td>
				<td class="header">FY#application.shortfiscalyear + 5# Hrs</td>
				<td class="header">FY#application.shortfiscalyear + 5# New</td>
				<td class="header">FY#application.shortfiscalyear + 5# Rate</td>
				<td class="header">FY#application.shortfiscalyear + 5# Revenue</td>

		</tr>
		<cfloop query="crHrsDown">
			<tr>
				<td>#OID#</td>
				<td>#CUR_FIS_YR#</td>
				<td>#INST_CD#</td>
				<td>#INST_DESC#</td>
				<td>#CHART_CD#</td>
				<td>#CHART_DESC#</td>
				<td>#ACAD_CAREER#</td>
				<td>#RES#</td>
				<td>#SORT#</td>
				<td>#CUR_YR_ORIG_HRS#</td><td>#CUR_YR_ORIG_RT#</td><td>#PRV_YR_REV#</td>
				<td>#CUR_YR_HRS#</td><td>#CUR_YR_HRS_NEW#</td><td>#CUR_YR_RT#</td><td>#CUR_YR_REV#</td>
				<td>#YR1_HRS#</td><td>#YR1_HRS_NEW#</td><td>#YR1_RT#</td><td>#YR1_REV#</td>
				<td>#YR2_HRS#</td><td>#YR2_HRS_NEW#</td><td>#YR2_RT#</td><td>#YR2_REV#</td>
				<td>#YR3_HRS#</td><td>#YR3_HRS_NEW#</td><td>#YR3_RT#</td><td>#YR3_REV#</td>
				<td>#YR4_HRS#</td><td>#YR4_HRS_NEW#</td><td>#YR4_RT#</td><td>#YR4_REV#</td>
				<td>#YR5_HRS#</td><td>#YR5_HRS_NEW#</td><td>#YR5_RT#</td><td>#YR5_REV#</td>
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
	Set the header so that the browser request the user
	to open/save the document. Give it an attachment behavior
	will do this. We are also suggesting that the browser
	use the name "phrases.xls" when prompting for save.
--->
<cfheader name="Content-Disposition" value="attachment; filename=5YRModel_fym_data.xls" />


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
	<cfcontent type="application/msexcel" reset="true" />
	<!--- Write the output. --->
<cfset WriteOutput( strExcelData.Trim() ) /><cfexit />


<cfelseif StructKeyExists( URL, "file" )>

	<!---
		We are going to stream the excel data to the browser
		using a file stream from the server. To do this, we
		will have to save a temp file to the server. We delete it later.
	--->

	<!--- Get the temp file for streaming. --->
	<cfset strFilePath = GetTempFile( GetTempDirectory(), "excel_" ) />

	<!--- Write the excel data to the file. --->
	<cffile action="WRITE" file="#strFilePath#" output="#strExcelData.Trim()#" />

	<cfcontent type="application/msexcel" file="#strFilePath#" deletefile="true" />

<cfelse>
	<cfcontent type="application/msexcel" variable="#ToBinary( ToBase64( strExcelData.Trim() ) )#" />

</cfif>
<cflocation url="CrHrProjections.cfm" addtoken="false" statuscode="200">