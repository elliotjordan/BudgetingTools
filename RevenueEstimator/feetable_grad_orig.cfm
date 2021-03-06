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
							<cfif application.budget_year eq "YR1">
								<th>#application.prioryear# Actual<br><span class="sm-black">as of<br>Census</span></th>
							</cfif>
								<th>#application.firstyear# Enrollment Study Projection Hours<br><span class="sm-blue">(machine hrs)</span></th>
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
								<!--- Blank spacer --->
								<th></th>
								<cfif application.budget_year eq "YR2">
									<th>#application.firstyear# Actual<br><span class="sm-black">as of<br>Census</span></th>
								</cfif>
								<th>#application.secondyear# Enrollment Study Projection Hours<br><span class="sm-blue">(machine hrs)</th>
								<th>#application.secondyear# Campus Projected Hours</th>
								<cfif application.rateStatus eq "Vc">
									<th>#application.secondyear# Effective Rate (Vc)</th>
									<th>#application.secondyear# Estimated Revenue<span class="sm-blue">(Cr Hrs * Const Eff Rate)</span></th>
								<cfelseif application.rateStatus eq "V1">
									<th>#application.secondyear# Escalated Rate (V1)</th>
									<th>#application.secondyear# Estimated Revenue<span class="sm-blue">(Cr Hrs * Escalated Rate)</span></th>
								<cfelse>
									<th>#application.secondyear# Rate</th>
									<th>#application.secondyear# Estimated Revenue</th>								
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
<cfif LEN(gl_sub_acct_cd) gt 0>	<span class="sm-red">#gl_sub_acct_cd#</span><br></cfif>
										<span class="sm-blue">
											#ACCOUNT_NM#
										</span>
									</td>
							<!--- BEGIN YEAR ONE COLUMNS --->
								<cfif application.budget_year eq "YR1">
									<td>Cr Hrs: #HOURS#<br>
										<span class="sm-blue">
											Heads: #HEADCOUNT#</span>
									</td> 
								</cfif>
									<td>
										#MACHHRS_YR1#
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
											<cfif IsNumeric(b1_ADJ_ESCL_RATE_YR1)>
												<cfset feeAmount = b1_ADJ_ESCL_RATE_YR1 />
											</cfif>
										</cfif>
			<cfif application.budget_year eq "YR1"> 
				<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" />
			<cfelse>
				<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" disabled />
				<input name="projHrs_Yr1" type="hidden" value="#projhours_yr1#" />
			</cfif>
									</td>
								<cfif application.rateStatus eq "Vc">	
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(b1_ADJ_RATE)#
									</td>
								<cfelseif application.rateStatus eq "V1">
									<td name="feeLY" id="feeLY#CurrentRow#">
										#DollarFormat(b1_ADJ_ESCL_RATE_YR1)#
									</td>
								</cfif>
									<td id="gradFeeRevYr1#CurrentRow#" name="gradEstRev_Yr1">#DollarFormat(EstRev_YR1)#</td>
									<!--- Blank spacer --->
									<td></td>
							<!--- BEGIN YEAR TWO COLUMNS --->
								<cfif application.budget_year eq "YR2">
									<td>Cr Hrs: #HOURS#<br>
										<span class="sm-blue">
											Heads: #HEADCOUNT#</span>
									</td> 
								</cfif>
									<td>
										#MACHHRS_YR2#
									</td>
									<td>
										<span class="sm-blue">Starting value: #b1_projhrs_yr2#</span>
										<br>
										<cfset currentTarget = 'gradFeeRevYr2' & CurrentRow />
										<cfset feeAmount = 0 />  <!--- We do this so we can catch bad data - set to 0, then check for numeric --->
										<cfif application.rateStatus eq "Vc">
											<cfif IsNumeric(ADJ_RATE)>
												<cfset feeAmount = b2_ADJ_RATE />
											</cfif>
										<cfelseif application.rateStatus eq "V1">
											<cfif IsNumeric(b1_ADJ_ESCL_RATE_YR2)>
												<cfset feeAmount = b2_ADJ_ESCL_RATE_YR2 />
											</cfif>
										</cfif>
										<input name="projHrs_Yr2" id="projHrsYr2#CurrentRow#" size="10" value="#projhours_yr2#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')">
										<span class="sm-red">#note#</span>
									</td>
									<cfif application.rateStatus eq "Vc">	
										<td name="feeHY" id="feeHY#CurrentRow#">
											#DollarFormat(b2_ADJ_RATE)#
										</td>
									<cfelseif application.rateStatus eq "V1">
										<td name="feeHY" id="feeHY#CurrentRow#">
											#DollarFormat(b2_ADJ_ESCL_RATE_YR2)#
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
</cfoutput>