	<cfinclude template="../includes/header_footer/header.cfm">
    <cfinclude template="../includes/functions/UATax_functions.cfm">
	<cfset currentUser = getUATaxUser(REQUEST.authUser) />
	
	<cfif StructKeyExists(form,"taxaction")>
		<cfswitch expression="#form.taxaction#" >
			<cfcase value="NewRequest">
				<cfset sortedRCs = StructSort(application.RCnames, "textnocase", "asc") />
				<cfset currentAccounts = getAccountNumbers(currentUser.PROJECTOR_RC) />
		        <cfinclude template="UATax_create.cfm" runonce="true">
			</cfcase>

			<cfcase value="CurrentRequest" >
				<cfset UATax_data = getUATax_data(currentUser.PROJECTOR_RC,"pending") />
		        <cfinclude template="UATax_pending.cfm" runonce="true">
			</cfcase>

			<cfcase value="AllocationByUnit" >
		        <cflocation url="UATax_alloc.cfm" addtoken="false">
			</cfcase>

			<cfcase value="Allocation77" >
				<cflocation url="UATax_alloc_RC77.cfm" addtoken="false">
			</cfcase>

			<cfcase value="orgDetail" >
		        <cflocation url="UATax_detail.cfm" addtoken="false">
			</cfcase>

			<cfcase value="B7940Detail" >
		        <cflocation url="UATax_history.cfm" addtoken="false">
			</cfcase>

			<cfcase value="assessSum" >
		        <cflocation url="UATax_summary.cfm" addtoken="false">
			</cfcase>

			<cfcase value="getAdjBase" >
				<cflocation url="UATax_adjBase.cfm" addtoken="false">
			</cfcase>

			<cfcase value="getGuidelines" >
				<cflocation url="index.cfm" addtoken="false">
			</cfcase>

			<cfcase value="supportScenarios" >
		        <cflocation url="UATax_scenarios.cfm" addtoken="false">
			</cfcase>

			<cfcase value="OrgRank">
				<cfset orgRanks = getOrgRankings() />
				<cfset distinctOrgs = getDistinctOrgs() />
				<cfset distinctAccts = getDistinctAccts() />
				OrgRank
				<cfinclude template="UATax_org_ranks.cfm" runonce="true">
			</cfcase>

			<cfcase value="AccountRank">
		    	<cfset currentAccounts = getAccountNumbers(currentUser.PROJECTOR_RC) />
				Account ranking here
				<cfdump var="#currentAccounts#">
			</cfcase>

			<cfcase value="otherBase" >
				otherBase - intended for reference data such as the calculated benefits rates data, etc.
			</cfcase>

			<cfcase value="approvalList" >
				<cfset UATax_data = getUATax_data(currentUser.PROJECTOR_RC,true) />
				approvalList
				<cfinclude template="UATax_approvals.cfm" runonce="true">
			</cfcase>

			<cfcase value="updateVars" >
				<cfset UATax_data = getUATax_data(currentUser.PROJECTOR_RC,true) />
				updateVars
				<cfinclude template="updateUATaxVars.cfm" runonce="true">
			</cfcase>

			<cfdefaultcase>Sorry but you have selected an item we do not recognize.  Let us know, we can fix it.</cfdefaultcase>
		</cfswitch>
	
	<cfelse>
		<cflocation url="index.cfm?message=Reloaded page." >
	</cfif>
		
<!---	SAVING THIS CONTROL BAR IN CASE I NEED IT 
		<h3>Controls</h3>
		<form name="uaTaxForm" action="submitUATaxRequest.cfm" method="post" enctype="multipart/form-data">
			<div class="controlBar">
				<div class="controlBinTL">
					<input id="dwnldBtn" type="submit" name="dwnldBtn" class="formBtn" value="Export All To Excel">
				</div>
				<!-- End controlBinTL -->
									
				<div class="controlBinTLC">
					<input id="reportBtn" type="submit" name="reportBtn" class="formBtn" value="Generate UA Tax Report">
				</div>
				<!-- End div controlBinTLC -->
				
				<!---<div class="controlBinTC">
					<input id="submitBtn" type="submit" name="submitBtn" class="formBtn" value="Submit Your Request">
				</div>--->
				<!-- End div controlBinTC -->
				
				<cfif ListFindNoCase(Approver_list, REQUEST.authUser)>
					<div class="controlBinTC">
						<input id="apprBtn" type="submit" name="apprBtn" class="formBtn" value="Approve/Deny Requests">
					</div>
				</cfif>
				<!-- End div controlBinTRC -->
			</div>
			<!-- End of div controlBar -->
			
			<hr width="90%">
--->