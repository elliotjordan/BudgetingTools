<!--- 
	file:	datamap.cfm
	author:	John Burgoon jburgoon
	ver.:	v1
	date:	9-8-17
	update:	
	note:	This cfm is the main page of our database mapping tool.
 --->
 <cfoutput>
	<div class="full_content">
		<span class="help"><a href="help.cfm">Help</a></span>
		<h2>Data Mapping Tool</h2>
		<p>This tool is intended to assist analysts and developers in finding and understanding specific data fields in the IU system.  It may end up being simple embedding of some of the data cookbook features we find.</p>
		
		<p>
			<!--- TODO: these should probably be dropdowns in context of the user who is logged in --->
			<label for="schSearch">Schema Search</label><input type="text" alt="Search by schema name" id="schSearch" name="search">
			<label for="tabSearch">Table Search</label><input type="text" alt="Search by table name" id="tabSearch" name="search">
			<label for="colSearch">Column Search</label><input type="text" alt="Search by column name" id="colSearch" name="search">
			<label for="valSearch">Value Search</label><input type="text" alt="Search by data value" id="valSearch" name="search">
		</p>
		
		<table class="datamapTable">
			<tr>
				<!--- NOTE: Actual size of the database icon is 300x318 --->
				<th>DSS_KFS</th>
				<th>DSS_KFS</th>
				<th>DSS_KFS</th>
				<th>DSS_KFS</th>
				<th>DSS_RDS</th>
				<th>DSS_RDS</th>
			</tr>
			<tr>
				<td>
					<img id="class_tbl_gl" src="images/database.jpg" alt="Database icon" height="75" width="80" >
					<label class="sm-blue" for="class_tbl_gl">class_tbl_gl</label>
				</td>
				<td>
					<img id="crse_offer_gl" src="images/database.jpg" alt="Database icon" height="75" width="80">
					<label class="sm-blue" for="crse_offer_gl">crse_offer_gl</label>
				</td>
				<td>
					<a href="db_details.cfm?table=FEE_CODES">
						<img id="FEE_CODES" src="images/database.jpg" alt="Database icon" height="75" width="80">
						<label class="sm-blue" for="FEE_CODES">FEE_CODES</label>
					</a>
				</td>
				<td>
					<img id="SF_GL_" src="images/database.jpg" alt="Database icon" height="75" width="80">
					<label class="sm-blue" for="GL_intereface">GL_interface</label>
				</td>
				<td>
					<img id="IR_CEN_CRS_SNPSHT_GT" src="images/database.jpg" alt="Database icon" height="75" width="80">
					<label class="sm-blue" for="IR_CEN_CRS_SNPSHT_GT">IR_CEN_CRS_SNPSHT_GT</label>
				</td>
				<td>
					<img name="IR_CEN_TRM_SNPSHT_GT" src="images/database.jpg" alt="Database icon" height="75" width="80">
					<label class="sm-blue" for="IR_CEN_TRM_SNPSHT_GT">IR_CEN_TRM_SNPSHT_GT</label>
				</td>
			</tr>
			<tr>
				<td>Metadata here</td>
				<td>Metadata here</td>
				<td>Metadata here</td>
				<td>Metadata here</td>
				<td>Metadata here</td>
				<td>Metadata here</td>
			</tr>
		</table>
	</div>  <!-- End div class "content" -->
</cfoutput>
