
	<!---  IE cannot handle less-than and greater-than signs in the description fields.  Too stupid to know content from commands.  --->
	<!---  We cannot deny the usage of such symbols in the description, since the fiscal officers need to see them.  --->
	<!---  Thus we have a user-defined function which corrects this.  --->
  	<cffunction name="correctSymbols" output="true">
 		<cfargument name="textString" required="true">
		<cfset returnValue = Replace(textString,"<","&lt;","all") />
		<cfset returnValue = Replace(returnValue,">","&gt;","all") />
		<cfset returnValue = Replace(returnValue,"&","&amp;","all") />
		<cfset returnValue = textString />
 		<cfreturn returnValue />
 	</cffunction>

 	<!--- Roles for specific userID  --->
	<cffunction name="getRoles" output="no">
    	<cfargument name="empID" required="yes" />
        <cfquery name="getroles" datasource="#application.datasource#">
            SELECT roleID, roleCode, campCode, deptID
            FROM	roles
            WHERE	empl_ID = <cfqueryparam value="#empID#" cfsqltype="cf_sql_char"> and
                    roleActive = 'A' and
                    roleStartDate <= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> AND
                    roleStopDate >= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
            ORDER BY roleStartDate ASC
        </cfquery>
        <cfreturn getroles />
    </cffunction>

    <!--- This is the ONLY logging function.  Use it by customizing your arguments.  Check the db for existing values. --->
<cffunction name="trackFeeAction" output="false">
	<cfargument name="loginId" required="true" default="#REQUEST.AuthUser#" />
	<cfargument name="campusId" required="true" />
	<cfargument name="actionId" required="true" />
	<cfargument name="description" required="false" default="" />
	<cfargument name="parameterCd" required="false" default="" />
	<cfquery datasource="#application.datasource#" name="makeMeta">
		INSERT INTO FEE_USER.METADATA
		(USER_ID,CAMPUS_ID,ACTION_ID,DESCRIPTION)
		VALUES
		('#loginId#','#campusId#','#actionId#','#description#')
	</cfquery>
</cffunction>

	<!--- FeeMasterID overrides the regular feeID.  This means that although we assign a feeID, the FeeMasterID is the one we will use for the actual rate.
	      Functionally this means that the regular FeeID might be a zero, or it might be any other value, but we will never see that value used.
	      Practically, I recommend that FeeIDs having FeeMasterIDs remain at "0.00" so that we will not be confused if a FeeMasterID is removed.  It is
	      easier to notice a fee of zero dollars than it would be to notice a fee of soem arbitrary value. --->
	<cffunction name="fetchMasterInst" output="true" description="Uses Fee MasterID to identify who controls the fee rate.">
 		<cfargument name="givenFeeID" required="true" type="string">
 		<!---<cfset baseFeeInfo = EntityLoad("Fee_codes",{FISCAL_YEAR=application.fiscalyear, FEE_ID = givenFeeID},true) />--->
 		<cfset masterID = baseFeeInfo.getfee_masterid() />
 		<cfif IsNull(masterID)>
 			<!--- <cfset masterCampus = ArrayNew(1)>   Send it back as the same structure, only empty, if nothing was found --->
 			<cfreturn "UBO" />
 		<cfelse>
 			<!---<cfset masterCampus = EntityLoad("Fee_codes",{FISCAL_YEAR=application.fiscalyear, FEE_ID = masterID},true) />	--->
			<cfreturn masterCampus.getFee_inst() />
 		</cfif>
 	</cffunction>

 	<cffunction name="toggleShowEditableFees" hint="Set or unset the status of the checkbox on the homepage" >
 		<!--- Not sure if we want to do this. --->
 	</cffunction>

	<cffunction name="getAllTuition">
		<!--- OLD fee_codes table  --->
		<!---<cfquery datasource="#application.datasource#" name="allFeeCodes">
			SELECT fc.id, fc.fee_id, 'xxxxxxxxxx', fc.fee_inst, fc.categ, fc.fee_descr,fc.fee_type,
					fc.fee_current,fc.fee_lowyear, 'xxx','Y','',fc.fee_highyear,'xxx','Y','N',
			s.residency, s.feeclass, s.sort_order, s.tier,fc.fee_setByCampusIndicator
			FROM fee_codes fc
			LEFT OUTER JOIN feecodesort s
			ON fc.fee_id = s.feecodeid
			WHERE fc.fiscal_year = <cfqueryparam cfsqltype="cf_sql_float" value='#application.fiscalyear#'>
			  AND fc.categ != 'OTHER'
		</cfquery>--->

		<cfquery name="allFeeCodes_v10" datasource="#application.datasource#">
            SELECT allfee_id as id, local_id as fee_id, inst_cd as fee_inst, fee_type as categ,
			  fee_desc_web as fee_descr,unit_basis as fee_type, fee_current,fee_lowyear,
			  fee_highyear,
			CASE
			  WHEN allfee_masterid IS NULL THEN 'Y'
			  WHEN allfee_masterid != allfee_id THEN 'N'
			  ELSE 'Y'
			END as fee_setByCampusIndicator
			FROM #application.allFeesTable#
			WHERE fiscal_year = <cfqueryparam cfsqltype="cf_sql_float" value='#application.fiscalyear#'> AND fee_type IN ('TUI','MAN','PRO')
		</cfquery>
		<cfreturn allFeeCodes_v10>
	</cffunction>

	<cffunction name="getFeesByUserID" output="true" >
		<cfargument name="userID" required="true" hint="Whatever userID exists in the session" type="string">
		<!--- Cases for userID are bduser, any campus user, PEND, and everything else --->
		<cfswitch expression = '#Ucase(userID)#'>
			<cfcase value = 'IUIUA'><cfset derived_inst = 'IUIUA'></cfcase>
			<cfcase value = 'PEND'><cfset derived_inst = 'PEND'></cfcase>
			<cfcase value = 'BDUSER'><cfset derived_inst = 'IU%'></cfcase>
			<cfdefaultcase><cfset derived_inst = 'IU' & Ucase(Mid(#userID#,1,2)) & 'A'></cfdefaultcase>
			<!---<cfcase value = 'BLUSER,EAUSER,INUSER,KOUSER,NWUSER,SBUSER,SEUSER'><cfset derived_inst = 'NONE'>--->
		</cfswitch>
		<!---<cfquery datasource="#application.datasource#" name="sortedFeeCodes">
			SELECT fc.id, fc.fee_inst, fc.categ, s.residency, s.feeclass, s.sort_order, s.tier, fc.fiscal_year,
				fc.fee_id, fc.fee_descr, fc.fee_type, fc.fee_current, fc.fee_lowyear,fc.fee_highyear, fc.fee_setByCampusIndicator
			FROM fee_codes fc
			INNER JOIN feecodesort s ON fc.fee_id = s.feecodeid
			WHERE fc.fiscal_year = <cfqueryparam cfsqltype="cf_sql_float" value=#application.fiscalyear#>
			  AND fc.categ != 'OTHER'
			  AND fc.fee_inst = <cfqueryparam cfsqltype="cf_sql_varchar" value=#derived_inst#>
			ORDER BY sort_order ASC, residency DESC, categ ASC, fee_id ASC, fee_inst ASC,  feeclass ASC,  tier ASC
		</cfquery>--->

		<cfquery datasource="#application.datasource#" name="sortedFeeCodes_v10">
			SELECT allfee_id, local_id as fee_id, inst_cd as fee_inst,fee_owner, fee_typ_desc as categ,
			  fee_desc_long as fee_descr,unit_basis as fee_type, fee_current,fee_lowyear,

			  fee_highyear, cohort,
			  CASE
			    WHEN allfee_masterid IS NULL THEN 'Y'
			    WHEN allfee_masterid != local_id THEN 'N'
			  ELSE 'Y'
			END AS fee_setByCampusIndicator
			FROM #application.allFeesTable#
			WHERE fiscal_year = <cfqueryparam cfsqltype="cf_sql_varchar" value=#application.fiscalyear#>
			  AND inst_cd LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value=#derived_inst#>
			   AND fee_type IN ('TUI','MAN','PRO','_DE') and active = 'Y'
			ORDER BY allfee_id ASC, inst_cd ASC
		</cfquery>
		<cfreturn sortedFeeCodes_v10>
	</cffunction>

<cffunction name="testData" >
  <cfquery name="testQuery" datasource="#application.datasource#" >
    SELECT allfee_id, fee_desc_web FROM #application.allFeesTable# WHERE FISCAL_YEAR =  '#application.fiscalyear#' AND ACTIVE = 'Y'
  </cfquery>
  <cfreturn testQuery>
</cffunction>

	<cffunction name="getTemplateByUserID">
		<cfargument name="userID" required="true" hint="Whatever userID exists in the session" type="string">
		<!--- Cases for userID are bduser, any campus user, PEND, and everything else --->
		<cfswitch expression = '#Ucase(userID)#'>
			<cfcase value = 'IUIUA'><cfset derived_inst = 'IUIUA'></cfcase>
			<cfcase value = 'PEND'><cfset derived_inst = 'PEND'></cfcase>
			<cfcase value = 'BDUSER'><cfset derived_inst = 'IU%'></cfcase>
			<cfcase value = 'BLUSER,EAUSER,INUSER,KOUSER,NWUSER,SBUSER,SEUSER'><cfset derived_inst = 'IU' & Ucase(Mid(#userID#,1,2)) & 'A'></cfcase>
			<cfdefaultcase><cfset derived_inst = 'NONE'></cfdefaultcase>
		</cfswitch>
		<!---<cfquery datasource="#application.datasource#" name="sortedFeeCodes">
			SELECT fc.id, fc.fee_id, fc.fee_inst, fc.categ, fc.fee_descr, fc.fee_type, fc.fee_current,
				" " AS Spacer1,
				fc.fee_lowyear,
				"{=IF(I39<>0, I39/G39 - 1, "Ready")}" AS "Increase % for 2018",
				"" AS "Valid for 2018?",
				" " AS Spacer2,
				fc.fee_highyear,
				"" AS "Increase % for 2019",
				"" AS "Valid for 2019?",
				fc.fee_setByCampusIndicator
			FROM fee_codes fc
			INNER JOIN feecodesort s
			ON fc.fee_id = s.feecodeid
			WHERE fc.fiscal_year = '#application.fiscalyear#' AND fc.categ != 'OTHER' AND fc.fee_inst LIKE '#derived_inst#'
		</cfquery>--->
		<cfquery datasource="#application.datasource#" name="sortedFeeCodes_v10">
			SELECT allfee_id AS id, local_id AS fee_id, inst_cd AS fee_inst, fee_type as categ,
			  fee_desc_web AS fee_descr,unit_basis AS fee_type, fee_current," " AS Spacer1,
			  fee_lowyear,
				"{=IF(I39<>0, I39/G39 - 1, "Ready")}" AS "Increase % for 2018",
				"" AS "Valid for 2018?",
				" " AS Spacer2,
				fee_highyear,
				"{=IF(I43<>0, I43/G43 - 1, "Ready")}" AS "Increase % for 2019",
				"" AS "Valid for 2019?",
			CASE
			  WHEN local_masterid IS NULL THEN 'Y'
			  WHEN local_masterid != local_id THEN 'N'
			  ELSE 'Y'
			END AS fee_setByCampusIndicator
			FROM #application.allFeesTable#
			WHERE fiscal_year = '#application.fiscalyear#' fee_inst LIKE '#derived_inst#'
		</cfquery>
		<cfreturn sortedFeeCodes_v10>
	</cffunction>

	<!--- Generic Excel sheet without any data - this empty template is the only one we need for this application --->
	<cffunction name="setupTuitionTemplate" hint="Setup details for Excel template Fee Requests tab" >
		<!--- Spreadsheet name is set here, workbook name is set in application.cfc --->
		<cfset sheet = SpreadSheetNew(application.tuitionTemplateName)>
		<!--- Add Excel title row 1 --->
		<cfset SpreadsheetAddRow(sheet,"Indiana University Budget Office - Fee Requests for FY20 and FY21")>
		<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),1)>
		<cfset SpreadsheetMergeCells(sheet,1,1,1,12)>
		<cfset SpreadsheetSetRowHeight(sheet,1,40)>
		<!--- Add Excel title row 2 --->
		<cfset SpreadsheetAddRow(sheet,"Current Fiscal Year 2020 - Fill out your requested increase amounts here and then use this sheet as the upload template when you are finished.")>
		<cfset SpreadsheetFormatRow(sheet, setExcelSubTitleFormatting(),2)>
		<cfset SpreadsheetMergeCells(sheet,2,2,1,12)>
		<!--- Add Excel title row 3 --->
		<!---<cfset SpreadsheetAddRow(sheet, "ID,Campus,Category,Residency,Fee Class, Sort order, Tier, Fiscal Year, Fee ID, Fee Rate Description, Fee Type, Current Rate,2016,2017, Set By Your Campus")>--->
		<cfset SpreadsheetAddRow(sheet, "AllFeeID,Fee ID,Campus,Fee Owner,Category,Fee Rate Description,Fee Type,Current 2019 Rate,FY20 Rate,FY21 Rate,Cohort,Set By Campus")>
		<cfset SpreadsheetFormatRow(sheet, setExcelTitleFormatting(),3)>
		<cfset SpreadsheetSetRowHeight(sheet,1,30)>
		<!--- Set up columns - widths are determined manually by adjusting the column titles.  If you change the titles, then you may need to change the widths. --->
		<cfset SpreadsheetSetColumnWidth(sheet,1,14)>   <!--- AllFee ID --->
		<cfset SpreadsheetSetColumnWidth(sheet,2,8)>    <!--- Fee ID --->
		<cfset SpreadsheetSetColumnWidth(sheet,3,16)>   <!--- Campus --->
		<cfset SpreadsheetSetColumnWidth(sheet,4,16)>	<!--- Fee Owner --->
		<cfset SpreadsheetSetColumnWidth(sheet,5,18)>   <!--- Category --->
		<cfset SpreadsheetSetColumnWidth(sheet,6,64)>   <!--- Fee Rate Description --->
		<cfset SpreadsheetSetColumnWidth(sheet,7,20)>   <!--- Fee Type --->
		<cfset SpreadsheetSetColumnWidth(sheet,8,26)>   <!--- Current Rate --->
		<cfset SpreadsheetSetColumnWidth(sheet,9,26)>   <!--- 2020 Rate --->
		<cfset SpreadsheetSetColumnWidth(sheet,10,26)>  <!--- 2021 Rate --->
		<cfset SpreadsheetSetColumnWidth(sheet,11,12)>  <!--- Cohort --->
		<cfset SpreadsheetSetColumnWidth(sheet,12,14)>  <!--- Set By Your Campus --->

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
				excelFormat.color = "DARK_RED";
				excelFormat.fgcolor = "GREY_25_PERCENT";
				excelFormat.font = "Times New Roman";
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
				excelFormat.font = "Times New Roman";
				excelFormat.fontsize = 12;
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

	<cffunction name="addSubmittedRows" hint="Uses slurped data to create rows for the fee request form." >
		<!--- Pass in the slurped Excel tab data, tell us what kind it is, and a struct for processing --->
		<cfargument name="uploadData" required="true" hint="Slurped data" type="query">
		<cfargument name="uploadType" required="true" hint="UG, GR, REG" type="string">
		<cfscript>
			submittedFeeCodes = generateEmptyFeeCodeQuery();
			submittedRows = StructNew();
			switch(uploadType) {
				case "UG":
					UGrows = StructNew();
					break;
				case "GR":
					GRrows = StructNew();
					break;
			}
		</cfscript>
		<cfreturn submittedFeeCodes>
	</cffunction>

	<cffunction name="generateEmptyFeeCodeQuery" >
		<cfscript>
			submittedFeeCodes = QueryNew("CATEG,FEECLASS,FEE_CURRENT,FEE_DESCR,FEE_HIGHYEAR,FEE_ID,FEE_INST,FEE_LOWYEAR,FEE_SETBYCAMPSUINDICATOR,FEE_TYPE,FISCAL_YEAR,ID,RESIDENCY,SORT_ORDER,TIER","varchar,varchar,integer,varchar,integer,varchar,varchar,integer,varchar,varchar,integer,integer,varchar,varchar,integer");
		</cfscript>
		<cfreturn submittedFeeCodes>
	</cffunction>

	<cffunction name="getValidSheetNames">
		<cfargument name="submissionType">  <!--- FindNoCase returns a positive position number if "consol subms" in submission file name --->
		<!--- Manually maintained list of sheetnames in use with Tuition Templates. CF lists are not datatypes, they are just strings.  You declare the delimiter as needed. --->
		<cfscript>
			sheetnameList = "";
			if(submissionType neq 0) {
			 	sheetnameList = ListAppend(sheetnameList,"EA Tuition, Undergraduate|EA Tuition, Grad & Professional","|");
				sheetnameList = ListAppend(sheetnameList,"IN Tuition, Undergraduate|IN Tuition, Grad & Professional","|");
				sheetnameList = ListAppend(sheetnameList,"KO Tuition, Undergraduate|KO Tuition, Grad & Professional","|");
				sheetnameList = ListAppend(sheetnameList,"NW Tuition, Undergraduate|NW Tuition, Grad & Professional","|");
				sheetnameList = ListAppend(sheetnameList,"SB Tuition, Undergraduate|SB Tuition, Grad & Professional","|");
				sheetnameList = ListAppend(sheetnameList,"SE Tuition, Undergraduate|SE Tuition, Grad & Professional","|");
			} else {
				sheetnameList = ListAppend(sheetnameList,"Tuition, Undergraduate|Tuition, Grad and Professional","|");
				sheetnameList = ListAppend(sheetnameList,"distance ed FY18 submitted","|");
			}
		</cfscript>
		<cfreturn sheetnameList>
	</cffunction>

	<cffunction name="getFeeByFeeID" hint="Pass in a FeeID and a campus and the current state of the data as it sits in the db.  If FeeID exists in the system, return the current year row for that FeeID/Campus combination.">
		<!--- Query of a query to get back a specific row. --->
		<cfargument name="submittedFeeID" required="true" type="string">
		<cfargument name="submittedCampus" required="true" type="string">
		<cfargument name="currentData" type="query">
		<cfargument name="feeIDSubGrpCd" required="false" type="string">
		<cfquery datasource="#application.datasource#"  name="getCurrentRow" dbtype="query">
			 SELECT *
			 FROM currentData
			 WHERE currentData.Fee_ID = <cfqueryparam value="#submittedFeeID#">
			 <cfif #submittedCampus# neq 'IUConsA'>
			   AND currentData.fee_inst = <cfqueryparam value="#submittedCampus#">
			 </cfif>
			 <cfif Len(feeIDSubGrpCd)>
			   AND currentData.feeid_subGrpCd = <cfqueryparam value="#feeIDSubGrpCd#">
			 </cfif>
		</cfquery>
		<cfreturn getCurrentRow >
	</cffunction>

	<cffunction name="getFeeDirect">
		<cfargument name="submittedFeeID" required="true" type="string">
		<!---<cfquery name="directFee" datasource="#application.datasource#" >
			 SELECT fee_id, subm_ly,subm_hy
			 FROM fee_codes
			 WHERE fee_ID = <cfqueryparam value="#submittedFeeID#">
		</cfquery>--->
		<cfquery name="directFee_v10" datasource="#application.datasource#" >
			 SELECT allfee_id, fee_lowyear, fee_highyear
			 FROM #application.allFeesTable#
			 WHERE fee_ID = <cfqueryparam value="#submittedFeeID#"> and FISCAL_YEAR =  '#application.fiscalyear#'
		</cfquery>
		<cfreturn directFee_v10 >
	</cffunction>

	<cffunction name="updateSubmittedValues">
		<cfargument name="submittedFeeID" required="true" type="string">
		<cfargument name="submittedValue" required="true" type="numeric">
		<cfargument name="columnToUpdate" required="true" type="string">
		<!---<cfquery name="insertValue" datasource="#application.datasource#" >
			UPDATE fee_codes
			SET #columnToUpdate# = #submittedValue#
			WHERE fee_id = '#submittedFeeID#' AND fiscal_year = #application.fiscalyear#
		</cfquery>--->
		<cfquery name="insertValue_v10" datasource="#application.datasource#" >
			UPDATE #application.allFeesTable#
			SET #columnToUpdate# = #submittedValue#
			WHERE allfee_id  = '#submittedFeeID#' AND fiscal_year = #application.fiscalyear#
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="getDistFIDs" >
		<cfquery name="getFIDlist" datasource="#application.datasource#" >
			SELECT DISTINCT fee_id
			FROM fee_codes
			WHERE fiscal_year = '#application.fiscalyear#'
		</cfquery>
		<cfreturn getFIDlist>
	</cffunction>

	<cffunction name="deAnnualize">
		<cfargument name="feeID" type="string">
		<cfscript>
			annualizedFeeIDs = "";
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'BR0000,BM0008,BM0009,BM0010,BM0011,BM0012,BN0023,UG007,UG008,UG0001,UG0002,UG0003,UG0004,UG0005,G00006,G00007');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'IR0046,IM0019,IM0020,IM0021,IM0022,IN0072');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'UG0013,UG0014,UG0015,UG0016,UG0017,UG0018,UG0023,UG0024,UG0033,UG0037,UG0041,UG0051,UG0053,UG0054,UG0055');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'ER0098,EM0025,EM0026,EM0027,EN0104,EM0025,EM0026,EM0027');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'KR0109,KM0030,KM0031,KM0032,KN0114');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'NR0119,NM0034,NM0035,NM0036,NN0124');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'SR0129,SM0038,SM0039,SM0040,SN0134');
			annualizedFeeIDs = ListAppend(annualizedFeeIDs,'JR0139,JM0042,JM0043,JM0044,JN0142');
			var testResult = false;
			if(FindNoCase(feeID,annualizedFeeIDs)) {
				testResult=true;
			}
		</cfscript>
		<cfreturn true>
	</cffunction>

<cffunction name="getAllTuitionColumnNames">
	<cfquery name="colNames"  datasource="#application.datasource#">
		SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS where TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_char" value="#UCASE(application.allFeesTable)#">
	</cfquery>
	<cfset listOfColumnValues = ValueList(colNames.COLUMN_NAME)>
	<cfset fullArray = ListToArray(listOfColumnValues)>
	<cfreturn fullArray>
</cffunction>

<cffunction name="updateTuitionChanges">
	<cfargument name="submittedForm" type="struct" required="true">
	<cfset debugQueries = "DEBUG: ">
	<cfset queryString = "">
	<cfloop list="#submittedForm.ALLFEE_ID#" index="i">
			<cfset formDetail_low = REReplace(i,"[^A-Za-z0-9+##\-_.:/ ]","","ALL") & "_FEE_LOWYEAR">  <!--- Looks like "BLMAN006929_FEE_LOWYEAR" --->
			<cfset formDetail_high = REReplace(i,"[^A-Za-z0-9+##\-_.:/ ]","","ALL") & "_FEE_HIGHYEAR">  <!--- Looks like "BLMAN006929_FEE_HIGHYEAR" --->
			<cfif StructKeyExists(FORM,formDetail_low) AND StructKeyExists(FORM,formDetail_high)>
				<cfset queryString = "UPDATE " & #application.allFeesTable# & " SET ">
				<cfset queryString = queryString & " FEE_LOWYEAR = '" & NumberFormat(REReplace(submittedForm[formDetail_low],"[^A-Za-z0-9+##\-_.:/ ]","","ALL"), "99.99") & "', FEE_HIGHYEAR = '" & NumberFormat(REReplace(submittedForm[formDetail_high],"[^A-Za-z0-9+##\-_.:/ ]","","ALL"), "99.99") & "' " >
				<cfset queryString = queryString & " WHERE ACTIVE = 'Y' AND allfee_id = '" & i & "'; COMMIT;">
				<cfset queryExecute(queryString,[],{datasource='#application.datasource#'}) >
				<cfset debugQueries = debugQueries & "<br>" & queryString>
			<cfset actionEntry = trackFeeAction(#REQUEST.AuthUser#,"UA",2,"tuition_update.cfm - #REQUEST.authUser# - #DateTimeFormat(Now(),"EEE dd-mmm-yyyy hh:nn:ss tt")# AllFeeID: #i# Fee_LY: #submittedForm[formDetail_low]#  Fee_HY: #submittedForm[formDetail_high]#") />
			</cfif>
	</cfloop>
	<cfreturn debugQueries>
</cffunction>

<cffunction name="getFeeOwners" output="true">
	<cfargument name="selectedCampus" type="string" default="BL">
	<cfset currentUserChart = getUserDataByCampus(request.authUser).chart>
	<cfquery datasource="#application.datasource2#" name="GetCampus">
	  select distinct c.fin_coa_cd, c.fin_coa_desc, r.rc_cd, r.rc_shrt_nm,
	    CONCAT(c.fin_coa_cd, CONCAT( CONCAT(' - ', r.rc_cd), CONCAT(' - ', r.rc_shrt_nm) ) ) "dropdown"
	  from #application.hours_to_project# h,
	       ref.bc_rc_t r,							<!--- includes all RCs, names, and ACTIVE code --->
	       ref.rc_sec_t s,							<!--- security table --->
	       ref.bc_chart_t c   						<!--- "BL" "Bloomington"   --->
	  where s.schm_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="CH_USER">
	  <cfif currentUserChart neq 'UA'>
	    and c.fin_coa_cd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectedCampus#">
	  </cfif>
	    and s.actv = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
	    and SUBSTR(h.inst,3,2) = c.fin_coa_cd
	    and h.rc = r.rc_cd
	  <cfif currentUserChart neq 'UA'>
	  	order by r.rc_cd asc
	  <cfelse>
	  	order by c.fin_coa_cd asc, r.rc_cd asc
	  </cfif>
	</cfquery>
	<cfif GetCampus.RecordCount gt 0>
		<cfreturn GetCampus>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

  <cffunction name="getUserDataByCampus" output="true">
  	<cfargument name="givenUser" required="false" default="">
  	<cfquery datasource="#application.datasource#" name="getUserList">
  		SELECT USERNAME, FIRST_LAST_NAME,EMAIL,DESCRIPTION,ACCESS_LEVEL,CHART,PROJECTOR_RC,PHONE,ACTIVE,CREATED_ON
  		FROM USERS
  		WHERE CHART = (
  			SELECT CHART
  			FROM USERS
  			WHERE ACTIVE = 'Y' AND USERNAME = <cfqueryparam value="#REQUEST.authuser#" cfsqltype="cf_sql_varchar">
  		   )
  		   AND ACCESS_LEVEL != 'GUEST'
  		<cfif LEN(givenUser) gt 0>
  			AND username = '#givenUser#'
  		</cfif>
  	</cfquery>
  	<cfreturn getUserList>
  </cffunction>