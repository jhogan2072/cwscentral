class ContactStaging < ActiveRecord::Base
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
      myrecord = row.to_hash

      if ContactAssignment.joins(:contact)
             .where("contacts.first_name = ? and contacts.last_name = ?", myrecord['first_name'], myrecord['last_name'])
             .where("contact_assignments.effective_end_date = '31-dec-9999'")
             .count > 0
        myrecord['duplicate'] = true
      else
        myrecord['duplicate'] = false
      end
      ContactStaging.create! myrecord
    end
    end
end
