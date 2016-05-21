class IncidentCategory < ActiveRecord::Base
  has_many :incidents
end
