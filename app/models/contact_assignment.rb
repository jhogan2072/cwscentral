class ContactAssignment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :contact

  def organization_name
    self.organization.name
  end

end