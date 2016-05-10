# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new
user.email = 'test@example.com'
user.username = 'admin'
user.password = 'password'
user.password_confirmation = 'password'
user.admin = true
user.save!
Student.create(first_name: 'Mark', last_name: 'Torres', mobile_phone: '123-456-7890')
Student.create(first_name: 'John', last_name: 'Hogan', mobile_phone: '567-890-1234')
Student.create(first_name: 'Selena', last_name: 'Lopez', mobile_phone: '456-789-0123')
Student.create(first_name: 'Julia', last_name: 'Martin', mobile_phone: '345-678-9012')
Student.create(first_name: 'Francisco', last_name: 'Samantha', mobile_phone: '234-5678-9012')
Organization.create(name: 'ACME Health Care', billing_address: '123 Main Street', city: 'Boston', state: 'MA', zip: '01742', sponsor_since: '01-jan-2011', sugarcrm_id: 'ABC')
Organization.create(name: 'Black Duck Software', billing_address: '123 Main Street', city: 'Burlington', state: 'MA', zip: '01803', sponsor_since: '01-jan-2012', sugarcrm_id: 'DEF')
Organization.create(name: 'Cartera Commerce, Inc.', billing_address: '1 Cranberry Hill', city: 'Lexington', state: 'MA', zip: '02421', sponsor_since: '01-jan-2013', sugarcrm_id: 'GHI')
Organization.create(name: 'Aptus Health', billing_address: '55 Walkers Brook Drive', city: 'Reading', state: 'MA', zip: '01867', sponsor_since: '01-jan-2013', sugarcrm_id: 'JKL')
Organization.create(name: 'AutoUse Deluca', billing_address: '100 Brickstone Sq.', city: 'Andover', state: 'MA', zip: '01810', sponsor_since: '01-jan-2013', sugarcrm_id: 'JKL')
Contact.create(salutation: 'Ms.', first_name: 'Nancy', last_name: 'Parker', title: 'Chief Medical Officer', department: 'Medical Devices', email: 'nparker@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 1)
Contact.create(salutation: 'Mr.', first_name: 'Can', last_name: 'Keskin', title: 'Senior Engineer', department: 'Engineering', email: 'ckeskin@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 2)
Contact.create(salutation: 'Mrs.', first_name: 'Diana', last_name: 'Noe', title: 'Staff Accountant', department: 'Accounting Department', email: 'dnoe@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 2)
Contact.create(salutation: 'Mr.', first_name: 'Steve', last_name: 'Tamaro', title: 'Accounting Manager', department: 'Accounting Department', email: 'stammaro@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 3)
Contact.create(salutation: 'Mr.', first_name: 'Jim', last_name: 'Speredelozzi', title: 'Senior Director of Global Inside Sales', department: 'Sales Department', email: 'jim@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'ABC', organization_id: 3)
Contact.create(salutation: 'Miss', first_name: 'Cathy', last_name: 'Counsell', title: 'Executive Director, Gain Share Operational Strategy', department: 'Account Management', email: 'cathy@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'XYZ', organization_id: 4)
Contact.create(salutation: 'Ms.', first_name: 'Lisa', last_name: 'Candelario', title: 'Supervisor', department: 'Human Resources', email: 'lisa@example.com', mobile: '123-456-7890', office_phone: '123-456-7890', fax: '123-456-78890', start_date: '01-jan-2012', sugarcrm_id: 'LRM', organization_id: 5)
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: false, work_day: 'Friday', student_gradelevel: 10, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_id: 1)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Thursday', student_gradelevel: 11, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_id: 1)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Thursday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 2, contact_id: 2)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Tuesday', student_gradelevel: 12, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 3, contact_id: 3)
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: false, work_day: 'Tuesday', student_gradelevel: 9, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 4, contact_id: 4)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Tuesday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 4, contact_id: 4)
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: true, work_day: 'Monday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 5, contact_id: 5)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: true, work_day: 'Monday', student_gradelevel: 11, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 5, contact_id: 5)
Van.create(name: 'Van 1', plate_number: '123456', vin: 'ABCDEFGHIJKLMNOP', make: 'CHEVY', model_year: '2012', last_oil_change: '38,000 mi', capacity: 6)
Van.create(name: 'Van 2', plate_number: '234567', vin: 'BCDEFGHIJKLMNOPQ', make: 'FORD', model_year: '2012', last_oil_change: '31,000 mi', capacity: 5)
Van.create(name: 'Van 3', plate_number: '345678', vin: 'CDEFGHIJKLMNOPQR', make: 'FORD', model_year: '2011', last_oil_change: '45,000 mi', capacity: 4)
Van.create(name: 'Van 4', plate_number: '456789', vin: 'DEFGHIJKLMNOPQRS', make: 'FORD', model_year: '2013', last_oil_change: '22,000 mi', capacity: 5)
Van.create(name: 'Van 5', plate_number: '567890', vin: 'EFGHIJKLMNOPQRST', make: 'FORD', model_year: '2012', last_oil_change: '34,000 mi', capacity: 6)
Driver.create(name:'Cesar')
Driver.create(name:'Tomas')
Driver.create(name:'John')
Driver.create(name:'Jane')
Driver.create(name:'Emily')
VanRoute.create(name: 'Route 1', route_date: '12-feb-2016', am_pm: 'AM', van_id: 1, driver_id: 1)
VanRoute.create(name: 'Route 2', route_date: '12-feb-2016', am_pm: 'AM', van_id: 2, driver_id: 2)
VanRoute.create(name: 'Route 3', route_date: '12-feb-2016', am_pm: 'AM', van_id: 3, driver_id: 3)
VanRoute.create(name: 'Route 1', route_date: '12-feb-2016', am_pm: 'PM', van_id: 1, driver_id: 1)
VanRoute.create(name: 'Route 2', route_date: '12-feb-2016', am_pm: 'PM', van_id: 2, driver_id: 2)
VanRoute.create(name: 'Route 3', route_date: '12-feb-2016', am_pm: 'PM', van_id: 3, driver_id: 3)
RouteStop.create(stop_order:'A', van_route_id: 1, placement_id: 2)
RouteStop.create(stop_order:'B', van_route_id: 1, placement_id: 3)
RouteStop.create(stop_order:'C', van_route_id: 1, placement_id: 4)
RouteStop.create(stop_order:'D', van_route_id: 1, placement_id: 6)
RouteStop.create(stop_order:'E', van_route_id: 1, placement_id: 8)
Incident.create(incident_date:'01-may-2016', description: 'The student was 3 hours late.', student_id: 1, contact_id: 1)
Incident.create(incident_date:'01-may-2016', description: 'The student was chewing gum.', student_id: 2, contact_id: 2)
Incident.create(incident_date:'01-may-2016', description: 'The student was wearing a funny hat.', student_id: 2, contact_id: 2)