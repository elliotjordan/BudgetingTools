<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/revenue_functions.cfm">
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

<cfif isDefined("Url") AND StructKeyExists(Url, "Campus") AND StructKeyExists(Url, "RC")>
	<cfset urlCampus = url.Campus>
	<cfset urlRC = url.RC>
	<cfset DataSelect = getProjectinatorData(urlCampus, urlRC)>
	<cfset getCampus = getCampusAndRC(urlcampus)>
	<cfset totProjCount = getProjCount()>
	<cfset ptg = getUBO_TOOL_SETTINGS(urlCampus,urlRC)>
<cfelse>  <!--- removes the problem of users clicking the CHRP link at the top of the page and getting an error due to no campus setting in the link.  Duh.  --->
	<cfif FindNoCase("campus",userLanding) gt 0>
		<cflocation url="#userLanding#" addtoken="false">
	</cfif>
</cfif>

<cfif getUserActiveSetting(REQUEST.authuser) eq 'N'>
	<cflocation url="no_access.cfm" addtoken="false" >
</cfif>

<cfoutput>
	<div class="full_content">
		<cfinclude template="prod_banner.cfm" runonce="true">
			<h2><a href="revenue_RC.cfm">Credit Hour Revenue Projector</a> <span class="sm-blue"> <i>v3 - Short Year</i></span></h2>
			<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.AuthUser ) OR ListFindNoCase(REQUEST.campusFOusernames, REQUEST.AuthUser)>
				<p><a href="revenue_Campus.cfm">Campus Page</a><span> -- </span><a href="revenue_University.cfm">University Page</a></p>
			</cfif>
			<!-- End div controlBinTR -->
			<cfform action="insert_web_submission.cfm">
				<div class="controlBar">
					<div class="controlBinTL">
						<select id="RCdropdown" name="RCdropdown" size="1" onchange="setSelectedRC(RCdropdown.value)">
							<option value="">
								--Campus/RC--
							</option>
							<cfloop query="getCampus">  
								<cfif getCampus.rc_cd eq '52' and getCampus.fin_coa_cd eq 'IN'>  <!--- omg what a hack, please don't look at me like that --->
									<option value="IN - 46 - IUPU COLUMBUS" <cfif urlCampus eq "IN" AND NOT IsNull(urlRC) AND  urlRC eq "46">selected</cfif>>IN - 46 - IUPU COLUMBUS</option>
								</cfif>
									<option value="#dropdown#" <cfif NOT IsNull(urlRC) AND urlCampus eq Mid(dropdown,1,2) AND urlRC eq Mid(dropdown,6,2)>selected</cfif>>#dropdown#</option>
							</cfloop>
						</select>
					</div>
					<!-- End div controlBinTL -->
					
					<div class="controlBinTLC">
						<cfif ListLen(userAccessList.allfees_rcs) gt 1>
							<span class="med-black-inline">You are authorized to modify #userAccessList.allfees_rcs#.</span>
						</cfif>
					</div>
					<!-- End controlBinTFL -->
					
					<div class="controlBinTRC">
						<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled >
					</div>
					<!-- End div controlBinTR -->
					
					<div class="controlBinTFR">
						<label for="VcRadio"><input id="VcRadio" name="Vtype" type="radio" value="Vc" <cfif application.rateStatus eq "Vc">checked="checked"</cfif>>Vc - Constant Rate</label>
						<br>
						<label for="V1Radio"><input id="V1Radio" name="Vtype" type="radio" value="V1" <cfif application.rateStatus eq "V1">checked="checked"</cfif>>V1 - Escalated Rate</label>
						<br>
						<input id="rateBtn" type="submit" name="rateBtn" class="submitBtn" value="Switch Rate Type">
						<input id="dwnldBtn" type="submit" name="dwnldBtn" class="dwnldBtn" value="Export All To Excel">
						<cfif urlCampus neq 'BL'>
							<br><input id="reportBtn" type="submit" name="reportBtn" class="reportBtn" value="Generate V1 Report for your RC" />
						</cfif>
					</div>
					<!-- End div controlBinTFR -->
										
				</div>
				<!-- End of div controlBar -->
				
				<!---  Unique key for this data set is Campus, RC, Term, Account, and FeeCode  --->
				<!---<cfif len(trim(urlCampus)) neq 0 & len(trim(urlRC)) neq 0>--->
				<cfif trim(urlRC) eq '81'>
					<cfset clearingSummarySelect = getClearingSummary(urlCampus,urlRC)>
					<cfinclude template="clearing_account.cfm">
				<cfelseif DataSelect.recordCount gt 0>
					<cfset enrllmtCount = getQueryResultCount(DataSelect)>
					<cfif Len(getCampus.recordCount) eq 0>		<!--- Placeholder for empty query results  --->
						Campus RecordCount is 0.  
					</cfif>
					<cfif 1>
						<h2>Graduate Credit Hours</h2>
						<p>We have set this table to contain what we believe are your "main" graduates.  All others are in a table at the bottom of the page.  We can change this setting for you if you wish.</p>
						<cfinclude template="feetable_grad.cfm" >
					</cfif>

					<cfif 1>
						<h2>Undergraduate Credit Hours</h2>
						<p>We have set this table to contain only your summer undergraduate enrollments.  All others are in a clearing account table for your campus fiscal officer.</p>
						<cfinclude template="feetable_undergrad.cfm" >
					</cfif>	
					
					<!--- Jump through some hoops to see if there are any non-GRAD, non-UGRD academic career lines left in the data --->
					<cfset careerList = ValueList(enrllmtCount.ACAD_CAREER) />
					<cfif ListLen(careerList) gt 0>
						<h2>Other Enrollments</h2>
						<p>We have set this table to contain miscellaneous graduate enrollments.  If there are any you prefer to appear in the table at the top of the page, we will be happy to change that for you.</p>
						<cfinclude template="feetable_special.cfm" >						
					</cfif>	
					<div class="controlBar">		
						<div class="controlBinTRC">
							<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled />
						</div>
					</div>

					<cfif urlCampus eq "IN" AND urlRC eq "80">
						<h2>OCC Enrollments</h2>
						<p>We have set this table to contain OCC enrollments.</p>
						<cfinclude template="feetable_OCC.cfm" >						

						<div class="controlBar">		
							<div class="controlBinTRC">
								<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled />
							</div>
						</div>

						<h2>Banded Enrollments</h2>
						<p>We have set this table to contain only Banded enrollments.</p>
						<cfinclude template="feetable_banded.cfm" >						

						<div class="controlBar">		
							<div class="controlBinTRC">
								<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled />
							</div>
						</div>
					</cfif>	
				<cfelse>
					<!--- TODO: Set this so it fails gracefully back to the RC selection dropdown ---> 
					<!---<cfdump var="#DataSelect#" ><cfabort>--->
					
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