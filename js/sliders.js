  <script type="text/javascript">
    "use strict";
    var cps1 = document.getElementById("cpsChosen1");
    var cps2 = document.getElementById("cpsChosen2");
    var cps3 = document.getElementById("cpsChosen3");
    var cps4 = document.getElementById("cpsChosen4");
    var cps5 = document.getElementById("cpsChosen5");
    var eRm = 0;  //initializes to 0 - see calcElbowRoom() - TODO: This may need to be set to database value if we centralize the WhatIf scenarios
    var initAmt = Number(cps1.attributes.origValue.value) + Number(cps2.attributes.origValue.value) + Number(cps3.attributes.origValue.value) + Number(cps4.attributes.origValue.value) + Number(cps5.attributes.origValue.value);

    function init() {
      totalamount.innerHTML = initAmt;
      calcElbowRoom();
    }

    function updateRateCap(rate) {
      if ( (rate === undefined) || (rate === null) || isNaN(rate) || isNaN(parseInt(rate)) || (rate === '') ) {  
        // lol - first ya gotta do straight isNaN to catch fractions, and isNan(parseInt()) to catch spaces.  Ain't js a stinker?
	var capRateBox = document.getElementById("rateInput");
	rate = 0.00;
	capRateBox.value = rate.toFixed(2);
      }
      var maxElem = document.getElementById("maxDollars");
      var origValue = Number(maxElem.attributes.origValue.value);
      var calcMax = origValue * (1 + (Number(rate)/100));
      maxDollars.innerHTML = calcMax.toFixed(2);
      calcElbowRoom();
    }

    function calcElbowRoom(){
      var cap_rate = document.getElementById("rateInput");
      eRm = initAmt * (1 + Number(cap_rate.value)/100) - initAmt;
      elbowroom.innerHTML = eRm.toFixed(2);
      return eRm;
    }

    function calcUsedIncreasePool() {
      var currentUsed = calcCurrentAmt() - calcElbowRoom();
      return currentUsed;
    }

    function calcCurrentAmt() {
      var currentAmt = Number(cps1.attributes.adjValue.value) + Number(cps2.attributes.adjValue.value) + Number(cps3.attributes.adjValue.value) + Number(cps4.attributes.adjValue.value) + Number(cps5.attributes.adjValue.value);
      return currentAmt;
    }

    function calcTotalAdjustments() {}

    function updateCmpLinkedSliders(slideAmount, elemID, displayName, displayTotalName) {
      //handle changes to the compound linked sliders (hereafter denoted "cls")

      //get the elements currently selected
      var cls_elem = document.getElementById(elemID.id);
      var cls_display = document.getElementById(displayName);
      var cls_displayTotal = document.getElementById(displayTotalName);
      var currentMax = document.getElementById("maxDollars");
      var cap = Number(cap_rate.value).toFixed(6);

      //get the rate cap and dollar total, adjust total accordingly
      var initSliderAmt = Number(cls_elem.value);
      //var origValue = Number(cls_display.attributes.origValue.value);	

      //adjust the one we changed to a new value and set it
      var adjDollars = ((Number(cls_elem.value)/100) * Number(cls_display.attributes.origValue.value)).toFixed(2);
      var adjTotal = ((1 + Number(cls_elem.value)/100) * Number(cls_display.attributes.origValue.value)).toFixed(2);
      cls_display.attributes.adjValue.value = adjTotal;
      cls_display.innerHTML = "Adjustment $" + adjDollars + " (base + " + (Number(cls_elem.value)).toFixed(2) + "%)";
      cls_displayTotal.innerHTML = "Total $" + adjTotal + " (base + adjustment)"; 
	
      //update the displayed "Total Adjustments"
      var adjRunningTotal = calcUsedIncreasePool() - initAmt;
      totadj.innerHTML = adjRunningTotal.toFixed(2);

      //update the totalamount
      var finalAmt = Number(cps1.attributes.origValue.value) + Number(cps2.attributes.origValue.value) + Number(cps3.attributes.origValue.value) + Number(cps4.attributes.origValue.value) + Number(cps5.attributes.origValue.value);
      totalamount.value = finalAmt.toFixed(2);
    }
      //***** SIMPLE IMAGE SLIDER DEMO *****-->
    function updateSlider(slideAmount) {
      //get the element
      var display = document.getElementById("chosen");
      //show the amount
      display.innerHTML=slideAmount+"%";
      //get the element
      var pic = document.getElementById("pic");
      //set the dimensions
      pic.style.width=slideAmount+"%";
      pic.style.height=slideAmount+"%";
    }
    
      //***** SIMPLE LINKED SLIDER DEMO *****-->
    function updateLinkedSliders(slideAmount) {
      //get the elements
      var display1 = document.getElementById("chosen1");
      var display2 = document.getElementById("chosen2");
      //show the amount
      display1.innerHTML="THEM: $" + (200 - slideAmount);
      display2.innerHTML="US:<br /> $" + (slideAmount);
      //get the element
    }
  </script>