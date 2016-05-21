class Incident < ActiveRecord::Base
  belongs_to :student
  belongs_to :contact
  belongs_to :incident_category

  def organization_id
    contact.organization_id
  end

  def organization_name
    contact.organization.name
  end

  def student_name
    student.full_name
  end

  def contact_name
    contact.name
  end

  def self.search(filtering_id=-1,query_type=-1)
    if query_type == 0
      joins(contact: :organization).includes(contact: :organization).where("student_id = ?", filtering_id)
    elsif query_type == 1
      joins(contact: :organization).includes(contact: :organization).where("contacts.organization_id = ?", filtering_id)
    elsif query_type == 2
      joins(contact: :organization).includes(contact: :organization).where("incidents.contact_id = ?", filtering_id)
    end
  end


end
