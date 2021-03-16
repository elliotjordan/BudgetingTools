<cfset gridData = getRegionalGrid()>
<!---<cfdump var="#gridData#">--->
<cfoutput>
			<table id="regionalGridTable" class="approvalTable">
				<thead>
					<tr>
						<th><span class="sm-blue">Master ID</span></th>
						<th><span class="sm-blue">Description</span></th>
						<!---<th><span class="sm-blue">Columbus</span></th>--->
						<th><span class="sm-blue">East</span></th>
						<th><span class="sm-blue">Kokomo</span></th>
						<th><span class="sm-blue">Northwest</span></th>
						<th><span class="sm-blue">South Bend</span></th>
						<th><span class="sm-blue">Southeast</span></th>
						<th class="separator"> </th>
						<th><span class="sm-blue">Bloomington</span></th>
						<th><span class="sm-blue">IUPUI</span></th>
					</tr>
				</thead>
				<tbody>
					<cfif gridData.recordCount lt 1>
			    		<tr>
					    	<td colspan="12">No rows were returned.  Please contact UBO.</td>
					    </tr>
					<cfelse>
						<cfloop query="#gridData#">
							<cfif gridData.active eq 'Y'>
					    		<tr>
					    			<td>#gridData.ALLFEE_MASTERID#</td>
									<td>#gridData.FEE_DESC_LONG#</td>
									<!---<td><cfif gridData.IUCOA eq ''>--<cfelse>#DollarFormat(gridData.IUCOA)#</cfif></td>--->
									<td><cfif gridData.IUEAA eq ''>--<cfelse>#DollarFormat(gridData.IUEAA)#</cfif></td>
									<td><cfif gridData.IUKOA eq ''>--<cfelse>#DollarFormat(gridData.IUKOA)#</cfif></td>
									<td><cfif gridData.IUNWA eq ''>--<cfelse>#DollarFormat(gridData.IUNWA)#</cfif></td>
									<td><cfif gridData.IUSBA eq ''>--<cfelse>#DollarFormat(gridData.IUSBA)#</cfif></td>
									<td><cfif gridData.IUSEA eq ''>--<cfelse>#DollarFormat(gridData.IUSEA)#</cfif></td>
									<td class="separator"> </td>
									<td><cfif gridData.IUBLA eq ''>--<cfelse>#DollarFormat(gridData.IUBLA)#</cfif></td>
									<td><cfif gridData.IUINA eq ''>--<cfelse>#DollarFormat(gridData.IUINA)#</cfif></td>
					    		</tr>
				    		</cfif>
			    		</cfloop> 
					</cfif>
		    	</tbody>
			</table>
</cfoutput>