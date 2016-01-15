json.array!(@work_assignments) do |work_assignment|
  json.extract! work_assignment, :id, :start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :student_id, :contact_id
  json.url work_assignment_url(work_assignment, format: :json)
end
