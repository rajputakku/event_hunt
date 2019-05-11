  window.location.reload();
  <% if !@unread_notifications_creator.blank? %>
  <% publish_to @channel1 do %>
$(".ncount").html('<%= @unread_notifications_creator.count %>')
$(".ncount").addClass('count_design');
<% end %>
<% end %>
<% if !@unread_notifications_organizer.blank? %>
<% publish_to @channel2 do %>
$(".ncount").html('<%= @unread_notifications_organizer.count %>')
$(".ncount").addClass('count_design');
<% end %>
<% end %>