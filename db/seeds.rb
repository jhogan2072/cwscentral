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
#Student.create(first_name: 'Mark', last_name: 'Torres')
#Student.create(first_name: 'John', last_name: 'Hogan')
#Student.create(first_name: 'Selena', last_name: 'Lopez')
#Organization.create(name: 'ACME Health Care', billing_address: '123 Main Street', city: 'Boston', state: 'MA', zip: '01742', sponsor_since: '01-jan-2011', sugarcrm_id: 'ABC')
#Contact.create(name: 'Nancy Parker', title: 'Chief Medical Officer', department: 'Medical Devices', email: 'nparker@example.com', mobile: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 1)
#WorkAssignment.create(start_date: '01-sep-2015', paid: false, work_day: 'Thursday', student_gradelevel: 10, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_id: 1)
Van.create(name: 'Van 1', plate_number: '123456', vin: 'ABCDEFGHIJKLMNOP', make: 'CHEVY', model_year: '2012', last_oil_change: '38,000 mi')
Van.create(name: 'Van 2', plate_number: '234567', vin: 'BCDEFGHIJKLMNOPQ', make: 'FORD', model_year: '2012', last_oil_change: '31,000 mi')
Van.create(name: 'Van 3', plate_number: '345678', vin: 'CDEFGHIJKLMNOPQR', make: 'FORD', model_year: '2011', last_oil_change: '45,000 mi')
Van.create(name: 'Van 4', plate_number: '456789', vin: 'DEFGHIJKLMNOPQRS', make: 'FORD', model_year: '2013', last_oil_change: '22,000 mi')
Van.create(name: 'Van 5', plate_number: '567890', vin: 'EFGHIJKLMNOPQRST', make: 'FORD', model_year: '2012', last_oil_change: '34,000 mi')
Driver.create(name:'Cesar')
Driver.create(name:'Tomas')
Driver.create(name:'John')
Driver.create(name:'Jane')
Driver.create(name:'Emily')
VanRoute.create(name: 'Route 1', route_date: '12-jan-2016', am_pm: 'AM', van_id: 1, driver_id: 1, :students => Student.where(:last_name => 'Torres'))
RouteStop.create(stop_order:'A', van_route_id: 1, organization_id: 1)
