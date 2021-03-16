<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfif IsDefined("url") and StructKeyExists(url,"assmtID")>
	<cfset ass_details = getCampusAssmtDetails(url.assmtID) />
</cfif>
<cfoutput>
<div class="full_content">
<!--- Base Items --->
<--<a href="UATax_campus_assessments.cfm">Back to Assessments List</a><br>
	<span class="sm-blue">#ass_details.assmt_id# - #ass_details.detail_id#</span>
	<h2>#ass_details.assessment_detail#</h2>
	<h3>Allocations for FY#ass_details.fyear#</h3>
			<table>
			<cfloop query="#ass_details#">
				<tr><td>IUBLA</td><td>$#NumberFormat(iubla,'999,999,999')#</td></tr>
				<tr><td>IUEAA</td><td>$#NumberFormat(iueaa,'999,999,999')#</td></tr>
				<tr><td>IUINA</td><td>$#NumberFormat(iuina,'999,999,999')#</td></tr>
				<tr><td>IUSM</td><td>$#NumberFormat(iusom,'999,999,999')#</td></tr>
				<tr><td>IUKOA</td><td>$#NumberFormat(iukoa,'999,999,999')#</td></tr>
				<tr><td>IUNWA</td><td>$#NumberFormat(iunwa,'999,999,999')#</td></tr>
				<tr><td>IUSBA</td><td>$#NumberFormat(iusba,'999,999,999')#</td></tr>
				<tr><td>IUSEA</td><td>$#NumberFormat(iusea,'999,999,999')#</td></tr>
				<cfif LEN(detail_note) gt 1>
					<tr><td>Notes - </td><td>$#detail_note#</td></tr>
				</cfif>
			</cfloop>
		</table>
</div>  <!-- End div class="full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm">