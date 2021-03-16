<!--- 
	file:	Fee_codes.cfc
	author:	John Burgoon jburgoon
	ver.:	v0.1
	date:	12-21-15
	update:	04-10-16
	note:	Component to match Oracle table in 'fee' datasource.  ORM is enabled in this application.
	cfproperty "version" - This sets optimistic locking to use version numbers. 
 --->
<cfcomponent datasource="#application.datasource#" persistent="true" table="FEE_CODES">
	<cfproperty name="id" column="id" fieldtype="id" length="10" notnull="true" generator="sequence" sequence="fee_user.FEE_CODES_SEQ" />
	<cfproperty name="fee_id" fieldtype="column" elementtype="string" length="6" notnull="true" />
	<cfproperty name="fee_masterid" fieldtype="column" elementtype="string" length="6" notnull="false" />
	<cfproperty name="fee_inst" fieldtype="column" elementtype="string" length="6" notnull="false"/>
	<cfproperty name="fee_residency" fieldtype="column" elementtype="string" length="1" notnull="false" />
	<cfproperty name="fee_distance" fieldtype="column" elementtype="string" length="1" notnull="false" />
	<cfproperty name="fee_descr" fieldtype="column" elementtype="string" length="80" notnull="false" />
	<cfproperty name="fee_lowyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_highyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_vpfactorlowyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_vpfactorhighyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_bursarfactorlowyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_bursarfactorhighyear" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="fee_type" fieldtype="column" elementtype="string" length="30" notnull="false" />
	<cfproperty name="fee_setbycampusindicator" fieldtype="column" elementtype="string" length="1" notnull="false" />
	<cfproperty name="fee_sortseq" fieldtype="column" elementtype="string" length="7" notnull="false" />
	<cfproperty name="version" fieldtype="version" datatype="int" />  
	<cfproperty name="categ" fieldtype="column" elementtype="string" length="16" notnull="false" />
	<cfproperty name="sort_key" fieldtype="column" elementtype="string" length="8" notnull="false" />
	<cfproperty name="fee_current" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="approval_status" fieldtype="column" elementtype="string" length="1" notnull="false" />
	<cfproperty name="fiscal_year" fieldtype="column" elementtype="numeric" length="10" notnull="false" />
	<cfproperty name="xfactor" fieldtype="column" elementtype="numeric" length="2" notnull="false" />
	<cfproperty name="subm_ly" fieldtype="column" elementtype="numeric" length="12" notnull="false" default="0" />
	<cfproperty name="subm_hy" fieldtype="column" elementtype="numeric" length="12" notnull="false" default="0" />
	<cfproperty name="subm_ft" fieldtype="column" elementtype="string" length="30" notnull="false" />
	<cfproperty name="feeid_subgrpcd" fieldtype="column" elementtype="string" length="8" notnull="false" />
	<cfproperty name="ratecap_pct" fieldtype="column" elementtype="numeric" length="6" notnull="false" />

	<cffunction name="init" hint="Constructor" access="public" output="false"> 
		<cfargument name="id" hint="Internal ID used by CF ORM" type="numeric" required="no" />
		<cfargument name="fee_id" hint="the fee_id of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_masterid" hint="the fee_masterid of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_inst" hint="the fee_inst of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_residency" hint="the fee_residency of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_distance" hint="the fee_distance of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_descr" hint="the fee_descr of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_lowyear" hint="the fee_lowyear of the record" type="numeric" required="no" default= 0 /> 
		<cfargument name="fee_highyear" hint="the fee_highyear of the record" type="numeric" required="no" default= 0 /> 
		<cfargument name="fee_vpfactorlowyear" hint="the fee_vpfactorlowyear of the record" type="numeric" required="no" default=0 /> 
		<cfargument name="fee_vpfactorhighyear" hint="the fee_vpfactorhighyear of the record" type="numeric" required="no" default=0 /> 
		<cfargument name="fee_bursarfactorlowyear" hint="the fee_bursarfactorlowyear of the record" type="numeric" required="no" default=0 /> 
		<cfargument name="fee_bursarfactorhighyear" hint="the fee_bursarfactorhighyear of the record" type="numeric" required="no" default=0 /> 
		<cfargument name="fee_type" hint="the fee_type of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_setbycampusindicator" hint="the fee_setbycampusindicator of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_sortseq" hint="the fee_sortseq of the record" type="string" required="no" default="" /> 
		<cfargument name="categ" hint="the category of the record" type="string" required="no" default="" /> 
		<cfargument name="sort_key" hint="the sort_key of the record" type="string" required="no" default="" /> 
		<cfargument name="fee_current" hint="the fee_lowyear of the record" type="numeric" required="no" default= 0 /> 
		<cfargument name="approval_status" hint="P - pending, A - approved, D - disapproved" type="string" required="no" default="P">
		<cfargument name="fiscal_year" hint="the fiscal year of the record" type="numeric" required="no" default= 0 /> 
		<cfargument name="xfactor" hint="the eXternal display factor" type="numeric" required="no" default= 1 /> 
		<cfargument name="subm_ly" hint="submitted lowyear value" type="numeric" required="no" default= 0 /> 
		<cfargument name="subm_hy" hint="submitted highyear value" type="numeric" required="no" default= 0 /> 
		<cfargument name="feeid_subgrpcd" hint="sub-group code for a given fee_id" type="string" required="no" default= "" /> 
		<cfargument name="ratecap_pct" hint="rate cap percentage" type="numeric" required="no" /> 

		<cfscript> 
			setFee_ID(arguments.fee_id); 
			setFee_Masterid(arguments.fee_masterid); 
			setFee_Inst(arguments.fee_inst);
			setFee_Residency(arguments.fee_residency);
			setFee_distance(arguments.fee_distance);
			setFee_descr(arguments.fee_descr);
			setFee_Lowyear(arguments.fee_lowyear);
			setFee_Highyear(arguments.fee_highyear);
			setFee_VPFactorlowyear(arguments.fee_vpfactorlowyear);
			setFee_VPFactorhighyear(arguments.fee_vpfactorhighyear);
			setFee_Bursarfactorlowyear(arguments.fee_bursarfactorlowyear);
			setFee_Bursarfactorhighyear(arguments.fee_bursarfactorhighyear);
			setFee_Type(arguments.fee_type);
			setFee_Setbycampusindicator(arguments.fee_setbycampusindicator);
			setfee_Sortseq(arguments.fee_sortseq);
			setCateg(arguments.categ);
			setSort_Key(arguments.sort_key);
			setFee_Current(arguments.fee_current);
			setApproval_status(arguments.approval_status);
			setFiscal_Year(arguments.fiscal_year);
			setXfactor(arguments.xfactor);
			setSubm_ly(arguments.subm_ly);
			setSubm_hy(arguments.subm_hy);
			setFeeid_subgrpcd(arguments.feeid_subgrpcd);
			setRatecap_pct(arguments.ratecap_pct);
			return this; 
		</cfscript> 
	</cffunction>
</cfcomponent>