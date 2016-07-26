json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name
  json.set! :organization_name, contact.contact_assignments.first.organization.name
  json.set! :business_email, contact.contact_assignments.first.business_email
  json.set! :office_phone, contact.contact_assignments.first.office_phone
  json.url contact_url(contact, format: :json)
end
