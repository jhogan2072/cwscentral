json.array!(@contacts) do |contact|
  json.extract! contact, :id, :last_name, :first_name
  json.set! :organization_name, contact.contact_assignments.first.organization.name
  json.set! :business_email, contact.contact_assignments.first.business_email
  json.set! :office_phone, contact.contact_assignments.first.office_phone
  json.set! :active_since, contact.contact_assignments.first.effective_start_date
  json.url contact_url(contact, format: :json)
end
