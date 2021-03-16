<h5>Clearing Account Page</h5>
<p>Clearing accounts normally contain all the Undergraduate Credit Hours lumped together to a single clearing account.<br>This year we are also showing the Online Course Connect hours as "OCCE$" for the enrollment hours (30% revenue) and OCCI$ for the instruction hours (70% revenue).  OCC hours are further broken out by tuition groups to help you see their source.</p>
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
				<th>Actual<br><span class="sm-black">as of<br>Census</span></th>
				<th>UBO Projected Hours YR1</th>
				<th>Campus Projected Hours YR1</th>
				<th>FY19 Constant Effective Rate</th>
				<th>Estimated Revenue YR1<span class="sm-blue">(YR1 CrHrs * Const Eff YR1 Rate)</span></th>
				<th>UBO Projected Hours YR2</th>
				<th>Campus Projected Hours YR2</th>
				<th>FY20 Constant Effective Rate</th>
				<th>Estimated Revenue YR2<span class="sm-blue">(YR2 CrHrs * Const Eff YR2 Rate)</span></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="clearingSummarySelect">
				<cfif SELGROUP neq "UNLINKED">
				<tr>
					<td>
						<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
						<input hidden="hidden" value="#oid#" name="OID">
						<input hidden="hidden" value="#FEECODE#" name="FEECODE">
						#FEECODE#
					</td>
					<td>#FEEDESCR#</td>
					<td><input hidden="hidden" value="#SESN#" name="SESN">
						<input hidden="hidden" value="#TERM#" name="TERM" />#TERM#
						<br><span class="sm-blue">#TRMLABEL#</span>
					</td>
					<td><input hidden="hidden" value="#RES#" name="RES" />
						#RESIDENCY#
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
					<td>Cr Hrs:	#NumberFormat(HOURS,'999,999.9')#
						<br><span class="sm-blue">Heads: #HEADCOUNT#</span>
					</td>
					<td>#NumberFormat(MACHINEHOURS_YR1,'999,999.9')#</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR1#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr1' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr1" id="projHrsYR1#CurrentRow#" value="#PROJHOURS_YR1#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>
					<td id="otherFeeRevYr1#CurrentRow#" name="estRevYr1">#DollarFormat(EstRev_YR1)#</td>
					<td>#NumberFormat(MACHINEHOURS_YR2,'999,999.9')#</td>
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR2#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr2' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr2" id="projHrsYR2#CurrentRow#" value="#PROJHOURS_YR2#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>
					<td id="otherFeeRevYr2#CurrentRow#" name="estRevYr2">#DollarFormat(EstRev_YR2)#</td>
				</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>
	
	<div class="controlBar">
	  <div class="controlBinTRC">
		<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled />
	  </div>
	</div>
					
	<h5>Unlinked Hours</h5>
	<p>These are the "Unlinked" credit hours to match Official Census count. "Unlinked" rows occur when we have fee-paying credit hours of enrollment from Official Census, but we do not find a matching fee amount for the course in FCP. We provide those rows here so that the credit hours can be properly tied back from the Projector to the Official Census.</p>
	<!--- UNLINKED TABLE --->
		<table id="csTable2" class="feeCodeTable">
		<thead>
			<tr>
				<th>Fee Code</th>
				<th>Fee Description</th>
				<th>Term</th>
				<th>Academic Career</th>
				<th>Residency</th>
				
				<!---<th>Tuition Group</th>--->
				<!---<th>Object Code</th>
				<th>Account</th>--->
				<th>Actual<br><span class="sm-black">as of<br>Census</span></th>
				<!---<th>UBO Projected Hours YR1</th>--->
				<th>Campus Projected Hours YR1</th>
				<th>FY19 Constant Effective Rate</th>
				<th>Estimated Revenue YR1<br><span class="sm-blue">(YR1 CrHrs * Const Eff YR1 Rate)</span></th>
				<!---<th>UBO Projected Hours YR2</th>--->
				<th>Campus Projected Hours YR2</th>
				<!---<th>FY20 Constant Effective Rate</th>--->
				<th>Estimated Revenue YR2<br><span class="sm-blue">(YR2 CrHrs * Const Eff YR2 Rate)</span></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="clearingSummarySelect">
				<cfif SELGROUP eq "UNLINKED">
				<tr>
					<td>
						<input hidden="hidden" value="#FEE_ID#" name="FEE_ID">
						<input hidden="hidden" value="#oid#" name="OID">
						<input hidden="hidden" value="#FEECODE#" name="FEECODE">
						#FEECODE#
					</td>
					<td>#FEEDESCR#</td>
					<td><input hidden="hidden" value="#SESN#" name="SESN">
						<input hidden="hidden" value="#TERM#" name="TERM" />#TERM#
						<br><span class="sm-blue">#TRMLABEL#</span>
					</td>
					<td>#ACAD_CAREER#</td>
					<td><input hidden="hidden" value="#RES#" name="RES" />
						#RESIDENCY#
						<input hidden="hidden" value="#SELGROUP#" name="SELGROUP" />	
					</td>
					
					<!---<td>
						<input hidden="hidden" value="#ACCOUNT#" name="ACCOUNT">
						#SELGROUP#
					</td>--->
					<td>Cr Hrs:	#NumberFormat(HOURS,'999,999.9')#
						<br><span class="sm-blue">Heads: #HEADCOUNT#</span>
					</td>
					<!---<td>#MACHINEHOURS_YR1#</td>--->
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR1#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr1' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr1" id="projHrsYR1#CurrentRow#" value="#PROJHOURS_YR1#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
					</td>
					<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>
					<td id="otherFeeRevYr1#CurrentRow#" name="estRevYr1">#DollarFormat(EstRev_YR1)#</td>
					<!---<td>#MACHINEHOURS_YR2#</td>--->
					<td><span class="sm-blue">Starting value: #PROJHOURS_YR2#</span>
						<!---<span class="sm-red">SAMPLE DATA</span>--->
										<br>
						<cfset currentTarget = 'otherFeeRevYr2' & #CurrentRow# />
						<cfset feeAmount = 0 />
						<cfif IsNumeric(ADJ_RATE)><cfset feeAmount = ADJ_RATE /></cfif>
						<input name="projHrs_Yr2" id="projHrsYR2#CurrentRow#" value="#PROJHOURS_YR2#" onblur="calcEstRev(this.value, #feeAmount#, '#currentTarget#')"/>
					</td>
					<!---<td name="feeLY" id="feeLY#CurrentRow#">#DollarFormat(ADJ_RATE)#</td>--->
					<td id="otherFeeRevYr2#CurrentRow#" name="estRevYr2">#DollarFormat(EstRev_YR2)#</td>
				</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>

	<div class="controlBar">
	  <div class="controlBinTRC">
		<input id="submitBtn" type="submit" name="submitBtn" class="submitBtn" value="Save Your Work" disabled />
	  </div>
	</div>
</cfoutput>