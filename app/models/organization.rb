class Organization < ActiveRecord::Base
  has_many :contact_assignments, dependent: :destroy
  has_many :contacts, through: :contact_assignments
  has_many :route_stops

  def name_and_address
    name + " (" + billing_address + ", " + city + ", " + state + ")"
  end
end
