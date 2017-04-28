class Placement < ActiveRecord::Base
  belongs_to :student
  belongs_to :contact_assignment
  delegate :contact, :to => :contact_assignment
  has_many :route_stops, dependent: :destroy
  validate :start_date_in_contact_assignment
  validate :start_date_before_end_date

  def start_date_in_contact_assignment
    if start_date < contact_assignment.effective_start_date or start_date > contact_assignment.effective_end_date
      errors.add(:start_date, "Must be while this supervisor was/is active.")
    end
  end

  def start_date_before_end_date
    if start_date > end_date
      errors.add(:end_date, "must be later than Start Date")
    end
  end

  def self.grade_names
    {
        9 => "Freshmen",
        10 => "Sophomores",
        11 => "Juniors",
        12 => "Seniors"
    }
  end

  def paid
      self[:paid] ? "Paid" : "Unpaid"
  end

  def organization_id
    if contact_assignment
      contact_assignment.organization_id
    end
  end

  def organization_name
    contact_assignment.organization_name
  end

  def student_name
    student.full_name
  end

  def billing_address
    contact_assignment.organization.billing_address
  end

  def city
    contact_assignment.organization.city
  end

  def state
    contact_assignment.organization.state
  end

  def zip
    contact_assignment.organization.zip
  end

  def contact_start_date
    contact_assignment.effective_start_date
  end

  def contact_address
    contact_assignment.address
  end

  def contact_city
    contact_assignment.city
  end

  def contact_state
    contact_assignment.state
  end

  def contact_zip
    contact_assignment.zip
  end

  def sponsor_since
    contact_assignment.organization.sponsor_since
  end

  def contact_id
    contact_assignment.contact_id
  end

  def contact_name
    contact_assignment.contact.name
  end

  def title
    contact_assignment.title
  end

  def department
    contact_assignment.department
  end

  def email
    contact_assignment.business_email
  end

  def mobile
    contact_assignment.contact.personal_mobile
  end

  def office_phone
    contact_assignment.office_phone
  end

  def fax
    contact_assignment.fax
  end

  def org_contact_student
    self.organization_name + ' (' + self.contact_name + ')' + ' - ' + self.student_name
  end

  def replace_supervisor(placement_params)
    # If the start date is the same as the existing start date, just update the supervisor
    date_param = placement_params["start_date"]
    if placement_params["start_date"].include? 'Sept'
      date_param = placement_params["start_date"].sub! 'Sept', 'Sep'
    end
    new_start_date = DateTime.strptime(date_param, '%d-%b-%Y')

    if new_start_date <= self.start_date
      self.update(:contact_assignment_id => placement_params['contact_assignment_id'])
    else
      new_placement = self.dup
      new_placement.start_date = new_start_date
      new_placement.contact_assignment_id = placement_params['contact_assignment_id']
      retval = new_placement.save
      if retval == false
        full_error_msg = ''
        new_placement.errors.full_messages.each_with_index do |msg, key|
          if key > 0
            full_error_msg += ', '
          end
          full_error_msg += msg
        end
        raise Exception.new(full_error_msg)
      else
        self.update(:end_date => new_start_date - 1)
      end
    end
  end

  def self.current_placements(effective_date)
    where("start_date <= ? and end_date >= ?", effective_date, effective_date)
  end

  def self.attendance(route_date, grade_level)
    joins(contact_assignment: :organization).joins(:student).joins(route_stops: :van_route).includes(:student)
        .includes(route_stops: :van_route).where("van_routes.route_date = ? and placements.student_gradelevel = ?",
                                    route_date , grade_level).order("placements.student_gradelevel")
  end

  def self.search(filtering_id=-1,query_type=-1,order_by="")
    if query_type == 0
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .includes(:student).where("student_id = ?", filtering_id).order("placements.student_gradelevel desc, placements.start_date desc")
    elsif query_type == 1
      default_order = "placements.start_date desc"
      if order_by.to_s.empty?
        order_by = default_order
      end
      order_by = order_by + ", students.last_name"
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .includes(:student).where("contact_assignments.organization_id = ?", filtering_id).order(order_by)
    elsif query_type == 2
      joins(contact_assignment: [:organization, :contact]).includes(contact_assignment: [:organization, :contact])
          .includes(:student).where("contact_assignments.contact_id = ?", filtering_id).order("placements.start_date desc, students.last_name")
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

