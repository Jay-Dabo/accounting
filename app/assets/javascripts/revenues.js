$(document).on("ready page:change", function()  {
  // Hide div
  $("#acc-receivables").css("display","none");

  // Add onclick handler to checkbox w/ class 'toggle_acc-payables'
  $("#toggle_receivables").click(function(){
    if ($("#toggle_receivables").is(":checked")) {
      // Show the hidden div
      $("#acc-receivables").show("fast");
    }
    else {
      // Otherwise, hide it
      $("#acc-receivables").hide("fast");
    }
  });
});