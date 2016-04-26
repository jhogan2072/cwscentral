json.array!(@placements) do |placement|
  json.extract! placement, :id, :start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :contact_id, :student_id, :student_name, :contact_name
  json.url work_student_url(placement, format: :json)
end
