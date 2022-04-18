<!DOCTYPE HTML><html class="no-js ie9" itemscope="itemscope" itemtype="http://schema.org/WebSite" lang="en-US"><head prefix="og: http://ogp.me/ns# profile: http://ogp.me/ns/profile# article: http://ogp.me/ns/article#"><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0" name="viewport"/><title>Web Framework: Indiana University</title><meta content="template, website, branding, build, developer, programmer" name="keywords"/><meta content="The Web Framework is an implementation of the Web Style Guide and branding. It's built using IU's supported content management system." name="description"/><meta content="IE=edge" http-equiv="X-UA-Compatible"/><link href="https://assets.iu.edu/favicon.ico" rel="shortcut icon" type="image/x-icon"/><!-- Canonical URL --><link href="https://framework.iu.edu/index.html" itemprop="url" rel="canonical"/><!-- Facebook Open Graph --><meta content="https://framework.iu.edu/images/clock.jpg" property="og:image"/><meta content="IU Framework" property="og:title"/><meta content="The IU Framework is an implementation of the IU Style Guide and branding. It's built using IU's supported content management system." property="og:description"/><meta content="https://framework.iu.edu/index.html" property="og:url"/><meta content="Web Framework" property="og:site_name"/><meta content="en_US" property="og:locale"/><meta content="website" property="og:type"/><!-- Twitter Card Tags --><meta content="https://framework.iu.edu/images/clock.jpg" name="twitter:image:src"/><meta content="IU Framework" name="twitter:title"/><meta content="The IU Framework is an implementation of the IU Style Guide and branding. It's built using IU's supported content management system." name="twitter:description"/><meta content="@indianauniv" name="twitter:site"/><meta content="@indianauniv" name="twitter:creator"/><meta content="summary_large_image" name="twitter:card"/><meta content="Web Framework" itemprop="name"/><meta content="The Web Framework is an implementation of the Web Style Guide and branding. It's built using IU's supported content management system." itemprop="description"/>
            
            
<link as="font" crossorigin="" href="https://fonts.iu.edu/fonts/benton-sans-regular.woff" rel="preload" type="font/woff2"/>
<link as="font" crossorigin="" href="https://fonts.iu.edu/fonts/benton-sans-bold.woff" rel="preload" type="font/woff2"/>
<link rel="preconnect" href="https://fonts.iu.edu" crossorigin=""/>
<link rel="dns-prefetch" href="https://fonts.iu.edu"/>

<link rel="stylesheet" type="text/css" href="//fonts.iu.edu/style.css?family=BentonSans:regular,bold|BentonSansCond:regular,bold|GeorgiaPro:regular|BentonSansLight:regular">

<link rel="stylesheet" href="//assets.iu.edu/web/fonts/icon-font.css" media="screen">

<link rel="stylesheet" href="//assets.iu.edu/web/3.2.x/css/iu-framework.min.css?2022-02-03">
<link rel="stylesheet" href="css/brand.css">
<link rel="stylesheet" href="//assets.iu.edu/search/3.2.x/search.min.css?2020-12-03">

<script src="//assets.iu.edu/web/1.5/libs/modernizr.min.js"></script>               
                            
<link href="https://framework.iu.edu/_assets/css/site.css" rel="stylesheet" type="text/css">
<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
            
                       
                                  
</head>

<body class="mahogany no-banner has-page-title landmarks" id="home">
                         
<header id="header">
                                                               
<div id="branding-bar" class="iu" style="width: 100%; position: fixed; top: 0px; z-index: auto;" itemscope="itemscope" itemtype="http://schema.org/CollegeOrUniversity">
	<div class="row pad">
			<img src="//assets.iu.edu/brand/3.2.x/trident-large.png" alt="" />
			<p id="iu-campus">
				<a href="https://www.iu.edu" title="Indiana University">
					<span id="campus-name" class="show-on-desktop" itemprop="name">Indiana University</span>
					<span class="show-on-tablet" itemprop="name">Indiana University</span>
					<span class="show-on-mobile" itemprop="name">IU</span>
				</a>
			</p>
	</div>
</div>
       
            </header>
			
			<br><br>
			                           
<div class="collapsed bg-none section">
                                       
        			
<CFQUERY DATASOURCE="#application.datasource#" NAME="DATABASE">
SELECT * FROM fee_user.pm_calendar    
</CFQUERY>

<table id="example" class="display" style="width: 100%; margin: 0 20px 0 20px;">
<thead>
				<th style="text-align: center; font-weight: 600;">CALENDAR ID</TH>
				<th style="text-align: center; font-weight: 600;">FISCAL YEAR</TH>
				<TH style="text-align: center; font-weight: 600;">CAL LAYER</TH>
                <TH style="text-align: center; font-weight: 600;">PUBLISH FLAG</TH>
				<TH style="text-align: center; font-weight: 600;">START DATE</TH>
				<TH style="text-align: center; font-weight: 600;">START DESC MAIN</TH>
				<TH style="text-align: center; font-weight: 600;">START DESC SUB</TH>
				<TH style="text-align: center; font-weight: 600;">DEADLINE DATE</TH>
				<TH style="text-align: center; font-weight: 600;">DEADLINE DESC MAIN</TH>
			    <TH style="text-align: center; font-weight: 600;">DEADLINE DESC SUB</TH>
			    <TH style="text-align: center; font-weight: 600;">COMPLETED FLAG</TH>
				<TH style="text-align: center; font-weight: 600;">RESPONSIBLE</TH>
				<TH style="text-align: center; font-weight: 600;">CREATED DATE</TH>
				<TH style="text-align: center; font-weight: 600;">UPDATED DATE</TH>
				<TH style="text-align: center; font-weight: 600;">UPDATED BY</TH>
				<TH style="text-align: center; font-weight: 600;">TAG</TH>
				<TH style="text-align: center; font-weight: 600;">META</TH>
				<TH style="text-align: center; font-weight: 600;">SORT</TH>
				<TH style="text-align: center; font-weight: 600;">HYPERLINK</TH>
				<TH style="text-align: center; font-weight: 600;">NOTE</TH>
</thead>
<cfoutput><CFLOOP QUERY="DATABASE">

			         <tr>
					 	<td style="text-align: center;">#cal_id#</td>
						<td>#fiscal_year#</td>
						<td style="text-align: center;">#cal_layer#</td>
						<td style="text-align: center;">#publish_flag#</td>
						<td>#start_date#</td>
						<td>#start_desc_main#</td>
						<td>#start_desc_sub#</td>
						<td>#deadline_date#</td>
						<td style="text-align: center;">#deadline_desc_main#</td>
						<td style="text-align: center;">#deadline_desc_sub#</td>
						<td style="text-align: center;">#completed_flag#</td>
						<td>#responsible#</td>
						<td>#created_date#</td>
						<td>#updated_date#</td>
						<td style="text-align: center;">#updated_by#</td>
						<td style="text-align: center;">#tag#</td>
						<td style="text-align: center;">#meta#</td>
						<td>#sort#</td>
						<td style="text-align: center;">#hyperlink#</td>
						<td style="text-align: center;">#note#</td>
				     </tr>               					
</CFLOOP>

 <tfoot>
            <tr>
                <th>CALENDAR ID</th>
                <th>FISCAL YEAR</th>
                <th>Office</th>
                <th>Age</th>
                <th>Start date</th>
                <th>Salary</th>
				<TH>START DESC SUB</TH>
				<TH>DEADLINE DATE</TH>
				<TH>DEADLINE DESC MAIN</TH>
			    <TH>DEADLINE DESC SUB</TH>
			    <TH>COMPLETED FLAG</TH>
				<TH style="text-align: center; font-weight: 600;">RESPONSIBLE</TH>
				<TH style="text-align: center; font-weight: 600;">CREATED DATE</TH>
				<TH style="text-align: center; font-weight: 600;">UPDATED DATE</TH>
				<TH style="text-align: center; font-weight: 600;">UPDATED BY</TH>
				<TH style="text-align: center; font-weight: 600;">TAG</TH>
				<TH style="text-align: center; font-weight: 600;">META</TH>
				<TH style="text-align: center; font-weight: 600;">SORT</TH>
				<TH style="text-align: center; font-weight: 600;">HYPERLINK</TH>
				<TH style="text-align: center; font-weight: 600;">NOTE</TH>
            </tr>
        </tfoot>
</table>
</cfoutput>
			                                                                 
    
</div>

<footer style="width: 100%; position: fixed; bottom: 0px; z-index: auto; background-color: #7D110c; height: 40px;">
                              
                          
      <!-- Include Javascript -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="https://assets.iu.edu/web/3.2.x/js/iu-framework.min.js?v=2"></script>
<script src="https://assets.iu.edu/search/3.2.x/search.min.js"></script>
<script src="https://framework.iu.edu/_assets/js/site.js"></script>
               
                            
    </body>
	</html>