<!---
	file:	Application.cfc
	author:	jburgoon, with code from Doug Jessee and Jeff Huang
	date:	2009-06-01    updated:	2019-26-17
	note:  updated some more 2-4-2021
 --->
<cfcomponent output="no">
	<cfset this.ormenabled=false>
	<cfset APPLICATIONname = "BudgetingTools"/>
	<!--- NOTE: Using spaces in this.name causes severe gastrointestinal disturbance. DO NOT DO IT.  --->
	<cfset this.sessionManagement = "Yes" />
	<cfset this.name="BudgetingTools" />
	<cfset this.setdomainCookies = false />
	<cfset this.sessioncookie.secure = "true" >
	<cfset this.sessioncookie.httponly = "true" >

	<cffunction name="onApplicationStart"  output="no" returntype="void">
		<!--- Base URL for building Paths or URLs for the specific server. --->
		<cfif not structkeyexists(application,"baseurl") or application.baseurl NEQ "https://#CGI.HTTP_HOST#">
			<cflock name="application.baseurl" timeout="5" type="readonly" throwontimeout="no">
				<cfset application.baseurl="https://#CGI.HTTP_HOST#/#this.name#/">
			</cflock>
		</cfif>

		<!--- Set application-specific variables  --->
		<cfset application.hours_to_project = "CH_USER.HTP">
		<cfset application.disabled = "disabled"> <!--- Empty string "" enables submit buttons; "disabled" will cause submit buttons to gray out --->
		<cfset application.current_term = "4208">
		<cfset application.default_begin_term = "4218">
    	<cfset application.fiscalyear = '2022' />
    	<cfset application.shortfiscalyear = '22' />
    	<cfset application.biennium = 'B22-23' />  <!--- formerly B20-21 --->
 		<cfset application.budget_year = "YR1" />  <!--- YR1 is "long" year where we set two years' worth of values. YR2 is "short" year where we tweak second year estimates.  --->
    	<cfset application.prioryear = 'FY21' />
    	<cfset application.firstyear = 'FY22' />
    	<cfset application.secondyear = 'FY23' />
 		<cfif !StructKeyExists(application,"rateStatus")>
    		<cfset application.rateStatus = "Vc">  <!--- valid values are either Vc or V1 --->
 		</cfif>
 		<cfset application.reportBtnEnabled = "true" />
     	<cfset application.excelTemplateName = 'FeeRateRequests.xls' />
    	<cfset application.tuitionTemplateName = 'TuitionRequests.xls' />
    	<cfset application.excelFeeRatesTabName = 'Fee Rates' />
		<!--- Set Application Variables based on Server. --->
		<cfif FindNoCase("gondor",application.baseurl)>
<!--- PRODUCTION --->
			<cfset application.currentState = 'PROD' />
			<cfset application.homepage = "https://bl-budu-gondor.ads.iu.edu/BudgetingTools/AllFees/index.cfm">
			<cfset this.sessioncookie.domain = ".iu.edu" />
			<cfset this.dsn="fee_pg">
			<cfset application.rateStatus = "Vc">  <!--- valid values are either Vc or V1; ovderrides global setting above --->
			<cfif not structkeyexists(application,"datasource")>
				<cflock name="application.datasource" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.datasource="fee_pg">
					<cfset application.datasource2="crproj_pg">
					<cfset application.allFeesTable="afm">
					<cfset application.allFeeStatus = "Non-instructional">
					<cfset application.bursarFeesTable="BUDU001.AFM_FY192021_BURSAR_T@dss_link">
					<cfset application.UATaxTable="INTB_UA_TAX">
					<cfset application.usersTable="fee_user.users">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"subjectprefix") or application.subjectprefix NEQ "[UNV.BUDU]">
				<cflock name="application.subjectprefix" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.subjectprefix="[UNV.BUDU][PROD]">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"supportemail") or application.supportemail NEQ "budu@indiana.edu">
				<cflock name="application.supportemail" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.supportemail="budu@indiana.edu">
				</cflock>
			</cfif>
		<cfelseif FindNoCase("rohan",application.baseurl)>
<!--- TEST --->
			<cfset application.currentState = 'TEST' />
			<cfset application.homepage = "https://bl-budu-rohan.ads.iu.edu/BudgetingTools/AllFees/index.cfm">
			<cfset this.sessioncookie.domain = ".iu.edu" />
			<cfset application.rateStatus = "V1">  <!--- valid values are either Vc or V1; ovderrides global setting above --->
			<cfif not structkeyexists(application,"datasource")>
				<cflock name="application.datasource" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.datasource="fee_pg">
					<cfset application.datasource2="crproj_pg">
					<cfset application.allFeesTable="afm">
					<cfset application.allFeeStatus = "Non-instructional">
					<cfset application.bursarFeesTable="BUDU001.AFM_BURSAR_TEST_T@dss_link">
					<cfset application.UATaxTable="INTB_UA_TAX">
					<cfset application.usersTable="fee_user.users">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"subjectprefix") or application.subjectprefix NEQ "[UNV.BUDU][TEST]">
				<cflock name="application.subjectprefix" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.subjectprefix="[UNV.BUDU][TEST]">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"supportemail") or application.supportemail NEQ "budu@indiana.edu">
				<cflock name="application.supportemail" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.supportemail="budu@indiana.edu">
				</cflock>
			</cfif>
		<cfelseif FindNoCase("cobalt",application.baseurl)>
<!--- LOCALHOST --->
			<cfset application.currentState = 'LOCAL' />
			<cfset application.homepage = "https://bl-budu-cobalt.bry.indiana.edu:8443/BudgetingTools/AllFees/index.cfm">
			<cfset application.rateStatus = "V1">  <!--- valid values are either Vc or V1; ovderrides global setting above --->
			<cfif not structkeyexists(application,"datasource")>
				<cflock name="application.datasource" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.datasource="fee_pg">
					<cfset application.datasource2="crproj_pg">
					<cfset application.allFeesTable="afm">
					<cfset application.allFeeStatus = "Non-instructional">
					<cfset application.bursarFeesTable="BUDU001.AFM_BURSAR_TEST_T@dss_link">
					<cfset application.UATaxTable="INTB_UA_TAX">
					<cfset application.usersTable="fee_user.users">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"subjectprefix") or application.subjectprefix NEQ "[UNV.BUDU][DEV]">
				<cflock name="application.subjectprefix" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.subjectprefix="[LOCALHOST]">
				</cflock>
			</cfif>
			<cfif not structkeyexists(application,"supportemail") or application.supportemail NEQ "budu@indiana.edu">
				<cflock name="application.supportemail" timeout="5" type="readonly" throwontimeout="no">
					<cfset application.supportemail="budu@indiana.edu">
				</cflock>
			</cfif>
		<cfelse>
			<cflocation url="no_access.cfm?message=Your server is not recognized, check application.cfc" addToken="false">
		</cfif>

		<!--- Setting site-wide variables --->
		<cfset application.currentFiscalYear = "2021" />         	<!--- Search this to confirm which apps use it --->
		<cfset application.latestApprovedFeeYear = "2021" />		<!--- Search this to confirm which apps use it --->
		<cfscript>
			APPLICATION.rcNames = StructNew();
			APPLICATION.rcNames["01"] = "BALANCE SHEET";
			APPLICATION.rcNames["02"] = "INSTRUCTIONAL PROGRAMS";
			APPLICATION.rcNames["04"] = "ARTS & SCIENCES";
			APPLICATION.rcNames["05"] = "SCHOOL OF HUMANITIES & SOCIAL SCIENCES";
			APPLICATION.rcNames["06"] = "ARTS AND LETTERS";
			APPLICATION.rcNames["08"] = "HEALTH & REHABILITATION SCIENCES";
			APPLICATION.rcNames["09"] = "SCHOOL OF HEALTH AND HUMAN SCIENCES";
			APPLICATION.rcNames["10"] = "MEDICINE & HEALTH SCIENCES";
			APPLICATION.rcNames["12"] = "NURSING";
			APPLICATION.rcNames["13"] = "PUBLIC HEALTH";
			APPLICATION.rcNames["14"] = "DENTISTRY";
			APPLICATION.rcNames["15"] = "COLLEGE OF HEALTH AND HUMAN SERVICES";
			APPLICATION.rcNames["17"] = "COLLEGE OF HEALTH SCIENCES";
			APPLICATION.rcNames["18"] = "LIBERAL ARTS";
			APPLICATION.rcNames["19"] = "PHILANTHROPY";
			APPLICATION.rcNames["20"] = "SCIENCE";
			APPLICATION.rcNames["22"] = "NATURAL SCIENCES";
			APPLICATION.rcNames["23"] = "SOCIAL SCIENCES";
			APPLICATION.rcNames["24"] = "BUSINESS";
			APPLICATION.rcNames["26"] = "EDUCATION";
			APPLICATION.rcNames["30"] = "HERRON SCHOOL OF ART AND DESIGN";
			APPLICATION.rcNames["32"] = "LAW";
			APPLICATION.rcNames["34"] = "ENGINEERING & TECHNOLOGY";
			APPLICATION.rcNames["36"] = "PUBLIC & ENVIRONMENTAL AFFAIRS";
			APPLICATION.rcNames["38"] = "SOCIAL WORK";
			APPLICATION.rcNames["42"] = "MUSIC";
			APPLICATION.rcNames["43"] = "ARTS";
			APPLICATION.rcNames["44"] = "OPTOMETRY";
			APPLICATION.rcNames["45"] = "INFORMATICS";
			APPLICATION.rcNames["46"] = "IUPU COLUMBUS";
			APPLICATION.rcNames["48"] = "SCHOOL OF CONTINUING STUDIES";
			APPLICATION.rcNames["4A"] = "ARTS & SCIENCES - COLLEGE DIVISION";
			APPLICATION.rcNames["4B"] = "ARTS & SCIENCES - MEDIA";
			APPLICATION.rcNames["4C"] = "ARTS & SCIENCES - GLOBAL & INTERNATIONAL";
			APPLICATION.rcNames["4D"] = "ARTS & SCIENCES - ART & DESIGN";
			APPLICATION.rcNames["52"] = "OTHER ACADEMIC PROGRAMS";
			APPLICATION.rcNames["56"] = "STATEWIDE TECHNOLOGY";
			APPLICATION.rcNames["58"] = "ACADEMIC SUPPORT";
			APPLICATION.rcNames["60"] = "UNDERGRADUATE EDUCATION";
			APPLICATION.rcNames["64"] = "VICE PROVOST FOR RESEARCH";
			APPLICATION.rcNames["65"] = "UNIV INFORMATION TECHNOLOGY SERVICES";
			APPLICATION.rcNames["66"] = "COMPUTER SERVICES";
			APPLICATION.rcNames["67"] = "TECHNOLOGY SUPPORT";
			APPLICATION.rcNames["68"] = "LIBRARY";
			APPLICATION.rcNames["70"] = "STUDENT SERVICES";
			APPLICATION.rcNames["73"] = "STUDENT LIFE";
			APPLICATION.rcNames["74"] = "EXECUTIVE MANAGEMENT";
			APPLICATION.rcNames["75"] = "EXECUTIVE MANAGEMENT/ACADEMIC SUPPORT";
			APPLICATION.rcNames["76"] = "GENERAL ADMINISTRATION";
			APPLICATION.rcNames["77"] = "INCOME";
			APPLICATION.rcNames["78"] = "FINANCE AND ADMINISTRATION";
			APPLICATION.rcNames["79"] = "EXTERNAL AFFAIRS";
			APPLICATION.rcNames["80"] = "BUDGET & FISCAL AFFAIRS";
			APPLICATION.rcNames["81"] = "BUDGET/STUDENT SUPPORT";
			APPLICATION.rcNames["82"] = "PHYSICAL PLANT";
			APPLICATION.rcNames["83"] = "ENROLLMENT SERVICES";
			APPLICATION.rcNames["84"] = "INTERCAMPUS TRANSFERS";
			APPLICATION.rcNames["85"] = "FACILITIES DEBT SERVICE";
			APPLICATION.rcNames["86"] = "VP DIVERSITY,EQUITY&MULTICULTURAL AFFRS";
			APPLICATION.rcNames["88"] = "PRESIDENT'S OFFICE";
			APPLICATION.rcNames["89"] = "OTHER UNIVERSITY ADMINISTRATION ACCOUNTS";
			APPLICATION.rcNames["8A"] = "BOARD OF TRUSTEES";
			APPLICATION.rcNames["8B"] = "ALUMNI RELATIONS";
			APPLICATION.rcNames["90"] = "VP FOR ACADEMIC AFFAIRS";
			APPLICATION.rcNames["91"] = "VP FOR RESEARCH";
			APPLICATION.rcNames["92"] = "VP AND CHIEF FINANCIAL OFFICER";
			APPLICATION.rcNames["93"] = "VP FOR INTERNATIONAL AFFAIRS";
			APPLICATION.rcNames["94"] = "VP FOR INFORMATION TECHNOLOGY";
			APPLICATION.rcNames["95"] = "EXEC VP UNIVERSITY ACADEMIC AFFAIRS";
			APPLICATION.rcNames["96"] = "VP FOR PUBLIC AFFAIRS & GOV'T RELATIONS";
			APPLICATION.rcNames["98"] = "VP CAPITAL PROJECTS & FACILITIES";
			APPLICATION.rcNames["99"] = "SYSTEM CONTINGENCIES";
			APPLICATION.rcNames["9A"] = "GENERAL COUNSEL";
			APPLICATION.rcNames["9B"] = "VP FOR COMMUNICATION AND MARKETING";
			APPLICATION.rcNames["9C"] = "VP CLINICAL AFFAIRS";
			APPLICATION.rcNames["9D"] = "VP FOR HUMAN RESOURCES";
			APPLICATION.rcNames["NO"] = "NO RESPONSIBILITY CENTER";
			APPLICATION.rcNames["52NURS"] = "NURSING";
			APPLICATION.rcNames["52OVST"] = "OVERSEAS STUDIES";
			APPLICATION.rcNames["52SOCW"] = "SOCIAL WORK";
			APPLICATION.rcNames["BL Campus"] = "";
			APPLICATION.rcNames["CFO"] = "";
			APPLICATION.rcNames["Bursar"] = "";
			APPLICATION.rcNames["Treasury"] = "";
			APPLICATION.rcNames["CO Campus"] = "";
			APPLICATION.rcNames["EA Campus"] = "";
			APPLICATION.rcNames["IN Campus"] = "";
			APPLICATION.rcNames["KO Campus"] = "";
			APPLICATION.rcNames["NW Campus"] = "";
			APPLICATION.rcNames["Purdue"] = "";
			APPLICATION.rcNames["SB Campus"] = "";
			APPLICATION.rcNames["SE Campus"] = "";
			APPLICATION.rcNames["UA fee"] = "";
			APPLICATION.rcNames[""] = "";
		</cfscript>
		<!--- Setting Site-wide regular expression validation patterns. --->
		<!--- Date format 1/1/02 or 01/01/2009. --->
		<cflock name="application.re_date" timeout="5" type="readonly" throwontimeout="no">
			<cfset application.re_date="^([1-9]|0[1-9]|1[012])[-/]([1-9]|[012][0-9]|3[01])[-/](\d\d|19\d\d|20\d\d)$">
		</cflock>
		<!--- email. --->
		<cflock name="application.re_email" timeout="5" type="readonly" throwontimeout="no">
			<cfparam name="application.re_email" default="^[A-Za-z0-9._+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$">
		</cflock>
		<!--- Password. --->
		<cflock name="application.re_password" timeout="5" type="readonly" throwontimeout="no">
			<cfparam name="application.re_password" default="^[A-Za-z0-9]{8,64}$">
		</cflock>
		<!--- Rank. --->
		<cflock name="application.re_rank" timeout="5" type="readonly" throwontimeout="no">
			<cfparam name="application.re_rank" default="^[CcGgNnPpRrSsTt][AaEeLlMmNnUuSs][1-6]?[A-Za-z0-9]{2,2}$">
		</cflock>
		<!--- Dept Code. ^[a-zA-Z]{2,2}-[a-zA-Z]{2,6}$ --->
		<cflock name="application.re_dept" timeout="5" type="readonly" throwontimeout="no">
			<cfparam name="application.re_dept" default="^[a-zA-Z]{2,2}-[a-zA-Z]{2,6}$">
		</cflock>
		<!--- Allowed Characters. --->
		<cflock name="application.re_text" timeout="5" type="readonly" throwontimeout="no">
			<cfset application.re_text="^[A-Za-z0-9-!'(),./:?\\_`~]$">
		</cflock>
		<!--- Disallowed Characters. " # $ ; % & * + = < > @ [ ] { } | --->
		<cflock name="application.re_badtext" timeout="5" type="readonly" throwontimeout="no">
			<cfset application.re_badtext='["##$;%&*+<=>@[\]{|}]'>
		</cflock>
		<!--- File Extensions .txt .TXT .rtf .RTF .doc .DOC .docx .DOCX .pdf .PDF (updated on 8-5-2009 to include the file name as well as the extension) (\\|\/|%2F|%5C) --->
		<cflock name="application.re_fileext" timeout="5" type="readonly" throwontimeout="no">
			<cfset application.re_fileext="(\\|\/|^)[a-zA-Z0-9\-\_ ]{1,124}\.(txt|TXT|rtf|RTF|doc|DOC|docx|DOCX|pdf|PDF)$">
		</cflock>
	</cffunction>

    <cffunction name="OnSessionStart">
	    <CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="5">
	    	<cfset session.domain = "#cgi.SERVER_NAME#" />
	        <cfset SESSION.DateInitialized = Now() />
	    </CFLOCK>
    </cffunction>

	<cffunction name="onRequestStart" output="false" returntype="boolean">
		<!---
		  See https://ucdavis.jira.com/wiki/spaces/IETP/pages/132808774/CAS+Cold+Fusion+Clients
		  The BUDU custom tags are up in C:\ColdFusionBuilder3\ColdFusion\cfusion\CustomTags\budu
		--->
		<cf_cas_auth> <!--- Sets REQUEST.authuser which can be called in code  --->
		<cfset This.scriptprotect="all">
		<cfset REQUEST.developerUsernames = "jburgoon,gwpalmer,nschrode,ellijord,jopadams,uisoscan" />
		<cfset REQUEST.adminUsernames = "jburgoon,gwpalmer,nschrode,ellijord,jopadams,alirober,nichodan,sbadams,uisoscan,bjmoelle,galter,ttwu" />
		<!--- TODO: make this a single setting in application and use dynamic where USERS.PROJECTOR_RC eq "ALL" --->
		<cfset REQUEST.campusFOusernames = "aheeter,freemanr,dkcarter,dadooley,dwavle,atronc01,cbroeker,kcwalsh,coback,arlsphil,kamyers,srastogi,rstrouse,lejulian,ltschler,peterskl,mtdicker,jahayman,tschance,kjgrant,jvsummer,ckasdor" />
		<cfset REQUEST.regionalUsernames = "pyebei" />
		<cfset REQUEST.bursarUsernames = "bchubbar,arasdall" />
		<cfset REQUEST.cfoUsernames = "jsej,sbadams" />
		<cfset REQUEST.baseurl = application.baseurl />
 		<cfset REQUEST.fileUploadPath = 'C:\Users\jburgoon\Documents' />
 		<cfset REQUEST.boxUploadPath = 'https://iu.app.box.com/folder/4781002109/' />
 		<cfset REQUEST.opAssAdmins = "gwpalmer,nschrode,ellijord,jopadams,jburgoon,alirober,ttwu,galter,bjmoelle,nichodan,sbadams,jsej,paulschm,dlkremer,pyebei" />
 		<cfset REQUEST.opAssUsers = "" />
 		<cfset REQUEST.Approver_list ="gwpalmer,nschrode,jburgoon,alirober,ttwu,galter,bjmoelle,nichodan,sbadams,jsej" />
 		<!---  Usernames appearing in the specialAccess list will see the Save Your Work button enabled EVEN IF application.disabled has been set to "disabled"  --->  <!--- TODO: Make this dynamic from the database and add a UBO Control to it  --->
 	 	<cfset REQUEST.specialAccess = "jburgoon,nschrode,ellijord,jopadams,alirober,aheeter,freemanr,bmcminn,cbroeker,kcwalsh,coback,lejulian,jahayman,mtdicker,tschance,kjgrant,ltschler,dwavle,jvsummer,ckasdor" />
		<!--- disable various hoo-haw shenanigans.  These constructs are too high strung to belong here. --->
		<cfif StructKeyExists(cgi,"Query_string") AND CGI.Query_string IS Not "">
			<cfset Checkstring = CGI.QUERY_STRING>
		    	<cfif Checkstring CONTAINS 'iframe' OR  Checkstring CONTAINS 'meta' OR  Checkstring CONTAINS 'applet' OR  Checkstring CONTAINS 'embed' OR  Checkstring CONTAINS 'object' OR  Checkstring CONTAINS 'script'>
		        	<cflocation url="no_access.cfm?message=Query strings are not allowed." addToken="false">
		        </cfif>
		</cfif>
		<cfreturn true />
	</cffunction>

    <cffunction name="onMissingTemplate" access="public" output="yes" returnType="boolean" hint="Executes on 404">
        <cfargument type="string" name="targetPage" required=true/>
        <cftry>
            <cfoutput>
                <h3>#Arguments.targetPage# could not be found.</h3>
                <p>You requested a non-existent ColdFusion page.<br />
                    Please check the URL.</p>
            </cfoutput>
            <cfreturn true />
            <cfcatch>
                <cfreturn false />
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="onError" returntype="void">
        <cfargument name="Exception" required=true/>
        <cfargument name="EventName" type="String" required=true/>
        <cfset errorText = "" />
        <cfsavecontent variable="errorText">
			<cfoutput>
                <h2>An error occurred</h2>
                <h3>http://#cgi.server_name##cgi.script_name#?#cgi.query_string#</h3>
                <p>Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#</p>
     			Event Name: #EventName#<br />
                #arguments.Exception#
            </cfoutput>
        </cfsavecontent>

        <!--- Some exceptions, including server-side validation errors, do not generate a rootcause structure. --->
		<cfif isdefined("exception.rootcause")>
            <cfoutput>
                <h2>Exception Root Cause</h2>
                <p>#exception.rootcause#</p>
            </cfoutput>
        </cfif>
        <!--- Display an error message if there is a page context. --->
        <cfif NOT (Arguments.EventName IS "onSessionEnd") OR (Arguments.EventName IS "onApplicationEnd")>
            <cfoutput>
                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <p>Error Event: #EventName#</p>
                <p>Error details:<br>
                <p>"#Arguments.exception#"</p>
            </cfoutput>
        </cfif>
    </cffunction>

    <cffunction name="OnRequestEnd">
		<!--- This method can be useful for gathering performance metrics, or for displaying dynamic footer information. --->
    </cffunction>
</cfcomponent>
