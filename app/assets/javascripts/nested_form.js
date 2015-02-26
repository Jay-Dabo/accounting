$(document).ready(function() {
    $('#owner')
      .on('cocoon:before-insert', function() {
        $("#owner_from_list").hide();
        $("#owner a.add_fields").hide();
      })
      .on('cocoon:after-insert', function() {
        /* ... do something ... */
      })
      .on("cocoon:before-remove", function() {
        $("#owner_from_list").show();
        $("#owner a.add_fields").show();
      })
      .on("cocoon:after-remove", function() {
        /* e.g. recalculate order of child items */
      });

    // example showing manipulating the inserted/removed item

    $('#tasks')
      .on('cocoon:before-insert', function(e,task_to_be_added) {
        task_to_be_added.fadeIn('slow');
      })
      .on('cocoon:after-insert', function(e, added_task) {
        // e.g. set the background of inserted task
        added_task.css("background","red");
      })
      .on('cocoon:before-remove', function(e, task) {
        // allow some time for the animation to complete
        $(this).data('remove-timeout', 1000);
        task.fadeOut('slow');
      });
});
