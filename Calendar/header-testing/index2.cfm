<!DOCTYPE HTML>
<html class="no-js ie9" itemscope="itemscope" lang="en-US">
<head>
<meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>UBO Calendar Application</title>
<meta content="noindex" name="robots"/>
<meta content="UBO, Budget, Calendar, indiana, bloomington" name="keywords"/>
<meta content="Alicia's calendar." name="description"/>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>

<link href="https://assets.iu.edu/favicon.ico" rel="shortcut icon" type="image/x-icon"/><!-- Canonical URL -->
<link href="https://budget.iu.edu/documentation/calendars.php" itemprop="url" rel="canonical"/><meta content="UBO Calendar" property="og:title"/>
<meta content="website" property="og:type"/>            
            
<script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-3.5.1.js"></script>			
<script data-search-pseudo-elements defer src="https://kit.fontawesome.com/44624c8523.js"></script> 
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>  
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.2.2/css/fixedHeader.dataTables.min.css">      
           
<link as="font" crossorigin="" href="https://fonts.iu.edu/fonts/benton-sans-regular.woff" rel="preload" type="font/woff2"/>
<link as="font" crossorigin="" href="https://fonts.iu.edu/fonts/benton-sans-bold.woff" rel="preload" type="font/woff2"/>
<link rel="preconnect" href="https://fonts.iu.edu" crossorigin=""/>
<link rel="dns-prefetch" href="https://fonts.iu.edu"/>

<link rel="stylesheet" type="text/css" href="//fonts.iu.edu/style.css?family=BentonSans:regular,bold|BentonSansCond:regular,bold|GeorgiaPro:regular|BentonSansLight:regular">

<link rel="stylesheet" href="//assets.iu.edu/web/fonts/icon-font.css" media="screen">

<link rel="stylesheet" href="https://assets.iu.edu/web/3.2.x/css/iu-framework.min.css?2022-02-03">
<link rel="stylesheet" href="css/brand.css">
<link rel="stylesheet" href="https://assets.iu.edu/search/3.2.x/search.min.css?2020-12-03">

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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

					
			
<h2 style="padding: 20px 0 0 40px;" class="section-title">Calendar 2022</h2>

<CFQUERY DATASOURCE="#application.datasource#" NAME="DATABASE">
SELECT * FROM fee_user.pm_calendar    
</CFQUERY>

<table id="example" class="display" style="width:100%">
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
			                                               
						
                              <!-- Include Javascript -->

<script>
$(document).ready(function () {
    // Setup - add a text input to each footer cell
    $('#example thead tr')
        .clone(true)
        .addClass('filters')
        .appendTo('#example thead');
 
    var table = $('#example').DataTable({
        orderCellsTop: true,
        fixedHeader: true,
        initComplete: function () {
            var api = this.api();
 
            // For each column
            api
                .columns()
                .eq(0)
                .each(function (colIdx) {
                    // Set the header cell to contain the input element
                    var cell = $('.filters th').eq(
                        $(api.column(colIdx).header()).index()
                    );
                    var title = $(cell).text();
                    $(cell).html('<input type="text" placeholder="' + title + '" />');
 
                    // On every keypress in this input
                    $(
                        'input',
                        $('.filters th').eq($(api.column(colIdx).header()).index())
                    )
                        .off('keyup change')
                        .on('keyup change', function (e) {
                            e.stopPropagation();
 
                            // Get the search value
                            $(this).attr('title', $(this).val());
                            var regexr = '({search})'; //$(this).parents('th').find('select').val();
 
                            var cursorPosition = this.selectionStart;
                            // Search the column for that value
                            api
                                .column(colIdx)
                                .search(
                                    this.value != ''
                                        ? regexr.replace('{search}', '(((' + this.value + ')))')
                                        : '',
                                    this.value != '',
                                    this.value == ''
                                )
                                .draw();
 
                            $(this)
                                .focus()[0]
                                .setSelectionRange(cursorPosition, cursorPosition);
                        });
                });
        },
    });
});
</script>

                              

               
                            
    </body>
	</html>        
                                            