class Organization < ActiveRecord::Base
  has_many :contact_assignments, dependent: :destroy
  has_many :contacts, through: :contact_assignments
  has_many :route_stops

  def self.current_organizations(effective_date)
    joins(:contact_assignments)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date",
               effective_date.nil? ? DateTime.now : effective_date).distinct.order("organizations.name")
  end
  def self.current_placements(effective_date)
    where("start_date <= ? and end_date >= ?", effective_date, effective_date)
  end
  def name_and_address
    name + " (" + billing_address + ", " + city + ", " + state + ")"
  end
end
