class Contact < ActiveRecord::Base
  has_many :placements
  has_many :incidents
  has_many :contact_assignments
  accepts_nested_attributes_for :contact_assignments

  def organization_name
    contact_assignment = self.contact_assignments.where("? between contact_assignments.effective_start_date and
contact_assignments.effective_end_date", DateTime.now)
    contact_assignment.first.organization.name
  end

  def name
    if self.first_name.nil? then
      self.last_name.nil? ? '' : self.last_name
    else
      self.last_name.nil? ? self.first_name : self.first_name + ' ' + self.last_name
    end
  end

end
