json.array!(@incident_categories) do |incident_category|
  json.extract! incident_category, :id, :category
  json.url incident_category_url(incident_category, format: :json)
end
