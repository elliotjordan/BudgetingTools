//UBO Project Management functions 
function toggleNewForm(id){
	//console.log("HI ELLIOT");
  var e = document.getElementById(id);
    if (e.style.display == 'block')
    	e.style.display = 'none';
    else
    	e.style.display = 'block';
    	console.log(e.id);
   $('.pm_submitBtn').hide();      
};
    
function submitNewProject() {
  $('.pm_submitBtn').show();	
}

function addRow(e) {
	//add a copy of each selection box to the span containing them
	$('#team_member').clone().appendTo('#addMember');
	$('#team_role').clone().appendTo('#addMember');
	$('#plusSign').clone().appendTo('#addMember');
	$('#minusSign').clone().appendTo('#addMember');
}

function removeBottomRow(e) {
	//add a copy of each selection box to the span containing them
	$('#team_member').last().remove();
	$('#team_role').last().remove();
	$('#plusSign').last().remove();
	$('#minusSign').last().remove();
}

function deleteRow(tableID) {
	try {
		var table = document.getElementById(tableID);
		var rowCount = table.rows.length;
		for(var i=0; i<rowCount; i++) {
			var row = table.rows[i];
			var chkbox = row.cells[0].childNodes[0];
			if(null != chkbox && true == chkbox.checked) {
				if(rowCount <= 1) {
					alert("Cannot delete all the rows.");
					break;
				}
				table.deleteRow(i);
				rowCount--;
				i--;
			}
		}
	}catch(e) {
		alert(e);
	}
}