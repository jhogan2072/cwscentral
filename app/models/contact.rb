class Contact < ActiveRecord::Base
  belongs_to :organization
  has_many :work_assignments
end
