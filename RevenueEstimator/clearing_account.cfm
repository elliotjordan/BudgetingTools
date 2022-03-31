<div id="clrFeesDiv" />
<h5>Clearing Account Page</h5>
<!---<cfdump var="#clearingSummarySelect#" ><cfabort>--->
<!--- Four major states determine which rates to use  --->
<cfif application.budget_year eq "YR1">
	<cfif application.rateStatus eq "Vc">
		<cfset Yr1RateCol = "b1_adj_rate">			<!--- starting out, all we know is data from yr1  --->
		<cfset Yr2RateCol = "b1_adj_rate">			<!--- no idea what yr2 will be, so we roll yr1 rate forward --->
	<cfelseif application.rateStatus eq "V1">		
		<cfset Yr1RateCol = "b1_adj_escl_rate_yr1">	<!--- at this point we know the escalation, so we use it now --->
		<cfset Yr2RateCol = "b1_adj_escl_rate_yr2">	<!--- yr2 escalation may or may not match yr 1, so we have separate column  --->
	</cfif>
<cfelseif application.budget_year eq "YR2">
	<cfif  application.rateStatus eq "Vc">
		<cfset Yr1RateCol = "b1_adj_esc_rate">		<!--- we roll forward the ending value from yr1 --->
		<cfset Yr2RateCol = "b2_adj_rate">			<!--- however, we have better data for yr2 now so we use it --->
	<cfelseif application.rateStatus eq "V1">
		<cfset Yr1RateCol = "b1_adj_esc_rate">		<!--- yr1 is over, nothing changes --->
		<cfset Yr2RateCol = "b1_adj_escl_rate_yr2">	<!--- finally we know the yr2 escalation, so we use it now --->
	</cfif>
</cfif>

<cfoutput>
	<!--- CLEARING SUMMARY TABLE --->
	<table id="clearingSummaryTable" class="feeCodeTable">
		<thead>
			<tr>
				<th>Fee Code</th>
				<th>Fee Description</th>
				<th>Term</th>
				<th>Residency</th>
				<th>Object Code</th>
				<th>Account</th>
			<cfif application.budget_year eq "YR1">
				<th>#application.prioryear# Actual<br><span class="sm-black">as of<br>Census</span></th>
			</cfif>
				<th>#application.firstyear# Enrollment Study Projection Hours<br><span class="sm-blue">(machine hrs)</th>
				<th>#application.firstyear# Campus Projected Hours</th>
			<cfif application.rateStatus eq "Vc">
				<th>#application.firstyear# Effective Rate (Vc)</th>
				<th>#application.firstyear# Estimated Revenue<span class="sm-blue">(Cr Hrs * Const Eff Rate)</span></th>
			<cfelseif application.rateStatus eq "V1">
				<th>#application.firstyear# Escalated Rate (V1)</th>
				<th>#application.firstyear# Estimated Revenue<span class="sm-blue">(YR1 Cr Hrs * Escalated Rate)</span></th>
			</cfif>		
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
				<th>#application.secondyear# Estimated Revenue<span class="sm-blue">(YR2 Cr Hrs * Escalated Rate)</span></th>
			</cfif>				
			</tr>
		</thead>
		<tbody>
			<cfloop query="clearingSummarySelect">
				<cfif SELGROUP neq "NO FCP">
				<tr>
					<td>
						<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
						<input hidden="hidden" value="#oid#" name="OID">
						<input hidden="hidden" value="#FEECODE#" name="FEECODE">
						#FEECODE#
					</td>
					<td>#FEEDESCR#</td>
					<td><input hidden="hidden" value="#SESN#" name="SESN">
						<input hidden="hidden" value="#TERM#" name="TERM" />#TRMLABEL#
						<br><span class="sm-blue">#TERM#</span>
					</td>
					<td><input hidden="hidden" value="#RES#" name="RES" />
						#RES#
						<input hidden="hidden" value="#SELGROUP#" name="SELGROUP" />	
					</td>
					<td>#OBJCD#
						<br>
						<span class="sm-blue">#FIN_OBJ_CD_NM#</span>
					</td>
					<td>
						<input hidden="hidden" value="#ACCOUNT#" name="ACCOUNT">
						#ACCOUNT#
						<br><span class="sm-blue">#ACCOUNT_NM#</span>
					</td>
				<cfif application.budget_year eq "YR1">
					<td>Cr Hrs:	#NumberFormat(HOURS,'999,999.9')#
						<br><span class="sm-blue">Heads: #HEADCOUNT#</span>
					</td>
				</cfif>
					<td>#NumberFormat(MACHHRS_YR1,'999,999.9')#</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR1#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr1' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(0)><cfset feeAmount = 0 /></cfif>  <!--- UNLINKED/NO FCP IS ALWAYS 0 by DEFINITION --->
			<cfif application.budget_year eq "YR1"> 
				<input name="projHrs_Yr1OID#OID#" id="projHrs_Yr1OID#OID#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" />
				<input name="projHrs_Yr1OID#OID#DELTA" type="hidden" value="false" />
			<cfelse>
				<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" disabled />
			</cfif>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(B1_ADJ_ESCL_RATE_YR1)#</td>
					<!---<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(b1_adj_rate)#</td>--->
					<td id="otherFeeRevYr1#CurrentRow#" name="estRevYr1">#DollarFormat(EstRev_YR1)#</td>
				<cfif application.budget_year eq "YR2">
					<td>Cr Hrs:	#NumberFormat(HOURS,'999,999.9')#
						<br><span class="sm-blue">Heads: #HEADCOUNT#</span>
					</td>
				</cfif>
					<td>#NumberFormat(MACHHRS_YR2,'999,999.9')#</td>
					<td><span class="sm-blue">Starting value: #b2_projhrs_yr2#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr2' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(0)><cfset feeAmount = 0 /></cfif>
						<input name="projHrs_Yr2OID#OID#" id="projHrs_YR2OID#OID#" size="10" value="#PROJHOURS_YR2#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
						<input name="projHrs_Yr2OID#OID#DELTA" type="hidden" value="false" />
					</td>
					<!---<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(b1_adj_rate)#</td>--->
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(B2_ADJ_ESCL_RATE_YR2)#</td>
					<td id="otherFeeRevYr2#CurrentRow#" name="estRevYr2">#DollarFormat(EstRev_YR2)#</td>
				</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>

	<h5>No FCP Hours (formerly "Unlinked")</h5>
	<p>These are the unlinked credit hours to match the Official Census count. "NO FCP" rows occur when we have fee-paying credit hours of enrollment from Official Census, but we do not find a matching course in FCP to retrieve financial data. We provide those rows here so that the credit hours can be properly tied back from the Projector to the Official Census.</p>	
	<!--- UNLINKED/NO FCP TABLE --->
		<table id="csTable2" class="feeCodeTable">
		<thead>
			<tr>
				<th>Fee Code</th>
				<th>Fee Description</th>
				<th>Term</th>
				<th>Academic Career</th>
				<th>Residency</th>
				<th>Actual<br><span class="sm-black">as of<br>Census</span></th>
				<th>Campus Projected Hours YR1</th>
				<th>FY19 Constant Effective Rate</th>
				<th>Estimated Revenue YR1<br><span class="sm-blue">(YR1 CrHrs * Const Eff YR1 Rate)</span></th>
				<th>Campus Projected Hours YR2</th>
				<th>Estimated Revenue YR2<br><span class="sm-blue">(YR2 CrHrs * Const Eff YR2 Rate)</span></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="noFCPSelect">
				<cfif SELGROUP eq "NO FCP">
				<tr>
					<td>
						<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
						<input hidden="hidden" value="#oid#" name="OID">
						<input hidden="hidden" value="#FEECODE#" name="FEECODE">
						#FEECODE#
					</td>
					<td>#FEEDESCR#</td>
					<td><input hidden="hidden" value="#SESN#" name="SESN">
						<input hidden="hidden" value="#TERM#" name="TERM" />#TRMLABEL#
						<br><span class="sm-blue">#TERM#</span>
					</td>
					<td>#ACAD_CAREER#</td>
					<td><input hidden="hidden" value="#RES#" name="RES" />
						#RES#
						<input hidden="hidden" value="#SELGROUP#" name="SELGROUP" />	
					</td>
					<td>Cr Hrs:	#NumberFormat(HOURS,'999,999.9')#
						<br><span class="sm-blue">Heads: #HEADCOUNT#</span>
					</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR1#</span>
						<br>
						<cfset currentTarget = 'otherFeeRevYr1' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
			<cfif application.budget_year eq "YR1"> 
				<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" />
			<cfelse>
				<input name="projHrs_Yr1OID#OID#" id="projHrsYr1OID#OID#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" disabled />
				<input name="projHrs_Yr1OID#OID#DELTA" type="hidden" value="false" />
			</cfif>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>
					<td id="otherFeeRevYr1#CurrentRow#" name="estRevYr1">#DollarFormat(EstRev_YR1)#</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR2#</span>
										<br>
						<cfset currentTarget = 'otherFeeRevYr2' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr2OID#OID#" id="projHrsYR2OID#OID#" size="10" value="#PROJHOURS_YR2#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
						<input name="projHrs_Yr2OID#OID#DELTA" type="hidden" value="false" />
							<span class="sm-red">#note#</span>
					</td>
					<td id="otherFeeRevYr2#CurrentRow#" name="estRevYr2">#DollarFormat(EstRev_YR2)#</td>
				</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>
</div>  <!-- end div clrFees  -->
</cfoutput>