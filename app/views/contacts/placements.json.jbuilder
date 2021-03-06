json.array!(@placements) do |placement|
  json.extract! placement, :id, :start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :contact_id, :organization_id, :organization_name, :student_name, :notes
  json.url placements_contact_url(placement, format: :json)
end
