json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :contact_id, :organization_id, :organization_name
  json.url work_student_url(assignment, format: :json)
end
