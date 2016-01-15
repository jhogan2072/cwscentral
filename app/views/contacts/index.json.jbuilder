json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :title, :address, :city, :state, :zip, :email, :mobile, :office_phone, :fax, :designations, :organization_id
  json.url contact_url(contact, format: :json)
end
