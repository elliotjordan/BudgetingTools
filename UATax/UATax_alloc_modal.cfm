<cfoutput>
	<cfloop query="#distObjLevels#">
		<cfif UATax_alloc.RC_CD eq distObjLevels.RC_CD AND distObjLevels.FIN_CONS_OBJ_CD eq '#i#'>
			<span class="goCubs">(#distObjLevels.FIN_OBJ_LEVEL_CD#) #distObjLevels.FIN_OBJ_LEVEL_NM# - $#NumberFormat(OBJ_LVL_SUM)#</span>
		</cfif>
	</cfloop>
</cfoutput>