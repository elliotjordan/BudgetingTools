<cfoutput>
					<div class="workSaver">
						<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" />
					</div>
					<table id="ugrdFeesTable" class="feeCodeTable">
						<thead>
							<tr>
								<th>Fee Code
 									<div class="tooltip"><span class="tooltiptext">Bursar Fee Code</span></div> 
								</th>
								<th>Term<br>(Actuals)</th>
								<th>Tuition Group</th>
								<th>Academic Career</th>
								<th>Residency</th>
								<th>Object Code</th>
								<th>Account</th>
								<th></th>
								<th>#application.firstyear# Enrollment Study Hours</th>
								<th>#application.firstyear# Campus Projected Hours</th>
								<cfif application.rateStatus eq "Vc">
									<th>#application.firstyear# Effective Rate (Vc)</th>
									<th>#application.firstyear# Estimated Revenue<span class="sm-blue">(Cr Hrs * Const Eff Rate)</span></th>
								<cfelseif application.rateStatus eq "V1">
									<th>#application.firstyear# Escalated Rate (V1)</th>
									<th>#application.firstyear# Estimated Revenue<span class="sm-blue">(Cr Hrs * Escalated Rate)</span></th>
								<cfelse>
									<th>#application.firstyear# Rate</th>
									<th>#application.firstyear# Estimated Revenue</th>								
								</cfif>
								<th></th>
								<th>FY21 Enrollment Study Hours</th>
								<th>FY21 Campus Projected Hours</th>
								<cfif application.rateStatus eq "Vc">
									<th>FY21 Effective Rate (Vc)</th>
									<th>FY21 Estimated Revenue<span class="sm-blue">(Cr Hrs * Const Eff Rate)</span></th>
								<cfelseif application.rateStatus eq "V1">
									<th>FY21 Escalated Rate (V1)</th>
									<th>FY21 Estimated Revenue<span class="sm-blue">(Cr Hrs * Escalated Rate)</span></th>
								<cfelse>
									<th>FY21 Rate</th>
									<th>FY21 Estimated Revenue</th>								
								</cfif>
							</tr>
						</thead>
						<tbody>
							<cfloop query="DataSelect">
								<cfif ACAD_CAREER eq "UGRD" and !(urlCampus eq "IN" AND urlRC eq "80" AND (MID(FEECODE,1,3) eq "OCC" OR MID(FEECODE,1,3) eq "BAN") )>
								<tr>
									<td>
										<cfif ListFindNoCase(REQUEST.adminUsernames,trim(REQUEST.AuthUser))><span class="sm-blue">#FEE_ID#</span></cfif>
										<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
										<input hidden="hidden" value="#OID#" name="OID">
										<input hidden="hidden" value="#FEECODE#" name="FEECODE">
										<br>
										<div class="tooltip">#FEECODE#
											<span class="tooltiptext">#FEEDESCR#</span>
										</div> 
										<br>
										<span class="sm-blue">
											#CHART#
										</span>
										<input name="INST" hidden="hidden" value="#INST#">
									</td>
									<td>
										<input hidden="hidden" value="#TERM#" name="TERM">
										<input hidden="hidden" value="#SESN#" name="SESN">
										#SESN#
										<br>
										<span class="sm-blue">
											#TERM#
										</span>
									</td>
									<td>
										<input hidden="hidden" value="#SELGROUP#" name="SELGROUP">
										#SELGROUP#
									</td>
									<td>
										#ACAD_CAREER#
									</td>
									<td>
										<input hidden="hidden" value="#RES#" name="RES">
										#RES#
									</td>
									<td>
										#OBJCD#
										<br>
										<span class="sm-blue">
											#FIN_OBJ_CD_NM#
										</span>
									</td>
									<td>
										<input hidden="hidden" value="#ACCOUNT#" name="ACCOUNT">
										#ACCOUNT#
										<br>
										<span class="sm-blue">
											#ACCOUNT_NM#
										</span>
									</td>
									<td></td>
								<!--- BEGIN YEAR_ONE COLUMNS --->
									<td>
										#MACHINEHOURS_YR1#
									</td>
									<td>
										<span class="sm-blue">
											Starting value: #PROJHOURS_YR1#
										</span>
										<br>
										<cfset currentTarget = 'ugrdFeeRevYr1' & #CurrentRow# />
										<cfset feeAmount = 0 />  <!--- We do this so we can catch bad data - set to 0, then check for numeric --->
									<cfif application.rateStatus eq "Vc">
										<cfif IsNumeric(ADJ_RATE)>
											<cfset feeAmount = ADJ_RATE />
										</cfif>
									<cfelseif application.rateStatus eq "V1">
										<cfif IsNumeric(ADJ_ESCL_RATE_YR1)>
											<cfset feeAmount = ADJ_ESCL_RATE_YR1 />
										</cfif>
									</cfif>
										<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')">
									</td>
								<cfif application.rateStatus eq "Vc">
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(ADJ_RATE)#
										<cfif (#FEECODE# eq 'ACPNR$' OR #FEECODE# eq 'ACPR$')><br>
											<span class="sm-blue">Already budgeted in Inc Inc</span>
										</cfif>
									</td>
								<cfelseif application.rateStatus eq "V1">
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(ADJ_ESCL_RATE_YR1)#
										<cfif (#FEECODE# eq 'ACPNR$' OR #FEECODE# eq 'ACPR$')><br>
											<span class="sm-blue">Already budgeted in Inc Inc</span>
										</cfif>
									</td>
								</cfif>
									<td id="ugrdFeeRevYr1#CurrentRow#" name="ugrdEstRev_Yr1">#DollarFormat(EstRev_YR1)#</td>
							<!--- BEGIN YEAR TWO COLUMNS --->
									<td>&nbsp;</td> <!-- solid spacer bar for visual separation of fiscal years -->
									<td class="darker">
										#MACHINEHOURS_YR2#
									</td>
									<td>
										<span class="sm-blue">Starting value:0</span>
										<br>
										<cfset currentTarget = 'ugrdFeeRevYr2' & #CurrentRow# />
										<cfset feeAmount = 0 />  <!--- We do this so we can catch bad data - set to 0, then check for numeric --->
									<cfif application.rateStatus eq "Vc">
										<cfif IsNumeric(ADJ_RATE)>
											<cfset feeAmount = ADJ_RATE />
										</cfif>
									<cfelseif application.rateStatus eq "V1">
										<cfif IsNumeric(ADJ_ESCL_RATE_YR2)>
											<cfset feeAmount = ADJ_ESCL_RATE_YR2 />
										</cfif>
									</cfif>
										<input name="projHrs_Yr2" id="projHrsYr2#CurrentRow#" value="#projhours_yr2#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')">
									</td>
								<cfif application.rateStatus eq "Vc">
									<td name="feeHY" id="feeHY#CurrentRow#">
										#DollarFormat(ADJ_RATE)#
									</td>
								<cfelseif application.rateStatus eq "V1">
									<td name="feeHY" id="feeHY#CurrentRow#">
										#DollarFormat(ADJ_ESCL_RATE_YR2)#
									</td>
								</cfif>
									<td id="ugrdFeeRevYr2#CurrentRow#" name="ugrdEstRev_Yr2">#DollarFormat(EstRev_YR2)#</td>
								</tr>
								</cfif>
							</cfloop>
						</tbody>
					</table>
					<cfif isDefined("Url") AND StructKeyExists(Url, "Campus") AND StructKeyExists(Url, "RC")>
						<input hidden="hidden" value="#Url.Campus#" name="CAMPUS" />
						<input hidden="hidden" value="#Url.RC#" name="RC" />
					</cfif>
					<span class="SubTotal" id="ugrdSubTotalYr1">
						SUB-TOTAL YR1 (only what is showing): 
						#DollarFormat(0000.00)#
					</span><br>
					<span class="SubTotal" id="ugrdSubTotalYr2">
						SUB-TOTAL YR2 (only what is showing): 
						#DollarFormat(0000.00)#
					</span>
</cfoutput>