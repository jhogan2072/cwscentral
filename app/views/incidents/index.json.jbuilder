json.array!(@incidents) do |incident|
  json.extract! incident, :id, :incident_date, :description, :student_id, :contact_id
  json.url incident_url(incident, format: :json)
end
