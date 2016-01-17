class Organization < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
  has_many :route_stops
end
