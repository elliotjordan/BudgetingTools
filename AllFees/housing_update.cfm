<cfinclude template="../includes/functions/fee_rate_functions.cfm" >
	<cfif StructKeyExists(FORM, "ALLFEE_ID")>
		<cfset counter = 1>
		<cfloop index="id" list="#Form.ALLFEE_ID#" delimiters=",">
			<!---#ListGetAt(ALLFEE_ID,counter)# - #ListGetAt(FY20_INPUT,counter)# - #ListGetAt(FY21_INPUT,counter)#<br>--->
			<cfset doThisOne = updateHousing( #ListGetAt(ALLFEE_ID,counter)#, #ListGetAt(FY20_INPUT,counter)#, #ListGetAt(FY21_INPUT,counter)# )> 
			<cfif dothisOne eq true>
	    		<cfset counter = counter + 1>
	    	<cfelse>
	    		<h2>Something is broken in the updateHousing() code.  Please contact John Burgoon or Nathan Schroder at UBO.  Thanks!</h2>
	    		<cfabort>
			</cfif>
		</cfloop>
	</cfif>
<cflocation url="housing.cfm" addtoken="false" />
