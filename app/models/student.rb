class Student < ActiveRecord::Base
  has_many :placements, dependent: :destroy
  has_many :incidents, dependent: :destroy
  #scope :active_students => {where(active: true)}
  #scope :red, -> { where(color: 'red') }

  def self.active_students
    where(active: true)
  end

  # Getter for full name
  def full_name
    "#{self.last_name}#{self.first_name ? (', ' + self.first_name) : ''}#{self.middle_name ? (' ' + self.middle_name) : ''}"
  end

end
