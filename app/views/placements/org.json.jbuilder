json.array!(@placement_array) do |placement|
  json.extract! placement, :id, :earliest_start, :latest_start, :ideal_start, :contact_name, :title, :department, :billing_address, :city, :state, :zip, :sponsor_since, :personal_email, :personal_mobile, :office_phone, :fax
  json.url org_placement_url(placement, format: :json)
end
