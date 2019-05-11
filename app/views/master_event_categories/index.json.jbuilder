json.array!(@master_event_categories) do |master_event_category|
  json.extract! master_event_category, :id
  json.url master_event_category_url(master_event_category, format: :json)
end
