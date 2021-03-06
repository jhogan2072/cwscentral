class ContactAssignment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :contact
  has_many :incidents
  has_many :placements
  before_save :get_address_from_organization
  validates :organization_id, presence: true
  validates :title, presence: true
  validates :effective_start_date, presence: true
  validate :placements_outside_dates

  WEEKDAYS = {'MONDAY' => 1, 'TUESDAY' => 2, 'WEDNESDAY' => 4, 'THURSDAY' => 8, 'FRIDAY' => 16, 'SATURDAY' => 32, 'SUNDAY' => 64}

  # setter
  def cc_days=(value_array)
    days_value = 0
    value_array.each do |day_value|
      days_value += day_value.to_i
    end
    write_attribute(:cc_days, days_value)
  end

  # getter
  def cc_days
    get_day_array(self[:cc_days].nil? ? 0 : self[:cc_days])
  end

  def organization_name
    self.organization.name
  end

  def contact_name
    self.contact.name
  end

  def current_assignment
    if self.contact and self.organization
      self.contact.name + ' - ' + self.organization.name
    end
  end

  def self.with_contact
    self.joins(:contact).includes(:contact)
  end

  def self.for_student(student_id)
    self.joins(:placements).where('placements.student_id = ?', student_id)
  end

  def self.for_start_date(start_date)
    self.joins(:organization).joins(:contact)
        .includes(:organization).includes(:contact).where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", start_date.nil? ? DateTime.now.to_date : start_date).order("contacts.last_name")
  end

  def self.for_organization(organization_id)
    if organization_id
      self.where('organization_id = ?', organization_id)
    else
      self.joins(:organization).joins(:contact)
                .includes(:organization).includes(:contact).where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now.to_date)
    end
  end

  def self.for_org_and_start_date(organization_id, start_date)
    self.joins(:organization).joins(:contact)
        .includes(:organization).includes(:contact)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date", start_date.nil? ? DateTime.now.to_date : start_date)
        .where("organization_id = ?", organization_id)
        .order("contacts.last_name")
  end

private
  def get_day_array(value)
    retval = []
    retval << WEEKDAYS['MONDAY'] if value & WEEKDAYS['MONDAY'] != 0
    retval << WEEKDAYS['TUESDAY'] if value & WEEKDAYS['TUESDAY'] != 0
    retval << WEEKDAYS['WEDNESDAY'] if value & WEEKDAYS['WEDNESDAY'] != 0
    retval << WEEKDAYS['THURSDAY'] if value & WEEKDAYS['THURSDAY'] != 0
    retval << WEEKDAYS['FRIDAY'] if value & WEEKDAYS['FRIDAY'] != 0
    retval << WEEKDAYS['SATURDAY'] if value & WEEKDAYS['SATURDAY'] != 0
    retval << WEEKDAYS['SUNDAY'] if value & WEEKDAYS['SUNDAY'] != 0
    return retval
  end

  def placements_outside_dates
    if Placement.where("contact_assignment_id = ? and end_date > ?", id, effective_end_date).any?
      errors.add(:effective_end_date, "is before the end date for at least one work assignment.  Please correct these assignments by searching for this contact on the " +
          "Placements by Contact screen.")
    end
  end

  def get_address_from_organization
    if self.address.nil?
      org = Organization.find(self.organization_id)
      self.address = org.billing_address
      self.city = org.city if not org.city.nil?
      self.state = org.state if not org.state.nil?
      self.zip = org.zip if not org.zip.nil?
    end
  end

end