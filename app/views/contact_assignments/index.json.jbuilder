json.array!(@contact_assignments) do |contact_assignment|
  json.extract! contact_assignment, :id, :contact_name, :effective_start_date, :effective_end_date
  json.url contact_assignment_url(contact_assignment, format: :json)
end
