class Student < ActiveRecord::Base
  has_many :placements, dependent: :destroy
  has_many :incidents, dependent: :destroy
  #scope :active_students => {where(active: true)}
  #scope :red, -> { where(color: 'red') }

  def self.active_students
    where(active: true)
  end

  def self.feedback_report(start_date, end_date)
    unless start_date.nil? or end_date.nil?
      joins(placements: { contact_assignment: :organization })
      .joins(placements: { contact_assignment: :contact })
      .joins(:incidents)
      .includes(placements: { contact_assignment: :organization })
      .includes(placements: { contact_assignment: :contact })
      .includes(:incidents)
      .where("placements.end_date >= ? and placements.start_date <= ? and incidents.incident_date >= ? and incidents.incident_date <= ?",
         start_date , end_date, start_date, end_date)
      .order("organizations.name, students.last_name")
    end
  end

  # Getter for full name
  def full_name
    "#{self.last_name}#{self.first_name ? (', ' + self.first_name) : ''}#{self.middle_name ? (' ' + self.middle_name) : ''}"
  end

end
