json.array!(@event_related_links) do |event_related_link|
  json.extract! event_related_link, :id
  json.url event_related_link_url(event_related_link, format: :json)
end
