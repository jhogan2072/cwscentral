class ContactAssignment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :contact
  has_many :incidents
  has_many :placements

  def organization_name
    self.organization.name
  end

  def current_assignment
    if self.contact and self.organization
      self.contact.name + ' - ' + self.organization.name
    end
  end

  def self.for_student(student_id)
    self.joins(:placements).where('placements.student_id = ?', student_id)
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

end