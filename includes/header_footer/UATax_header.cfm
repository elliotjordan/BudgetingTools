<!--- UATAX HEADER  --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>IU UBO - UA Support</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">				<!-- Tell IE what to do, because Microsoft products are like that -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
		<meta name="Keywords" content="Indiana University, IU, Budget Office, UA Support, Budgeting tools">
		<meta name="Description" content="Indiana University Budget Office - Budgeting Tools - UA Support">
		<meta http-equiv="cache-control" content="no-cache, no-store, must-revalidate, post-check=0, pre-check=0">  <!--- Always get a fresh version, needed for CAS --->
		<meta http-equiv="expires" content="-1">
		<meta http-equiv="pragma" content="no-cache">		
															
		<meta name="Copyright" content="Copyright 2020, The Trustees of Indiana University">
		<meta name="last-modified" content="2020-03-23" >
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
	</head>

	<body>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR in the ALLFEES HEADER -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a class="tiny" href="http://www.iub.edu/">&nbsp;</a>
	                	<a href="https://budu.iu.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt="IU Trident logo" />
	                        <span class="line-break">INDIANA UNIVERSITY BUDGET OFFICE - UA SUPPORT PORTAL</span>
	                    </a>
						<span class="link_hilight"><a href="index.cfm">Home</a></span>
						<span class="link_hilight"><a href="UATax_summary.cfm">Summary</a></span>
						<span class="link_hilight"><a href="UATax_adjBase.cfm">Annual Change Details</a></span>
						<span class="link_hilight"><a href="UATax_campus_assessments.cfm">Campus Assessments</a></span>
						<span class="link_hilight"><a href="UATax_alloc.cfm">Allocated By Unit</a></span>
						<span class="link_hilight"><a href="UATax_alloc_RC77.cfm">RC77</a></span>
						<span class="link_hilight"><a href="UATax_detail.cfm">Detail</a></span>
						<span class="link_hilight"><a href="UATax_history.cfm">History</a></span>
					<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser)>
						<span class="link_hilight"><a href="UATax_scenarios.cfm">Scenarios</a></span>
					</cfif>
	                </p>
	            </div>
	        </div>
	    </div>

 