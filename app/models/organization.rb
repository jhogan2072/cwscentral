class Organization < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
end
