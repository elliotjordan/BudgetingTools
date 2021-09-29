<cfinclude template="../includes/header_footer/UATax_header.cfm">
<cfinclude template="../includes/functions/UATax_functions.cfm">
<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
<h2>Detail Page</h2>
<p>This page could contain details or possibly the Step 2 content with specific line items included in the totals shown on the Allocated Summary table.</p>
</cfif>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">