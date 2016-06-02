json.array!(@incidents) do |incident|
  json.extract! incident, :id, :incident_date, :category, :contact_name, :organization_name
  json.url incidents_contact_url(incident, format: :json)
end
