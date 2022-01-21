<cfoutput>
	<table id="fymSummaryTable" class="summaryTable">
	  <tr>
	  	<th>Item</th>
		<th>FY#application.shortfiscalyear# Adj Base Budget</th>
		<th>FY#application.shortfiscalyear# Projection</th>
		<th>FY#application.shortfiscalyear + 1# Projection</th>
		<th>FY#application.shortfiscalyear + 2# Projection</th>
		<th>FY#application.shortfiscalyear + 3# Projection</th>
		<th>FY#application.shortfiscalyear + 4# Projection</th>
		<th>FY#application.shortfiscalyear + 5# Projection</th>
	  </tr>
	<cfloop query="fymSummaryTable">
	  	<tr>
	  		<td>#item#</td>
	  		<td><span id="rs_pr">$ #NumberFormat(pr_total,'999,999,999')#</span></td>
	  		<td><span id="rs_cy">$ #NumberFormat(cy_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr1">$ #NumberFormat(yr1_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr2">$ #NumberFormat(yr2_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr3">$ #NumberFormat(yr3_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr4">$ #NumberFormat(yr4_total,'999,999,999')#</span></td>
	  		<td><span id="rs_yr5">$ #NumberFormat(yr5_total,'999,999,999')#</span></td>
	  	</tr>
	</cfloop>
	</table>  <!--- End of fymSummaryTable  --->
</cfoutput>
	
	  
	  	  