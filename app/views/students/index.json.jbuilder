json.array!(@students) do |student|
  json.extract! student, :id, :last_name, :first_name, :mobile_phone, :skills, :goals, :active
  json.url student_url(student, format: :json)
end
