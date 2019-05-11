json.array!(@event_upvotes) do |event_upvote|
  json.extract! event_upvote, :id
  json.url event_upvote_url(event_upvote, format: :json)
end
