<cfinclude template="../includes/header_footer/fym_header.cfm" runonce="true" />
<cfoutput>
<div class="full_content">
<h2>Uploads for FY#application.shortfiscalyear#</h2>
<p>We have two folders in the UBO Teams space where you may upload files:</p>
	<p>The All Teams folder for general uploads is
			<a alt="Link to BUDU all campuses uploads folder" href='https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/All_Campuses_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=q3dNbS' target="_blank">here</a>
		</p>
		<p>Your private #currentUser.fym_inst# campus upload folder is
		<cfswitch expression="#currentUser.fym_inst#">
			<cfcase value="BL">
				<a target="_blank" alt="Link to BL uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/BL_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=dZOmZa">here</a>
			</cfcase>

    		<cfcase value="BL-ATHL">
				<a target="_blank" alt="Link to BL Athletics uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/BL_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=dZOmZa">here</a>
    		</cfcase>

    		<cfcase value="EA" delimiters=";">
				<a target="_blank" alt="Link to EA uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/EA_Submission_BudgetOffice/5-Year%20Projections/2020-21/">here</a>
    		</cfcase>

    		<cfcase value="IN">
				<a target="_blank" alt="Link to IN uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/IN_Submission_BudgetOffice/5-Year%20Projections?csf=1&web=1&e=mIbGOo">here</a>
    		</cfcase>

    		<cfcase value="MED">
				<a target="_blank" alt="Link to School of Medicine uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/IN_Submission_BudgetOffice/5-Year%20Projections?csf=1&web=1&e=mIbGOo">here</a>
    		</cfcase>

    		<cfcase value="KO">
				<a target="_blank" alt="Link to KO uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/KO_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=8ONafZ">here</a>
    		</cfcase>

    		<cfcase value="NW">
				<a target="_blank" alt="Link to NW uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/NW_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=E5yTT7">here</a>
    		</cfcase>

    		<cfcase value="SB">
				<a target="_blank" alt="Link to SB uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/SB_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=WB7YlI">here</a>
    		</cfcase>

    		<cfcase value="SE">
				<a target="_blank" href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/SE_Submission_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=5WANbI">here</a>
    		</cfcase>

    		<cfdefaultcase>
    			<a target="_blank" alt="default link to BUDU all campuses uploads folder"
href="https://indiana.sharepoint.com/:f:/r/sites/msteams_858801/Shared%20Documents/General/UA-BUDU-External/CampusSubmission_BUDU/All_Campuses_BudgetOffice/5-Year%20Projections/2020-21?csf=1&web=1&e=q3dNbS">here</a
    		</cfdefaultcase>

		</cfswitch>


		</p>
</div>  <!-- End div class full-content -->
</cfoutput>
<cfinclude template="../includes/header_footer/fym_footer.cfm" runonce="true" />