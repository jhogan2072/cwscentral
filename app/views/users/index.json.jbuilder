json.array!(@users) do |user|
  json.extract! user, :id, :designations
  json.url user_url(user, format: :json)
end
