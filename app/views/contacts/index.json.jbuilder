json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :title, :role, :date_started, :date_departed, :address, :city, :state, :zip,
                :email, :mobile, :office_phone, :fax, :organization_name, :notes
  json.url contact_url(contact, format: :json)
end
