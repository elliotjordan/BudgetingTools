<!--- 
	file:	Feecodetofeekeymap.cfc
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	12-21-15
	update:	12-19-17
	note:	Component to match Oracle table in 'fee' datasource.  ORM is enabled in this application.
 --->
<cfcomponent datasource="#application.datasource#" persistent="true" table="FEECODETOFEEKEYMAP">
	<cfproperty name="rowid" column="`ROWID`" fieldtype="id" generated="always" />
	<cfproperty name="inst" fieldtype="column" elementtype="string" length="5" notnull="false"/>
	<cfproperty name="feecode" fieldtype="column" elementtype="string" length="6" notnull="false" />
	<cfproperty name="feeid" fieldtype="column" elementtype="string" length="6" notnull="false" />
	<cfproperty name="feedescr" fieldtype="column" elementtype="string" length="64" notnull="false" />
	<cfproperty name="updated_fy" fieldtype="column" elementtype="string" length="4" notnull="false" />

	<cffunction name="init" hint="Constructor" access="public" output="false"> 
		<cfargument name="inst" hint="the fee_inst of the record" type="string" required="no" default="" /> 
		<cfargument name="feecode" hint="the feecode of the record" type="string" required="no" default="" /> 
		<cfargument name="feeid" hint="the fee_id of the record" type="string" required="no" default="" /> 
		<cfargument name="feedescr" hint="the fee_descr of the record" type="string" required="no" default="" /> 
		<cfargument name="updated_fy" hint="the fiscal year of the record" type="string" required="no" default="" /> 
		<cfscript> 
			setInst(arguments.inst);
			setFeecode(arguments.feecode);
			setFeedescr(arguments.feeid);
			setFeeid(arguments.feedescr);
			setUpdated_fy(arguments.updated_fy);
			return this; 
		</cfscript> 
	</cffunction>
</cfcomponent>