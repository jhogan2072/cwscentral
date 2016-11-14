class Contact < ActiveRecord::Base
  has_many :contact_assignments, :dependent => :destroy
  accepts_nested_attributes_for :contact_assignments, :allow_destroy => true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def organization_name
    contact_assignment = self.contact_assignments.where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now.to_date)
    contact_assignment.first.organization.name
  end

  def current_assignment_id
    contact_assignment = self.contact_assignments.where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now.to_date)
    contact_assignment.first.nil? ? -1 : contact_assignment.first.id
  end

  def self.display_active
    joins("LEFT JOIN contact_assignments ON contacts.id = contact_assignments.contact_id LEFT JOIN organizations
          ON organizations.id = contact_assignments.organization_id").includes(contact_assignments: :organization)
        .order("contact_assignments.organization_id, contacts.last_name")
  end

  def self.active_contacts
    joins(:contact_assignments)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date", DateTime.now.to_date)
        .includes(:contact_assignments).order(:last_name, :first_name)
  end

  def self.get_assignment_info
    joins(contact_assignments: :organization).includes(contact_assignments: :organization)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date",
        DateTime.now).order("contact_assignments.organization_id, contacts.last_name")
  end

  def name
    if self.first_name.nil? then
      self.last_name.nil? ? '' : self.last_name
    else
      self.last_name.nil? ? self.first_name : self.first_name + ' ' + self.last_name
    end
  end

end
