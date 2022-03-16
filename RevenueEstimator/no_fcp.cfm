<cfoutput>
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
				<th>Campus Projected Hours #application.firstyear#</th>
				<th>#application.firstyear# Constant Effective Rate</th>
				<th>Estimated Revenue #application.firstyear#<br><span class="sm-blue">(#application.firstyear# CrHrs * Const Eff #application.firstyear# Rate)</span></th>
				<th>Campus Projected Hours #application.secondyear#</th>
				<th>Estimated Revenue #application.secondyear#<br><span class="sm-blue">(#application.secondyear# CrHrs * Const Eff #application.secondyear# Rate)</span></th>
			</tr>
		</thead>
		<tbody>
		<cfif noFCPSelect.recordcount eq 0>
			<tr><td rowspan="11">No data found.</td></tr>	
		<cfelse>
			<cfloop query="noFCPSelect">
				<cfif SELGROUP eq "NO FCP" and HOURS neq 0>
				<tr>
					<td>
						<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
						<input hidden="hidden" value="#oid#" name="OID">
						<input hidden="hidden" value="#FEECODE#" name="FEECODE">
						<div class="tooltip">
							#FEECODE#<span class="tooltiptext">#FEEDESCR#</span>
						</div> 
						<br>
						<span class="sm-blue">#CHART#</span>
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
				<input name="projHrs_Yr1" id="projHrsYr1#CurrentRow#" size="10" value="#projhours_yr1#" onblur="calcEstRev(this.value, #feeAmount#,'#currentTarget#')" disabled />
				<input name="projHrs_Yr1" type="hidden" value="#projhours_yr1#" />
			</cfif>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>
					<td id="otherFeeRevYr1#CurrentRow#" name="estRevYr1">#DollarFormat(EstRev_YR1)#</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR2#</span>
										<br>
						<cfset currentTarget = 'otherFeeRevYr2' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr2" id="projHrsYR2#CurrentRow#" size="10" value="#PROJHOURS_YR2#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
							<span class="sm-red">#note#</span>
					</td>
					<td id="otherFeeRevYr2#CurrentRow#" name="estRevYr2">#DollarFormat(EstRev_YR2)#</td>
				</tr>
				</cfif>
			</cfloop>
		</cfif>
		</tbody>
	</table>
</cfoutput>