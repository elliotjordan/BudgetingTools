<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfparam name="getCampus" type="string" default="">
<cfparam name="urlCampus" type="string" default="">
<cfparam name="urlRC" type="string" default="">
<cfparam name="DataSelect" type="query" default="#QueryNew('ID','integer')#">
<cfscript>
	currentTarget = StructNew();
	currentTarget.RC_TARGET = 0;
</cfscript>
<cfset userLanding = getUserLandingPage() />
<cfset userAccessList = getUserAccessList() />
<cfset dssIsOpen = checkDSSavailability() />

<cfif isDefined("Url") AND StructKeyExists(Url, "Campus") AND StructKeyExists(Url, "RC")>
	<cfset urlCampus = url.Campus>
	<cfset urlRC = url.RC>
	<cfset DataSelect = getProjectinatorData(urlCampus, urlRC,application.rateStatus)>
	<cfif ListFindNocase("77,80,81",urlRc)> <cfset noFCPSelect = getNoFCPRows("IU"&urlCampus&"A",urlRC)> </cfif>
	<cfset getCampus = getCampusAndRC(urlcampus)>
	<cfset totProjCount = getProjCount()>
	<cfset ptg = getUBO_TOOL_SETTINGS(urlCampus,urlRC)>
	<cfset campusUser = false />
<cfelse>  <!--- removes the problem of users clicking the CHRP link at the top of the page and getting an error due to no campus setting in the link.  Duh.  --->
	<cfset campusUser = true />
	<cfif FindNoCase("campus",userLanding) gt 0>
		<cflocation url="#userLanding#" addtoken="false">
	</cfif>
</cfif>

<!--- ********** OPEN/CLOSE ********** --->
<cfset projStatus = "open" />  <!--- valid settings are "open" and "closed" - button logic checks ninjaList for "OPEN" --->
<cfset ninjaList = "nschrode,jburgoon,nichodan,bjmoelle" /> 
<!--- Turn off SAVE button for specific campuses   --->
<cfif ListFindNoCase('XX',urlCampus)>
	<cfset projstatus = "closed" />
</cfif>
<cfset disabledBtn = "" />
<cfif projStatus eq "closed"><cfset disabledBtn = "disabled"></cfif>
<cfset ninjaList =ListAppend(ninjaList,projStatus) />


<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>

<cfoutput>
	<div class="full_content">
			<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a> </h2>
			Currently set to <b>
							<cfif application.rateStatus eq "Vc">constant effective rates.
							<cfelseif application.rateStatus eq "V1">adjusted escalated rates.
							</cfif></b>
				<span class="sm-blue"> <i>v3 - #application.budget_year# of the #application.biennium# Biennium</i></span>
			<cfif REQUEST.AuthUser eq 'rstrouse' or ListFindNoCase(REQUEST.adminUsernames, REQUEST.AuthUser ) OR ListFindNoCase(REQUEST.campusFOusernames, REQUEST.AuthUser) OR ListFindNoCase(REQUEST.regionalUsernames, REQUEST.authUser)>
				<p><a href="revenue_Campus.cfm">Campus Page</a><span> -- </span><a href="revenue_University.cfm">University Page</a></p>
			</cfif>

			<cfform action="insert_web_submission.cfm?campus=#url.campus#&rc=#url.RC#">
				<div class="controlBar">
					<div class="controlBinTL">
						<select id="RCdropdown" name="RCdropdown" size="1" onchange="setSelectedRC(RCdropdown.value)">
							<option value="">
								--Campus/RC--
							</option>
							<cfloop query="getCampus">
								<cfif NOT IsNull(urlRC) AND urlCampus eq Mid(dropdown,1,2) AND urlRC eq Mid(dropdown,6,2)>
									<cfset selectedStatus = "selected">
								<cfelse>
									<cfset selectedStatus = "">
								</cfif>
								<option value="#dropdown#" #selectedStatus#> #dropdown# </option>
							</cfloop>
						</select>
					</div>
					<!-- End div controlBinTL -->

					<div class="controlBinTLC">
						<cfif ListLen(userAccessList.allfees_rcs) gt 1>
							<span class="med-black-inline">You are authorized to modify #userAccessList.allfees_rcs#.</span>
						</cfif>
					</div>
					<!-- End controlBinTLC -->

					<div class="controlBinTC">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel">
						<cfif urlCampus neq 'BL'>
						<!---temporarily disabled button per nschrode on 031022--->
							<input disabled id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate #application.rateStatus# Report for your RC"
					<cfif !ListFindNoCase(REQUEST.specialAccess, REQUEST.authuser) OR !dssIsOpen >
						#application.disabled#</cfif> /><br><span class="sm-blue">
									<a href="https://kb.iu.edu/d/alkh"><i>Available only when IUIE is open</i></a>
								  </span>
					</cfif>
					</div>	<!-- End div controlBinTC -->
				</div>	<!-- End of div controlBar -->

				<!---  Unique key for this data set is Campus, RC, Term, Account, and FeeCode  --->
				<cfif trim(urlRC) eq '81'>
					<cfset clearingSummarySelect = getClearingSummary(urlCampus,urlRC)>
					<cfinclude template="clearing_account.cfm">
				<cfelseif DataSelect.recordCount gt 0>
					<cfset enrllmtCount = getQueryResultCount(DataSelect)>
					<cfif Len(getCampus.recordCount) eq 0>		<!--- Placeholder for empty query results  --->
						Campus RecordCount is 0.
				</cfif>
				<h2>Graduate Credit Hours</h2><button id="gradClicker" type="button" class="sm-green">Show/Hide Grad table</button>
				<p>We have set this table to contain what we believe are your "main" graduates.  All others are in a table at the bottom of the page.  We can change this setting for you if you wish.</p>
				<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />	
				<cfinclude template="feetable_grad.cfm" >
								
				<h2>Undergraduate Credit Hours</h2><button id="ugClicker" type="button" class="sm-green">Show/Hide Undergrad table</button>
				<p>We have set this table to contain only your summer undergraduate enrollments.  All others are in a clearing account table for your campus fiscal officer.</p>
				<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
				<cfinclude template="feetable_undergrad.cfm" >


				<!--- Jump through some hoops to see if there are any non-GRAD, non-UGRD academic career lines left in the data --->
				<cfset careerList = ValueList(enrllmtCount.ACAD_CAREER) />
				<cfif ListLen(careerList) gt 0>
					<h2>Other Enrollments</h2><button id="othClicker" type="button" class="sm-green">Show/Hide Other Enrollments table</button>
					<p>We have set this table to contain miscellaneous graduate enrollments.  If there are any you prefer to appear in the table at the top of the page, we will be happy to change that for you.</p>
					<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
					<cfinclude template="feetable_special.cfm" >
				</cfif>

				<!--- Special OCC table for IN Fiscal Officer --->
					<cfif urlCampus eq "IN" AND urlRC eq "80">
						<h2>OCC Enrollments</h2><button id="occClicker" type="button" class="sm-green">Show/Hide OCC table</button>
						<p>We have set this table to contain OCC enrollments.</p>
						<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
						<cfinclude template="feetable_OCC.cfm" >

				<!--- Special Banded enrollments table for IN Fiscal Officer  --->
						<h2>Banded Enrollments</h2><button id="bandClicker" type="button" class="sm-green">Show/Hide Banded table</button>
						<p>We have set this table to contain only Banded enrollments.</p>
						<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
						<cfinclude template="feetable_banded.cfm" >					
					</cfif>

					<!--- No FCP conditional include --->
					<cfif ListFindNocase("77,80,81",urlRc)>
						<h2>No FCP Hours (formerly "Unlinked")</h2><button id="fcpClicker" type="button" class="sm-green">Show/Hide Unlinked table</button>
						<p>These are the unlinked credit hours to match the Official Census count. "NO FCP" rows occur when we have fee-paying credit hours of enrollment from Official Census, but we do not find a matching course in FCP to retrieve financial data. We provide those rows here so that the credit hours can be properly tied back from the Projector to the Official Census.</p>	
						<input #disabledBtn# id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
						<cfinclude template="no_fcp.cfm" >
					</cfif>
					<!--- end No FCP section --->
				<cfelse>
					<cflocation url="#userLanding#" addtoken="false">
				</cfif>

				<cfif isDefined("Url") AND StructKeyExists(Url, "Campus") AND StructKeyExists(Url, "RC")>
					<input hidden="hidden" value="#urlCampus#" name="urlCAMPUS" />
					<input hidden="hidden" value="#urlRC#" name="urlRC" />
				</cfif>
			</cfform>
	</div>
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">