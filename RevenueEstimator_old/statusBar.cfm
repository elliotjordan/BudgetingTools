<!--- 
	file:	statusBar.cfm
	author:	John Burgoon jburgoon
	ver.:	v1
	date:	9-12-17
	update:	9-26-17
	note:	This cfm is the revenue status bar for our revenue estimator tool.
 --->
 <cfoutput >
	<div class="statusBar">
		<div class="statusBinTFL">
			<h3>Prior Year Actual Revenue:  <span id="campTarget">#DollarFormat(currentTarget.RC_TARGET)#</span></h3>
		</div>  <!-- End of div statusBinTFL -->	

		<div class="statusBinTCL">
			<h3>Current Total Campus Projected<br>Credit Hours: <span id="crhrGrand">#NumberFormat(0,'999,999.9')#</span></h3>
		</div>  <!-- End of div statusBinTCL -->
        
        <div class="statusBinTCR">
			<h3>Current Total<br>Estimated Revenue YR1: <span id="campGrandYr1">#DollarFormat("0")#</span></h3>
		</div>	<!-- End of div statusBinTCR -->
		
       
		<div class="statusBinTFR">
			<h3>Current Total<br>Estimated Revenue YR2: <span id="campGrandYr2">#DollarFormat("0")#</span></h3>
		</div>	<!-- End of div statusBinTFR -->	
	
	</div>  <!-- End of div statusBar -->
 </cfoutput>