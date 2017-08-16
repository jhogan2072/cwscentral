json.array!(@students) do |student|
  json.extract! student, :id, :first_name, :last_name, :classof, :active
  json.url graduate_students_url(student, format: :json)
end