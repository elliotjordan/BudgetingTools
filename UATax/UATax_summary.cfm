<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">

<cfscript>
	try{
		currentUser = getUATaxUser(REQUEST.authUser);
		UATax_alloc = getUATaxCharges();
		distObjLevels = getDistinctObjLevels('2020');
	} catch (any e) {
		WriteOutput("UATax-bug-o-matic: " & e.message);
	}
</cfscript>
<!---<cfdump var="#UATax_alloc#" />  <cfabort>--->
<cfset revConsObjCdList = "STFE,IDIN,OTRE">
<cfset expConsObjCdList = "CMPN,CPTL,GENX,IDEX,SCHL,TRVL,RSRX">
<cfset distObjLevels = getDistinctObjLevels('2020') />

<cfoutput>
<a href="index.cfm">Home</a><br>

<div class="full_content">
	<h2>What Are You Paying For?</h2>
	<p>Here are the current expense summaries for the UA units.</p>

	    <!--- Exclude income and contingency RCs  --->
	<table class="summaryTable pres_rows">
		<thead>
			<th>Expense Category</th>
			<th>Account</th>
			<th>Object Code</th>
			<th>Sub-object Code</th>
			<th>UA Aux</th>
			<th>Bloomington</th>
			<th>IUPUI - GA</th>
			<th>IUSM</th>
			<th>East</th>
			<th>Kokomo</th>
			<th>Northwest</th>
			<th>South Bend</th>
			<th>Southeast</th>
			<th>UA Total</th>
		</thead>
		<tbody>
		<cfloop query="#UATax_alloc#">
			<cfif FindNoCase('base',source) and acct_nbr neq ''>
			<tr>
				<td>#item_desc#</b></td>
				<td>#acct_nbr#</td>
				<td>#fin_obj_cd_shrt_nm#<br><span class="sm-blue">(#obj_cd#)</span></td>
				<td>#sub_obj_cd#</td>
				<td>$#NumberFormat(ua_aux,'999,999')#</td>
				<td>$#NumberFormat(iubla,'999,999')#</td>
				<td>$#NumberFormat(east,'999,999')#</td>
				<td>$#NumberFormat(kokomo,'999,999')#</td>
				<td>$#NumberFormat(iupui_ga,'999,999')#</td>
				<td>$#NumberFormat(iupui_som,'999,999')#</td>
				<td>$#NumberFormat(northwest,'999,999')#</td>
				<td>$#NumberFormat(south_bend,'999,999')#</td>
				<td>$#NumberFormat(southeast,'999,999')#</td>
				<td>$#NumberFormat(total,'999,999')#</td>
			</tr>
			</cfif>
			<cfif FindNoCase('base',source) and acct_nbr eq ''>
			<tr> <td colspan='4'>#item_desc#</b></td>
				<td>#NumberFormat(ua_aux *100,'999.99')#%</td>
				<td>#NumberFormat(iubla *100,'999.99')#%</td>
				<td>#NumberFormat(east *100,'999.99')#%</td>
				<td>#NumberFormat(kokomo *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_ga *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_som *100,'999.99')#%</td>
				<td>#NumberFormat(northwest *100,'999.99')#%</td>
				<td>#NumberFormat(south_bend *100,'999.99')#%</td>
				<td>#NumberFormat(southeast *100,'999.99')#%</td>
				<td>#NumberFormat(total,'999.99')#%</td>
			</tr>
			</cfif>
		</cfloop>
		<cfloop query="#UATax_alloc#">
			<cfif FindNoCase('change',source) and acct_nbr neq ''>
			<tr> <td>#item_desc#</b></td> <td>#acct_nbr#</td> <td>#obj_cd#</td> <td>#sub_obj_cd#</td>  				<td>$#NumberFormat(ua_aux,'999,999')#</td>
				<td>$#NumberFormat(iubla,'999,999')#</td>
				<td>$#NumberFormat(east,'999,999')#</td>
				<td>$#NumberFormat(kokomo,'999,999')#</td>
				<td>$#NumberFormat(iupui_ga,'999,999')#</td>
				<td>$#NumberFormat(iupui_som,'999,999')#</td>
				<td>$#NumberFormat(northwest,'999,999')#</td>
				<td>$#NumberFormat(south_bend,'999,999')#</td>
				<td>$#NumberFormat(southeast,'999,999')#</td>
				<td>$#NumberFormat(total,'999,999')#</td>
			</tr>
			</cfif>
			<cfif FindNoCase('change',source) and acct_nbr eq ''>
			<tr> <td colspan='4'>#item_desc#</b></td>
				<td>#NumberFormat(ua_aux *100,'999.99')#%</td>
				<td>#NumberFormat(iubla *100,'999.99')#%</td>
				<td>#NumberFormat(east *100,'999.99')#%</td>
				<td>#NumberFormat(kokomo *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_ga *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_som *100,'999.99')#%</td>
				<td>#NumberFormat(northwest *100,'999.99')#%</td>
				<td>#NumberFormat(south_bend *100,'999.99')#%</td>
				<td>#NumberFormat(southeast *100,'999.99')#%</td>
				<td>#NumberFormat(total,'999.99')#%</td>
			</tr>
			</cfif>
		</cfloop>
		<cfloop query="#UATax_alloc#">
			<cfif FindNoCase('total',source) and acct_nbr neq ''>
			<tr> <td>#item_desc#</b></td> <td>#acct_nbr#</td> <td>#obj_cd#</td> <td>#sub_obj_cd#</td>  				<td>$#NumberFormat(ua_aux,'999,999')#</td>
				<td>$#NumberFormat(iubla,'999,999')#</td>
				<td>$#NumberFormat(east,'999,999')#</td>
				<td>$#NumberFormat(kokomo,'999,999')#</td>
				<td>$#NumberFormat(iupui_ga,'999,999')#</td>
				<td>$#NumberFormat(iupui_som,'999,999')#</td>
				<td>$#NumberFormat(northwest,'999,999')#</td>
				<td>$#NumberFormat(south_bend,'999,999')#</td>
				<td>$#NumberFormat(southeast,'999,999')#</td>
				<td>$#NumberFormat(total,'999,999')#</td>
			</tr>
			</cfif>
			<cfif FindNoCase('total',source) and acct_nbr eq ''>
			<tr> <td colspan='4'>#item_desc#</b></td>
				<td>#NumberFormat(ua_aux *100,'999.99')#%</td>
				<td>#NumberFormat(iubla *100,'999.99')#%</td>
				<td>#NumberFormat(east *100,'999.99')#%</td>
				<td>#NumberFormat(kokomo *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_ga *100,'999.99')#%</td>
				<td>#NumberFormat(iupui_som *100,'999.99')#%</td>
				<td>#NumberFormat(northwest *100,'999.99')#%</td>
				<td>#NumberFormat(south_bend *100,'999.99')#%</td>
				<td>#NumberFormat(southeast *100,'999.99')#%</td>
				<td>#NumberFormat(total,'999.99')#%</td>
			</tr>
			</cfif>
		</cfloop>

		</tbody>
	</table>

<!---<cfdump var="#UATax_alloc#" >--->


	<!--- Historical budgets  --->
	<h3>INDIANA UNIVERSITY<br>2007-08 Operating Budget</h3>
	<h2>University Assessment (Administrative Service Charge)</h2>

	<table class="summaryTable">
		<thead>
			<th>Campus</th>
			<th>2006-07 Rebased Amount</th>
			<th>2007-08 Request</th>
			<th>Amount Change</th>
			<th>Change</th>
		</thead>
		<tbody>
			<tr> <td>Bloomington</td><td>29,981,792</td><td>30,731,336</td>	<td>749,544</td>	<td>2.5%</td></tr>
			<tr> <td>IUPUI</td> <td>8,797,950</td>	<td>9,017,899</td>		<td>219,949</td>	<td>2.5%</td></tr>
			<tr> <td>East</td><td>304,617</td>	<td>312,232</td>			<td>7,615</td>	<td>2.5%</td></tr>
			<tr> <td>Kokomo</td> <td>369,410</td>	<td>378,645</td>			<td>9,235</td>	<td>2.5%</td></tr>
			<tr> <td>Northwest</td> <td>672,342</td>	<td>689,151</td>		<td>16,809</td>	<td>2.5%</td></tr>
			<tr> <td>South Bend</td> <td>951,673</td>  <td>975,465</td>		<td>23,792</td>	<td>2.5%</td></tr>
			<tr> <td>Southeast</td> <td>753,463</td>	<td>772,300</td>		<td>18,837</td>	<td>2.5%</td></tr>
			<tr> <td>University Admin</td> <td>864,796</td>	<td>886,416</td>	<td>21,620</td>	<td>2.5%</td></tr>
			<tr> <td>TOTALS</td> <td>42,696,043</td> <td>43,763,444</td> <td>1,067,401</td>	<td>2.5%</td></tr>
		</tbody>
	</table>

	<p>Campuses are encouraged to redistribute increases in both the university and campus assessments to non-general fund operations, to the greatest extent possible, in order to preserve dollars available for key academic priorities.</p>


	<h2>Rebasing:</h2>
	<table class="summaryTable">
		<thead>
			<th>Campus</th>
			<th>Adjusted Base</th>
			<th>Rebasing Amount</th>
			<th>Adjusted Rebased</th>
			<th>Change</th>
		</thead>
		<tbody>
			<tr><td>Bloomington</td><td>29,736,729</td><td>245,063</td>	<td>29,981,792</td>	<td>0.8%</td></tr>
			<tr><td>IUPUI</td><td>8,789,068</td>	<td>8,882</td>		<td>8,797,950</td>	<td>0.1%</td></tr>
			<tr><td>East</td><td>318,681</td>	<td>(14,064)</td>			<td>304,617</td>	<td>(4.4%)</td></tr>
			<tr><td>Kokomo</td><td>383,151</td>	<td>(13,741)</td>			<td>369,410</td>	<td>(3.6%)</td></tr>
			<tr><td>Northwest</td><td>682,283</td>	<td>(9,941)</td>		<td>672,342</td>	<td>(1.5%)</td></tr>
			<tr><td>South Bend</td><td>971,364/td>	<td>(19,691)</td>		<td>951,673</td>	<td>(2.0%)</td></tr>
			<tr><td>Southeast</td><td>793,834</td>	<td>(40,371)</td>		<td>753,463</td>	<td>(5.1%)</td></tr>
			<tr><td>University Admin</td><td>1,020,933</td>	<td>(156,137)</td>	<td>864,796</td>	<td>(15.3%)</td></tr>
			<tr><td>TOTALS</td><td>42,696,043</td>	<td>-</td>		<td>42,696,043</td>	<td>0.0%</td> </tr>
		</tbody>
	</table>
</div>  <!-- End div class "full_content" -->
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
