class ContactAssignment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :contact
  has_many :incidents
  has_many :placements

  def organization_name
    self.organization.name
  end

  def current_assignment
    self.contact.name + ' - ' + self.organization.name
  end

  def self.for_student(student_id)
    self.joins(:placements).where('placements.student_id = ?', student_id)
  end

  def self.for_organization(organization_id)
    self.where('organization_id = ?', organization_id)
  end

end