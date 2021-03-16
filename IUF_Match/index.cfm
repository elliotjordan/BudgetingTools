<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/IUF_functions.cfm">

<cfset currentUser = getIUF_user(REQUEST.AuthUser) />
<cfset Approver_list ="gwpalmer,nschrode,jburgoon,alirober,bjmoelle,nichodan,sbadams,jsej" />

<cfoutput>
	<div class="full_content">
		<h2>IUF Matching Funds</h2>

		<h3>Controls</h3>
		<form name="IUF_Form" action="" method="post" enctype="multipart/form-data">
			<div class="controlBar">
				<div class="controlBinTL">
					<input id="dwnldBtn" type="submit" name="dwnldBtn" class="formBtn" value="Export All To Excel">
				</div>
				<!-- End controlBinTL -->
									
				<div class="controlBinTLC">
					<input id="reportBtn" type="submit" name="reportBtn" class="formBtn" value="Generate IUF Matching Report">
				</div>
				<!-- End div controlBinTLC -->
				
				<div class="controlBinTC">
					<input id="submitBtn" type="submit" name="submitBtn" class="formBtn" value="Add a New KEM ID">
				</div>
				<!-- End div controlBinTC -->
				
<!---				<cfif ListFindNoCase(Approver_list, REQUEST.authUser)>
					<div class="controlBinTC">
						<input id="apprBtn" type="submit" name="apprBtn" class="formBtn" value="Approve/Deny Requests">
					</div>
				</cfif>--->
				<!-- End div controlBinTRC -->
			</div>
			<!-- End of div controlBar -->
			
			<hr width="90%">
			
		<cfinclude template="IUFmatch_tables.cfm">
			
		</form>
	</div>  <!-- End class full_content   -->
</cfoutput>
<cfinclude template="../includes/header_footer/IUF_footer.cfm">