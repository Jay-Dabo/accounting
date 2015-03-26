$(document).ready(function(){
  // Hide div
  $(".help").css("display","none");
  $('.main-container').hover(function(){
      $('.techinfo').fadeIn(500)
  },function(){
      $('.techinfo').fadeOut(500)
  })
});
  // Add onclick handler to checkbox w/ class 'toggle_capital-details'
  // $("#toggle_capital-details").click(function(){
  //   if ($("#toggle_capital-details").is(":checked")) {
  //     // Show the hidden div
  //     $("#capital-details").show("fast");
  //     $("#loan-details").hide("fast");
  //   }
  //   else {
  //     // Otherwise, hide it
  //     $("#capital-details").hide("fast");
  //   }
  // });

  // $("#toggle_loan-details").click(function(){
  //   if ($("#toggle_loan-details").is(":checked")) {
  //     // Show the hidden div
  //     $("#loan-details").show("fast");
  //     $("#capital-details").hide("fast");
  //   }
  //   else {
  //     // Otherwise, hide it
  //     $("#loan-details").hide("fast");
  //   }
  // });  
// });