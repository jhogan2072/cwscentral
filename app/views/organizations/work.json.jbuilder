json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :contact_id, :student_id, :student_name, :contact_name
  json.url work_student_url(assignment, format: :json)
end
