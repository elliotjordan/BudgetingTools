<!--- 
	file:	staff_header.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	12-2-14
	update:	12-2-14
	note:	Staff head element with contents; assumes some tags will be closed in the footer.
 --->
<cfheader name="Expires" value="-1">
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
	    <meta name="Keywords" content="Indiana University, IU, Budget Office, Fee Request, Regional campus">
	    <meta name="Description" content="Indiana University Budget Office - Budgeting Tools">
	    <meta http-equiv="Pragma" content="no-cache">
	    <meta http-equiv="Expires" content="-1">
		<meta http-equiv="x-ua-compatible" content="ie=edge" >
		<meta name="Copyright" content="Copyright 2014, The Trustees of Indiana University">
		<meta name="last-modified" content="2014-11-14" >
		<meta name="audiences" content="default" >
		<meta name="owner-group" content="budu" >
		
		<title>University Budget Office - Budgeting Tools</title>

		<link href="https://www.iu.edu/favicon.ico" rel="icon" />
	    <link href="../css/screen2.css" rel="stylesheet" type="text/css" media="screen">
	    <!--<link href="css/screen.css" rel="stylesheet" type="text/css" media="screen">-->
	    <link href="../css/print.css" rel="stylesheet" type="text/css" media="print">	
        <link href="../_iu-brand/css/base.css" rel="stylesheet" type="text/css" />
        <link href="../_iu-brand/css/wide.css" media="(min-width: 48.000em)" rel="stylesheet" type="text/css" />
        <script src="../js/jquery-1.11.2.min.js"></script>
		<script src="../js/jquery-migrate-1.2.1.min.js"></script>
        <script src="../js/jquery.dataTables.min.js"></script>
        <script src="../js/dataTables.fixedHeader.min.js"></script>
	</head>

	<body>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a href="http://www.iub.edu/">
	                    	<img src="../_iu-brand/img/trident-tab.gif" height="73" width="64" alt=" " />
	                        <span class="line-break">Indiana University</span>
	                    </a>
	                </p>
	            </div>
	        </div>
	    </div>
	    <!-- END INDIANA UNIVERSITY BRANDING BAR -->
		<cfinclude template="staff_top_menu.cfm">
