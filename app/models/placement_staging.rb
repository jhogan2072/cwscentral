class PlacementStaging < ActiveRecord::Base
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
      myrecord = row.to_hash

      if Placement.joins(contact_assignment: [:organization, :contact]).joins(:student)
             .where("students.last_name = ? and students.first_name = ? and contacts.first_name = ? and contacts.last_name = ? and organizations.name = ? and placements.student_gradelevel = ?",
                    myrecord['student_last_name'], myrecord['student_first_name'], myrecord['contact_first_name'], myrecord['contact_last_name'],
                    myrecord['organization_name'], myrecord['student_gradelevel']).count > 0
        myrecord['duplicate'] = true
      else
        myrecord['duplicate'] = false
      end
      PlacementStaging.create! myrecord
    end
  end
end
