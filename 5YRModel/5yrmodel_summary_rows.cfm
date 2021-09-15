<cfoutput>  
	  <cfloop query="fymRevSums">
	  	<tr>
	  		<td>Revenue Totals</td>
	  		<td><span id="rs_pr">$ #NumberFormat(fymRevSums.pr_total,'999,999,999')#</span></td>
	  		<td><span id="rs_cy">$ #NumberFormat(fymRevSums.cy_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr1">$ #NumberFormat(fymRevSums.yr1_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr2">$ #NumberFormat(fymRevSums.yr2_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr3">$ #NumberFormat(fymRevSums.yr3_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr4">$ #NumberFormat(fymRevSums.yr4_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr5">#NumberFormat(fymRevSums.yr5_total,'999,999,999')#</span></td>
	  	</tr>
	  </cfloop>

	  <cfloop query="fymRevDelta">
	  	<tr>
	  		<td>Revenue change from prior year</td>
	  		<td><span>--</span></td>
	  		<td><span id="rs_cydelta">#NumberFormat(fymRevSums.cy_total - fymRevSums.pr_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr1delta">#NumberFormat(fymRevSums.yr1_total - fymRevSums.cy_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr2delta">#NumberFormat(fymRevSums.yr2_total - fymRevSums.yr1_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr3delta">#NumberFormat(fymRevSums.yr3_total - fymRevSums.yr2_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr4delta">#NumberFormat(fymRevSums.yr4_total - fymRevSums.yr3_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr5delta">#NumberFormat(fymRevSums.yr5_total - fymRevSums.yr4_total,'999,999,999')#</span></td>
	  	</tr>
	  </cfloop>
	  
	  <cfloop query="fymExpSums">
	  	<tr>
	  		<td>Expense totals</td>
	  		<td><span id="xs_pr">$ #NumberFormat(fymExpSums.pr_total)#</span></td>
	  		<td><span id="xs_cy">$ #NumberFormat(fymExpSums.cy_total)#</span></td>
	  		<td><span id="xs_yr1">$ #NumberFormat(fymExpSums.yr1_total)#</span></td>
	  		<td><span id="xs_yr2">$ #NumberFormat(fymExpSums.yr2_total)#</span></td>
	  		<td><span id="xs_yr3">$ #NumberFormat(fymExpSums.yr3_total)#</span></td>
	  		<td><span id="xs_yr4">$ #NumberFormat(fymExpSums.yr4_total)#</span></td>
	  		<td><span id="xs_yr5">$ #NumberFormat(fymExpSums.yr5_total)#</span></td>
	  	</tr>
	  </cfloop>

	  <cfloop query="fymExpDelta">
	  	<tr>
	  		<td>Expense change from prior year</td>
	  		<td><span>--</span></td>
	  		<td><span id="xs_cydelta">#NumberFormat(fymExpSums.cy_total - fymExpSums.pr_total)#</span></td>
	  		<td><span id="xs_yr1delta">#NumberFormat(fymExpSums.yr1_total - fymExpSums.cy_total)#</span></td>
	  		<td><span id="xs_yr2delta">#NumberFormat(fymExpSums.yr2_total - fymExpSums.yr1_total)#</span></td>
	  		<td><span id="xs_yr3delta">#NumberFormat(fymExpSums.yr3_total - fymExpSums.yr2_total)#</span></td>
	  		<td><span id="xs_yr4delta">#NumberFormat(fymExpSums.yr4_total - fymExpSums.yr3_total)#</span></td>
	  		<td><span id="xs_yr5delta">#NumberFormat(fymExpSums.yr5_total - fymExpSums.yr4_total)#</span></td>
	  	</tr>
	  </cfloop>	 
	  
	  <cfloop query="fymSurplus">
	  	<tr>
	  		<td>Total Surplus/Deficit</td>
	  		<td><span id="tsd_pr">$ #NumberFormat(fymRevSums.pr_total - fymExpSums.pr_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_cy">$ #NumberFormat(fymRevSums.cy_total - fymExpSums.cy_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_yr1">$ #NumberFormat(fymRevSums.yr1_total - fymExpSums.yr1_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_yr2">$ #NumberFormat(fymRevSums.yr2_total - fymExpSums.yr2_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_yr3">$ #NumberFormat(fymRevSums.yr3_total - fymExpSums.yr3_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_yr4">$ #NumberFormat(fymRevSums.yr4_total - fymExpSums.yr4_total,'999,999,999')#</span></td>
	  		<td><span id="tsd_yr5">$ #NumberFormat(fymRevSums.yr5_total - fymExpSums.yr5_total,'999,999,999')#</span></td>
	  	</tr>
	  </cfloop>	  
</cfoutput>
	
	  
	  	  