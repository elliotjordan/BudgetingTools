<cfinclude template="../includes/header_footer/header.cfm">
<cfinclude template="../includes/functions/bi_revenue_functions.cfm">
<cfset authUser = getUser(REQUEST.authuser)>
<cfparam name="urlCampus" type="string" default="">
<cfset urlCampus = authUser['chart'][1]>  
<!--- not really the "url" campus now, is it?  Turned out to be handy for debugging to do it this way--->
<cfset thisInst = "IU" & #authUser['chart'][1]# & "A" />
<cfset urlRC = authUser['projector_RC'][1]>

<cfoutput>
<cfif IsDefined("form") and StructKeyExists(form,"subAcctSubmit")>
		<cfset row = 1>
		<cfloop list="#form.oid#" index="i">
			<cfset thisSA = getSubAccountByOID(i) />
		<cfif ListGetAt(form.FC,row) neq thisSA.sf_trm_fee_cd or
		      ListGetAt(form.TUIGRP,row) neq thisSA.sf_tuit_grp_ind or
		      ListGetAt(form.ACCT_NBR,row) neq thisSA.gl_acct_nbr or
		      ListGetAt(form.SUB_ACCT,row) neq thisSA.gl_sub_acct_cd>
		<cfset thisRow = updateSubAccts(i,ListGetAt(form.INST_CD,row),ListGetAt(form.TUIGRP,row),ListGetAt(form.FC,row),ListGetAt(form.ACCT_NBR,row),ListGetAt(form.SUB_ACCT,row)) />
		<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#urlCampus#,8,"#REQUEST.AuthUser# at #urlCampus# RC #urlRC# updated sub-accounts table with FC #form.FC#, SELGROUP #form.TUIGRP#, account #form.ACCT_NBR#, sub-account #form.SUB_ACCT#") />
		</cfif>
		<cfset row++ />		
	</cfloop>
<cfelseif IsDefined("form") and StructKeyExists(form,"NEWSUBACCTBTN")>
	<cfset addSubAccts(form.NEW_CAMPUS,form.NEW_TERM,form.NEW_FC,form.NEW_TUIGRP,form.NEW_ACCT,form.NEW_SUBACCT) />
	<cfset actionEntry = trackProjectinatorAction(#REQUEST.AuthUser#,#urlCampus#,8,"#REQUEST.AuthUser# at #urlCampus# RC #urlRC# created a new sub-account with FC #form.NEW_FC#, SELGROUP #form.NEW_TUIGRP#, account #form.NEW_ACCT#, sub-account #form.NEW_SUBACCT#") />	
</cfif>

	<!--- Top of page  --->
	
<cfset subAcctData = getSubAccountsByCampus(urlCampus) />

	<span>
		<a href="revenue_RC.cfm">RC Page</a><span> -- </span>
		<a href="revenue_Campus.cfm">Campus Page</a><span> -- </span>
		<a href="revenue_University.cfm">University Page</a>	
	</span>
	<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser)>
		<p>You are currently a user associated with the #urlCampus# campus.</p>
	</cfif>

	<form action="campus_controls.cfm" method="post" name="subAcctForm">
		<input id="subAcctSubmit"  name="subAcctSubmit" type="submit" value="Update Sub-accounts">
		<table id="subAcctTable" name="subAcctTable" class="feeCodeTable">
		  <thead>
		    <tr>
		      <th>Row ID</th>
		      <th>bursar_bsns_unit_cd</th>
		      <th>sf_trm_cd</th>
		      <th>sf_trm_fee_cd</th>
		      <th>sf_tuit_grp_ind</th>
		      <th>gl_acct_nbr</th>
		      <th>gl_sub_acct_cd</th>
		    </tr>
		  </thead>
		  <tbody>
		  	<cfif subAcctData.recordcount gt 0>
		  	<cfloop query="#subAcctData#">
		    <tr>
		      <td>#oid#
		        <input id="term_cd" name="oid" type="hidden" value="#oid#" />
		      </td>
		      <td>#bursar_bsns_unit_cd#
		        <input id="inst_cd" name="inst_cd" type="hidden" value="#bursar_bsns_unit_cd#" />
		      </td>
		      <td>#sf_trm_cd#</td>
		      <td><input id="FC" name="FC" value="#sf_trm_fee_cd#" /></td>
		      <td><input id="tuiGrp" name="tuiGrp" value="#sf_tuit_grp_ind#" /></td>
		      <td><input id="acct_nbr" name="acct_nbr" value="#gl_acct_nbr#" alt="account number input field" /></td>
		      <td><input id="sub_acct" name="sub_acct" value="#gl_sub_acct_cd#" alt="sub-account number input field" /></td>
		    </tr>
		    </cfloop>
		    <cfelse>
		    <tr>
		    	<td colspan = '7'>No sub-accounts were returned.</td>
		    </tr>
		    </cfif>
		  </tbody>
		</table> 
	</form>
	
	<hr>
	<h2>Add New Sub-account</h2>
		<form id="addSubAcctForm" name="subAcctCreate" action="campus_controls.cfm" method="POST"  > 
		    <table id="addSubAcctTable" class="" border="1">	
		    	<thead>
					<tr>
						<th>Campus</th>
						<th>Term</th>
						<th>Fee Code</th>
						<th>Tuition Group</th>
						<th>Account Number</th>
						<th>Sub-account number</th>
					</tr>
				</thead>
				<tbody>
				<!--- Create the input fields --->
    			<tr>
	  				<td><input size="12" name="new_Campus" maxlength="5" value="#thisInst#" /></td>
	  				<td><input size="32" name="new_Term" maxlength="20" /></td>
	  				<td><input size="32" name="new_FC" maxlength="20" /></td>
	  				<td><input size="16" name="new_TuiGrp" maxlength="20" /></td>
	  				<td><input size="32" name="new_Acct" maxlength="20" /></td>
					<td><input size="6" name="new_SubAcct" maxlength="20" /></td>
    			</tr>
    			</tbody>
			</table>
			<p><input type="submit" name="newSubAcctBtn" value="Add New Sub-account"  /></p>
		</form>		
</cfoutput>
<cfinclude template="../includes/header_footer/footer.cfm">