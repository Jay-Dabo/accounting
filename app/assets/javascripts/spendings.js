$(document).ready(function(){
  // Hide div
  $("#acc-payables").css("display","none");

  // Add onclick handler to checkbox w/ class 'toggle_acc-payables'
  $("#toggle_payables").click(function(){
    if ($("#toggle_payables").is(":checked")) {
      // Show the hidden div
      $("#acc-payables").show("fast");
    }
    else {
      // Otherwise, hide it
      $("#acc-payables").hide("fast");
    }
  });
});