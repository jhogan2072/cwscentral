json.array!(@incidents) do |incident|
  json.extract! incident, :id, :incident_date, :description, :student_name, :organization_name, :category
  json.url incidents_contact_url(incident, format: :json)
end
