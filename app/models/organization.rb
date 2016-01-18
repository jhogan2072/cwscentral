class Organization < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
  has_many :route_stops

  def name_and_address
    name + " (" + billing_address + ", " + city + ", " + state + ")"
  end
end
