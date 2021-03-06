<!DOCTYPE html>
<html lang="en">
	<head>
		<title>UBO Calendar</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">				<!-- Tell IE what to do, because Microsoft products are like that -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
		<meta name="Keywords" content="Indiana University, IU, Budget Office, Budget tools">
		<meta name="Description" content="Indiana University Budget Office - Calendar">
		<meta http-equiv="cache-control" content="no-cache, no-store, must-revalidate, post-check=0, pre-check=0">  <!--- Always get a fresh version, needed for CAS --->
		<meta http-equiv="expires" content="-1">
		<meta http-equiv="pragma" content="no-cache">		
															
		<meta name="Copyright" content="Copyright 2022, The Trustees of Indiana University">
		<meta name="last-modified" content="2022-04-19" >
		<meta name="audiences" content="default" >
		<meta name="owner-group" content="budu" >
		<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- insure page width and zoom on any device -->
		
		<link href="https://www.iu.edu/favicon.ico" rel="icon" />
	    <link href="../css/screen2.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="../js/datatables.min.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="../css/print.css" rel="stylesheet" type="text/css" media="print">	
        <link href="../_iu-brand/css/base.css" rel="stylesheet" type="text/css" />
        <link href="../_iu-brand/css/wide.css" media="(min-width: 48.000em)" rel="stylesheet" type="text/css" />
        
		<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
        <script src="../js/datatables.min.js"></script>
        <script src="../js/dataTables.buttons.min.js"></script>
	</head>

	<body>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a href="http://www.budu.iu.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt=" " />
	                        <span class="line-break">Indiana University Budget Office</span>
	                    </a>
	                </p>
	                <cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser) OR ListFindNoCase(REQUEST.regionalUsernames, REQUEST.authUser)> 
	                	<span class="headerUBO">
		                	<a href="UBO_controls.cfm"><input id="cockpitBtn" class="gangnamStyle" type="submit" name="cockpitBtn" value="Go To UBO Controls" /></a>
	                	</span>
	                	<span class="headerFarRight">
	                	 <form id="emulationForm" action="..\emulate_user.cfm" method="post">
	                	 	<input id="emulateInput" class="emu" type="text" name="usernameInput" size="15" width="30" maxlength="8" alt="input for username you wish to emulate" placeholder="Enter campus code" />
	                	 	<input id="emulateBtn" class="emu" type="submit" name="emulateBtn" value="Shazam!" />
	                	 </form>	
	                	</span>
	                </cfif>
	            </div>
	        </div>
	    </div>
	    <!-- END INDIANA UNIVERSITY BRANDING BAR -->
