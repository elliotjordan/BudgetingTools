<cfinclude template="../includes/header_footer/UATax_header.cfm" runonce="true">
<cfinclude template="../includes/functions/UATax_functions.cfm" runonce="true">

<cfif StructKeyExists(url,"ln")>
	<cfset B7940item = getSpecificItem(url.ln) />
	<cfset B7940itemCatList = getItemCatList() />
	<cfset B7940itemSubCatList = getItemSubCatList() />

	<cfoutput>
		<form action="UATax_historyEdit.cfm" method="post" id="updateHistoryForm">
			<cfif B7940item.recordCount eq 0>
				<h2>No record available to review.</h2>
			<cfelse>
				<span class="fieldset narrow">
					<a href="UATax_adjBase.cfm">BACK</a><br>
					<cfif StructKeyExists(url,"message") and LEN(url.message) gt 0>
						<h3 class="admin_burden_indigo">#url.message#</h3>
					</cfif>
				<h2>Edit B7940 item - row #B7940item.src_line_nbr#</h2>
				Fiscal Year: #B7940item.FY# <br>
				Description: #B7940item.ITEM_DESC# <br>
				UA Service Charge: #NumberFormat(B7940item.UA_SVC_CHARGE)# <br>
				UA Auxiliary: #NumberFormat(B7940item.UA_AUX)# <br>
				BL: #NumberFormat(B7940item.BLOOMINGTON)# <br>
				IUPUI: #NumberFormat(B7940item.IUPUI_GA)# <br>
				IUSM: #NumberFormat(B7940item.IUPUI_SOM)# <br>
				EA: #NumberFormat(B7940item.EAST)# <br>
				KO: #NumberFormat(B7940item.KOKOMO)# <br>
				NW: #NumberFormat(B7940item.NORTHWEST)# <br>
				SB: #NumberFormat(B7940item.SOUTH_BEND)# <br>
				SE: #NumberFormat(B7940item.SOUTHEAST)#
				TOTAL: #NumberFormat(B7940item.TOTAL)# <br>
				UNIT: <input name="unit" alt="Update unit for this row" class="fielditem" value="#B7940item.UNIT#"><br>
				NOTE:<textarea name="itemNote" cols="multiple" rows="1" wrap="soft" alt="Note for this item" class="fielditem wide" maxlength="512"><cfif LEN(B7940item.note) eq 0>(none)<cfelse>#B7940item.NOTE#</cfif>
					</textarea>
				Flag: <br><label for="flag"><i>Enter a word that describes the issue, such as "error", "correction", etc.</i></label> <br />
				<input name="flag" alt="Flag field" class="fielditem" value="#B7940item.FLAG#"><br>

				Flag Note: <br><label for="flag"><i>Add any notes you wish for the flag you entered above.</i></label> <br />
				  <textarea  name="flagNote" cols="multiple" rows="1" wrap="soft" alt="Note for flag field" class="fielditem wide" maxlength="128">#B7940item.FLAG_NOTE#</textarea>
				  <br>
				<h3>Category: #B7940item.ITEM_CAT#</h3>
				  <select name="catSet" class="fielditem">
				  	<option value="UNCHANGED">Set Category</option>
				  	<cfloop query="#B7940itemCatList#">
				  		<option value="#item_cat#" <cfif B7940item.ITEM_CAT eq item_cat>selected</cfif>  >#item_cat#</option>
				  	</cfloop>
				  </select>
				  <br>
				<h3>Sub-category: #B7940item.SUB_CAT#</h3>
				  <select name="subCatSet" class="fielditem">
				  	<option value="UNCHANGED">Set Sub-category</option>
				  	<cfloop query="#B7940itemSubCatList#">
				  		<option value="#sub_cat#" <cfif B7940item.SUB_CAT eq sub_cat>selected</cfif>  >#sub_cat#</option>
				  	</cfloop>
				  </select>
				  <br>
				Metadata:
				  <cfif #LEN(B7940item.meta)# eq 0><span class="fielditem">(none)</span>
				  <cfelse><span class="fielditem">#B7940item.META#</span>
				  </cfif>
 				  <br>
				<input name="authUser" type="hidden" value="#REQUEST.authUser#" alt="hidden username field for metadata updates">
				<input name="lineNbr" type="hidden" value="#B7940item.src_line_nbr#" alt="hidden line number field for metadata updates">
				<input type="submit" alt="Update changes button" value="Submit updates" />
			</cfif>
		</form>
	</cfoutput>

<cfelseif IsDefined("form") and StructKeyExists(form,"authUser") and StructKeyExists(form,"linenbr")>
	<cfinclude template="UATax_updateHistory.cfm" runonce="true">
<cfelse>
	<cflocation url="index.cfm?message=request not recognized" addtoken="false">
</cfif>
<cfinclude template="../includes/header_footer/UATax_footer.cfm" runonce="true">
