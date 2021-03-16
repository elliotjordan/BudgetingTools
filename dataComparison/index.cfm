<!doctype html>
<head>
	<title>UBO Data Comparison - It's a drag</title>
	<meta charset='utf-8'>
	<link href='css/dragula.css' rel='stylesheet' type='text/css' />
	<link href='css/example.css' rel='stylesheet' type='text/css' />
</head>

<cfinclude template="includes/rules_functions.cfm" />
<cfset dsList = fetchDatasources() />

<cfoutput>
<body>
	<h2>UBO Data Comparison Tool</h2>
	<div class="navbar"><a href="rules.cfm">Rules</a> <a href="datasources.cfm">Data Sources</a> </div>
	
	<div class='examples'>
	    <div class='parent'>
	    	<div class='wrapper'>
		    	<label for='hy'>Move your choice into one of the containers.</label>
		    	<div id='top-defaults' class='container2'>
		    		<cfloop query="dsList">
		    			<div>#ds_nm#</div>
		    		</cfloop>
		    	</div>
	    	</div>
	    </div>
	    
      	<div class="parent">
	    	<div class="wrapper">
		    	<div id='left-defaults' class='container'>
		        	<div class="dataDivLeft"></div>
		      	</div>
		    	<div id='right-defaults' class='container'>
		        	<div class="dataDivRight"></div>
		      	</div>
	      	</div>
      	</div>

	    <div class='parent'>
	      <label><strong>Click or Drag!</strong> Fires a click when the mouse button is released before a <code>mousemove</code> event, otherwise a drag event is fired. No extra configuration is necessary.  Also, notice how you cannot drag to the upper example area, only within this one.</label>
	      <div class='wrapper'>
	        <div id='sortable' class='container'>
	          <div>Clicking on these elements triggers a regular <code>click</code> event you can listen to.</div>
	          <div>Try dragging or clicking on this element.</div>
	          <div>Note how you can click normally?</div>
	          <div>Drags don't trigger click events.</div>
	          <div>Clicks don't end up in a drag, either.</div>
	          <div>This is useful if you have elements that can be both clicked or dragged.</div>
	        </div>
	      </div>
	    </div>
	</div>  <!-- End div examples -->
	
	<script src='js/dragula.js'></script>
	<script src='js/example.min.js'></script> 
</body>
</cfoutput>