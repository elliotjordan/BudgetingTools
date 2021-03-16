<cfinclude template="../includes/functions/fee_rate_functions.cfm" runonce="true" />

<form id="bursarUpdateForm" method="post" action="fee_controls.cfm">
	<p>This control will refresh the table which drives BUDU001.BURSAR_ALLFEES_VW with all active fees. That view supplies the official published list of active fees to the Student Central searchable fee list.
	<input name="bursarUpdateBtn" type="submit" value="UPDATE">
</form>
