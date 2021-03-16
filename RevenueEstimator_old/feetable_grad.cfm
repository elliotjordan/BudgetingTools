<!--- this page is a "partial" to be included on revenue_RC.cfm  --->
<cfoutput>
					<table id="gradFeesTable" class="feeCodeTable">
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
								<!--- Begin YR1 headers  --->
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
								<cfif application.budget_year eq "YR1">
									<th>#application.firstyear# Actual<br><span class="sm-black">as of<br>Census</span></th>
								<cfelse>
									<th>#application.secondyear# Actual<br><span class="sm-black">as of<br>Census</span></th>
								</cfif>
								<th>#application.secondyear# Enrollment Study Hours</th>
								<cfif application.budget_year eq "YR1">
									<th>#application.secondyear# Campus Projected Hours</th>
								<cfelse>	
									<th>#application.secondyear# Campus Projected Hours<br>(adjusted)</th>									
								</cfif>	
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
							<cfset rowcounter = 1 />
							<cfloop query="DataSelect">
								<cfif ListFindNoCase(ptg,SELGROUP) and !(urlCampus eq "IN" AND urlRC eq "80" AND (MID(FEECODE,1,3) eq "OCC" OR MID(FEECODE,1,3) eq "BAN"))>
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
										<cfif ACAD_CAREER eq "LAW">
											<br><span class="sm-blue">#FEEDESCR#</span>
										</cfif>
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
									<td>&nbsp;</td>
							<!--- BEGIN YEAR ONE COLUMNS --->
									<td>
										#MACHINEHOURS_YR1#
									</td>
									<td>
										<span class="sm-blue">
											Starting value: #PROJHOURS_YR1#
										</span>
										<br>
										<cfset currentTarget = 'gradFeeRevYr1' & CurrentRow />
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
										<!--- TODO: toggle the editability of this field for YR2 --->
										<!---<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')">--->
										<div name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')">#projhours_yr1#</div>
									</td>
								<cfif application.rateStatus eq "Vc">	
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(ADJ_RATE)#
									</td>
								<cfelseif application.rateStatus eq "V1">
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(ADJ_ESCL_RATE_YR1)#
									</td>
								</cfif>
									<td id="gradFeeRevYr1#CurrentRow#" name="gradEstRev_Yr1">#DollarFormat(EstRev_YR1)#</td>
									<td></td>
							<!--- BEGIN YEAR TWO COLUMNS --->
									<td>Cr Hrs: #HOURS#<br>
										<span class="sm-blue">
											Heads: #HEADCOUNT#</span>
									</td> 
									<td class="darker">
										#MACHINEHOURS_YR2#
									</td>
									<td>
										<cfif application.budget_year eq "YR1">
											<span class="sm-blue">Starting value: 0</span>
										<cfelse>
											<span class="sm-blue">Starting value: #projhours_yr2#</span>
										</cfif>
										<br>
										<cfset currentTarget = 'gradFeeRevYr2' & CurrentRow />
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
									<td id="gradFeeRevYr2#CurrentRow#" name="gradEstRev_Yr2">#DollarFormat(EstRev_YR2)#</td>
								</tr>
								</cfif>
								<cfset rowcounter++ />
							</cfloop>
						</tbody>
					</table>
					<cfif isDefined("Url") AND StructKeyExists(Url, "Campus") AND StructKeyExists(Url, "RC")>
						<input hidden="hidden" value="#Url.Campus#" name="CAMPUS" />
						<input hidden="hidden" value="#Url.RC#" name="RC" />
					</cfif>
					<span class="SubTotal" id="gradSubTotalYr1">
						SUB-TOTAL YR1 (only what is showing): 
						#DollarFormat(0000.00)#
					</span><br>
					<span class="SubTotal" id="gradSubTotalYr2">
						SUB-TOTAL YR2 (only what is showing): 
						#DollarFormat(0000.00)#
					</span>
</cfoutput>