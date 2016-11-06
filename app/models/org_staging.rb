class OrgStaging < ActiveRecord::Base
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
      myrecord = row.to_hash
      if Organization.where(name: myrecord['name']).count > 0
        myrecord['duplicate'] = true
      else
        myrecord['duplicate'] = false
      end
      OrgStaging.create! myrecord
    end
  end
end
