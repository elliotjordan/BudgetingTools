<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">
<cfset scenario_list = getUATaxScenarios() />

<cfoutput>
<a href="index.cfm">Home</a><br>

<h2>UA Support Scenarios</h2>
<p>This page intended to present UA Support scenarios at a high level</p>
<p>Only UBO personnel designated as "admins" can see the link to the page, or the contents of the page.<br>
	Currently the designated UBO admins are:<br> #REQUEST.adminUsernames#
</p>
<cfif ListFindNoCase(REQUEST.adminUsernames,REQUEST.authUser)>
<table class="summaryTable">
	<colgroup>
		<col class="medium" /><col class="medium" /><col class="medium" /><col class="medium" /><col class="medium" /><col class="medium" /><col class="medium" />
	</colgroup>
	<thead>
		<tr>
			<th>Aggregated Costs</th>
			<th>Scenario 1</th>
			<th>Scenario 2</th>
			<th>Scenario 3</th>
			<th>...</th>
			<th>...</th>
			<th>...</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="subTotal_gray">Actual Expense</td>
			<td class="admin_burden_pink">$97B</td>
			<td class="admin_burden_orange">$98B</td>
			<td class="admin_burden_red">$99B</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_gray">Actual Revenue</td>
			<td class="admin_burden_pink">$92M</td>
			<td class="admin_burden_orange">$90M</td>
			<td class="admin_burden_red">$89M</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_gray">Backed trans out</td>
			<td class="admin_burden_pink">$23M</td>
			<td class="admin_burden_orange">$28M</td>
			<td class="admin_burden_red">$34M</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_gray">Subfund - Research</td>
			<td class="admin_burden_pink">$24M</td>
			<td class="admin_burden_orange">$21M</td>
			<td class="admin_burden_red">$22M</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_gray">Subfund - Travel</td>
			<td  class="admin_burden_pink">$7M</td>
			<td class="admin_burden_orange">$7.2M</td>
			<td class="admin_burden_red">$7.6MM</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_gray">- etc -</td>
			<td class="admin_burden_pink">- etc --</td>
			<td class="admin_burden_orange">- etc -</td>
			<td class="admin_burden_red">- etc -</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="subTotal_white">Campus/RC Subsidy</td>
			<td class="admin_burden_purple">IUBLA - 57%<br>
				IUSM - 12.1%<br>
				IUPUI - 32.1%<br>
				IUEAA - 17.6%<br>
				IUKOA - 18.2%<br>
				IUNWA - 14.4%<br>
				IUSBA - 19.0%<br>
				IUSEA - 12.8%
			</td>
			<td class="admin_burden_tangerine">IUBLA - 57%<br>
				IUSM - 12.1%<br>
				IUPUI - 32.1%<br>
				IUEAA - 17.6%<br>
				IUKOA - 18.2%<br>
				IUNWA - 14.4%<br>
				IUSBA - 19.0%<br>
				IUSEA - 12.8%
			</td>
			<td class="admin_burden_scarlet">IUBLA - 57%<br>
				IUSM - 12.1%<br>
				IUPUI - 32.1%<br>
				IUEAA - 17.6%<br>
				IUKOA - 18.2%<br>
				IUNWA - 14.4%<br>
				IUSBA - 19.0%<br>
				IUSEA - 12.8%
			</td>
			<td class=""></td>
			<td class=""></td>
			<td class=""></td>
		</tr>

	</tbody>
</table>

<cfelse>
	<p>We are sorry, but you are not authorized to access this page.  Please contact UBO to request permission for access.
</cfif>
</cfoutput>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">