json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :billing_address, :city, :state, :zip, :sponsor_since, :sugarcrm_id
  json.url organization_url(organization, format: :json)
end
