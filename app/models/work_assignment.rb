class WorkAssignment < ActiveRecord::Base
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

  def self.search(student_id=-1,organization_id=-1)
    if student_id != -1
      joins(contact: :organization).includes(contact: :organization).where("student_id = ?", student_id)
    else
      joins(contact: :student).includes(contact: :student).where("organization_id = ?", organization_id)
    end
  end

end

