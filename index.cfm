<!--- 
	file:	index.cfm
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	1-4-16
	update:	11-2-17
	note:	Main page
 --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>University Budget Office - Budgeting Tools</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">				<!-- Tell IE what to do, because Microsoft products are like that -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
		<meta name="Keywords" content="Indiana University, IU, Budget Office, Fee Request, Regional campus, Budget tools">
		<meta name="Description" content="Indiana University Budget Office - Budgeting Tools">
		<meta http-equiv="cache-control" content="no-cache, no-store, must-revalidate, post-check=0, pre-check=0">  <!--- Always get a fresh version, needed for CAS --->
		<meta http-equiv="expires" content="-1">
		<meta http-equiv="pragma" content="no-cache">		
		<meta name="Copyright" content="Copyright 2016, The Trustees of Indiana University">
		<meta name="last-modified" content="2017-11-3" >
		<meta name="audiences" content="default" >
		<meta name="owner-group" content="budu" >
		<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- insure page width and zoom on any device -->
		<link href="https://www.iu.edu/favicon.ico" rel="icon" />
	    <link href="css/screen2.css" rel="stylesheet" type="text/css" media="screen">
	    <link href="css/print.css" rel="stylesheet" type="text/css" media="print">	
        <link href="_iu-brand/css/base.css" rel="stylesheet" type="text/css" />
        <link href="_iu-brand/css/wide.css" media="(min-width: 48.000em)" rel="stylesheet" type="text/css" />
	</head>

	<!--- TODO: Go back to using the index page as the starting point for all logins.
	      TODO: Consult the USERS table and determine the default location for the user. --->
	<body>
		<!-- BEGIN INDIANA UNIVERSITY BRANDING BAR -->
	    <div id="branding-bar">
	    	<div class="bar">
	        	<div class="wrapper">
	            	<p class="campus">
	                	<a href="http://www.iub.edu/">
	                    	<img src="_iu-brand/img/trident-tab.gif" height="73" width="64" alt=" " />
	                        <span class="line-break">Indiana University</span>
	                    </a>
	                </p>
	            </div>
	        </div>
	    </div>
	    <!-- END INDIANA UNIVERSITY BRANDING BAR -->
		<div id="header-wrap-outer" role="banner">
			<div id="header-wrap-inner">
				<div id="header">
					<h1>IU Budget Office Budgeting Tools</h1>
				</div>
			</div>
		</div>	

<cfoutput>

	<div class="content">
		<cflocation url="AllFees/tuition.cfm" addtoken="false" />
	</div>

</cfoutput>	
<cfinclude template="includes/header_footer/footer.cfm">
