class Contact < ActiveRecord::Base
  belongs_to :organization
  has_many :placements
  has_many :incidents

  def organization_name
    self.organization.name
  end

  def name
    if self.first_name.nil? then
      self.last_name.nil? ? '' : self.last_name
    else
      self.last_name.nil? ? self.first_name : self.first_name + ' ' + self.last_name
    end
  end

end
