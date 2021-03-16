<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">

<cfset UATax_history = getB7940() />

	<div class="full_content">
		<h2>Assessment Methods and Line Details</h2>
		<p>This page is intended to display line items from the UATax history (B7940sum_2020V2.xlsx) for the campus user to browse and search.</p>	
			<cfinclude template="UATax_assessments.cfm">
<!---		<h2>UA Support History</h2>
			<cfinclude template="UATax_historyDisplay.cfm">--->
	</div>  <!-- End div class "full_content" -->

<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
