class Contact < ActiveRecord::Base
  has_many :contact_assignments, :dependent => :destroy
  accepts_nested_attributes_for :contact_assignments, :allow_destroy => true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.active_contacts
    joins(:contact_assignments)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date", DateTime.now.to_date)
        .includes(:contact_assignments).order(:last_name, :first_name)
  end

  def current_assignment_id
    contact_assignment = self.contact_assignments.where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now.to_date)
    contact_assignment.first.nil? ? -1 : contact_assignment.first.id
  end

  def self.display_active
    joins("LEFT JOIN contact_assignments ON contacts.id = contact_assignments.contact_id LEFT JOIN organizations
          ON organizations.id = contact_assignments.organization_id").includes(contact_assignments: :organization)
        .where("contact_assignments.effective_end_date = '9999-12-31'")
        .order("contact_assignments.organization_id, contacts.last_name, contact_assignments.effective_end_date desc")
  end

  def self.display_all
    joins("LEFT JOIN contact_assignments ON contacts.id = contact_assignments.contact_id LEFT JOIN organizations
          ON organizations.id = contact_assignments.organization_id").includes(contact_assignments: :organization)
        .order("contact_assignments.organization_id, contacts.last_name, contact_assignments.effective_end_date desc")
  end

  def self.get_assignment_info
    joins(contact_assignments: :organization).includes(contact_assignments: :organization)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date",
        DateTime.now).order("contact_assignments.organization_id, contacts.last_name")
  end

  def name
    if self.first_name.nil?
      self.last_name.nil? ? '' : self.last_name
    else
      self.last_name.nil? ? self.first_name : self.first_name + ' ' + self.last_name
    end
  end

  def name_with_id
    full_name = ''
    if self.first_name.nil?
      full_name = self.last_name.nil? ? '' : self.last_name
    else
      full_name = self.last_name.nil? ? self.first_name : self.first_name + ' ' + self.last_name
    end
    full_name += ' (' + id.to_s + ')'
  end

  def organization_name
    contact_assignment = self.contact_assignments.where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now.to_date)
    contact_assignment.first.organization.name
  end

  def self.merge_contacts(contact_1_id, contact_2_id)
    contact1 = find(contact_1_id)
    contact2 = find(contact_2_id)
    if contact1.nil? || contact2.nil?
      raise Exception.new('One or both of the contacts were not recognized')
    end

    begin
      contact2.contact_assignments.each do |ca|
        new_ca = contact1.contact_assignments.new(ca.attributes)
        ca.placements.each do |placement|
          new_ca.placements.new(placement.attributes)
          placement.delete
        end
        ca.delete
        new_ca.save
      end
      contact2.delete
    rescue => e
      raise Exception.new("#{e.message}")
    end
  end

  def self.query_contacts(days_of_week, roles, organizations)
    where_clause = days_of_week.empty? ? '' : "placements.work_day in (" + days_of_week.map {|str| "'#{str}'"}.join(',') + ")" +
    (roles.empty? ? '' : " and contact_assignments.role in (" + roles.map {|str| "'#{str}'"}.join(',') + ")") +
    (organizations.empty? ? '' : " and organizations.id in (" + organizations.map {|str| "#{str}"}.join(',') + ")")

    joins(contact_assignments: :organization).joins(contact_assignments: :placements)
        .includes(contact_assignments: :organization)
        .where("? between placements.start_date and placements.end_date",
               DateTime.now).order("contact_assignments.organization_id, contacts.last_name")
        .where(where_clause)
  end

  def self.query_cc(days_of_week, organizations)
    where_string = ''
    days_of_week.each do |day|
      where_string = "coalesce(contact_assignments.cc_days,0) & " + ContactAssignment::WEEKDAYS[day.upcase].to_s + " >0 or "
    end
    where_string = where_string.chomp(' or ')
    where_clause = where_string +  (organizations.empty? ? '' : " and organizations.id in (" + organizations.map {|str| "#{str}"}.join(',') + ")")

    joins(contact_assignments: :organization)
        .includes(contact_assignments: :organization)
        .where(where_clause).order("contact_assignments.organization_id, contacts.last_name")
  end

  def self.mailing_list(days_of_week, roles, organizations)
    if self.query_contacts(days_of_week, roles, organizations).length >0
      (self.query_contacts(days_of_week, roles, organizations) + self.query_cc(days_of_week, organizations))
    else
      self.query_cc(days_of_week, organizations)
    end
  end

end
