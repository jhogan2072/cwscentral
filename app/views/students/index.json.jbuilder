json.array!(@students) do |student|
  json.extract! student, :id, :full_name, :powerschool_id
  json.url student_url(student, format: :json)
end
