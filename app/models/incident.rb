class Incident < ActiveRecord::Base
  belongs_to :student
  belongs_to :contact_assignment
  belongs_to :incident_category
  validate :date_must_match_contact_assignment

  def date_must_match_contact_assignment
    if incident_date < contact_assignment.effective_start_date or incident_date > contact_assignment.effective_end_date
      errors.add(:incident_date, "must be while this supervisor was active.")
    end
  end

  def organization_id
    contact_assignment.organization_id
  end

  def organization_name
    contact_assignment.organization.name
  end

  def student_name
    student.full_name
  end

  def contact_name
    contact_assignment.contact.name
  end

  def category
    incident_category.category
  end

  def self.search(filtering_id=-1,query_type=-1)
    if query_type == 0
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .joins(:incident_category).includes(:incident_category).where("student_id = ?", filtering_id)
    elsif query_type == 1
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .where("contact_assignments.organization_id = ?", filtering_id)
    elsif query_type == 2
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .where("contact_assignments.contact_id = ?", filtering_id)
    end
  end


end
