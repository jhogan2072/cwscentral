class Organization < ActiveRecord::Base
  has_many :contact_assignments, dependent: :destroy
  has_many :contacts, through: :contact_assignments
  has_many :route_stops

  def self.current_organizations(effective_date)
    joins(:contact_assignments)
        .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date",
               effective_date.nil? ? DateTime.now : effective_date).distinct.order("organizations.name")
  end
  def self.current_placements(effective_date)
    where("start_date <= ? and end_date >= ?", effective_date, effective_date)
  end

  def self.merge_organizations(org_1_id, org_2_id)
    org1 = find(org_1_id)
    org2 = find(org_2_id)
    if org1.nil? || org2.nil?
      raise Exception.new('One or both of the organizations were not recognized')
    end

    begin
      org2.contact_assignments.each do |ca|
        new_ca = org1.contact_assignments.new(ca.attributes)
        ca.placements.each do |placement|
          new_ca.placements.new(placement.attributes)
          placement.delete
        end
        ca.delete
        new_ca.save
      end
      org2.delete
    rescue => e
        raise Exception.new("#{e.message}")
    end
  end

  def name_and_address
    name + ' (' + billing_address + ', ' + city + ', ' + state + ')'
  end
end
