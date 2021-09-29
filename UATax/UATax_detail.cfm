<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfif opAccess eq false >
  <p>For permission to view this page, please contact the University Budget Office. Thank you.</p>
<cfelse>
<cfset RClist = getDistinctRCs('false') />
<cfset ObjConList = getDistinctObjConCds() />
<cfset revenueConsObjCdList = "STFE,IDIN,OTRE" >
<cfif StructKeyExists(url,"uatObjCon") AND StructKeyExists(url,"uatRC")>
	<cfset UATax_detail = getUATax_data(url.uatrc,url.uatobjcon,"legacy") />  <!--- use lower case for arg! --->
	<cfset selectedRC = #url.uatRC#>
	<cfset selectedObjCon = #url.uatobjcon#>
<cfelse>
	<cfset UATax_detail = getUATax_data("86","CMPN","legacy") />  <!--- use lower case for arg! --->
	<cfset selectedRC = "86">
	<cfset selectedObjCon = "CMPN">
</cfif>

<cfoutput>
	<div class="full_content">
		<h2>Detail Data</h2>
		<p>This page is intended to display line items from the UATax for the campus user to browse and search.</p>
		
		<!---  Let user choose which records to generally view  --->
		<a href="incIncRows.cfm">IncInc Row-level Detail</a><br>
		<form id="detailSelector" name="uatDetailSelection" action="UATax_detail.cfm" method="get">
			<div class="code_group">
				<b>RC:</b> 
				<cfset loopIncrement = 1>
				<cfloop query="RCList">
					<cfset idVal = "RC" & #rc_cd#>
					<cfif selectedRC eq rc_cd><cfset selector = "checked"><cfelse><cfset selector = ""></cfif>
						<input type="radio" id="#idVal#" name="uatRC" value="#rc_cd#" #selector# ><label for="#idVal#"> #rc_cd#</label>
					<cfif loopIncrement neq RCList.recordCount> |</cfif>
					<cfset loopIncrement++ >
				</cfloop>
				
				<br><br>
				
				<div class="revenue_codes">
					<b>Revenue Consolidation Object Codes:</b> 
					<cfloop query="ObjConList">
						<cfset conCdVal = "objCon" & #fin_cons_obj_cd#>
						<cfif ListFindNoCase(revenueConsObjCdList,fin_cons_obj_cd)>
							<cfif selectedObjCon eq fin_cons_obj_cd><cfset selector = "checked"><cfelse><cfset selector = ""></cfif>
							<input type="radio" id="#conCdVal#" name="uatObjCon" value="#fin_cons_obj_cd#" #selector# ><label for="#conCdVal#"> #fin_cons_obj_cd#</label> |
						</cfif>
					</cfloop>					
				</div>  <!-- End class revenue_codes  -->
				
				<div class="expense_codes">
					<b>Expense Consolidation Object Codes:</b> 
					<cfloop query="ObjConList">
						<cfset conCdVal = "objCon" & #fin_cons_obj_cd#>
						<cfif !ListFindNoCase(revenueConsObjCdList,fin_cons_obj_cd)>
							<cfif selectedObjCon eq fin_cons_obj_cd>
								<cfset selector = "checked"><cfelse><cfset selector = "">
							</cfif>
							<input type="radio" id="#conCdVal#" name="uatObjCon" value="#fin_cons_obj_cd#" #selector# ><label for="#conCdVal#"> #fin_cons_obj_cd#</label> |
						</cfif>
					</cfloop>					
				</div>  <!-- End class expense_codes  -->
				
				<br>
				
				<input class="workSaver" type="submit" value="Update" />
			</div>   <!-- End div class code_group  -->
		</form>
		
		<br clear="all">
		<h2>UA Support Details<cfif StructKeyExists(url,"uatRC") AND StructKeyExists(url,"uatObjCon")> for RC #url.uatRC#, Consolidation Object Code #url.uatObjCon#</cfif></h2>
		<!--- Display the result  --->
		<table id="uaTaxDetailTable" class="summaryTable">
			<thead>
				<tr>
					<th>Specific Line Number</th>
					<th class="wide">Org</th>
					<th>Obj Cd</th>
					<th>Account</th>
					<th>Account Name</th>
					<th>Base Budget Amt</th>
					<th>Adjusted Base Amt</th>
				</tr>
			</thead>
			<tbody>
					<cfif UATax_detail.recordCount eq 0>
						<tr>
							<td style="border:1px solid black">No records available to review.</td><td></td><td></td><td></td><td></td><td></td><td></td>
						</tr
					<cfelse>				
						<cfloop query="#UATax_detail#">
							<tr>
								<td class="narrow">#UATAX_ID#</td>
								<td class="wide"><span class="tiny-black">#ORG_CD# - #ORG_NM#</span></td>
								<td>#FIN_OBJECT_CD#</td>
								<td>#ACCOUNT_NBR#</td>
								<td>#ACCOUNT_NM#</td>
								<td>#DollarFormat(BB_AMT)#</td>
								<td>#DollarFormat(ADJBASE_AMT)#</td>
							</tr>
						</cfloop>
					</cfif>
			</tbody>
		</table>
	</div>  <!-- End div class "full_content" -->
</cfoutput>
</cfif>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
