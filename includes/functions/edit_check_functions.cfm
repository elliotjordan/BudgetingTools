<!---
	October 16, 2017
	Functions in support of distributed edit checks.
	For questions contact Gary Palmer 
--->

<cffunction name="getCheck06" output="true">
	<cfquery name="getCheck06" datasource="slag">
		SELECT POSITION_NBR, POS_FTE, FIN_COA_CD, ACCOUNT_NBR, SUB_ACCT_NBR, 
		  FIN_OBJECT_CD, FIN_SUB_OBJ_CD, EMPLID, PERSON_NM, APPT_RQST_FTE_QTY, 
		  RPTS_TO_FIN_COA_CD, RPTS_TO_ORG_CD, RC_CD
		FROM CHECK06_TMP01_T
		WHERE POSITION_NBR = '00000767'
		ORDER BY POSITION_NBR ASC, ACCOUNT_NBR ASC
	</cfquery>
	<cfif getCheck06.RecordCount gt 0>
		<cfreturn getCheck06>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getCheck06_byOrg" output="true">
	<cfargument name="POV_org" required="true">
	<cfquery name="get06" datasource="slag">
		SELECT DISTINCT c1.POSITION_NBR, c1.ACCOUNT_NBR, c1.APPT_RQST_FTE_QTY, c1.EMPLID,
			c1.FIN_COA_CD, c1.FIN_OBJECT_CD, c1.FIN_SUB_OBJ_CD, 
			REPLACE(c1.PERSON_NM, ',','  ') "PERSON_NM",
			c1.POS_FTE, c1.RC_CD, c1.RPTS_TO_FIN_COA_CD, c1.RPTS_TO_ORG_CD,
			c1.SUB_ACCT_NBR, c1.UNIV_FISCAL_YR
		FROM CHECK06_TMP01_T c, CHECK06_TMP01_T c1 
		WHERE C.RPTS_TO_ORG_CD = '#POV_org#' 
		  AND c1.position_nbr = c.position_nbr
	</cfquery>

	<!--- The above query is "re"-sorted by doing what CF calls a Query of Query.  --->
	<cfquery name="sortedGet06" dbtype="query">
		SELECT * FROM get06
		ORDER BY POSITION_NBR ASC, ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn sortedGet06>
</cffunction>

<cffunction name="getCheck06_byCampus" output="true">
	<cfargument name="POV_campus" required="true">
	<cfquery name="get06" datasource="slag">
		SELECT DISTINCT c1.POSITION_NBR, c1.ACCOUNT_NBR, c1.APPT_RQST_FTE_QTY, c1.EMPLID,
			c1.FIN_COA_CD, c1.FIN_OBJECT_CD, c1.FIN_SUB_OBJ_CD, 
			REPLACE(c1.PERSON_NM, ',','  ') "PERSON_NM",
			c1.POS_FTE, c1.RC_CD, c1.RPTS_TO_FIN_COA_CD, c1.RPTS_TO_ORG_CD,
			c1.SUB_ACCT_NBR, c1.UNIV_FISCAL_YR
		FROM CHECK06_TMP01_T c, CHECK06_TMP01_T c1 
		WHERE C.RPTS_TO_FIN_COA_CD = '#POV_campus#' 
		  AND c1.position_nbr = c.position_nbr
	</cfquery>

	<!--- The above query is "re"-sorted by doing what CF calls a Query of Query.  --->
	<cfquery name="sortedGet06" dbtype="query">
		SELECT * FROM get06
		ORDER BY POSITION_NBR ASC, ACCOUNT_NBR ASC
	</cfquery>
	<cfreturn sortedGet06>
</cffunction>

<cffunction name="setup_Edit_Check_Excel" hint="Setup details for edit check Excel output" >
	<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
	<cfset sheet = SpreadSheetNew("Position FTE Less Than Funding FTE Sum Across Charts (06)")>		
	<!--- Add Excel title row 1 --->
	<cfset SpreadsheetAddRow(sheet,"Position FTE < Funding FTE sum across charts (06)")>
	<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),1)>
	<cfset SpreadsheetMergeCells(sheet,1,1,1,14)>
	<cfset SpreadsheetSetRowHeight(sheet,1,40)>
	<!--- Add Excel title row 2 --->
	<cfset SpreadsheetAddRow(sheet,"Detailed instructions or special messages can go here.  Have a great day.")>
	<cfset SpreadsheetFormatRow(sheet, setExcelSubTitleFormatting(),2)>
	<cfset SpreadsheetMergeCells(sheet,2,2,1,14)>
	<!--- Add Excel column headers in row 3 --->
	<!---<cfset SpreadsheetAddRow(sheet, "Pos Nbr, Account, Request FTE, Empl ID, Chart, Obj Cd, Sub Obj Cd, Person, Position FTE, RC, Reports to Chart, Reports to Org, Sub Account, Univ FY")>--->
	<cfset SpreadsheetAddRow(sheet, "Posn, PsEff, ,Empl ID, , , , ,Request FTE,RC,COA,Org, , ")>

	<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),3)>
	<cfset SpreadsheetSetRowHeight(sheet,1,30)>
	<!--- Set up columns - widths are determined manually by adjusting the column titles.  If you change the titles, then you may need to change the widths. --->
	<cfset SpreadsheetSetColumnWidth(sheet,1,18)>   <!--- Position Number --->
	<cfset SpreadsheetSetColumnWidth(sheet,2,12)>   <!--- Account --->
	<cfset SpreadsheetSetColumnWidth(sheet,3,14)>   <!--- Request FTE --->
	<cfset SpreadsheetSetColumnWidth(sheet,4,16)>   <!--- Empl ID --->
	<cfset SpreadsheetSetColumnWidth(sheet,5,12)>   <!--- Chart --->
	<cfset SpreadsheetSetColumnWidth(sheet,6,12)>   <!--- Obj Cd --->
	<cfset SpreadsheetSetColumnWidth(sheet,7,18)>   <!--- Sub Obj Cd --->
	<cfset SpreadsheetSetColumnWidth(sheet,8,36)>   <!--- Person --->
	<cfset SpreadsheetSetColumnWidth(sheet,9,18)>   <!--- Position FTE --->
	<cfset SpreadsheetSetColumnWidth(sheet,10,10)>  <!--- RC --->
	<cfset SpreadsheetSetColumnWidth(sheet,11,18)>  <!--- Reports to Chart --->
	<cfset SpreadsheetSetColumnWidth(sheet,12,18)>  <!--- Reports to Org --->
	<cfset SpreadsheetSetColumnWidth(sheet,13,18)>  <!--- Sub Account --->
	<cfset SpreadsheetSetColumnWidth(sheet,14,18)>  <!--- Univ FY --->
	
	<!--- formatting columns --->
	<!---<cfset SpreadsheetFormatColumn(sObj, {dataformat="$00000.00"}, 4)>  example of formatting a column as currency --->
	<!---<cfset SpreadSheetSetColumnWidth(sObj, 14, 0)> example of hiding a column by setting the width = 0  --->
	<!--- <cfset spreadsheetFormatColumn(sheet, {dataformat='[Green]"Y";;[Red]"N"'}, "1-2")>   --->
	<cfreturn sheet />
</cffunction>
	
<cffunction name="setExcelTitleFormatting" hint="Sets the formatting for the header in the Excel download and returns the values as a Struct">
	<!--- See https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-functions/functions-s/spreadsheetformatcell.html for valid values --->
	
	<!--- Color values in the org.apache.poi.hssf.util.HSSFColor class:AQUA, AUTOMATIC, BLACK, BLUE, BLUE_GREY, BRIGHT_GREEN, BROWN, CORAL, CORNFLOWER_BLUE, DARK_BLUE ---> 		<!--- DARK_GREEN, DARK_RED, DARK_TEAL, DARK_YELLOW, GOLD, GREEN, GREY_25_PERCENT, GREY_40_PERCENT, GREY_50_PERCENT, GREY_80_PERCENT, ---> 
	<!--- INDIGO, LAVENDER, LEMON_CHIFFON, LIGHT_BLUE, LIGHT_CORNFLOWER_BLUE, LIGHT_GREEN, LIGHT_ORANGE, LIGHT_TURQUOISE, LIGHT_YELLOW, LIME, MAROON, OLIVE_GREEN --->
	<!--- ORANGE, ORCHID, PALE_BLUE, PINK, PLUM, RED, ROSE, ROYAL_BLUE, SEA_GREEN, SKY_BLUE, TAN, TEAL, TURQUOISE, VIOLET, WHITE, YELLOW --->
	<cfscript>
		excelFormat = StructNew();
		excelFormat.alignment = "CENTER";
		excelFormat.bold = true;
		//excelFormat.bottomborder = "THICK";
		excelFormat.bottombordercolor = "AUTOMATIC";
		excelFormat.color = "GREY_50_PERCENT";
		excelFormat.fgcolor = "GREY_25_PERCENT";
		excelFormat.font = "Arial";
		excelFormat.fontsize = 14;
		excelFormat.italic = false;
		excelFormat.textwrap = true;
		excelFormat.underline = false;
		excelFormat.verticalalignment = "VERTICAL_CENTER";
	</cfscript>
	<cfreturn excelFormat />
</cffunction>

<cffunction name="setExcelSubTitleFormatting" hint="Sets the formatting for the sub-header rows above the main header">
	<cfscript>
		excelFormat = StructNew();
		excelFormat.color = "AUTOMATIC";
		excelFormat.fgcolor = "GREY_25_PERCENT";
		excelFormat.font = "Arial";
		excelFormat.fontsize = 10;
		excelFormat.alignment = "CENTER";
		excelFormat.verticalalignment = "VERTICAL_CENTER";
	</cfscript>	
	<cfreturn excelFormat />
</cffunction>

<cffunction name="setExcelRowFormatting" hint="Sets the format for the data rows in the Excel download and returns the values as a Struct">
	<cfscript>
		excelFormat = StructNew();
		excelFormat.font = "Courier";
		excelFormat.fontsize = 12;
		excelFormat.textwrap = true;			//Keeps the descriptions under control
	</cfscript>
	<cfreturn excelFormat>
</cffunction>
	