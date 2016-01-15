# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = User.new
# user.email = 'test@example.com'
# user.username = 'admin'
# user.password = 'password'
# user.password_confirmation = 'password'
# user.admin = true
# user.save!
Student.create(first_name: 'Mark', last_name: 'Torres')
Student.create(first_name: 'John', last_name: 'Hogan')
Student.create(first_name: 'Selena', last_name: 'Lopez')
Organization.create(name: 'ACME Health Care', billing_address: '123 Main Street', city: 'Boston', state: 'MA', zip: '01742', sponsor_since: '01-jan-2011', sugarcrm_id: 'ABC')
Contact.create(name: 'Nancy Parker', title: 'Chief Medical Officer', department: 'Medical Devices', email: 'nparker@example.com', mobile: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 1)
WorkAssignment.create(start_date: '01-sep-2015', paid: false, work_day: 'Thursday', student_gradelevel: 10, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_id: 1)
