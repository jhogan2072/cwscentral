class RouteStop < ActiveRecord::Base
  belongs_to :van_route
  belongs_to :placement
  validates :placement_id, presence: true
  validates :stop_order, presence: true
  after_validation :validate_placement

  default_scope { order('stop_order') }

  def placement_description
    placement.nil? ? nil : placement.org_contact_student
  end

  protected

  def validate_placement
    if errors[:placement_id].present?
      errors[:placement_id].each { |message| errors.add :placement_description, message }
    end
  end
end
