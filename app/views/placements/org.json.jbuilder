json.array!(@placement_array) do |placement|
  json.extract! placement, :id, :earliest_start, :latest_start, :ideal_start, :contact_name, :title, :department,
                :contact_start_date, :contact_address, :contact_city, :contact_state, :contact_zip, :sponsor_since,
                :email, :mobile, :office_phone, :fax
  json.url org_placement_url(placement, format: :json)
end
