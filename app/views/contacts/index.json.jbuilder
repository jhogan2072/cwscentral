json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :title, :email, :mobile, :office_phone, :fax, :organization_name
  json.url contact_url(contact, format: :json)
end
