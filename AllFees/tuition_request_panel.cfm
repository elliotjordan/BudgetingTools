	<h3>Request Changes to Existing Fees</h3>
	<div id="nav-wrapper">
		<ul id="nav">
			<li>
			   	<form name="tuitionDownForm" action="tuition.cfm" method="post">
		   			<input id="tuition_down_btn" type="submit" name="SubmitTuitionDown" value="Download Rates" />
		   			<label for="excel_down_btn">Re-usable as submission template.</label>
		   		</form>    			
			</li>
			<li>
				<form name="tuitionUpForm" action="uploadAllFees.cfm"  method="post" enctype="multipart/form-data">
					<input type="submit" name="SubmitUp" value="Upload Excel" <cfif request.authUser neq 'jburgoon'>disabled="disabled"</cfif> >
					<input type="file" name="xlsfile" required <cfif request.authUser neq 'jburgoon'>disabled="disabled"</cfif> >
					<label for="headerLine">Header row:</label>
					<select name="headerLine">
						<option value="1">1</option> 
						<option value="2">2</option> 
						<option value="3" selected>3</option> 
						<option value="4">4</option> 
						<option value="5">5</option> 
					</select>
		   		</form>
		   	</li>
		</ul>
	</div>