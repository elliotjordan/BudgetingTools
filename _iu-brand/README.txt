INDIANA UNIVERSITY BRANDING BAR AND FOOTER

Overview and Instructions

----------------------------------------------------------------------------
For more information, see http://brand.iu.edu/
----------------------------------------------------------------------------

This branding bar and footer download has been created to enable anyone within Indiana University to build websites that conform to Indiana University's brand guidelines.


----------------------------------------------------------------------------
Web Standards
----------------------------------------------------------------------------

The files included in this download have been programmed using semantic HTML markup for structure and CSS for presentation and interactivity. They have been tested using the following operating systems and browsers:

Windows:
	
    * Chrome
    * Firefox
    * Safari
    * Internet Explorer
    * Opera

Mac:

    * Chrome
	* Firefox
    * Safari
	* Opera

Other:
	* iOS
	* Android


----------------------------------------------------------------------------
Instructions
----------------------------------------------------------------------------

These instructions assume a basic knowledge of HTML and CSS. 


1. Contents
----------------------------------------------------------------------------

The branding bar and footer download contains the following files and folders.

	* /_iu-brand/ - Master folder containing all branding bar and footer dependencies

		* /css/ - Cascading style sheets

		 	* base.css - Base layout
			* fixed.css - Fixed width layout and style adjustments (intended for legacy browsers and non-responsive implementations)
			* ie6.css - Internet Explorer 6 style adjustments
			* ie7.css - Internet Explorer 7 style adjustments
			* wide.css - Wide layout styles (optimized for devices and screen sizes 768 pixels and up)

	 	* /fonts/ - Fonts

		* /img/ - Images

		* /js/ - JavaScript

	* index.html - Default page with embedded branding bar and footer

	* search.html - Search results page


2. Adding the branding bar and footer
----------------------------------------------------------------------------

First you must copy the "_iu-brand" folder and its contents to your web account or server.

The index.html file contains the structure and content of the branding bar and footer. Three blocks of code within index.html begin and end with comments that describe their contents. To add the branding bar and footer to your pages, copy the contents of each of the following comment blocks to your pages:

	* INDIANA UNIVERSITY BRANDING BAR AND FOOTER <HEAD> ELEMENTS - This must appear in the <head> of your document
	
	* INDIANA UNIVERSITY BRANDING BAR - This must be the first visible item at the top of each of your pages
	
	* INDIANA UNIVERSITY FOOTER - This must be the last visible item at the bottom of each of your pages (with the exception of background colors or images)

All other code in the index.html file is suggested, but not required by Indiana University's brand guidelines.


3. CSS options
----------------------------------------------------------------------------

You may need to adjust the width of the branding bar and footer to match or accommodate the width of your website design. The width is set to 960 pixels by default. To adjust the width:

	* Open the following CSS files:
		* /css/base.css
		* /css/fixed.css

	* Under the "Resuable Classes" comment, locate the ".wrapper" class. Change the max-width and/or width attribute to the size of your website design.

Additionally, you may want to adjust the margin of the footer so that it displays flush with the bottom of your website content. By default the footer has a 40 pixel top margin. To adjust the margin:

	* Open the following CSS file:
		* /css/wide.css

	* Under the "Footer" comment, locate the "#footer" id. Change the margin-top value to -40px. You may want to add 60 pixels of padding to the bottom of the container directly above the footer so that the content of the footer does not display over the content of the container above.


4. Responsive options
----------------------------------------------------------------------------

By default the branding bar and footer are responsive and will adapt to the orientation and screen size of the device viewing it. If your website is not responsive or if you would like to turn this feature off, you should make the following updates to the index.html file:

	* Locate and remove the following two elements from the INDIANA UNIVERSITY BRANDING BAR AND FOOTER <HEAD> ELEMENTS section:

		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<!--[if (lte IE 8) & (!IEMobile)]>
        	<link href="_iu-brand/css/fixed.css" media="screen" rel="stylesheet" type="text/css" />
        <![endif]-->

	* Locate the following tag, and replace it with the tag shown below.

		<link href="_iu-brand/css/wide.css" media="(min-width: 48.000em)" rel="stylesheet" type="text/css" /> (<- REPLACE THIS)

		<link href="_iu-brand/css/fixed.css" rel="stylesheet" type="text/css" /> (<- WITH THIS)


5. Search options
----------------------------------------------------------------------------

By default the branding bar includes a Google Custom Search form. Use of the search form is OPTIONAL. 

-> To customize the search:

	* Open the following HTML files:
		* index.html
		* search.html

	* Locate the tag with ID "cse-search-option1" (index.html) and "cse-search-results-option1" (search.html) within the OPTIONAL GOOGLE CUSTOM SEARCH code block. Update the value attribute with the URL to your website (do not include http:// or https:// or end with a forward slash). Ex: www.iu.edu/~iubrand or brand.iu.edu.

	* Please note, the scripts included in the INDIANA UNVERSITY BRANDING BAR AND FOOTER <HEAD> ELEMENTS code block assist with the functionality of the search form. The scripts must be passed the following three variables:

		* searchResultsURL: 'search.html'
			* This is the path to the search results page, relative to the current page. If you move the search results page, this path must be updated to reflect the new location path.

		* searchId: 'cse-search-form'
			* This is the ID of the Google Custom Search form.

		* searchResultsId: 'cse-search-results-form'
			* This is the ID of the Google Custom Search results form.


-> To remove the search:

	* Locate and remove the OPTIONAL GOOGLE CUSTOM SEARCH code block within the INDIANA UNIVERSITY BRANDING BAR code block.

	* Locate and remove the script tags within the INDIANA UNIVERSITY BRANDING BAR AND FOOTER <HEAD> ELEMENTS code block.

	* Delete the search.html page.