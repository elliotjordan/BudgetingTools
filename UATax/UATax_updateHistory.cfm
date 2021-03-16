<cfoutput>
<!---<cfdump var="#form#" >--->

<cfif StructKeyExists(form,"flag")>
	<cfset updateUATax("flag",form.linenbr,form.flag) />
</cfif>

<cfif StructKeyExists(form,"flagNote")>
	<cfset updateUATax("flag_note",form.linenbr,form.flagNote) />
</cfif>

<cfif StructKeyExists(form,"unit")>
	<cfset updateUATax("unit",form.linenbr,form.unit) />
</cfif>

<cfif StructKeyExists(form,"catSet")>
	<cfif TRIM(form.catSet) neq "UNCHANGED">
		<cfset updateUATax("item_cat",form.linenbr,TRIM(form.catSet)) />
	</cfif>
</cfif>

<cfif StructKeyExists(form,"subCatSet")>
	<cfif TRIM(form.subCatSet) neq "UNCHANGED">
		<cfset updateUATax("sub_cat",form.linenbr,TRIM(form.subCatSet)) />
	</cfif>
</cfif>

<cfif StructKeyExists(form,"itemNote")>
	<cfset updateUATax("note",form.linenbr,form.itemNote) />
</cfif>

<cfset submission = updateUATax("meta",form.linenbr,form.authUser) />
<cflocation url="UATax_historyEdit.cfm?ln=#form.linenbr#&message=You have successfully updated this record." addtoken="false">
</cfoutput>