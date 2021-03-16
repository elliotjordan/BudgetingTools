<cfoutput>
	<cfset showForm = true>
    <cfinclude template="prod_banner.cfm">
	    <hr width="100%">
   	<h2>Tuition Request Form for Fiscal Years #application.firstyear# and #application.secondyear#</h2>
	<!---<cfinclude template="fee_owner_select.cfm" />--->
   	<cfif IsDefined("form") and StructKeyExists(form,"SubmitTuitionDown")>
	    <cfinclude template="../includes/forms/exportTuition.cfm">
   	</cfif>
   	<cfif IsDefined("form") AND StructKeyExists(form,"SubmitUp") AND structKeyExists(form, "xlsfile") and len(form.xlsfile)>
		<cfinclude template="uploadAllFees.cfm">
   	</cfif>
<!---
	<h3>Request a Brand New Fee</h3>
	<cfform action = "fee_change_request.cfm" id = "newTuitionReq" format = "html" method = "POST" preloader = "no" preserveData = "yes" 
 		timeout = "1200" width = "800" wMode = "opaque">
		<p>
			<select id="type_select" name="SubmitNewTuition" class="request" onchange="newFeeButton()">
				<option value="false">-- Please select a fee type --</option>
		<!---				<option value="1_ADM">Administrative Fee</option>
				<option value="2_CMP">Campus Fee</option>
				<option value="4_CRS">Course Fee</option>
   				<option value="5__DE">Distance Ed Fee</option>  --->
				<option value="6_TUI">Instructional</option>
				<option value="7_MAN">Mandatory Program Fee</option>
				<option value="8_OTH">Other Fee</option>
			</select>
		</p>
		<input id="SubmitBtn1" type="submit" name="SubmitNewTuitionBtn" value="Request New Fee" disabled="disabled"  />			
	</cfform>
--->
	<cfinclude template="tuition_request_panel.cfm">	    

 	<form action = "tuition_update.cfm" id = "FeeRequestForm" method = "POST" width = "800">
		<input id = "SubmitBtn" type="submit" name="Submit" value="Save Your Work" form="FeeRequestForm" disabled />
		<label for="SubmitBtn">Submit your changes.</label><br>

		<input type="checkbox" id="ViewControl">
		<label for="ViewControl">Only show or download the ones we can change</label>
		<table id="tuitionTable" class="feeCodeTable">
			<thead>
				<tr>
					<th>Fee Category</th>
					<th>Campus</th>
					<th>Fee Description</th>
					<th>Fee Owner</th>
					<th>Current rate</th>
					<th>#application.firstyear# Rate</th>
					<th>#application.secondyear# Rate</th>
				</tr>
			</thead>
			<tbody>
			<cfset currentRow = 0 />
			<cfloop query="#tuitionData#">
				<cfif tuitionData.fee_current gt 0 AND tuitionData.fee_lowyear gt 0>   
					<!--- Calculate the percentage if there is some value for the fee --->
					<cfset low_perc = (#tuitionData.fee_lowyear# / (#tuitionData.fee_current#) - 1) * 100 />
					<cfset high_perc = (#tuitionData.fee_highyear# / (#tuitionData.fee_lowyear#) - 1)* 100 />
				<cfelse>
					<cfset low_perc = 0>
					<cfset high_perc = 0>
				</cfif>
				<tr <cfif #tuitionData.fee_setByCampusIndicator# neq 'Y'>class="non_edit_row"</cfif> >
					<td>#tuitionData.categ#</td>
					<td>#tuitionData.fee_inst#</td>
						<cfset thisRow = correctSymbols(#tuitionData.fee_descr#) />
					<td>
						<input type="hidden" name="ALLFEE_ID" value="#allfee_id#" >
						<p class="sm-blue">#tuitionData.allfee_id# (old ID #tuitionData.fee_id#)</p>
						#thisRow#
						<p class="sm-blue">#tuitionData.fee_type# 
						<cfif LEN(cohort) gt 1> - #cohort# cohort</cfif>
						</p>
						</td>
					<td>#fee_owner#</td>
					<td id="currRate#currentRow#" name="currRate#currentRow#_#allfee_id#">#DollarFormat(tuitionData.fee_current)#</td>
					<td>
					<cfif #tuitionData.fee_setByCampusIndicator# eq 'Y'> 
						<input id="#allfee_id#_incPercentLow" name="incPctLow#currentRow#_#allfee_id#" size="7" maxlength="7" required="false" value="#NumberFormat(low_perc,'.0000')#" type="text" onkeyup="updateByPercent(this.id,'Low',#currentRow#,'#allfee_id#')">%</input> ($<input id="#allfee_id#_low" name="#allfee_id#_FEE_LOWYEAR" size="10" type="text" maxlength="10" required="true"	value="#NumberFormat(tuitionData.fee_lowyear,',.00')#" onkeyup="updateByDollars(this.id,'Low',#currentRow#,'#allfee_id#')"></input>)
<!---						<p class="badResult" id="lowBadResult#currentRow#"></p>
						<p class="goodResult" id="lowGoodResult#currentRow#"></p>--->
						<br>#fee_type#
					<cfelse>
						<p class="sm-blue">This rate is set by another campus.</p>
						#NumberFormat(tuitionData.fee_lowyear,',.00')#
					</cfif></td>
					<td>
					<cfif #tuitionData.fee_setByCampusIndicator# eq 'Y'>
						<input id="#allfee_id#_incPercentHigh" name="incPctHigh#currentRow#_#allfee_id#" size="7" maxlength="7" required="false" value="#NumberFormat(high_perc,'.000')#" type="text" disabled="disabled" onkeyup="updateByPercent(this.id,'High',#currentRow#,'#allfee_id#')">%</input> ($<input size="10" name="#allfee_id#_FEE_HIGHYEAR" id="#allfee_id#_high" type="text"  maxlength="10" required="true" 
value="#NumberFormat(tuitionData.fee_highyear,',.00')#" disabled="disabled" onkeyup="updateByDollars(this.id,'High',#currentRow#,'#allfee_id#')">)
<!---						<div class="badResult" id="highBadResult#currentRow#"></div>
						<div class="goodResult" id="highGoodResult#currentRow#"></div>--->
							<br>#fee_type#
					<cfelse>
						#NumberFormat(tuitionData.fee_highyear,',.00')#								
					</cfif></td>
				</tr>
				<cfset currentRow = currentRow + 1 />
		    </cfloop> 
		    </tbody>
		</table>
		<!--- Add a submit button --->
		<input id="SubmitBtn2" type="submit" name="Submit" value="Save Your Work" disabled />
		<label for="SubmitBtn2">Submit your changes.</label>
	</form>
</div>  <!---  End of DIV class="form-inline"  --->
</cfoutput>