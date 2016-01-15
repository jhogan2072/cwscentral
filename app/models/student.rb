class Student < ActiveRecord::Base
  has_many :work_assignments, dependent: :destroy

  # Getter
  def full_name
    "#{self.last_name}#{self.first_name ? (', ' + self.first_name) : ''}#{self.middle_name ? (' ' + self.middle_name) : ''}"
  end

end
