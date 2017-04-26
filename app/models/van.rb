class Van < ActiveRecord::Base
  has_many :van_routes

  def update_out_of_service(active)
    self.update({out_of_service: active})
  end
end
