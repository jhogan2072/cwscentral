class MergesController < ApplicationController
  autocomplete :organization, :name

  def org_merge
    org_1 = params["org_1_id"]
    org_2 = params["org_2_id"]
    if org_1.to_s.empty? || org_2.to_s.empty?
      flash[:error] = 'Please select both a merge from and a merge to organization.'
      redirect_to merge_organizations_merges_url
    else
      begin
        Organization.merge_organizations(org_1, org_2)
        flash[:notice] = 'Organizations merged.'
      rescue Exception => e
        flash[:error] = 'There was an error merging organizations: ' + "#{e.message}"
      end
      redirect_to merge_organizations_merges_url
    end
  end

  def merge_contacts
  end

  def merge_organizations
  end
end
