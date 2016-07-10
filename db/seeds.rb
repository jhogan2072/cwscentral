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
User.create(email: 'claire@example.com', username: 'chogan', password: 'password', admin: false)
User.create(email: 'mark@example.com', username: 'msmith', password: 'password', admin: false)
Student.create(first_name: 'Mark', last_name: 'Torres', mobile_phone: '123-456-7890', skills: 'bilingual, great typist',
               goals: 'Start a software company')
Student.create(first_name: 'John', last_name: 'Hogan', mobile_phone: '567-890-1234', skills: 'Reads braille',
               goals: 'Become a doctor')
Student.create(first_name: 'Selena', last_name: 'Lopez', mobile_phone: '456-789-0123', skills: 'Can drive a forklift',
               goals: 'Learn to code')
Student.create(first_name: 'Julia', last_name: 'Martin', mobile_phone: '345-678-9012', skills: 'Excellent communicator',
               goals: 'Open a restaurant')
Student.create(first_name: 'Francisco', last_name: 'Samantha', mobile_phone: '234-5678-9012',
               skills: 'Lab experience, knows cold room procedures', goals: 'Commercialize nuclear fusion')
Organization.create(name: 'ACME Health Care', billing_address: '123 Main Street', city: 'Boston', state: 'MA',
                    zip: '01742', sponsor_since: '01-jan-2011', sugarcrm_id: 'ABC')
Organization.create(name: 'Black Duck Software', billing_address: '123 Main Street', city: 'Burlington', state: 'MA',
                    zip: '01803', sponsor_since: '01-jan-2012', sugarcrm_id: 'DEF')
Organization.create(name: 'Cartera Commerce, Inc.', billing_address: '1 Cranberry Hill', city: 'Lexington', state: 'MA',
                    zip: '02421', sponsor_since: '01-jan-2013', sugarcrm_id: 'GHI')
Organization.create(name: 'Aptus Health', billing_address: '55 Walkers Brook Drive', city: 'Reading', state: 'MA',
                    zip: '01867', sponsor_since: '01-jan-2013', sugarcrm_id: 'JKL')
Organization.create(name: 'AutoUse Deluca', billing_address: '100 Brickstone Sq.', city: 'Andover', state: 'MA',
                    zip: '01810', sponsor_since: '01-jan-2013', sugarcrm_id: 'JKL')
Contact.create(salutation: 'Ms.', first_name: 'Nancy', last_name: 'Parker', email: 'nparker@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Chief Medical Officer', department: 'Medical Devices', office_phone: '123-456-7890',
                         fax: '123-456-78890', effective_start_date: '01-jan-2012', effective_end_date: '31-dec-9999', organization_id: 1, contact_id: 1,
                         role: 'CMO', notes: 'Nice manager', business_email: 'nancy@work.com')
Contact.create(salutation: 'Mr.', first_name: 'Can', last_name: 'Keskin', email: 'ckeskin@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Senior Engineer', department: 'Engineering', office_phone: '123-456-7890',
                         fax: '123-456-78890', effective_start_date: '01-jan-2012', effective_end_date: '31-dec-9999', organization_id: 2, contact_id: 2,
                         role: 'Engineer', notes: 'Excellent engineer and teacher', business_email: 'can@work.com')
Contact.create(salutation: 'Mrs.', first_name: 'Diana', last_name: 'Noe', email: 'dnoe@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Staff Accountant', department: 'Accounting Department', office_phone: '123-456-7890',
                         fax: '123-456-7880', effective_start_date: '01-jan-2012', effective_end_date: '31-dec-9999', organization_id: 3, contact_id: 3,
                         role: 'Accountant', notes: 'Interesting personality', business_email: 'diana@work.com')
Contact.create(salutation: 'Mr.', first_name: 'Steve', last_name: 'Tamaro', email: 'stammaro@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Accounting Manager', department: 'Accounting Department', office_phone: '123-456-7890',
                         fax: '123-456-7880', effective_start_date: '01-sep-2014', effective_end_date: '31-dec-9999', organization_id: 4, contact_id: 4,
                         role: 'Manager', notes: 'Very helpful', business_email: 'steve@work.com')
Contact.create(salutation: 'Mr.', first_name: 'Jim', last_name: 'Speredelozzi', email: 'jim@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Senior Director of Global Inside Sales', department: 'Sales Department',
                         office_phone: '123-456-7890', fax: '123-456-7880', effective_start_date: '01-sep-2013', effective_end_date: '31-dec-9999',
                         organization_id: 4, contact_id: 5, role: 'Sales', notes: 'Very helpful', business_email: 'jim@work.com')
Contact.create(salutation: 'Miss', first_name: 'Cathy', last_name: 'Counsell', email: 'cathy@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Executive Director, Gain Share Operational Strategy', department: 'Account Management',
                         office_phone: '123-456-7890', fax: '123-456-7880', effective_start_date: '01-jan-2012', effective_end_date: '31-dec-9999',
                         organization_id: 5, contact_id: 6, role: 'Sales', business_email: 'cathy@work.com',
                         notes: 'Does not want people working half days, wants people working full days.  And a half day is 12 hours.')
Contact.create(salutation: 'Ms.', first_name: 'Lisa', last_name: 'Candelario', email: 'lisa@example.com', mobile: '123-456-7890')
ContactAssignment.create(title: 'Floor Supervisor', department: 'Human Resources', business_email: 'lisa@work.com',
                         office_phone: '123-456-7890', fax: '123-456-7880', effective_start_date: '01-sep-2013', effective_end_date: '31-dec-9999',
                         organization_id: 5, contact_id: 7, role: 'HR Representative', notes: 'Tough negotiator')
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: false, work_day: 'Friday', student_gradelevel: 10, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_assignment_id: 1)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Thursday', student_gradelevel: 11, earliest_start: '8:00', latest_start: '9:00', ideal_start: '8:30', student_id: 1, contact_assignment_id: 1)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Thursday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 2, contact_assignment_id: 2)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Tuesday', student_gradelevel: 12, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 3, contact_assignment_id: 3)
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: false, work_day: 'Tuesday', student_gradelevel: 9, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 4, contact_assignment_id: 4)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: false, work_day: 'Tuesday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 4, contact_assignment_id: 4)
Placement.create(start_date: '01-sep-2014', end_date: '01-sep-2015', paid: true, work_day: 'Monday', student_gradelevel: 10, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 5, contact_assignment_id: 5)
Placement.create(start_date: '01-sep-2015', end_date: '01-sep-2016', paid: true, work_day: 'Monday', student_gradelevel: 11, earliest_start: '8:30', latest_start: '9:00', ideal_start: '8:30', student_id: 5, contact_assignment_id: 5)
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
VanRoute.create(name: 'Route 1', route_date: '15-jun-2016', am_pm: 'AM', check_in_time: "8:00 AM", van_id: 1, driver_id: 1)
VanRoute.create(name: 'Route 2', route_date: '15-jun-2016', am_pm: 'AM', check_in_time: "8:30 AM", van_id: 2, driver_id: 2)
VanRoute.create(name: 'Route 3', route_date: '15-jun-2016', am_pm: 'AM', check_in_time: "7:00 AM", van_id: 3, driver_id: 3)
VanRoute.create(name: 'Route 1', route_date: '15-jun-2016', am_pm: 'PM', check_in_time: "7:30 AM", van_id: 1, driver_id: 1)
VanRoute.create(name: 'Route 2', route_date: '15-jun-2016', am_pm: 'PM', van_id: 2, driver_id: 2)
VanRoute.create(name: 'Route 3', route_date: '15-jun-2016', am_pm: 'PM', van_id: 3, driver_id: 3)
RouteStop.create(stop_order:'A', van_route_id: 1, placement_id: 2)
RouteStop.create(stop_order:'B', van_route_id: 1, placement_id: 3)
RouteStop.create(stop_order:'C', van_route_id: 1, placement_id: 4)
RouteStop.create(stop_order:'D', van_route_id: 1, placement_id: 6)
RouteStop.create(stop_order:'E', van_route_id: 1, placement_id: 8)
IncidentCategory.create(category: 'Cell phone use')
IncidentCategory.create(category: 'Language')
IncidentCategory.create(category: 'Tardiness')
IncidentCategory.create(category: 'Inappropriate Dress')
IncidentCategory.create(category: 'Poor performance')
Incident.create(incident_date:'01-may-2016', description: 'The student was 3 hours late.', student_id: 1, contact_assignment_id: 1, incident_category_id: 3)
Incident.create(incident_date:'01-may-2016', description: 'The student was using their cell phone.', student_id: 2, contact_assignment_id: 2, incident_category_id: 1)
Incident.create(incident_date:'01-may-2016', description: 'The student was using in appropriate language.', student_id: 2, contact_assignment_id: 2, incident_category_id: 2)