<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfoutput>
<div class="full_content">
	
<h2>Uploads for FY#application.shortfiscalyear#</h2>
		<p>Your private #current_inst# campus upload folder is
		<cfswitch expression="#currentUser.focus#">
			<cfcase value="BL">
				<a target="_blank" alt="Link to BL uploads folder" 
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/BL_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=t29mNw">here</a>
			</cfcase>

    		<cfcase value="BA-ATHL">
				<a target="_blank" alt="Link to BL Athletics uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/BL_Submission_BudgetOffice/BA-Athletics-RC%208C_Submission/5-Year%20Projections/2021-22?csf=1&web=1&e=txIHAR">here</a>
    		</cfcase>

    		<cfcase value="EA">
				<a target="_blank" alt="Link to EA uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/EA_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=mUkzrN">here</a>
    		</cfcase>

    		<cfcase value="IN">
				<a target="_blank" alt="Link to IN uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/IN_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=Ge25z7">here</a>
    		</cfcase>

    		<cfcase value="MED">
				<a target="_blank" alt="Link to School of Medicine uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/IN_Submission_BudgetOffice/IN-MED-RC%2010_Submission/5-Year%20Projections/2021-22?csf=1&web=1&e=00KbDS">here</a>
    		</cfcase>

    		<cfcase value="KO">
				<a target="_blank" alt="Link to KO uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/KO_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=8m2dhr">here</a>
    		</cfcase>

    		<cfcase value="NW">
				<a target="_blank" alt="Link to NW uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/NW_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=uHfWrz">here</a>
    		</cfcase>

    		<cfcase value="SB">
				<a target="_blank" alt="Link to SB uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/SB_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=zRcJOR">here</a>
    		</cfcase>

    		<cfcase value="SE">
				<a target="_blank" alt="Link to SE uploads folder" 
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/SE_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=tbBgR8">here</a>
    		</cfcase>

    		<cfcase value="UA">
				<a target="_blank" alt="Link to UA uploads folder" 
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/UA_Submission_BudgetOffice/5-Year%20Projections/2021-22?csf=1&web=1&e=vd87YA">here</a>
    		</cfcase>
    		
    		<cfdefaultcase>
    			not found. Please contact us and we will have a look.
    		</cfdefaultcase>

		</cfswitch>


		</p>
</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />