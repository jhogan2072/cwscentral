json.array!(@assignment_array) do |assignment|
  json.extract! assignment, :id, :earliest_start, :latest_start, :ideal_start, :contact_name, :title, :department, :billing_address, :city, :state, :zip, :sponsor_since, :email, :mobile, :office_phone, :fax
  json.url work_student_url(assignment, format: :json)
end
