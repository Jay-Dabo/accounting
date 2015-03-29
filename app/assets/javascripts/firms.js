$(document).ready(function(){
  // Hide div
  $("#trading-help").css("display","none");
  $("#service-help").css("display","none");
  $("#manufacture-help").css("display","none");

  // Add onclick handler to radio 
  $("#trading").click(function(){
    if ($("#trading").is(":checked")) {
      // Show the hidden div
      $("#trading-help").show("fast");
      $("#service-help").hide("fast");
      $("#manufacture-help").hide("fast");
    }
    else {
      // Otherwise, hide it
      $("#trading-help").hide("fast");
    }
  });

  $("#service").click(function(){
    if ($("#service").is(":checked")) {
      // Show the hidden div
      $("#service-help").show("fast");
      $("#trading-help").hide("fast");
      $("#manufacture-help").hide("fast");
    }
    else {
      // Otherwise, hide it
      $("#service-help").hide("fast");
    }
  });

  $("#manufacture").click(function(){
    if ($("#manufacture").is(":checked")) {
      // Show the hidden div
      $("#manufacture-help").show("fast");
      $("#trading-help").hide("fast");
      $("#service-help").hide("fast");
    }
    else {
      // Otherwise, hide it
      $("#manufacture-help").hide("fast");
    }
  });    
});

