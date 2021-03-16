<cfinclude template="../includes/header_footer/allfees_header.cfm" />

<div class="full_content">	
	<h2>All Fees Project Parking Lot</h2>
	<p><a href="index.cfm">Back to All Fees page.</a></p>
	<h3>Features</h3>
		<table class="statusTable">
			<tr> <th>Phase I Working Now</th> <th>Phase I Coming Soon</th> <th>Phase II / Needed</th> <th>Phase II / Nice To Have</th> <th>Phase III / In Our Dreams</th></tr>
			<tr> <td>Duo Login</td> <td>Editable Fields / Live Updating</td> <td>New Fee Request Form</td> <td>User Ordered Excel Columns</td> <td>User-defined notifications</td> </tr>
			<tr> <td>Show All Active Fees</td> <td>Save Your Settings</td> <td>Click'n'drag Class Associations</td> <td>User Can Include or Hide Columns</td> <td>User-designed templates</td> </tr>
			<tr> <td>Sort Each Column</td> <td>Excel "Slurp" (Upload)</td> <td>Class/Course List Comparison</td> <td>Custom Reports</td> <td></td> </tr>
			<tr> <td>Excel Download</td> <td>Metadata records of all changes</td> <td>Approval Routing</td> <td>Integrate site with Box for File Versions</td> <td></td> </tr>
			<tr> <td>Show Course Associations table</td> <td>Integration of Tuition Portal with All Fees Master list</td> <td>User-settable Preferences</td> <td>Revenue Impact Estimator</td> <td></td> </tr>
			<tr> <td>Show All Fees Table</td> <td>Save Your Work</td> <td></td> <td></td> <td></td> </tr>
			<tr> <td>Copy, Print, Show/Hide Columns Control</td> <td>User Chooses To Show Active vs. Inactive Fees</td> <td></td> <td></td> <td></td> </tr>
			<tr> <td></td> <td>Table Pre-sorts Campus According to Your User ID</td> <td></td> <td></td> <td></td> </tr>
			<!---<tr> <td></td> <td></td> <td></td> <td></td> <td></td> </tr>--->
		</table>
		
	<h5>Thoughts About Working on All Fees</h5>
	<ul>
		<li>You will have the option to work in Excel as you always have, then upload your changes, or simply make changes directly here.  Bear in mind that the list will be constantly changing, so remember that any local copies of Excel will rapidly be out of date.</li>
		<li>The key to automating fee maintenance will be to ALWAYS MAKE SURE that you have ONE ACTIVE row per unique ALLFEE_ID.</li>
		<li>On that unique, active ALLFEE_ID row, the goal is for the machine to notice you have made a change, and to put that change in the database.</li>
		<li>If you think about that for a moment, you will realize that you do not need to do anything more than change the values in your Excel.  The machine will do the rest.</li>
		<li>That said, if you want to use highlighter to help yourself, or add some columns, that's OK - just remember that the machine will ignore all that.</li>
		<li>Every change will be logged to a metadata table in case there is any question who made a change.  We will record the old value and the new value, username, and timestamp.</li>
	</ul>
	
	<h5>Testers</h5>
	<p>Missty Warren, mibhicks@indiana.edu - Kelley School</p>
</div>  <!-- End div class full_content -->
<cfinclude template="../includes/header_footer/allfees_footer.cfm" />