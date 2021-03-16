<cfoutput>
	<cfset disableButtonField = true>
	<!--- TODO set lockedStatusList as a UBO control and make it dynamic --->
	<cfset lockedStatusList = "Submitted,Submitted Change,Submitted New,CampusOK,RegionalOK,BursarOK,CFO Approved">
	<!---<cfdump var="#lockedStatusList#" ><br><cfdump var="#disableButtonField#" >--->
	<cfif !ListFindNoCase(lockedStatusList,ALLFEE_INFO.FEE_STATUS) OR FindNoCase(MID(session.access_level,3,2),"us")>
		<cfset disableButtonField = false>
	</cfif>
	<!---<cfdump var="#ALLFEE_INFO.FEE_STATUS# - #disableButtonField# - #session.access_level#">--->
	<!-- Begin Fee Request form -->
	 	<form action = "fee_rate_update.cfm" id = "AllFeesForm" method = "POST">
			<fieldset>
				<p>You may make a request for fiscal year 2022 or 2023 or both</p>
<!---<cfdump var="#ALLFEE_INFO.FEE_BEGIN_TERM# - #application.current_term# - #newFeeInd#">--->
				<p>	<!--- TODO: make this dynamic from the database itself  --->
					<cfif FindNoCase(REQUEST.adminUsernames, REQUEST.authUser)>
						<label for="campus_select">Campuses (CRTL-Click to select multiple)</label><br>
						<select id="campus_select" name="INST_CD" class="request" multiple="multiple">
							<option value="false">-- Please select one or more campuses --</option>
							<option value="IUBLA" <cfif "IUBLA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUBLA - Bloomington</option>
							<option value="IUCOA" <cfif "IUCOA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUCOA - Columbus</option>
							<option value="IUEAA" <cfif "IUEAA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUEAA - Richmond</option>
							<option value="IUINA" <cfif "IUINA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUINA - IUPUI</option>
							<option value="IUKOA" <cfif "IUKOA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUKOA - Kokomo</option>
							<option value="IUFWA" <cfif "IUFTW" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUFWA - Fort Wayne</option>
							<option value="IUNWA" <cfif "IUNWA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUNWA - Gary</option>
							<option value="IUSBA" <cfif "IUSBA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUSBA - South Bend</option>
							<option value="IUSEA" <cfif "IUSEA" eq #ALLFEE_INFO.INST_CD# >selected</cfif> >IUSEA - New Albany</option>
						</select>
					<cfelse>
						<h3>#session.curr_proj_chart#</h3>
					</cfif>
				</p>
				<p>
					<label for="owner_select">Fee Owner</label><br>
					<select id="owner_select" name="FEE_OWNER" class="target" >
						<option value="false">-- Please select a fee owner --</option>
						<cfloop query="#DISTINCT_OWNERS#">
							<option value="#fee_owner#" <cfif #fee_owner# eq ALLFEE_INFO.FEE_OWNER>selected</cfif> >#FEE_OWNER# #application.rcNames[FEE_OWNER]#</option>
						</cfloop>
					</select>
					<input id="owner_selectDELTA" type="hidden" value="false">
				</p>
				<p>
					<h3>#ALLFEE_INFO.FEE_TYP_DESC#</h3>
				</p>

<cfif newFeeInd>
				<p>
					<label for="term_select">First Term To Be Charged</label><br>
					<select id="term_select" name="FEE_BEGIN_TERM" class="request">
						<option value="false">-- Term when fee begins --</option>
						<option value="4188">-- Existing fee --</option>
						<cfloop query="DISTINCT_BEGIN_TERMS">
							<option value="#FEE_BEGIN_TERM#" <cfif (#FEE_BEGIN_TERM# eq ALLFEE_INFO.FEE_BEGIN_TERM)>selected</cfif> >#FEE_BEGIN_DESC#</option>
						</cfloop>
					</select>
				</p>
</cfif>
				<p>
					<label for="billing_descr_field">Official Fee Description</b> (Bursar billing version)</label><br>
					<input id="billing_descr_field" name="FEE_DESC_BILLING" class="target" type="text" size="35" maxlength="30" placeholder="(up to 30 characters)" value="#ALLFEE_INFO.FEE_DESC_BILLING#"></input>
					<input id="billing_descr_fieldDELTA" type="hidden" value="false">
				</p>

				<p>
					<label for="long_descr_field">Reporting Fee Description (longer version used in reports)</label><br>
					<input type="text" id="long_descr_field" name="FEE_DESC_LONG" size="55" maxlength="50" placeholder="(up to 50 characters)" value="#ALLFEE_INFO.FEE_DESC_LONG#"></input>
				</p>

				<p>
					<label for="web_descr_field">Fee Explanation (web version for public websites)</label><br>
					<textarea id="web_descr_field" name="FEE_DESC_WEB" cols="128" rows="2" maxlength="256" placeholder="use this data to explain what the fee is for to students">#ALLFEE_INFO.FEE_DESC_WEB#</textarea>
				</p>

				<p>
					Is this a "Dynamic" fee? <br />
					<input type="checkbox" id="dynOrg_checkbox" name="DYN_ORG_IND" onchange="dynOrgToggle()" value="1" <cfif #ALLFEE_INFO.DYN_ORG_IND# eq '1'>checked="checked"</cfif>>
					<span id="dynOrg_state_label">No</span>
					<label for="dynOrg_checkbox"> - Check this only if this is a dynamic fee.  When revenue feeds dynamically to your accounts, the system will override the account used on the item type and use the "dynamic" account associated with the academic org tied to the course.  Tuition is commonly fed dynamically and in some cases so are course related fees. If you still are not sure, please call the Bursar. They will be happy to help you. If your fee is <i>not</i> "dynamic", just uncheck the checkbox. Thanks!</label>
				</p>

				<div id="acct_org_inputs">
					<p>
						<label for="account_select" id="account_select_label">Revenue Account Number</label><br>
						<select id="account_select" name="ACCOUNT_NBR" class="request" onchange="newAccountEntry()">
							<option value="false">-- Please select an account --</option>
							<option id="new_acct" value="create">-- Enter a new account --</option>
							<cfif DISTINCT_ACCOUNTS.recordcount eq 1>
								<cfset setAccount = true>
							<cfelse>
								<cfset setAccount = false>
							</cfif>
							<cfif SESSION.curr_proj_rc eq '42'>  <!--- TODO: develop a preferences field for this --->
								<option value="1042677" <cfif ('1042677' eq ALLFEE_INFO.ACCOUNT_NBR) OR setAccount>selected</cfif>>1042677</option>
							</cfif>
							<cfloop query="DISTINCT_ACCOUNTS">
								<option value="#ACCOUNT_NBR#" <cfif (#ACCOUNT_NBR# eq ALLFEE_INFO.ACCOUNT_NBR) OR setAccount>selected</cfif> >#ACCOUNT_NBR#</option>
							</cfloop>
						</select>
						<label for="new_acct_input" id="undo_new_acct" hidden="hidden" onclick="undoNewAccountNumber()">Undo New Account Number</label>
						<input id="new_acct_input" name="new_acct_input" size="24" type="text" hidden="hidden" placeholder="Enter new account number" maxlength="7"  onblur="newAccountEntry()" />
					</p>

					<p>
						<label for="sub_account_select" id="sub_account_select_label">Sub-account Number</label><br>
						<select id="sub_account_select" name="SUB_ACCOUNT_NBR" class="request" <cfif DISTINCT_SUB_ACCOUNTS.recordcount lt 1>disabled</cfif>  >
							<option value="None">None</option>
							<cfloop query="DISTINCT_SUB_ACCOUNTS">
								<option value="#sub_account_nbr#" <cfif #sub_account_nbr# eq ALLFEE_INFO.SUB_ACCOUNT_NBR>selected</cfif> >#SUB_ACCOUNT_NBR#</option>
							</cfloop>
						</select>
					</p>
				</div>

				<p>
					<label for="objcd_select">Object Code</label><br>
					<select id="objcd_select" name="OBJ_CD" class="request">
						<option value="false">-- Please select an object code --</option>
						<cfloop query="DISTINCT_OBJCDS">
							<option value="#obj_cd#" <cfif #obj_cd# eq ALLFEE_INFO.OBJ_CD>selected</cfif> >#obj_cd#</option>
						</cfloop>
					</select>
				</p>

				<p>
					<label for="wo_account_select">Bad Debt Account Number</label><br>
					<select id="wo_account_select" name="WO_ACCOUNT_NBR" class="request" <cfif DISTINCT_WO_ACCOUNTS.recordcount lt 1>disabled</cfif> >
						<cfif DISTINCT_WO_ACCOUNTS.recordcount lt 1>
							<option value="false">-- No known write-off accounts --</option>
						<cfelse>
							<option value="false">-- Please select a write-off account --</option>
						</cfif>

						<cfloop query="DISTINCT_WO_ACCOUNTS">
							<option value="#wo_account_nbr#" <cfif #wo_account_nbr# eq ALLFEE_INFO.WO_ACCOUNT_NBR>selected</cfif> >#WO_ACCOUNT_NBR#</option>
						</cfloop>
					</select>
				</p>

				<p>
					<label for="assess_select">Assessment Method</label><br>
					<select id="assess_select" name="UNIT_BASIS" class="request">
						<option value="false">-- Please select the assessment method --</option>
						<cfloop query="DISTINCT_UNIT_BASIS">
							<option value="#UNIT_BASIS#" <cfif #UNIT_BASIS# eq ALLFEE_INFO.UNIT_BASIS>selected</cfif> >#UNIT_BASIS#</option>
						</cfloop>
					</select>
				</p>

				<h3>FY2021 Active Fee Amount: $ #ALLFEE_INFO.fee_current#</h3>
				<p>
					<label for="YR1_amount_field">FY2022 Fee Amount Requested</label><br>
					<input type="hidden" id="current_amt" value="#ALLFEE_INFO.fee_current#">
					<cfif ALLFEE_INFO.fee_current neq ''>
						<cfset glCalc = #NumberFormat(LSParseNumber(ALLFEE_INFO.fee_current) * 1.02, "_$,9.99")# >
					<cfelse>
						<cfset glCalc = 0>
					</cfif>
					<input id="YR1_amount_field" name="fee_lowyear" class="right-justify" type="text" size="25" maxlength="10" placeholder="(In dollars/cents, i.e, 550.00)" value="#ALLFEE_INFO.fee_lowyear#" onkeyup="calcRequestPctIncrease(#ALLFEE_INFO.fee_current#,this)"></input>
					<cfif LSParseNumber(#ALLFEE_INFO.fee_current#) eq 0>
					<span id="fee_amt_pct_field_text1" class="lg-green"> New fee</span>
					<cfelse>
						<span id="fee_amt_pct_field_text1"  class="lg-green"> 0 % - #glCalc# is the guideline maximum</span>
					</cfif>
				</p>
<cfif newFeeInd>
				<p>
					<label for="YR1_count_est_field">Estimated FY2022 Headcount/Credit Hours Assessed</label><br>
					<input id="YR1_count_est_field" name="YR1_EST_VOL" class="right-justify" type="text" size="25" maxlength="10" value="#ALLFEE_INFO.YR1_EST_VOL#" onkeyup="calcNewRequestRevenue()"></input> - Calculated Estimated Revenue: <span id="count_est_field_text1">$ 99999.99 per term</span>
				</p>
</cfif>
				<p>
					<label for="YR2_amount_field">FY2023 Fee Amount Requested</label><br>
					<cfset glCalc2 = #NumberFormat(LSParseNumber("1.00") * 1.02, "_$,9.99")# >
					<input id="YR2_amount_field" name="fee_highyear" class="right-justify" type="text" size="25" maxlength="10" placeholder="(In dollars/cents, i.e, 550.00)" value="#ALLFEE_INFO.fee_highyear#" onkeyup="calcYR2RequestPctIncrease(this)" disabled="disabled"></input>
					<span id="fee_amt_pct_field_text2"  class="lg-green"> 0 % </span>
				</p>

<cfif newFeeInd>
				<p>
					<label for="YR2_count_est_field">Estimated FY2023 Headcount/Credit Hours Assessed</label><br>
					<input id="YR2_count_est_field" name="YR2_EST_VOL" class="right-justify" type="text" size="25" maxlength="10" value="#ALLFEE_INFO.YR2_EST_VOL#" onkeyup="calcNewRequestRevenue()"></input> - Calculated Estimated Revenue: <span id="count_est_field_text2">$ 99999.99 per term</span>
				</p>
</cfif>

<cfif newFeeInd>
				<h3>Itemization of Costs</h3>
				<cfset Spacer = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;">
				<cfset bigSpacer = Spacer & Spacer & Spacer & Spacer & Spacer & Spacer & Spacer & Spacer>
				<label for="FY20_label">#Spacer# Description#bigSpacer#Amount</label><br>
				<label ID="FY20_label" for="itemized_desc_field1">FY22</label>
				<input id="itemized_desc_field1" name="COST_DESC_ITEM1" type="text" size="55" maxlength="50" value="#ALLFEE_INFO.COST_DESC_ITEM1#"></input>
				<input id="itemized_amount_field1" name="COST_AMT_ITEM1" type="text" size="25" maxlength="10" placeholder="(In dollars/cents, i.e, 1,015.89)" value="#ALLFEE_INFO.COST_AMT_ITEM1#"></input>

				<br><br>
				<label for="itemized_desc_field2">FY23</label>
				<input id="itemized_desc_field2" name="COST_DESC_ITEM2" type="text" size="55" maxlength="50" value="#ALLFEE_INFO.COST_DESC_ITEM2#">
				<input id="itemized_amount_field2" name="COST_AMT_ITEM2" type="text" size="25" maxlength="10" placeholder="(In dollars/cents, i.e, 1,015.89)" value="#ALLFEE_INFO.COST_AMT_ITEM2#"></input>
</cfif>

<cfif newFeeInd>
				<p>
					<label for="replacement_checkbox" id="replacement_checkbox_label">Is this a replacement fee?</label>
					<cfif #ALLFEE_INFO.REPLACEMENT_IND# eq 'on'><cfset blork = 'checked="checked"'><cfelse><cfset blork = ''></cfif>
					<input type="checkbox" id="replacement_checkbox" name="REPLACEMENT_IND" onclick="replacementFeeToggle()" #blork#></input>
					<span id="replCkbox_state_label">Yes</span>
				</p>

				<div id="fee_select_inputs">  		<!-- initially hidden by CSS, shown when checkbox is clicked - see screen2.css -->
					<p>
						<label for="repl_fee_select" id="fee_select_label">Currently Active Fees:</label><br>
						<select id="repl_fee_select" name="REPLACEMENT_FEE" class="request">
						<cfif ALLFEE_LIST.recordcount lt 1>
							<option value="false">-- You have no other fees --</option>
						<cfelse>
							<option value="false">-- Please select which fee to replace --</option>
						</cfif>
						<cfloop query="ALLFEE_LIST">
							<cfif ALLFEE_INFO.ALLFEE_ID neq ALLFEE_LIST.ALLFEE_ID>
								<option value="#ALLFEE_LIST.ALLFEE_ID#">#ALLFEE_LIST.ALLFEE_ID# - #FEE_DESC_LONG#</option>
							</cfif>
						</cfloop>
						</select>
					</p>
				</div>	<!-- End of div for fee select inputs -->
</cfif>
					<p>
						<label for="why_now_text">Why do we need this change?</label>
						<input type="textarea" id="why_now_text" name="NEED_FOR_FEE" size="132" maxlength="128" placeholder="(Brief explanation about your request)" value="#ALLFEE_INFO.NEED_FOR_FEE#"></input>
					</p>

				<p>
					<label for="justification_txtbox">Further justification</label><br>
					<textarea id="justification_txtbox" name="FURTHER_JUSTIFY"  cols="124" rows="8" maxlength="1024">#ALLFEE_INFO.FURTHER_JUSTIFY#</textarea>
				</p>
				<p>
					<label for="notes_txtbox">Notes</label><br>
					<textarea id="notes_txtbox" name="FEE_NOTE" cols="124" rows="8" maxlength="256">#ALLFEE_INFO.FEE_NOTE#</textarea>
				</p>

			<div id="button_field" <cfif disableButtonField>hidden='hidden'</cfif> >
				<input type="hidden" id="ALLFEE_ID_VALUE" name="ALLFEE_ID" value="#ALLFEE_INFO.ALLFEE_ID#"></input>
				<input type="hidden" id="FISCAL_YEAR" name="FISCAL_YEAR" value="#ALLFEE_INFO.FISCAL_YEAR#"></input>
			<cfif StructKeyExists(url,"PRESERVE_STATUS") AND url.PRESERVE_STATUS eq "true">
				<input type="hidden" id="PRESERVE_STATUS" name="PRESERVE_STATUS" value="true"></input>
			</cfif>
				<input id="save_btn" type="submit" name="save_btn" value="Save"></input>
				<cfif newFeeInd>
					<input type="button" id="check_all_btn" name="check_all_btn" value="Check Everything" onclick="checkEachFieldForSelections()">
					<input id="new_submit_btn" type="submit" name="new_submit_btn" value="Submit #ALLFEE_INFO.ALLFEE_ID#"  onclick="checkEachFieldForSelections()" disabled feeid="#ALLFEE_INFO.ALLFEE_ID#"></input>
					<label id="new_submit_label" for="new_submit_btn" class="sm-blue">Once all fields are filled in, click Check Everything to enable Submit</label>
				<cfelse>
					<input id="edit_submit_btn" type="submit" name="edit_submit_btn" value="Submit"></input>
				</cfif>
			</div>
			<div id="status_explanation" <cfif !disableButtonField>hidden='hidden'</cfif>>
				<h4>You have submitted #ALLFEE_INFO.ALLFEE_ID# "#ALLFEE_INFO.FEE_DESC_BILLING#" and cannot edit further unless it is returned to you for further work.</h4>
			</div>
			</fieldset>
	 	</form>
</cfoutput>