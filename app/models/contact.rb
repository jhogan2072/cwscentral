class Contact < ActiveRecord::Base
  belongs_to :organization
  has_many :placements

  def organization_name
    self.organization.name
  end

end
