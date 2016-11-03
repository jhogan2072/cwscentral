class StudentsStaging < ActiveRecord::Base

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
      myrecord = row.to_hash
      if Student.where(first_name: myrecord['first_name']).where(last_name: myrecord['last_name']).count > 0
        myrecord['duplicate'] = true
      else
        myrecord['duplicate'] = false
      end
      StudentsStaging.create! myrecord
    end
  end

end
