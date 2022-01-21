<cfinclude template="../functions/user_functions.cfm" runonce="true" />
<cfinclude template="../functions/fym_functions.cfm" runonce="true" />
<cfset currentUser = getFYMUser(REQUEST.authUser) />
<cfset current_inst = getFocus(currentUser.username).focus /> 
<cfset current_scenario = currentUser.fym_scenario_focus />
<cfset scenario_details = getCurrentScenario(current_scenario) />

<cfif true>  <!--- ListFindNoCase('XY',current_inst) or REQUEST.authUser eq 'sbadams'> --->  
	<cfset openModel = true />
<cfelse>
	<cfset openModel = false />
</cfif>
<cfif ListFindNoCase('ZZTop',current_inst) or ListFindNoCase('jopadams,sbadams,jburgoon,nschrode,ellijord,pyebei',REQUEST.authUser)>
	<cfset showScenarios = true />
<cfelse>
	<cfset showScenarios = false />
</cfif>

<!--- 5YM HEADER  --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<title>IU UBO - Budgeting Tools - 5YR MODEL</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">				<!-- Tell IE what to do, because Microsoft products are like that -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
		<meta name="Keywords" content="Indiana University, IU, Budget Office, 5Year Model, Budgeting tools">
		<meta name="Description" content="Indiana University Budget Office - Budgeting Tools - Five Year Model">
		<meta http-equiv="cache-control" content="no-cache, no-store, must-revalidate, post-check=0, pre-check=0">  <!--- Always get a fresh version, needed for CAS --->
		<meta http-equiv="expires" content="-1">
		<meta http-equiv="pragma" content="no-cache">
		<meta name="Copyright" content="Copyright 2021, The Trustees of Indiana University">
		<meta name="last-modified" content="2021-12-16" >
		<meta name="audiences" content="default" >
		<meta name="owner-group" content="budu" >
		<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- insure page width and zoom on any device -->

		<link href="https://www.iu.edu/favicon.ico" rel="icon" />
	    
	    <link href="../js/datatables.min.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="../css/print.css" rel="stylesheet" type="text/css" media="print">
        <link href="../_iu-brand/css/base.css" rel="stylesheet" type="text/css" />
        <link href="../_iu-brand/css/wide.css" rel="stylesheet" type="text/css" />
		<link href="../css/screen2.css" rel="stylesheet" type="text/css" media="screen">
		<script src="../js/jQuery-1.12.3/jquery-1.12.3.min.js"></script>
        <script src="../js/datatables.min.js"></script>
        <script src="../js/dataTables.buttons.min.js"></script>
        <script src="../js/pm.js"></script>
	</head>

	<body>
		<cfoutput>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR in the FYM HEADER -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a class="tiny" href="http://www.iub.edu/">&nbsp;</a>
	                	<a href="https://budu.iu.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt="IU Trident logo" />
	                        <span class="line-break">INDIANA UNIVERSITY BUDGET OFFICE - 5YR MODEL PORTAL</span>
	                    </a>
						<span class="link_hilight"><a id="instrxnLink" href="instructions.cfm">Instructions</a></span>
						
						<span class="link_hilight targetLink"> 
							<a id="modelLink" href="index.cfm"><b>Model #current_inst#</b></a> 
							<cfif Len(currentUser.fym_inst) neq 1>
								<cfset CurrentURL = 'https://' & cgi.HTTP_HOST & CGI.SCRIPT_NAME>
								<cfloop list="#currentUser.fym_inst#" index="choice">
									<cfif choice neq current_inst>
										<a id="choiceLink" href="../emulate_user.cfm?target=#choice#&url=#CurrentURL#">| #choice#</a> 
									</cfif>
								</cfloop>
							</cfif>
						</span>
						<span class="link_hilight"><a id="crHrLink" href="CrHrProjections.cfm">Credit Hours</a></span>
					<cfif showScenarios AND (listFindNoCase(REQUEST.adminUsernames, currentUser.username) OR ListFindNoCase(REQUEST.regionalUsernames, currentUser.username))>
						<span class="link_hilight"><a id="scenLink" href="scenarios.cfm">Scenarios (#current_scenario#)</a></span> 
						<span class="link_hilight"><a id="scenCompLink" href="fym_comparison.cfm">Comparisons (#current_scenario#)</a></span> 
					</cfif>
						<span class="link_hilight"><a id="paramLink" href="params.cfm">Parameters</a></span>
						<span class="link_hilight"><a id="dataLink" href="fym_excel.cfm">FYM Data (#current_inst#)</a></span>
						<span class="link_hilight"><a id="uploadLink" href="uploads.cfm">Uploads</a></span>
	                </p>
	            </div>
	        </div>
	    </div>
		</cfoutput>
