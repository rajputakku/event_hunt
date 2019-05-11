$(".pending_events_div").html('<%= raw escape_javascript(render partial:"/admin_profiles/admin_pending_events_table", collection:@pending_events )%>');

$(".delete_it").empty();
$(".delete_it").html('<script>
       var TablesDatatables = function() {
    return {
      init: function() {
        /* Initialize Bootstrap Datatables Integration */
        App.datatables();
            
        //  $.extend( $.fn.dataTable.defaults, {
        //     "ordering": 6
        // } );
        /* Initialize Datatables */
        $("#example-datatable").dataTable({
          "aoColumnDefs": [ { "bSortable": false, "aTargets": [0,1,2,3,4,5,7] } ],
          "iDisplayLength": 10,
          
          "aLengthMenu": [[10, 20, 30, -1], [10, 20, 30, "All"]]
        });
        $("#example-datatable2").dataTable({
          "aoColumnDefs": [ { "bSortable": false, "aTargets": [1] } ],
          "iDisplayLength": 10,
          "order":[[ 0, "asc" ]],
          "aLengthMenu": [[10, 20, 30, -1], [10, 20, 30, "All"]]
        });
$("#example-datatable3").dataTable({
  "aoColumnDefs": [ { "bSortable": false, "aTargets": [1,2,3,4,5,6,7] } ],
          "iDisplayLength": 10,
          "order":[[ 0, "asc" ]],
          "aLengthMenu": [[10, 20, 30, -1], [10, 20, 30, "All"]]
        });
        /* Add placeholder attribute to the search input */
        $(".dataTables_filter input").attr("placeholder", "Search");
      }
    };
  }();

  $(function(){ TablesDatatables.init(); });

     $(".link_organizer").on("click",function(){
    $(".link_organizer").popover({trigger: "manual"})
    var id= $(this).attr("event_id");
    $.ajax({
      type: "get",
      url: "event/organizer_popup",
      data: {id: id} 
    });
    //$(this).popover("show");
    return false;
      });
     </script>');

$("#cover").fadeOut(1000);

