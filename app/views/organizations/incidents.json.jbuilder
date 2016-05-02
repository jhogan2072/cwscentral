json.array!(@incidents) do |incident|
  json.extract! incident, :id, :incident_date, :description, :student_name, :contact_name
  json.url incidents_contact_url(incident, format: :json)
end
