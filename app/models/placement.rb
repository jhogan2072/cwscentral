class Placement < ActiveRecord::Base
  belongs_to :student
  belongs_to :contact

  def paid
      self[:paid] ? "Paid" : "Unpaid"
  end

  def organization_id
    contact.organization_id
  end

  def organization_name
    contact.organization.name
  end

  def student_name
    student.full_name
  end

  def billing_address
    contact.organization.billing_address
  end

  def city
    contact.organization.city
  end

  def state
    contact.organization.state
  end

  def zip
    contact.organization.zip
  end

  def sponsor_since
    contact.organization.sponsor_since
  end

  def org_sugarcrm_id
    contact.organization.sugarcrm_id
  end

  def contact_name
    contact.name
  end

  def title
    contact.title
  end

  def department
    contact.department
  end

  def email
    contact.email
  end

  def mobile
    contact.mobile
  end

  def office_phone
    contact.office_phone
  end

  def fax
    contact.fax
  end

  def self.search(filtering_id=-1,query_type=-1)
    if query_type == 0
      joins(contact: :organization).includes(contact: :organization).where("student_id = ?", filtering_id)
    elsif query_type == 1
      joins(contact: :organization).includes(contact: :organization).where("contacts.organization_id = ?", filtering_id)
    elsif query_type == 2
      joins(contact: :organization).includes(contact: :organization).where("placements.contact_id = ?", filtering_id)
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |placement|
        csv << placement.attributes.values_at(*column_names)
      end
    end
  end
end

