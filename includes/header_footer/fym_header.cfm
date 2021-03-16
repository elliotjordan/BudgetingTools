<cfinclude template="../functions/user_functions.cfm" runonce="true" />
<cfset currentUser = getFYMUser(REQUEST.authUser) />
<cfset current_inst = getFocus(currentUser.username).focus /> 
<!--- ALLFEES HEADER  --->
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

		<meta name="Copyright" content="Copyright 2020, The Trustees of Indiana University">
		<meta name="last-modified" content="2021-01-21" >
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
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR in the ALLFEES HEADER -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a class="tiny" href="http://www.iub.edu/">&nbsp;</a>
	                	<a href="https://budu.iu.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt="IU Trident logo" />
	                        <span class="line-break">INDIANA UNIVERSITY BUDGET OFFICE - 5YR MODEL PORTAL</span>
	                    </a>
						<span class="link_hilight"><a href="instructions.cfm">Instructions</a></span>
						
						<span class="link_hilight targetLink">
							<a href="index.cfm">Model #current_inst#</a> 
							<cfif Len(currentUser.fym_inst) neq 1>
								<cfset CurrentURL = 'https://' & cgi.HTTP_HOST & CGI.SCRIPT_NAME>
								<cfloop list="#currentUser.fym_inst#" index="choice">
									<cfif choice neq current_inst>
										<a href="../emulate_user.cfm?target=#choice#&url=#CurrentURL#">| #choice#</a> 
									</cfif>
								</cfloop>
							</cfif>
						</span>
						<span class="link_hilight"><a href="CrHrProjections.cfm">Credit Hours</a></span>
						<span class="link_hilight"><a href="params.cfm">Parameters</a></span>
						<span class="link_hilight"><a href="fym_excel.cfm">FYM Data (#current_inst#)</a></span>
						<span class="link_hilight"><a href="uploads.cfm">Uploads</a></span>
						<cfif ListFindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
							<!---<span class="link_hilight"><a href="fym_param_excel.cfm">FYM Params (Table)</a></span>--->
							<!---<span class="link_hilight"><a href="fym_interface_excel.cfm">FYM Model (Interface)</a></span>--->
						</cfif>
	                </p>
	                <cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser) OR ListFindNoCase(REQUEST.regionalUsernames, REQUEST.authUser)>
	                	 <!---<span class="headerFarRight">
	                	 <form id="emulationForm" action="..\emulate_user.cfm" method="post">
	                	 	<input id="emulateInput" class="emu" type="text" name="usernameInput" size="15" width="30" maxlength="8" alt="input for username you wish to emulate" placeholder="Enter campus code" />
	                	 	<input id="emulateBtn" class="emu" type="submit" name="emulateBtn" value="Shazam!" />
	                	 </form>
	                	 </span>--->
	                </cfif>
	            </div>
	        </div>
	    </div>
		</cfoutput>
