<!--- ALLFEES HEADER  --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>UBO - Master Fee List</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">	<!-- Tell IE what to do, because Microsoft products are like that -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
		<meta name="Keywords" content="Indiana University, IU, Budget Office, Fee Request, Regional campus, Budget tools">
		<meta name="Description" content="Indiana University Budget Office - Budgeting Tools">
		<meta http-equiv="cache-control" content="no-cache, no-store, must-revalidate, post-check=0, pre-check=0">  <!--- Always get a fresh version, needed for CAS --->
		<meta http-equiv="expires" content="-1">
		<meta http-equiv="pragma" content="no-cache">

		<meta name="Copyright" content="Copyright 2020, The Trustees of Indiana University">
		<meta name="last-modified" content="2020-12-03" >
		<meta name="audiences" content="default" >
		<meta name="owner-group" content="budu" >
		<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- insure page width and zoom on any device -->

		<link href="https://www.iu.edu/favicon.ico" rel="icon" />
	    <link href="../css/screen2.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="../js/datatables.min.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="../css/print.css" rel="stylesheet" type="text/css" media="print">
        <link href="../_iu-brand/css/base.css" rel="stylesheet" type="text/css" />
        <link href="../_iu-brand/css/wide.css" media="(min-width: 48.000em)" rel="stylesheet" type="text/css" />

		<script src="../js/jQuery-1.12.3/jquery-1.12.3.min.js"></script>
        <script src="../js/datatables.min.js"></script>
        <script src="../js/dataTables.buttons.min.js"></script>
        <script src="../js/revenue.js"></script>
        <script src="../js/all_fees.js"></script>
		<script src="../js/UBOvalidations.js"></script>
	</head>

	<body>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR in the ALLFEES HEADER -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a class="tiny" href="http://www.iub.edu/"> </a>
	                	<a href="https://budu.iu.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt="IU Trident logo" />
	                        <span class="line-break">INDIANA UNIVERSITY BUDGET OFFICE - FEE REQUEST PORTAL</span>
						</a>
<!--- HIDE ALL LINKS EXCEPT MASTER LIST
<cfif REQUEST.authUser neq "gbourkl">
		<span class="link_hilight"><a href="index.cfm">Non-Instructional Fees</a></span>
</cfif> --->

<!---	<span class="link_hilight"><a href="tuition.cfm">Tuition & Mandatory Fees</a></span> --->

	<cfset imposter = 'blork'>
	<cfif FindNoCase(REQUEST.authUser,REQUEST.developerUsernames)
	      OR FindNoCase(REQUEST.authUser,REQUEST.adminUsernames)
	      OR FindNoCase(REQUEST.authUser,REQUEST.campusFOusernames)
	      OR FindNoCase(REQUEST.authUser,REQUEST.regionalUsernames)
	      OR FindNoCase(REQUEST.authUser,REQUEST.bursarUsernames)
	      OR FindNoCase(REQUEST.authUser,REQUEST.cfoUsernames)
	      >
		<span class="link_hilight"><a href="all_fees.cfm">Master List</a></span>
		<!---<span class="link_hilight"><a href="campus_controls.cfm">New/Pending Requests</a></span>--->
	</cfif>

	<cfif REQUEST.authUser neq imposter AND (FindNoCase(REQUEST.authUser,REQUEST.regionalUsernames) OR FindNoCase(REQUEST.authUser,REQUEST.adminUsernames))>
		<span class="link_hilight"><a href="regional_controls.cfm">Regional Controls</a></span>
	</cfif>

<!---	<cfif REQUEST.authUser neq imposter AND (FindNoCase(REQUEST.authUser,REQUEST.bursarUsernames) OR FindNoCase(REQUEST.authUser,REQUEST.adminUsernames))>
		<span class="link_hilight"><a href="bursar_controls.cfm">Bursar Controls</a></span>
	</cfif>--->
<!---
	<cfif REQUEST.authUser neq imposter AND (FindNoCase(REQUEST.authUser,REQUEST.cfoUsernames) OR FindNoCase(REQUEST.authUser,REQUEST.adminUsernames))>
		<span class="link_hilight"><a href="cfo_controls.cfm">CFO Controls</a> </span>
	</cfif>

	<cfif REQUEST.authUser neq imposter AND FindNoCase(REQUEST.authUser,REQUEST.adminUsernames)>
		<span class="link_hilight"><a href="fee_controls.cfm">UBO Controls</a> </span>
	</cfif>
END HIDING ALL OTHER LINKS	--->


<!--- HIDE LINK
	<cfif FindNoCase(REQUEST.authUser,REQUEST.developerUsernames) OR ListFindNoCase("gbourkl", REQUEST.authUser)>
		<span class="link_hilight"><a href="housing.cfm">Housing Fees</a></span>
	</cfif>
--->
<!---	<cfif REQUEST.authUser neq 'blork' AND FindNoCase(REQUEST.authUser,REQUEST.developerUsernames)>
		<span class="link_hilight"><a href="preferences.cfm">Preferences</a></span>
	</cfif>
--->
	<!---Upcoming Training Schedule:
	    <a href="../includes/forms/UBO_FEE_10_19_18.ics">Friday, October 19, 2018 at 10am and 2pm</a>
	--->
	<span class="link_hilight"><a href="mailto:budu@iu.edu?subject=Request for Fee Solicitation Training">Training</a></span>
	<span class="link_hilight"><a href="../includes/forms/Student and Other University Fees Quick Guide.pdf" target="_blank">Fee Quick Guide</a> </span>
	<!---<span class="link_hilight"><a href="../includes/forms/Fee Request Portal User Guide.docx">Fee Request Portal User Guide</a> </span>--->

	                </p>

	                <cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser)>
	                	<span class="headerFarRight">
	                	 <form id="emulationForm" action="..\emulate_user.cfm" method="post">
	                	 	<input id="emulateInput" class="emu" type="text" name="usernameInput" size="9" width="20" maxlength="8" alt="input for username you wish to emulate" />
	                	 	<input id="emulateBtn" class="emu" type="submit" name="emulateBtn" value="Shazam!" />
	                	 </form>
	                	</span>
	                </cfif>
	            </div>
	        </div>
	    </div>

	    <!-- END INDIANA UNIVERSITY BRANDING BAR -->
		<cfinclude template="top_menu.cfm">

<!---	<cfif !ListFindNoCase(REQUEST.adminUsernames,REQUEST.authuser) AND NOT StructKeyExists(url,"message")>
		<cflocation url="closed.cfm?message=Closed" addtoken="false" >
	</cfif>--->


