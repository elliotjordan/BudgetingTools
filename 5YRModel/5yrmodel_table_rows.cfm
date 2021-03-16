<cfoutput>
	  	<tr>
	  		<td>
	  			<cfif Len(details_disp) gt 0><div class="tooltip2">
	  			<cfelse><div>
	  			</cfif>
	  				<span class="sm-blue">#grp1_desc# #grp2_desc#</span><br>
	  				#ln1_desc#<cfif Len(details_disp) gt 0><span class="tooltiptext">#details_disp#</span></cfif>
	  				<cfif ln2_desc neq ''> - #ln2_desc#</cfif>
	  			</div>
	  		</td>
			<td>
				<span  id="origOID#OID#" name="origOID#OID#_#grp2_cd#">$#NumberFormat(cy_orig_budget_amt,'999,999,999')#</span><br />
				<input id="origOID#OID#" type="hidden" value="#NumberFormat(cy_orig_budget_amt,'999,999,999')#" />
			</td>
			<td><!--- Current year col --->
				<cfif param_type_cd eq 'CMP' and editcy>

					<span id="rtc#OID#" class="sm-blue">Running total: $ #NumberFormat( cur_yr_new,'999,999,999')#</span><br>
					$ <input id="cur_yr_newOID#OID#" name="cur_yr_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(cur_yr_new,'999,999,999'))#" /><br />
					<input id="cur_yr_newOID#OID#DELTA" name="cur_yr_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span  id="cur_yr_newOID#OID#" name="cur_yr_newOID#OID#_#grp2_cd#">$ #NumberFormat(cur_yr_new,'999,999,999')#</span>
				</cfif>
			</td>
			<td><!--- Yr1 col --->
				<cfif param_type_cd eq 'CMP' and edityr1>
					<span id="rt1#OID#" class="sm-blue">Running total: $ #NumberFormat(yr1_old + yr1_new,'999,999,999')#</span><br>
					$ <input id="yr1_newOID#OID#" name="yr1_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(yr1_new,'999,999,999'))#" /><br />
					<input id="yr1_newOID#OID#DELTA" name="yr1_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span  id="yr1_newOID#OID#" name="yr1_newOID#OID#_#grp2_cd#">$ #NumberFormat(yr1_new,'999,999,999')#</span>
				</cfif>
			</td>
			<td><!--- Yr2 col --->
				<cfif param_type_cd eq 'CMP' and edityr2>
					<span id="rt2#OID#" class="sm-blue">Running total: $ #NumberFormat(yr2_old + yr2_new,'999,999,999')#</span><br>
					$ <input id="yr2_newOID#OID#" name="yr2_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(yr2_new,'999,999,999'))#" /><br />
					<input id="yr2_newOID#OID#DELTA" name="yr2_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span id="yr2_newOID#OID#" name="yr2_newOID#OID#_#grp2_cd#">$ #NumberFormat(yr2_new,'999,999,999')#</span>
				</cfif>
			</td>
			<td><!--- Yr3 col --->
				<cfif param_type_cd eq 'CMP' and edityr3>
					<span id="rt3#OID#" class="sm-blue">Running total: $ #NumberFormat(yr3_old + yr3_new,'999,999,999')#</span><br>
					$ <input id="yr3_newOID#OID#" name="yr3_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(yr3_new,'999,999,999'))#" /><br />
					<input id="yr3_newOID#OID#DELTA"  name="yr3_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span id="yr3_newOID#OID#"  name="yr3_newOID#OID#_#grp2_cd#">$ #NumberFormat(yr3_new,'999,999,999')#</span>
				</cfif>
			</td>
			<td><!--- Yr4 col --->
				<cfif param_type_cd eq 'CMP' and edityr4>
					<span id="rt4#OID#" class="sm-blue">Running total: $ #NumberFormat(yr4_old + yr4_new,'999,999,999')#</span><br>
					$ <input id="yr4_newOID#OID#" name="yr4_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(yr4_new,'999,999,999'))#" /><br />
					<input id="yr4_newOID#OID#DELTA" name="yr4_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span id="yr4_newOID#OID#"  name="yr4_newOID#OID#_#grp2_cd#">$ #NumberFormat(yr4_new,'999,999,999')#</span>
				</cfif>
			</td>
			<td><!--- Yr5 col --->
				<cfif param_type_cd eq 'CMP' and edityr5>
					<span id="rt5#OID#" class="sm-blue">Running total: $ #NumberFormat(yr5_old + yr5_new,'999,999,999')#</span><br>
					$ <input id="yr5_newOID#OID#" name="yr5_newOID#OID#_#grp2_cd#" type="text" size="10" value="#trim(NumberFormat(yr5_new,'999,999,999'))#" /><br />
					<input id="yr5_newOID#OID#DELTA" name="yr5_newOID#OID#_#grp2_cd#DELTA" type="hidden" value="false">
				<cfelse>
					<span id="yr5_newOID#OID#" name="yr5_newOID#OID#_#grp2_cd#">$ #NumberFormat(yr5_new,'999,999,999')#</span>
				</cfif>
			</td> <!---<cfdump var="#commentBucket[104].comment#" ><cfabort>--->
			<td><!--- Comment --->
				<cfif StructKeyExists(commentbucket,oid)>
					<textarea id="comm_#OID#" name="comm_#OID#" type="text" maxlength="1024" height="3" width="100%">#commentBucket[oid].comment#</textarea>
					<input id="comm_#OID#CDELTA" name="comm_#OID#CDELTA" type="hidden" value="false" />
				<cfelse>
					<textarea id="comm_#OID#" type="text" maxlength="1024" height="3" width="100%">#commentBucket[oid].comment#</textarea>
					<input id="comm_#OID#CDELTA" name="comm_#OID#CDELTA" type="hidden" value="false" />
				</cfif>
			</td>
		</tr>
</cfoutput>