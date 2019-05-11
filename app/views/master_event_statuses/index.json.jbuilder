json.array!(@master_event_statuses) do |master_event_status|
  json.extract! master_event_status, :id
  json.url master_event_status_url(master_event_status, format: :json)
end
